# Professional PDF Generation Makefile
# Generates publication-quality PDFs from Markdown using Pandoc + Eisvogel

# Variables
PANDOC := pandoc
LATEX := xelatex
INPUT_DIR := ../content/articles
OUTPUT_DIR := ./output
TEMPLATE_DIR := ./templates
TEMPLATE_URL := https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex
TEMPLATE := $(TEMPLATE_DIR)/eisvogel.tex
METADATA := metadata.yaml
SYNTAX_THEME := syntax-theme.json

# OS Detection
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    INSTALL_CMD := sudo apt-get update && sudo apt-get install -y
    PANDOC_PKG := pandoc
    LATEX_PKG := texlive-full
    FONT_PKG := fonts-firacode fonts-open-sans
endif
ifeq ($(UNAME_S),Darwin)
    INSTALL_CMD := brew install
    PANDOC_PKG := pandoc
    LATEX_PKG := basictex
    FONT_PKG := font-fira-code font-source-sans-pro
endif

# Default target
.PHONY: all
all: check-deps pdf

# Check and install dependencies
.PHONY: check-deps
check-deps:
	@echo "Checking dependencies..."
	@command -v $(PANDOC) >/dev/null 2>&1 || (echo "Installing Pandoc..." && $(INSTALL_CMD) $(PANDOC_PKG))
	@command -v $(LATEX) >/dev/null 2>&1 || (echo "Installing LaTeX..." && $(INSTALL_CMD) $(LATEX_PKG))
	@echo "Dependencies checked ✓"

# Install fonts
.PHONY: install-fonts
install-fonts:
	@echo "Installing professional fonts..."
ifeq ($(UNAME_S),Linux)
	@$(INSTALL_CMD) $(FONT_PKG) || true
	@fc-cache -f -v
endif
ifeq ($(UNAME_S),Darwin)
	@$(INSTALL_CMD) $(FONT_PKG) || true
endif
	@echo "Fonts installed ✓"

# Download Eisvogel template
.PHONY: get-template
get-template:
	@mkdir -p $(TEMPLATE_DIR)
	@if [ ! -f $(TEMPLATE) ]; then \
		echo "Downloading Eisvogel template..."; \
		curl -L $(TEMPLATE_URL) -o $(TEMPLATE); \
		echo "Template downloaded ✓"; \
	else \
		echo "Template already exists ✓"; \
	fi

# Create output directory
$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

# Generate syntax highlighting theme
.PHONY: syntax-theme
syntax-theme:
	@if [ ! -f $(SYNTAX_THEME) ]; then \
		echo "Generating syntax theme..."; \
		pandoc --print-highlight-style breezedark > $(SYNTAX_THEME) 2>/dev/null || \
		pandoc --print-highlight-style zenburn > $(SYNTAX_THEME) 2>/dev/null || \
		echo '{"text-color":"#f8f8f2","background-color":"#272822","line-number-color":"#75715e","line-number-background-color":"#272822"}' > $(SYNTAX_THEME); \
		echo "Syntax theme created ✓"; \
	fi

# Main PDF generation target (universal)
.PHONY: pdf
pdf: check-deps get-template syntax-theme $(OUTPUT_DIR)
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify a markdown file"; \
		echo "Usage: make pdf FILE=yourfile.md"; \
		echo ""; \
		echo "You can also use: make pdf-auto to find files automatically"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "Error: File not found: $(FILE)"; \
		exit 1; \
	fi
	@echo "Generating PDF from $(FILE)..."
	@OUTPUT_FILE="$(OUTPUT_DIR)/$$(basename $(FILE) .md).pdf"; \
	TITLE=$$(grep -m 1 '^# ' $(FILE) | sed 's/^# //') || TITLE=$$(basename $(FILE) .md); \
	AUTHOR="$${AUTHOR:-Generated Document}"; \
	DATE="$${DATE:-$$(date +%Y-%m-%d)}"; \
	$(PANDOC) $(FILE) \
		--from markdown \
		--to pdf \
		--pdf-engine=$(LATEX) \
		--template=$(TEMPLATE) \
		--metadata-file=$(METADATA) \
		--metadata title="$$TITLE" \
		--metadata author="$$AUTHOR" \
		--metadata date="$$DATE" \
		--highlight-style=$(SYNTAX_THEME) \
		--toc \
		--toc-depth=2 \
		--number-sections \
		--top-level-division=chapter \
		--filter pandoc-crossref 2>/dev/null || \
	$(PANDOC) $(FILE) \
		--from markdown \
		--to pdf \
		--pdf-engine=$(LATEX) \
		--template=$(TEMPLATE) \
		--metadata-file=$(METADATA) \
		--metadata title="$$TITLE" \
		--metadata author="$$AUTHOR" \
		--metadata date="$$DATE" \
		--highlight-style=breezedark \
		--toc \
		--toc-depth=2 \
		--number-sections \
		--top-level-division=chapter \
		-o "$$OUTPUT_FILE"; \
	echo "✓ PDF generated: $$OUTPUT_FILE"

