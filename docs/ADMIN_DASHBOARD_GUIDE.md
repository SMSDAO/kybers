# Admin Dashboard - Complete Guide

## Overview

The Kybers DEX Admin Dashboard provides comprehensive control over all aspects of the DEX platform. This guide covers all 6 admin sections with full specifications and usage instructions.

## Table of Contents

1. [Dashboard Overview](#dashboard-overview)
2. [Fee Management](#fee-management)
3. [Treasury Monitor](#treasury-monitor)
4. [Security Controls](#security-controls)
5. [Contract Management](#contract-management)
6. [Advanced Analytics](#advanced-analytics)
7. [Web3 Integration](#web3-integration)

---

## Dashboard Overview

**Path**: `/admin/dashboard`

### Key Metrics

**Total Volume**
- Real-time trading volume across all chains
- 24h/7d/30d comparison
- Percentage change tracking

**Total Fees Collected**
- Cumulative fee revenue
- 0.05% base fee display
- Fee breakdown by token

**Active Users**
- Unique wallet addresses (24h)
- New vs returning user ratio
- User growth trends

**Total Swaps**
- All-time swap count
- Average swaps per day
- Peak trading periods

### DEX Performance

Tracks volume and trade count for each integrated DEX:
- Uniswap V3
- Sushiswap
- Curve Finance
- Balancer
- Kyber Network
- 1inch
- PancakeSwap
- QuickSwap
- Trader Joe
- Velodrome
- Aerodrome
- Plus 4 more DEXs

**Metrics per DEX**:
- 24h volume
- Number of trades
- Average trade size
- Gas efficiency

### Chain Distribution

Volume breakdown across all 7 supported chains:
- Ethereum (Mainnet)
- Base
- Zora
- Arbitrum
- Optimism
- Polygon
- BSC

**Chain Metrics**:
- 24h volume
- Active users
- Average gas price
- Transaction count

### System Status

Real-time health monitoring:
- ✅ Smart Contracts - Operational
- ✅ Price Aggregation - Operational
- ✅ Treasury Auto-Forward - Active
- ⚠️ RPC Endpoints - Check status
- 🔴 Issues - Alert display

---

## Fee Management

**Path**: `/admin/fees`

### Current Fee Configuration

**Base Fee**: 0.05% (5 basis points)
- Industry-leading low fee
- Applied to all swaps
- Non-adjustable base rate

**Congestion Adjustment**: ±0.02%
- Dynamic based on network congestion
- Automatically calculated
- Manual override available

**Max Fee Cap**: 0.30% (30 basis points)
- Hard limit on total fees
- Protects users from excessive charges
- Includes all adjustments

### Dynamic Fee Adjustments

**Congestion Adjustment**
```solidity
Input: 0.00% to 0.02%
Purpose: Compensate for high gas periods
Calculation: Based on avg gas price
Update Frequency: Every block
```

**Volatility Adjustment**
```solidity
Input: 0.00% to 0.02%
Purpose: Account for market volatility
Calculation: Based on price changes
Update Frequency: Every 5 minutes
```

**Functions**:
- `setC ongestionFee(uint256 bps)` - Update congestion adjustment
- `setVolatilityFee(uint256 bps)` - Update volatility adjustment
- `setMaxFee(uint256 bps)` - Update maximum fee cap

### Fee Exemptions

Add addresses exempt from fees:
- Partner addresses
- Liquidity providers
- Protocol-owned wallets
- Strategic partnerships

**Usage**:
1. Enter Ethereum address (0x...)
2. Click "Add" to exemption list
3. View all exempted addresses
4. Remove with "Delete" button

**Smart Contract Function**:
```solidity
function addFeeExemption(address _address) external onlyAdmin
function removeFeeExemption(address _address) external onlyAdmin
```

### Volume Discount Tiers

Automatic discounts based on cumulative trading volume:

| Tier | Volume Threshold | Discount | Effective Fee |
|------|------------------|----------|---------------|
| Tier 1 | ≥100,000 USD | -0.01% | 0.04% |
| Tier 2 | ≥500,000 USD | -0.02% | 0.03% |
| Tier 3 | ≥1,000,000 USD | -0.03% | 0.02% |
| Platinum | ≥5,000,000 USD | -0.03% | 0.02% |

**Features**:
- Automatically applied
- Tracked per wallet address
- Cumulative across all chains
- Reset annually (optional)

---

## Treasury Monitor

**Path**: `/admin/treasury`

### Treasury Address

**Address**: `0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e`
**ENS**: `gxqstudio.eth`

### Balance Overview

**Total ETH Collected**
- All-time fee collection in ETH
- Current pending balance
- Already forwarded amount

**Total USD Value**
- Approximate USD value
- Based on current ETH price
- Real-time conversion

**Last Forward**
- Timestamp of last auto-forward
- Amount forwarded
- Transaction hash link

### Token Balances

Tracks accumulated fees for each token:
- ETH (native)
- WETH (wrapped)
- USDC (stablecoin)
- USDT (stablecoin)
- DAI (stablecoin)
- WBTC
- Other ERC20 tokens

**Per Token Metrics**:
- Accumulated: Total ever collected
- Forwarded: Already sent to treasury
- Pending: Waiting for threshold

### Auto-Forward Configuration

**Threshold**: 1 ETH
- Automatically forwards when accumulated fees ≥ 1 ETH
- Includes all token values converted to ETH
- Gas-optimized batch transfers

**Manual Forward Options**:
- Forward All Pending Fees
- Forward ETH Only
- Forward Tokens Only
- Emergency Withdrawal

**Smart Contract Functions**:
```solidity
function collectFee(address token, uint256 amount) external authorized
function forwardToTreasury() external
function setForwardThreshold(uint256 _threshold) external onlyAdmin
function updateTreasuryAddress(address _newTreasury) external onlyAdmin
```

### Recent Forwards

Transaction history:
- Timestamp
- Token/Amount
- Transaction hash
- Gas used
- Status (confirmed/pending)

---

## Security Controls

**Path**: `/admin/security`

### System Status

Real-time contract status for all core contracts:
- SwapRouter
- PriceAggregator
- DynamicFeeManager
- TreasuryManager
- AdminControl
- MEVProtection
- CrossChainRouter
- PartnerAPI

**Status Indicators**:
- 🟢 Active - Contract operational
- 🟡 Paused - Emergency pause active
- 🔴 Error - Contract issue detected

**Actions**:
- Pause Contract - Emergency shutdown
- Unpause Contract - Resume operations
- View Contract - Block explorer link

### Emergency Controls

**🚨 Emergency Shutdown**
```
Purpose: Immediately halt all swap operations
Use Case: Critical security vulnerability detected
Effect: Pauses SwapRouter, blocks all swaps
Recovery: Manual unpause after fix
Authorization: EMERGENCY_ROLE required
```

**✅ Resume Operations**
```
Purpose: Restore normal swap functionality
Use Case: After security issue resolved
Effect: Unpauses all contracts
Prerequisites: Security audit complete
Authorization: SUPER_ADMIN_ROLE required
```

**Smart Contract Functions**:
```solidity
function pause() external onlyEmergencyRole
function unpause() external onlySuperAdmin
```

### MEV Protection Settings

**Rate Limit**
- Default: 2 seconds between transactions
- Range: 1-10 seconds
- Per-address enforcement
- Prevents rapid-fire exploits

**Max Transaction Size**
- Default: 100 ETH equivalent
- Adjustable per market conditions
- Prevents whale manipulation
- Separate limits per chain

**Max Slippage Tolerance**
- Default: 5%
- Range: 0.1% - 10%
- User-configurable
- Hard cap for safety

**Update Function**:
```solidity
function updateMEVSettings(
    uint256 _rateLimit,
    uint256 _maxTxSize,
    uint256 _maxSlippage
) external onlyOperator
```

### Blacklist Management

Block malicious addresses:
- MEV bot addresses
- Exploit contracts
- Sanctioned addresses
- Reported scammers

**Usage**:
1. Enter address to blacklist
2. Optional: Add reason/note
3. Click "Add" to blacklist
4. View all blacklisted addresses
5. Remove with explanation

**Smart Contract Function**:
```solidity
function addToBlacklist(address _address, string _reason) external onlyAdmin
function removeFromBlacklist(address _address) external onlyAdmin
function isBlacklisted(address _address) external view returns (bool)
```

### Security Event Log

Tracks all security-related events:
- Pause/unpause actions
- Blacklist additions/removals
- Failed transaction attempts
- MEV detection triggers
- Admin role changes
- Emergency withdrawals

**Event Details**:
- Timestamp
- Event type
- Affected address
- Admin who triggered
- Transaction hash

---

## Contract Management

**Path**: `/admin/contracts`

### Contract Overview

**Total Contracts**: 8 core contracts
**Deployed**: Status per chain
**Verified**: Block explorer verification status

### Contract Details

For each of the 8 core contracts:

**SwapRouter.sol**
- Address: Contract deployment address
- Version: Current version (e.g., 1.0.0)
- Deployed: Deployment date/block
- Verified: Etherscan verification status
- Status: Active/Paused/Inactive

**Quick Actions**:
- View Source - GitHub/Etherscan
- Read Contract - Query functions
- Write Contract - Execute functions
- Events - View emitted events
- Upgrade - Proxy upgrade (if upgradeable)

### Deployment Actions

**Select Chain**
- Ethereum Mainnet
- Base
- Zora
- Arbitrum
- Optimism
- Polygon
- BSC
- All Testnets (Base Sepolia, Eth Sepolia, etc.)

**Deployment Options**:
1. Deploy All Contracts - Full deployment
2. Verify All Contracts - Block explorer verification
3. Deploy Single Contract - Individual deployment
4. Upgrade Contract - Proxy upgrade

**Deployment Workflow**:
```bash
# 1. Verify build
./scripts/audit-verify.sh

# 2. Setup Foundry
./scripts/foundry-updates.sh

# 3. Deploy to testnet
./scripts/testnet-deploy.sh base-sepolia

# 4. Test thoroughly (7 days)

# 5. Deploy to mainnet
./scripts/mainnet-deploy.sh base
```

### Contract Interactions

Execute contract functions directly from UI:

**Select Contract**: Dropdown of all 8 contracts
**Select Function**: Available functions
- Read functions (no gas)
- Write functions (requires transaction)

**Example Functions**:
- `pause()` - Pause contract
- `unpause()` - Resume contract
- `setFeeRate(uint256 _rate)` - Update fee
- `updateTreasuryAddress(address _treasury)` - Change treasury
- `grantRole(bytes32 _role, address _account)` - Assign admin role

**Parameter Input**:
- Dynamic form based on function signature
- Type validation (address, uint256, bool, etc.)
- Array support for batch operations

**Execution**:
1. Connect wallet (MetaMask/WalletConnect)
2. Select contract and function
3. Enter parameters
4. Review transaction details
5. Confirm and sign
6. Wait for confirmation
7. View transaction on explorer

### Recent Admin Transactions

History of all admin actions:
- Contract deployments
- Function executions
- Role assignments
- Configuration changes
- Emergency actions

---

## Advanced Analytics

**Path**: `/admin/analytics`

### Analytics Overview

**24h Volume**: Total trading volume (last 24 hours)
**24h Fees**: Total fees collected (last 24 hours)
**Active Users**: Unique traders (last 24 hours)
**Avg Trade Size**: Average swap amount

### Time Range Selector

- 24H - Last 24 hours
- 7D - Last 7 days
- 30D - Last 30 days
- 90D - Last 90 days
- 1Y - Last year
- ALL - All time

**Export Data**: Download CSV/JSON of analytics data

### Volume Chart

Interactive line/bar chart showing:
- Trading volume over time
- Comparison with previous period
- Trend analysis
- Peak trading times
- Volume by chain

**Chart Features**:
- Zoom and pan
- Hover for exact values
- Toggle chains on/off
- Export chart image

### Top Trading Pairs

Ranked list of most traded pairs:

| Rank | Pair | Volume (24h) | Trades | Change |
|------|------|--------------|--------|--------|
| #1 | ETH/USDC | $X | Y | +Z% |
| #2 | WETH/DAI | $X | Y | +Z% |
| #3 | USDC/USDT | $X | Y | +Z% |

**Sortable by**:
- Volume
- Number of trades
- Price change
- Liquidity depth

### User Analytics

**New vs Returning Users**
- New Users: First-time traders
- Returning Users: Previous traders
- Retention rate
- Growth metrics

**Gas Efficiency**
- Average gas used per swap
- Gas savings vs direct DEX
- Optimization improvements
- Cost per transaction

### Revenue Breakdown

Distribution of collected fees:

**Treasury (70%)**: $X to gxqstudio.eth
**Partners (20%)**: $Y revenue share
**Reserve (10%)**: $Z emergency fund

**Visualization**:
- Pie chart of distribution
- Historical trends
- Projection calculator

### Partner Program Analytics

**Total Partners**: Active referral partners
**Tier Distribution**:
- Bronze (0.10% share)
- Silver (0.20% share)
- Gold (0.35% share)
- Platinum (0.50% share)

**Top Partners**:
- Ranking by referral volume
- Earnings breakdown
- Conversion rates
- Growth trends

### DEX Routing Analytics

Efficiency metrics for each DEX:

**Per DEX**:
- Number of routes used
- Average savings vs direct
- Success rate
- Gas efficiency
- Liquidity utilization

**Routing Intelligence**:
- Multi-hop route analysis
- Split trade optimization
- Price impact reduction
- Best execution rate

### System Performance

**Uptime**: 99.9% target
**Avg Response Time**: API latency
**Success Rate**: Successful swaps / total attempts
**Failed Transactions**: Count and reasons

---

## Web3 Integration

### Wallet Connection

Supported wallets:
- MetaMask
- WalletConnect
- Coinbase Wallet
- Ledger
- Trezor

**Connection Flow**:
1. Click "Connect Wallet"
2. Select wallet provider
3. Approve connection
4. Select chain
5. Confirm address

### Admin Authorization

**Role-Based Access Control (RBAC)**:

**SUPER_ADMIN_ROLE**
- Full system control
- Emergency shutdown
- Role assignment
- Contract upgrades

**OPERATOR_ROLE**
- Fee adjustments
- MEV settings
- Blacklist management
- Daily operations

**TREASURY_ROLE**
- Treasury address updates
- Manual fee forwards
- Balance monitoring

**EMERGENCY_ROLE**
- Pause/unpause contracts
- Emergency withdrawals
- Security responses

**Role Assignment**:
```solidity
function grantRole(bytes32 role, address account) external onlySuperAdmin
function revokeRole(bytes32 role, address account) external onlySuperAdmin
```

### Transaction Signing

All admin actions require transaction signatures:

**Read Operations** (no gas):
- View balances
- Check status
- Query data

**Write Operations** (requires gas):
- Update settings
- Pause contracts
- Assign roles
- Forward fees

**Transaction Details**:
- Gas estimate
- Current gas price
- Total cost
- Expected time
- Risk warnings

### Multi-Signature Support

For critical operations:
- Contract upgrades
- Treasury address changes
- Emergency shutdowns

**Gnosis Safe Integration**:
- 2-of-3 or 3-of-5 signatures required
- Timelock (24-48 hours)
- Transaction queue
- Approval tracking

---

## Security Best Practices

### Access Control

1. **Use hardware wallets** for admin keys
2. **Enable 2FA** on all accounts
3. **Rotate keys** periodically
4. **Limit admin addresses** to essential personnel
5. **Audit all changes** before execution

### Emergency Procedures

**If vulnerability detected**:
1. Immediately pause affected contracts
2. Assess severity and impact
3. Notify team and users
4. Develop and test fix
5. Deploy fix and audit
6. Unpause after verification

**Emergency Contacts**:
- Security team: security@kybers.io
- Smart contract auditor: audits@kybers.io
- Community: discord.gg/kybers

### Monitoring

**24/7 Monitoring**:
- Transaction patterns
- Gas usage anomalies
- Failed transaction spikes
- Unusual admin activity
- Contract health status

**Alerts**:
- Email notifications
- Slack/Discord webhooks
- SMS for critical events
- Dashboard indicators

---

## Deployment Checklist

Before deploying changes:

- [ ] Run audit verification: `./scripts/audit-verify.sh`
- [ ] All tests passing (100%)
- [ ] Code coverage >95%
- [ ] Security audit complete
- [ ] Deploy to testnet first
- [ ] Test on testnet (7+ days)
- [ ] Get multi-sig approvals
- [ ] Schedule maintenance window
- [ ] Deploy to mainnet
- [ ] Verify contracts on explorers
- [ ] Test all admin functions
- [ ] Monitor for 24 hours

---

## Support

**Documentation**: docs.kybers.io
**GitHub**: github.com/SMSDAO/kybers
**Discord**: discord.gg/kybers
**Email**: support@kybers.io

**Admin Support**:
- Priority response for critical issues
- Direct line to development team
- 24/7 emergency support
- Scheduled training sessions

---

## Changelog

**v1.0.0** (Current)
- Initial admin dashboard release
- All 6 sections implemented
- Full smart contract integration
- Real-time analytics
- Neo glow cyberpunk theme

**Coming Soon**:
- Advanced charting library
- Mobile admin app
- Automated reports
- AI-powered insights
- Cross-chain analytics aggregation

---

*Last Updated: January 2026*
*Version: 1.0.0*
*Maintainer: Kybers DEX Team*
