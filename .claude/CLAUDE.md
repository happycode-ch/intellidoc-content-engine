# IntelliDoc Content Engine - 41-Agent Pipeline

## Project Overview
A sophisticated content creation system using 41 specialized Claude Code agents organized in a 9-phase pipeline. Each agent follows Anthropic's single-responsibility principle, enabling precise, high-quality content generation across multiple formats and platforms.

## Architecture Philosophy
This system implements **specialization over consolidation** - 41 focused agents instead of 10 generalist agents, prioritizing precision and quality over execution speed.

## Tech Stack
- **Agent Framework**: Claude Code native agents
- **Model Distribution**:
  - Haiku (29 agents) - Simple, fast tasks
  - Sonnet (11 agents) - Complex reasoning
  - Opus (1 agent) - Critical content generation
- **Agent Format**: YAML + Markdown configuration
- **Orchestration**: Claude Code automatic agent selection

## Directory Structure
```
/CODE/
├── .claude/                              # Claude configuration
│   └── CLAUDE.md                        # This file
├── .docs/                               # Documentation
│   └── best_practices/                  # Best practices guides
│       └── CLAUDE_MD/                   # CLAUDE.md guidelines
├── cc_native_41_subagnt_cntnt_creation/ # 41 agent definitions
│   ├── IMPLEMENTATION_GUIDE_41_AGENTS.md
│   └── [41 agent .md files]
└── claude_md_file_example/              # Example files
```

## Agent Pipeline Phases

### Phase 1: Research & Discovery (5 agents)
- `topic-scout` - Discover trending topics (haiku)
- `source-gatherer` - Collect authoritative sources (haiku)
- `competitor-analyzer` - Analyze competition (sonnet)
- `fact-verifier` - Verify claims and statistics (haiku)
- `keyword-researcher` - Research SEO keywords (haiku)

### Phase 2: Strategy & Planning (5 agents)
- `content-planner` - Plan content calendar (sonnet)
- `angle-definer` - Define unique angles (haiku)
- `audience-profiler` - Profile target audience (haiku)
- `spec-writer` - Write detailed specifications (sonnet)
- `template-selector` - Select content templates (haiku)

### Phase 3: Content Creation (5 agents)
- `outline-builder` - Create content outlines (haiku)
- `intro-writer` - Write compelling introductions (sonnet)
- `body-writer` - Generate main content (opus)
- `conclusion-writer` - Craft conclusions (sonnet)
- `quote-integrator` - Add expert quotes (haiku)

### Phase 4: Technical Content (4 agents)
- `code-example-writer` - Create code examples (sonnet)
- `api-documenter` - Document APIs (sonnet)
- `command-demonstrator` - Show command usage (haiku)
- `error-handler` - Handle error scenarios (haiku)

### Phase 5: Tutorial Creation (4 agents)
- `step-sequencer` - Sequence tutorial steps (haiku)
- `exercise-designer` - Design practice exercises (sonnet)
- `solution-provider` - Provide solutions (sonnet)
- `concept-explainer` - Explain concepts clearly (sonnet)

### Phase 6: Quality Assurance (5 agents)
- `grammar-checker` - Check grammar/spelling (haiku)
- `style-editor` - Edit for style consistency (haiku)
- `flow-optimizer` - Optimize content flow (sonnet)
- `readability-scorer` - Score readability (haiku)
- `link-validator` - Validate all links (haiku)

### Phase 7: Visual Creation (5 agents)
- `ai-prompt-engineer` - Create AI image prompts (haiku)
- `chart-designer` - Design data charts (haiku)
- `infographic-planner` - Plan infographics (sonnet)
- `thumbnail-creator` - Create thumbnails (haiku)
- `diagram-sketcher` - Sketch diagrams (haiku)

### Phase 8: Distribution (5 agents)
- `content-atomizer` - Break into atomic pieces (haiku)
- `twitter-formatter` - Format for Twitter/X (haiku)
- `linkedin-adapter` - Adapt for LinkedIn (haiku)
- `instagram-packager` - Package for Instagram (haiku)
- `newsletter-curator` - Curate newsletters (sonnet)

### Phase 9: Performance Analysis (3 agents)
- `metrics-collector` - Collect performance metrics (haiku)
- `trend-spotter` - Identify content trends (sonnet)
- `improvement-advisor` - Advise improvements (sonnet)

## File Naming Conventions

### Agent Files
- **Format**: `[function]-[role].md`
- **Examples**:
  - `topic-scout.md`
  - `body-writer.md`
  - `grammar-checker.md`
- **Location**: `/cc_native_41_subagnt_cntnt_creation/`

### Documentation
- **Guides**: `IMPLEMENTATION_GUIDE_[TOPIC].md`
- **Research**: `[date]_[topic]_cc_RESEARCH.md`
- **Best Practices**: Stored in `.docs/best_practices/`

## Agent Structure Template
Each agent follows this consistent structure:

