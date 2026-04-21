# Kybers DEX - Deployment Guide

## Prerequisites

Before deploying, ensure you have:

- **Node.js** 20+ installed
- **Foundry** installed (forge, cast, anvil)
- **Git** installed
- Private keys for deployment wallets
- RPC endpoints for target chains
- API keys for Etherscan, Alchemy, etc.
- **Vercel account** for frontend deployment

## Environment Setup

1. **Clone the repository**
```bash
git clone https://github.com/SMSDAO/kybers.git
cd kybers
```

2. **Copy environment template**
```bash
cp .env.example .env
```

3. **Configure environment variables**

Edit `.env` and add your values:

```bash
# Deployment
PRIVATE_KEY=your_private_key_here
DEPLOYER_PRIVATE_KEY=your_deployer_key_here

# RPC URLs
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY
BASE_RPC_URL=https://base-mainnet.g.alchemy.com/v2/YOUR_KEY
# ... other chains

# API Keys
ETHERSCAN_API_KEY=your_key
BASESCAN_API_KEY=your_key
# ... other explorers
```

## Smart Contract Deployment

### Step 1: Install Dependencies

```bash
# Install Foundry dependencies
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install foundry-rs/forge-std --no-commit
```

### Step 2: Compile Contracts

```bash
forge build
```

Expected output:
```
[⠊] Compiling...
[⠒] Compiling 51 files with 0.8.24
[⠢] Solc 0.8.24 finished in 2.31s
Compiler run successful!
```

### Step 3: Run Tests

```bash
forge test -vvv
```

All tests should pass before deployment.

### Step 4: Deploy to Testnet

```bash
# Deploy to Base Sepolia (testnet)
./scripts/deploy-contracts.sh testnet
```

This will:
- Deploy all 7 core contracts
- Verify contracts on Basescan
- Save deployment addresses to `deployment-addresses.txt`

### Step 5: Deploy to Mainnet

⚠️ **WARNING**: This will deploy to production networks and use real funds!

```bash
# Deploy to mainnet
./scripts/deploy-contracts.sh mainnet
```

This deploys to:
- Ethereum Mainnet
- Base
- Zora
- (Additional chains as configured)

### Step 6: Verify Deployment

```bash
# Check deployment addresses
cat deployment-addresses.txt

# Verify contracts are responding
forge verify-contract <contract_address> contracts/core/SwapRouter.sol:SwapRouter \
    --chain-id 1 \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

## Frontend Deployment (Next.js on Vercel)

The Kybers DEX frontend includes Next.js API routes for price aggregation and routing. Everything is deployed together as a single Next.js application on Vercel.

### Step 1: Install Dependencies

```bash
cd frontend
npm install
```

### Step 2: Configure Environment Variables

Create a `.env.local` file in the frontend directory:

```bash
# WalletConnect
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_id

# Infura/Alchemy
NEXT_PUBLIC_INFURA_ID=your_infura_id

# Contract Addresses (from smart contract deployment)
NEXT_PUBLIC_SWAP_ROUTER_ADDRESS=0x...
NEXT_PUBLIC_PRICE_AGGREGATOR_ADDRESS=0x...
# ... other contract addresses

# Application URL
NEXT_PUBLIC_APP_URL=https://kybers-dex.vercel.app
```

### Step 3: Build and Test Locally

```bash
npm run build
npm start
```

Visit `http://localhost:3000` to verify everything works.

### Step 4: Deploy to Vercel

**Option A: Vercel CLI**
```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy to preview
vercel

# Deploy to production
vercel --prod
```

**Option B: GitHub Integration (Recommended)**
1. Push your code to GitHub
2. Connect repository to Vercel
3. Vercel will automatically deploy on push to main branch

### Step 5: Configure Environment Variables in Vercel

In the Vercel dashboard, add these environment variables:
- `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID`
- `NEXT_PUBLIC_INFURA_ID`
- Contract addresses from deployment
- `NEXT_PUBLIC_APP_URL`

## API Routes

The following API routes are automatically deployed with the frontend:
- `/api/health` - Health check endpoint
- `/api/prices/[tokenIn]/[tokenOut]` - Price aggregation
- `/api/route/[tokenIn]/[tokenOut]/[amount]` - Optimal route calculation

These routes are serverless functions running on Vercel's Edge Network.

## Post-Deployment Verification

### 1. Test API Endpoints

```bash
# Health check
curl https://kybers-dex.vercel.app/api/health

# Price check (example)
curl https://kybers-dex.vercel.app/api/prices/[TOKEN_IN]/[TOKEN_OUT]
```

### 2. Register DEXs in PriceAggregator

```bash
cast send <PRICE_AGGREGATOR_ADDRESS> \
    "registerDex(address,uint256)" \
    <UNISWAP_V3_ADDRESS> \
    150000 \
    --private-key $PRIVATE_KEY \
    --rpc-url $BASE_RPC_URL
```

Repeat for all DEXs:
- Uniswap V3
- Sushiswap
- Curve
- Balancer
- etc.

### 3. Add DEXs to SwapRouter

