# Automation Scripts

## Purpose
Utility scripts for agent management and content operations

## Directory Structure
```
scripts/
├── setup-agents.js              # Agent initialization
├── fix-temporal-hardcoding.sh   # Temporal fixes
├── add-temporal-context.sh      # Context headers
├── verify-fixes.sh              # Validation
├── add-path-configuration.sh    # Path config updates
├── update-orchestrator-handoff.sh # (Obsolete - orchestrators removed)
├── content-management/          # Content & archive scripts
│   ├── archive-all.sh          # Archive docs, content, scripts
│   ├── archive-content.sh      # Archive content only
│   ├── clean-content.sh        # Clean content directories
│   └── setup-content-dirs.sh   # Setup sources structure
├── development/                 # Dev utilities
└── pdf-build/                   # PDF generation
```

## Common Commands

### Agent Management
```bash
# Setup agent symlinks
node setup-agents.js

# Verify agent deployment
./verify-fixes.sh

# Check agent configurations
grep -r "model:" ../agents/*.md | head
```

### Content Fixes
```bash
# Fix temporal hardcoding in agents
./fix-temporal-hardcoding.sh

# Add temporal context to content
./add-temporal-context.sh [file]

# Add path configuration
./add-path-configuration.sh

# (Obsolete - orchestrators removed)
# ./update-orchestrator-handoff.sh

# Verify all fixes applied
./verify-fixes.sh
```

### PDF Generation
```bash
# Generate PDF from markdown
cd pdf-build/
./generate-pdf.sh [input.md] [output.pdf]

# Export any format
./export-any.sh [input] [output]
```

### Development Scripts
```bash
# Run development utilities
cd development/
./[script-name].sh
```

### Content Management
```bash
# Archive everything to .archive/[timestamp]/
cd content-management/
./archive-all.sh
# Answer 'n' to keep originals (backup only)
# Answer 'y' to clean originals after archiving

# Setup content directories with sources/
./setup-content-dirs.sh
# Creates content/sources/{internal,external}

# Other content operations
./[script-name].sh
```

### Archive Operations
```bash
# Create timestamped archive (archives docs/, content/, scripts/)
./content-management/archive-all.sh
# - Archives to .archive/[YYYYMMDD-HHMMSS]/
# - Preserves complete folder structure
# - Includes content/sources/{internal,external}
# - Creates archive summary with restoration instructions
# - Typical archive: ~187 files

# Restore from archive
cp -r ../.archive/[YYYYMMDD-HHMMSS]/content/* ../content/
```

## Script Patterns
- Always backup before modifying
- Use repo-relative paths
- Preserve original formatting
- Log operations for audit

## AI-hints
- Scripts modify agent prompts and content
- Bash scripts use sed/awk for text processing
- All scripts preserve backups before modifications
- Path configurations are repo-relative
- Scripts should be idempotent where possible