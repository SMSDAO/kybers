# Kybers DEX - Smart Contract Documentation

## Overview

Kybers DEX is a complete production-ready advanced DEX infrastructure that aggregates liquidity from 15+ DEXs across 7 chains. The smart contract suite provides secure, gas-optimized swapping with dynamic fees and MEV protection.

## Core Contracts

### 1. SwapRouter.sol

**Purpose**: Main entry point for executing swaps across multiple DEXs.

**Key Features**:
- Aggregates liquidity from 15+ DEXs
- Smart order routing
- Multi-hop swap support
- Gas-optimized execution
- Slippage protection
- Emergency pause functionality

**Main Functions**:
- `executeSwap(SwapParams)` - Execute a single swap
- `executeMultiHopSwap(SwapParams, RouteStep[])` - Execute multi-hop swap
- `getExpectedOutput(address, address, uint256)` - Get expected output amount
- `pause()` / `unpause()` - Emergency controls

### 2. PriceAggregator.sol

**Purpose**: Aggregates prices from multiple DEXs to find the best route.

**Key Features**:
- Real-time price comparison
- Route optimization
- Price caching (5-second TTL)
- Gas estimate calculation
- Support for 15+ DEXs

**Main Functions**:
- `getBestPrice(address, address, uint256)` - Get best price across all DEXs
- `getAllPrices(address, address, uint256)` - Get prices from all DEXs
- `getBestRoute(address, address, uint256)` - Get optimal route
- `registerDex(address, uint256)` - Register a new DEX

### 3. DynamicFeeManager.sol

**Purpose**: Manages dynamic fee calculation with 0.05% base fee.

**Key Features**:
- Base fee: 0.05% (5 basis points)
- Maximum fee: 0.3% (30 basis points)
- Dynamic adjustments based on:
  - Network congestion
  - Liquidity depth
  - User volume tiers
  - Trade size
- Fee exemption list

**Main Functions**:
- `calculateFee(address, uint256, uint256)` - Calculate fee for a swap
- `updateFeeConfig(uint256, uint256)` - Update fee parameters
- `updateUserTier(address, uint256)` - Update user tier
- `setFeeExemption(address, bool)` - Set fee exemption
- `getEffectiveFeeRate(address, uint256, uint256)` - Get current fee rate

**Fee Tiers**:
- Volume >= 1,000,000: 0.03% discount
- Volume >= 500,000: 0.02% discount
- Volume >= 100,000: 0.01% discount

### 4. TreasuryManager.sol

**Purpose**: Manages fee collection and auto-forwards to gxqstudio.eth.

**Treasury Address**: `0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e` (gxqstudio.eth)

**Key Features**:
- Automatic fee collection
- Auto-forward threshold: 1 ETH equivalent
- Multi-token support
- Emergency withdrawal
- Batch forwarding

**Main Functions**:
- `collectFee(address, uint256)` - Collect fees
- `forwardFees(address)` - Manually forward fees
- `forwardMultipleTokens(address[])` - Batch forward
- `emergencyWithdraw(address, uint256, address)` - Emergency recovery
- `getTokenBalance(address)` - Get balance info

### 5. AdminControl.sol

**Purpose**: Role-based access control with timelock.

**Roles**:
- `SUPER_ADMIN_ROLE` - Full control
- `OPERATOR_ROLE` - Day-to-day operations
- `TREASURY_ROLE` - Fee management
- `EMERGENCY_ROLE` - Pause/unpause

**Key Features**:
- Multi-signature requirement
- 24-hour timelock for critical operations
- Whitelist/blacklist management
- Admin action logging

**Main Functions**:
- `scheduleAction(bytes32)` - Schedule timelock action
- `executeAction(bytes32)` - Execute timelock action
- `grantOperatorRole(address)` - Grant operator role
- `whitelistToken(address, bool)` - Whitelist token
- `blacklistAddress(address, bool)` - Blacklist address
- `emergencyShutdown()` - Emergency pause

### 6. MEVProtection.sol

**Purpose**: Protects against MEV attacks.

**Key Features**:
- Rate limiting (2 seconds between transactions)
- Transaction size limits (max 100 ETH)
- Blacklist for known MEV bots
- Sandwich attack detection
- Slippage tolerance enforcement

