import type { Metadata } from 'next'
import './globals.css'
import '../styles/globals.css'
import { Providers } from './providers'

export const metadata: Metadata = {
  title: 'Kybers DEX - Advanced Multi-Chain Aggregator',
  description: 'Complete production-ready advanced DEX infrastructure with 15+ DEX aggregation',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="cyber-grid-bg min-h-screen">
        <Providers>
          <div className="relative z-10">
            {children}
          </div>
        </Providers>
      </body>
    </html>
  )
}
