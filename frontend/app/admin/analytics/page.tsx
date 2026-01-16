'use client'

export default function AdminAnalyticsPage() {
  return (
    <div className="space-y-6">
      {/* Analytics Overview */}
      <div className="glass rounded-xl p-6 neon-border animate-glow">
        <h2 className="text-2xl font-bold text-neon-cyan mb-4">Advanced Analytics</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">24h Volume</div>
            <div className="text-3xl font-bold text-neon-green">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">+0% vs yesterday</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">24h Fees</div>
            <div className="text-3xl font-bold text-neon-purple">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">+0% vs yesterday</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Active Users</div>
            <div className="text-3xl font-bold text-neon-cyan">0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">Last 24h</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Avg Trade Size</div>
            <div className="text-3xl font-bold text-neon-pink">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">Last 24h</div>
          </div>
        </div>
      </div>

      {/* Time Range Selector */}
      <div className="glass rounded-xl p-4 neon-border">
        <div className="flex items-center justify-between flex-wrap gap-4">
          <div className="flex items-center space-x-2">
            <span className="text-neon-cyan/70 text-sm">Time Range:</span>
            <div className="flex space-x-2">
              {['24H', '7D', '30D', '90D', '1Y', 'ALL'].map((range) => (
                <button
                  key={range}
                  className={`px-4 py-2 rounded-lg glass text-sm font-semibold transition-all ${
                    range === '24H' ? 'glow-cyan text-neon-cyan' : 'text-neon-cyan/70 hover:text-neon-cyan'
                  }`}
                >
                  {range}
                </button>
              ))}
            </div>
          </div>
          
          <button className="px-4 py-2 rounded-lg btn-neon text-sm">
            Export Data
          </button>
        </div>
      </div>

      {/* Volume Chart */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Volume Over Time</h3>
        <div className="h-64 flex items-center justify-center border-2 border-neon-cyan/20 rounded-lg">
          <div className="text-center">
            <svg className="w-16 h-16 mx-auto text-neon-cyan/30 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
            <p className="text-neon-cyan/50">Volume chart will appear here</p>
            <p className="text-sm text-neon-cyan/30 mt-2">Once swap data is available</p>
          </div>
        </div>
      </div>

      {/* Top Tokens */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Top Trading Pairs</h3>
        <div className="space-y-3">
          {[
            { pair: 'ETH/USDC', volume: '$0', trades: 0, change: '+0%', color: 'neon-green' },
            { pair: 'WETH/DAI', volume: '$0', trades: 0, change: '+0%', color: 'neon-purple' },
            { pair: 'USDC/USDT', volume: '$0', trades: 0, change: '+0%', color: 'neon-cyan' },
            { pair: 'WBTC/ETH', volume: '$0', trades: 0, change: '+0%', color: 'neon-pink' },
            { pair: 'DAI/USDC', volume: '$0', trades: 0, change: '+0%', color: 'neon-green' },
          ].map((token, idx) => (
            <div key={token.pair} className="flex items-center justify-between p-4 rounded-lg glass">
              <div className="flex items-center space-x-4">
                <div className="w-8 h-8 rounded-full bg-gradient-to-r from-neon-cyan to-neon-purple flex items-center justify-center text-xs font-bold">
                  #{idx + 1}
                </div>
                <div>
                  <div className={`font-semibold text-${token.color}`}>{token.pair}</div>
                  <div className="text-sm text-neon-cyan/50">{token.trades} trades</div>
                </div>
              </div>
              <div className="text-right">
                <div className="font-bold text-neon-cyan">{token.volume}</div>
                <div className="text-xs text-neon-green">{token.change}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* User Analytics */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* New vs Returning Users */}
        <div className="glass rounded-xl p-6 neon-border">
          <h3 className="text-xl font-bold text-neon-cyan mb-4">User Distribution</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 rounded-lg glass">
              <div>
                <div className="text-neon-cyan/70 text-sm">New Users</div>
                <div className="text-2xl font-bold text-neon-green">0</div>
              </div>
              <div className="text-4xl text-neon-green/30">
                <svg className="w-12 h-12" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M8 9a3 3 0 100-6 3 3 0 000 6zM8 11a6 6 0 016 6H2a6 6 0 016-6zM16 7a1 1 0 10-2 0v1h-1a1 1 0 100 2h1v1a1 1 0 102 0v-1h1a1 1 0 100-2h-1V7z" />
                </svg>
              </div>
            </div>
            
            <div className="flex items-center justify-between p-4 rounded-lg glass">
              <div>
                <div className="text-neon-cyan/70 text-sm">Returning Users</div>
                <div className="text-2xl font-bold text-neon-purple">0</div>
              </div>
              <div className="text-4xl text-neon-purple/30">
                <svg className="w-12 h-12" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
                </svg>
              </div>
            </div>
          </div>
        </div>

        {/* Gas Efficiency */}
        <div className="glass rounded-xl p-6 neon-border">
          <h3 className="text-xl font-bold text-neon-cyan mb-4">Gas Efficiency</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 rounded-lg glass">
              <div>
                <div className="text-neon-cyan/70 text-sm">Avg Gas Used</div>
                <div className="text-2xl font-bold text-neon-cyan">0 Gwei</div>
              </div>
              <div className="text-4xl text-neon-cyan/30">
                ⚡
              </div>
            </div>
            
            <div className="flex items-center justify-between p-4 rounded-lg glass">
              <div>
                <div className="text-neon-cyan/70 text-sm">Gas Savings</div>
                <div className="text-2xl font-bold text-neon-green">0%</div>
              </div>
              <div className="text-4xl text-neon-green/30">
                💰
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Revenue Breakdown */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Revenue Breakdown</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Treasury (70%)</div>
            <div className="text-2xl font-bold text-neon-green">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">To gxqstudio.eth</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Partners (20%)</div>
            <div className="text-2xl font-bold text-neon-purple">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">Revenue share</div>
          </div>
          
          <div className="glass rounded-lg p-4">
            <div className="text-sm text-neon-cyan/70 mb-2">Reserve (10%)</div>
            <div className="text-2xl font-bold text-neon-cyan">$0</div>
            <div className="text-xs text-neon-cyan/50 mt-1">Emergency fund</div>
          </div>
        </div>
      </div>

      {/* Partner Analytics */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">Partner Program Analytics</h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Total Partners</div>
            <div className="text-3xl font-bold text-neon-cyan">0</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Bronze</div>
            <div className="text-3xl font-bold text-yellow-600">0</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Silver</div>
            <div className="text-3xl font-bold text-gray-400">0</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Gold/Platinum</div>
            <div className="text-3xl font-bold text-neon-green">0</div>
          </div>
        </div>

        <div className="space-y-3">
          <div className="text-sm font-semibold text-neon-cyan mb-2">Top Partners</div>
          <div className="text-center py-8 text-neon-cyan/50">
            No partner data yet
          </div>
        </div>
      </div>

      {/* DEX Routing Analytics */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">DEX Routing Efficiency</h3>
        <div className="space-y-3">
          {[
            { dex: 'Uniswap V3', routes: 0, savings: '0%', color: 'neon-green' },
            { dex: 'Sushiswap', routes: 0, savings: '0%', color: 'neon-purple' },
            { dex: 'Curve', routes: 0, savings: '0%', color: 'neon-cyan' },
            { dex: 'Balancer', routes: 0, savings: '0%', color: 'neon-pink' },
            { dex: 'Kyber', routes: 0, savings: '0%', color: 'neon-green' },
          ].map((dex) => (
            <div key={dex.dex} className="flex items-center justify-between p-4 rounded-lg glass">
              <div className="flex items-center space-x-4">
                <div className={`text-${dex.color} font-semibold`}>{dex.dex}</div>
                <div className="text-sm text-neon-cyan/50">{dex.routes} routes</div>
              </div>
              <div className="flex items-center space-x-6">
                <div className="text-right">
                  <div className="text-sm text-neon-cyan/70">Avg Savings</div>
                  <div className="text-lg font-bold text-neon-green">{dex.savings}</div>
                </div>
                <div className="w-24 h-2 bg-neon-cyan/20 rounded-full overflow-hidden">
                  <div className={`h-full bg-${dex.color}`} style={{ width: '0%' }}></div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* System Performance */}
      <div className="glass rounded-xl p-6 neon-border">
        <h3 className="text-xl font-bold text-neon-cyan mb-4">System Performance</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Uptime</div>
            <div className="text-2xl font-bold text-neon-green">99.9%</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Avg Response</div>
            <div className="text-2xl font-bold text-neon-cyan">0ms</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Success Rate</div>
            <div className="text-2xl font-bold text-neon-green">100%</div>
          </div>
          
          <div className="glass rounded-lg p-4 text-center">
            <div className="text-sm text-neon-cyan/70 mb-2">Failed Txs</div>
            <div className="text-2xl font-bold text-neon-pink">0</div>
          </div>
        </div>
      </div>
    </div>
  )
}
