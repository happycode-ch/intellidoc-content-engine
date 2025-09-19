#!/bin/bash
# File: scripts/pdf-build/build.sh
# Purpose: Utility script for project operations
# Related: scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit


# Professional PDF Build Script
# Automated PDF generation with dependency checking and optimization

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"
TEMPLATE_URL="https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex"
TEMPLATE="$TEMPLATE_DIR/eisvogel.tex"
OUTPUT_DIR="$SCRIPT_DIR/output"
METADATA="$SCRIPT_DIR/metadata.yaml"
SYNTAX_THEME="$SCRIPT_DIR/syntax-theme.json"

# Function to print colored messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check for required commands
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed!"
        return 1
    fi
    return 0
}

# Install dependencies based on OS
install_dependencies() {
    print_status "Checking system dependencies..."

    local needs_install=false

    if ! check_command pandoc; then
        needs_install=true
        print_warning "Pandoc not found"
    fi

    if ! check_command xelatex && ! check_command pdflatex; then
        needs_install=true
        print_warning "LaTeX not found"
    fi

    if [ "$needs_install" = true ]; then
        print_status "Installing missing dependencies..."

        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get update
            sudo apt-get install -y pandoc texlive-full fonts-firacode fonts-open-sans
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if ! check_command brew; then
                print_error "Homebrew is required on macOS. Please install from https://brew.sh"
                exit 1
            fi
            brew install pandoc basictex
            brew install --cask font-fira-code font-source-sans-pro
        else
            print_error "Unsupported OS: $OSTYPE"
            exit 1
        fi

        print_success "Dependencies installed"
    else
        print_success "All dependencies are already installed"
    fi
}

# Download Eisvogel template
download_template() {
    if [ ! -f "$TEMPLATE" ]; then
        print_status "Downloading Eisvogel template..."
        mkdir -p "$TEMPLATE_DIR"
        curl -L "$TEMPLATE_URL" -o "$TEMPLATE" || {
            print_error "Failed to download template"
            exit 1
        }
        print_success "Template downloaded"
    else
        print_status "Template already exists"
    fi
}

# Find input file
find_input_file() {
    local input_file=""

    # Check for argument
    if [ -n "$1" ]; then
        if [ -f "$1" ]; then
            input_file="$1"
        else
            print_error "File not found: $1"
            print_status "Usage: $0 <markdown-file> [author] [date]"
            exit 1
        fi
    else
        print_error "No input file specified!"
        print_status "Usage: $0 <markdown-file> [author] [date]"
        print_status ""
        print_status "Examples:"
        print_status "  $0 document.md"
        print_status "  $0 report.md 'John Doe'"
        print_status "  $0 tutorial.md 'Jane Smith' '2025-01-15'"
        exit 1
    fi

    echo "$input_file"
}

# Extract title from markdown
extract_title() {
    local file="$1"
    local title=""

    # Try to extract from YAML front matter
    if grep -q '^---$' "$file"; then
        title=$(sed -n '/^---$/,/^---$/p' "$file" | grep '^title:' | sed 's/^title: *//' | sed 's/["\x27]//g' | head -1)
    fi

    # If not found, try first # heading
    if [ -z "$title" ]; then
        title=$(grep -m 1 '^# ' "$file" | sed 's/^# //' | sed 's/[[:space:]]*$//')
    fi

    # If still not found, use filename
    if [ -z "$title" ]; then
        title=$(basename "$file" .md | sed 's/[-_]/ /g')
    fi

    echo "$title"
}

