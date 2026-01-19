// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title PartnerAPI
 * @notice Manages partner fee-sharing and referral system
 */
contract PartnerAPI is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Partner {
        address wallet;
        uint256 feeShareBps; // Basis points (100 = 1%)
        uint256 totalEarned;
        uint256 totalVolume;
        bool isActive;
        uint256 registeredAt;
    }

    struct ReferralTier {
        uint256 minVolume;
        uint256 feeShareBps;
    }

    // Partner registry
    mapping(address => Partner) public partners;
    mapping(bytes32 => address) public referralCodes;
    
    // Referral tiers
    ReferralTier[] public referralTiers;

    // Fee tracking
    mapping(address => mapping(address => uint256)) public partnerFees; // partner => token => amount

    event PartnerRegistered(address indexed partner, bytes32 referralCode, uint256 feeShareBps);
    event PartnerUpdated(address indexed partner, uint256 newFeeShareBps);
    event PartnerDeactivated(address indexed partner);
    event ReferralUsed(address indexed user, address indexed partner, uint256 volume);
    event FeesDistributed(address indexed partner, address indexed token, uint256 amount);
    event TierAdded(uint256 minVolume, uint256 feeShareBps);

    constructor() Ownable(msg.sender) {
        // Initialize default referral tiers
        referralTiers.push(ReferralTier({minVolume: 0, feeShareBps: 10})); // 0.1% for new partners
        referralTiers.push(ReferralTier({minVolume: 100000 ether, feeShareBps: 20})); // 0.2% for 100k volume
        referralTiers.push(ReferralTier({minVolume: 1000000 ether, feeShareBps: 30})); // 0.3% for 1M volume
        referralTiers.push(ReferralTier({minVolume: 10000000 ether, feeShareBps: 50})); // 0.5% for 10M volume
    }

    /**
     * @notice Register a new partner
     */
    function registerPartner(address wallet, bytes32 referralCode, uint256 feeShareBps) external onlyOwner {
        require(wallet != address(0), "Invalid wallet");
        require(partners[wallet].wallet == address(0), "Partner already exists");
        require(referralCodes[referralCode] == address(0), "Referral code taken");
        require(feeShareBps <= 1000, "Fee share too high"); // Max 10%

        partners[wallet] = Partner({
            wallet: wallet,
            feeShareBps: feeShareBps,
            totalEarned: 0,
            totalVolume: 0,
            isActive: true,
            registeredAt: block.timestamp
        });

        referralCodes[referralCode] = wallet;

        emit PartnerRegistered(wallet, referralCode, feeShareBps);
    }

    /**
     * @notice Update partner fee share
     */
    function updatePartnerFeeShare(address wallet, uint256 newFeeShareBps) external onlyOwner {
        require(partners[wallet].isActive, "Partner not active");
        require(newFeeShareBps <= 1000, "Fee share too high");

        partners[wallet].feeShareBps = newFeeShareBps;

        emit PartnerUpdated(wallet, newFeeShareBps);
    }

    /**
     * @notice Deactivate a partner
     */
    function deactivatePartner(address wallet) external onlyOwner {
        require(partners[wallet].isActive, "Partner not active");
        partners[wallet].isActive = false;

        emit PartnerDeactivated(wallet);
    }

    /**
     * @notice Record referral usage and update volume
     */
    function recordReferral(address user, bytes32 referralCode, uint256 volume) external {
        address partner = referralCodes[referralCode];
        require(partner != address(0), "Invalid referral code");
        require(partners[partner].isActive, "Partner not active");

        partners[partner].totalVolume += volume;

        // Check if partner should be upgraded to higher tier
        _updatePartnerTier(partner);

        emit ReferralUsed(user, partner, volume);
    }

    /**
     * @notice Calculate partner fee share for a swap
     */
    function calculatePartnerFee(address partner, uint256 totalFee) public view returns (uint256) {
        if (!partners[partner].isActive) {
            return 0;
        }

        return (totalFee * partners[partner].feeShareBps) / 10000;
    }

    /**
     * @notice Distribute fees to partner
     */
    function distributeFees(address partner, address token, uint256 amount) external nonReentrant {
        require(partners[partner].isActive, "Partner not active");
        require(amount > 0, "Invalid amount");

        partnerFees[partner][token] += amount;
        partners[partner].totalEarned += amount;

        if (token == address(0)) {
            require(address(this).balance >= amount, "Insufficient ETH");
            (bool success,) = partner.call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(partner, amount);
        }

        emit FeesDistributed(partner, token, amount);
    }

    /**
     * @notice Update partner tier based on volume
     */
    function _updatePartnerTier(address partner) internal {
        uint256 volume = partners[partner].totalVolume;
        uint256 currentTier = 0;

        for (uint256 i = referralTiers.length; i > 0; i--) {
            if (volume >= referralTiers[i - 1].minVolume) {
                currentTier = i - 1;
                break;
            }
        }

        uint256 newFeeShare = referralTiers[currentTier].feeShareBps;
        if (newFeeShare > partners[partner].feeShareBps) {
            partners[partner].feeShareBps = newFeeShare;
            emit PartnerUpdated(partner, newFeeShare);
        }
    }

    /**
     * @notice Add a new referral tier
     */
    function addReferralTier(uint256 minVolume, uint256 feeShareBps) external onlyOwner {
        require(feeShareBps <= 1000, "Fee share too high");
        referralTiers.push(ReferralTier({minVolume: minVolume, feeShareBps: feeShareBps}));

        emit TierAdded(minVolume, feeShareBps);
    }

    /**
     * @notice Get partner info
     */
    function getPartnerInfo(address wallet)
        external
        view
        returns (uint256 feeShareBps, uint256 totalEarned, uint256 totalVolume, bool isActive)
    {
        Partner memory p = partners[wallet];
        return (p.feeShareBps, p.totalEarned, p.totalVolume, p.isActive);
    }

    /**
     * @notice Get partner by referral code
     */
    function getPartnerByCode(bytes32 code) external view returns (address) {
        return referralCodes[code];
    }

    /**
     * @notice Get all referral tiers
     */
    function getReferralTiers() external view returns (ReferralTier[] memory) {
        return referralTiers;
    }

    /**
     * @notice Receive ETH
     */
    receive() external payable {}
}
