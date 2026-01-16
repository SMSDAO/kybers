export default function AdminTreasuryPage() {
  const TREASURY_ADDRESS = '0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e'

  return (
    <div className="space-y-6">
      {/* Treasury Info */}
      <div className="glass rounded-xl p-6 neon-border animate-glow">
        <h2 className="text-2xl font-bold text-neon-cyan mb-4">Treasury Monitor</h2>
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-neon-cyan/70">Treasury Address</span>
            <div className="flex items-center space-x-2">
              <span className="font-mono text-neon-cyan">{TREASURY_ADDRESS.slice(0, 10)}...{TREASURY_ADDRESS.slice(-8)}</span>
              <button className="p-2 rounded-lg glass hover:glow-cyan transition-all duration-300">
                <svg className="w-4 h-4 text-neon-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
              </button>
            </div>
          </div>
          
          <div className="flex items-center justify-between">
            <span className="text-neon-cyan/70">ENS Name</span>
            <span className="font-semibold text-neon-green">gxqstudio.eth</span>
          </div>
        </div>
      </div>

      {/* Balance Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="glass rounded-xl p-6 neon-border glow-green">
          <div className="text-sm text-neon-cyan/70 mb-2">Total ETH Collected</div>
          <div className="text-3xl font-bold text-neon-green">0.00 ETH</div>
          <div className="text-xs text-neon-cyan/50 mt-2">All time</div>
        </div>
        
        <div className="glass rounded-xl p-6 neon-border glow-purple">
          <div className="text-sm text-neon-cyan/70 mb-2">Total USD Value</div>
          <div className="text-3xl font-bold text-neon-purple">$0.00</div>
          <div className="text-xs text-neon-cyan/50 mt-2">Approximate</div>
        </div>
        
        <div className="glass rounded-xl p-6 neon-border glow-cyan">
          <div className="text-sm text-neon-cyan/70 mb-2">Last Forward</div>
          <div className="text-3xl font-bold text-neon-cyan">Never</div>
          <div className="text-xs text-neon-cyan/50 mt-2">Timestamp</div>
        </div>
      </div>

      {/* Token Balances */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Token Balances</h3>
        <div className="space-y-3">
          {[
            { token: 'ETH', accumulated: '0.00', forwarded: '0.00', pending: '0.00' },
            { token: 'USDC', accumulated: '0.00', forwarded: '0.00', pending: '0.00' },
            { token: 'USDT', accumulated: '0.00', forwarded: '0.00', pending: '0.00' },
            { token: 'DAI', accumulated: '0.00', forwarded: '0.00', pending: '0.00' },
          ].map((item) => (
            <div key={item.token} className="flex items-center justify-between p-4 rounded-lg glass">
              <div className="flex items-center space-x-4">
                <div className="w-10 h-10 rounded-full bg-gradient-to-r from-neon-cyan to-neon-purple flex items-center justify-center">
                  <span className="text-xs font-bold">{item.token.slice(0, 2)}</span>
                </div>
                <div>
                  <div className="font-semibold text-neon-cyan">{item.token}</div>
                  <div className="text-xs text-neon-cyan/50">Pending: {item.pending}</div>
                </div>
              </div>
              <div className="text-right">
                <div className="text-sm text-neon-cyan">Acc: {item.accumulated}</div>
                <div className="text-xs text-neon-green">Fwd: {item.forwarded}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Forward Controls */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Manual Controls</h3>
        <div className="space-y-4">
          <button className="w-full py-3 rounded-lg btn-neon animate-glow font-semibold">
            Forward All Pending Fees
          </button>
          
          <div className="grid grid-cols-2 gap-4">
            <button className="py-3 rounded-lg glass hover:glow-cyan transition-all duration-300 text-neon-cyan font-semibold">
              Forward ETH Only
            </button>
            <button className="py-3 rounded-lg glass hover:glow-purple transition-all duration-300 text-neon-cyan font-semibold">
              Forward Tokens Only
            </button>
          </div>
        </div>
      </div>

      {/* Recent Forwards */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Recent Forwards</h3>
        <div className="text-center py-8 text-neon-cyan/50">
          No recent forwards
        </div>
      </div>
    </div>
  )
}
