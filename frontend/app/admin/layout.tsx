import Link from 'next/link'

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen p-4 md:p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl md:text-4xl font-bold holographic mb-2">
            Admin Dashboard
          </h1>
          <p className="text-neon-cyan/70">Manage Kybers DEX Platform</p>
        </div>

        {/* Navigation */}
        <nav className="glass rounded-xl p-4 mb-8 neon-border">
          <div className="flex flex-wrap gap-4">
            <Link href="/admin/dashboard" className="px-4 py-2 rounded-lg glass hover:glow-cyan transition-all duration-300 text-neon-cyan">
              Dashboard
            </Link>
            <Link href="/admin/fees" className="px-4 py-2 rounded-lg glass hover:glow-purple transition-all duration-300 text-neon-cyan">
              Fee Management
            </Link>
            <Link href="/admin/treasury" className="px-4 py-2 rounded-lg glass hover:glow-green transition-all duration-300 text-neon-cyan">
              Treasury
            </Link>
            <Link href="/admin/security" className="px-4 py-2 rounded-lg glass hover:glow-pink transition-all duration-300 text-neon-cyan">
              Security
            </Link>
            <Link href="/admin/contracts" className="px-4 py-2 rounded-lg glass hover:glow-cyan transition-all duration-300 text-neon-cyan">
              Contracts
            </Link>
            <Link href="/admin/analytics" className="px-4 py-2 rounded-lg glass hover:glow-purple transition-all duration-300 text-neon-cyan">
              Analytics
            </Link>
            <Link href="/" className="px-4 py-2 rounded-lg glass hover:glow-pink transition-all duration-300 text-neon-cyan ml-auto">
              ← Back to Swap
            </Link>
          </div>
        </nav>

        {/* Content */}
        {children}
      </div>
    </div>
  )
}
