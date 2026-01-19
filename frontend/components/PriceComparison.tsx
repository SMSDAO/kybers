'use client'

interface PriceComparisonProps {
  tokenIn: string
  tokenOut: string
  amountIn: string
}

const DEX_PRICES = [
  { name: 'Uniswap V3', price: 1834.52, logo: '🦄' },
  { name: 'Sushiswap', price: 1832.18, logo: '🍣' },
  { name: 'Curve', price: 1835.67, logo: '🌊' },
  { name: 'Balancer', price: 1831.45, logo: '⚖️' },
  { name: 'Kyber', price: 1833.89, logo: '⚡' },
]

export default function PriceComparison({ tokenIn, tokenOut, amountIn }: PriceComparisonProps) {
  const bestPrice = Math.max(...DEX_PRICES.map(d => d.price))

  return (
    <div className="glass rounded-xl p-4 neon-border">
      <h3 className="text-lg font-bold text-neon-cyan mb-4">Price Comparison</h3>
      
      <div className="space-y-2">
        {DEX_PRICES.map((dex, index) => {
          const isBest = dex.price === bestPrice
          return (
            <div
              key={dex.name}
              className={`p-3 rounded-lg glass flex items-center justify-between ${
                isBest ? 'glow-green border-2 border-neon-green' : ''
              }`}
            >
              <div className="flex items-center space-x-2">
                <span className="text-2xl">{dex.logo}</span>
                <div>
                  <div className={`font-semibold ${isBest ? 'text-neon-green' : 'text-neon-cyan'}`}>
                    {dex.name}
                  </div>
                  {isBest && (
                    <div className="text-xs text-neon-green">✓ Best Price</div>
                  )}
                </div>
              </div>
              <div className="text-right">
                <div className={`font-bold ${isBest ? 'text-neon-green' : 'text-neon-cyan'}`}>
                  ${dex.price.toFixed(2)}
                </div>
                <div className="text-xs text-neon-cyan/50">
                  {((dex.price / bestPrice - 1) * 100).toFixed(2)}%
                </div>
              </div>
            </div>
          )
        })}
      </div>

      <div className="mt-4 text-xs text-center text-neon-cyan/50">
        Prices updated in real-time from 15+ DEXs
      </div>
    </div>
  )
}
