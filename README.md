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
cd ../services && npm install
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
# Using Docker Compose
docker-compose up -d

# Or run services individually
cd frontend && npm run dev
cd services && npm run dev
```

6. **Access the application**
- Frontend: http://localhost:3000
- Admin Dashboard: http://localhost:3000/admin
- Backend API: http://localhost:4000

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
│   ├── app/              # App router pages
│   │   ├── page.tsx      # Main swap interface
│   │   └── admin/        # Admin dashboard
│   ├── components/       # React components
│   │   ├── SwapCard.tsx
│   │   ├── TokenInput.tsx
│   │   ├── PriceComparison.tsx
│   │   └── RouteVisualizer.tsx
│   ├── lib/              # Web3 integration
│   ├── styles/           # CSS and themes
│   └── public/           # Static assets
│
├── services/              # Backend services
│   ├── aggregator/       # Price aggregation
│   ├── indexer/          # Blockchain indexer
│   ├── oracle/           # Oracle service
│   └── api/              # GraphQL API
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
├── infra/                 # Infrastructure
│   ├── docker/
│   └── kubernetes/
│
├── foundry.toml          # Foundry configuration
├── docker-compose.yml    # Docker orchestration
└── README.md             # This file
```

---

## 🛠️ Development

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

### Backend Services

```bash
cd services

# Start all services
npm run dev

# Run specific service
npm run aggregator
npm run indexer
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

### Complete Deployment

```bash
# Deploy everything (contracts + frontend + backend)
./scripts/deploy-all.sh

# Deploy to testnet
./scripts/deploy-all.sh testnet

# Deploy to mainnet
./scripts/deploy-all.sh mainnet
```

### Docker Deployment

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Kubernetes Deployment

```bash
# Apply configurations
kubectl apply -f infra/kubernetes/

# Check status
kubectl get pods

# View logs
kubectl logs -f deployment/kybers-frontend
```

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
