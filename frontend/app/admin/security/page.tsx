export default function AdminSecurityPage() {
  return (
    <div className="space-y-6">
      {/* System Status */}
      <div className="glass rounded-xl p-6 neon-border animate-glow">
        <h2 className="text-2xl font-bold text-neon-cyan mb-4">System Status</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="glass rounded-lg p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-neon-cyan/70">SwapRouter</span>
              <span className="w-2 h-2 rounded-full bg-neon-green animate-pulse"></span>
            </div>
            <div className="text-2xl font-bold text-neon-green">Active</div>
            <button className="mt-2 text-sm text-neon-pink hover:underline">Pause Contract</button>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-neon-cyan/70">PriceAggregator</span>
              <span className="w-2 h-2 rounded-full bg-neon-green animate-pulse"></span>
            </div>
            <div className="text-2xl font-bold text-neon-green">Active</div>
            <button className="mt-2 text-sm text-neon-pink hover:underline">Pause Contract</button>
          </div>
        </div>
      </div>

      {/* Emergency Controls */}
      <div className="glass rounded-xl p-6 neon-border border-neon-pink">
        <h3 className="text-xl font-bold text-neon-pink mb-4">🚨 Emergency Controls</h3>
        <div className="space-y-4">
          <div className="glass rounded-lg p-4 border-2 border-neon-pink/30">
            <div className="font-semibold text-neon-cyan mb-2">Emergency Shutdown</div>
            <p className="text-sm text-neon-cyan/70 mb-4">
              Immediately pause all swap operations. Use only in case of critical security issues.
            </p>
            <button className="w-full py-3 rounded-lg bg-gradient-to-r from-neon-pink to-red-600 text-white font-semibold hover:shadow-neon-pink transition-all duration-300">
              Emergency Shutdown
            </button>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="font-semibold text-neon-cyan mb-2">Resume Operations</div>
            <p className="text-sm text-neon-cyan/70 mb-4">
              Resume all swap operations after resolving security issues.
            </p>
            <button className="w-full py-3 rounded-lg bg-gradient-to-r from-neon-green to-green-600 text-white font-semibold hover:shadow-neon-green transition-all duration-300">
              Resume Operations
            </button>
          </div>
        </div>
      </div>

      {/* MEV Protection */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">MEV Protection</h3>
        <div className="space-y-4">
          <div className="glass rounded-lg p-4">
            <label className="block text-sm font-semibold text-neon-cyan mb-2">
              Rate Limit (seconds between txs)
            </label>
            <input
              type="number"
              defaultValue="2"
              className="w-full px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
          </div>
          
          <div className="glass rounded-lg p-4">
            <label className="block text-sm font-semibold text-neon-cyan mb-2">
              Max Transaction Size (ETH)
            </label>
            <input
              type="number"
              defaultValue="100"
              className="w-full px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
          </div>
          
          <div className="glass rounded-lg p-4">
            <label className="block text-sm font-semibold text-neon-cyan mb-2">
              Max Slippage Tolerance (%)
            </label>
            <input
              type="number"
              step="0.1"
              defaultValue="5"
              className="w-full px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
          </div>
          
          <button className="w-full py-3 rounded-lg btn-neon font-semibold">
            Update MEV Settings
          </button>
        </div>
      </div>

      {/* Blacklist Management */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Blacklist Management</h3>
        <div className="space-y-4">
          <div className="flex items-center space-x-4">
            <input
              type="text"
              placeholder="0x... address to blacklist"
              className="flex-1 px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
            />
            <button className="px-6 py-2 rounded-lg btn-neon">Add</button>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm font-semibold text-neon-cyan mb-2">Blacklisted Addresses</div>
            <div className="text-sm text-neon-cyan/50 text-center py-4">
              No blacklisted addresses
            </div>
          </div>
        </div>
      </div>

      {/* Security Logs */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Recent Security Events</h3>
        <div className="space-y-2">
          <div className="text-center py-8 text-neon-cyan/50">
            No security events recorded
          </div>
        </div>
      </div>
    </div>
  )
}
