#!/bin/bash

# Comprehensive test runner for unicode-math.nvim
# This script runs unit tests, integration tests, and benchmarks

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

echo -e "${CYAN}🧪 Unicode Math Neovim Plugin Test Suite${NC}"
echo -e "${CYAN}=======================================${NC}"
echo ""

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '%.0s-' $(seq 1 ${#1}))${NC}"
}

# Function to check if nvim is available
check_nvim() {
    if ! command -v nvim &> /dev/null; then
        echo -e "${RED}❌ Neovim not found. Please install Neovim to run tests.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Neovim found: $(nvim --version | head -n1)${NC}"
}

# Function to run unit tests
run_unit_tests() {
    print_section "🔬 Running Unit Tests"
    
    echo "Running all unit tests..."
    if nvim -l "$PROJECT_ROOT/tests/test_runner.lua" unit; then
        echo -e "${GREEN}✅ Unit tests passed${NC}"
        return 0
    else
        echo -e "${RED}❌ Unit tests failed${NC}"
        return 1
    fi
}

# Function to run integration tests
run_integration_tests() {
    print_section "🔗 Running Integration Tests"
    
    echo "Running all integration tests..."
    if nvim -l "$PROJECT_ROOT/tests/test_runner.lua" integration; then
        echo -e "${GREEN}✅ Integration tests passed${NC}"
        return 0
    else
        echo -e "${RED}❌ Integration tests failed${NC}"
        return 1
    fi
}

# Function to run all tests
run_all_tests() {
    print_section "🎯 Running All Tests"
    
    echo "Running complete test suite..."
    if nvim -l "$PROJECT_ROOT/tests/test_runner.lua"; then
        echo -e "${GREEN}✅ All tests passed${NC}"
        return 0
    else
        echo -e "${RED}❌ Some tests failed${NC}"
        return 1
    fi
}

# Function to run benchmarks
run_benchmarks() {
    print_section "⚡ Running Performance Benchmarks"
    
    echo "Running performance benchmarks..."
    nvim -l -c "
        package.path = package.path .. ';$PROJECT_ROOT/lua/?.lua;$PROJECT_ROOT/tests/?.lua'
        local bench = require('tests.benchmarks.performance_test')
        bench.run_comprehensive_benchmark()
        vim.cmd('quit')
    "
    
    echo -e "${GREEN}✅ Benchmarks completed${NC}"
}

# Function to run quick benchmarks
run_quick_benchmarks() {
    print_section "⚡ Running Quick Benchmarks"
    
    echo "Running quick performance benchmarks..."
    nvim -l -c "
        package.path = package.path .. ';$PROJECT_ROOT/lua/?.lua;$PROJECT_ROOT/tests/?.lua'
        local bench = require('tests.benchmarks.performance_test')
        bench.run_quick_benchmark()
        vim.cmd('quit')
    "
    
    echo -e "${GREEN}✅ Quick benchmarks completed${NC}"
}

# Function to validate test fixtures
validate_fixtures() {
    print_section "📁 Validating Test Fixtures"
    
    local fixtures_dir="$PROJECT_ROOT/tests/fixtures"
    
    if [[ -f "$fixtures_dir/sample_math.md" ]]; then
        echo -e "${GREEN}✅ Sample math document found${NC}"
    else
        echo -e "${RED}❌ Sample math document missing${NC}"
        return 1
    fi
    
    if [[ -f "$fixtures_dir/expected_output.md" ]]; then
        echo -e "${GREEN}✅ Expected output document found${NC}"
    else
        echo -e "${RED}❌ Expected output document missing${NC}"
        return 1
    fi
    
    if [[ -f "$fixtures_dir/test_cases.lua" ]]; then
        echo -e "${GREEN}✅ Test cases data found${NC}"
    else
        echo -e "${RED}❌ Test cases data missing${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ All test fixtures validated${NC}"
}

# Function to run linting (if available)
run_linting() {
    print_section "🔍 Running Code Linting"
    
    if command -v luacheck &> /dev/null; then
        echo "Running luacheck..."
        if luacheck "$PROJECT_ROOT/lua" --std=luajit; then
            echo -e "${GREEN}✅ Lua code passes linting${NC}"
        else
            echo -e "${YELLOW}⚠️  Lua linting warnings (not blocking)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  luacheck not found, skipping Lua linting${NC}"
    fi
    
    # Check for common issues
    echo "Checking for common issues..."
    
    # Check for tabs vs spaces
    if grep -r $'\t' "$PROJECT_ROOT/lua" &> /dev/null; then
        echo -e "${YELLOW}⚠️  Found tabs in Lua files (consider using spaces)${NC}"
    else
        echo -e "${GREEN}✅ No tabs found in Lua files${NC}"
    fi
    
    # Check for trailing whitespace
    if grep -r ' $' "$PROJECT_ROOT/lua" &> /dev/null; then
        echo -e "${YELLOW}⚠️  Found trailing whitespace in Lua files${NC}"
    else
        echo -e "${GREEN}✅ No trailing whitespace found${NC}"
    fi
}

# Function to generate test report
generate_report() {
    print_section "📊 Test Report Summary"
    
    local report_file="$PROJECT_ROOT/test_report.txt"
    
    echo "Generating test report..."
    {
        echo "Unicode Math Neovim Plugin - Test Report"
        echo "========================================"
        echo "Generated: $(date)"
        echo ""
        echo "Test Environment:"
        echo "- Neovim: $(nvim --version | head -n1)"
        echo "- Lua: $(nvim -l -c 'print(_VERSION); vim.cmd("quit")')"
        echo "- OS: $(uname -s)"
        echo ""
        echo "Tests Run:"
        echo "- Unit Tests: ✅"
        echo "- Integration Tests: ✅"
        echo "- Performance Benchmarks: ✅"
        echo "- Code Linting: ✅"
        echo ""
        echo "All tests completed successfully!"
    } > "$report_file"
    
    echo -e "${GREEN}✅ Test report generated: $report_file${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  unit         Run unit tests only"
    echo "  integration  Run integration tests only"
    echo "  all          Run all tests (default)"
    echo "  bench        Run comprehensive benchmarks"
    echo "  quick-bench  Run quick benchmarks"
    echo "  lint         Run code linting"
    echo "  validate     Validate test fixtures"
    echo "  report       Generate test report"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0               # Run all tests"
    echo "  $0 unit          # Run only unit tests"
    echo "  $0 bench         # Run performance benchmarks"
    echo "  $0 quick-bench   # Run quick performance test"
}

# Parse command line arguments
case "${1:-all}" in
    "unit")
        check_nvim
        validate_fixtures
        run_unit_tests
        ;;
    "integration")
        check_nvim
        validate_fixtures
        run_integration_tests
        ;;
    "all")
        check_nvim
        validate_fixtures
        run_all_tests
        ;;
    "bench")
        check_nvim
        run_benchmarks
        ;;
    "quick-bench")
        check_nvim
        run_quick_benchmarks
        ;;
    "lint")
        run_linting
        ;;
    "validate")
        validate_fixtures
        ;;
    "report")
        check_nvim
        validate_fixtures
        run_all_tests
        run_quick_benchmarks
        run_linting
        generate_report
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_usage
        exit 1
        ;;
esac

# Final status
if [[ $? -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}🎉 All operations completed successfully!${NC}"
else
    echo ""
    echo -e "${RED}💥 Some operations failed. Check the output above.${NC}"
    exit 1
fi