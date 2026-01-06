'use client'

interface RouteVisualizerProps {
  tokenIn: string
  tokenOut: string
}

export default function RouteVisualizer({ tokenIn, tokenOut }: RouteVisualizerProps) {
  return (
    <div className="glass rounded-xl p-4 neon-border">
      <h3 className="text-lg font-bold text-neon-cyan mb-4">Optimal Route</h3>
      
      <div className="space-y-3">
        {/* Route Path */}
        <div className="flex items-center justify-center space-x-2">
          {/* Start Token */}
          <div className="flex flex-col items-center">
            <div className="w-12 h-12 rounded-full bg-gradient-to-r from-neon-cyan to-neon-purple flex items-center justify-center glass">
              <span className="text-xs font-bold">{tokenIn}</span>
            </div>
          </div>

          {/* Arrow with DEX */}
          <div className="flex-1 flex flex-col items-center">
            <div className="w-full h-1 bg-gradient-to-r from-neon-cyan via-neon-purple to-neon-pink animate-shimmer"></div>
            <div className="text-xs text-neon-purple mt-1">Uniswap V3</div>
          </div>

          {/* End Token */}
          <div className="flex flex-col items-center">
            <div className="w-12 h-12 rounded-full bg-gradient-to-r from-neon-purple to-neon-pink flex items-center justify-center glass">
              <span className="text-xs font-bold">{tokenOut}</span>
            </div>
          </div>
        </div>

        {/* Route Details */}
        <div className="glass rounded-lg p-3 space-y-2 text-sm">
          <div className="flex justify-between">
            <span className="text-neon-cyan/70">Route Type</span>
            <span className="text-neon-green">Direct</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neon-cyan/70">Hops</span>
            <span className="text-neon-cyan">1</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neon-cyan/70">Gas Estimate</span>
            <span className="text-neon-cyan">~150k</span>
          </div>
          <div className="flex justify-between">
            <span className="text-neon-cyan/70">Price Impact</span>
            <span className="text-neon-green">&lt; 0.1%</span>
          </div>
        </div>

        {/* Best Price Badge */}
        <div className="bg-gradient-to-r from-neon-green/20 to-neon-cyan/20 rounded-lg p-2 text-center">
          <span className="text-xs text-neon-green font-semibold">
            ✓ Best route selected from 15+ DEXs
          </span>
        </div>
      </div>
    </div>
  )
}
