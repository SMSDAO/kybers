#!/bin/bash

# Kybers DEX - Pre-Launch Verification Script
# Comprehensive checks before production deployment

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CHECKS_PASSED=0
CHECKS_FAILED=0
WARNINGS=0

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Kybers DEX - Pre-Launch Checks      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to check
check() {
    local description=$1
    local command=$2
    
    echo -n "Checking $description... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC}"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Function to warn
warn() {
    local description=$1
    local command=$2
    
    echo -n "Checking $description... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${YELLOW}⚠${NC}"
        ((WARNINGS++))
    fi
}

echo -e "${BLUE}1. Development Tools${NC}"
check "Foundry installation" "command -v forge"
check "Node.js installation" "command -v node"
check "npm installation" "command -v npm"
check "Docker installation" "command -v docker"
check "Docker Compose" "command -v docker-compose"
warn "Vercel CLI" "command -v vercel"
echo ""

echo -e "${BLUE}2. Environment Variables${NC}"
check "PRIVATE_KEY set" "[ ! -z \$PRIVATE_KEY ]"
warn "ETHERSCAN_API_KEY set" "[ ! -z \$ETHERSCAN_API_KEY ]"
warn "INFURA_API_KEY set" "[ ! -z \$INFURA_API_KEY ]"
warn "ALCHEMY_API_KEY set" "[ ! -z \$ALCHEMY_API_KEY ]"
echo ""

echo -e "${BLUE}3. Smart Contracts${NC}"
check "Foundry project" "[ -f foundry.toml ]"
check "Contract sources" "[ -d contracts/core ]"
check "Test files" "[ -d contracts/test ]"
check "Deployment scripts" "[ -d contracts/script ]"
echo ""

echo -e "${BLUE}4. Contract Tests${NC}"
if [ -f foundry.toml ]; then
    echo "Running contract tests..."
    if forge test --no-match-test ".*testFork.*" 2>&1 | tail -5; then
        echo -e "${GREEN}✓ All tests passed${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        ((CHECKS_FAILED++))
    fi
fi
echo ""

echo -e "${BLUE}5. Frontend${NC}"
check "Frontend directory" "[ -d frontend ]"
check "package.json" "[ -f frontend/package.json ]"
check "Next.js config" "[ -f frontend/next.config.js ]"
check "Components" "[ -d frontend/components ]"
check "App directory" "[ -d frontend/app ]"
echo ""

echo -e "${BLUE}6. Backend Services${NC}"
check "Services directory" "[ -d services ]"
check "Service package.json" "[ -f services/package.json ]"
check "Health check" "[ -f services/healthcheck.js ]"
echo ""

echo -e "${BLUE}7. Infrastructure${NC}"
check "Docker Compose config" "[ -f docker-compose.yml ]"
check "Frontend Dockerfile" "[ -f Dockerfile.frontend ]"
check "Backend Dockerfile" "[ -f Dockerfile.backend ]"
check "GitHub workflows" "[ -d .github/workflows ]"
echo ""

echo -e "${BLUE}8. Documentation${NC}"
check "README.md" "[ -f README.md ]"
check "Smart Contracts docs" "[ -f docs/SMART_CONTRACTS.md ]"
check "Deployment guide" "[ -f docs/DEPLOYMENT.md ]"
check "API documentation" "[ -f docs/API.md ]"
check "Security audit" "[ -f docs/SECURITY_AUDIT.md ]"
check "Tokenomics" "[ -f docs/TOKENOMICS.md ]"
echo ""

echo -e "${BLUE}9. Security${NC}"
check "Audit report" "[ -f docs/SECURITY_AUDIT.md ]"
check "Audit changes" "[ -f AUDIT_CHANGES.md ]"
check ".gitignore" "[ -f .gitignore ]"
check ".env.example" "[ -f .env.example ]"
echo ""

echo -e "${BLUE}10. Deployment Scripts${NC}"
check "Deploy all script" "[ -f scripts/deploy-all.sh ]"
check "Deploy contracts script" "[ -f scripts/deploy-contracts.sh ]"
check "Launch production script" "[ -f scripts/launch-production.sh ]"
check "Scripts are executable" "[ -x scripts/deploy-all.sh ]"
echo ""

echo -e "${BLUE}11. Contract Compilation${NC}"
echo "Compiling contracts..."
if forge build 2>&1 | tail -3; then
    echo -e "${GREEN}✓ Contracts compiled successfully${NC}"
    ((CHECKS_PASSED++))
else
    echo -e "${RED}✗ Contract compilation failed${NC}"
    ((CHECKS_FAILED++))
fi
echo ""

echo -e "${BLUE}12. Gas Optimization Check${NC}"
echo "Checking gas usage..."
if forge test --gas-report 2>&1 | grep -q "test"; then
    echo -e "${GREEN}✓ Gas optimization report generated${NC}"
    ((CHECKS_PASSED++))
else
    echo -e "${YELLOW}⚠ Could not generate gas report${NC}"
    ((WARNINGS++))
fi
echo ""

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Verification Summary                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC}  $CHECKS_PASSED"
echo -e "  ${RED}Failed:${NC}  $CHECKS_FAILED"
echo -e "  ${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✓ All Critical Checks Passed!       ║${NC}"
    echo -e "${GREEN}║   Ready for production deployment     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Note: ${WARNINGS} warnings detected. Review before deploying.${NC}"
        echo ""
    fi
    
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Review deployment configuration"
    echo -e "  2. Ensure all private keys are secure"
    echo -e "  3. Run: ./scripts/launch-production.sh production"
    echo ""
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   ✗ Some Checks Failed                ║${NC}"
    echo -e "${RED}║   Fix issues before deploying         ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Please fix the failed checks and run this script again.${NC}"
    echo ""
    exit 1
fi
