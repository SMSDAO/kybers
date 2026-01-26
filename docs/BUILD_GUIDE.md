# Build & Development Guide

Complete guide for building, testing, and developing the Kybers DEX platform.

## Quick Start

```bash
# 1. Clone repository
git clone https://github.com/SMSDAO/kybers.git
cd kybers

# 2. Install all dependencies
./scripts/master.sh install

# 3. Build everything
./scripts/master.sh build

# 4. Run tests
./scripts/master.sh test

# 5. Verify build
./scripts/master.sh verify
```

## Prerequisites

### Required Tools

1. **Node.js & npm**
   ```bash
   # Version 20 or higher required
   node --version  # Should be >= 20.0.0
   npm --version   # Should be >= 9.0.0
   
   # Install Node.js 20
   curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

2. **Foundry** (Smart Contracts)
   ```bash
   # Install Foundry
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   
   # Verify installation
   forge --version
   cast --version
   anvil --version
   ```

3. **Git**
   ```bash
   git --version  # Should be >= 2.0
   ```

4. **Optional: Docker** (For smart contract testing with anvil)
   ```bash
   docker --version
   ```

## Project Structure

```
kybers/
├── package.json              # Root package configuration
├── contracts/                # Smart contracts (Foundry)
├── frontend/                 # Next.js application + API routes
│   ├── app/                  # Next.js App Router
│   │   ├── api/              # API routes (serverless)
│   │   ├── admin/            # Admin dashboard
│   │   └── partner/          # Partner program
│   ├── components/           # React components
│   └── package.json
├── scripts/                  # Build & deploy scripts
└── .github/workflows/        # CI/CD pipelines
```

## Building Components

### 1. Smart Contracts

```bash
# Navigate to root
cd /path/to/kybers

# Install Foundry dependencies
forge install

# Compile contracts
forge build

# Check contract sizes
forge build --sizes

# Expected output:
# ✅ All contracts compiled successfully
# ✅ All contracts under 24KB limit
```

**Troubleshooting:**
```bash
# If forge not found:
curl -L https://foundry.paradigm.xyz | bash
foundryup

# If compilation fails:
forge clean
forge build

# Check remappings:
cat remappings.txt
```

### 2. Frontend (Next.js)

```bash
# Navigate to frontend
cd frontend

# Install dependencies
npm install

# Build for production
npm run build

# Expected output:
# ✅ Compiled successfully
# ✅ Static pages generated
# ✅ Build artifacts in .next/
```

**Troubleshooting:**
```bash
# Clear cache and rebuild
rm -rf .next node_modules
npm install
npm run build

# Fix dependency issues
npm audit fix
npm update

# Check for peer dependency issues
npm list
```

### 3. Classic Interface (App)

```bash
# Navigate to app
cd app

# No build required! Pure HTML/CSS/JS
# Just serve the files:
python3 -m http.server 8000

# Or use npm script
npm start
```

### 4. Backend Services

```bash
# Navigate to services
cd services

# Install dependencies
npm install

# Build TypeScript
npm run build

# Expected output:
# ✅ TypeScript compiled
# ✅ Build artifacts in dist/
```

## Master Build Script

The `master.sh` script provides a unified build pipeline:

```bash
# Run everything
./scripts/master.sh all

# Individual commands
./scripts/master.sh install   # Install dependencies
./scripts/master.sh clean     # Clean build artifacts
./scripts/master.sh build     # Build all components
./scripts/master.sh test      # Run all tests
./scripts/master.sh lint      # Run linters
./scripts/master.sh verify    # 10-step verification
./scripts/master.sh security  # Security scans
```

### Build Verification Steps

The `verify` command runs 10 critical checks:

1. ✅ Node.js and npm installed
2. ✅ Foundry (forge, cast, anvil) installed
3. ✅ Git repository valid
4. ✅ Dependencies installed
5. ✅ Smart contracts compile
6. ✅ Frontend builds successfully
7. ✅ Contract sizes under limits
8. ✅ Tests pass
9. ✅ No critical security issues
10. ✅ Documentation up-to-date

## Testing

### Smart Contract Tests

```bash
# Run all tests
forge test

# Verbose output
forge test -vvv

# Specific test
forge test --match-test testSwapExactTokensForTokens

# Gas report
forge test --gas-report

# Coverage
forge coverage
```

### Frontend Tests

```bash
cd frontend

# Run tests
npm run test