# Generate PDF
generate_pdf() {
    local input_file="$1"
    local output_file="$2"
    local author="$3"
    local date="$4"
    local title="$5"

    print_status "Generating PDF from $(basename "$input_file")..."

    # Determine PDF engine
    local pdf_engine="xelatex"
    if ! command -v xelatex &> /dev/null; then
        pdf_engine="pdflatex"
    fi

    # Create temporary metadata with dynamic values
    local temp_metadata=$(mktemp /tmp/metadata.XXXXXX.yaml)

    # Use template if available, otherwise use existing metadata
    local metadata_source="$METADATA"
    if [ -f "$SCRIPT_DIR/metadata-template.yaml" ]; then
        metadata_source="$SCRIPT_DIR/metadata-template.yaml"
    fi

    # Substitute variables
    sed \
        -e "s|\${TITLE}|$title|g" \
        -e "s|\${AUTHOR}|$author|g" \
        -e "s|\${DATE}|$date|g" \
        -e "s|\${SUBTITLE}||g" \
        -e "s|\${KEYWORDS}|documentation, technical|g" \
        -e "s|\${SUBJECT}|Technical Documentation|g" \
        -e "s|\${LANG}|en|g" \
        -e "s|\${RIGHTS}|© $date - All Rights Reserved|g" \
        -e "s|\${FOOTER_TEXT}|$(basename "$input_file" .md)|g" \
        "$metadata_source" > "$temp_metadata"

    # Build pandoc command
    local pandoc_cmd="pandoc \"$input_file\" \
        --from markdown+yaml_metadata_block+raw_html+fenced_code_blocks+backtick_code_blocks+autolink_bare_uris+space_in_atx_header \
        --to pdf \
        --pdf-engine=$pdf_engine \
        --template=\"$TEMPLATE\" \
        --metadata-file=\"$temp_metadata\" \
        --highlight-style=\"$SYNTAX_THEME\" \
        --toc \
        --toc-depth=2 \
        --number-sections \
        --top-level-division=chapter \
        --standalone \
        -o \"$output_file\""

    # Try with custom syntax theme first
    if eval $pandoc_cmd 2>/dev/null; then
        print_success "PDF generated successfully"
    else
        # Fallback to built-in theme
        print_warning "Custom theme failed, using built-in theme..."
        pandoc "$input_file" \
            --from markdown \
            --to pdf \
            --pdf-engine=$pdf_engine \
            --template="$TEMPLATE" \
            --metadata-file="$temp_metadata" \
            --highlight-style=breezedark \
            --toc \
            --toc-depth=2 \
            --number-sections \
            --top-level-division=chapter \
            -o "$output_file" || {
                print_error "PDF generation failed"
                rm -f "$temp_metadata"
                exit 1
            }
        print_success "PDF generated with fallback settings"
    fi

    # Clean up temp file
    rm -f "$temp_metadata"

    print_success "Output: $output_file"

    # Show file size
    local size=$(ls -lh "$output_file" | awk '{print $5}')
    print_status "File size: $size"
}

# Main execution
main() {
    echo "======================================"
    echo "  Universal PDF Generation System     "
    echo "======================================"
    echo

    # Check/install dependencies
    install_dependencies

    # Download template
    download_template

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Find input file (now required)
    input_file=$(find_input_file "$1")
    print_status "Input file: $input_file"

    # Extract or set metadata
    title=$(extract_title "$input_file")
    author="${2:-Generated Document}"
    date="${3:-$(date +%Y-%m-%d)}"

    # Display metadata
    print_status "Title: $title"
    print_status "Author: $author"
    print_status "Date: $date"

    # Generate output filename
    base_name=$(basename "$input_file" .md)
    output_file="$OUTPUT_DIR/${base_name}.pdf"

    # Check if syntax theme exists
    if [ ! -f "$SYNTAX_THEME" ]; then
        print_warning "Syntax theme not found, using default"
    fi

    # Generate PDF with metadata
    generate_pdf "$input_file" "$output_file" "$author" "$date" "$title"

    echo
    echo "======================================"
    print_success "PDF generation complete!"
    echo "======================================"

    # Open PDF if on macOS or Linux with desktop
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Opening PDF..."
        open "$output_file"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [ -n "$DISPLAY" ]; then
        if command -v xdg-open &> /dev/null; then
            print_status "Opening PDF..."
            xdg-open "$output_file"
        fi
    fi
}

# Run main function
main "$@"