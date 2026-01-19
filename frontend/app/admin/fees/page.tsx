export default function AdminFeesPage() {
  return (
    <div className="space-y-6">
      <div className="glass rounded-xl p-6 neon-border">
        <h2 className="text-2xl font-bold text-neon-cyan mb-6">Dynamic Fee Management</h2>
        
        {/* Current Fee Configuration */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Base Fee</div>
            <div className="text-3xl font-bold text-neon-green">0.05%</div>
            <div className="text-xs text-neon-cyan/50 mt-1">5 basis points</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Congestion Adj.</div>
            <div className="text-3xl font-bold text-neon-purple">+0.00%</div>
            <div className="text-xs text-neon-cyan/50 mt-1">Network based</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Max Fee Cap</div>
            <div className="text-3xl font-bold text-neon-pink">0.30%</div>
            <div className="text-xs text-neon-cyan/50 mt-1">30 basis points</div>
          </div>
        </div>

        {/* Fee Adjustments */}
        <div className="space-y-4">
          <div className="glass rounded-lg p-4">
            <label className="block text-sm font-semibold text-neon-cyan mb-2">
              Congestion Adjustment
            </label>
            <input
              type="number"
              step="0.01"
              defaultValue="0.00"
              className="w-full px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
            <p className="text-xs text-neon-cyan/50 mt-2">
              Adjust fee based on network congestion (±0.02%)
            </p>
          </div>

          <div className="glass rounded-lg p-4">
            <label className="block text-sm font-semibold text-neon-cyan mb-2">
              Volatility Adjustment
            </label>
            <input
              type="number"
              step="0.01"
              defaultValue="0.00"
              className="w-full px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
            <p className="text-xs text-neon-cyan/50 mt-2">
              Adjust fee based on market volatility
            </p>
          </div>

          <button className="w-full py-3 rounded-lg btn-neon animate-glow font-semibold">
            Update Fee Configuration
          </button>
        </div>
      </div>

      {/* Fee Exemptions */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Fee Exemptions</h3>
        <div className="space-y-3">
          <div className="flex items-center space-x-4 p-4 rounded-lg glass">
            <input
              type="text"
              placeholder="0x... address"
              className="flex-1 px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
            <button className="px-6 py-2 rounded-lg btn-neon">Add</button>
          </div>
          
          <div className="text-sm text-neon-cyan/50 text-center">
            No exempted addresses
          </div>
        </div>
      </div>

      {/* User Tiers */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Volume Discount Tiers</h3>
        <div className="space-y-3">
          <div className="flex justify-between items-center p-4 rounded-lg glass">
            <div>
              <div className="font-semibold text-neon-cyan">Tier 1</div>
              <div className="text-sm text-neon-cyan/70">≥ 100,000 volume</div>
            </div>
            <div className="text-neon-green font-bold">-0.01% discount</div>
          </div>
          
          <div className="flex justify-between items-center p-4 rounded-lg glass">
            <div>
              <div className="font-semibold text-neon-cyan">Tier 2</div>
              <div className="text-sm text-neon-cyan/70">≥ 500,000 volume</div>
            </div>
            <div className="text-neon-green font-bold">-0.02% discount</div>
          </div>
          
          <div className="flex justify-between items-center p-4 rounded-lg glass">
            <div>
              <div className="font-semibold text-neon-cyan">Tier 3</div>
              <div className="text-sm text-neon-cyan/70">≥ 1,000,000 volume</div>
            </div>
            <div className="text-neon-green font-bold">-0.03% discount</div>
          </div>
        </div>
      </div>
    </div>
  )
}
