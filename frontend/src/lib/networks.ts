export const NETWORKS = {
  base: {
    chainId: 84532,
    name: "Base Sepolia",
    rpc: process.env.NEXT_PUBLIC_BASE_TESTNET_RPC,
    key: "base-sepolia",
  },
  zora: {
    chainId: 999999999,
    name: "Zora Sepolia",
    rpc: process.env.NEXT_PUBLIC_ZORA_TESTNET_RPC,
    key: "zora-sepolia",
  },
  polygon: {
    chainId: 80002,
    name: "Polygon Testnet",
    rpc: process.env.NEXT_PUBLIC_POLYGON_TESTNET_RPC,
    key: "polygon-testnet",
  },
};

export function getNetworkByChainId(chainId: number) {
  return Object.values(NETWORKS).find((n) => n.chainId === chainId) || null;
}

export function getNetwork(key: keyof typeof NETWORKS) {
  return NETWORKS[key] || null;
}
