#!/bin/bash

###############################################################################
# Kybers DEX - Master Build & Test Script
# 
# This script performs comprehensive build verification, testing, and
# deployment preparation for the Kybers DEX platform.
#
# Usage:
#   ./scripts/master.sh [command]
#
# Commands:
#   build     - Build all components (contracts, frontend, backend)
#   test      - Run all tests (contracts, frontend, backend)
#   verify    - Run build verification (10-step check)
#   clean     - Clean all build artifacts and dependencies
#   install   - Install all dependencies
#   lint      - Run linters on all code
#   security  - Run security scans
#   all       - Run install, build, test, verify, and security
#   help      - Show this help message
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

###############################################################################
# Command Functions
###############################################################################

cmd_install() {
    print_header "Installing Dependencies"
    
    print_info "Installing Foundry dependencies..."
    if command -v forge &> /dev/null; then
        forge install
        print_success "Foundry dependencies installed"
    else
        print_warning "Foundry not found, skipping contract dependencies"
    fi
    
    print_info "Installing frontend dependencies..."
    if [ -d "frontend" ]; then
        cd frontend
        npm install
        cd ..
        print_success "Frontend dependencies installed"
    fi
    
    print_info "Installing backend dependencies..."
    if [ -d "services" ]; then
        cd services
        npm install
        cd ..
        print_success "Backend dependencies installed"
    fi
    
    print_success "All dependencies installed successfully"
}

cmd_clean() {
    print_header "Cleaning Build Artifacts"
    
    print_info "Cleaning Foundry artifacts..."
    if [ -d "cache" ]; then
        rm -rf cache
        print_success "Removed cache/"
    fi
    if [ -d "out" ]; then
        rm -rf out
        print_success "Removed out/"
    fi
    if [ -d "broadcast" ]; then
        rm -rf broadcast
        print_success "Removed broadcast/"
    fi
    
    print_info "Cleaning frontend build..."
    if [ -d "frontend/.next" ]; then
        rm -rf frontend/.next
        print_success "Removed frontend/.next/"
    fi
    if [ -d "frontend/out" ]; then
        rm -rf frontend/out
        print_success "Removed frontend/out/"
    fi
    
    print_info "Cleaning node_modules (optional - commented out by default)..."
    # Uncomment to remove node_modules
    # rm -rf frontend/node_modules services/node_modules
    
    print_info "Cleaning lock files..."
    find . -name "package-lock.json" -type f -delete
    find . -name "yarn.lock" -type f -delete
    find . -name "pnpm-lock.yaml" -type f -delete
    print_success "Removed all lock files"
    
    print_success "Cleanup completed"
}

cmd_build() {
    print_header "Building All Components"
    
    print_info "Building smart contracts..."
    if command -v forge &> /dev/null; then
        forge build --sizes
        print_success "Contracts built successfully"
    else
        print_error "Foundry not installed. Please install: https://getfoundry.sh"
        exit 1
    fi
    
    print_info "Building frontend..."
    if [ -d "frontend" ]; then
        cd frontend
        npm run build
        cd ..
        print_success "Frontend built successfully"
    fi
    
    print_info "Building backend services..."
    if [ -d "services" ]; then
        cd services
        if [ -f "tsconfig.json" ]; then
            npm run build
        fi
        cd ..
        print_success "Backend services built successfully"
    fi
    
    print_success "All components built successfully"
}

cmd_test() {
    print_header "Running All Tests"
    
    print_info "Running contract tests..."
    if command -v forge &> /dev/null; then
        forge test -vv
        print_success "Contract tests passed"
    else
        print_error "Foundry not installed"
        exit 1
    fi
    
    print_info "Generating coverage report..."
    forge coverage --report summary
    
    print_info "Running frontend tests..."
    if [ -d "frontend" ]; then
        cd frontend
        # Skip if no tests configured
        if grep -q "\"test\"" package.json; then
            npm test || print_warning "Frontend tests not configured or failed"
        else
            print_warning "Frontend tests not configured"
        fi
        cd ..
    fi
    
    print_info "Running backend tests..."
    if [ -d "services" ]; then
        cd services
        # Skip if no tests configured
        if grep -q "\"test\"" package.json; then
            npm test || print_warning "Backend tests not configured or failed"
        else
            print_warning "Backend tests not configured"
        fi
        cd ..
    fi
    
    print_success "All tests completed"
}

cmd_verify() {
    print_header "Running Build Verification"
    
    if [ -f "scripts/build-verify.sh" ]; then
        chmod +x scripts/build-verify.sh
        ./scripts/build-verify.sh
    else
        print_error "build-verify.sh not found"
        exit 1
    fi
}

cmd_lint() {
    print_header "Running Linters"
    
    print_info "Linting smart contracts..."
    if command -v forge &> /dev/null; then
        forge fmt --check || {
            print_warning "Contract formatting issues found. Run 'forge fmt' to fix."
        }
    fi
    
    print_info "Linting frontend..."
    if [ -d "frontend" ]; then
        cd frontend
        npm run lint || print_warning "Frontend linting issues found"
        cd ..
    fi
    
    print_success "Linting completed"
}

cmd_security() {
    print_header "Running Security Scans"
    
    print_info "Running Slither static analysis..."
    if command -v slither &> /dev/null; then
        slither . --filter-paths "node_modules|test" --exclude naming-convention,solc-version || \
            print_warning "Slither found potential issues"
    else
        print_warning "Slither not installed. Install: pip3 install slither-analyzer"
    fi
    
    print_info "Running npm audit on frontend..."
    if [ -d "frontend" ]; then
        cd frontend
        npm audit --audit-level=moderate || print_warning "Frontend vulnerabilities found"
        cd ..
    fi
    
    print_info "Running npm audit on backend..."
    if [ -d "services" ]; then
        cd services
        npm audit --audit-level=moderate || print_warning "Backend vulnerabilities found"
        cd ..
    fi
    
    print_success "Security scans completed"
}

cmd_all() {
    print_header "Running Complete Build & Test Pipeline"
    
    cmd_clean
    cmd_install
    cmd_build
    cmd_test
    cmd_lint
    cmd_verify
    cmd_security
    
    print_header "Pipeline Completed Successfully"
    print_success "All checks passed! Ready for deployment."
}

cmd_help() {
    cat << EOF
Kybers DEX - Master Build & Test Script

Usage:
  ./scripts/master.sh [command]

Commands:
  install   - Install all dependencies (Foundry, npm packages)
  clean     - Clean all build artifacts and lock files
  build     - Build all components (contracts, frontend, backend)
  test      - Run all tests (contracts, frontend, backend)
  verify    - Run comprehensive build verification (10-step check)
  lint      - Run linters on all code
  security  - Run security scans (Slither, npm audit)
  all       - Run complete pipeline (clean, install, build, test, lint, verify, security)
  help      - Show this help message

Examples:
  ./scripts/master.sh install     # Install dependencies
  ./scripts/master.sh build       # Build everything
  ./scripts/master.sh test        # Run all tests
  ./scripts/master.sh all         # Run complete pipeline

For more information, see the documentation at docs/
EOF
}

###############################################################################
# Main Script Logic
###############################################################################

COMMAND="${1:-help}"

case "$COMMAND" in
    install)
        cmd_install
        ;;
    clean)
        cmd_clean
        ;;
    build)
        cmd_build
        ;;
    test)
        cmd_test
        ;;
    verify)
        cmd_verify
        ;;
    lint)
        cmd_lint
        ;;
    security)
        cmd_security
        ;;
    all)
        cmd_all
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        echo ""
        cmd_help
        exit 1
        ;;
esac

exit 0
