# Foundry Updates & Testnet Deployment Guide

## Overview

The `foundry-updates.sh` and `audit-verify.sh` scripts provide comprehensive automation for Foundry setup, smart contract auditing, and testnet deployment preparation.

## Scripts Overview

### 1. foundry-updates.sh
**Complete Foundry installation and testnet deployment preparation**

### 2. audit-verify.sh
**Complete smart contract audit verification (must pass before merge)**

---

## 📋 foundry-updates.sh Usage

### Purpose
Automates the complete setup of Foundry, dependency installation, RPC health monitoring, wallet balance checking, and testnet deployment preparation.

### Command
```bash
./scripts/foundry-updates.sh
```

### What It Does

#### 1. Install/Update Foundry
- Installs Foundry if not present
- Updates to latest version if already installed
- Verifies forge, cast, and anvil are working
- Displays version information

#### 2. Install Dependencies
- Installs OpenZeppelin contracts (`lib/openzeppelin-contracts`)
- Installs forge-std (`lib/forge-std`)
- Uses `--no-commit` flag to avoid dirty git state

#### 3. RPC Health Check
Checks connectivity and health for all 7 testnet RPCs:
- **Base Sepolia** - https://sepolia.base.org
- **Ethereum Sepolia** - https://rpc.sepolia.org
- **Arbitrum Sepolia** - https://sepolia-rollup.arbitrum.io/rpc
- **Optimism Sepolia** - https://sepolia.optimism.io
- **Polygon Mumbai** - https://rpc-mumbai.maticvigil.com
- **BSC Testnet** - https://data-seed-prebsc-1-s1.binance.org:8545
- **Zora Testnet** - https://testnet.rpc.zora.energy

For each RPC:
- ✅ Queries chain ID to verify connectivity
- ✅ Reports status (Healthy/Unhealthy)
- ✅ Displays chain ID if successful

#### 4. Check Testnet Wallet Balances
Requires `DEPLOYER_ADDRESS` in `.env` file.

For each testnet:
- Checks ETH balance of your wallet
- ✅ Green if balance > 0.01 ETH (Sufficient)
- ⚠️ Yellow if 0 < balance < 0.01 ETH (Low - claim more)
- ✗ Red if balance = 0 (Need funds)

#### 5. Display Faucet Information
Shows faucet URLs for all 7 testnets:
- **Base Sepolia**: https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet
- **Ethereum Sepolia**: https://sepoliafaucet.com
- **Arbitrum Sepolia**: https://faucet.quicknode.com/arbitrum/sepolia
- **Optimism Sepolia**: https://app.optimism.io/faucet
- **Polygon Mumbai**: https://faucet.polygon.technology
- **BSC Testnet**: https://testnet.bnbchain.org/faucet-smart
- **Zora Testnet**: https://testnet.bridge.zora.energy

#### 6. Integrate Proxy Patterns
Creates upgradeable contract infrastructure:
- Creates `contracts/proxy/KybersProxy.sol` - UUPS proxy implementation
- Creates `contracts/script/DeployProxy.s.sol` - Proxy deployment script
- Enables contract upgradeability for mainnet

#### 7. Compile Contracts
- Runs `forge build --sizes`
- Shows contract sizes
- Verifies all contracts compile successfully
- Logs output to `/tmp/forge-build.log`

#### 8. Run Tests
- Runs `forge test -vv`
- Counts test suites executed
- Verifies all tests pass
- Logs output to `/tmp/forge-test.log`

#### 9. Run Security Audit
- Runs Slither static analysis (if installed)
- Excludes dependencies and test files
- Checks for critical/high severity issues
- Displays security checklist:
  - ✓ Reentrancy guards
  - ✓ Safe token approval patterns
  - ✓ Access control
  - ✓ Input validation
  - ✓ Slippage protection
  - ✓ Emergency pause
  - ✓ Timelock

#### 10. Generate Deployment Report
Creates `DEPLOYMENT_READINESS.md` with:
- Foundry version information
- Dependency status
- RPC health status for all chains
- Contract compilation status
- Test suite results
- Security audit summary
- Testnet faucet links
- Security status checklist
- Next steps for deployment

