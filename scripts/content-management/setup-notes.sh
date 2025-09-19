#!/bin/bash
# File: scripts/content-management/setup-notes.sh
# Purpose: Setup project directories and configuration
# Related: scripts/content-management/, scripts/CLAUDE.md
# AI-hints:
# - Side effects: File operations, directory changes
# - Requires bash shell environment
# - Part of project automation toolkit

# Setup personal notes directory for saving information from agent conversations

echo "=== Setting up personal notes directory ==="
echo ""

# Create main notes directories
echo "Creating notes directories..."
mkdir -p my-notes/{notes,conversation-summaries}

# Add .gitkeep files to maintain structure
echo "Adding .gitkeep files..."
touch my-notes/.gitkeep
touch my-notes/notes/.gitkeep
touch my-notes/conversation-summaries/.gitkeep

# Create README for the notes directory
cat > my-notes/README.md << 'EOF'
# Personal Notes Directory

This directory is for personal notes and is NOT tracked by git.

## Structure

- **notes/** - Quick notes, reminders, and information to save
- **conversation-summaries/** - Summaries from agent conversations

## Usage

Save any information you want to preserve:
- Notes from agent conversations before context is compacted
- Important outputs from agents
- Personal reminders and todos
- Any dictated notes

## Important

This directory is listed in .gitignore and will not be:
- Tracked by git
- Included in commits
- Archived by archive-all.sh (it's personal, not project content)

To backup these notes manually:
```bash
cp -r my-notes/ ~/my-notes-backup-$(date +%Y%m%d)/
```
EOF

echo ""
echo "✅ Personal notes directory created successfully!"
echo ""
echo "Directory structure:"
echo "my-notes/"
echo "├── notes/                   # Quick notes and reminders"
echo "├── conversation-summaries/  # Agent conversation summaries"
echo "└── README.md               # Usage instructions"
echo ""
echo "Note: This directory is NOT tracked by git (see .gitignore)"