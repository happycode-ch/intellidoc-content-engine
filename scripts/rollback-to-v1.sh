#!/bin/bash
# scripts/rollback-to-v1.sh
# Purpose: Emergency rollback to v1 agent system from preserved snapshot
# Related: v1-frozen/, .archive/v1-complete-20250921-083632/, docs/v1-system-documentation.md
# AI-hints:
# - Restores v1 system from frozen snapshot
# - Interactive confirmation required
# - Creates backup before rollback

set -e

echo "============================================"
echo "V1 SYSTEM EMERGENCY ROLLBACK"
echo "============================================"
echo ""
echo "This script will restore the v1 agent system from the preserved snapshot."
echo "Current system state will be backed up before rollback."
echo ""

# Check if v1-frozen exists
if [ ! -d "v1-frozen" ]; then
    echo "ERROR: v1-frozen directory not found!"
    echo "Looking for archive backup..."

    if [ -d ".archive/v1-complete-20250921-083632" ]; then
        echo "Found archive at .archive/v1-complete-20250921-083632"
        ROLLBACK_SOURCE=".archive/v1-complete-20250921-083632"
    else
        echo "ERROR: No v1 backup found. Cannot rollback."
        exit 1
    fi
else
    ROLLBACK_SOURCE="v1-frozen"
fi

echo "Rollback source: $ROLLBACK_SOURCE"
echo ""

# Confirm rollback
read -p "Are you sure you want to rollback to v1? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Rollback cancelled."
    exit 0
fi

# Create backup of current state
echo ""
echo "Creating backup of current state..."
BACKUP_DIR=".archive/pre-rollback-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup current directories
if [ -d "agents" ]; then
    cp -r agents/ "$BACKUP_DIR/"
    echo "Backed up agents/"
fi

if [ -d ".claude" ]; then
    cp -r .claude/ "$BACKUP_DIR/"
    echo "Backed up .claude/"
fi

if [ -d "templates" ]; then
    cp -r templates/ "$BACKUP_DIR/"
    echo "Backed up templates/"
fi

# Save current git info
echo "Current git state before rollback:" > "$BACKUP_DIR/GIT_STATE.txt"
echo "Branch: $(git branch --show-current)" >> "$BACKUP_DIR/GIT_STATE.txt"
echo "Commit: $(git rev-parse HEAD)" >> "$BACKUP_DIR/GIT_STATE.txt"
echo "Status:" >> "$BACKUP_DIR/GIT_STATE.txt"
git status --short >> "$BACKUP_DIR/GIT_STATE.txt"

echo "Backup created at: $BACKUP_DIR"
echo ""

# Perform rollback
echo "Starting rollback to v1..."
echo ""

# Remove current directories
echo "Removing current system directories..."
rm -rf agents/ .claude/ templates/

# Restore v1 system
echo "Restoring v1 system from $ROLLBACK_SOURCE..."
cp -r "$ROLLBACK_SOURCE/agents/" ./
cp -r "$ROLLBACK_SOURCE/.claude/" ./
cp -r "$ROLLBACK_SOURCE/templates/" ./

# Restore root CLAUDE.md if it exists
if [ -f "$ROLLBACK_SOURCE/CLAUDE.md" ]; then
    cp "$ROLLBACK_SOURCE/CLAUDE.md" ./
    echo "Restored CLAUDE.md"
fi

echo ""
echo "============================================"
echo "ROLLBACK COMPLETE"
echo "============================================"
echo ""
echo "The v1 agent system has been restored."
echo "Previous state backed up to: $BACKUP_DIR"
echo ""
echo "Recommended next steps:"
echo "1. Verify system functionality with: /agents"
echo "2. Test a simple workflow from templates/"
echo "3. Check git status: git status"
echo "4. If issues persist, restore from: $BACKUP_DIR"
echo ""
echo "To undo this rollback:"
echo "cp -r $BACKUP_DIR/* ./"
echo ""

# Show restored system info
echo "Restored system summary:"
echo "- Agents: $(ls -1 agents/*.md 2>/dev/null | wc -l) agent files"
echo "- Deployed: $(ls -1 .claude/agents/*.md 2>/dev/null | grep -v CLAUDE | wc -l) agents in .claude/"
echo "- Templates: $(ls -1 templates/*.md 2>/dev/null | wc -l) workflow templates"

echo ""
echo "Rollback completed successfully."