**Main Functions**:
- `checkTransaction(address, uint256, uint256, uint256)` - Validate transaction
- `detectSandwich(address, uint256)` - Detect sandwich attacks
- `blacklistBot(address)` - Blacklist MEV bot
- `updateRateLimit(uint256)` - Update rate limit
- `updateMaxTxSize(uint256)` - Update max transaction size

### 7. CrossChainRouter.sol

**Purpose**: Handles cross-chain swaps and bridging.

**Supported Chains**:
1. Ethereum Mainnet (Chain ID: 1)
2. Base (Chain ID: 8453)
3. Zora (Chain ID: 7777777)
4. Arbitrum (Chain ID: 42161)
5. Optimism (Chain ID: 10)
6. Polygon (Chain ID: 137)
7. BSC (Chain ID: 56)

**Key Features**:
- Atomic cross-chain swaps
- Bridge liquidity management
- Failed transaction refunds
- Per-chain limits

**Main Functions**:
- `initiateCrossChainSwap(CrossChainSwap)` - Start cross-chain swap
- `completeCrossChainSwap(bytes32, address, address, uint256)` - Complete swap
- `refundFailedSwap(bytes32, address, address, uint256, string)` - Refund
- `addChain(uint256, address, address, uint256, uint256)` - Add chain
- `updateChainConfig(...)` - Update chain config

## Deployment

### Prerequisites

- Foundry installed
- Private key with sufficient funds
- RPC endpoints configured

### Deploy to Testnet

```bash
forge script contracts/script/Deploy.s.sol:DeployScript \
    --rpc-url $BASE_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify
```

### Deploy to Mainnet

```bash
forge script contracts/script/Deploy.s.sol:DeployScript \
    --rpc-url $MAINNET_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify
```

## Testing

### Run All Tests

```bash
forge test -vvv
```

### Run Specific Test

```bash
forge test --match-contract DynamicFeeManagerTest -vvv
```

### Generate Coverage Report

```bash
forge coverage --report lcov
```

### Gas Report

```bash
forge test --gas-report
```

## Security

### Audits

- OpenZeppelin contracts used as base
- Slither static analysis
- Mythril security scan
- Manual security review

### Best Practices

- Reentrancy guards on all external calls
- Overflow protection (Solidity 0.8+)
- Access control on sensitive functions
- Emergency pause mechanism
- Timelock on critical operations

## Integration

### Adding a New DEX

1. Implement DEX-specific adapter
2. Register DEX in PriceAggregator
3. Add DEX to SwapRouter
4. Test thoroughly
5. Deploy and verify

Example:

```solidity
// Register DEX
priceAggregator.registerDex(dexAddress, gasEstimate);

// Add to SwapRouter
swapRouter.addDex(dexAddress);
```

### Interacting with Contracts

```javascript
// Using ethers.js
const swapRouter = new ethers.Contract(
  swapRouterAddress,
  swapRouterABI,
  signer
);

// Execute swap
const tx = await swapRouter.executeSwap({
  tokenIn: '0x...',
  tokenOut: '0x...',
  amountIn: ethers.parseEther('1'),
  amountOutMin: ethers.parseEther('1800'),
  recipient: userAddress,
  deadline: Math.floor(Date.now() / 1000) + 1200,
  routeData: '0x'
});

await tx.wait();
```

## Events

All contracts emit detailed events for monitoring:

- `SwapExecuted` - Emitted on successful swap
- `FeeCollected` - Emitted when fees are collected
- `FeesForwarded` - Emitted when fees are forwarded
- `DexRegistered` - Emitted when DEX is registered
- `PriceUpdate` - Emitted on price updates
- `EmergencyPause` - Emitted on pause/unpause

## Gas Optimization

- Batch operations where possible
- Use `calldata` instead of `memory`
- Pack storage variables
- Use events for data storage
- Optimize loops
- Use unchecked blocks for safe arithmetic

## Support

For questions or issues:
- GitHub Issues: https://github.com/SMSDAO/kybers/issues
- Discord: https://discord.gg/kybers
- Documentation: https://docs.kybers.io
