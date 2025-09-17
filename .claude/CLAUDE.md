# IntelliDoc Content Engine

## Project Overview
Sophisticated content creation system using 54 specialized agents (48 core + 6 Swiss localization) organized in 10 phases. Orchestrated by `content-pipeline-orchestrator` for intelligent agent subset selection based on content type.

## Core Philosophy
**Specialization over consolidation** - Each agent has single responsibility for precision and quality.

## Tech Stack
- **Framework**: Claude Code native agents (YAML + Markdown)
- **Models**: Haiku (18), Sonnet (22), Opus (14 - orchestrators, core content, Swiss localization)
- **Orchestration**: `content-pipeline-orchestrator` for intelligent coordination

## Project Structure
- **`agents/`** - Agent source files and development docs (single source of truth)
- **`.claude/agents/`** - Deployed agent definitions (symlinks to agents/)
- **`docs/`** - Comprehensive documentation and guides
- **`scripts/`** - Utilities and automation scripts
- **`content/`** - Generated content output directory

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

### Content Creation with Specialized Orchestrators
```bash
# Blog posts (with automatic assembly)
/agent blog-post-orchestrator
"Create a technical blog post about [topic]"

# Tutorials (with exercises and solutions)
/agent tutorial-orchestrator
"Create a step-by-step tutorial on [topic]"

# Quick news articles
/agent news-orchestrator
"Breaking news about [event]"

# Social media content
/agent social-media-orchestrator
"Create social posts from [existing article]"

# White papers
/agent whitepaper-orchestrator
"Create authoritative white paper on [topic]"

# Content series
/agent series-orchestrator
"Create 5-part series about [topic]"

# List all available agents
/agents
```


## Content Type Workflows

### Blog Post (8-15 min)
`blog-post-orchestrator` → research → content creation → `content-assembler` → final blog post

### Tutorial (20-30 min)
`tutorial-orchestrator` → planning → interactive elements → `content-assembler` → complete guide

### News Article (< 30 min)
`news-orchestrator` → rapid research → quick creation → `content-assembler` → published article

### Social Media (3-5 min)
`social-media-orchestrator` → content atomization → platform adaptation → `content-assembler` → multi-platform package

### White Paper (25-40 min)
`whitepaper-orchestrator` → deep research → authority building → `content-assembler` → professional document

### Content Series (varies)
`series-orchestrator` → per-part creation with `content-assembler` → series consistency → final packaging


## Design Principles
- **Single Responsibility**: Each agent does ONE thing perfectly
- **Context Isolation**: Clean context prevents task contamination
- **Minimal Tool Access**: Agents only get necessary permissions
- **Orchestrated Execution**: `content-pipeline-orchestrator` coordinates workflow

## Performance Expectations
- **Blog Post**: 8-15 minutes (optimized subset)
- **Tutorial**: 20-30 minutes (comprehensive)
- **Quick Article**: 5-8 minutes (minimal agents)
- **Quality**: Professional-grade output through specialization

## Troubleshooting
- **Agent not found**: Check `.claude/agents/` directory
- **Wrong output type**: Use `content-pipeline-orchestrator` for proper workflow
- **Slow execution**: Orchestrator optimizes subset for content type
- **Multiple files generated**: Normal - orchestrator manages consolidation

## Best Practices
1. **Always use orchestrator** for content creation tasks
2. **Specify content type** clearly (blog, tutorial, social)
3. **Trust agent selection** - orchestrator optimizes for your needs
4. **Review outputs** in `content/articles/` directory





## Key Resources
- **Agent Development**: See `agents/CLAUDE.md`
- **Documentation Hub**: `docs/README.md`
- **Model Optimization**: `docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md`
- **Scripts & Utilities**: `scripts/`
- **Generated Content**: `content/articles/[date]-[topic]/`