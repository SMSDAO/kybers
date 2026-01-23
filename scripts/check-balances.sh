#!/usr/bin/env bash
set -e

echo "Checking balances for deployer wallet..."
echo "Wallet: $PRIVATE_KEY"

check () {
    local NAME=$1
    local RPC=$2
    local SYMBOL=$3

    BAL=$(cast balance $PRIVATE_KEY --rpc-url $RPC)
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
