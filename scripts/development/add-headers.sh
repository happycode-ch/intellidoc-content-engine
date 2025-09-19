#!/bin/bash
# File: scripts/development/add-headers-fixed.sh
# Purpose: Add standardized headers to all project files
# Related: scripts/development/README.md
# AI-hints:
# - Side effects: Modifies files in-place, creates backups
# - Key operations: Header detection, generation, and insertion
# - Constraints: Skips files with existing headers
# - Exclusions: .archive/*, temp_agent_outputs/*, backups

# Don't use set -e as we handle errors ourselves

# Configuration
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR=".archive/headers-backup-$TIMESTAMP"
DRY_RUN=false
TEST_MODE=false
TEST_COUNT=5

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      echo "🔍 DRY RUN MODE - No files will be modified"
      shift
      ;;
    --test)
      TEST_MODE=true
      echo "🧪 TEST MODE - Processing first $TEST_COUNT files only"
      shift
      ;;
    --help)
      echo "Usage: $0 [--dry-run] [--test]"
      echo "  --dry-run : Preview changes without modifying files"
      echo "  --test    : Process only first $TEST_COUNT files"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Create backup directory
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$BACKUP_DIR"
  echo "📁 Backup directory: $BACKUP_DIR"
fi

# Function to check if file already has a header
has_header() {
  local file="$1"
  # Check for "# File:" or "File:" pattern in first 10 lines
  head -n 10 "$file" 2>/dev/null | grep -q "^#\? *File:" && return 0
  return 1
}

# Function to get file purpose based on filename and path
get_file_purpose() {
  local file="$1"
  local basename=$(basename "$file")
  local dirname=$(dirname "$file")

  # Agent files
  if [[ "$dirname" == *"agents"* ]]; then
    case "$basename" in
      *writer*.md) echo "Write content sections with context and evidence" ;;
      *researcher*.md) echo "Research and gather information for content" ;;
      *analyzer*.md) echo "Analyze content for quality and improvements" ;;
      *formatter*.md) echo "Format content for specific platforms" ;;
      *translator*.md) echo "Translate content to target languages" ;;
      *verifier*.md) echo "Verify content accuracy and compliance" ;;
      *assembler*.md) echo "Consolidate content fragments into final output" ;;
      CLAUDE.md) echo "Agent system documentation and specifications" ;;
      *) echo "Specialized agent for content creation pipeline" ;;
    esac
  # Template files
  elif [[ "$dirname" == *"templates"* ]]; then
    case "$basename" in
      *blog*.md) echo "Template for creating blog posts with parallel agents" ;;
      *tutorial*.md) echo "Template for step-by-step tutorials with exercises" ;;
      *news*.md) echo "Template for rapid news article creation" ;;
      *social*.md) echo "Template for multi-platform social media content" ;;
      *whitepaper*.md) echo "Template for long-form authoritative content" ;;
      *series*.md) echo "Template for multi-part content series" ;;
      *swiss*.md) echo "Template for Swiss multilingual content" ;;
      CLAUDE.md) echo "Template system documentation and workflow patterns" ;;
      *) echo "Content creation workflow template" ;;
    esac
  # Script files
  elif [[ "$file" == *.sh ]]; then
    case "$basename" in
      *archive*.sh) echo "Archive and backup project content" ;;
      *clean*.sh) echo "Clean generated content and temporary files" ;;
      *setup*.sh) echo "Setup project directories and configuration" ;;
      *deploy*.sh) echo "Deploy agents to Claude configuration" ;;
      *test*.sh) echo "Test agent functionality and workflows" ;;
      *add-headers*.sh) echo "Add standardized headers to all project files" ;;
      *) echo "Utility script for project operations" ;;
    esac
  # Documentation files
  elif [[ "$basename" == "CLAUDE.md" ]]; then
    echo "Navigation and documentation for $(basename "$dirname") directory"
  elif [[ "$basename" == "README.md" ]]; then
    echo "Primary documentation for the project"
  elif [[ "$basename" == "CHANGELOG.md" ]]; then
    echo "Track project changes and version history"
  # YAML files
  elif [[ "$file" == *.yaml ]] || [[ "$file" == *.yml ]]; then
    case "$basename" in
      *routing*.yaml) echo "Configure content routing and organization" ;;
      *config*.yaml) echo "Project configuration settings" ;;
      *) echo "Configuration file" ;;
    esac
  else
    echo "Project file"
  fi
}

# Function to get related files
get_related_files() {
  local file="$1"
  local basename=$(basename "$file")
  local dirname=$(dirname "$file")
  local related=""

  # For agent files, relate to templates and CLAUDE.md
  if [[ "$dirname" == *"agents"* ]]; then
    related="agents/CLAUDE.md, templates/"
  # For templates, relate to agents
  elif [[ "$dirname" == *"templates"* ]]; then
    related="agents/, templates/CLAUDE.md"
  # For scripts, relate to other scripts in same directory
  elif [[ "$file" == *.sh ]]; then
    if [[ "$dirname" == *"content-management"* ]]; then
      related="scripts/content-management/, scripts/CLAUDE.md"
    else
      related="scripts/CLAUDE.md"
    fi
  # For CLAUDE.md files, relate to parent CLAUDE.md
  elif [[ "$basename" == "CLAUDE.md" ]]; then
    if [[ "$dirname" != "." ]]; then
      related=".claude/CLAUDE.md, CLAUDE.md"
    else
      related=".claude/CLAUDE.md"
    fi
  fi

  echo "$related"
}

