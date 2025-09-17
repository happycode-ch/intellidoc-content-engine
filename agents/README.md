# IntelliDoc Content Engine - Agent System

This directory contains the complete collection of 54 specialized agents that power the IntelliDoc Content Engine. Each agent is designed for a single, specific responsibility to ensure precision and quality.

## 🏗️ Agent Architecture

### Single Source of Truth
All agent definitions are stored here and deployed via symbolic links to `.claude/agents/` for Claude Code integration. Edit agents here, and changes are immediately reflected in the deployment.

### Organization Structure
```
agents/
├── [41 core agents].md        # Main content creation agents
├── orchestration/            # 7 orchestrator agents
│   ├── blog-post-orchestrator.md
│   ├── content-assembler-agent.md
│   ├── news-orchestrator.md
│   ├── series-orchestrator.md
│   ├── social-media-orchestrator.md
│   ├── tutorial-orchestrator.md
│   └── whitepaper-orchestrator.md
├── language_agents/          # 6 Swiss localization agents
│   ├── swiss-compliance-checker.md
│   ├── swiss-french-translator.md
│   ├── swiss-german-translator.md
│   ├── swiss-italian-translator.md
│   ├── swiss-language-verifier.md
│   └── swiss-localization-orchestrator.md
└── prompts/                 # Master prompt templates
```

## 🎯 Agent Categories

### Orchestrators (7 agents - Opus)
Complex workflow coordination agents that manage entire content creation pipelines:
- **blog-post-orchestrator** - Technical blog posts (1500-3000 words)
- **tutorial-orchestrator** - Step-by-step guides with exercises
- **news-orchestrator** - Rapid news articles
- **whitepaper-orchestrator** - Long-form authoritative documents
- **social-media-orchestrator** - Multi-platform social content
- **series-orchestrator** - Multi-part content series
- **content-assembler-agent** - Consolidates all content fragments

### Content Creation (20 agents - Sonnet)
Research, analysis, and strategic content development:
- Research: `source-gatherer`, `keyword-researcher`, `fact-verifier`
- Planning: `content-planner`, `audience-profiler`, `angle-definer`
- Writing: `intro-writer`, `body-writer`, `conclusion-writer`
- Technical: `api-documenter`, `code-example-writer`, `error-handler`

### Content Processing (18 agents - Haiku)
Fast formatting, validation, and specification tasks:
- Formatting: `twitter-formatter`, `linkedin-adapter`, `instagram-packager`
- Analysis: `trend-spotter`, `topic-scout`, `metrics-collector`
- Specifications: `diagram-sketcher`, `chart-designer`, `thumbnail-creator`

### Swiss Localization (6 agents - Opus)
Specialized multilingual and compliance agents:
- Translation: German, French, Italian translators
- Quality: Language verifier, compliance checker
- Orchestration: Swiss localization orchestrator

## 📊 Model Distribution (Optimized)
- **Opus (14 agents, 26%)** - Complex reasoning and orchestration
- **Sonnet (22 agents, 41%)** - Balanced analysis and content creation
- **Haiku (18 agents, 33%)** - High-speed processing and formatting

## 🛠️ Working with Agents

### Editing Agents
1. Edit the source file in this directory
2. Changes are immediately reflected in `.claude/agents/` via symlinks
3. Test with `/agent [agent-name]` in Claude Code

### Creating New Agents
1. Follow the standard agent template structure
2. Choose appropriate model based on complexity
3. Assign minimal necessary tools
4. Update symlinks in `.claude/agents/`

### Agent Template Structure
```yaml
---
name: agent-name
description: Single responsibility description
model: haiku|sonnet|opus
tools: Read, Write
---

You are a [role] specializing in [specific task].

## Core Function
[Clear responsibility statement]

## Input/Output
[Structured data formats]

## Constraints
- MUST [requirements]
- NEVER [restrictions]
```

## 🔗 Integration

### Claude Code Integration
Agents are deployed via symlinks from `.claude/agents/` to this directory, maintaining a single source of truth while providing flat access for Claude Code.

### Orchestration
Orchestrator agents coordinate subsets of specialized agents based on content type and requirements, ensuring optimal performance and cost efficiency.

## 📈 Performance Metrics
- **Speed**: 3-5x faster execution for simple tasks (Haiku)
- **Cost**: ~70% reduction through optimized model allocation
- **Quality**: Maintained precision through specialization
- **Scalability**: 54 agents handle any content creation scenario

---

For detailed information about model optimization and performance, see [docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md](../docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md).