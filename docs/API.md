# Kybers DEX - API Documentation

## Overview

The Kybers DEX API provides programmatic access to price aggregation, swap routing, and platform analytics.

**Base URL**: `https://api.kybers.io` (Production)  
**Base URL**: `http://localhost:4000` (Development)

## Authentication

Most endpoints are public and don't require authentication. Admin endpoints require authentication via JWT token.

```bash
# Admin endpoints require Bearer token
Authorization: Bearer <your_jwt_token>
```

## Rate Limiting

- Public endpoints: 100 requests/minute
- Authenticated: 1000 requests/minute

## Endpoints

### Price & Routing

#### GET /api/prices/:tokenIn/:tokenOut

Get current prices for a token pair across all DEXs.

**Parameters:**
- `tokenIn` (path) - Input token address
- `tokenOut` (path) - Output token address

**Response:**
```json
{
  "tokenIn": "0x...",
  "tokenOut": "0x...",
  "prices": [
    {
      "dex": "Uniswap V3",
      "price": 1834.52,
      "liquidity": 1000000,
      "gasEstimate": 150000
    },
    {
      "dex": "Sushiswap",
      "price": 1832.18,
      "liquidity": 500000,
      "gasEstimate": 145000
    }
  ],
  "bestPrice": 1835.67,
  "bestDex": "Curve",
  "timestamp": "2024-01-06T12:00:00Z"
}
```

**Example:**
```bash
curl https://api.kybers.io/api/prices/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
```

#### GET /api/route/:tokenIn/:tokenOut/:amount

Get optimal route for a swap with expected output.

**Parameters:**
- `tokenIn` (path) - Input token address
- `tokenOut` (path) - Output token address
- `amount` (path) - Input amount in wei

**Query Parameters:**
- `slippage` (optional) - Slippage tolerance (default: 0.5)

**Response:**
```json
{
  "route": [
    {
      "dex": "Uniswap V3",
      "percentage": 70,
      "tokenIn": "0x...",
      "tokenOut": "0x...",
      "expectedAmount": "1283.56"
    },
    {
      "dex": "Sushiswap",
      "percentage": 30,
      "tokenIn": "0x...",
      "tokenOut": "0x...",
      "expectedAmount": "550.10"
    }
  ],
  "expectedOutput": "1833.66",
  "priceImpact": 0.05,
  "gasEstimate": 275000,
  "fee": "0.9168",
  "minReceived": "1824.89"
}
```

**Example:**
```bash
curl "https://api.kybers.io/api/route/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48/1000000000000000000?slippage=0.5"
```

### Swap History

#### GET /api/swaps

Get recent swap history.

**Query Parameters:**
- `user` (optional) - Filter by user address
- `limit` (optional) - Number of results (default: 50, max: 100)
- `offset` (optional) - Pagination offset

**Response:**
```json
{
  "swaps": [
    {
      "id": "0x123...",
      "user": "0xabc...",
      "tokenIn": "0x...",
      "tokenOut": "0x...",
      "amountIn": "1000000000000000000",
      "amountOut": "1834520000",
      "fee": "500000000000000",
      "route": ["Uniswap V3"],
      "timestamp": "2024-01-06T12:00:00Z",
      "txHash": "0x..."
    }
  ],
  "total": 1234,
  "page": 1,
  "hasMore": true
}
```

#### GET /api/swaps/:txHash

Get details of a specific swap transaction.

**Response:**
```json
{
  "id": "0x123...",
  "user": "0xabc...",
  "tokenIn": {
    "address": "0x...",
    "symbol": "ETH",
    "decimals": 18
  },
  "tokenOut": {
    "address": "0x...",
    "symbol": "USDC",
    "decimals": 6
  },
  "amountIn": "1000000000000000000",
  "amountOut": "1834520000",
  "fee": "500000000000000",
  "route": [
    {
      "dex": "Uniswap V3",
      "tokenIn": "0x...",
      "tokenOut": "0x...",
      "amountIn": "1000000000000000000",
      "amountOut": "1834520000"
    }
  ],
  "priceImpact": 0.05,
  "gasUsed": 151234,
  "timestamp": "2024-01-06T12:00:00Z",
  "status": "success"
}
```

### Analytics

#### GET /api/analytics/volume

Get trading volume statistics.

**Query Parameters:**
- `period` - Time period: `24h`, `7d`, `30d`, `all` (default: `24h`)
- `chain` (optional) - Filter by chain ID

