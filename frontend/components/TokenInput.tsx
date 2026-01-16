'use client'

import { useState } from 'react'
import TokenSelector from './TokenSelector'

interface TokenInputProps {
  label: string
  token: string
  amount: string
  onTokenChange: (token: string) => void
  onAmountChange: (amount: string) => void
  readOnly?: boolean
}

export default function TokenInput({
  label,
  token,
  amount,
  onTokenChange,
  onAmountChange,
  readOnly = false,
}: TokenInputProps) {
  const [showSelector, setShowSelector] = useState(false)

  const handleAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value
    // Only allow numbers and decimals
    if (value === '' || /^\d*\.?\d*$/.test(value)) {
      onAmountChange(value)
    }
  }

  return (
    <>
      <div className="glass rounded-xl p-4 border-2 border-neon-purple/30 hover:border-neon-purple/60 transition-all duration-300">
        <div className="flex justify-between items-center mb-2">
          <span className="text-sm text-neon-cyan/70">{label}</span>
          <span className="text-xs text-neon-cyan/50">Balance: 0.0</span>
        </div>
        
        <div className="flex items-center space-x-4">
          {/* Token Selector */}
          <button
            onClick={() => setShowSelector(true)}
            className="flex items-center space-x-2 px-4 py-2 rounded-lg glass hover:glow-purple transition-all duration-300"
          >
            <div className="w-6 h-6 rounded-full bg-gradient-to-r from-neon-cyan to-neon-purple"></div>
            <span className="font-semibold text-neon-cyan">{token}</span>
            <svg className="w-4 h-4 text-neon-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
            </svg>
          </button>

          {/* Amount Input */}
          <input
            type="text"
            value={amount}
            onChange={handleAmountChange}
            placeholder="0.0"
            readOnly={readOnly}
            className="flex-1 bg-transparent text-right text-2xl font-bold text-neon-cyan outline-none placeholder-neon-cyan/30"
          />
        </div>
      </div>

      {/* Token Selector Modal */}
      {showSelector && (
        <TokenSelector
          onSelect={(selectedToken) => {
            onTokenChange(selectedToken)
            setShowSelector(false)
          }}
          onClose={() => setShowSelector(false)}
        />
      )}
    </>
  )
}
