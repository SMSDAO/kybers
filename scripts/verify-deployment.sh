#!/usr/bin/env bash
set -e

echo "Starting verification..."

########################################
# Base Sepolia (Testnet)
########################################
if [ -f deployments/base-testnet.json ]; then
  ADDR=$(jq -r '.router' deployments/base-testnet.json)
  echo "Verifying Base Sepolia router: $ADDR"
  forge verify-contract \
    --chain-id 84532 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $BASESCAN_API_KEY \
    --watch
fi

########################################
# Zora Sepolia (Testnet)
########################################
if [ -f deployments/zora-testnet.json ]; then
  ADDR=$(jq -r '.router' deployments/zora-testnet.json)
  echo "Verifying Zora Sepolia router: $ADDR"
  forge verify-contract \
    --chain-id 999999999 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $ZORASCAN_API_KEY \
    --watch
fi

########################################
# Polygon Testnet (Amoy)
########################################
if [ -f deployments/polygon-testnet.json ]; then
  ADDR=$(jq -r '.router' deployments/polygon-testnet.json)
  echo "Verifying Polygon Testnet router: $ADDR"
  forge verify-contract \
    --chain-id 80002 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $POLYGONSCAN_API_KEY \
    --watch
fi

########################################
# Base Mainnet
########################################
if [ -f deployments/base-mainnet.json ]; then
  ADDR=$(jq -r '.router' deployments/base-mainnet.json)
  echo "Verifying Base Mainnet router: $ADDR"
  forge verify-contract \
    --chain-id 8453 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $BASESCAN_API_KEY \
    --watch
fi

########################################
# Zora Mainnet
########################################
if [ -f deployments/zora-mainnet.json ]; then
  ADDR=$(jq -r '.router' deployments/zora-mainnet.json)
  echo "Verifying Zora Mainnet router: $ADDR"
  forge verify-contract \
    --chain-id 7777777 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $ZORASCAN_API_KEY \
    --watch
fi

########################################
# Polygon Mainnet
########################################
if [ -f deployments/polygon-mainnet.json ]; then
  ADDR=$(jq -r '.router' deployments/polygon-mainnet.json)
  echo "Verifying Polygon Mainnet router: $ADDR"
  forge verify-contract \
    --chain-id 137 \
    $ADDR \
    src/Router.sol:Router \
    --etherscan-api-key $POLYGONSCAN_API_KEY \
    --watch
fi

echo "Verification complete."
