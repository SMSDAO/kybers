// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IPriceAggregator
 * @notice Interface for price aggregation across multiple DEXs
 */
interface IPriceAggregator {
    struct DexPrice {
        address dex;
        uint256 price;
        uint256 liquidity;
        uint256 gasEstimate;
    }

    struct BestRoute {
        address[] path;
        address[] dexes;
        uint256 expectedOutput;
        uint256 priceImpact;
        uint256 gasEstimate;
    }

    event PriceUpdate(address indexed tokenIn, address indexed tokenOut, uint256 bestPrice, address bestDex);

    function getBestPrice(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (uint256 bestPrice, address bestDex);

    function getAllPrices(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (DexPrice[] memory);

    function getBestRoute(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (BestRoute memory);

    function updatePriceCache(address tokenIn, address tokenOut) external;
}