```yaml
---
name: [agent-name]
description: [single-line description]
model: [haiku|sonnet|opus]
tools: [Read, Write, WebSearch, etc.]
---

## Core Function
[Single responsibility description]

## Input
```json
{
  "field": "description"
}
```

## Process
1. [Step 1]
2. [Step 2]
...

## Output
```json
{
  "result": "description"
}
```

## Constraints
- MUST [requirement]
- NEVER [restriction]
```

## Common Workflows

### Technical Blog Post
```
"Write a comprehensive technical blog post about [topic]"
```
**Agents triggered**: topic-scout → source-gatherer → fact-verifier → content-planner → outline-builder → intro-writer → body-writer → code-example-writer → conclusion-writer → grammar-checker → flow-optimizer

### Quick News Article
```
"Create a news article about [event]"
```
**Agents triggered**: source-gatherer → fact-verifier → intro-writer → body-writer → conclusion-writer → twitter-formatter

### Step-by-Step Tutorial
```
"Create a tutorial for [technology]"
```
**Agents triggered**: topic-scout → step-sequencer → concept-explainer → code-example-writer → exercise-designer → solution-provider

## Development Commands

### Agent Installation
```bash
# Copy agents to Claude Code directory
cp cc_native_41_subagnt_cntnt_creation/*.md ~/.claude/agents/

# Or for project-specific (recommended)
mkdir -p .claude/agents/
cp cc_native_41_subagnt_cntnt_creation/*.md .claude/agents/
```

### Verify Installation
```bash
# In Claude Code
/agents  # List all available agents
```

### Direct Agent Invocation
```bash
/agent [agent-name]  # Invoke specific agent
```

## Key Design Principles

### Single Responsibility
Each agent does ONE thing only. Examples:
- `quote-integrator` ONLY integrates quotes (doesn't write or edit)
- `link-validator` ONLY validates links (doesn't fix them)
- `grammar-checker` ONLY checks grammar (doesn't rewrite)

### Context Isolation
- Each agent receives clean context
- No contamination between tasks
- Precise, focused execution

### Minimal Tool Access
Agents only get tools they need:
- `grammar-checker`: Read, Write only
- `source-gatherer`: WebSearch, WebFetch
- `metrics-collector`: Read only

### Scalability
Add new agents without touching existing ones:
- Need video scripts? Add `video-script-writer`
- Need podcasts? Add `podcast-outliner`
- System remains stable

## Performance Expectations

### Execution Times
- **Quick article**: 2-3 minutes
- **Full blog post**: 5-10 minutes
- **Comprehensive guide**: 15-20 minutes

### Quality Metrics
- **Precision**: HIGH (specialized agents)
- **Consistency**: HIGH (single responsibility)
- **Maintainability**: HIGH (isolated agents)
- **Scalability**: HIGH (easy to extend)

## Troubleshooting

### Agents Not Triggering
1. Verify agents are in `.claude/agents/`
2. Check file names match exactly (include .md)
3. Use `/agents` to list available
4. Try explicit: `/agent [name]`

### Wrong Agent Selected
- Be more specific in request
- Use explicit agent invocation
- Review agent descriptions

### Slow Execution
- Normal for 41-agent pipeline
- Precision over speed design
- Quality output worth the wait

## Best Practices

1. **Trust automatic orchestration** - Claude Code intelligently selects agents
2. **Be specific in requests** - Clear requirements help agent selection
3. **Let pipeline complete** - Don't interrupt mid-execution
4. **Review phase outputs** - 41 quality checkpoints ensure excellence

## Advanced Patterns

### Force Specific Agents
```
/agent quote-integrator
Add these expert quotes: [quotes]
```

### Skip Phases
```
"Quick draft without research"
# Skips Phase 1 agents automatically
```

### Maximum Quality
```
"Publication-ready article with full QA"
# Engages all QA agents
```

## Extending the System

### Adding New Agents
1. Create agent file: `new-function.md`
2. Follow standard agent template
3. Place in `.claude/agents/`
4. Agent automatically available

### Creating Agent Groups
Future enhancement: Group related agents for workflow optimization

## Philosophy

> "In AI agent systems, a specialist who does one thing perfectly beats a generalist who does many things adequately."

This 41-agent system embodies specialization, precision, and quality over consolidated efficiency.

## Maintenance

### Update Triggers
- New content types added
- Workflow improvements identified
- Agent performance optimizations
- Tool availability changes

### Version Control
Track agent modifications in git for rollback capability

## Support & Documentation

- **Implementation Guide**: `/cc_native_41_subagnt_cntnt_creation/IMPLEMENTATION_GUIDE_41_AGENTS.md`
- **Best Practices**: `/.docs/best_practices/CLAUDE_MD/`
- **Agent Definitions**: `/cc_native_41_subagnt_cntnt_creation/*.md`

---

*This content engine represents Anthropic-aligned agent architecture: specialized, isolated, and precise.*