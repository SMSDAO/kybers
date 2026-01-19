# Kybers DEX - Tokenomics & Fee Structure

## Overview

Kybers DEX implements a sustainable and fair tokenomics model designed to benefit all stakeholders: traders, liquidity providers, partners, and the protocol treasury.

---

## Fee Structure

### Base Trading Fees

**0.05% Base Fee** (5 basis points)
- One of the lowest in the industry
- Applied to all swaps
- Transparent and predictable

**Dynamic Adjustments** (±0.02%)
- Network congestion adjustment
- Volatility adjustment
- Liquidity depth discounts

**Maximum Fee Cap: 0.3%**
- Hard cap ensures competitive pricing
- Protects users from excessive fees

### Fee Distribution

```
Total Swap Fee (0.05% - 0.3%)
│
├── Treasury (gxqstudio.eth) - 70%
│   └── Auto-forwards at 1 ETH threshold
│
├── Partner Revenue Share - 20%
│   └── Distributed to referral partners
│
└── Protocol Reserve - 10%
    └── Future development & security
```

---

## Volume-Based Discounts

Users receive automatic discounts based on cumulative trading volume:

| Tier | Minimum Volume | Discount | Effective Fee |
|------|---------------|----------|---------------|
| Bronze | $0 | 0% | 0.05% |
| Silver | $100,000 | 0.01% | 0.04% |
| Gold | $500,000 | 0.02% | 0.03% |
| Platinum | $1,000,000 | 0.03% | 0.02% |

**Note**: Discounts are calculated automatically and applied to each swap.

---

## Partner Revenue Sharing Program

### Referral Tiers

Partners earn a percentage of fees generated from their referrals:

| Tier | Minimum Referral Volume | Revenue Share |
|------|------------------------|---------------|
| Tier 1 | $0 | 0.10% (10 bps) |
| Tier 2 | $100,000 | 0.20% (20 bps) |
| Tier 3 | $1,000,000 | 0.30% (30 bps) |
| Tier 4 | $10,000,000 | 0.50% (50 bps) |

### Partner Benefits

- **Automatic Tier Upgrades**: Move up tiers as referral volume grows
- **Real-time Payouts**: Fees distributed immediately after swaps
- **Multi-Token Support**: Earn in ETH, WETH, USDC, USDT, and more
- **Dashboard Access**: Track earnings and referral performance
- **API Integration**: Seamlessly integrate Kybers into your platform

### Becoming a Partner

1. Apply through the partner portal
2. Receive a unique referral code
3. Start referring users
4. Earn revenue share automatically

**Contact**: partners@kybers.io

---

## Fee Collection Mechanism

### Smart Contract Architecture

```solidity
User Swap
    ↓
SwapRouter (executes swap)
    ↓
DynamicFeeManager (calculates fee)
    ↓
Fee Split:
    ├→ TreasuryManager (70% to gxqstudio.eth)
    ├→ PartnerAPI (20% to referrer if applicable)
    └→ Protocol Reserve (10%)
```

### Auto-Forwarding

- **Threshold**: 1 ETH equivalent
- **Frequency**: Automatic when threshold reached
- **Manual Option**: Admin can trigger manual forwarding
- **Multi-Token**: Supports ETH and all major tokens
- **Gas Optimized**: Batched transfers to minimize costs

---

## Multi-Chain Fee Handling

### Chain-Specific Considerations

**Ethereum (L1)**
- Standard fee structure applies
- Higher gas costs factored into routes

**Base, Optimism, Arbitrum (L2s)**
- Same fee percentage
- Lower gas costs = better net returns

**Polygon, BSC**
- Same fee structure maintained
- Chain-specific gas tokens handled

### Cross-Chain Fee Aggregation

- Fees collected on each chain
- Aggregated to treasury address on respective chains
- Bridge fees covered by protocol when consolidating

---

## Fee Exemptions

Certain addresses may be exempted from fees:

- **Partner Protocols**: Strategic partners with fee-sharing agreements
- **High-Volume Traders**: Negotiated exemptions for institutional users
- **Protocol-Owned Contracts**: Internal protocol operations

