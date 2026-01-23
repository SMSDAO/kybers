// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TreasuryManager
 * @notice Manages fee collection and auto-forwards to gxqstudio.eth
 */
contract TreasuryManager is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    address payable public treasuryAddress;
    uint256 public constant AUTO_FORWARD_THRESHOLD = 1 ether;

    // Authorized callers (e.g., SwapRouter)
    mapping(address => bool) public authorizedCallers;

    struct TokenBalance {
        uint256 accumulated;
        uint256 forwarded;
        uint256 lastForwardTime;
    }

    mapping(address => TokenBalance) public tokenBalances;
    mapping(uint256 => mapping(address => uint256)) public chainBalances; // chainId => token => balance

    event FeeCollected(address indexed token, uint256 amount, address indexed from);
    event FeesForwarded(address indexed token, uint256 amount, address indexed to);
    event EmergencyWithdraw(address indexed token, uint256 amount, address indexed to);
    event ThresholdReached(address indexed token, uint256 amount);
    event TreasuryAddressUpdated(address indexed oldAddress, address indexed newAddress);
    event AuthorizedCallerUpdated(address indexed caller, bool status);

    constructor(address payable _treasuryAddress) Ownable(msg.sender) {
        require(_treasuryAddress != address(0), "Invalid treasury address");
        treasuryAddress = _treasuryAddress; // gxqstudio.eth: 0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e
    }

    /**
     * @notice Update treasury address (only owner, for upgradability)
     */
    function updateTreasuryAddress(address payable newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid treasury address");
        address oldAddress = treasuryAddress;
        treasuryAddress = newTreasury;
        emit TreasuryAddressUpdated(oldAddress, newTreasury);
    }

    /**
     * @notice Set authorized caller status
     */
    function setAuthorizedCaller(address caller, bool status) external onlyOwner {
        require(caller != address(0), "Invalid caller address");
        authorizedCallers[caller] = status;
        emit AuthorizedCallerUpdated(caller, status);
    }

    /**
     * @notice Collect fees from a swap (only authorized callers)
     */
    function collectFee(address token, uint256 amount) external payable nonReentrant {
        require(authorizedCallers[msg.sender], "Caller not authorized");
        require(amount > 0, "Amount must be greater than 0");

        if (token == address(0)) {
            require(msg.value >= amount, "Insufficient ETH sent");
            tokenBalances[token].accumulated += amount;
        } else {
            IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
            tokenBalances[token].accumulated += amount;
        }

        emit FeeCollected(token, amount, msg.sender);

        // Auto-forward if threshold reached
        if (shouldAutoForward(token)) {
            _forwardFees(token);
        }
    }

    /**
     * @notice Check if token balance should be auto-forwarded
     */
    function shouldAutoForward(address token) public view returns (bool) {
        uint256 balance = tokenBalances[token].accumulated;

        if (token == address(0)) {
            return balance >= AUTO_FORWARD_THRESHOLD;
        } else {
            // For ERC20 tokens, convert to ETH equivalent (simplified)
            return balance >= AUTO_FORWARD_THRESHOLD;
        }
    }

    /**
     * @notice Forward accumulated fees to treasury
     */
    function forwardFees(address token) external nonReentrant {
        _forwardFees(token);
    }

    /**
     * @notice Internal function to forward fees
     */
    function _forwardFees(address token) internal {
        uint256 amount = tokenBalances[token].accumulated;
        require(amount > 0, "No fees to forward");

        tokenBalances[token].accumulated = 0;
        tokenBalances[token].forwarded += amount;
        tokenBalances[token].lastForwardTime = block.timestamp;

        if (token == address(0)) {
            (bool success,) = treasuryAddress.call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(treasuryAddress, amount);
        }

        emit FeesForwarded(token, amount, treasuryAddress);
    }

    /**
     * @notice Batch forward fees for multiple tokens
     */
    function forwardMultipleTokens(address[] calldata tokens) external nonReentrant {
        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokenBalances[tokens[i]].accumulated > 0) {
                _forwardFees(tokens[i]);
            }
        }
    }

    /**
     * @notice Emergency withdrawal function (only owner)
     */
    function emergencyWithdraw(address token, uint256 amount, address to) external onlyOwner nonReentrant {
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be greater than 0");

        if (token == address(0)) {
            require(address(this).balance >= amount, "Insufficient ETH balance");
            (bool success,) = to.call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(to, amount);
        }

        emit EmergencyWithdraw(token, amount, to);
    }

    /**
     * @notice Get token balance info
     */
    function getTokenBalance(address token)
        external
        view
        returns (uint256 accumulated, uint256 forwarded, uint256 lastForwardTime)
    {
        TokenBalance memory balance = tokenBalances[token];
        return (balance.accumulated, balance.forwarded, balance.lastForwardTime);
    }

    /**
     * @notice Get total forwarded amount for all tokens
     */
    function getTotalForwarded(address token) external view returns (uint256) {
        return tokenBalances[token].forwarded;
    }

    /**
     * @notice Receive ETH - only from authorized callers
     */
    receive() external payable {
        require(authorizedCallers[msg.sender], "Caller not authorized");
        tokenBalances[address(0)].accumulated += msg.value;
        emit FeeCollected(address(0), msg.value, msg.sender);
    }
}
