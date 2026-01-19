// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title MEVProtection
 * @notice Provides MEV protection mechanisms for swaps
 */
contract MEVProtection is Ownable, ReentrancyGuard {
    // Rate limiting
    mapping(address => uint256) public lastTxTimestamp;
    mapping(address => uint256) public txCountInBlock;
    uint256 public minTimeBetweenTx = 2; // seconds

    // Transaction size limits
    uint256 public maxTxSize = 100 ether;

    // Blacklisted addresses (known MEV bots)
    mapping(address => bool) public blacklistedBots;

    // Slippage tolerance
    uint256 public maxSlippageTolerance = 500; // 5%
    uint256 public constant SLIPPAGE_DENOMINATOR = 10000;

    event BotBlacklisted(address indexed bot);
    event BotWhitelisted(address indexed bot);
    event RateLimitExceeded(address indexed user);
    event MaxSizeExceeded(address indexed user, uint256 amount);
    event FrontrunDetected(address indexed user, uint256 blockNumber);

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Check if transaction is allowed
     */
    function checkTransaction(address user, uint256 amount, uint256 expectedOutput, uint256 actualOutput)
        external
        returns (bool)
    {
        // Check blacklist
        require(!blacklistedBots[user], "Address blacklisted");

        // Check rate limiting
        require(block.timestamp >= lastTxTimestamp[user] + minTimeBetweenTx, "Rate limit exceeded");

        // Check transaction size
        require(amount <= maxTxSize, "Transaction too large");

        // Check slippage
        if (expectedOutput > 0) {
            uint256 slippage = expectedOutput > actualOutput
                ? ((expectedOutput - actualOutput) * SLIPPAGE_DENOMINATOR) / expectedOutput
                : 0;
            require(slippage <= maxSlippageTolerance, "Slippage too high");
        }

        // Update rate limit tracking
        if (block.number == txCountInBlock[user]) {
            require(txCountInBlock[user] < 3, "Too many transactions in block");
        } else {
            txCountInBlock[user] = 0;
        }

        lastTxTimestamp[user] = block.timestamp;
        txCountInBlock[user]++;

        return true;
    }

    /**
     * @notice Detect potential sandwich attack
     */
    function detectSandwich(address user, uint256 priceImpact) external view returns (bool) {
        // If price impact is too high and there were recent transactions, possible sandwich
        if (priceImpact > 300) {
            // 3% impact
            return true;
        }
        return false;
    }

    /**
     * @notice Blacklist a bot address
     */
    function blacklistBot(address bot) external onlyOwner {
        blacklistedBots[bot] = true;
        emit BotBlacklisted(bot);
    }

    /**
     * @notice Whitelist a bot address
     */
    function whitelistBot(address bot) external onlyOwner {
        blacklistedBots[bot] = false;
        emit BotWhitelisted(bot);
    }

    /**
     * @notice Update rate limit parameters
     */
    function updateRateLimit(uint256 _minTimeBetweenTx) external onlyOwner {
        minTimeBetweenTx = _minTimeBetweenTx;
    }

    /**
     * @notice Update max transaction size
     */
    function updateMaxTxSize(uint256 _maxTxSize) external onlyOwner {
        maxTxSize = _maxTxSize;
    }

    /**
     * @notice Update max slippage tolerance
     */
    function updateMaxSlippage(uint256 _maxSlippage) external onlyOwner {
        require(_maxSlippage <= SLIPPAGE_DENOMINATOR, "Invalid slippage");
        maxSlippageTolerance = _maxSlippage;
    }

    /**
     * @notice Check if address is blacklisted
     */
    function isBlacklisted(address user) external view returns (bool) {
        return blacklistedBots[user];
    }

    /**
     * @notice Get time until next transaction allowed
     */
    function getTimeUntilNextTx(address user) external view returns (uint256) {
        uint256 nextAllowed = lastTxTimestamp[user] + minTimeBetweenTx;
        if (block.timestamp >= nextAllowed) {
            return 0;
        }
        return nextAllowed - block.timestamp;
    }
}
