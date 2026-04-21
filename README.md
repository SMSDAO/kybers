# 🔷 KYBERS DEX - Advanced Multi-Chain Aggregator

<div align="center">

![Kybers DEX](https://img.shields.io/badge/DEX-Kybers-00fff9?style=for-the-badge&logo=ethereum)
![Solidity](https://img.shields.io/badge/Solidity-0.8.24-b537f2?style=for-the-badge&logo=solidity)
![Next.js](https://img.shields.io/badge/Next.js-15-black?style=for-the-badge&logo=next.js)
![License](https://img.shields.io/badge/License-MIT-39ff14?style=for-the-badge)

**Complete production-ready advanced DEX infrastructure with 15+ DEX aggregation, neo glow cyberpunk UI, dynamic fee system, and complete automation.**

[Demo](https://kybers-dex.vercel.app) • [Docs](#documentation) • [Admin Panel](#admin-dashboard)

</div>

---

## ✨ Features

### 🔥 Smart Contract Suite (Solidity 0.8.24+)

- **SwapRouter** - Aggregates liquidity from 15+ DEXs with intelligent routing
- **PriceAggregator** - Real-time price comparison and best route selection
- **DynamicFeeManager** - 0.05% base fee with dynamic adjustments
- **TreasuryManager** - Auto-forwards fees to `gxqstudio.eth`
- **AdminControl** - Role-based access control with timelock
- **MEVProtection** - Frontrunning and sandwich attack prevention
- **CrossChainRouter** - Multi-chain support (7 chains)

### 🎨 Neo Glow Cyberpunk UI

- **Glassmorphism** design with backdrop blur effects
- **Animated Neon Glows** on hover and focus
- **Holographic Shimmer** effects on price updates
- **Particle Effects** for successful swaps
- **Responsive Design** - Mobile-first approach
- **Dark Theme** with neon cyan, purple, pink, and green accents

### 🌐 Multi-Chain Support

- Ethereum Mainnet
- Base (Primary)
- Zora (Primary Target)
- Arbitrum
- Optimism
- Polygon
- BSC

### 📊 Admin Dashboard

- Real-time metrics and analytics
- Dynamic fee management
- Treasury monitoring (gxqstudio.eth)
- Security controls (pause/unpause)
- Contract management
- User role management

---

## 🚀 Quick Start

### Prerequisites

- Node.js 20+
- Foundry
- Docker & Docker Compose
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/SMSDAO/kybers.git
cd kybers
```

2. **Install dependencies**
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Node dependencies
cd frontend && npm install
cd ..
```

3. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Build smart contracts**
```bash
forge build
forge test
```

5. **Start development environment**
```bash
# Start the Next.js development server
cd frontend && npm run dev
```

6. **Access the application**
- Frontend: http://localhost:3000
- Admin Dashboard: http://localhost:3000/admin
- API Routes: http://localhost:3000/api/*

---

## 📁 Project Structure

```
kybers/
├── contracts/              # Smart contracts (Solidity 0.8.24+)
│   ├── core/              # Main contracts
│   │   ├── SwapRouter.sol
│   │   ├── PriceAggregator.sol
│   │   ├── DynamicFeeManager.sol
│   │   ├── TreasuryManager.sol
│   │   └── CrossChainRouter.sol
│   ├── admin/             # Admin contracts
│   │   └── AdminControl.sol
│   ├── security/          # Security contracts
│   │   └── MEVProtection.sol
│   ├── interfaces/        # Contract interfaces
│   ├── libraries/         # Reusable libraries
│   ├── test/             # Contract tests
│   └── script/           # Deployment scripts
│
├── frontend/              # Next.js 15 + React 19 UI
│   ├── app/              # App router
│   │   ├── page.tsx      # Main swap interface
│   │   ├── admin/        # Admin dashboard
│   │   ├── partner/      # Partner program pages
│   │   └── api/          # Next.js API routes
│   │       ├── health/   # Health check endpoint
│   │       ├── prices/   # Price aggregation API
│   │       └── route/    # Route optimization API
│   ├── components/       # React components
│   │   ├── SwapCard.tsx
│   │   ├── TokenInput.tsx
│   │   ├── PriceComparison.tsx
│   │   └── RouteVisualizer.tsx
│   ├── src/              # Core application logic
│   ├── lib/              # Web3 integration
│   ├── styles/           # CSS and themes
│   └── public/           # Static assets
│
├── .github/workflows/     # CI/CD pipelines
│   ├── test-contracts.yml
│   ├── deploy-contracts.yml
│   ├── deploy-frontend.yml
│   └── security-scan.yml
│
├── scripts/               # Automation scripts
│   ├── deploy-all.sh
│   └── deploy-contracts.sh
│
├── docs/                  # Documentation
│   ├── API.md
│   ├── DEPLOYMENT.md
│   ├── TESTING_GUIDE.md
│   └── ...
│
├── foundry.toml          # Foundry configuration
├── package.json          # Root package configuration
└── README.md             # This file
```

---

## 🛠️ Development

### Master Build Script

The `master.sh` script provides a comprehensive build and test pipeline:

```bash
# Run complete pipeline (clean, install, build, test, lint, verify, security)
./scripts/master.sh all

# Individual commands
./scripts/master.sh install   # Install all dependencies
./scripts/master.sh clean     # Clean build artifacts and lock files
./scripts/master.sh build     # Build all components
./scripts/master.sh test      # Run all tests
./scripts/master.sh verify    # Run build verification (10-step check)
./scripts/master.sh lint      # Run linters
./scripts/master.sh security  # Run security scans
./scripts/master.sh help      # Show help
```

**Key Features:**
- ✅ Automated dependency installation (Foundry + npm)
- ✅ Color-coded output for easy monitoring
- ✅ Comprehensive error handling
- ✅ Modular command structure

### Foundry Updates & Testnet Deployment Script 🆕

The `foundry-updates.sh` script provides complete Foundry setup and testnet deployment preparation:

```bash
# Run complete Foundry setup and testnet preparation
./scripts/foundry-updates.sh

# This comprehensive script will:
# 1. Install/Update Foundry (forge, cast, anvil)
# 2. Install OpenZeppelin and forge-std dependencies
# 3. Check RPC health for all 7 testnets (Base, Ethereum, Arbitrum, Optimism, Polygon, BSC, Zora)
# 4. Check wallet balance on all testnets
# 5. Display faucet URLs for claiming testnet ETH
# 6. Integrate UUPS proxy patterns for upgradeable contracts
# 7. Compile all contracts with size reports
# 8. Run complete test suite
# 9. Run Slither security analysis
# 10. Generate DEPLOYMENT_READINESS.md report
```

**Testnet RPCs Monitored:**
- Base Sepolia - https://sepolia.base.org
- Ethereum Sepolia - https://rpc.sepolia.org
- Arbitrum Sepolia - https://sepolia-rollup.arbitrum.io/rpc
- Optimism Sepolia - https://sepolia.optimism.io
- Polygon Mumbai - https://rpc-mumbai.maticvigil.com
- BSC Testnet - https://data-seed-prebsc-1-s1.binance.org:8545
- Zora Testnet - https://testnet.rpc.zora.energy

**Testnet Faucets Included:**
- Automatic faucet URL display for all chains
- Balance checking for wallet preparation
- Claims testnet ETH for deployment gas

### Complete Audit Verification Script 🆕

The `audit-verify.sh` script ensures all smart contracts are secure and ready for merge:

```bash
# Run complete audit verification (MUST BE GREEN before merge)
./scripts/audit-verify.sh

# Comprehensive verification includes:
# 1. Verify all 8 contract files exist
# 2. Compile all contracts successfully
# 3. Run complete test suite (100% passing)
# 4. Check code coverage (>95% target)
# 5. Security audit verification
#    - Reentrancy protection
#    - SafeERC20 usage
#    - Access control
#    - Emergency pause functionality
# 6. Gas optimization analysis
# 7. Verify all 10 security fixes documented
# 8. Check contract sizes (<24KB limit)
# 9. Generate AUDIT_VERIFICATION_REPORT.md
```

**Security Checks Performed:**
- ✅ Reentrancy guards on external functions
- ✅ SafeERC20 for all token operations
- ✅ Access control modifiers (onlyOwner, onlyRole)
- ✅ No unchecked arithmetic vulnerabilities
- ✅ Emergency pause functionality present
- ✅ All 10 security issues from audit fixed (100%)

**Output:**
```bash
# Success output (ALL GREEN):
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ✅  ALL CHECKS PASSED - CONTRACTS ARE GREEN FOR MERGE  ✅   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```
- ✅ Comprehensive build verification (10 steps)
- ✅ Clean build artifacts and lock files
- ✅ Run all tests (contracts, frontend, backend)
- ✅ Security scans (Slither, npm audit)
- ✅ Linting and formatting checks
- ✅ Color-coded output for easy debugging

### Smart Contracts

```bash
# Compile contracts
forge build

# Run tests
forge test -vvv

# Generate coverage report
forge coverage

# Run gas report
forge test --gas-report

# Deploy to testnet
./scripts/deploy-contracts.sh testnet

# Deploy to mainnet
./scripts/deploy-contracts.sh mainnet
```

### Frontend

```bash
cd frontend

# Development server
npm run dev

# Build for production
npm run build

# Run production server
npm start

# Lint code
npm run lint
```

### Next.js API Routes

The backend API has been consolidated into Next.js API routes:

```bash
# API routes are automatically available when running the dev server
cd frontend && npm run dev

# API endpoints available at:
# - GET /api/health - Health check
# - GET /api/prices/[tokenIn]/[tokenOut] - Get token prices
# - GET /api/route/[tokenIn]/[tokenOut]/[amount] - Get optimal swap route
```

---

## 🎨 UI Components

### Neo Glow Theme

The UI features a custom cyberpunk theme with:

- **Colors**: Neon cyan (#00fff9), purple (#b537f2), green (#39ff14), pink (#ff006e)
- **Glassmorphism**: Semi-transparent cards with backdrop blur
- **Animated Glows**: Pulsing box-shadow effects
- **Holographic Text**: Gradient animations
- **Grid Background**: Animated cyberpunk grid pattern

### Key Components

- **SwapCard** - Main trading interface with glassmorphic design
- **TokenInput** - Token selection and amount input
- **PriceComparison** - Real-time price display across DEXs
- **RouteVisualizer** - Visual representation of swap routes
- **AdminDashboard** - Complete admin control panel

---

## 🔒 Security

### Smart Contract Security

- **Audited**: OpenZeppelin contracts used as base
- **MEV Protection**: Built-in frontrunning protection
- **Rate Limiting**: Per-address transaction limits
- **Emergency Pause**: Admin can pause contracts
- **Timelock**: 24-hour delay on critical operations

### Security Scanning

```bash
# Run Slither
slither contracts/

# Run Mythril
myth analyze contracts/core/*.sol

# Dependency check
npm audit
```

---

## 📊 Fee Structure

- **Base Fee**: 0.05% (5 basis points)
- **Maximum Fee**: 0.3% (30 basis points)
- **Dynamic Adjustments**:
  - Network congestion: ±0.02%
  - Volume discounts available
  - Liquidity depth adjustments

**All fees automatically forward to**: `gxqstudio.eth` (0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e)

---

## 🚢 Deployment

### Build Verification (Required First)

```bash
# Run comprehensive build verification before deployment
./scripts/build-verify.sh

# Must pass all checks (all green ✓) before proceeding
```

### Testnet Deployment

```bash
# Deploy to testnet (contracts remain same for mainnet migration)
./scripts/testnet-deploy.sh base-sepolia

# Supported testnets:
# - base-sepolia (Base Testnet)
# - sepolia (Ethereum Testnet)
# - arbitrum-sepolia (Arbitrum Testnet)
# - optimism-sepolia (Optimism Testnet)
# - polygon-mumbai (Polygon Testnet)
# - bsc-testnet (BSC Testnet)

# After deployment, test thoroughly using TESTING_GUIDE.md
```

### Mainnet Deployment

```bash
# ⚠️ PRODUCTION DEPLOYMENT - Use with extreme care
# Contracts must be identical to tested testnet deployment

# Deploy to mainnet
./scripts/mainnet-deploy.sh ethereum
./scripts/mainnet-deploy.sh base
./scripts/mainnet-deploy.sh zora
# ... other chains

# Requires triple confirmation and comprehensive pre-checks
```

### Complete Deployment (All Services)

```bash
# Deploy everything (contracts + frontend + backend)
./scripts/deploy-all.sh

# Production launch with monitoring
./scripts/launch-production.sh production
```

### Vercel Deployment (Recommended)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy to Vercel
cd frontend
vercel

# Deploy to production
vercel --prod
```

The application is optimized for Vercel deployment with Next.js 15. The frontend and API routes are deployed together as a single application.

---

## 📈 Monitoring & Analytics

### Admin Dashboard Features

- **Volume Tracking**: Real-time 24h volume
- **Fee Collection**: Total fees collected per chain
- **DEX Performance**: Individual DEX metrics
- **Chain Distribution**: Volume breakdown by chain
- **System Status**: Contract and service health
- **User Analytics**: Active users and transaction counts

---

## 🧪 Testing & Validation

### Comprehensive Testing

```bash
# Build verification (prerequisite for deployment)
./scripts/build-verify.sh

# Run all contract tests
forge test -vvv

# Generate coverage report
forge coverage

# Run security scans
slither contracts/
```

### Testing Documentation

- **[Complete Testing Guide](docs/TESTING_GUIDE.md)** - Comprehensive testing procedures
- **[Contract Integrity](docs/CONTRACT_INTEGRITY.md)** - Ensures code consistency testnet→mainnet
- **[Security Audit](docs/SECURITY_AUDIT.md)** - Full security audit report (10/10 issues fixed)
- **[Audit Changes](AUDIT_CHANGES.md)** - Detailed security fixes summary

### Pre-Launch Verification

```bash
# Run pre-launch checks (50+ automated checks)
./scripts/pre-launch-verify.sh

# All checks must pass before mainnet deployment
```

---

## 📚 Documentation

### Core Documentation

- **[README.md](README.md)** - This file (project overview)
- **[SMART_CONTRACTS.md](docs/SMART_CONTRACTS.md)** - Contract reference
- **[DEPLOYMENT.md](docs/DEPLOYMENT.md)** - Deployment guide
- **[API.md](docs/API.md)** - API documentation
- **[TOKENOMICS.md](docs/TOKENOMICS.md)** - Fee structure & partner program

### Security & Testing

- **[SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md)** - Security audit report
- **[TESTING_GUIDE.md](docs/TESTING_GUIDE.md)** - Complete testing procedures
- **[CONTRACT_INTEGRITY.md](docs/CONTRACT_INTEGRITY.md)** - Code consistency verification

### Implementation

- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Implementation overview
- **[AUDIT_CHANGES.md](AUDIT_CHANGES.md)** - Security fixes summary
- **[Landing Page](docs/index.html)** - Cyberpunk-themed docs portal

---

## 🔐 Security Features

### Security Audit Status

✅ **Complete** - All 10 issues fixed (100% resolution)

| Severity | Count | Status |
|----------|-------|--------|
| Critical | 3 | ✅ Fixed |
| High | 2 | ✅ Fixed |
| Medium | 3 | ✅ Fixed |
| Low | 2 | ✅ Fixed |

### Security Enhancements

- ✅ Safe token approval patterns (reset before/after)
- ✅ Authorization system for fee collection
- ✅ Comprehensive input validation
- ✅ Multi-hop route validation (max 4 hops)
- ✅ Minimum output protection (1% slippage)
- ✅ MEV protection (rate limiting, blacklisting)
- ✅ Emergency pause functionality
- ✅ Reentrancy guards
- ✅ 24-hour timelock for critical operations

### Running Security Scans

```bash
# Static analysis with Slither
slither contracts/

# Symbolic execution with Mythril
myth analyze contracts/core/*.sol

# Manual security review
# See docs/SECURITY_AUDIT.md for checklist
```

---

## 🔗 Integrated DEXs

1. Uniswap V2 & V3
2. Sushiswap
3. Curve Finance
4. Balancer
5. Kyber Network
6. 1inch
7. PancakeSwap
8. QuickSwap
9. Trader Joe
10. Velodrome (Base)
11. Aerodrome (Base)
12. Additional DEXs...

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **OpenZeppelin** - Smart contract libraries
- **Foundry** - Smart contract development toolkit
- **Next.js** - React framework
- **Vercel** - Frontend hosting
- **gxqstudio.eth** - Treasury and project sponsor

---

## 📞 Support

- **Website**: [kybers-dex.vercel.app](https://kybers-dex.vercel.app)
- **Twitter**: [@KybersDEX](https://twitter.com/KybersDEX)
- **Discord**: [Join our community](https://discord.gg/kybers)
- **Docs**: [docs.kybers.io](https://docs.kybers.io)

---

<div align="center">

**Built with ❤️ by gxqstudio.eth**

⭐ Star us on GitHub — it motivates us a lot!

</div>
# Kybers DEX
