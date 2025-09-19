# IntelliDoc Content Engine

## Project Overview
Sophisticated content creation system using 46 specialized agents (40 core + 6 Swiss localization) organized in 10 phases. Uses template-based workflows with direct parallel invocation for true multi-agent coordination.

## Core Philosophy
**Specialization over consolidation** - Each agent has single responsibility for precision and quality.

## Tech Stack
- **Framework**: Claude Code native agents (YAML + Markdown)
- **Models**: Haiku (18), Sonnet (20), Opus (6 - core content + Swiss localization)
- **Orchestration**: Template-based workflows with direct parallel invocation

## Complete Project Structure
```
CODE/
├── .claude/                    # Claude Code configuration
│   ├── agents/                 # Deployed agents (symlinks)
│   └── CLAUDE.md              # Main navigation hub (THIS FILE)
├── agents/                     # Agent source files (46 total)
│   ├── language_agents/        # Swiss localization (6)
│   ├── orchestration/          # Content assembler only
│   ├── prompts/               # Prompt templates
│   └── CLAUDE.md              # Agent specifications
├── templates/                  # XML workflow templates (7)
│   └── CLAUDE.md              # Orchestration patterns
├── content/                    # Generated content outputs
│   ├── articles/              # Blog posts by date
│   ├── sources/               # Research materials
│   │   ├── internal/          # Internal sources
│   │   └── external/          # External references
│   └── CLAUDE.md              # Content organization
├── scripts/                    # Automation utilities
│   ├── content-management/     # Archive & setup scripts
│   ├── development/           # Dev tools
│   ├── pdf-build/             # PDF generation
│   └── CLAUDE.md              # Script documentation
├── .archive/                   # Timestamped backups
│   ├── [YYYYMMDD-HHMMSS]/    # Archive snapshots
│   └── CLAUDE.md              # Archive procedures
├── docs/                       # Documentation
│   ├── reports/               # White papers, analyses
│   └── migration/             # Migration guides
├── temp_agent_outputs/         # Intermediate agent outputs
│   └── CLAUDE.md              # Output management guide
└── CLAUDE.md                  # Root project overview
```

## CLAUDE.md Files Roadmap

Navigate to specific documentation based on your needs:

### Root Level
- **`/CLAUDE.md`** - Project root overview, git operations, GitHub workflow
  - Focus: High-level navigation, quick start, version control

### Core Directories
- **`agents/CLAUDE.md`** - 46 agent specifications and model assignments
  - Focus: Agent details, model optimization, performance metrics

- **`templates/CLAUDE.md`** - 7 XML workflow templates for content creation
  - Focus: Orchestration patterns, XML structure, parallel execution

- **`content/CLAUDE.md`** - Content output organization and generation
  - Focus: Directory structure, naming conventions, workflow outputs

- **`scripts/CLAUDE.md`** - Automation scripts and utilities
  - Focus: Agent management, content operations, archive tools

- **`.archive/CLAUDE.md`** - Timestamped backup system
  - Focus: Archive structure, restoration procedures, backup management

- **`temp_agent_outputs/CLAUDE.md`** - Intermediate agent output storage
  - Focus: Temporary files, debugging workflows, cleanup procedures

### This File
- **`.claude/CLAUDE.md`** (You are here) - Main navigation hub
  - Focus: Project overview, common operations, resource links

## Quick Navigation Guide

What do you need to do?

- **Create content** → Go to `templates/CLAUDE.md`
- **Find an agent** → Go to `agents/CLAUDE.md`
- **Generate output** → Go to `content/CLAUDE.md`
- **Run scripts** → Go to `scripts/CLAUDE.md`
- **Restore backup** → Go to `.archive/CLAUDE.md`
- **Git/GitHub** → Go to `/CLAUDE.md` (root)

## 10-Phase Agent Pipeline
**Phase 1**: Research & Discovery (5 agents)
**Phase 2**: Strategy & Planning (5 agents)
**Phase 3**: Content Creation (5 agents)
**Phase 4**: Technical Content (4 agents)
**Phase 5**: Tutorial Creation (4 agents)
**Phase 6**: Quality Assurance (5 agents)
**Phase 7**: Visual Creation (5 agents)
**Phase 8**: Distribution (5 agents)
**Phase 9**: Performance Analysis (3 agents)
**Phase 10**: Swiss Localization (6 agents)

→ See `agents/CLAUDE.md` for agent details

