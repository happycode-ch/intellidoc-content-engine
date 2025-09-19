#!/bin/bash
# File: scripts/content-management/archive-all.sh
# Purpose: Archive and backup project content
# Related: scripts/content-management/, scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit

# Archive docs, content, scripts, and my-notes to root .archive directory
# Note: Scripts are archived but NEVER cleaned (infrastructure must remain)

echo "=== Project Archive System ==="
echo ""

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_DIR=".archive/$TIMESTAMP"

# Count current content across all directories
TOTAL_FILES=0
for dir in docs content scripts my-notes; do
    if [ -d "$dir" ]; then
        COUNT=$(find "$dir" -type f ! -name ".gitkeep" 2>/dev/null | wc -l)
        TOTAL_FILES=$((TOTAL_FILES + COUNT))
    fi
done

# Get total size
TOTAL_SIZE=$(du -sh docs content scripts my-notes 2>/dev/null | awk '{sum+=$1} END {print sum}')

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "⚠️  No files to archive"
    exit 0
fi

echo "Found $TOTAL_FILES files to archive"
echo "Archive destination: $ARCHIVE_DIR"
echo ""

# Create archive directory
mkdir -p "$ARCHIVE_DIR"

# Archive docs directory
if [ -d "docs" ] && [ "$(find docs -type f ! -name ".gitkeep" | head -1)" ]; then
    echo "Archiving docs/..."
    cp -r docs "$ARCHIVE_DIR/"
    echo "  ✓ Archived $(find docs -type f | wc -l) files from docs/"
fi

# Archive content directory (including sources with internal/external)
if [ -d "content" ] && [ "$(find content -type f ! -name ".gitkeep" ! -path "content/.archive/*" | head -1)" ]; then
    echo "Archiving content/..."
    # Create content directory in archive
    mkdir -p "$ARCHIVE_DIR/content"

    # Copy all content except the .archive directory inside content
    for item in content/*; do
        if [ -e "$item" ]; then
            basename_item=$(basename "$item")
            if [ "$basename_item" != ".archive" ]; then
                cp -r "$item" "$ARCHIVE_DIR/content/"
            fi
        fi
    done

    # Also copy hidden files except .archive
    for item in content/.*; do
        basename_item=$(basename "$item")
        if [ -e "$item" ] && [ "$basename_item" != "." ] && [ "$basename_item" != ".." ] && [ "$basename_item" != ".archive" ]; then
            cp -r "$item" "$ARCHIVE_DIR/content/"
        fi
    done

    echo "  ✓ Archived $(find content -type f ! -path "content/.archive/*" | wc -l) files from content/"

    # Special note if sources directory was archived
    if [ -d "$ARCHIVE_DIR/content/sources" ]; then
        echo "  ✓ Preserved sources/ with internal/external structure"
    fi
fi

# Archive scripts directory
if [ -d "scripts" ] && [ "$(find scripts -type f ! -name ".gitkeep" | head -1)" ]; then
    echo "Archiving scripts/..."
    cp -r scripts "$ARCHIVE_DIR/"
    echo "  ✓ Archived $(find scripts -type f | wc -l) files from scripts/"
fi

# Archive my-notes directory (personal notes)
if [ -d "my-notes" ] && [ "$(find my-notes -type f ! -name ".gitkeep" | head -1)" ]; then
    echo "Archiving my-notes/..."
    cp -r my-notes "$ARCHIVE_DIR/"
    echo "  ✓ Archived $(find my-notes -type f | wc -l) files from my-notes/"
    echo "  ✓ Preserved notes/ and conversation-summaries/ structure"
fi

# Create archive summary
cat > "$ARCHIVE_DIR/ARCHIVE_INFO.txt" << EOF
=====================================
Project Archive Information
=====================================
Archive Date: $(date)
Archive ID: $TIMESTAMP

Archive Statistics:
-------------------
Total Files: $(find "$ARCHIVE_DIR" -type f | wc -l)
Total Size: $(du -sh "$ARCHIVE_DIR" | cut -f1)

Directories Archived:
---------------------
$(for d in "$ARCHIVE_DIR"/*/; do [ -d "$d" ] && echo "  - $(basename "$d")" || true; done | grep -v "^\s*$" | sort)

Content Structure:
------------------
$(if [ -d "$ARCHIVE_DIR/content" ]; then
    echo "content/"
    find "$ARCHIVE_DIR/content" -type d | sed "s|$ARCHIVE_DIR/content||" | head -20 | sed 's/^/  /'
fi)

Notes:
------
This archive was created by the IntelliDoc Content Engine
archive system. All directories have been preserved with their
original structure including personal notes.

To restore this archive:
  # Full restoration
  cp -r $ARCHIVE_DIR/* .

  # Selective restoration
  cp -r $ARCHIVE_DIR/docs/* docs/
  cp -r $ARCHIVE_DIR/content/* content/
  cp -r $ARCHIVE_DIR/scripts/* scripts/
  cp -r $ARCHIVE_DIR/my-notes/* my-notes/

To view archive contents:
  tree $ARCHIVE_DIR/
EOF

echo ""
echo "✅ Archive created successfully!"
echo ""

# Ask if user wants to clean the directories
echo "Do you want to clean the original directories? (y/n)"
read -n 1 -r REPLY
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleaning original directories (excluding scripts)..."

    # Clean docs directory
    if [ -d "docs" ]; then
        find docs -type f ! -name ".gitkeep" -delete 2>/dev/null
        find docs -type d -empty ! -name "docs" -delete 2>/dev/null || true
        echo "  ✓ Cleaned docs/"
    fi

    # Clean content directory (preserve .archive and sources structure)
    if [ -d "content" ]; then
        find content -type f ! -name ".gitkeep" ! -path "content/.archive/*" -delete 2>/dev/null
        find content -type d -empty ! -path "content/.archive*" ! -path "content/sources*" ! -name "content" -delete 2>/dev/null || true

        # Recreate sources structure if it was cleaned
        if [ ! -d "content/sources/internal" ]; then
            mkdir -p content/sources/{internal,external}
            touch content/sources/.gitkeep
            touch content/sources/internal/.gitkeep
            touch content/sources/external/.gitkeep
        fi
        echo "  ✓ Cleaned content/ (preserved .archive and sources structure)"
    fi

    # Scripts directory is NOT cleaned (infrastructure must remain)

    # Clean my-notes directory (preserve structure)
    if [ -d "my-notes" ]; then
        # Clean content but preserve README and structure
        find my-notes -type f ! -name ".gitkeep" ! -name "README.md" -delete 2>/dev/null

        # Recreate structure if needed
        if [ ! -d "my-notes/notes" ]; then
            mkdir -p my-notes/{notes,conversation-summaries}
            touch my-notes/notes/.gitkeep
            touch my-notes/conversation-summaries/.gitkeep
        fi
        echo "  ✓ Cleaned my-notes/ (preserved structure and README)"
    fi

    echo ""
    echo "✅ Directories cleaned"
else
    echo "ℹ️  Original directories preserved"
fi

echo ""
echo "Archive location: $ARCHIVE_DIR"
echo "Archive summary: $ARCHIVE_DIR/ARCHIVE_INFO.txt"
echo ""

# Show archive structure
echo "Archive structure:"
ls -la "$ARCHIVE_DIR" | tail -n +2 | grep "^d" | awk '{print "  " $NF "/"}'