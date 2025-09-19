# IntelliDoc Content Engine

## Project Overview
Multi-agent content creation system with 46 specialized agents using template-based parallel workflows.

## Directory Structure
```
CODE/
├── agents/             # 46 content creation agents (source of truth)
├── .claude/agents/     # Deployed agents (symlinks)
├── templates/          # XML workflow templates
├── content/            # Generated content outputs
├── scripts/            # Automation utilities
├── docs/               # Documentation and reports
├── my-notes/           # Personal notes (not tracked by git)
├── temp_agent_outputs/ # Intermediate agent outputs
└── .archive/           # Timestamped backups of everything
```

## CLAUDE.md Documentation Map

Project documentation is distributed across directories:

- **This file** (`/CLAUDE.md`) - Root overview and git operations
- **`.claude/CLAUDE.md`** - Main navigation hub with complete roadmap
- **`agents/CLAUDE.md`** - 46 agent specifications
- **`templates/CLAUDE.md`** - 7 XML workflow templates
- **`content/CLAUDE.md`** - Output organization
- **`scripts/CLAUDE.md`** - Automation tools
- **`.archive/CLAUDE.md`** - Backup procedures
- **`temp_agent_outputs/CLAUDE.md`** - Intermediate file management

For detailed navigation, see `.claude/CLAUDE.md`

## Quick Start
1. Choose template from `templates/`
2. Copy XML pattern and customize
3. Execute agents in parallel
4. Use content-assembler to finalize

## Common Commands

### Git Operations
```bash
# Check status before committing
git status
git diff

# Commit changes
git add .
git commit -m "feat: [description]"

# Create PR when work complete
git push origin [branch-name]
gh pr create --title "[Title]" --body "[Description]"

# Common branch operations
git checkout -b feature/[feature-name]
git pull origin main
```

### Agent Commands
```bash
# List all available agents
/agents

# Use content assembler
/agent content-assembler
"Combine all outputs into final deliverable"

# Check agent deployment
ls -la .claude/agents/
```

### Archive & Cleanup
```bash
# Archive everything (docs, content, scripts, my-notes)
./scripts/content-management/archive-all.sh
# Answer 'n' to keep originals (backup only)
# Answer 'y' to clean directories after archiving

# What gets archived: docs/, content/, scripts/, my-notes/
# What gets cleaned: All files except .gitkeep and README.md
# Preserved: .archive/, content/sources/, directory structures

# Restore from archive
cp -r .archive/[YYYYMMDD-HHMMSS]/* .

# Details: see .archive/CLAUDE.md
```

## GitHub Integration
- Repository: intellidoc_content_engine
- Main branch: main
- PR required for all changes
- Create PR after completing directory work

## AI-hints
- Uses Claude Code native agent system
- XML patterns enable parallel execution
- Template-based workflows replace orchestrators
- 46 agents: 40 core + 6 Swiss localization
- Archive system backs up docs/, content/, scripts/, my-notes/
- my-notes/ for personal notes (not tracked by git)
- .archive/ contains timestamped backups
- Always create PR when work complete