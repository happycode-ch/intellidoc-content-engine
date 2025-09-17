# 52-Agent Content Creation Module (Including Swiss Localization)

## Module Purpose
Source directory for 52 specialized content agents including:
- 46 core content creation agents
- 6 Swiss localization agents for multilingual content
- Plus the `content-pipeline-orchestrator` that coordinates intelligent agent subset selection based on content type and requirements.

## Orchestration Strategy

### Content-Pipeline-Orchestrator
The master orchestrator (Opus-powered) analyzes content requests and selects optimal agent subsets:
- **Blog posts**: 6-8 agents for focused content
- **Tutorials**: 20-25 agents for comprehensive coverage
- **Social media**: 3-4 distribution agents
- **Whitepapers**: 15-20 research and content agents

### Content Assembly Solution
**NEW: `content-assembler` agent** consolidates all fragments:
- Merges intro, body, conclusion, code examples into single document
- Maintains consistent formatting and flow
- Generates publication-ready deliverables
- Handles all content types (blog, tutorial, news, whitepaper, social)

### Specialized Orchestrators
Seven content-type orchestrators:
- `blog-post-orchestrator` - Technical blog posts (1500-3000 words)
- `tutorial-orchestrator` - Step-by-step guides with exercises
- `news-orchestrator` - Rapid news articles (<30 min)
- `social-media-orchestrator` - Platform-specific social content
- `whitepaper-orchestrator` - Authoritative long-form (5000-10000 words)
- `series-orchestrator` - Multi-part content series
- `swiss-localization-orchestrator` - Swiss multilingual content pipeline (DE/FR/IT)

## Model Optimization (September 2024)

### Optimization Results
After comprehensive analysis of all 46 agents, model assignments were optimized for performance and cost:

**Previous Distribution (Inefficient)**:
- Opus: 37 agents (80%) - Overused for simple tasks
- Sonnet: 9 agents (20%) - Underutilized
- Haiku: 0 agents (0%) - Not leveraged

**Current Distribution (Optimized - 52 agents total)**:
- **Opus: 14 agents (27%)** - Complex orchestration, deep content, and Swiss localization
  - 8 core content agents (orchestrators + body-writer + content-assembler)
  - 6 Swiss localization agents (translation + compliance + verification)
- **Sonnet: 20 agents (38%)** - Handles research, analysis, and strategic planning
- **Haiku: 18 agents (35%)** - Manages simple formatting, validation, and specifications

### Performance Improvements
- **Speed**: 3-5x faster execution for simple tasks (Haiku agents)
- **Cost**: ~70% reduction in API costs through appropriate model allocation
- **Quality**: Maintained for complex tasks with Opus retention where needed
- **Throughput**: Higher concurrent agent execution due to faster Haiku processing

### Model Assignment Strategy

**Opus (Complex Reasoning)**:
- All orchestrators (`blog-post`, `tutorial`, `whitepaper`, `news`, `social-media`, `series`)
- Core content creators (`body-writer`, `content-assembler`)
- Tasks requiring multi-step coordination and deep context understanding

**Sonnet (Balanced Performance)**:
- Research agents (`source-gatherer`, `keyword-researcher`, `competitor-analyzer`)
- Strategic planning (`content-planner`, `audience-profiler`, `angle-definer`)
- Content components (`intro-writer`, `conclusion-writer`, `concept-explainer`)
- Quality assurance (`grammar-checker`, `readability-scorer`, `link-validator`)

**Haiku (High-Speed Processing)**:
- Format adapters (`twitter-formatter`, `linkedin-adapter`, `instagram-packager`)
- Simple validators (`fact-verifier`, `link-validator`)
- Specification creators (`diagram-sketcher`, `chart-designer`, `infographic-planner`)
- Pattern recognition (`trend-spotter`, `topic-scout`)

## Swiss Localization Module

### Swiss Language Agents (6 specialized agents)
Located in `language_agents/` and deployed to `.claude/agents/`:

**Translation Agents**:
- `swiss-german-translator` - Translates to Swiss German (Schweizerdeutsch) with cultural adaptation
- `swiss-french-translator` - Translates to Swiss French (français suisse) with regional nuances
- `swiss-italian-translator` - Translates to Swiss Italian (italiano svizzero) for Ticino region

**Quality & Compliance**:
- `swiss-language-verifier` - Verifies linguistic accuracy across all three languages
- `swiss-compliance-checker` - Ensures Swiss legal, regulatory, and formatting standards
- `swiss-localization-orchestrator` - Coordinates multilingual content pipeline

### Swiss Content Workflow
```bash
# For Swiss multilingual content
/agent swiss-localization-orchestrator
"Create blog post about [topic] in all Swiss languages"

# For specific language translation
/agent swiss-german-translator
"Translate this content to Swiss German: [content]"
```

### Swiss Market Considerations
- **Language Distribution**: German (63%), French (23%), Italian (8%), Romansh (0.5%)
- **Regional Variations**: Considers cantonal differences
- **Compliance**: Swiss data protection, financial regulations, consumer laws
- **Cultural Adaptation**: Swiss business etiquette, neutral tone, precision

## Agent Architecture

### Agent File Structure
Each agent follows this exact pattern:
```yaml
---
name: [agent-name]
description: [single responsibility description]
model: [haiku|sonnet|opus]
tools: [minimal tool list]
---

You are a [role] [doing what].

## Core Function
[Single, clear responsibility statement]

## Input
```json
{
  "field": "expected input structure"
}
```

## Process
1. [Step 1]
2. [Step 2]
...

## Output
```json
{
  "result": "output structure"
}
```

## Constraints
- MUST [requirement]
- NEVER [restriction]
```