**Fee exemption list managed by**: AdminControl contract with 24h timelock

---

## Treasury Management

### Treasury Address

**gxqstudio.eth**: `0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e`

### Treasury Allocation

**Protocol Development (40%)**
- Smart contract improvements
- New feature development
- Security audits and bug bounties

**Marketing & Growth (30%)**
- User acquisition
- Partnership development
- Community initiatives

**Operations (20%)**
- Infrastructure costs
- Team compensation
- Legal and compliance

**Reserve Fund (10%)**
- Emergency situations
- Opportunity fund
- Future protocol upgrades

---

## Security Measures

### Fee Collection Security

✅ **Authorization System**: Only SwapRouter can collect fees  
✅ **Reentrancy Protection**: ReentrancyGuard on all fee functions  
✅ **Safe Token Handling**: SafeERC20 for all transfers  
✅ **Emergency Controls**: Pause functionality for critical situations  
✅ **Timelock**: 24-hour delay on critical parameter changes  

### Audit Status

- ✅ Complete security audit performed
- ✅ All 10 issues resolved (3 Critical, 2 High, 3 Medium, 2 Low)
- ✅ Safe approval patterns implemented
- ✅ Input validation on all functions

---

## Fee Transparency

### Real-Time Tracking

Users can track fees in real-time through:

1. **Frontend Interface**: Live fee display before swaps
2. **Blockchain Explorer**: All fees recorded on-chain
3. **Analytics Dashboard**: Historical fee data and trends
4. **Partner Portal**: Referral earnings tracking

### Fee Breakdown Example

```
Swap: 1 ETH → USDC
Current Price: 1 ETH = $2,000

Base Fee: 0.05% = $1.00
Congestion Adjustment: +0.01% = $0.20
Volume Discount (Gold): -0.02% = -$0.40
──────────────────────────────────
Total Fee: 0.04% = $0.80

Distribution:
├─ Treasury: $0.56 (70%)
├─ Partner: $0.16 (20%)
└─ Reserve: $0.08 (10%)
```

---

## Future Tokenomics (Potential)

### Governance Token Considerations

While Kybers currently operates without a native token, future considerations may include:

- **Governance Rights**: Vote on protocol parameters
- **Fee Discounts**: Additional discounts for token holders
- **Revenue Sharing**: Share in protocol revenue
- **Staking Rewards**: Earn rewards for providing security

**Note**: Any tokenomics changes would be announced well in advance and subject to community governance.

---

## Comparison with Competitors

| DEX | Base Fee | Max Fee | Revenue Share | Multi-Chain |
|-----|----------|---------|---------------|-------------|
| **Kybers** | **0.05%** | **0.3%** | **Yes (20%)** | **7 chains** |
| Uniswap | 0.3% | 1% | No | Limited |
| 1inch | 0.0% | Variable | Yes | Multiple |
| Paraswap | 0.0% | Variable | Yes | Multiple |
| Matcha | 0.0% | Variable | No | Limited |

**Kybers Advantage**: Transparent fees, partner program, and extensive multi-chain support.

---

## Fee Parameter Governance

### Adjustable Parameters

Controlled by AdminControl with 24h timelock:

- **Base Fee Rate**: Currently 0.05%
- **Congestion Adjustment**: ±0.02%
- **Volatility Adjustment**: ±0.02%
- **Volume Discount Thresholds**: Tier breakpoints
- **Partner Revenue Share**: Currently 20%
- **Auto-Forward Threshold**: Currently 1 ETH

### Change Process

1. Proposal submitted by SUPER_ADMIN
2. 24-hour timelock period
3. Community notification
4. Execution after timelock expires

---

## Contact & Support

**General Inquiries**: hello@kybers.io  
**Partner Program**: partners@kybers.io  
**Technical Support**: support@kybers.io  
**Security**: security@kybers.io  

**Treasury Address**: gxqstudio.eth  
**GitHub**: https://github.com/SMSDAO/kybers  

---

*Last Updated: January 2026*  
*Version: 1.0*