**Response:**
```json
{
  "period": "24h",
  "volume": "12345678.90",
  "volumeUSD": "22695522.02",
  "trades": 1234,
  "uniqueUsers": 567,
  "byChain": [
    {
      "chainId": 1,
      "chainName": "Ethereum",
      "volume": "5678901.23",
      "volumeUSD": "10439164.26",
      "trades": 456
    }
  ],
  "byDex": [
    {
      "dex": "Uniswap V3",
      "volume": "7890123.45",
      "volumeUSD": "14502343.54",
      "trades": 789
    }
  ]
}
```

#### GET /api/analytics/fees

Get fee collection statistics.

**Response:**
```json
{
  "totalCollected": "61.73",
  "totalCollectedUSD": "113477.61",
  "totalForwarded": "50.00",
  "totalForwardedUSD": "91925.00",
  "pending": "11.73",
  "pendingUSD": "21552.61",
  "byToken": [
    {
      "token": "ETH",
      "collected": "30.5",
      "forwarded": "25.0",
      "pending": "5.5"
    }
  ]
}
```

#### GET /api/analytics/dexs

Get DEX performance metrics.

**Response:**
```json
{
  "dexes": [
    {
      "name": "Uniswap V3",
      "volume24h": "5000000.00",
      "trades24h": 500,
      "avgSlippage": 0.05,
      "avgGas": 150000,
      "uptime": 99.9
    }
  ]
}
```

### Treasury

#### GET /api/treasury/balance

Get current treasury balance.

**Response:**
```json
{
  "address": "0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e",
  "ens": "gxqstudio.eth",
  "balances": [
    {
      "token": "ETH",
      "balance": "50.5",
      "balanceUSD": "92817.50"
    },
    {
      "token": "USDC",
      "balance": "10000.00",
      "balanceUSD": "10000.00"
    }
  ],
  "totalUSD": "102817.50"
}
```

### Admin Endpoints

All admin endpoints require authentication.

#### POST /api/admin/fees/update

Update fee configuration.

**Request:**
```json
{
  "congestionAdjustment": 0.02,
  "volatilityAdjustment": 0.01
}
```

**Response:**
```json
{
  "success": true,
  "newConfig": {
    "baseFee": 0.05,
    "congestionAdjustment": 0.02,
    "volatilityAdjustment": 0.01,
    "effectiveFee": 0.08
  }
}
```

#### POST /api/admin/security/pause

Pause all swap operations.

**Response:**
```json
{
  "success": true,
  "paused": true,
  "timestamp": "2024-01-06T12:00:00Z"
}
```

#### POST /api/admin/security/unpause

Resume swap operations.

**Response:**
```json
{
  "success": true,
  "paused": false,
  "timestamp": "2024-01-06T12:00:00Z"
}
```

## WebSocket API

Real-time price updates via WebSocket.

**Endpoint**: `wss://api.kybers.io/ws`

### Subscribe to Price Updates

```javascript
const ws = new WebSocket('wss://api.kybers.io/ws');

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'subscribe',
    channel: 'prices',
    tokens: ['ETH/USDC', 'ETH/DAI']
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Price update:', data);
};
```

**Message Format:**
```json
{
  "type": "price_update",
  "pair": "ETH/USDC",
  "price": 1834.52,
  "dex": "Uniswap V3",
  "timestamp": "2024-01-06T12:00:00Z"
}
```

## Error Handling

All errors follow this format:

```json
{
  "error": {
    "code": "INVALID_TOKEN",
    "message": "Token address is invalid",
    "details": {
      "token": "0xinvalid"
    }
  }
}
```

**Error Codes:**
- `INVALID_TOKEN` - Invalid token address
- `INSUFFICIENT_LIQUIDITY` - Not enough liquidity
- `SLIPPAGE_EXCEEDED` - Slippage too high
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `UNAUTHORIZED` - Authentication required
- `CONTRACT_PAUSED` - Swaps are paused

## SDKs

### JavaScript/TypeScript

```bash
npm install @kybers/sdk
```

```typescript
import { KybersSDK } from '@kybers/sdk';

const kybers = new KybersSDK({
  apiKey: 'your_api_key',
  network: 'mainnet'
});

// Get best price
const price = await kybers.getBestPrice('ETH', 'USDC', '1');

// Get route
const route = await kybers.getRoute('ETH', 'USDC', '1');

// Execute swap
const tx = await kybers.executeSwap({
  tokenIn: 'ETH',
  tokenOut: 'USDC',
  amount: '1',
  slippage: 0.5
});
```

## Rate Limits

| Endpoint | Rate Limit |
|----------|------------|
| Public APIs | 100/minute |
| Authenticated | 1000/minute |
| WebSocket | 10 connections |

## Support

- Documentation: https://docs.kybers.io
- API Status: https://status.kybers.io
- Discord: https://discord.gg/kybers
- Email: api@kybers.io
