'use client'

import { useState } from 'react'
import SwapCard from './SwapCard'
import PriceComparison from './PriceComparison'
import RouteVisualizer from './RouteVisualizer'

export default function SwapInterface() {
  const [tokenIn, setTokenIn] = useState<string>('ETH')
  const [tokenOut, setTokenOut] = useState<string>('USDC')
  const [amountIn, setAmountIn] = useState<string>('')
  const [amountOut, setAmountOut] = useState<string>('')

  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
      {/* Main Swap Card */}
      <div className="lg:col-span-2">
        <SwapCard
          tokenIn={tokenIn}
          tokenOut={tokenOut}
          amountIn={amountIn}
          amountOut={amountOut}
          onTokenInChange={setTokenIn}
          onTokenOutChange={setTokenOut}
          onAmountInChange={setAmountIn}
          onAmountOutChange={setAmountOut}
        />
      </div>

      {/* Side Panel */}
      <div className="space-y-6">
        {/* Route Visualizer */}
        <RouteVisualizer
          tokenIn={tokenIn}
          tokenOut={tokenOut}
        />

        {/* Price Comparison */}
        <PriceComparison
          tokenIn={tokenIn}
          tokenOut={tokenOut}
          amountIn={amountIn}
        />
      </div>
    </div>
  )
}
