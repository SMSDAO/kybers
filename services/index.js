const express = require('express');
const cors = require('cors');
const { createServer } = require('http');

const app = express();
const httpServer = createServer(app);

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'kybers-backend',
    timestamp: new Date().toISOString(),
  });
});

// API routes
app.get('/api/prices/:tokenIn/:tokenOut', async (req, res) => {
  const { tokenIn, tokenOut } = req.params;
  
  // TODO: Implement price aggregation
  res.json({
    tokenIn,
    tokenOut,
    prices: [
      { dex: 'Uniswap V3', price: 1834.52 },
      { dex: 'Sushiswap', price: 1832.18 },
      { dex: 'Curve', price: 1835.67 },
    ],
    bestPrice: 1835.67,
    bestDex: 'Curve',
  });
});

app.get('/api/route/:tokenIn/:tokenOut/:amount', async (req, res) => {
  const { tokenIn, tokenOut, amount } = req.params;
  
  // TODO: Implement route calculation
  res.json({
    route: [
      { dex: 'Uniswap V3', percentage: 100 },
    ],
    expectedOutput: parseFloat(amount) * 1834.52,
    priceImpact: 0.05,
    gasEstimate: 150000,
  });
});

const PORT = process.env.PORT || 4000;

httpServer.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
});

module.exports = app;
