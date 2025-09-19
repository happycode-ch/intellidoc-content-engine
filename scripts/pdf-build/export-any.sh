#!/bin/bash
# File: scripts/pdf-build/export-any.sh
# Purpose: Utility script for project operations
# Related: scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit


# Universal PDF Export Script
# Converts any markdown document to professional PDF with smart metadata extraction

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
DEFAULT_AUTHOR="Generated Document"
DEFAULT_SUBTITLE=""
DEFAULT_SUBJECT="Technical Documentation"
DEFAULT_KEYWORDS="documentation, technical, professional"
DEFAULT_LANG="en"
DEFAULT_RIGHTS="© $(date +%Y) - All Rights Reserved"
DEFAULT_FOOTER="Professional Documentation"

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

# Extract metadata from markdown file
extract_metadata() {
    local file="$1"
    local key="$2"
    local default="$3"

    # Try to extract from YAML front matter
    local value=$(sed -n '/^---$/,/^---$/p' "$file" | grep "^$key:" | sed "s/^$key: *//; s/['\"]//g" | head -1)

    # If not found, use default
    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Extract title from markdown
extract_title() {
    local file="$1"

    # First try YAML front matter
    local title=$(extract_metadata "$file" "title" "")

    # If not found, try first # heading
    if [ -z "$title" ]; then
        title=$(grep -m 1 '^# ' "$file" | sed 's/^# //' | sed 's/[[:space:]]*$//')
    fi

    # If still not found, use filename
    if [ -z "$title" ]; then
        title=$(basename "$file" .md | sed 's/[-_]/ /g' | sed 's/\b\(.\)/\u\1/g')
    fi

    echo "$title"
}

# Show usage
show_usage() {
    echo "Universal PDF Export Script"
    echo "==========================="
    echo ""
    echo "Usage: $0 <markdown-file> [options]"
    echo ""
    echo "Options:"
    echo "  -a, --author 'Name'      Set document author"
    echo "  -s, --subtitle 'Text'    Set document subtitle"
    echo "  -d, --date 'YYYY-MM-DD'  Set document date"
    echo "  -k, --keywords 'words'   Set document keywords"
    echo "  -f, --footer 'Text'      Set footer text"
    echo "  -o, --output 'file.pdf'  Set output filename"
    echo "  -t, --toc                Include table of contents (default)"
    echo "  -n, --no-toc             Exclude table of contents"
    echo "  -c, --config 'file'      Use custom metadata config file"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 document.md"
    echo "  $0 report.md --author 'John Doe' --date '2025-01-15'"
    echo "  $0 tutorial.md -a 'Jane Smith' -s 'Complete Guide'"
    echo ""
    echo "The script will:"
    echo "  1. Extract title from markdown (# heading or filename)"
    echo "  2. Extract metadata from YAML front matter if present"
    echo "  3. Use command-line arguments to override"
    echo "  4. Generate professional PDF with Eisvogel template"
}

# Main execution
main() {
    # Check for help or no arguments
    if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi

    # Input file
    INPUT_FILE="$1"
    shift

    # Check if file exists
    if [ ! -f "$INPUT_FILE" ]; then
        print_error "File not found: $INPUT_FILE"
        exit 1
    fi

    print_status "Processing: $INPUT_FILE"

    # Extract default values from markdown
    TITLE=$(extract_title "$INPUT_FILE")
    AUTHOR=$(extract_metadata "$INPUT_FILE" "author" "$DEFAULT_AUTHOR")
    SUBTITLE=$(extract_metadata "$INPUT_FILE" "subtitle" "$DEFAULT_SUBTITLE")
    DATE=$(extract_metadata "$INPUT_FILE" "date" "$(date +%Y-%m-%d)")
    KEYWORDS=$(extract_metadata "$INPUT_FILE" "keywords" "$DEFAULT_KEYWORDS")
    SUBJECT=$(extract_metadata "$INPUT_FILE" "subject" "$DEFAULT_SUBJECT")
    LANG=$(extract_metadata "$INPUT_FILE" "lang" "$DEFAULT_LANG")
    RIGHTS=$(extract_metadata "$INPUT_FILE" "rights" "$DEFAULT_RIGHTS")
    FOOTER_TEXT="$DEFAULT_FOOTER"

    # Default output file
    OUTPUT_FILE="$(basename "$INPUT_FILE" .md).pdf"

    # Include TOC by default
    INCLUDE_TOC="true"

    # Custom config file
    CONFIG_FILE="$SCRIPT_DIR/metadata.yaml"

    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -a|--author)
                AUTHOR="$2"
                shift 2
                ;;
            -s|--subtitle)
                SUBTITLE="$2"
                shift 2
                ;;
            -d|--date)
                DATE="$2"
                shift 2
                ;;
            -k|--keywords)
                KEYWORDS="$2"
                shift 2
                ;;
            -f|--footer)
                FOOTER_TEXT="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -t|--toc)
                INCLUDE_TOC="true"
                shift
                ;;
            -n|--no-toc)
                INCLUDE_TOC="false"
                shift
                ;;
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Display metadata
    echo ""
    print_status "Document Metadata:"
    echo "  Title:    $TITLE"
    [ -n "$SUBTITLE" ] && echo "  Subtitle: $SUBTITLE"
    echo "  Author:   $AUTHOR"
    echo "  Date:     $DATE"
    echo "  Output:   $OUTPUT_FILE"
    echo ""

    # Create temporary metadata file with substituted values
    TEMP_METADATA=$(mktemp /tmp/metadata.XXXXXX.yaml)

    # Use simplified metadata to avoid header conflicts
    if [ -f "$SCRIPT_DIR/metadata-simple.yaml" ]; then
        TEMPLATE_FILE="$SCRIPT_DIR/metadata-simple.yaml"
    elif [ -f "$SCRIPT_DIR/metadata-template.yaml" ]; then
        TEMPLATE_FILE="$SCRIPT_DIR/metadata-template.yaml"
    else
        TEMPLATE_FILE="$CONFIG_FILE"
    fi

    # Substitute variables in metadata
    sed \
        -e "s|\${TITLE}|$TITLE|g" \
        -e "s|\${SUBTITLE}|$SUBTITLE|g" \
        -e "s|\${AUTHOR}|$AUTHOR|g" \
        -e "s|\${DATE}|$DATE|g" \
        -e "s|\${KEYWORDS}|$KEYWORDS|g" \
        -e "s|\${SUBJECT}|$SUBJECT|g" \
        -e "s|\${LANG}|$LANG|g" \
        -e "s|\${RIGHTS}|$RIGHTS|g" \
        -e "s|\${FOOTER_TEXT}|$FOOTER_TEXT|g" \
        "$TEMPLATE_FILE" > "$TEMP_METADATA"

    # Set TOC option
    if [ "$INCLUDE_TOC" = "false" ]; then
        sed -i 's/^toc: true/toc: false/' "$TEMP_METADATA"
    fi

    # Build pandoc command
    print_status "Generating PDF..."

    # Determine paths
    TEMPLATE="$SCRIPT_DIR/templates/eisvogel.tex"
    SYNTAX_THEME="$SCRIPT_DIR/syntax-theme.json"
    OUTPUT_DIR="$SCRIPT_DIR/output"

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Full output path
    FULL_OUTPUT="$OUTPUT_DIR/$OUTPUT_FILE"

    # Check for template
    if [ ! -f "$TEMPLATE" ]; then
        print_warning "Eisvogel template not found, downloading..."
        mkdir -p "$(dirname "$TEMPLATE")"
        curl -L "https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex" \
            -o "$TEMPLATE" 2>/dev/null || {
            print_error "Failed to download template"
            rm -f "$TEMP_METADATA"
            exit 1
        }
    fi

    # Determine PDF engine
    if command -v xelatex &> /dev/null; then
        PDF_ENGINE="xelatex"
    elif command -v pdflatex &> /dev/null; then
        PDF_ENGINE="pdflatex"
    else
        print_error "No LaTeX engine found! Please install texlive or basictex"
        rm -f "$TEMP_METADATA"
        exit 1
    fi

    # Generate PDF
    if [ -f "$SYNTAX_THEME" ]; then
        pandoc "$INPUT_FILE" \
            --from markdown \
            --to pdf \
            --pdf-engine="$PDF_ENGINE" \
            --template="$TEMPLATE" \
            --metadata-file="$TEMP_METADATA" \
            --highlight-style="$SYNTAX_THEME" \
            --number-sections \
            --top-level-division=chapter \
            -o "$FULL_OUTPUT" 2>/dev/null || \
        pandoc "$INPUT_FILE" \
            --from markdown \
            --to pdf \
            --pdf-engine="$PDF_ENGINE" \
            --template="$TEMPLATE" \
            --metadata-file="$TEMP_METADATA" \
            --highlight-style=breezedark \
            --number-sections \
            --top-level-division=chapter \
            -o "$FULL_OUTPUT"
    else
        pandoc "$INPUT_FILE" \
            --from markdown \
            --to pdf \
            --pdf-engine="$PDF_ENGINE" \
            --template="$TEMPLATE" \
            --metadata-file="$TEMP_METADATA" \
            --highlight-style=breezedark \
            --number-sections \
            --top-level-division=chapter \
            -o "$FULL_OUTPUT"
    fi

    # Check if successful
    if [ $? -eq 0 ] && [ -f "$FULL_OUTPUT" ]; then
        print_success "PDF generated successfully!"

        # Show file info
        SIZE=$(ls -lh "$FULL_OUTPUT" | awk '{print $5}')
        echo ""
        print_status "Output file: $FULL_OUTPUT"
        print_status "File size: $SIZE"

        # Copy to current directory if requested
        if [ "$(dirname "$OUTPUT_FILE")" != "." ] && [ "$(dirname "$OUTPUT_FILE")" != "$OUTPUT_DIR" ]; then
            cp "$FULL_OUTPUT" "$OUTPUT_FILE"
            print_status "Also copied to: $OUTPUT_FILE"
        fi

        # Open PDF if on desktop system
        if [[ "$OSTYPE" == "darwin"* ]]; then
            print_status "Opening PDF..."
            open "$FULL_OUTPUT"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [ -n "$DISPLAY" ]; then
            if command -v xdg-open &> /dev/null; then
                print_status "Opening PDF..."
                xdg-open "$FULL_OUTPUT"
            fi
        fi
    else
        print_error "PDF generation failed!"
        rm -f "$TEMP_METADATA"
        exit 1
    fi

    # Clean up
    rm -f "$TEMP_METADATA"

    echo ""
    print_success "Done!"
}

# Run main function with all arguments
main "$@"