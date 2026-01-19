#!/bin/bash

# Smart contract deployment script

set -e

NETWORK=${1:-testnet}

echo "Deploying contracts to $NETWORK..."

# Check for private key
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable not set"
    exit 1
fi

# Deploy to different networks
case $NETWORK in
    "testnet")
        echo "Deploying to Base Sepolia..."
        forge script contracts/script/Deploy.s.sol:DeployScript \
            --rpc-url $BASE_RPC_URL \
            --private-key $PRIVATE_KEY \
            --broadcast \
            --verify
        ;;
    
    "mainnet")
        echo "Deploying to multiple mainnets..."
        
        # Ethereum Mainnet
        echo "Deploying to Ethereum Mainnet..."
        forge script contracts/script/Deploy.s.sol:DeployScript \
            --rpc-url $MAINNET_RPC_URL \
            --private-key $PRIVATE_KEY \
            --broadcast \
            --verify
        
        # Base
        echo "Deploying to Base..."
        forge script contracts/script/Deploy.s.sol:DeployScript \
            --rpc-url $BASE_RPC_URL \
            --private-key $PRIVATE_KEY \
            --broadcast \
            --verify
        
        # Zora
        echo "Deploying to Zora..."
        forge script contracts/script/Deploy.s.sol:DeployScript \
            --rpc-url $ZORA_RPC_URL \
            --private-key $PRIVATE_KEY \
            --broadcast \
            --verify
        ;;
    
    *)
        echo "Unknown network: $NETWORK"
        exit 1
        ;;
esac

echo "Deployment complete!"
