'use client'

import { WagmiProvider, createConfig, http } from 'wagmi'
import { mainnet, base, zora, arbitrum, optimism, polygon, bsc } from 'wagmi/chains'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useState } from 'react'

const config = createConfig({
  chains: [mainnet, base, zora, arbitrum, optimism, polygon, bsc],
  transports: {
    [mainnet.id]: http(),
    [base.id]: http(),
    [zora.id]: http(),
    [arbitrum.id]: http(),
    [optimism.id]: http(),
    [polygon.id]: http(),
    [bsc.id]: http(),
  },
})

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient())

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    </WagmiProvider>
  )
}
