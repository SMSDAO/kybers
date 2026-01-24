#!/bin/bash

# Complete deployment orchestration script for Kybers DEX

set -e

echo "========================================="
echo "Kybers DEX - Complete Deployment"
echo "========================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check dependencies
echo ""
echo "Checking dependencies..."
command -v forge >/dev/null 2>&1 || { print_error "Foundry is not installed. Please install it first."; exit 1; }
command -v node >/dev/null 2>&1 || { print_error "Node.js is not installed. Please install it first."; exit 1; }
command -v docker >/dev/null 2>&1 || { print_error "Docker is not installed. Please install it first."; exit 1; }

print_success "All dependencies found"

# Build smart contracts
echo ""
echo "Building smart contracts..."
forge build || { print_error "Contract build failed"; exit 1; }
print_success "Contracts built successfully"

# Run contract tests
echo ""
echo "Running contract tests..."
forge test || { print_error "Contract tests failed"; exit 1; }
print_success "All contract tests passed"

# Deploy contracts
echo ""
echo "Deploying smart contracts..."
if [ "$1" == "mainnet" ]; then
    print_warning "Deploying to MAINNET - This will use real funds!"
    read -p "Are you sure you want to continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        print_error "Deployment cancelled"
        exit 0
    fi
    ./scripts/deploy-contracts.sh mainnet || { print_error "Contract deployment failed"; exit 1; }
else
    ./scripts/deploy-contracts.sh testnet || { print_error "Contract deployment failed"; exit 1; }
fi
print_success "Contracts deployed successfully"

# Build frontend
echo ""
echo "Building frontend..."
cd frontend
npm install || { print_error "Frontend dependency installation failed"; exit 1; }
npm run build || { print_error "Frontend build failed"; exit 1; }
cd ..
print_success "Frontend built successfully"

# Build backend services
echo ""
echo "Building backend services..."
cd services
npm install || { print_error "Backend dependency installation failed"; exit 1; }
cd ..
print_success "Backend services ready"

# Build Docker images
echo ""
echo "Building Docker images..."
docker-compose build || { print_error "Docker build failed"; exit 1; }
print_success "Docker images built successfully"

# Start services
echo ""
echo "Starting services..."
docker-compose up -d || { print_error "Service startup failed"; exit 1; }
print_success "All services started successfully"

# Verify deployment
echo ""
echo "Verifying deployment..."
sleep 10

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    print_error "Some services failed to start"
    docker-compose logs
    exit 1
fi

print_success "All services are running"

# Print deployment summary
echo ""
echo "========================================="
echo "Deployment Complete!"
echo "========================================="
echo ""
echo "Services:"
echo "  Frontend:  http://localhost:3000"
echo "  API:       http://localhost:3000/api"
echo ""
echo "Admin Dashboard: http://localhost:3000/admin"
echo ""
echo "To view deployment status:"
echo "  vercel logs"
echo ""
echo "To stop services:"
echo "  docker-compose down"
echo ""
print_success "Deployment successful!"
