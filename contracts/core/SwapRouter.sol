// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "../interfaces/ISwapRouter.sol";
import "../interfaces/IUniswapV2Router.sol";
import "./DynamicFeeManager.sol";
import "./TreasuryManager.sol";
import "./PriceAggregator.sol";

/**
 * @title SwapRouter
 * @notice Main swap router aggregating liquidity from 15+ DEXs
 */
contract SwapRouter is ISwapRouter, Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    DynamicFeeManager public feeManager;
    TreasuryManager public treasuryManager;
    PriceAggregator public priceAggregator;

    // Supported DEXs
    mapping(address => bool) public supportedDexs;
    address[] public dexList;

    // Slippage protection
    uint256 public constant MAX_SLIPPAGE = 1000; // 10%
    uint256 public constant SLIPPAGE_DENOMINATOR = 10000;

    event DexAdded(address indexed dex);
    event DexRemoved(address indexed dex);
    event SlippageExceeded(address indexed user, uint256 expected, uint256 actual);

    constructor(address _feeManager, address _treasuryManager, address _priceAggregator) Ownable(msg.sender) {
        feeManager = DynamicFeeManager(_feeManager);
        treasuryManager = TreasuryManager(_treasuryManager);
        priceAggregator = PriceAggregator(_priceAggregator);
    }

    /**
     * @notice Execute a swap with optimal routing
     */
    function executeSwap(SwapParams calldata params)
        external
        payable
        override
        nonReentrant
        whenNotPaused
        returns (uint256 amountOut)
    {
        require(params.deadline >= block.timestamp, "Transaction expired");
        require(params.amountIn > 0, "Invalid amount");
        require(params.recipient != address(0), "Invalid recipient");
        require(params.tokenIn != params.tokenOut, "Same token swap");

        // Get best route from price aggregator
        (uint256 expectedOut, address bestDex) =
            priceAggregator.getBestPrice(params.tokenIn, params.tokenOut, params.amountIn);

        require(expectedOut >= params.amountOutMin, "Insufficient output amount");
        require(bestDex != address(0), "No valid DEX found");

        // Calculate and collect fee
        uint256 fee = feeManager.calculateFee(msg.sender, params.amountIn, expectedOut);
        uint256 amountInAfterFee = params.amountIn - fee;

        // Transfer tokens from user
        if (params.tokenIn == address(0)) {
            require(msg.value >= params.amountIn, "Insufficient ETH");
            if (fee > 0) {
                treasuryManager.collectFee{value: fee}(address(0), fee);
            }
        } else {
            IERC20(params.tokenIn).safeTransferFrom(msg.sender, address(this), params.amountIn);
            if (fee > 0) {
                IERC20(params.tokenIn).safeApprove(address(treasuryManager), fee);
                treasuryManager.collectFee(params.tokenIn, fee);
                IERC20(params.tokenIn).safeApprove(address(treasuryManager), 0);
            }
        }

        // Execute swap on best DEX
        amountOut = _executeSwapOnDex(bestDex, params.tokenIn, params.tokenOut, amountInAfterFee, params.recipient);

        // Verify slippage
        uint256 slippage = expectedOut > amountOut ? ((expectedOut - amountOut) * SLIPPAGE_DENOMINATOR) / expectedOut : 0;
        require(slippage <= MAX_SLIPPAGE, "Slippage too high");

        emit SwapExecuted(
            msg.sender,
            params.tokenIn,
            params.tokenOut,
            params.amountIn,
            amountOut,
            fee,
            keccak256(abi.encodePacked(bestDex, params.tokenIn, params.tokenOut))
        );
    }

    /**
     * @notice Execute multi-hop swap with custom route
     */
    function executeMultiHopSwap(SwapParams calldata params, RouteStep[] calldata route)
        external
        payable
        override
        nonReentrant
        whenNotPaused
        returns (uint256 amountOut)
    {
        require(params.deadline >= block.timestamp, "Transaction expired");
        require(route.length > 0 && route.length <= 4, "Invalid route length");
        require(params.recipient != address(0), "Invalid recipient");

        uint256 currentAmount = params.amountIn;

        // Validate route
        uint256 totalPercentage = 0;
        for (uint256 i = 0; i < route.length; i++) {
            require(supportedDexs[route[i].dex], "DEX not supported in route");
            require(route[i].percentage > 0 && route[i].percentage <= 100, "Invalid percentage");
            totalPercentage += route[i].percentage;
        }
        require(totalPercentage == 100, "Route percentages must sum to 100");

        // Calculate and collect fee
        uint256 fee = feeManager.calculateFee(msg.sender, params.amountIn, 0);
        currentAmount -= fee;

        // Transfer initial tokens
        if (params.tokenIn == address(0)) {
            require(msg.value >= params.amountIn, "Insufficient ETH");
            if (fee > 0) {
                treasuryManager.collectFee{value: fee}(address(0), fee);
            }
        } else {
            IERC20(params.tokenIn).safeTransferFrom(msg.sender, address(this), params.amountIn);
            if (fee > 0) {
                IERC20(params.tokenIn).safeApprove(address(treasuryManager), fee);
                treasuryManager.collectFee(params.tokenIn, fee);
                IERC20(params.tokenIn).safeApprove(address(treasuryManager), 0);
            }
        }

        // Execute each hop
        for (uint256 i = 0; i < route.length; i++) {
            RouteStep memory step = route[i];
            uint256 swapAmount = (currentAmount * step.percentage) / 100;
            require(swapAmount > 0, "Swap amount too small");

            currentAmount = _executeSwapOnDex(step.dex, step.tokenIn, step.tokenOut, swapAmount, address(this));
        }

        // Transfer final amount to recipient
        amountOut = currentAmount;
        require(amountOut >= params.amountOutMin, "Insufficient output amount");

        if (params.tokenOut == address(0)) {
            (bool success,) = params.recipient.call{value: amountOut}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(params.tokenOut).safeTransfer(params.recipient, amountOut);
        }

        emit SwapExecuted(
            msg.sender,
            params.tokenIn,
            params.tokenOut,
            params.amountIn,
            amountOut,
            fee,
            keccak256(abi.encode(route))
        );
    }

    /**
     * @notice Get expected output amount for a swap
     */
    function getExpectedOutput(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        override
        returns (uint256)
    {
        (uint256 expectedOut,) = priceAggregator.getBestPrice(tokenIn, tokenOut, amountIn);
        return expectedOut;
    }

    /**
     * @notice Internal function to execute swap on a specific DEX
     */
    function _executeSwapOnDex(address dex, address tokenIn, address tokenOut, uint256 amountIn, address recipient)
        internal
        returns (uint256 amountOut)
    {
        require(supportedDexs[dex], "DEX not supported");
        require(recipient != address(0), "Invalid recipient");
        require(amountIn > 0, "Invalid amount");

        // Approve token spending - use SafeERC20 and reset approval after
        if (tokenIn != address(0)) {
            IERC20 token = IERC20(tokenIn);
            token.safeApprove(dex, 0); // Reset to 0 first
            token.safeApprove(dex, amountIn);
        }

        // Build path
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        // Execute swap on Uniswap V2 style router
        IUniswapV2Router router = IUniswapV2Router(dex);

        // Calculate minimum output (1% slippage tolerance)
        uint256 minOutput = (amountIn * 99) / 100;

        if (tokenIn == address(0)) {
            uint256[] memory amounts = router.swapExactETHForTokens{value: amountIn}(minOutput, path, recipient, block.timestamp);
            amountOut = amounts[amounts.length - 1];
        } else if (tokenOut == address(0)) {
            uint256[] memory amounts = router.swapExactTokensForETH(amountIn, minOutput, path, recipient, block.timestamp);
            amountOut = amounts[amounts.length - 1];
            
            // Reset approval after swap
            IERC20(tokenIn).safeApprove(dex, 0);
        } else {
            uint256[] memory amounts = router.swapExactTokensForTokens(amountIn, minOutput, path, recipient, block.timestamp);
            amountOut = amounts[amounts.length - 1];
            
            // Reset approval after swap
            IERC20(tokenIn).safeApprove(dex, 0);
        }
        
        require(amountOut > 0, "Swap failed - zero output");
    }

    /**
     * @notice Add a supported DEX
     */
    function addDex(address dex) external onlyOwner {
        require(dex != address(0), "Invalid DEX address");
        require(!supportedDexs[dex], "DEX already supported");

        supportedDexs[dex] = true;
        dexList.push(dex);

        emit DexAdded(dex);
    }

    /**
     * @notice Remove a supported DEX
     */
    function removeDex(address dex) external onlyOwner {
        require(supportedDexs[dex], "DEX not supported");

        supportedDexs[dex] = false;

        // Remove from list
        for (uint256 i = 0; i < dexList.length; i++) {
            if (dexList[i] == dex) {
                dexList[i] = dexList[dexList.length - 1];
                dexList.pop();
                break;
            }
        }

        emit DexRemoved(dex);
    }

    /**
     * @notice Pause contract
     */
    function pause() external override onlyOwner {
        _pause();
        emit EmergencyPause(true);
    }

    /**
     * @notice Unpause contract
     */
    function unpause() external override onlyOwner {
        _unpause();
        emit EmergencyPause(false);
    }

    /**
     * @notice Check if contract is paused
     */
    function isPaused() external view override returns (bool) {
        return paused();
    }

    /**
     * @notice Get list of supported DEXs
     */
    function getSupportedDexs() external view returns (address[] memory) {
        return dexList;
    }

    receive() external payable {}
}