# Watch mode
npm run test:watch

# Coverage
npm run test:coverage
```

### Integration Tests

```bash
# Run all tests across components
npm run test

# Includes:
# - Contract tests (forge)
# - Frontend tests (Jest)
# - Services tests (Jest)
```

## Development Workflow

### 1. Local Development

```bash
# Terminal 1: Local blockchain
anvil

# Terminal 2: Deploy contracts
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast

# Terminal 3: Frontend dev server
cd frontend
npm run dev

# Terminal 4: Backend services
cd services
npm run dev
```

### 2. Making Changes

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes
# ... edit files ...

# 3. Format code
npm run format

# 4. Lint code
npm run lint

# 5. Run tests
npm run test

# 6. Build verification
./scripts/master.sh verify

# 7. Commit changes
git add .
git commit -m "feat: add my feature"

# 8. Push and create PR
git push origin feature/my-feature
```

### 3. Pre-Commit Checklist

- [ ] Code formatted (`npm run format`)
- [ ] No linting errors (`npm run lint`)
- [ ] Tests pass (`npm run test`)
- [ ] Contracts compile (`forge build`)
- [ ] Documentation updated
- [ ] Build verification passes (`./scripts/master.sh verify`)

## Common Issues & Solutions

### Issue: `forge: not found`

**Solution:**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
export PATH="$HOME/.foundry/bin:$PATH"
```

### Issue: `npm install` fails

**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and lock file
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

### Issue: Build runs out of memory

**Solution:**
```bash
# Increase Node.js memory
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

### Issue: Port already in use

**Solution:**
```bash
# Frontend (default 3000)
PORT=3001 npm run dev

# Backend (default 4000)
PORT=4001 npm run dev

# App (default 8000)
python3 -m http.server 8001
```

### Issue: Contract size exceeds limit

**Solution:**
```bash
# Enable optimizer in foundry.toml
[profile.default]
optimizer = true
optimizer_runs = 200

# Rebuild
forge clean
forge build --sizes
```

## CI/CD Integration

### GitHub Actions Workflows

1. **Test Contracts** (`.github/workflows/test-contracts.yml`)
   - Runs on every push to main/develop
   - Compiles contracts
   - Runs test suite
   - Generates coverage report

2. **Deploy Frontend** (`.github/workflows/deploy-frontend.yml`)
   - Deploys to Vercel on push to main
   - Runs Lighthouse CI

3. **Deploy Contracts** (`.github/workflows/deploy-contracts.yml`)
   - Deploys to testnet/mainnet
   - Requires manual approval

4. **Security Scan** (`.github/workflows/security-scan.yml`)
   - Runs Slither on contracts
   - npm audit for dependencies

### Running CI Locally

```bash
# Install act (GitHub Actions local runner)
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow locally
act -j test
```

## Performance Optimization

### Smart Contracts
- Enable optimizer in `foundry.toml`
- Minimize storage operations
- Use events for logging
- Batch operations where possible

### Frontend
- Enable Next.js image optimization
- Use code splitting
- Implement lazy loading
- Enable SSR for critical pages

### Build Time
- Use npm/yarn cache
- Parallelize builds
- Skip unnecessary rebuilds

## Vercel Deployment

The frontend (including API routes) is deployed to Vercel:

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel --prod
```

Or use GitHub integration for automatic deployments.

## Production Build

```bash
# Complete production build
./scripts/deploy-all.sh

# This will:
# 1. Run full verification
# 2. Build contracts
# 3. Build frontend
# 4. Build backend
# 5. Run security scans
# 6. Generate deployment artifacts
```

## Environment Variables

### Frontend (.env.local)
```bash
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_project_id
NEXT_PUBLIC_ALCHEMY_KEY=your_alchemy_key
NEXT_PUBLIC_INFURA_KEY=your_infura_key
```

### Contracts (.env)
```bash
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_key
RPC_URL=https://mainnet.infura.io/v3/your_key
```

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Wagmi Documentation](https://wagmi.sh/)
- [Project Wiki](https://github.com/SMSDAO/kybers/wiki)

## Support

If you encounter build issues:

1. Check this guide first
2. Search [existing issues](https://github.com/SMSDAO/kybers/issues)
3. Join community discussions (see project README for links)
4. Create a [new issue](https://github.com/SMSDAO/kybers/issues/new)

---

**Last Updated**: 2026-01-20
**Maintainer**: gxqstudio.eth