### Output Example

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🚀 Foundry Updates & Testnet Deployment Automation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This script will:
  1. Install/Update Foundry
  2. Install dependencies
  3. Check testnet RPC health
  4. Check wallet balances
  5. Show faucet information
  6. Integrate proxy patterns
  7. Compile contracts
  8. Run tests
  9. Run security audit
  10. Generate deployment report

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. Installing/Updating Foundry
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Foundry updated to latest version
✓ Forge: forge 0.2.0 (abc1234 2024-01-01T00:00:00.000000000Z)
✓ Cast: cast 0.2.0 (abc1234 2024-01-01T00:00:00.000000000Z)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  3. Testnet RPC Health Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Checking base-sepolia...
✓ base-sepolia: Healthy (Chain ID: 84532)
ℹ Checking ethereum-sepolia...
✓ ethereum-sepolia: Healthy (Chain ID: 11155111)
✓ All testnet RPCs are healthy

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ All Checks Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Foundry is up to date
✓ Dependencies installed
✓ Contracts compiled
✓ Tests passing
✓ Security audit complete
✓ Deployment report generated

ℹ Next steps:
  1. Review DEPLOYMENT_READINESS.md
  2. Claim testnet ETH from faucets
  3. Run: ./scripts/testnet-deploy.sh <network>
  4. Follow TESTING_GUIDE.md for 7-day validation

✓ ALL RED FLAGS PASSED - READY FOR DEPLOYMENT
```

### Prerequisites
- Bash shell
- curl (for Foundry installation)
- Git
- `.env` file with `DEPLOYER_ADDRESS` (optional, for balance checks)

### Troubleshooting

**Issue**: "Foundry not found after installation"
**Solution**: Reload shell or run `export PATH="$HOME/.foundry/bin:$PATH"`

**Issue**: "RPC unhealthy"
**Solution**: Check internet connection, RPC may be temporarily down

**Issue**: "Balance check failed"
**Solution**: Set `DEPLOYER_ADDRESS` in `.env` file

---

## 📋 audit-verify.sh Usage

### Purpose
Comprehensive smart contract audit verification to ensure all security and quality checks pass before merging to main branch.

### Command
```bash
./scripts/audit-verify.sh
```

### What It Does

#### 1. Verify Contract Files Exist
Checks that all 8 production contracts are present:
- SwapRouter.sol
- PriceAggregator.sol
- DynamicFeeManager.sol
- TreasuryManager.sol
- AdminControl.sol
- MEVProtection.sol
- CrossChainRouter.sol
- PartnerAPI.sol

#### 2. Compile Contracts
- Runs `forge build`
- Verifies successful compilation
- Checks for compilation warnings
- Logs to `/tmp/audit-compile.log`

#### 3. Run All Tests
- Runs `forge test -vv`
- Counts passed and failed tests
- **Requires 100% passing rate**
- Logs to `/tmp/audit-tests.log`

#### 4. Check Code Coverage
- Runs `forge coverage`
- Extracts coverage percentage
- **Target: >90% coverage**
- Logs to `/tmp/audit-coverage.log`

#### 5. Security Audit Checks
Performs comprehensive security verification:
- **Reentrancy Protection**: Checks for `nonReentrant` modifier
- **SafeERC20 Usage**: Verifies safe token operations
- **Access Control**: Confirms `onlyOwner`/`onlyRole` modifiers
- **Unchecked Arithmetic**: Flags intentional unchecked blocks
- **Emergency Pause**: Verifies pause functionality exists

#### 6. Gas Optimization Analysis
- Runs `forge test --gas-report`
- Shows gas usage for key functions
- Reports on `executeSwap` and other critical functions
- Logs to `/tmp/audit-gas.log`

#### 7. Verify Security Audit Fixes
Confirms all documented security fixes:
- Checks `docs/SECURITY_AUDIT.md` exists
- Verifies fix 1: Unlimited token approval
- Verifies fix 2: Unrestricted fee collection
- Verifies fix 3: Minimum output validation
- Confirms 10/10 issues fixed (100%)

#### 8. Contract Size Verification
- Checks contract sizes with `forge build --sizes`
- **Limit: 24KB per contract**
- Warns if contracts near limit
- Logs to `/tmp/audit-sizes.log`

#### 9. Generate Audit Report
Creates `AUDIT_VERIFICATION_REPORT.md` with:
- Executive summary
- Contract file verification
- Compilation status
- Test results (passed/failed)
- Code coverage percentage
- Security audit status (10/10 fixed)
- Security features implemented
- Gas optimization status
- Contract sizes
- Pre-merge checklist
- Overall approval status

### Success Output

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎯 Audit Verification Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ✅  ALL CHECKS PASSED - CONTRACTS ARE GREEN FOR MERGE  ✅   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

✓ All 8 smart contracts verified and secure
✓ 10/10 security issues fixed (100%)
✓ All tests passing (100%)
✓ Ready for testnet deployment

ℹ Review AUDIT_VERIFICATION_REPORT.md for details
ℹ Next: Run ./scripts/foundry-updates.sh for testnet setup
```

