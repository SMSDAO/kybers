#!/usr/bin/env bash
set -eo pipefail

check_balance () {
    local RPC=$1
    local MIN_BALANCE_WEI=10000000000000000   # 0.01 ETH

    # Derive deployer address from private key
    if [ -z "$DEPLOYER_ADDRESS" ]; then
        DEPLOYER_ADDRESS=$(cast wallet address --private-key "$PRIVATE_KEY")
    fi

    BALANCE=$(cast balance "$DEPLOYER_ADDRESS" --rpc-url "$RPC")

    echo "Wallet address: $DEPLOYER_ADDRESS"
    echo "Wallet balance: $BALANCE wei"

    if [ "$BALANCE" -lt "$MIN_BALANCE_WEI" ]; then
        echo "❌ ERROR: Wallet balance too low for deployment (need at least 0.01 ETH)"
        exit 1
    fi
}

extract_address () {
    local OUTPUT=$1
    local LABEL=$2
    local ADDRESS

    ADDRESS=$(printf '%s\n' "$OUTPUT" | awk -v label="$LABEL" '$1 == label { print $2; exit }')

    if [[ ! "$ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
        echo "❌ ERROR: Failed to extract valid address for $LABEL"
        exit 1
    fi

    echo "$ADDRESS"
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
check_balance "$RPC_BASE"

echo "Deploying to Base..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url "$RPC_BASE" \
  --private-key "$PRIVATE_KEY" \
  --broadcast 2>&1)

# Extract addresses from console2.log output
ADMIN=$(extract_address "$OUTPUT" "ADMIN_CONTROL")
TREASURY_MANAGER=$(extract_address "$OUTPUT" "TREASURY_MANAGER")
AGGREGATOR=$(extract_address "$OUTPUT" "PRICE_AGGREGATOR")
FEE_MANAGER=$(extract_address "$OUTPUT" "FEE_MANAGER")
ROUTER=$(extract_address "$OUTPUT" "SWAP_ROUTER")

cat <<EOF > deployments/base-$NETWORK.json
{
  "admin": "$ADMIN",
  "treasuryManager": "$TREASURY_MANAGER",
  "priceAggregator": "$AGGREGATOR",
  "feeManager": "$FEE_MANAGER",
  "router": "$ROUTER"
}
EOF

echo "Base deployment written to deployments/base-$NETWORK.json"

########################################
# Zora Deploy
########################################
echo "Checking balance for Zora..."
check_balance "$RPC_ZORA"

echo "Deploying to Zora..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url "$RPC_ZORA" \
  --private-key "$PRIVATE_KEY" \
  --broadcast 2>&1)

# Extract addresses from console2.log output
ADMIN=$(extract_address "$OUTPUT" "ADMIN_CONTROL")
TREASURY_MANAGER=$(extract_address "$OUTPUT" "TREASURY_MANAGER")
AGGREGATOR=$(extract_address "$OUTPUT" "PRICE_AGGREGATOR")
FEE_MANAGER=$(extract_address "$OUTPUT" "FEE_MANAGER")
ROUTER=$(extract_address "$OUTPUT" "SWAP_ROUTER")

cat <<EOF > deployments/zora-$NETWORK.json
{
  "admin": "$ADMIN",
  "treasuryManager": "$TREASURY_MANAGER",
  "priceAggregator": "$AGGREGATOR",
  "feeManager": "$FEE_MANAGER",
  "router": "$ROUTER"
}
EOF

echo "Zora deployment written to deployments/zora-$NETWORK.json"

########################################
# Polygon Deploy
########################################
echo "Checking balance for Polygon..."
check_balance "$RPC_POLYGON"

echo "Deploying to Polygon..."
OUTPUT=$(forge script script/Deploy.s.sol:Deploy \
  --rpc-url "$RPC_POLYGON" \
  --private-key "$PRIVATE_KEY" \
  --broadcast 2>&1)

# Extract addresses from console2.log output
ADMIN=$(extract_address "$OUTPUT" "ADMIN_CONTROL")
TREASURY_MANAGER=$(extract_address "$OUTPUT" "TREASURY_MANAGER")
AGGREGATOR=$(extract_address "$OUTPUT" "PRICE_AGGREGATOR")
FEE_MANAGER=$(extract_address "$OUTPUT" "FEE_MANAGER")
ROUTER=$(extract_address "$OUTPUT" "SWAP_ROUTER")

cat <<EOF > deployments/polygon-$NETWORK.json
{
  "admin": "$ADMIN",
  "treasuryManager": "$TREASURY_MANAGER",
  "priceAggregator": "$AGGREGATOR",
  "feeManager": "$FEE_MANAGER",
  "router": "$ROUTER"
}
EOF

echo "Polygon deployment written to deployments/polygon-$NETWORK.json"

echo "All deployments complete."
