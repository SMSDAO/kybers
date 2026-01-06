// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IPriceAggregator.sol";
import "../interfaces/IUniswapV2Router.sol";

/**
 * @title PriceAggregator
 * @notice Aggregates prices from multiple DEXs to find best routes
 */
contract PriceAggregator is IPriceAggregator, Ownable {
    struct CachedPrice {
        uint256 price;
        uint256 timestamp;
        uint256 liquidity;
    }

    // Cache duration: 5 seconds
    uint256 public constant CACHE_DURATION = 5;

    // Registered DEXs
    address[] public dexes;
    mapping(address => bool) public isDexRegistered;

    // Price cache: tokenIn => tokenOut => CachedPrice
    mapping(address => mapping(address => CachedPrice)) public priceCache;

    // Gas estimates per DEX
    mapping(address => uint256) public dexGasEstimates;

    event DexRegistered(address indexed dex, uint256 gasEstimate);
    event DexUnregistered(address indexed dex);
    event PriceCacheUpdated(address indexed tokenIn, address indexed tokenOut, uint256 price);

    constructor() Ownable(msg.sender) {
        // Default gas estimates for common operations
        dexGasEstimates[address(0)] = 150000; // Default estimate
    }

    /**
     * @notice Get best price across all DEXs
     */
    function getBestPrice(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        override
        returns (uint256 bestPrice, address bestDex)
    {
        require(dexes.length > 0, "No DEXs registered");

        bestPrice = 0;
        bestDex = address(0);

        for (uint256 i = 0; i < dexes.length; i++) {
            try this.getPriceFromDex(dexes[i], tokenIn, tokenOut, amountIn) returns (uint256 price) {
                if (price > bestPrice) {
                    bestPrice = price;
                    bestDex = dexes[i];
                }
            } catch {
                // Skip failed DEX queries
                continue;
            }
        }

        require(bestPrice > 0, "No valid price found");
        emit PriceUpdate(tokenIn, tokenOut, bestPrice, bestDex);
    }

    /**
     * @notice Get prices from all DEXs
     */
    function getAllPrices(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        override
        returns (DexPrice[] memory)
    {
        DexPrice[] memory prices = new DexPrice[](dexes.length);

        for (uint256 i = 0; i < dexes.length; i++) {
            try this.getPriceFromDex(dexes[i], tokenIn, tokenOut, amountIn) returns (uint256 price) {
                prices[i] = DexPrice({
                    dex: dexes[i],
                    price: price,
                    liquidity: 0, // Simplified
                    gasEstimate: dexGasEstimates[dexes[i]]
                });
            } catch {
                prices[i] = DexPrice({dex: dexes[i], price: 0, liquidity: 0, gasEstimate: dexGasEstimates[dexes[i]]});
            }
        }

        return prices;
    }

    /**
     * @notice Get best route for a swap
     */
    function getBestRoute(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        override
        returns (BestRoute memory)
    {
        (uint256 bestPrice, address bestDex) = this.getBestPrice(tokenIn, tokenOut, amountIn);

        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        address[] memory dexPath = new address[](1);
        dexPath[0] = bestDex;

        // Calculate price impact (simplified)
        uint256 priceImpact = 0;
        if (amountIn > 0 && bestPrice > 0) {
            priceImpact = (amountIn * 100) / bestPrice;
        }

        return BestRoute({
            path: path,
            dexes: dexPath,
            expectedOutput: bestPrice,
            priceImpact: priceImpact,
            gasEstimate: dexGasEstimates[bestDex]
        });
    }

    /**
     * @notice Get price from a specific DEX
     */
    function getPriceFromDex(address dex, address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (uint256)
    {
        require(isDexRegistered[dex], "DEX not registered");

        // Check cache first
        CachedPrice memory cached = priceCache[tokenIn][tokenOut];
        if (cached.timestamp + CACHE_DURATION > block.timestamp && cached.price > 0) {
            return (cached.price * amountIn) / 1 ether;
        }

        // Query DEX
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        try IUniswapV2Router(dex).getAmountsOut(amountIn, path) returns (uint256[] memory amounts) {
            return amounts[amounts.length - 1];
        } catch {
            return 0;
        }
    }

    /**
     * @notice Update price cache manually
     */
    function updatePriceCache(address tokenIn, address tokenOut) external override {
        uint256 amountIn = 1 ether; // Standard amount for pricing

        for (uint256 i = 0; i < dexes.length; i++) {
            try this.getPriceFromDex(dexes[i], tokenIn, tokenOut, amountIn) returns (uint256 price) {
                if (price > 0) {
                    priceCache[tokenIn][tokenOut] =
                        CachedPrice({price: price, timestamp: block.timestamp, liquidity: 0});

                    emit PriceCacheUpdated(tokenIn, tokenOut, price);
                    break;
                }
            } catch {
                continue;
            }
        }
    }

    /**
     * @notice Register a new DEX
     */
    function registerDex(address dex, uint256 gasEstimate) external onlyOwner {
        require(dex != address(0), "Invalid DEX address");
        require(!isDexRegistered[dex], "DEX already registered");

        dexes.push(dex);
        isDexRegistered[dex] = true;
        dexGasEstimates[dex] = gasEstimate;

        emit DexRegistered(dex, gasEstimate);
    }

    /**
     * @notice Unregister a DEX
     */
    function unregisterDex(address dex) external onlyOwner {
        require(isDexRegistered[dex], "DEX not registered");

        isDexRegistered[dex] = false;

        for (uint256 i = 0; i < dexes.length; i++) {
            if (dexes[i] == dex) {
                dexes[i] = dexes[dexes.length - 1];
                dexes.pop();
                break;
            }
        }

        emit DexUnregistered(dex);
    }

    /**
     * @notice Update gas estimate for a DEX
     */
    function updateGasEstimate(address dex, uint256 gasEstimate) external onlyOwner {
        require(isDexRegistered[dex], "DEX not registered");
        dexGasEstimates[dex] = gasEstimate;
    }

    /**
     * @notice Get all registered DEXs
     */
    function getRegisteredDexes() external view returns (address[] memory) {
        return dexes;
    }

    /**
     * @notice Get number of registered DEXs
     */
    function getDexCount() external view returns (uint256) {
        return dexes.length;
    }
}
