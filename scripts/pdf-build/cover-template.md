# File: scripts/pdf-build/cover-template.md
# Purpose: Project file
# AI-hints:
# - Markdown documentation file
# - Part of distributed documentation system

---
title: "Your Document Title"
subtitle: "Professional Subtitle Here"
author:
  - "Primary Author"
  - "Contributing Author"
date: "2025"
institute: "Your Organization"
keywords:
  - Technical Documentation
  - Professional
  - PDF Generation
abstract: |
  This is an abstract or executive summary of your document.
  It provides a brief overview of the content, key findings,
  and important conclusions. This section is optional but
  recommended for technical documentation and reports.

titlepage: true
titlepage-color: "2E3440"
titlepage-text-color: "ECEFF4"
titlepage-rule-color: "88C0D0"
titlepage-rule-height: 2
logo: "logo.png"
logo-width: 100
---

\newpage

# Preface {.unnumbered}

This document was generated using the Professional PDF Generation System, featuring:

- **Eisvogel LaTeX Template**: Professional book-quality typography
- **Pandoc Markdown**: Flexible content authoring
- **Dark Syntax Highlighting**: Monokai-inspired code blocks
- **Professional Fonts**: Source Sans Pro and Fira Code

## How to Use This Template {.unnumbered}

1. **Edit this file** with your content
2. **Add your logo** as `logo.png` in the same directory
3. **Generate PDF** using:
   ```bash
   ../export-any.sh cover-template.md
   ```

## Document Structure {.unnumbered}

This template includes:

- Professional title page with branding
- Abstract/executive summary
- Numbered sections with proper hierarchy
- Code blocks with syntax highlighting
- Tables and figures support
- Automatic table of contents

\newpage
\tableofcontents
\newpage

# Introduction

Begin your main content here. This section will be numbered automatically.

## Background

Provide context and background information for your document.

### Technical Details

Include detailed technical information with proper formatting:

```javascript
// Example code with syntax highlighting
class DocumentGenerator {
  constructor(options) {
    this.template = options.template || 'eisvogel';
    this.format = options.format || 'pdf';
    this.styling = options.styling || 'professional';
  }

  async generate(markdown) {
    const processed = await this.preprocess(markdown);
    const pdf = await this.convertToPdf(processed);
    return this.postprocess(pdf);
  }
}
```

## Key Features

Highlight important features using various formatting options:

- **Bold text** for emphasis
- *Italic text* for subtle emphasis
- `inline code` for technical terms
- [Hyperlinks](https://example.com) for references

### Tables

Professional tables with alternating row colors:

| Feature | Description | Status |
|---------|-------------|--------|
| Typography | Professional fonts and spacing | ✓ |
| Code Highlighting | Dark theme with syntax colors | ✓ |
| Page Layout | Book-quality margins and headers | ✓ |
| TOC Generation | Automatic with depth control | ✓ |

### Mathematical Equations

Support for LaTeX math expressions:

$$E = mc^2$$

Inline math also works: $\alpha + \beta = \gamma$

## Best Practices

> **Note**: Blockquotes can be used for important callouts and tips.
> They stand out visually and help organize information.

### Code Examples

Multiple programming languages are supported:

```python
# Python example
def generate_pdf(markdown_file, output_file):
    """Convert markdown to PDF with professional styling."""
    with open(markdown_file, 'r') as f:
        content = f.read()

    pdf = PdfGenerator(
        template='eisvogel',
        highlight_style='monokai'
    )

    pdf.convert(content, output_file)
    return output_file
```

```sql
-- SQL example with highlighting
SELECT
    document_id,
    title,
    author,
    created_at
FROM documents
WHERE status = 'published'
ORDER BY created_at DESC
LIMIT 10;
```

# Advanced Features

## Cross-References

You can reference other sections, figures, and tables throughout your document.

## Lists and Enumerations

1. First item
   a. Sub-item one
   b. Sub-item two
2. Second item
   - Bullet point
   - Another bullet
3. Third item

## Diagrams and Visualizations

While this template doesn't include diagram generation by default, you can:

1. Include pre-generated images
2. Use ASCII art for simple diagrams
3. Integrate with PlantUML or Mermaid (requires additional setup)

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Markdown  │────▶│   Pandoc    │────▶│     PDF     │
└─────────────┘     └─────────────┘     └─────────────┘
      Input           Processing           Output
```

# Conclusion

Summarize your key points and findings here.

## Next Steps

1. Review the generated PDF
2. Customize the template as needed
3. Share with your team

## Additional Resources

- [Pandoc Documentation](https://pandoc.org/MANUAL.html)
- [Eisvogel Template](https://github.com/Wandmalfarbe/pandoc-latex-template)
- [Markdown Guide](https://www.markdownguide.org/)

---

*This document was generated using the Professional PDF Generation System.*

*For questions or support, please refer to the README.md in the pdf-build directory.*