### Failure Output

```bash
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ✗  SOME CHECKS FAILED - FIX ISSUES BEFORE MERGE  ✗          ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

✗ Review errors above and fix before merging
```

### Prerequisites
- Foundry installed
- All dependencies installed
- All contracts present in `/contracts`
- Documentation present in `/docs`

### When to Run
- **Before every merge to main branch**
- After fixing security vulnerabilities
- After making contract changes
- As part of CI/CD pipeline

### Exit Codes
- `0` - All checks passed (green for merge)
- `1` - Some checks failed (fix before merge)

---

## 🔄 Workflow Integration

### Complete Pre-Deployment Workflow

```bash
# Step 1: Run audit verification (MUST PASS)
./scripts/audit-verify.sh

# Step 2: If all green, run Foundry updates
./scripts/foundry-updates.sh

# Step 3: Review generated reports
cat AUDIT_VERIFICATION_REPORT.md
cat DEPLOYMENT_READINESS.md

# Step 4: Claim testnet ETH from faucets (if needed)
# Visit faucet URLs shown in foundry-updates.sh output

# Step 5: Deploy to testnet
./scripts/testnet-deploy.sh base-sepolia

# Step 6: Follow 7-day testing plan
# See docs/TESTING_GUIDE.md

# Step 7: Deploy to mainnet (after testing)
./scripts/mainnet-deploy.sh base
```

### CI/CD Integration

Add to `.github/workflows/pre-merge-audit.yml`:

```yaml
name: Pre-Merge Audit
on:
  pull_request:
    branches: [main]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
      - name: Run Audit Verification
        run: ./scripts/audit-verify.sh
      - name: Upload Audit Report
        uses: actions/upload-artifact@v4
        with:
          name: audit-report
          path: AUDIT_VERIFICATION_REPORT.md
```

---

## 📊 Reports Generated

### 1. DEPLOYMENT_READINESS.md
- Generated by `foundry-updates.sh`
- Contains Foundry versions, RPC health, faucet links
- Pre-deployment checklist
- Security status summary

### 2. AUDIT_VERIFICATION_REPORT.md
- Generated by `audit-verify.sh`
- Comprehensive audit results
- Security feature verification
- Test and coverage results
- Approval/rejection status

---

## 🔐 Security Considerations

### Audit Verification Ensures:
- ✅ No unlimited token approvals
- ✅ Authorization system for fee collection
- ✅ Comprehensive input validation
- ✅ Multi-hop route validation
- ✅ Minimum output protection
- ✅ MEV protection mechanisms
- ✅ Emergency pause functionality
- ✅ Reentrancy guards
- ✅ Safe token handling patterns

### Foundry Updates Enables:
- ✅ Testnet deployment readiness
- ✅ RPC health monitoring
- ✅ Wallet balance verification
- ✅ Proxy pattern integration
- ✅ Security audit automation
- ✅ Comprehensive testing

---

## 🎯 Success Criteria

### For Merge Approval (audit-verify.sh):
- ✅ All 8 contracts present
- ✅ All contracts compile
- ✅ 100% tests passing
- ✅ >90% code coverage
- ✅ 10/10 security issues fixed
- ✅ All contracts <24KB
- ✅ SafeERC20 used throughout
- ✅ Access control implemented

### For Testnet Deployment (foundry-updates.sh):
- ✅ Foundry installed and updated
- ✅ All dependencies present
- ✅ All testnets healthy
- ✅ Wallet funded on target chains
- ✅ Contracts compiled
- ✅ All tests passing
- ✅ Security audit clean

---

## 📞 Support

If you encounter issues:
1. Check prerequisites are installed
2. Review error messages in log files (`/tmp/audit-*.log`, `/tmp/forge-*.log`)
3. Ensure `.env` file is properly configured
4. Verify internet connectivity for RPC checks
5. Check GitHub Issues for similar problems

---

**Last Updated:** 2024-01-15  
**Scripts Version:** 1.0.0  
**Status:** ✅ Production Ready
