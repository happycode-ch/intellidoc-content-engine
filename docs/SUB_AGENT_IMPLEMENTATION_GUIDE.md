# docs/SUB_AGENT_IMPLEMENTATION_GUIDE.md
**Purpose**: Detailed implementation steps for creating specialized sub-agents
**Related**: agents/CLAUDE.md, .claude/CLAUDE.md, templates/CLAUDE.md
**AI-hints**:
- Based on proven 46-agent IntelliDoc Content Engine architecture
- Covers YAML configuration, model selection, and deployment
- Includes specific examples from production system

# Sub-Agent Creation Implementation Guide

## Table of Contents
1. [Understanding the Architecture](#step-1-understanding-the-architecture)
2. [YAML Configuration Setup](#step-2-yaml-configuration-setup)
3. [Agent Naming and Description](#step-3-agent-naming-and-description)
4. [Tool Configuration](#step-4-tool-configuration)
5. [Model Selection](#step-5-model-selection)
6. [System Prompt Design](#step-6-system-prompt-design)
7. [Deployment and Testing](#step-7-deployment-and-testing)

---

## Step 1: Understanding the Architecture

### The 46-Agent Ecosystem Structure

The IntelliDoc Content Engine demonstrates a **specialization over consolidation** philosophy with 46 specialized agents organized in 10 phases:

```
46 Total Agents:
├── 40 Core Content Agents (Phases 1-9)
│   ├── Phase 1: Research & Discovery (5 agents)
│   ├── Phase 2: Strategy & Planning (5 agents)
│   ├── Phase 3: Content Creation (5 agents)
│   ├── Phase 4: Technical Content (4 agents)
│   ├── Phase 5: Tutorial Creation (4 agents)
│   ├── Phase 6: Quality Assurance (5 agents)
│   ├── Phase 7: Visual Creation (5 agents)
│   ├── Phase 8: Distribution (5 agents)
│   └── Phase 9: Performance Analysis (3 agents)
└── 6 Swiss Localization Agents (Phase 10)
```

### Directory Structure

```
CODE/
├── agents/                     # Source files (46 total)
│   ├── language_agents/        # Swiss localization (6)
│   ├── orchestration/          # content-assembler only
│   └── [individual-agent].md   # Core agents (40)
├── .claude/agents/             # Deployed agents (symlinks)
└── templates/                  # XML workflow patterns (7)
```

### Context Isolation and Single Responsibility

**Key Principle**: Each agent has ONE clear responsibility to prevent:
- Task contamination across agents
- Context bleeding between different functions
- Tool permission escalation

**Example from Production**:
- `source-gatherer` (Sonnet): Only research and source collection
- `body-writer` (Sonnet): Only main content writing with evidence
- `twitter-formatter` (Haiku): Only Twitter thread creation
- `content-assembler` (Haiku): Only consolidation of fragments

---

## Step 2: YAML Configuration Setup

### Required YAML Frontmatter Structure

Every agent MUST start with this exact YAML structure:

```yaml
---
name: [agent-name]
description: [single responsibility description]
model: [haiku|sonnet|opus]
tools: [minimal tool list]
---
```

### Real Examples from Production

#### Research Agent (Sonnet + Web Tools)
```yaml
---
name: source-gatherer
description: Collect authoritative sources and references for content topics
model: sonnet
tools: WebSearch, WebFetch, Read
---
```

#### Content Creation Agent (Sonnet + File Tools)
```yaml
---
name: body-writer
description: Write main content sections with examples and evidence
model: sonnet
tools: Read, Write
---
```

#### Formatting Agent (Haiku + Minimal Tools)
```yaml
---
name: twitter-formatter
description: Create Twitter/X threads from content
model: haiku
tools: Read, Write
---
```

#### Assembly Agent (Haiku + File Tools)
```yaml
---
name: content-assembler
description: Consolidates all content fragments from pipeline agents into final polished deliverable
model: haiku
tools: Read, Write
---
```

### YAML Field Requirements

- **name**: Must be lowercase, hyphen-separated, match filename
- **description**: Must include trigger keywords for automatic invocation
- **model**: Must be `haiku`, `sonnet`, or `opus` (lowercase)
- **tools**: Comma-separated list, minimal necessary permissions only

---

## Step 3: Agent Naming and Description

### File Naming Convention

Pattern: `[function]-[role].md`

**Production Examples**:
- `source-gatherer.md` - Gathers sources
- `body-writer.md` - Writes main content
- `fact-verifier.md` - Verifies factual accuracy
- `twitter-formatter.md` - Formats for Twitter
- `swiss-german-translator.md` - Swiss German translation

### Description Guidelines

Descriptions must be **clear and specific** for automatic agent selection:

#### Good Descriptions (From Production)
```yaml
# Specific and actionable
description: Collect authoritative sources and references for content topics

# Clear single responsibility
description: Write main content sections with examples and evidence

# Platform-specific
description: Create Twitter/X threads from content

# Translation specific
description: Translates to Swiss German (Schweizerdeutsch) with cultural adaptation
```

#### Bad Descriptions (Avoid)
```yaml
# Too vague
description: Help with content

# Multiple responsibilities
description: Research topics and write content and format for social media

# Missing key trigger words
description: Does writing stuff
```

### Trigger Keywords for Automatic Invocation

Include these keywords in descriptions based on agent function:

- **Research**: "collect", "gather", "find", "research", "sources"
- **Writing**: "write", "create", "compose", "draft"
- **Analysis**: "analyze", "examine", "assess", "evaluate"
- **Formatting**: "format", "adapt", "transform", "convert"
- **Translation**: "translate", "localize", "adapt"
- **Quality**: "verify", "check", "review", "validate"

---

## Step 4: Tool Configuration

### Minimal Tool Access Principle

**Rule**: Give each agent only the minimum tools needed for its specific function.

### Tool Patterns by Agent Type

#### Research Agents
```yaml
tools: WebSearch, WebFetch, Read
```
**Rationale**: Need to search web, fetch content, and read existing files for context.

**Example**: `source-gatherer`, `competitor-analyzer`, `trend-spotter`

#### Content Creation Agents
```yaml
tools: Read, Write
```
**Rationale**: Need to read research/context and write new content.

**Example**: `body-writer`, `intro-writer`, `conclusion-writer`

#### Analysis/Review Agents
```yaml
tools: Read
```
**Rationale**: Only need to read and analyze existing content.

**Example**: `grammar-checker`, `readability-scorer`, `fact-verifier`

#### Platform Formatting Agents
```yaml
tools: Read, Write
```
**Rationale**: Read source content and write formatted versions.

**Example**: `twitter-formatter`, `linkedin-adapter`, `instagram-packager`

#### Code Testing Agents (Special Case)
```yaml
tools: Read, Write, Bash
```
**Rationale**: Need to test code examples in tutorials.

**Example**: `code-tester`, `snippet-validator`

### Security Considerations

- **Never** give `Bash` access unless absolutely required for code testing
- **Never** give `WebSearch` to agents that don't need external data
- **Never** give `Write` to pure analysis agents
- Review all Opus agents and Bash tool assignments carefully

---

## Step 5: Model Selection

### Model Distribution Strategy (Optimized for 70% Cost Reduction)

Based on IntelliDoc's proven optimization:

- **Haiku (18 agents - 35%)**: Simple formatting, validation, specifications
- **Sonnet (20 agents - 38%)**: Research, analysis, strategic planning
- **Opus (6 agents - 13%)**: Deep content creation and critical translations

### Model Selection Decision Tree

#### Choose Haiku When:
- **Simple formatting** for different platforms
- **Rule-based validations** (fact checking, link validation)
- **Specifications creation** (diagrams, charts, infographics)
- **Pattern recognition** (trend spotting, topic scouting)
- **Platform adaptation** (Twitter, LinkedIn, Instagram formatting)

**Production Examples**:
```yaml
# Platform formatting
name: twitter-formatter
model: haiku

# Content assembly
name: content-assembler
model: haiku

# Simple validation
name: link-validator
model: haiku
```

#### Choose Sonnet When:
- **Research and competitive analysis**
- **Content strategy and planning**
- **Content components writing** (intro, body, conclusion)
- **Quality assurance requiring judgment**
- **Technical documentation**

**Production Examples**:
```yaml
# Research
name: source-gatherer
model: sonnet

# Content writing
name: body-writer
model: sonnet

# Strategic planning
name: content-planner
model: sonnet
```

#### Choose Opus When:
- **Complex content orchestration** requiring deep reasoning
- **Long-form content creation** with context synthesis
- **Critical translation work** requiring cultural understanding
- **Cross-content continuity** management

**Production Examples**:
```yaml
# Deep content creation
name: whitepaper-orchestrator
model: opus

# Critical translation
name: swiss-german-translator
model: opus

# Complex assembly
name: content-pipeline-orchestrator
model: opus
```

### Performance vs Cost Trade-offs

| Model | Speed | Cost | Best For |
|-------|-------|------|----------|
| Haiku | 3-5x faster | 70% cheaper | Simple, rule-based tasks |
| Sonnet | Balanced | Moderate | Research, analysis, writing |
| Opus | Slower | Higher | Complex reasoning, orchestration |

---

## Step 6: System Prompt Design

### Core Structure Template

Every agent follows this exact pattern after the YAML frontmatter:

```markdown
You are a [role] [doing what].

## Core Function
[Single, clear responsibility statement]

## Temporal Context
[Standard temporal context block - see examples]

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

### Real Production Examples

#### Research Agent Pattern (source-gatherer)
```markdown
You are a research specialist gathering authoritative sources.

## Core Function
Find and collect 5-7 high-quality sources from authoritative publications for content research.

## Input
```json
{
  "topic": "content topic to research",
  "angle": "specific perspective if defined",
  "source_requirements": "types of sources needed"
}
```

## Process
1. Search for authoritative sources on topic
2. Prioritize official docs and primary sources
3. Include recent industry publications
4. Extract key information from each source
5. Verify source credibility

## Output
```json
{
  "research_document": {
    "sources": [
      {
        "url": "full URL here",
        "title": "exact article title",
        "author": "author name or organization",
        "quotes": [...],
        "statistics": [...],
        "key_points": [...]
      }
    ]
  }
}
```

## Constraints
- MUST provide 5-7 sources minimum
- MUST verify source authority
- NEVER use content farms or unreliable sources
```

#### Content Writing Agent Pattern (body-writer)
```markdown
You are a content writer creating informative body sections.

## Core Function
Write clear, engaging main content sections that deliver on the article's promise with examples and evidence.

## Input
```json
{
  "outline": "section structure",
  "research_document": {...},
  "tone": "writing style",
  "word_target": 1000
}
```

## Process
1. Follow outline structure
2. Integrate research naturally WITH proper citations
3. Include relevant examples from research_document
4. Maintain consistent tone
5. Ensure smooth transitions

## Output
```json
{
  "body_content": "main article text",
  "sections_completed": 3,
  "examples_included": 5,
  "word_count": 1000
}
```

## Constraints
- MUST follow outline exactly
- MUST cite sources properly
- NEVER plagiarize sources
```

#### Platform Formatting Agent Pattern (twitter-formatter)
```markdown
You are a Twitter thread specialist.

## Core Function
Transform content into engaging Twitter threads optimized for the platform.

## Input
```json
{
  "key_points": ["from atomizer"],
  "article_url": "link to full",
  "hashtags": ["relevant tags"]
}
```

## Process
1. Create hook tweet
2. Break into tweet-sized insights
3. Ensure thread flow
4. Add hashtags strategically
5. Include CTA with link

## Output
```json
{
  "thread": [
    {"tweet": 1, "text": "hook", "chars": 250},
    {"tweet": 2, "text": "point", "chars": 240}
  ],
  "total_tweets": 6
}
```

## Constraints
- MUST stay under 280 chars
- MUST flow naturally
- MUST include article link
```

### Input/Output Specifications (JSON Format)

**Key Principles**:
1. **Always use JSON** for structured input/output
2. **Be specific** about field names and types
3. **Include metadata** (counts, timestamps, etc.)
4. **Show examples** of complex structures

### Process Steps

**Guidelines**:
- Use **numbered lists** (1, 2, 3...)
- Keep steps **specific and actionable**
- **3-7 steps** is optimal
- Each step should be **one clear action**

### Constraints (MUST/NEVER Patterns)

**Structure**:
```markdown
## Constraints
- MUST [specific requirement]
- MUST [another requirement]
- NEVER [specific restriction]
- NEVER [another restriction]
```

**Production Examples**:
```markdown
# Research agent constraints
- MUST provide 5-7 sources minimum
- MUST verify source authority
- NEVER use content farms or unreliable sources

# Content agent constraints
- MUST follow outline exactly
- MUST cite sources properly
- NEVER plagiarize sources

# Platform agent constraints
- MUST stay under 280 chars
- MUST include article link
- NEVER exceed platform limits
```

---

## Step 7: Deployment and Testing

### File Structure and Placement

1. **Create in source directory**:
   ```bash
   # Create new agent file
   nano /path/to/agents/my-new-agent.md
   ```

2. **Follow naming convention**:
   - Filename: `[function]-[role].md`
   - Agent name in YAML: must match filename (without .md)

3. **Include required header**:
   ```markdown
   # agents/my-new-agent.md
   **Purpose**: [Imperative verb + specific action, ≤80 chars]
   **Related**: agents/CLAUDE.md, templates/
   **AI-hints**:
   - Agent configuration with model and tools
   - Single responsibility principle enforced
   - Part of 46-agent content creation system
   ```

### Deployment Process

#### Method 1: Copy to .claude/agents/ (Simple)
```bash
# Copy source agent to deployed location
cp agents/my-new-agent.md .claude/agents/

# Verify deployment
ls -la .claude/agents/my-new-agent.md
```

#### Method 2: Symlink (Recommended for Development)
```bash
# Create symlink to keep source and deployed in sync
ln -s ../agents/my-new-agent.md .claude/agents/

# Verify symlink
ls -la .claude/agents/ | grep my-new-agent
```

### Testing Approaches

#### Basic Functionality Test
```bash
# Test agent responds to invocation
/agent my-new-agent
"Simple test request matching agent's function"
```

#### Input Validation Test
```bash
# Test with proper JSON input structure
/agent my-new-agent
```json
{
  "test_field": "test value",
  "expected_input": "as defined in agent"
}
```

#### Integration Test
```bash
# Test agent works within workflow
/agent source-gatherer
"Research topic: AI development"

# Then test new agent with that output
/agent my-new-agent
"[Use output from previous agent]"
```

### Validation Checklist

Before considering an agent production-ready:

#### Technical Validation
- [ ] YAML frontmatter is valid and complete
- [ ] Agent name matches filename (without .md)
- [ ] Model assignment follows optimization guidelines
- [ ] Tools are minimal and appropriate
- [ ] File exists in both `agents/` and `.claude/agents/`

#### Functional Validation
- [ ] Agent responds to invocation with `/agent [name]`
- [ ] Input JSON structure is clearly defined
- [ ] Output JSON structure is consistent and useful
- [ ] Process steps are actionable and specific
- [ ] Constraints prevent misuse and scope creep

#### Integration Validation
- [ ] Agent works within template workflows
- [ ] Outputs are compatible with other agents
- [ ] Content-assembler can handle agent outputs
- [ ] No duplicate functionality with existing agents

### Common Issues and Solutions

#### Agent Not Found
```bash
# Check if agent exists in deployed location
ls -la .claude/agents/my-new-agent.md

# If missing, copy from source
cp agents/my-new-agent.md .claude/agents/
```

#### YAML Parse Errors
- Verify no tabs (use spaces only)
- Check for trailing spaces after values
- Ensure proper comma separation in tools list
- Validate model name is exact: `haiku`, `sonnet`, or `opus`

#### Tool Permission Issues
- Start with minimal tools and add only if needed
- Test each tool individually
- Review security implications of Bash access
- Verify WebSearch/WebFetch are needed for research agents

#### Poor Integration with Workflows
- Test agent outputs with content-assembler
- Verify JSON structure matches template expectations
- Check that process steps align with workflow phases
- Ensure constraints don't conflict with other agents

### Performance Monitoring

After deployment, monitor:

#### Execution Metrics
- Response time compared to similar agents
- Cost per invocation vs model assignment
- Success rate for different input types
- Integration success with other agents

#### Quality Metrics
- Output consistency across multiple runs
- Adherence to JSON structure specification
- Constraint compliance in real usage
- User satisfaction with agent outputs

---

## Conclusion

This implementation guide is based on the proven architecture of the IntelliDoc Content Engine's 46-agent system, which achieved:

- **70% cost reduction** through optimized model assignment
- **3-5x speed improvement** for simple tasks via Haiku agents
- **Professional-grade output** through specialized single-responsibility agents
- **True parallel execution** enabling rapid content creation

### Key Success Factors

1. **Single Responsibility**: Each agent does ONE thing perfectly
2. **Minimal Tool Access**: Security through least privilege
3. **Optimized Model Selection**: Right model for the right task
4. **Template-Based Orchestration**: Systematic workflows over ad-hoc coordination
5. **Context Isolation**: Clean separation prevents contamination

### Next Steps

1. Start with simple Haiku agents for formatting/validation
2. Progress to Sonnet agents for research/writing components
3. Reserve Opus only for complex orchestration or critical tasks
4. Test thoroughly in isolation before integrating with workflows
5. Monitor performance and optimize model assignments based on actual usage

The 46-agent architecture demonstrates that **specialization over consolidation** delivers superior results at lower cost when implemented systematically.