### Model Selection Guidelines (Optimized September 2024)
- **Haiku (18 agents)**: Simple formatting, validation, specifications, platform adaptation
- **Sonnet (20 agents)**: Research, analysis, strategic planning, content components
- **Opus (14 agents)**: Orchestrators (7) + core content (2) + Swiss localization (6)

### Tool Access Principles
Each agent has **minimal necessary tools**:
- `Read, Write`: Content manipulation agents
- `WebSearch, WebFetch`: Research agents
- `Bash`: Code testing agents only
- `Read` only: Analysis/review agents

## Working with Agent Definitions

### Modifying Existing Agents

1. **Before Editing**:
   ```bash
   # Always backup before changes
   cp [agent-name].md [agent-name].md.backup
   ```

2. **Edit Guidelines**:
   - **NEVER** change the agent's core responsibility
   - **NEVER** add tools unless absolutely necessary
   - **DO** refine prompts for clarity
   - **DO** update examples and constraints

3. **Test Changes**:
   ```bash
   # Copy to Claude agents directory
   cp [agent-name].md ~/.claude/agents/

   # Test with simple request
   /agent [agent-name]
   [simple test prompt]
   ```

### Creating New Agents

1. **Determine Agent Need**:
   - Identify missing capability gap
   - Confirm no existing agent covers this
   - Ensure single, clear responsibility

2. **Choose Phase Placement**:
   - **Phase 1-2**: Research/Planning (sonnet for complex research, haiku for simple lookups)
   - **Phase 3**: Core Content (opus for orchestrators & body-writer, sonnet for components)
   - **Phase 4-5**: Technical/Tutorial (sonnet for complex docs, haiku for code snippets)
   - **Phase 6**: Quality Assurance (sonnet for deep review, haiku for validation)
   - **Phase 7-8**: Visual/Distribution (haiku for formatting and adaptation)
   - **Phase 9**: Analysis (sonnet for metrics, haiku for pattern spotting)

3. **Agent Template**:
   ```bash
   # Create new agent file
   cp template-agent.md [new-agent-name].md
   ```

4. **Required Fields**:
   - `name`: Must match filename (without .md)
   - `description`: Include trigger keywords
   - `model`: Based on complexity
   - `tools`: Absolute minimum required

### Agent Naming Convention
`[function]-[role].md` (e.g., `fact-verifier.md`, `body-writer.md`)

## Testing Workflow

### Orchestrator Testing
```bash
# Test specialized orchestrators with content-assembler
/agent blog-post-orchestrator
"Create a technical blog post about Docker"

# Verify content assembly in tutorials
/agent tutorial-orchestrator
"Create comprehensive tutorial on Kubernetes"

# Test rapid assembly for news
/agent news-orchestrator
"Breaking news about AI announcement"
```

### Individual Agent Testing
```bash
# Copy to agents directory
cp [agent-name].md ~/.claude/agents/

# Test specific agent
/agent [agent-name]
```

## Phase Specializations

**Phases 1-2**: Research & Strategy (WebSearch, WebFetch)
**Phase 3**: Core Content Creation (Read, Write)
**Phases 4-5**: Technical & Tutorial (Read, Write, Bash)
**Phase 6**: Quality Assurance (Read, Write minimal)
**Phases 7-8**: Visual & Distribution (Read, Write)
**Phase 9**: Analysis & Improvement (Read only)
**Phase 10**: Swiss Localization (Read, Write) - Translation & compliance for CH market

## Orchestration Patterns

**Sequential**: Research → Planning → Creation → QA → Distribution
**Parallel**: Multiple QA agents run simultaneously
**Optimized**: Orchestrator selects minimal subset for content type
**Fallback**: Orchestrator handles agent failures gracefully

## Maintenance

### Agent Updates
1. Always backup: `cp agent.md agent.md.backup`
2. Test changes in isolation
3. Verify orchestrator compatibility
4. Update both source and deployed versions


## Security Constraints
- No access to sensitive files
- Minimal tool permissions per agent
- Orchestrator validates all agent outputs
- Code review required for Opus agents and Bash tools

## File References
- **Project Context**: `@../.claude/CLAUDE.md`
- **Orchestrator**: `.claude/agents/content-pipeline-orchestrator.md`
- **Model Optimization Guide**: `AGENT_MODEL_OPTIMIZATION_GUIDE.md`
- **Implementation Archive**: `.archive/IMPLEMENTATION_GUIDE_41_AGENTS.md`

## Quick Reference

### Using the System
```bash
# For any content creation task
/agent content-pipeline-orchestrator
"[Your content request]"
```

### Troubleshooting
- **Wrong output format**: Orchestrator handles consolidation
- **Too many files**: Expected - orchestrator manages this
- **Slow execution**: Trade-off for quality, orchestrator optimizes

## Model Selection Quick Guide

### Choose Opus When:
- Orchestrating multiple agents in complex workflows
- Creating long-form content requiring deep reasoning
- Managing cross-content continuity and context
- Consolidating multiple content sources into polished output

### Choose Sonnet When:
- Performing research and competitive analysis
- Planning content strategy and structure
- Writing specific content sections with nuance
- Conducting quality checks requiring judgment

### Choose Haiku When:
- Formatting content for different platforms
- Creating simple specifications or templates
- Performing rule-based validations
- Extracting or transforming existing content
- Running high-volume, repetitive tasks

---

*52 specialized agents (46 core + 6 Swiss) + optimized model distribution = exceptional multilingual content at 70% lower cost*