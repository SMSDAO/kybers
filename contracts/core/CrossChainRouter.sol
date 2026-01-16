// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title CrossChainRouter
 * @notice Handles cross-chain swaps and bridging
 */
contract CrossChainRouter is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct ChainConfig {
        uint256 chainId;
        address router;
        address bridge;
        bool enabled;
        uint256 minAmount;
        uint256 maxAmount;
    }

    struct CrossChainSwap {
        uint256 srcChainId;
        uint256 dstChainId;
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 minAmountOut;
        address recipient;
        uint256 deadline;
        bytes bridgeData;
    }

    // Supported chains
    mapping(uint256 => ChainConfig) public chainConfigs;
    uint256[] public supportedChainIds;

    // Pending cross-chain swaps
    mapping(bytes32 => bool) public completedSwaps;

    event ChainAdded(uint256 indexed chainId, address router, address bridge);
    event ChainRemoved(uint256 indexed chainId);
    event CrossChainSwapInitiated(
        bytes32 indexed swapId,
        uint256 srcChainId,
        uint256 dstChainId,
        address indexed user,
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    );
    event CrossChainSwapCompleted(bytes32 indexed swapId, uint256 amountOut);
    event CrossChainSwapFailed(bytes32 indexed swapId, string reason);

    constructor() Ownable(msg.sender) {
        // Initialize with common chains
        _addChain(1, address(0), address(0), 0.01 ether, 1000 ether); // Ethereum Mainnet
        _addChain(8453, address(0), address(0), 0.001 ether, 1000 ether); // Base
        _addChain(7777777, address(0), address(0), 0.001 ether, 1000 ether); // Zora
        _addChain(42161, address(0), address(0), 0.001 ether, 1000 ether); // Arbitrum
        _addChain(10, address(0), address(0), 0.001 ether, 1000 ether); // Optimism
        _addChain(137, address(0), address(0), 0.1 ether, 10000 ether); // Polygon
        _addChain(56, address(0), address(0), 0.01 ether, 1000 ether); // BSC
    }

    /**
     * @notice Initiate a cross-chain swap
     */
    function initiateCrossChainSwap(CrossChainSwap calldata swap)
        external
        payable
        nonReentrant
        returns (bytes32 swapId)
    {
        require(swap.deadline >= block.timestamp, "Swap expired");
        require(chainConfigs[swap.dstChainId].enabled, "Destination chain not supported");
        require(swap.amountIn >= chainConfigs[swap.dstChainId].minAmount, "Amount too low");
        require(swap.amountIn <= chainConfigs[swap.dstChainId].maxAmount, "Amount too high");

        // Generate swap ID
        swapId = keccak256(
            abi.encodePacked(
                swap.srcChainId,
                swap.dstChainId,
                swap.tokenIn,
                swap.tokenOut,
                swap.amountIn,
                msg.sender,
                block.timestamp
            )
        );

        // Transfer tokens from user
        if (swap.tokenIn == address(0)) {
            require(msg.value >= swap.amountIn, "Insufficient ETH");
        } else {
            IERC20(swap.tokenIn).safeTransferFrom(msg.sender, address(this), swap.amountIn);
        }

        emit CrossChainSwapInitiated(
            swapId, swap.srcChainId, swap.dstChainId, msg.sender, swap.tokenIn, swap.tokenOut, swap.amountIn
        );

        return swapId;
    }

    /**
     * @notice Complete a cross-chain swap (called by relayer)
     */
    function completeCrossChainSwap(bytes32 swapId, address recipient, address token, uint256 amount)
        external
        onlyOwner
        nonReentrant
    {
        require(!completedSwaps[swapId], "Swap already completed");

        completedSwaps[swapId] = true;

        // Transfer tokens to recipient
        if (token == address(0)) {
            (bool success,) = recipient.call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit CrossChainSwapCompleted(swapId, amount);
    }

    /**
     * @notice Refund failed cross-chain swap
     */
    function refundFailedSwap(bytes32 swapId, address recipient, address token, uint256 amount, string calldata reason)
        external
        onlyOwner
        nonReentrant
    {
        require(!completedSwaps[swapId], "Swap already completed");

        completedSwaps[swapId] = true;

        // Refund tokens to user
        if (token == address(0)) {
            (bool success,) = recipient.call{value: amount}("");
            require(success, "ETH refund failed");
        } else {
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit CrossChainSwapFailed(swapId, reason);
    }

    /**
     * @notice Add a new chain configuration
     */
    function addChain(uint256 chainId, address router, address bridge, uint256 minAmount, uint256 maxAmount)
        external
        onlyOwner
    {
        _addChain(chainId, router, bridge, minAmount, maxAmount);
    }

    /**
     * @notice Internal function to add chain
     */
    function _addChain(uint256 chainId, address router, address bridge, uint256 minAmount, uint256 maxAmount)
        internal
    {
        require(chainConfigs[chainId].chainId == 0, "Chain already configured");

        chainConfigs[chainId] = ChainConfig({
            chainId: chainId,
            router: router,
            bridge: bridge,
            enabled: true,
            minAmount: minAmount,
            maxAmount: maxAmount
        });

        supportedChainIds.push(chainId);

        emit ChainAdded(chainId, router, bridge);
    }

    /**
     * @notice Update chain configuration
     */
    function updateChainConfig(
        uint256 chainId,
        address router,
        address bridge,
        bool enabled,
        uint256 minAmount,
        uint256 maxAmount
    ) external onlyOwner {
        require(chainConfigs[chainId].chainId != 0, "Chain not configured");

        ChainConfig storage config = chainConfigs[chainId];
        config.router = router;
        config.bridge = bridge;
        config.enabled = enabled;
        config.minAmount = minAmount;
        config.maxAmount = maxAmount;
    }

    /**
     * @notice Remove a chain
     */
    function removeChain(uint256 chainId) external onlyOwner {
        require(chainConfigs[chainId].chainId != 0, "Chain not configured");

        delete chainConfigs[chainId];

        // Remove from array
        for (uint256 i = 0; i < supportedChainIds.length; i++) {
            if (supportedChainIds[i] == chainId) {
                supportedChainIds[i] = supportedChainIds[supportedChainIds.length - 1];
                supportedChainIds.pop();
                break;
            }
        }

        emit ChainRemoved(chainId);
    }

    /**
     * @notice Get supported chain IDs
     */
    function getSupportedChains() external view returns (uint256[] memory) {
        return supportedChainIds;
    }

    /**
     * @notice Check if chain is supported
     */
    function isChainSupported(uint256 chainId) external view returns (bool) {
        return chainConfigs[chainId].enabled;
    }

    /**
     * @notice Emergency withdraw
     */
    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        if (token == address(0)) {
            (bool success,) = owner().call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).safeTransfer(owner(), amount);
        }
    }

    receive() external payable {}
}
