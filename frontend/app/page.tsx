import SwapInterface from '@/components/SwapInterface'

export default function Home() {
  return (
    <main className="min-h-screen p-4 md:p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <header className="mb-8 md:mb-12">
          <div className="text-center mb-8">
            <h1 className="text-4xl md:text-6xl font-bold holographic mb-4">
              KYBERS DEX
            </h1>
            <p className="text-neon-cyan text-lg md:text-xl">
              Advanced Multi-Chain DEX Aggregator
            </p>
          </div>
          
          {/* Stats Bar */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <div className="glass p-4 rounded-lg text-center animate-glow">
              <div className="text-2xl font-bold text-neon-green">15+</div>
              <div className="text-sm text-neon-cyan/70">DEXs</div>
            </div>
            <div className="glass p-4 rounded-lg text-center glow-purple">
              <div className="text-2xl font-bold text-neon-purple">7</div>
              <div className="text-sm text-neon-cyan/70">Chains</div>
            </div>
            <div className="glass p-4 rounded-lg text-center glow-pink">
              <div className="text-2xl font-bold text-neon-pink">0.05%</div>
              <div className="text-sm text-neon-cyan/70">Base Fee</div>
            </div>
            <div className="glass p-4 rounded-lg text-center glow-cyan">
              <div className="text-2xl font-bold text-neon-cyan">$0</div>
              <div className="text-sm text-neon-cyan/70">Volume 24h</div>
            </div>
          </div>
        </header>

        {/* Main Swap Interface */}
        <SwapInterface />

        {/* Footer */}
        <footer className="mt-12 text-center text-neon-cyan/50 text-sm">
          <p>Powered by gxqstudio.eth | Fees auto-forwarded to Treasury</p>
          <p className="mt-2">Supporting Ethereum, Base, Zora, Arbitrum, Optimism, Polygon, BSC</p>
        </footer>
      </div>
    </main>
  )
}
