#!/bin/bash
# XML Validation Script for Singapore BIS Billing Examples
# This script validates XML files against UBL 2.1 schemas and basic business rules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
EXAMPLES_DIR="$PROJECT_ROOT/examples"
SCHEMAS_DIR="$PROJECT_ROOT/schemas"
VALIDATION_LOG="$PROJECT_ROOT/validation.log"

# Counters
TOTAL_FILES=0
VALID_FILES=0
INVALID_FILES=0

# Functions
print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  Singapore BIS Billing XML Validator${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_status() {
    local status=$1
    local file=$2
    local message=$3
    
    if [ "$status" == "PASS" ]; then
        echo -e "✅ ${GREEN}PASS${NC} - $file"
    elif [ "$status" == "FAIL" ]; then
        echo -e "❌ ${RED}FAIL${NC} - $file"
        if [ -n "$message" ]; then
            echo -e "   ${RED}Error: $message${NC}"
        fi
    elif [ "$status" == "WARN" ]; then
        echo -e "⚠️  ${YELLOW}WARN${NC} - $file"
        if [ -n "$message" ]; then
            echo -e "   ${YELLOW}Warning: $message${NC}"
        fi
    fi
}

log_result() {
    echo "$(date): $1 - $2" >> "$VALIDATION_LOG"
}

validate_xml_wellformed() {
    local file=$1
    
    if xmllint --noout "$file" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

validate_ubl_schema() {
    local file=$1
    local schema_file=""
    
    # Determine schema based on root element
    local root_element=$(xmllint --xpath "local-name(/*)" "$file" 2>/dev/null)
    
    case $root_element in
        "Invoice")
            schema_file="$SCHEMAS_DIR/ubl-2.1/UBL-Invoice-2.1.xsd"
            ;;
        "CreditNote")
            schema_file="$SCHEMAS_DIR/ubl-2.1/UBL-CreditNote-2.1.xsd"
            ;;
        "DebitNote")
            schema_file="$SCHEMAS_DIR/ubl-2.1/UBL-DebitNote-2.1.xsd"
            ;;
        *)
            echo "Unknown document type: $root_element"
            return 1
            ;;
    esac
    
    if [ ! -f "$schema_file" ]; then
        echo "Schema file not found: $schema_file"
        return 1
    fi
    
    if xmllint --schema "$schema_file" --noout "$file" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

validate_singapore_basics() {
    local file=$1
    local errors=()
    
    # Check for Singapore customization ID
    if ! xmllint --xpath "//*[local-name()='CustomizationID' and contains(text(), 'sg')]" "$file" >/dev/null 2>&1; then
        errors+=("Missing Singapore customization ID")
    fi
    
    # Check for proper currency code
    if ! xmllint --xpath "//*[local-name()='DocumentCurrencyCode']" "$file" >/dev/null 2>&1; then
        errors+=("Missing document currency code")
    fi
    
    # Check for UBL version 2.1
    local ubl_version=$(xmllint --xpath "//*[local-name()='UBLVersionID']/text()" "$file" 2>/dev/null || echo "")
    if [ "$ubl_version" != "2.1" ]; then
        errors+=("UBL version should be 2.1, found: $ubl_version")
    fi
    
    # Check for profile ID
    if ! xmllint --xpath "//*[local-name()='ProfileID' and contains(text(), 'peppol')]" "$file" >/dev/null 2>&1; then
        errors+=("Missing PEPPOL profile ID")
    fi
    
    if [ ${#errors[@]} -eq 0 ]; then
        return 0
    else
        echo "${errors[*]}"
        return 1
    fi
}

validate_file() {
    local file=$1
    local relative_path=${file#$PROJECT_ROOT/}
    
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    echo -e "\n${BLUE}Validating:${NC} $relative_path"
    
    # 1. Check well-formedness
    if ! validate_xml_wellformed "$file"; then
        print_status "FAIL" "$relative_path" "XML is not well-formed"
        log_result "FAIL" "$relative_path - Not well-formed"
        INVALID_FILES=$((INVALID_FILES + 1))
        return 1
    fi
    
    # 2. Validate against UBL schema
    if ! validate_ubl_schema "$file"; then
        print_status "FAIL" "$relative_path" "UBL schema validation failed"
        log_result "FAIL" "$relative_path - Schema validation failed"
        INVALID_FILES=$((INVALID_FILES + 1))
        return 1
    fi
    
    # 3. Basic Singapore compliance checks
    local sg_errors
    if ! sg_errors=$(validate_singapore_basics "$file"); then
        print_status "WARN" "$relative_path" "$sg_errors"
        log_result "WARN" "$relative_path - $sg_errors"
    fi
    
    print_status "PASS" "$relative_path"
    log_result "PASS" "$relative_path"
    VALID_FILES=$((VALID_FILES + 1))
    return 0
}

print_summary() {
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  Validation Summary${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo -e "Total files processed: ${BLUE}$TOTAL_FILES${NC}"
    echo -e "Valid files: ${GREEN}$VALID_FILES${NC}"
    echo -e "Invalid files: ${RED}$INVALID_FILES${NC}"
    
    if [ $INVALID_FILES -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All validations passed!${NC}"
        echo -e "Log file: $VALIDATION_LOG"
        exit 0
    else
        echo -e "\n${RED}❌ Validation errors found${NC}"
        echo -e "Log file: $VALIDATION_LOG"
        exit 1
    fi
}

check_dependencies() {
    if ! command -v xmllint &> /dev/null; then
        echo -e "${RED}Error: xmllint is required but not installed${NC}"
        echo "Install with: sudo apt-get install libxml2-utils (Ubuntu/Debian)"
        echo "or: brew install libxml2 (macOS)"
        exit 1
    fi
}

# Main execution
main() {
    print_header
    check_dependencies
    
    # Initialize log file
    echo "Validation started at $(date)" > "$VALIDATION_LOG"
    
    # Find and validate all XML files
    if [ $# -eq 0 ]; then
        # No arguments, validate all example files
        while IFS= read -r -d '' file; do
            validate_file "$file"
        done < <(find "$EXAMPLES_DIR" -name "*.xml" -type f -print0)
    else
        # Validate specific files
        for file in "$@"; do
            if [ -f "$file" ]; then
                validate_file "$file"
            else
                echo -e "${RED}File not found: $file${NC}"
                TOTAL_FILES=$((TOTAL_FILES + 1))
                INVALID_FILES=$((INVALID_FILES + 1))
            fi
        done
    fi
    
    print_summary
}

# Help function
show_help() {
    cat << EOF
Singapore BIS Billing XML Validator

Usage: $0 [OPTIONS] [FILES...]

If no files are specified, all XML files in the examples directory will be validated.

Options:
    -h, --help     Show this help message
    
Examples:
    $0                                    # Validate all example files
    $0 examples/invoices/basic/*.xml      # Validate specific files
    $0 my-invoice.xml                     # Validate single file

Dependencies:
    - xmllint (libxml2-utils package)

Log file: $VALIDATION_LOG
EOF
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
