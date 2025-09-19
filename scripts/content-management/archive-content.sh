#!/bin/bash
# File: scripts/content-management/archive-content.sh
# Purpose: Archive and backup project content
# Related: scripts/content-management/, scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit

# Archive all content to timestamped folder

echo "=== Content Archive System ==="
echo ""

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_DIR="content/.archive/$TIMESTAMP"

# Count current content
TOTAL_FILES=$(find content -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh content 2>/dev/null | cut -f1)

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "⚠️  No content to archive"
    exit 0
fi

echo "Found $TOTAL_FILES files to archive ($TOTAL_SIZE)"
echo "Archive destination: $ARCHIVE_DIR"
echo ""

# Create archive directory
mkdir -p "$ARCHIVE_DIR"

# Archive each content type (preserve structure)
echo "Archiving content..."

for dir in blog tutorials news whitepapers series social swiss articles assets prompts_to_create_content; do
    if [ -d "content/$dir" ] && [ "$(ls -A content/$dir 2>/dev/null | grep -v '\.gitkeep')" ]; then
        echo "  → Archiving $dir..."
        cp -r "content/$dir" "$ARCHIVE_DIR/"
    fi
done

# Archive any loose files in content root
for file in content/*; do
    if [ -f "$file" ] && [ "$(basename "$file")" != ".gitkeep" ]; then
        echo "  → Archiving $(basename "$file")"
        cp "$file" "$ARCHIVE_DIR/"
    fi
done

# Archive other directories not in standard list
for dir in content/*/; do
    dir_name=$(basename "$dir")
    if [[ ! " blog tutorials news whitepapers series social swiss articles assets prompts_to_create_content .archive " =~ " $dir_name " ]]; then
        if [ "$(ls -A "$dir" 2>/dev/null | grep -v '\.gitkeep')" ]; then
            echo "  → Archiving $dir_name..."
            cp -r "$dir" "$ARCHIVE_DIR/"
        fi
    fi
done

# Create archive summary
cat > "$ARCHIVE_DIR/ARCHIVE_INFO.txt" << EOF
=====================================
Content Archive Information
=====================================
Archive Date: $(date)
Archive ID: $TIMESTAMP

Content Statistics:
-------------------
Total Files: $(find "$ARCHIVE_DIR" -type f | wc -l)
Total Size: $(du -sh "$ARCHIVE_DIR" | cut -f1)

Content Types Archived:
-----------------------
$(for d in "$ARCHIVE_DIR"/*/; do [ -d "$d" ] && echo "  - $(basename "$d")" || true; done | grep -v "^\s*$" | sort)

Notes:
------
This archive was created by the IntelliDoc Content Engine
Archive system. All content has been preserved with its
original structure.

To restore this archive:
  cp -r "$ARCHIVE_DIR"/* content/
EOF

echo ""
echo "✅ Archive created successfully!"
echo ""

# Clean the original directories (keep .gitkeep files)
echo "Cleaning original directories..."
find content -type f ! -name ".gitkeep" ! -path "content/.archive/*" -delete 2>/dev/null
find content -type d -empty ! -path "content/.archive*" -delete 2>/dev/null || true

echo "✅ Content directories cleaned"
echo ""
echo "Archive location: $ARCHIVE_DIR"
echo "Archive summary: $ARCHIVE_DIR/ARCHIVE_INFO.txt"
echo ""

# Show what was archived
echo "Archived content types:"
ls -d "$ARCHIVE_DIR"/*/ 2>/dev/null | xargs -n1 basename | sed 's/^/  - /' | sort