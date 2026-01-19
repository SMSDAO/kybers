// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title DynamicFeeManager
 * @notice Manages dynamic fee calculation with 0.05% base fee
 */
contract DynamicFeeManager is Ownable, ReentrancyGuard {
    uint256 public constant BASE_FEE = 5; // 0.05% = 5 basis points
    uint256 public constant MAX_FEE = 30; // 0.3% = 30 basis points
    uint256 public constant FEE_DENOMINATOR = 10000; // 100% = 10000 basis points

    struct FeeConfig {
        uint256 baseFee;
        uint256 congestionAdjustment;
        uint256 volatilityAdjustment;
        uint256 liquidityDiscountThreshold;
        uint256 volumeDiscountThreshold;
    }

    struct UserTier {
        uint256 volume;
        uint256 discount; // in basis points
        uint256 lastUpdate;
    }

    FeeConfig public feeConfig;
    mapping(address => UserTier) public userTiers;
    mapping(address => bool) public feeExemptAddresses;

    event FeeConfigUpdated(uint256 baseFee, uint256 congestionAdj, uint256 volatilityAdj);
    event UserTierUpdated(address indexed user, uint256 volume, uint256 discount);
    event FeeExemptionSet(address indexed account, bool exempt);
    event FeeCalculated(address indexed user, uint256 amount, uint256 fee);

    constructor() Ownable(msg.sender) {
        feeConfig = FeeConfig({
            baseFee: BASE_FEE,
            congestionAdjustment: 0,
            volatilityAdjustment: 0,
            liquidityDiscountThreshold: 1000000 ether,
            volumeDiscountThreshold: 100000 ether
        });
    }

    /**
     * @notice Calculate fee for a swap
     * @param user Address of the user
     * @param amount Amount being swapped
     * @param liquidityDepth Available liquidity in the pool
     * @return fee The calculated fee amount
     */
    function calculateFee(address user, uint256 amount, uint256 liquidityDepth)
        external
        view
        returns (uint256 fee)
    {
        if (feeExemptAddresses[user]) {
            return 0;
        }

        uint256 effectiveFee = feeConfig.baseFee;

        // Apply congestion adjustment
        effectiveFee += feeConfig.congestionAdjustment;

        // Apply volatility adjustment
        effectiveFee += feeConfig.volatilityAdjustment;

        // Apply liquidity discount
        if (liquidityDepth >= feeConfig.liquidityDiscountThreshold) {
            effectiveFee = effectiveFee > 1 ? effectiveFee - 1 : 0;
        }

        // Apply user tier discount
        UserTier memory tier = userTiers[user];
        if (tier.discount > 0) {
            effectiveFee = effectiveFee > tier.discount ? effectiveFee - tier.discount : 0;
        }

        // Apply volume discount
        if (amount >= feeConfig.volumeDiscountThreshold) {
            effectiveFee = effectiveFee > 1 ? effectiveFee - 1 : 0;
        }

        // Ensure fee doesn't exceed maximum
        if (effectiveFee > MAX_FEE) {
            effectiveFee = MAX_FEE;
        }

        fee = (amount * effectiveFee) / FEE_DENOMINATOR;
    }

    /**
     * @notice Update fee configuration
     */
    function updateFeeConfig(uint256 congestionAdj, uint256 volatilityAdj) external onlyOwner {
        require(BASE_FEE + congestionAdj + volatilityAdj <= MAX_FEE, "Fee exceeds maximum");

        feeConfig.congestionAdjustment = congestionAdj;
        feeConfig.volatilityAdjustment = volatilityAdj;

        emit FeeConfigUpdated(feeConfig.baseFee, congestionAdj, volatilityAdj);
    }

    /**
     * @notice Update user tier based on volume
     */
    function updateUserTier(address user, uint256 volume) external onlyOwner {
        uint256 discount = 0;

        if (volume >= 1000000 ether) {
            discount = 3; // 0.03% discount
        } else if (volume >= 500000 ether) {
            discount = 2; // 0.02% discount
        } else if (volume >= 100000 ether) {
            discount = 1; // 0.01% discount
        }

        userTiers[user] = UserTier({volume: volume, discount: discount, lastUpdate: block.timestamp});

        emit UserTierUpdated(user, volume, discount);
    }

    /**
     * @notice Set fee exemption for an address
     */
    function setFeeExemption(address account, bool exempt) external onlyOwner {
        feeExemptAddresses[account] = exempt;
        emit FeeExemptionSet(account, exempt);
    }

    /**
     * @notice Get current effective fee for a user
     */
    function getEffectiveFeeRate(address user, uint256 amount, uint256 liquidityDepth)
        external
        view
        returns (uint256)
    {
        if (feeExemptAddresses[user]) {
            return 0;
        }

        uint256 effectiveFee = feeConfig.baseFee + feeConfig.congestionAdjustment + feeConfig.volatilityAdjustment;

        if (liquidityDepth >= feeConfig.liquidityDiscountThreshold) {
            effectiveFee = effectiveFee > 1 ? effectiveFee - 1 : 0;
        }

        UserTier memory tier = userTiers[user];
        if (tier.discount > 0) {
            effectiveFee = effectiveFee > tier.discount ? effectiveFee - tier.discount : 0;
        }

        if (amount >= feeConfig.volumeDiscountThreshold) {
            effectiveFee = effectiveFee > 1 ? effectiveFee - 1 : 0;
        }

        return effectiveFee > MAX_FEE ? MAX_FEE : effectiveFee;
    }
}
