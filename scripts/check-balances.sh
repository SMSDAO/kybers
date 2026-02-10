#!/usr/bin/env bash
set -e

# Determine deployer address without exposing the private key
if [ -z "$DEPLOYER_ADDRESS" ]; then
    DEPLOYER_ADDRESS=$(cast wallet address --private-key "$PRIVATE_KEY")
fi

echo "Checking balances for deployer wallet..."
echo "Wallet address: $DEPLOYER_ADDRESS"

check () {
    local NAME=$1
    local RPC=$2
    local SYMBOL=$3

    BAL=$(cast balance "$DEPLOYER_ADDRESS" --rpc-url $RPC)
    ETH=$(cast from-wei $BAL)

    echo "$NAME: $ETH $SYMBOL"
}

echo "----------------------------------------"
echo "TESTNET BALANCES"
echo "----------------------------------------"

check "Base Sepolia"   "$BASE_TESTNET_RPC"   "ETH"
check "Zora Sepolia"   "$ZORA_TESTNET_RPC"   "ETH"
check "Polygon Testnet" "$POLYGON_TESTNET_RPC" "MATIC"

echo "----------------------------------------"
echo "MAINNET BALANCES"
echo "----------------------------------------"

check "Base Mainnet"   "$BASE_RPC_URL"       "ETH"
check "Zora Mainnet"   "$ZORA_RPC_URL"       "ETH"
check "Polygon Mainnet" "$POLYGON_RPC_URL"   "MATIC"
