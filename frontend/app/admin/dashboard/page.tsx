export default function AdminDashboard() {
  return (
    <div className="space-y-6">
      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="glass rounded-xl p-6 neon-border animate-glow">
          <div className="text-sm text-neon-cyan/70 mb-2">Total Volume</div>
          <div className="text-3xl font-bold text-neon-green">$0</div>
          <div className="text-xs text-neon-cyan/50 mt-2">+0% from last week</div>
        </div>
        
        <div className="glass rounded-xl p-6 neon-border glow-purple">
          <div className="text-sm text-neon-cyan/70 mb-2">Total Fees Collected</div>
          <div className="text-3xl font-bold text-neon-purple">$0</div>
          <div className="text-xs text-neon-cyan/50 mt-2">0.05% average fee</div>
        </div>
        
        <div className="glass rounded-xl p-6 neon-border glow-pink">
          <div className="text-sm text-neon-cyan/70 mb-2">Active Users</div>
          <div className="text-3xl font-bold text-neon-pink">0</div>
          <div className="text-xs text-neon-cyan/50 mt-2">Last 24h</div>
        </div>
        
        <div className="glass rounded-xl p-6 neon-border glow-cyan">
          <div className="text-sm text-neon-cyan/70 mb-2">Total Swaps</div>
          <div className="text-3xl font-bold text-neon-cyan">0</div>
          <div className="text-xs text-neon-cyan/50 mt-2">All time</div>
        </div>
      </div>

      {/* DEX Performance */}
      <div className="glass rounded-xl p-6 neon-border">
        <h2 className="text-xl font-bold text-neon-cyan mb-4">DEX Performance</h2>
        <div className="space-y-3">
          {[
            { name: 'Uniswap V3', volume: '$0', trades: 0, color: 'neon-green' },
            { name: 'Sushiswap', volume: '$0', trades: 0, color: 'neon-purple' },
            { name: 'Curve', volume: '$0', trades: 0, color: 'neon-cyan' },
            { name: 'Balancer', volume: '$0', trades: 0, color: 'neon-pink' },
            { name: 'Kyber', volume: '$0', trades: 0, color: 'neon-green' },
          ].map((dex) => (
            <div key={dex.name} className="flex items-center justify-between p-4 rounded-lg glass">
              <div className="flex-1">
                <div className={`font-semibold text-${dex.color}`}>{dex.name}</div>
                <div className="text-sm text-neon-cyan/50">{dex.trades} trades</div>
              </div>
              <div className="text-right">
                <div className="font-bold text-neon-cyan">{dex.volume}</div>
                <div className="text-xs text-neon-cyan/50">Volume 24h</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Chain Distribution */}
      <div className="glass rounded-xl p-6 neon-border">
        <h2 className="text-xl font-bold text-neon-cyan mb-4">Chain Distribution</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { name: 'Ethereum', volume: '$0', color: 'neon-cyan' },
            { name: 'Base', volume: '$0', color: 'neon-purple' },
            { name: 'Zora', volume: '$0', color: 'neon-pink' },
            { name: 'Arbitrum', volume: '$0', color: 'neon-green' },
            { name: 'Optimism', volume: '$0', color: 'neon-cyan' },
            { name: 'Polygon', volume: '$0', color: 'neon-purple' },
            { name: 'BSC', volume: '$0', color: 'neon-pink' },
          ].map((chain) => (
            <div key={chain.name} className="glass rounded-lg p-4 text-center">
              <div className={`font-semibold text-${chain.color}`}>{chain.name}</div>
              <div className="text-2xl font-bold text-neon-cyan mt-2">{chain.volume}</div>
              <div className="text-xs text-neon-cyan/50 mt-1">24h Volume</div>
            </div>
          ))}
        </div>
      </div>

      {/* System Status */}
      <div className="glass rounded-xl p-6 neon-border">
        <h2 className="text-xl font-bold text-neon-cyan mb-4">System Status</h2>
        <div className="space-y-3">
          <div className="flex items-center justify-between p-4 rounded-lg glass">
            <span className="text-neon-cyan">Smart Contracts</span>
            <span className="text-neon-green flex items-center">
              <span className="w-2 h-2 rounded-full bg-neon-green mr-2 animate-pulse"></span>
              Operational
            </span>
          </div>
          <div className="flex items-center justify-between p-4 rounded-lg glass">
            <span className="text-neon-cyan">Price Aggregation</span>
            <span className="text-neon-green flex items-center">
              <span className="w-2 h-2 rounded-full bg-neon-green mr-2 animate-pulse"></span>
              Operational
            </span>
          </div>
          <div className="flex items-center justify-between p-4 rounded-lg glass">
            <span className="text-neon-cyan">Treasury Auto-Forward</span>
            <span className="text-neon-green flex items-center">
              <span className="w-2 h-2 rounded-full bg-neon-green mr-2 animate-pulse"></span>
              Active
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}