# Auto-find PDF generation (legacy support)
.PHONY: pdf-auto
pdf-auto: check-deps get-template syntax-theme $(OUTPUT_DIR)
	@echo "Auto-finding markdown file..."
	@if [ -f "tutorial.md" ]; then \
		INPUT_FILE="tutorial.md"; \
	elif [ -f "../tutorial.md" ]; then \
		INPUT_FILE="../tutorial.md"; \
	else \
		INPUT_FILE=$$(find . -name "*.md" -not -path "./output/*" -type f 2>/dev/null | head -1); \
	fi; \
	if [ -z "$$INPUT_FILE" ] || [ ! -f "$$INPUT_FILE" ]; then \
		echo "Error: No markdown file found!"; \
		exit 1; \
	fi; \
	$(MAKE) pdf FILE="$$INPUT_FILE"


# Generate ePub
.PHONY: epub
epub: check-deps $(OUTPUT_DIR)
	@echo "Generating ePub..."
	@if [ -f "tutorial.md" ]; then \
		INPUT_FILE="tutorial.md"; \
	elif [ -f "../tutorial.md" ]; then \
		INPUT_FILE="../tutorial.md"; \
	else \
		INPUT_FILE=$$(find $(INPUT_DIR) -name "*.md" -type f 2>/dev/null | head -1); \
	fi; \
	OUTPUT_FILE="$(OUTPUT_DIR)/$$(basename $$INPUT_FILE .md).epub"; \
	$(PANDOC) "$$INPUT_FILE" \
		--from markdown \
		--to epub3 \
		--metadata-file=$(METADATA) \
		--highlight-style=breezedark \
		--toc \
		--toc-depth=2 \
		--epub-chapter-level=2 \
		-o "$$OUTPUT_FILE"
	@echo "✓ ePub generated: $$OUTPUT_FILE"

# Clean generated files
.PHONY: clean
clean:
	@echo "Cleaning generated files..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Clean complete ✓"

# Clean everything including template
.PHONY: clean-all
clean-all: clean
	@echo "Removing template..."
	@rm -rf $(TEMPLATE_DIR)
	@rm -f $(SYNTAX_THEME)
	@echo "Full clean complete ✓"

# Show help
.PHONY: help
help:
	@echo "Universal PDF Generation System"
	@echo "================================"
	@echo ""
	@echo "Commands:"
	@echo "  make pdf FILE=doc.md      - Generate PDF from specific markdown file"
	@echo "  make pdf-auto             - Auto-find and convert markdown file"
	@echo "  make epub FILE=doc.md     - Generate ePub from specific file"
	@echo "  make check-deps           - Check and install dependencies"
	@echo "  make install-fonts        - Install professional fonts"
	@echo "  make get-template         - Download Eisvogel LaTeX template"
	@echo "  make clean                - Remove generated files"
	@echo "  make clean-all            - Remove everything including templates"
	@echo "  make help                 - Show this help message"
	@echo ""
	@echo "Environment Variables:"
	@echo "  AUTHOR='Your Name'       - Set document author"
	@echo "  DATE='2025-01-15'         - Set document date"
	@echo ""
	@echo "Examples:"
	@echo "  make pdf FILE=document.md"
	@echo "  AUTHOR='John Doe' make pdf FILE=report.md"
	@echo "  make pdf FILE=../content/articles/tutorial.md"