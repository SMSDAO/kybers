# Complete Testing & Validation Guide

## Overview

This guide provides comprehensive testing procedures for the Kybers DEX platform, covering all phases from development to production deployment.

## Table of Contents

1. [Local Development Testing](#local-development-testing)
2. [Contract Testing](#contract-testing)
3. [Security Testing](#security-testing)
4. [Integration Testing](#integration-testing)
5. [Testnet Validation](#testnet-validation)
6. [Mainnet Pre-Launch Testing](#mainnet-pre-launch-testing)
7. [Monitoring & Post-Launch](#monitoring--post-launch)

---

## Local Development Testing

### Prerequisites

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install foundry-rs/forge-std --no-commit

# Install Node.js dependencies
cd frontend && npm install
cd ../services && npm install
```

### Build Verification

```bash
# Run comprehensive build verification
./scripts/build-verify.sh

# Expected output:
# - All checks green (✓)
# - Compilation successful
# - Tests passing
# - Security checks clear
```

### Contract Compilation

```bash
# Compile all contracts
forge build

# With size report
forge build --sizes

# Check for size issues
# Max contract size: 24KB (24576 bytes)
```

---

## Contract Testing

### Unit Tests

Test individual contract functions in isolation:

```bash
# Run all tests
forge test

# Verbose output
forge test -vv

# Extra verbose (with gas reports)
forge test -vvv

# Specific test file
forge test --match-path contracts/test/SwapRouter.t.sol

# Specific test function
forge test --match-test testExecuteSwap
```

### Test Coverage

```bash
# Generate coverage report
forge coverage

# Detailed coverage
forge coverage --report debug

# Target: >95% coverage for all contracts
```

### Gas Optimization Testing

```bash
# Generate gas report
forge test --gas-report

# Save gas snapshot
forge snapshot

# Compare gas usage
forge snapshot --diff .gas-snapshot
```

### Fuzz Testing

```bash
# Run fuzz tests
forge test --fuzz-runs 1000

# For CI (more thorough)
forge test --fuzz-runs 10000
```

---

## Security Testing

### Static Analysis

```bash
# Slither security scanner
slither contracts/

# Focus on high/medium severity
slither contracts/ --filter-paths "test|script"

# Mythril symbolic execution
myth analyze contracts/core/*.sol
```

### Manual Security Checks

#### 1. Access Control

```bash
# Check all onlyOwner functions
grep -r "onlyOwner" contracts/core contracts/admin

# Check role-based access
grep -r "onlyRole" contracts/

# Verify timelock on critical functions
grep -r "timelock" contracts/
```

#### 2. Reentrancy Protection

```bash
# Check for nonReentrant modifier
grep -r "nonReentrant" contracts/

# Check for checks-effects-interactions pattern
# Manual review required
```

#### 3. Integer Overflow

```bash
# Verify Solidity 0.8.x (built-in overflow protection)
grep "pragma solidity" contracts/**/*.sol

# Should all be 0.8.x or higher
```

#### 4. Token Safety

```bash
# Check for SafeERC20 usage
grep -r "SafeERC20\|safeTransfer\|safeApprove" contracts/

# Verify approval resets
grep -r "approve(.*0)" contracts/
```

### Known Vulnerabilities Checklist

Based on our security audit, verify these fixes are in place:

- [ ] C-1: Token approval resets (before and after swaps)
- [ ] C-2: TreasuryManager authorization system
- [ ] C-3: Minimum output validation (1% slippage)
- [ ] H-1: Comprehensive input validation
- [ ] H-2: Multi-hop route validation
- [ ] M-1: Updatable treasury address
- [ ] M-2: No events in view functions
- [ ] M-3: SafeERC20 everywhere
- [ ] L-1: Zero amount checks
- [ ] L-2: Token address validation

```bash
# Automated check for audit fixes
./scripts/verify-audit-fixes.sh
```

---

## Integration Testing

### Multi-Contract Interactions

Test how contracts interact with each other:

```bash
# Test swap → fee collection → treasury forwarding
forge test --match-test testFullSwapFlow -vvv

# Test admin → fee manager → configuration
forge test --match-test testFeeConfiguration -vvv

# Test partner → swap → revenue share
forge test --match-test testPartnerRevenue -vvv
```

### Multi-Chain Testing

```bash
# Test cross-chain functionality
forge test --match-path contracts/test/MultiChain.t.sol -vvv

# Test each supported chain
forge test --match-test testEthereumSwap -vvv
forge test --match-test testBaseSwap -vvv
forge test --match-test testZoraSwap -vvv
# etc.
```

### DEX Integration Testing

Test integration with each DEX:

```bash
# Test Uniswap V2
forge test --match-test testUniswapV2Swap -vvv

# Test Uniswap V3
forge test --match-test testUniswapV3Swap -vvv

# Test Sushiswap
forge test --match-test testSushiswapSwap -vvv

# Continue for all 15+ DEXs
```

---

## Testnet Validation

### Deployment to Testnet

```bash
# Deploy to testnet (e.g., Base Sepolia)
./scripts/testnet-deploy.sh base-sepolia

# Verify deployment
# Check deployment log and addresses JSON
```

### Testnet Testing Checklist

#### Phase 1: Basic Functionality (Day 1)

- [ ] Deploy all contracts to testnet
- [ ] Verify contracts on block explorer
- [ ] Configure authorization (TreasuryManager ↔ SwapRouter)
- [ ] Set initial fee parameters (0.05% base)
- [ ] Test basic swap (ETH → USDC)
- [ ] Verify fee collection
- [ ] Confirm treasury forwarding
- [ ] Test pause/unpause functionality

#### Phase 2: Advanced Features (Days 2-3)

- [ ] Test multi-hop swaps
- [ ] Test cross-chain swaps
- [ ] Test MEV protection (rate limiting)
- [ ] Test partner revenue sharing
- [ ] Test volume-based fee discounts
- [ ] Test emergency withdrawal
- [ ] Test admin controls (timelock)
- [ ] Test slippage protection

#### Phase 3: Edge Cases (Days 4-5)

- [ ] Test with minimum amounts
- [ ] Test with maximum amounts
- [ ] Test with zero liquidity pairs
- [ ] Test with high volatility pairs
- [ ] Test deadline expiration
- [ ] Test invalid routes
- [ ] Test unauthorized access attempts
- [ ] Test reentrancy scenarios

#### Phase 4: Integration (Days 6-7)

- [ ] Connect frontend to testnet
- [ ] Test all UI components
- [ ] Test wallet connections
- [ ] Test transaction signing
- [ ] Test error handling
- [ ] Test mobile responsiveness
- [ ] Load testing (multiple concurrent users)
- [ ] Partner API integration testing

### Testnet Performance Metrics

Track these metrics during testnet phase:

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Swap success rate | >99% | - | - |
| Average gas cost | <150k gas | - | - |
| Fee collection | 100% | - | - |
| Treasury forwarding | 100% | - | - |
| Partner distribution | 100% | - | - |
| Response time | <3s | - | - |
| Uptime | >99.9% | - | - |

### Testnet Issues Log

Document all issues found during testnet:

```
Issue #1: [Description]
- Severity: [Critical/High/Medium/Low]
- Impact: [What's affected]
- Fix: [How it was fixed]
- Commit: [Fix commit hash]
- Verified: [Yes/No]

Issue #2: ...
```

---

## Mainnet Pre-Launch Testing

### Code Freeze Verification

```bash
# Verify code hasn't changed since testnet
./scripts/verify-code-integrity.sh

# Expected: Hash matches testnet deployment
```

### Pre-Launch Checklist

- [ ] All testnet testing completed
- [ ] All issues resolved
- [ ] Security audit reviewed and issues fixed
- [ ] Code frozen (no changes since testnet)
- [ ] Deployment scripts reviewed
- [ ] Private keys secured (hardware wallet)
- [ ] Multi-sig configured for admin
- [ ] Emergency response plan documented
- [ ] Monitoring configured
- [ ] Team briefed on launch procedures

### Dry Run Deployment

```bash
# Run deployment script in dry-run mode
forge script contracts/script/Deploy.s.sol:DeployScript \
    --rpc-url mainnet \
    --dry-run \
    -vvvv

# Review gas costs and deployment order
```

### Final Build Verification

```bash
# Run comprehensive verification
./scripts/build-verify.sh

# All checks must pass (green) ✓
```

---

## Mainnet Launch Testing

### Immediate Post-Deployment (Hour 1)

```bash
# 1. Verify all contracts deployed
cast code <ADDRESS> --rpc-url mainnet

# 2. Verify contracts on explorer
# Check each contract on Etherscan/Basescan

# 3. Test basic swap with small amount (0.01 ETH)
cast send <SWAP_ROUTER> "executeSwap(...)" \
    --value 0.01ether \
    --rpc-url mainnet

# 4. Verify fee collection
cast call <TREASURY_MANAGER> "accumulatedFees(address)" <TOKEN>

# 5. Check treasury balance
cast balance <TREASURY_ADDRESS>
```

### Gradual Rollout (Day 1)

- Hour 1-2: Team testing only (small amounts)
- Hour 3-6: Beta users invited (limited amounts)
- Hour 7-12: Soft launch (transaction limits)
- Hour 13-24: Full launch (all features)

### Health Checks

Run these checks every hour for the first 24 hours:

```bash
# Check contract is not paused
cast call <SWAP_ROUTER> "paused()"

# Check accumulated fees
cast call <TREASURY_MANAGER> "totalFeesCollected()"

# Check treasury balance
cast balance <TREASURY_ADDRESS>

# Check recent swaps (via events)
cast logs --address <SWAP_ROUTER> --event "SwapExecuted(...)"

# Check for any errors
cast logs --address <SWAP_ROUTER> --event "Error(...)"
```

---

## Monitoring & Post-Launch

### Continuous Monitoring

Set up alerts for:

1. **Contract Events**
   - All swaps
   - Fee collections
   - Treasury forwards
   - Errors/reverts
   - Pause/unpause events

2. **Performance Metrics**
   - Transaction success rate
   - Average gas costs
   - Response times
   - Queue lengths

3. **Security Alerts**
   - Unauthorized access attempts
   - Unusual transaction patterns
   - High-value transactions
   - MEV bot activity

4. **Financial Tracking**
   - Total volume
   - Total fees collected
   - Treasury balance
   - Partner earnings

### Weekly Health Reports

Generate weekly reports covering:

- Total transactions
- Total volume
- Total fees collected
- Average gas costs
- Success rate
- Issues encountered
- User feedback
- Performance trends

### Quarterly Security Reviews

Every 3 months:

- Review all security incidents
- Update threat model
- Re-run security scanners
- Audit admin actions
- Review access controls
- Update emergency procedures

---

## Testing Tools & Resources

### Foundry Tools

```bash
forge        # Compile, test, deploy
cast         # Interact with contracts
anvil        # Local Ethereum node
chisel       # Solidity REPL
```

### Security Tools

```bash
slither      # Static analysis
mythril      # Symbolic execution
echidna      # Fuzzing
manticore    # Symbolic execution
```

### Monitoring Tools

- Tenderly - Transaction monitoring
- Defender - OpenZeppelin security monitoring
- Dune Analytics - On-chain analytics
- The Graph - Event indexing

### Testing Networks

- **Ethereum**: Sepolia, Goerli
- **Base**: Base Sepolia
- **Arbitrum**: Arbitrum Sepolia
- **Optimism**: Optimism Sepolia
- **Polygon**: Mumbai
- **BSC**: BSC Testnet
- **Zora**: Zora Testnet

---

## Troubleshooting

### Common Issues

#### Issue: Tests failing

```bash
# Clean build artifacts
forge clean

# Rebuild
forge build

# Re-run tests
forge test -vvv
```

#### Issue: Out of gas

```bash
# Check gas limits
forge test --gas-report

# Optimize contracts
# Review loops and storage operations
```

#### Issue: Reentrancy detected

```bash
# Add nonReentrant modifier
# Follow checks-effects-interactions pattern
# Review external calls
```

#### Issue: Deployment fails

```bash
# Check deployer balance
cast balance <DEPLOYER> --rpc-url <NETWORK>

# Check gas price
cast gas-price --rpc-url <NETWORK>

# Try with higher gas limit
forge script ... --gas-limit 10000000
```

---

## Testing Best Practices

### 1. Test Early, Test Often

- Write tests alongside code
- Run tests before every commit
- Automate testing in CI/CD

### 2. Comprehensive Coverage

- Aim for >95% code coverage
- Test all code paths
- Include edge cases
- Test error conditions

### 3. Realistic Scenarios

- Use realistic test data
- Test with actual token addresses (on testnet)
- Simulate real user behavior
- Test under load

### 4. Security First

- Always run security scanners
- Manual review for critical functions
- Test attack vectors
- Validate all inputs

### 5. Document Everything

- Document test cases
- Record test results
- Track issues and fixes
- Maintain test reports

---

## Summary

This comprehensive testing guide ensures that:

✅ All code is thoroughly tested before deployment
✅ Security is validated at every stage
✅ Testnet provides a safe environment for validation
✅ Mainnet deployment is methodical and safe
✅ Ongoing monitoring catches issues early
✅ The platform remains secure and reliable

**Remember**: The same code tested on testnet is deployed to mainnet. Thorough testnet validation is critical for mainnet success.

---

*Last Updated: January 15, 2026*
*Current Phase: Ready for testnet deployment*
*Next Phase: Comprehensive testnet validation*
