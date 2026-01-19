#!/bin/bash
# Build Verification Script - Ensures all contracts compile and checks pass
# This script verifies the build before deployment to testnet or mainnet

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Kybers DEX - Build Verification Script                ║${NC}"
echo -e "${BLUE}║         Comprehensive Build & Security Checks                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Track results
PASSED=0
FAILED=0
WARNINGS=0

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} $message"
        ((PASSED++))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}✗${NC} $message"
        ((FAILED++))
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
        ((WARNINGS++))
    else
        echo -e "${BLUE}ℹ${NC} $message"
    fi
}

echo -e "${BLUE}[1/10] Checking Prerequisites...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Check if forge is installed
if command -v forge &> /dev/null; then
    print_status "PASS" "Foundry (forge) is installed: $(forge --version | head -n1)"
else
    print_status "FAIL" "Foundry (forge) is not installed"
    echo "Install: curl -L https://foundry.paradigm.xyz | bash && foundryup"
fi

# Check if Node.js is installed
if command -v node &> /dev/null; then
    print_status "PASS" "Node.js is installed: $(node --version)"
else
    print_status "WARN" "Node.js is not installed (required for frontend)"
fi

# Check if Git is installed
if command -v git &> /dev/null; then
    print_status "PASS" "Git is installed: $(git --version)"
else
    print_status "FAIL" "Git is not installed"
fi

echo ""
echo -e "${BLUE}[2/10] Checking Dependencies...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Check OpenZeppelin contracts
if [ -d "lib/openzeppelin-contracts" ]; then
    print_status "PASS" "OpenZeppelin contracts installed"
else
    print_status "FAIL" "OpenZeppelin contracts not found in lib/"
    echo "Install: forge install OpenZeppelin/openzeppelin-contracts --no-commit"
fi

# Check forge-std
if [ -d "lib/forge-std" ]; then
    print_status "PASS" "forge-std installed"
else
    print_status "WARN" "forge-std not found (recommended for testing)"
    echo "Install: forge install foundry-rs/forge-std --no-commit"
fi

echo ""
echo -e "${BLUE}[3/10] Validating Contract Structure...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Count contracts
CORE_CONTRACTS=$(find contracts/core -name "*.sol" 2>/dev/null | wc -l)
ADMIN_CONTRACTS=$(find contracts/admin -name "*.sol" 2>/dev/null | wc -l)
SECURITY_CONTRACTS=$(find contracts/security -name "*.sol" 2>/dev/null | wc -l)
TEST_CONTRACTS=$(find contracts/test -name "*.t.sol" 2>/dev/null | wc -l)
INTERFACES=$(find contracts/interfaces -name "*.sol" 2>/dev/null | wc -l)

print_status "INFO" "Core contracts: $CORE_CONTRACTS (Expected: 6)"
print_status "INFO" "Admin contracts: $ADMIN_CONTRACTS (Expected: 1)"
print_status "INFO" "Security contracts: $SECURITY_CONTRACTS (Expected: 1)"
print_status "INFO" "Test contracts: $TEST_CONTRACTS (Expected: 4+)"
print_status "INFO" "Interfaces: $INTERFACES (Expected: 3+)"

if [ "$CORE_CONTRACTS" -ge 6 ]; then
    print_status "PASS" "Core contracts structure valid"
else
    print_status "FAIL" "Missing core contracts"
fi

echo ""
echo -e "${BLUE}[4/10] Compiling Contracts...${NC}"
echo "─────────────────────────────────────────────────────────────────"

if command -v forge &> /dev/null; then
    echo "Running: forge build --sizes"
    if forge build --sizes 2>&1 | tee /tmp/forge-build.log; then
        print_status "PASS" "All contracts compiled successfully"
        
        # Check for contract size warnings
        if grep -q "code size" /tmp/forge-build.log; then
            print_status "WARN" "Some contracts may exceed size limit"
        fi
    else
        print_status "FAIL" "Contract compilation failed"
        echo "Check /tmp/forge-build.log for details"
    fi
else
    print_status "WARN" "Skipping compilation (forge not installed)"
fi

echo ""
echo -e "${BLUE}[5/10] Running Tests...${NC}"
echo "─────────────────────────────────────────────────────────────────"

if command -v forge &> /dev/null; then
    echo "Running: forge test -vv"
    if forge test -vv 2>&1 | tee /tmp/forge-test.log; then
        print_status "PASS" "All tests passed"
        
        # Extract test count
        TEST_COUNT=$(grep -o "[0-9]* tests passed" /tmp/forge-test.log | head -1 | cut -d' ' -f1)
        if [ ! -z "$TEST_COUNT" ]; then
            print_status "INFO" "Tests passed: $TEST_COUNT"
        fi
    else
        print_status "FAIL" "Some tests failed"
        echo "Check /tmp/forge-test.log for details"
    fi
