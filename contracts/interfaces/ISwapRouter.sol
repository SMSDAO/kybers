// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ISwapRouter
 * @notice Interface for the main swap router contract
 */
interface ISwapRouter {
    struct SwapParams {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 amountOutMin;
        address recipient;
        uint256 deadline;
        bytes routeData;
    }

    struct RouteStep {
        address dex;
        address tokenIn;
        address tokenOut;
        uint256 percentage;
        bytes data;
    }

    event SwapExecuted(
        address indexed user,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        uint256 fee,
        bytes32 routeHash
    );

    event EmergencyPause(bool paused);

    function executeSwap(SwapParams calldata params) external payable returns (uint256 amountOut);

    function executeMultiHopSwap(SwapParams calldata params, RouteStep[] calldata route)
        external
        payable
        returns (uint256 amountOut);

    function getExpectedOutput(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (uint256 amountOut);

    function pause() external;

    function unpause() external;

    function isPaused() external view returns (bool);
}
