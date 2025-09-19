# File: scripts/pdf-build/README.md
# Purpose: Primary documentation for the project
# AI-hints:
# - Markdown documentation file
# - Part of distributed documentation system

# Professional PDF Generation System

A production-ready system for converting Markdown documentation to beautifully formatted PDFs with professional book-quality typography, syntax highlighting, and layout.

## Features

- **Professional Typography**: Source Sans Pro for text, Fira Code for code blocks
- **Dark Syntax Highlighting**: Monokai-inspired theme for code blocks
- **Book-Quality Layout**: O'Reilly/Pragmatic Programmer aesthetic
- **Automated Build**: One-command PDF generation with dependency management
- **Cross-Platform**: Works on Linux, macOS, and WSL
- **Multiple Formats**: PDF and ePub output support

## Quick Start

### Generate PDF with Make

```bash
# Generate PDF from tutorial.md or most recent article
make pdf

# Generate PDF from specific file
make pdf FILE=path/to/your-document.md

# Generate ePub
make epub
```

### Generate PDF with Build Script

```bash
# Run the automated build script
./build.sh

# Or specify a file
./build.sh path/to/document.md
```

## Installation

### Automatic Installation

The Makefile and build script automatically install dependencies:

```bash
# Check and install all dependencies
make check-deps

# Install professional fonts
make install-fonts

# Download Eisvogel template
make get-template
```

### Manual Installation

#### Linux (Ubuntu/Debian)

```bash
# Install Pandoc and LaTeX
sudo apt-get update
sudo apt-get install -y pandoc texlive-full

# Install fonts
sudo apt-get install -y fonts-firacode fonts-open-sans
fc-cache -f -v
```

#### macOS

```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Pandoc and LaTeX
brew install pandoc
brew install --cask basictex

# Install fonts
brew install --cask font-fira-code font-source-sans-pro
```

#### Windows (WSL)

Follow the Linux instructions inside WSL. For native Windows, use:

```powershell
# Install Pandoc
choco install pandoc

# Install MiKTeX for LaTeX
choco install miktex
```

## Project Structure

```
pdf-build/
├── Makefile              # Build automation with targets
├── build.sh             # Standalone build script
├── metadata.yaml        # PDF metadata and settings
├── syntax-theme.json    # Custom syntax highlighting
├── custom-pdf-style.css # CSS for VS Code export
├── templates/
│   └── eisvogel.tex    # Professional LaTeX template
├── output/             # Generated PDFs
└── README.md           # This file
```

## Customization

### Modify Document Metadata

Edit `metadata.yaml` to customize:

- Title, subtitle, and author
- Paper size and margins
- Fonts and typography
- Header/footer content
- Link colors and styling

### Change Syntax Highlighting

The `syntax-theme.json` defines code block colors. Modify the color values to match your preference:

```json
{
  "text-color": "#f8f8f2",
  "background-color": "#272822",
  "keyword": { "text-color": "#f92672" }
}
```

### Add a Cover Page

Create `cover.md` with your cover content:

```markdown
---
title-page: true
title: "Your Book Title"
subtitle: "Professional Subtitle"
author: "Author Name"
date: "2025"
logo: "logo.png"
---
```

Then build with:

```bash
pandoc cover.md content.md -o output.pdf --template=templates/eisvogel.tex
```

### Custom Headers and Footers

Add to `metadata.yaml`:

```yaml
header-includes: |
  \fancyhead[LE,RO]{\thepage}
  \fancyhead[LO]{Chapter \thechapter}
  \fancyhead[RE]{\leftmark}
  \fancyfoot[C]{Your Custom Footer}
```

## Export to ePub

Generate ePub for e-readers:

```bash
# Using Make
make epub

# Direct Pandoc command
pandoc input.md \
  --to epub3 \
  --metadata-file=metadata.yaml \
  --toc \
  -o output.epub
```

### ePub Customization

Add to `metadata.yaml`:

```yaml
epub-metadata: metadata.xml
epub-stylesheet: epub-style.css
epub-cover-image: cover.jpg
epub-fonts:
  - FiraCode-Regular.ttf
  - SourceSansPro-Regular.ttf
```

## VS Code Alternative (Quick Export)

For quick PDF generation without LaTeX:

### Install VS Code Extension

```bash
code --install-extension yzane.markdown-pdf
```

### Use Provided Settings

The `.vscode/settings.json` configures optimal PDF export:

- Professional margins and headers
- GitHub-flavored markdown CSS
- Syntax highlighting
- Custom fonts

### Export from VS Code

1. Open your markdown file
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Select "Markdown PDF: Export (pdf)"

## Advanced Usage

### Batch Processing

Convert multiple files:

```bash
for file in content/*.md; do
  make pdf FILE="$file"
done
```

### CI/CD Integration

Add to GitHub Actions:

```yaml
- name: Generate PDF
  run: |
    cd pdf-build
    make pdf FILE=${{ github.workspace }}/docs/manual.md

- name: Upload PDF
  uses: actions/upload-artifact@v2
  with:
    name: documentation-pdf
    path: pdf-build/output/*.pdf
```

### Docker Container

Build PDFs in isolated environment:

```dockerfile
FROM pandoc/latex:latest
WORKDIR /workspace
COPY . .
RUN make pdf
```

## Troubleshooting

### Common Issues

#### "Pandoc not found"

```bash
# Install Pandoc
make check-deps
```

#### "LaTeX Error: File not found"

```bash
# Install full LaTeX distribution
sudo apt-get install texlive-full  # Linux
brew install --cask mactex          # macOS
```

#### "Font not found"

```bash
# Install fonts and rebuild cache
make install-fonts
fc-cache -f -v  # Linux only
```

#### Template Download Failed

```bash
# Manual download
curl -L https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex \
  -o templates/eisvogel.tex
```

### Debug Mode

Enable verbose output:

```bash
# Verbose Pandoc output
pandoc input.md -o output.pdf --verbose

# Check LaTeX log
pandoc input.md -o output.pdf --pdf-engine-opt=-interaction=nonstopmode
```

## Performance Tips

1. **Cache Templates**: Templates are downloaded once and reused
2. **Optimize Images**: Compress images before including
3. **Use References**: For repeated content, use Pandoc references
4. **Parallel Builds**: Use `make -j4` for parallel processing

## Examples

### Technical Blog Post

```bash
make pdf FILE=blog-post.md
```

### API Documentation

```bash
pandoc api-docs.md \
  --template=templates/eisvogel.tex \
  --metadata-file=metadata.yaml \
  --toc-depth=3 \
  -o api-documentation.pdf
```

### Tutorial Series

```bash
# Combine multiple files
pandoc intro.md chapter1.md chapter2.md \
  --template=templates/eisvogel.tex \
  --metadata title="Complete Tutorial" \
  -o tutorial-complete.pdf
```

## Resources

- [Pandoc Documentation](https://pandoc.org/MANUAL.html)
- [Eisvogel Template](https://github.com/Wandmalfarbe/pandoc-latex-template)
- [LaTeX Font Catalogue](https://tug.org/FontCatalogue/)
- [Pandoc Filters](https://pandoc.org/filters.html)

## License

This PDF generation system is provided as-is for use with your documentation projects.

## Contributing

To improve this system:

1. Test with your documents
2. Report issues or suggestions
3. Share custom themes or templates
4. Contribute automation scripts

---

*Built for professional technical documentation with production-quality output.*