# Function to get AI hints based on file type
get_ai_hints() {
  local file="$1"
  local hints=""

  if [[ "$file" == *.md ]]; then
    if [[ "$file" == *"agents"*".md" ]]; then
      hints="# - Agent configuration with model and tools\n# - Single responsibility principle enforced\n# - Part of 46-agent content creation system"
    elif [[ "$file" == *"templates"*".md" ]]; then
      hints="# - XML workflow pattern for parallel execution\n# - Orchestrates multiple agents in phases\n# - Direct invocation replaces orchestrator agents"
    else
      hints="# - Markdown documentation file\n# - Part of distributed documentation system"
    fi
  elif [[ "$file" == *.sh ]]; then
    hints="# - Side effects: File operations, directory changes\n# - Requires bash shell environment\n# - Part of project automation toolkit"
  elif [[ "$file" == *.yaml ]] || [[ "$file" == *.yml ]]; then
    hints="# - YAML configuration file\n# - Parsed by content routing system\n# - Defines project structure and settings"
  fi

  echo -e "$hints"
}

# Function to add header to file
add_header_to_file() {
  local file="$1"
  local rel_path="${file#./}"  # Remove leading ./

  # Skip if file already has header
  if has_header "$file"; then
    echo "  ⏭️  Skipping (has header): $rel_path"
    return 1  # Return 1 to indicate skipped
  fi

  # Generate header components
  local purpose=$(get_file_purpose "$file")
  local related=$(get_related_files "$file")
  local hints=$(get_ai_hints "$file")

  # Build header based on file type
  local header=""
  if [[ "$file" == *.sh ]]; then
    # For shell scripts, insert after shebang
    if head -n 1 "$file" | grep -q "^#!/"; then
      # Has shebang, insert after it
      header="# File: $rel_path\n# Purpose: $purpose"
      if [[ -n "$related" ]]; then
        header="$header\n# Related: $related"
      fi
      header="$header\n# AI-hints:\n$hints\n"
    else
      # No shebang, add it with header
      header="#!/bin/bash\n# File: $rel_path\n# Purpose: $purpose"
      if [[ -n "$related" ]]; then
        header="$header\n# Related: $related"
      fi
      header="$header\n# AI-hints:\n$hints\n"
    fi
  else
    # For other files (MD, YAML)
    header="# File: $rel_path\n# Purpose: $purpose"
    if [[ -n "$related" ]]; then
      header="$header\n# Related: $related"
    fi
    header="$header\n# AI-hints:\n$hints\n"
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "  📝 Would add header to: $rel_path"
    echo "     Purpose: $purpose"
    if [[ -n "$related" ]]; then
      echo "     Related: $related"
    fi
    return 0
  fi

  # Backup file
  local backup_file="$BACKUP_DIR/$rel_path"
  mkdir -p "$(dirname "$backup_file")"
  cp "$file" "$backup_file"

  # Add header to file
  if [[ "$file" == *.sh ]] && head -n 1 "$file" | grep -q "^#!/"; then
    # Shell script with shebang - insert header after first line
    local tmpfile=$(mktemp)
    head -n 1 "$file" > "$tmpfile"
    echo -e "$header" >> "$tmpfile"
    tail -n +2 "$file" >> "$tmpfile"
    mv "$tmpfile" "$file"
  else
    # Other files - prepend header
    local tmpfile=$(mktemp)
    echo -e "$header" > "$tmpfile"
    cat "$file" >> "$tmpfile"
    mv "$tmpfile" "$file"
  fi

  echo "  ✅ Added header to: $rel_path"
  return 0
}

# Main processing
echo ""
echo "=== Adding Headers to Project Files ==="
echo ""

# Get list of files to process
mapfile -t files < <(find . -type f \( -name "*.md" -o -name "*.sh" -o -name "*.yaml" -o -name "*.yml" \) \
  ! -path "./.archive/*" \
  ! -path "./.claude/agents.backup*" \
  ! -path "./node_modules/*" \
  ! -path "./.git/*" \
  ! -path "./temp_agent_outputs/*" \
  | sort)

total_files=${#files[@]}
echo "Found $total_files files to process"
echo ""

# Process files
processed=0
skipped=0
errors=0

for file in "${files[@]}"; do
  if [ "$TEST_MODE" = true ] && [ $processed -ge $TEST_COUNT ]; then
    echo ""
    echo "🧪 Test mode: Stopping after $TEST_COUNT files processed"
    break
  fi

  add_header_to_file "$file"
  result=$?

  if [ $result -eq 0 ]; then
    ((processed++))
  elif [ $result -eq 1 ]; then
    ((skipped++))
  else
    ((errors++))
  fi
done

# Summary
echo ""
echo "=== Summary ==="
echo "✅ Processed: $processed files"
echo "⏭️  Skipped: $skipped files (already have headers)"
if [ $errors -gt 0 ]; then
  echo "❌ Errors: $errors files"
fi

if [ "$DRY_RUN" = false ] && [ $processed -gt 0 ]; then
  echo ""
  echo "📁 Backups saved to: $BACKUP_DIR"
  echo ""
  echo "To restore original files:"
  echo "  cp -r $BACKUP_DIR/* ."
fi

echo ""
echo "✨ Header addition complete!"