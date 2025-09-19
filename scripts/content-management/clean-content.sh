#!/bin/bash
# File: scripts/content-management/clean-content.sh
# Purpose: Clean generated content and temporary files
# Related: scripts/content-management/, scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit

# Quick clean content directory without archiving (for testing)

echo "=== Content Clean Utility ==="
echo ""

# Count current content
TOTAL_FILES=$(find content -type f ! -name ".gitkeep" ! -path "content/.archive/*" 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh content --exclude=content/.archive 2>/dev/null | cut -f1)

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "✅ Content directory is already clean"
    exit 0
fi

echo "Current content:"
echo "  Files: $TOTAL_FILES"
echo "  Size: $TOTAL_SIZE"
echo ""
echo "⚠️  WARNING: This will delete all content without archiving!"
echo "    (Archive directory will be preserved)"
echo ""
read -p "Are you sure you want to clean all content? (yes/no) " -r REPLY
echo ""

if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo "❌ Clean cancelled"
    exit 1
fi

echo "Cleaning content directory..."

# Remove all files except .gitkeep and archive
find content -type f ! -name ".gitkeep" ! -path "content/.archive/*" -delete 2>/dev/null

# Remove empty directories except .archive
find content -type d -empty ! -path "content/.archive*" ! -path "content" -delete 2>/dev/null || true

echo "✅ Content directory cleaned"
echo ""

# Show final state
echo "Content directory state:"
echo "  Files remaining: $(find content -type f ! -path "content/.archive/*" | wc -l)"
echo "  Directories: $(find content -type d ! -path "content/.archive/*" | wc -l)"
echo "  Archives preserved: $(ls -1 content/.archive 2>/dev/null | wc -l)"

# Recreate standard structure if needed
if [ ! -d "content/blog" ]; then
    echo ""
    echo "Standard directories were removed. Run ./setup-content-dirs.sh to recreate them."
fi