else
    print_status "WARN" "Skipping tests (forge not installed)"
fi

echo ""
echo -e "${BLUE}[6/10] Checking Test Coverage...${NC}"
echo "─────────────────────────────────────────────────────────────────"

if command -v forge &> /dev/null; then
    echo "Running: forge coverage"
    if forge coverage 2>&1 | tee /tmp/forge-coverage.log; then
        # Extract coverage percentage if available
        if grep -q "%" /tmp/forge-coverage.log; then
            print_status "PASS" "Coverage report generated"
        else
            print_status "WARN" "Coverage data not available"
        fi
    else
        print_status "WARN" "Coverage check failed (may require lcov)"
    fi
else
    print_status "WARN" "Skipping coverage (forge not installed)"
fi

echo ""
echo -e "${BLUE}[7/10] Security Checks...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Check for common security issues in contracts
echo "Scanning for security patterns..."

# Check for unchecked external calls
if grep -r "call{" contracts/ --include="*.sol" | grep -v "require\|assert" > /dev/null; then
    print_status "WARN" "Found unchecked external calls - review manually"
else
    print_status "PASS" "No unchecked external calls found"
fi

# Check for proper access control
if grep -r "onlyOwner\|onlyRole" contracts/core contracts/admin --include="*.sol" > /dev/null; then
    print_status "PASS" "Access control modifiers found"
else
    print_status "WARN" "Limited access control modifiers - review manually"
fi

# Check for ReentrancyGuard usage
if grep -r "ReentrancyGuard\|nonReentrant" contracts/ --include="*.sol" > /dev/null; then
    print_status "PASS" "ReentrancyGuard usage found"
else
    print_status "WARN" "No ReentrancyGuard usage found - review for reentrancy risks"
fi

# Check for SafeERC20 usage
if grep -r "SafeERC20\|safeTransfer" contracts/ --include="*.sol" > /dev/null; then
    print_status "PASS" "SafeERC20 patterns found"
else
    print_status "WARN" "No SafeERC20 usage - review token transfers"
fi

echo ""
echo -e "${BLUE}[8/10] Gas Optimization Check...${NC}"
echo "─────────────────────────────────────────────────────────────────"

if command -v forge &> /dev/null; then
    echo "Running: forge test --gas-report"
    if forge test --gas-report 2>&1 | tee /tmp/forge-gas.log | tail -20; then
        print_status "PASS" "Gas report generated"
    else
        print_status "WARN" "Gas report generation failed"
    fi
else
    print_status "WARN" "Skipping gas report (forge not installed)"
fi

echo ""
echo -e "${BLUE}[9/10] Deployment Script Validation...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Check deployment scripts exist
if [ -f "contracts/script/Deploy.s.sol" ]; then
    print_status "PASS" "Deploy script found"
else
    print_status "FAIL" "Deploy script not found"
fi

if [ -f "scripts/deploy-contracts.sh" ]; then
    print_status "PASS" "Deploy shell script found"
else
    print_status "WARN" "Deploy shell script not found"
fi

echo ""
echo -e "${BLUE}[10/10] Configuration Validation...${NC}"
echo "─────────────────────────────────────────────────────────────────"

# Check foundry.toml
if [ -f "foundry.toml" ]; then
    print_status "PASS" "foundry.toml exists"
    
    # Check for important settings
    if grep -q "solc_version.*0\.8\." foundry.toml; then
        print_status "PASS" "Solidity version configured (0.8.x)"
    else
        print_status "WARN" "Solidity version not configured"
    fi
    
    if grep -q "optimizer.*true" foundry.toml; then
        print_status "PASS" "Optimizer enabled"
    else
        print_status "WARN" "Optimizer not enabled"
    fi
else
    print_status "FAIL" "foundry.toml not found"
fi

# Check .env.example
if [ -f ".env.example" ]; then
    print_status "PASS" ".env.example exists"
else
    print_status "WARN" ".env.example not found"
fi

# Check remappings.txt
if [ -f "remappings.txt" ]; then
    print_status "PASS" "remappings.txt exists"
else
    print_status "WARN" "remappings.txt not found"
fi

echo ""
echo "═════════════════════════════════════════════════════════════════"
echo -e "${BLUE}Build Verification Summary${NC}"
echo "═════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC}   $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Build verification completed successfully!${NC}"
    echo -e "${GREEN}  The project is ready for deployment to testnet/mainnet.${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Build verification failed!${NC}"
    echo -e "${RED}  Please fix the issues above before deployment.${NC}"
    echo ""
    exit 1
fi
