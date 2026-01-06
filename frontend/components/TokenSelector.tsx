'use client'

interface TokenSelectorProps {
  onSelect: (token: string) => void
  onClose: () => void
}

const POPULAR_TOKENS = [
  { symbol: 'ETH', name: 'Ethereum', icon: '🔷' },
  { symbol: 'USDC', name: 'USD Coin', icon: '💵' },
  { symbol: 'USDT', name: 'Tether', icon: '💰' },
  { symbol: 'DAI', name: 'Dai Stablecoin', icon: '🟡' },
  { symbol: 'WETH', name: 'Wrapped Ether', icon: '🔶' },
  { symbol: 'WBTC', name: 'Wrapped Bitcoin', icon: '🟠' },
]

export default function TokenSelector({ onSelect, onClose }: TokenSelectorProps) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm">
      <div className="glass rounded-2xl p-6 w-full max-w-md neon-border animate-glow">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <h3 className="text-xl font-bold text-neon-cyan">Select Token</h3>
          <button
            onClick={onClose}
            className="p-2 rounded-lg glass hover:glow-pink transition-all duration-300"
          >
            <svg className="w-6 h-6 text-neon-pink" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Search */}
        <div className="mb-4">
          <input
            type="text"
            placeholder="Search token..."
            className="w-full px-4 py-3 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan placeholder-neon-cyan/30"
          />
        </div>

        {/* Token List */}
        <div className="space-y-2 max-h-96 overflow-y-auto">
          {POPULAR_TOKENS.map((token) => (
            <button
              key={token.symbol}
              onClick={() => onSelect(token.symbol)}
              className="w-full flex items-center space-x-4 p-4 rounded-lg glass hover:glow-cyan transition-all duration-300"
            >
              <div className="text-3xl">{token.icon}</div>
              <div className="flex-1 text-left">
                <div className="font-semibold text-neon-cyan">{token.symbol}</div>
                <div className="text-sm text-neon-cyan/50">{token.name}</div>
              </div>
              <div className="text-right">
                <div className="text-sm text-neon-green">$1,234.56</div>
                <div className="text-xs text-neon-cyan/50">0.0</div>
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