```bash
cast send <SWAP_ROUTER_ADDRESS> \
    "addDex(address)" \
    <UNISWAP_V3_ADDRESS> \
    --private-key $PRIVATE_KEY \
    --rpc-url $BASE_RPC_URL
```

### 4. Configure Admin Roles

```bash
# Grant operator role
cast send <ADMIN_CONTROL_ADDRESS> \
    "grantOperatorRole(address)" \
    <OPERATOR_ADDRESS> \
    --private-key $PRIVATE_KEY \
    --rpc-url $BASE_RPC_URL

# Grant emergency role
cast send <ADMIN_CONTROL_ADDRESS> \
    "grantEmergencyRole(address)" \
    <EMERGENCY_ADDRESS> \
    --private-key $PRIVATE_KEY \
    --rpc-url $BASE_RPC_URL
```

### 5. Update Frontend Contract Addresses

Edit `frontend/lib/contracts.ts`:

```typescript
export const CONTRACTS = {
  swapRouter: '0x...',
  priceAggregator: '0x...',
  feeManager: '0x...',
  treasuryManager: '0x...',
  // ... other contracts
}
```

Redeploy frontend after updating.

## Monitoring and Health Checks

### Health Check Endpoints

The application exposes health check endpoints:
- Frontend: `GET /` (main page)
- API: `GET /api/health`

Configure your monitoring service (Vercel Analytics, Datadog, etc.) to monitor these endpoints.

### Vercel Analytics

Vercel provides built-in analytics for:
- Page views and performance
- API route usage and latency
- Edge function invocations
- Error tracking

Enable in the Vercel dashboard under Analytics.

## Security Checklist

Before going live:

- [ ] All contracts verified on block explorers
- [ ] Admin roles properly assigned
- [ ] Emergency roles configured
- [ ] MEV protection parameters set
- [ ] Rate limits configured
- [ ] Treasury address verified (gxqstudio.eth)
- [ ] Frontend environment variables set in Vercel
- [ ] SSL certificates configured (automatic with Vercel)
- [ ] DDoS protection enabled (Vercel provides this)
- [ ] Monitoring and alerts active
- [ ] API routes tested and responding correctly

## Testing Production

### 1. Test Swap on Testnet

```bash
# Get expected output
cast call <SWAP_ROUTER_ADDRESS> \
    "getExpectedOutput(address,address,uint256)" \
    <TOKEN_IN> <TOKEN_OUT> 1000000000000000000 \
    --rpc-url $BASE_RPC_URL

# Execute test swap (small amount)
# Use frontend or cast
```

### 2. Verify Fee Collection

```bash
# Check treasury balance
cast call <TREASURY_MANAGER_ADDRESS> \
    "getTokenBalance(address)" \
    0x0000000000000000000000000000000000000000 \
    --rpc-url $BASE_RPC_URL
```

### 3. Test Admin Functions

- Access admin dashboard
- Try updating fee configuration
- Test pause/unpause functionality
- Verify role-based access

## Rollback Procedure

If issues are detected:

### 1. Emergency Pause

```bash
cast send <SWAP_ROUTER_ADDRESS> \
    "pause()" \
    --private-key $EMERGENCY_PRIVATE_KEY \
    --rpc-url $BASE_RPC_URL
```

### 2. Roll Back Frontend

```bash
# Vercel rollback
vercel rollback

# Or manual
git revert HEAD
git push origin main
```

### 3. Fix and Redeploy

1. Identify and fix issue
2. Test thoroughly
3. Deploy fix
4. Unpause contracts

## Maintenance

### Regular Tasks

- **Daily**: Check monitoring alerts
- **Weekly**: Review security logs
- **Monthly**: Update dependencies
- **Quarterly**: Security audit

### Updating Contracts

Contract updates require new deployment since they're immutable:

1. Deploy new version
2. Migrate state if needed
3. Update frontend to use new addresses
4. Deprecate old contracts

## Support

For deployment issues:
- GitHub Issues: https://github.com/SMSDAO/kybers/issues
- Discord: https://discord.gg/kybers
- Email: support@kybers.io

## Appendix

### Useful Commands

```bash
# Check contract balance
cast balance <ADDRESS> --rpc-url $RPC_URL

# Get block number
cast block-number --rpc-url $RPC_URL

# Call read function
cast call <CONTRACT> "function()" --rpc-url $RPC_URL

# Send transaction
cast send <CONTRACT> "function()" --private-key $KEY --rpc-url $RPC_URL

# Decode transaction
cast decode "function(args)" <RETURN_DATA>
```

### Troubleshooting

**Issue**: Contract deployment fails

**Solution**: 
- Check private key has sufficient funds
- Verify RPC URL is correct
- Check gas price and limit

**Issue**: Frontend can't connect to contracts

**Solution**:
- Verify contract addresses in frontend config
- Check RPC endpoints
- Ensure correct chain selected

**Issue**: Tests failing

**Solution**:
- Run `forge install` to update dependencies
- Check Solidity version matches
- Review error messages for specific issues