## Key Commands

### Content Creation with Template-Based Workflows
```bash
# Blog posts - Use templates/blog-post-template.md
# Copy template commands and customize for your topic

# Tutorials - Use templates/tutorial-template.md
# Step-by-step guides with exercises

# News articles - Use templates/news-article-template.md
# Rapid content for breaking news

# Social media - Use templates/social-media-template.md
# Multi-platform content packages

# White papers - Use templates/whitepaper-template.md
# Long-form authoritative content

# Swiss localization - Use templates/swiss-localization-template.md
# Translations and compliance for CH market

# List all available agents
/agents

# Final assembly for any content type
/agent content-assembler
"Combine all outputs into final deliverable"
```


## Content Type Workflows

### Blog Post (5-10 min with parallel execution)
Template → parallel research (4 agents) → parallel writing (3-4 agents) → `content-assembler` → final blog post

### Tutorial (15-20 min)
Template → parallel research → structured creation → exercises → `content-assembler` → complete guide

### News Article (5-10 min)
Template → rapid parallel research (3 agents) → quick creation → `content-assembler` → published article

### Social Media (2-3 min)
Template → parallel platform creation (3-4 agents) → `content-assembler` → multi-platform package

### White Paper (20-30 min)
Template → deep parallel research (5 agents) → batched content creation → `content-assembler` → professional document

### Swiss Localization (5-10 min)
Template → parallel translation (3 agents) → compliance check → verification → localized content


## Design Principles
- **Single Responsibility**: Each agent does ONE thing perfectly
- **Context Isolation**: Clean context prevents task contamination
- **Minimal Tool Access**: Agents only get necessary permissions
- **Parallel Execution**: Direct invocation enables true parallelization

## Performance Expectations
- **Blog Post**: 5-10 minutes (parallel execution)
- **Tutorial**: 15-20 minutes (comprehensive with exercises)
- **Quick Article**: 5-10 minutes (rapid parallel research)
- **Quality**: Professional-grade output through specialization
- **Cost**: 70% reduction vs old orchestrator approach

## Troubleshooting
- **Agent not found**: Check `.claude/agents/` directory
- **Agents not parallel**: Explicitly state "invoke in parallel"
- **Lost context**: Copy outputs between workflow phases
- **Multiple files generated**: Normal - use content-assembler to consolidate

## Best Practices
1. **Use templates** from `templates/` directory for workflows
2. **Run agents in parallel** whenever tasks are independent
3. **Use content-assembler** to consolidate all outputs
4. **Review outputs** in `content/` or `temp_agent_outputs/` directories



## Common Operations

### Template Usage
```bash
# Copy template for blog post
cat templates/blog-post-template.md

# List all templates
ls templates/*.md

# Templates contain XML patterns for parallel execution
```

### Agent Operations
```bash
# Check deployed agents (should be 46)
ls -la .claude/agents/*.md | grep -v CLAUDE | wc -l

# Verify no orchestrators remain
ls -la .claude/agents/ | grep orchestrator

# List agent by category
grep -l "model: haiku" .claude/agents/*.md | wc -l  # 18 agents
grep -l "model: sonnet" .claude/agents/*.md | wc -l # 20 agents
grep -l "model: opus" .claude/agents/*.md | wc -l   # 6 agents
```

### GitHub Workflow
```bash
# After making changes
git add -A
git commit -m "feat: update content engine"
git push origin [branch]
gh pr create --title "Update: [description]"
```

## Key Resources
- **Workflow Templates**: `templates/` - Ready-to-use content workflows
- **Migration Guide**: `docs/migration/from-orchestrators-to-direct-invocation.md`
- **Agent Development**: See `agents/CLAUDE.md`
- **Documentation Hub**: `docs/README.md`
- **White Paper**: `docs/reports/claude-code-orchestration-white-paper.md`
- **Model Optimization**: `docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md`
- **Scripts & Utilities**: `scripts/`
- **Generated Content**: `content/articles/[date]-[topic]/`

#### Header Rules
1. **File path**: Must be repo-root-relative and updated if file moves
2. **Purpose**: Imperative mood, ≤80 characters (e.g., "Calculate NOI for rental properties")
3. **Related**: List related files/docs; omit line if none
4. **AI-hints**: 1-5 bullets covering:
   - Key APIs or services called
   - Side effects (DB writes, external calls)
   - Important constraints or assumptions
   - Props/params for components
   - Export patterns
