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

    address public constant TREASURY_ADDRESS = 0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e; // gxqstudio.eth
    uint256 public constant AUTO_FORWARD_THRESHOLD = 1 ether;

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

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Collect fees from a swap
     */
    function collectFee(address token, uint256 amount) external nonReentrant {
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
            (bool success,) = TREASURY_ADDRESS.call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(TREASURY_ADDRESS, amount);
        }

        emit FeesForwarded(token, amount, TREASURY_ADDRESS);
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
     * @notice Receive ETH
     */
    receive() external payable {
        tokenBalances[address(0)].accumulated += msg.value;
        emit FeeCollected(address(0), msg.value, msg.sender);
    }
}
