#!/usr/bin/env bash
set -e

check_balance () {
    local RPC=$1
    local MIN_BALANCE_WEI=10000000000000000   # 0.01 ETH

    BALANCE=$(cast balance $PRIVATE_KEY --rpc-url $RPC)

    echo "Wallet balance: $BALANCE wei"

    if [ "$BALANCE" -lt "$MIN_BALANCE_WEI" ]; then
        echo "❌ ERROR: Wallet balance too low for deployment (need at least 0.01 ETH)"
        exit 1
    fi
}

NETWORK=$1

echo "Deploying to: $NETWORK"

# Select RPC based on mode
if [ "$NETWORK" = "testnet" ]; then
  RPC_BASE=$BASE_TESTNET_RPC
  RPC_ZORA=$ZORA_TESTNET_RPC
  RPC_POLYGON=$POLYGON_TESTNET_RPC
elif [ "$NETWORK" = "mainnet" ]; then
  RPC_BASE=$BASE_RPC_URL
  RPC_ZORA=$ZORA_RPC_URL
  RPC_POLYGON=$POLYGON_RPC_URL
else
  echo "Unknown network: $NETWORK"
  exit 1
fi

mkdir -p deployments

########################################
# Base Deploy
########################################
echo "Checking balance for Base..."
check_balance $RPC_BASE

echo "Deploying to Base..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url $RPC_BASE \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --json)

ROUTER=$(echo $OUTPUT | jq -r '.returns.router')
FACTORY=$(echo $OUTPUT | jq -r '.returns.factory')
TOKEN=$(echo $OUTPUT | jq -r '.returns.token')

cat <<EOF > deployments/base-$NETWORK.json
{
  "router": "$ROUTER",
  "factory": "$FACTORY",
  "token": "$TOKEN"
}
EOF

echo "Base deployment written to deployments/base-$NETWORK.json"

########################################
# Zora Deploy
########################################
echo "Checking balance for Zora..."
check_balance $RPC_ZORA

echo "Deploying to Zora..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url $RPC_ZORA \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --json)

ROUTER=$(echo $OUTPUT | jq -r '.returns.router')
FACTORY=$(echo $OUTPUT | jq -r '.returns.factory')
TOKEN=$(echo $OUTPUT | jq -r '.returns.token')

cat <<EOF > deployments/zora-$NETWORK.json
{
  "router": "$ROUTER",
  "factory": "$FACTORY",
  "token": "$TOKEN"
}
EOF

echo "Zora deployment written to deployments/zora-$NETWORK.json"

########################################
# Polygon Deploy
########################################
echo "Checking balance for Polygon..."
check_balance $RPC_POLYGON

echo "Deploying to Polygon..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url $RPC_POLYGON \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --json)

ROUTER=$(echo $OUTPUT | jq -r '.returns.router')
FACTORY=$(echo $OUTPUT | jq -r '.returns.factory')
TOKEN=$(echo $OUTPUT | jq -r '.returns.token')

cat <<EOF > deployments/polygon-$NETWORK.json
{
  "router": "$ROUTER",
  "factory": "$FACTORY",
  "token": "$TOKEN"
}
EOF

echo "Polygon deployment written to deployments/polygon-$NETWORK.json"

echo "All deployments complete."
