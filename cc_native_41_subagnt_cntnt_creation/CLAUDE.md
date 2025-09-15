# 41-Agent Content Creation Module

## Module Purpose
Source directory for 41 specialized content agents plus the `content-pipeline-orchestrator` that coordinates intelligent agent subset selection based on content type and requirements.

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
Six content-type orchestrators in `orchestration/` directory:
- `blog-post-orchestrator` - Technical blog posts (1500-3000 words)
- `tutorial-orchestrator` - Step-by-step guides with exercises
- `news-orchestrator` - Rapid news articles (<30 min)
- `social-media-orchestrator` - Platform-specific social content
- `whitepaper-orchestrator` - Authoritative long-form (5000-10000 words)
- `series-orchestrator` - Multi-part content series

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

### Model Selection Guidelines
- **Haiku (29 agents)**: Simple formatting, grammar checks, basic operations
- **Sonnet (11 agents)**: Complex reasoning, content strategy, quality assurance
- **Opus (1 agent)**: Critical content generation (`body-writer`)

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
   - **Phase 1-2**: Research/Planning (haiku/sonnet)
   - **Phase 3**: Core Content (sonnet/opus)
   - **Phase 4-5**: Technical/Tutorial (sonnet)
   - **Phase 6**: Quality Assurance (haiku)
   - **Phase 7-8**: Visual/Distribution (haiku)
   - **Phase 9**: Analysis (sonnet)

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
- **Implementation**: `IMPLEMENTATION_GUIDE_41_AGENTS.md`

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

---

*41 specialized agents + intelligent orchestration = exceptional content at scale*