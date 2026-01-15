# Kybers DEX API Documentation

## Base URL
```
https://api.kybers.dex/v1
```

## Authentication
All API requests require an API key passed in the header:
```
X-API-Key: your_api_key_here
```

## Endpoints

### Market Data

#### GET /markets
Get all available trading pairs

**Response:**
```json
{
  "pairs": [
    {
      "pair": "ETH/USDT",
      "price": 2500.00,
      "volume_24h": 1250000,
      "change_24h": 5.2
    }
  ]
}
```

#### GET /markets/:pair/ticker
Get ticker data for a specific pair

**Parameters:**
- `pair` - Trading pair (e.g., ETH-USDT)

**Response:**
```json
{
  "pair": "ETH/USDT",
  "last_price": 2500.00,
  "bid": 2499.50,
  "ask": 2500.50,
  "volume_24h": 1250000,
  "high_24h": 2550.00,
  "low_24h": 2450.00
}
```

### Trading

#### POST /swap/quote
Get a quote for a token swap

**Body:**
```json
{
  "from_token": "0x...",
  "to_token": "0x...",
  "amount": "1000000000000000000"
}
```

**Response:**
```json
{
  "from_amount": "1.0",
  "to_amount": "2500.0",
  "price": 2500.0,
  "price_impact": 0.1,
  "fee": 0.003,
  "route": ["ETH", "USDT"]
}
```

#### POST /swap/execute
Execute a token swap

**Body:**
```json
{
  "from_token": "0x...",
  "to_token": "0x...",
  "amount": "1000000000000000000",
  "slippage": 0.5,
  "deadline": 1234567890
}
```

**Response:**
```json
{
  "tx_hash": "0x...",
  "status": "pending"
}
```

### Liquidity Pools

#### GET /pools
Get all liquidity pools

**Response:**
```json
{
  "pools": [
    {
      "pair": "ETH/USDT",
      "tvl": 25500000,
      "volume_24h": 1250000,
      "apr": 12.5,
      "token0": "0x...",
      "token1": "0x..."
    }
  ]
}
```

#### POST /pools/add
Add liquidity to a pool

**Body:**
```json
{
  "token0": "0x...",
  "token1": "0x...",
  "amount0": "1000000000000000000",
  "amount1": "2500000000000000000000"
}
```

**Response:**
```json
{
  "tx_hash": "0x...",
  "lp_tokens": "100.5",
  "status": "pending"
}
```

### User

#### GET /user/:address/balance
Get token balances for an address

**Parameters:**
- `address` - User wallet address

**Response:**
```json
{
  "address": "0x...",
  "balances": [
    {
      "token": "ETH",
      "balance": "2.5",
      "value_usd": 6250.00
    }
  ]
}
```

#### GET /user/:address/transactions
Get transaction history

**Parameters:**
- `address` - User wallet address
- `limit` - Number of transactions (default: 50)
- `offset` - Pagination offset

**Response:**
```json
{
  "transactions": [
    {
      "hash": "0x...",
      "type": "swap",
      "from_token": "ETH",
      "to_token": "USDT",
      "amount": "1.0",
      "timestamp": 1234567890,
      "status": "confirmed"
    }
  ]
}
```

## WebSocket API

### Connection
```
wss://ws.kybers.dex/v1
```

### Subscribe to price updates
```json
{
  "action": "subscribe",
  "channel": "prices",
  "pairs": ["ETH-USDT", "BTC-USDT"]
}
```

### Price update message
```json
{
  "channel": "prices",
  "pair": "ETH-USDT",
  "price": 2500.00,
  "timestamp": 1234567890
}
```

## Rate Limits

- Public endpoints: 100 requests per minute
- Authenticated endpoints: 500 requests per minute

## Error Codes

- `400` - Bad Request
- `401` - Unauthorized
- `429` - Rate Limit Exceeded
- `500` - Internal Server Error

## Support

For API support, contact: api@kybers.dex
