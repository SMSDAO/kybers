'use client'

import { useState } from 'react'
import TokenInput from './TokenInput'
import SwapButton from './SwapButton'
import SlippageSettings from './SlippageSettings'

interface SwapCardProps {
  tokenIn: string
  tokenOut: string
  amountIn: string
  amountOut: string
  onTokenInChange: (token: string) => void
  onTokenOutChange: (token: string) => void
  onAmountInChange: (amount: string) => void
  onAmountOutChange: (amount: string) => void
}

export default function SwapCard({
  tokenIn,
  tokenOut,
  amountIn,
  amountOut,
  onTokenInChange,
  onTokenOutChange,
  onAmountInChange,
  onAmountOutChange,
}: SwapCardProps) {
  const [slippage, setSlippage] = useState<number>(0.5)
  const [showSettings, setShowSettings] = useState<boolean>(false)

  const handleSwap = async () => {
    console.log('Executing swap:', { tokenIn, tokenOut, amountIn, slippage })
    // TODO: Implement actual swap logic
  }

  const handleFlip = () => {
    onTokenInChange(tokenOut)
    onTokenOutChange(tokenIn)
    onAmountInChange(amountOut)
    onAmountOutChange(amountIn)
  }

  return (
    <div className="glass rounded-2xl p-6 neon-border">
      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-neon-cyan">Swap</h2>
        <button
          onClick={() => setShowSettings(!showSettings)}
          className="p-2 rounded-lg glass hover:glow-cyan transition-all duration-300"
        >
          <svg className="w-6 h-6 text-neon-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
        </button>
      </div>

      {/* Settings Panel */}
      {showSettings && (
        <div className="mb-6">
          <SlippageSettings value={slippage} onChange={setSlippage} />
        </div>
      )}

      {/* Token Input - From */}
      <div className="mb-2">
        <TokenInput
          label="From"
          token={tokenIn}
          amount={amountIn}
          onTokenChange={onTokenInChange}
          onAmountChange={onAmountInChange}
        />
      </div>

      {/* Swap Direction Button */}
      <div className="flex justify-center -my-4 relative z-10">
        <button
          onClick={handleFlip}
          className="p-3 rounded-full glass glow-purple hover:animate-glow transition-all duration-300"
        >
          <svg className="w-6 h-6 text-neon-purple" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
          </svg>
        </button>
      </div>

      {/* Token Input - To */}
      <div className="mb-6">
        <TokenInput
          label="To"
          token={tokenOut}
          amount={amountOut}
          onTokenChange={onTokenOutChange}
          onAmountChange={onAmountOutChange}
          readOnly
        />
      </div>

      {/* Price Info */}
      {amountIn && amountOut && (
        <div className="glass rounded-lg p-4 mb-6 space-y-2 text-sm">
          <div className="flex justify-between text-neon-cyan/70">
            <span>Rate</span>
            <span className="text-neon-cyan">1 {tokenIn} = {(parseFloat(amountOut) / parseFloat(amountIn)).toFixed(6)} {tokenOut}</span>
          </div>
          <div className="flex justify-between text-neon-cyan/70">
            <span>Fee (0.05%)</span>
            <span className="text-neon-green">{(parseFloat(amountIn) * 0.0005).toFixed(6)} {tokenIn}</span>
          </div>
          <div className="flex justify-between text-neon-cyan/70">
            <span>Price Impact</span>
            <span className="text-neon-pink">&lt; 0.1%</span>
          </div>
          <div className="flex justify-between text-neon-cyan/70">
            <span>Min Received</span>
            <span className="text-neon-cyan">{(parseFloat(amountOut) * (1 - slippage / 100)).toFixed(6)} {tokenOut}</span>
          </div>
        </div>
      )}

      {/* Swap Button */}
      <SwapButton onClick={handleSwap} disabled={!amountIn || !amountOut} />

      {/* Footer Info */}
      <div className="mt-4 text-center text-xs text-neon-cyan/50">
        <p>Aggregating from 15+ DEXs across 7 chains</p>
        <p>Fees auto-forward to gxqstudio.eth</p>
      </div>
    </div>
  )
}
