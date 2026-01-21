import base from "./deployments/base-sepolia.json";
import zora from "./deployments/zora-sepolia.json";
import polygon from "./deployments/polygon-testnet.json";

export const deployments = {
  "base-sepolia": base,
  "zora-sepolia": zora,
  "polygon-testnet": polygon,
};

export function getDeployment(key: string) {
  return deployments[key] || null;
}
