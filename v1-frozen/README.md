# v1-frozen/README.md
**Purpose**: Mark v1 system snapshot as immutable preservation
**Related**: CLAUDE.md, .archive/v1-complete-20250921-083632/
**AI-hints**:
- Read-only snapshot of v1 agent system
- Do not modify any files in this directory
- Reference copy for rollback procedures

# FROZEN V1 SYSTEM SNAPSHOT

## ⚠️ DO NOT MODIFY ⚠️

This directory contains a complete, preserved snapshot of the v1 agent-based content engine system.

## Preserved Version Details
- **Version**: v1.0.0-agent-system
- **Date Preserved**: September 21, 2025
- **Git Tag**: v1.0.0-agent-system
- **Branch**: preserve/v1-agent-system
- **Archive Location**: .archive/v1-complete-20250921-083632/

## System Components
- **46 Specialized Agents**: Complete agent definitions
- **Template-Based Orchestration**: XML workflow templates
- **Parallel Execution**: Direct invocation patterns
- **Claude Code Native**: .claude/agents/ deployed configuration

## Directory Contents
```
v1-frozen/
├── agents/             # 46 agent source files
├── .claude/            # Claude Code configuration
├── templates/          # 7 XML workflow templates
└── CLAUDE.md          # V1 system documentation
```

## Purpose
This frozen snapshot serves as:
1. Reference implementation for v2 migration
2. Rollback source if v2 has issues
3. Historical record of v1 architecture
4. Validation baseline for feature parity

## Usage
- **Reference Only**: Use for comparison and understanding
- **Testing**: Can be copied to test environment
- **Rollback**: Source for emergency restoration

## DO NOT:
- Edit any files in this directory
- Run scripts that modify these files
- Use as working directory
- Commit changes to these files

## For Active Development
Use the main project directories or v2 development branch.

## Rollback Instructions
If rollback to v1 is needed:
```bash
# Use the rollback script
./scripts/rollback-to-v1.sh

# Or manually restore from this snapshot
cp -r v1-frozen/agents/ ./
cp -r v1-frozen/.claude/ ./
cp -r v1-frozen/templates/ ./
```

## Contact
For questions about this preserved system, refer to the migration documentation in `docs/migration/`.