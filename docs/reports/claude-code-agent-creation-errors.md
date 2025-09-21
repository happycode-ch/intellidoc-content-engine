# docs/reports/claude-code-agent-creation-errors.md
**Purpose**: Document common sub-agent creation errors and solutions
**Related**: agents/CLAUDE.md, .claude/CLAUDE.md
**AI-hints**:
- Error documentation for Claude Code agent system
- Covers YAML syntax, naming, deployment issues
- Includes specific error messages and solutions

# Claude Code Agent Creation: Common Errors and Solutions

## Overview
This guide documents the 7 most common error categories when creating sub-agents in the Claude Code system, based on the 46-agent IntelliDoc Content Engine. Each error includes specific symptoms, root causes, and step-by-step solutions.

---

## 1. YAML Syntax Issues

### 1.1 Invalid Indentation Errors

**Error Message:**
```
Error: YAML parse error at line 12: Invalid indentation
Agent deployment failed: Malformed frontmatter
```

**Common Causes:**
- Mixing tabs and spaces in YAML frontmatter
- Incorrect indentation levels (YAML requires exact 2-space indentation)
- Missing spaces after colons in key-value pairs

**Examples of Invalid YAML:**
```yaml
---
name:source-gatherer          # Missing space after colon
description: Research content sources
model:  sonnet                # Extra space before value
tools:                        # Correct
 - Read                       # 1 space (should be 2)
	- Write                     # Tab character (should be spaces)
---
```

**Solution:**
```yaml
---
name: source-gatherer         # Space after colon
description: Research content sources
model: sonnet                 # Single space after colon
tools:                        # Correct
  - Read                      # Exactly 2 spaces
  - Write                     # Exactly 2 spaces
---
```

**Prevention Steps:**
1. Configure editor to show whitespace characters
2. Set editor to use spaces (not tabs) for YAML files
3. Use 2-space indentation consistently
4. Validate YAML syntax before deployment

### 1.2 Missing Required Fields

**Error Message:**
```
Agent validation failed: Missing required field 'description'
Required fields: name, description, model, tools
```

**Required Fields in Every Agent:**
```yaml
---
name: [agent-name]            # REQUIRED: Must match filename
description: [purpose]        # REQUIRED: Single responsibility statement
model: [haiku|sonnet|opus]   # REQUIRED: Performance tier
tools: [tool-list]           # REQUIRED: Can be empty array []
---
```

**Solution Pattern:**
```yaml
---
name: content-validator
description: Validate content structure and formatting requirements
model: haiku
tools:
  - Read
---
```

### 1.3 Incorrect Frontmatter Format

**Error Message:**
```
No frontmatter detected in agent file
Agent must start with --- and end with ---
```

**Invalid Examples:**
```markdown
name: my-agent               # Missing opening ---
description: Does things
model: sonnet
tools: []

--                           # Wrong delimiter
name: my-agent
description: Does things
model: sonnet
tools: []
--                           # Wrong closing delimiter
```

**Correct Format:**
```yaml
---                          # Exactly three dashes
name: my-agent
description: Does things
model: sonnet
tools: []
---                          # Exactly three dashes

You are a [role description]...
```

---

## 2. Naming Conflicts

### 2.1 Duplicate Agent Names

**Error Message:**
```
Agent deployment error: Name 'content-writer' already exists
Conflicting file: /home/user/.claude/agents/content-writer.md
```

**Root Cause:**
- Agent name matches existing agent in `.claude/agents/`
- Case-sensitive conflicts (Linux systems)
- Attempting to create variants of existing agents

**Solution Steps:**
1. Check existing agents:
   ```bash
   ls -la ~/.claude/agents/*.md | grep -i "content-writer"
   ```

2. Choose unique, descriptive name:
   ```yaml
   # Instead of: content-writer
   # Use specific function:
   ---
   name: blog-body-writer
   # or
   name: tutorial-content-creator
   # or
   name: technical-content-specialist
   ```

3. Verify uniqueness before creation:
   ```bash
   # Check if name exists
   find ~/.claude/agents/ -name "*blog-body-writer*"
   ```

### 2.2 Invalid Characters in Names

**Error Message:**
```
Invalid agent name: 'content_writer@v2.1'
Names must contain only lowercase letters, numbers, and hyphens
```

**Invalid Name Patterns:**
```yaml
name: content_writer         # Underscores not allowed
name: Content-Writer         # Uppercase not allowed
name: content-writer@v2      # Special characters not allowed
name: content writer         # Spaces not allowed
name: content-writer-       # Cannot end with hyphen
name: -content-writer       # Cannot start with hyphen
```

**Valid Name Patterns:**
```yaml
name: content-writer         # Lowercase with hyphens
name: content-writer-v2      # Numbers allowed
name: blog-content-creator   # Multiple hyphens allowed
name: swiss-german-translator # Descriptive compound names
```

### 2.3 Case Sensitivity Issues

**Error Message (Linux):**
```
Warning: Case conflict detected
Found: Content-Writer.md and content-writer.md
Linux deployment will fail
```

**Prevention:**
- Always use lowercase names
- Test on Linux-like systems
- Use consistent naming conventions

---

## 3. Tool Access Problems

### 3.1 Requesting Non-existent Tools

**Error Message:**
```
Unknown tool: 'WebCrawl'
Available tools: Read, Write, WebSearch, WebFetch, Bash
```

**Available Tools in Claude Code:**
```yaml
tools:
  - Read          # File reading
  - Write         # File writing
  - WebSearch     # Internet search
  - WebFetch      # Fetch web pages
  - Bash          # Shell commands (limited access)
```

**Common Typos:**
```yaml
# WRONG                    # CORRECT
tools:                     tools:
  - read                   # Case sensitive - use Read
  - WebCrawl              # Use WebSearch or WebFetch
  - FileRead              # Use Read
  - HTTPFetch             # Use WebFetch
  - Terminal              # Use Bash
```

### 3.2 Tool Name Typos

**Error Message:**
```
Tool 'WebSeach' not recognized
Did you mean: WebSearch?
```

**Common Typos and Corrections:**
```yaml
# Common misspellings:
tools:
  - WebSeach      # WRONG: Missing 'r'
  - WebSearch     # CORRECT

  - WebFetsh      # WRONG: Letters swapped
  - WebFetch      # CORRECT

  - ReadFile      # WRONG: Compound name
  - Read          # CORRECT

  - WriteFile     # WRONG: Compound name
  - Write         # CORRECT
```

### 3.3 Security Permission Denials

**Error Message:**
```
Permission denied: Agent 'content-reader' cannot access Bash tool
Bash access restricted to code-testing agents only
```

**Tool Access Guidelines:**
```yaml
# Research agents (Phase 1-2)
tools:
  - WebSearch
  - WebFetch
  - Read          # For existing content

# Content creation agents (Phase 3)
tools:
  - Read
  - Write

# Code testing agents only
tools:
  - Read
  - Write
  - Bash          # Restricted access

# Analysis agents (Phase 6, 9)
tools:
  - Read          # Read-only access

# Formatting agents (Phase 7-8)
tools:
  - Read
  - Write
```

**Solution:**
1. Review agent's actual function
2. Request minimal necessary tools
3. For Bash access, justify in agent description:
   ```yaml
   name: code-validator
   description: Test and validate code examples for tutorials
   model: sonnet
   tools:
     - Read
     - Write
     - Bash        # Required for code execution testing
   ```

---

## 4. Model Selection Failures

### 4.1 Invalid Model Names

**Error Message:**
```
Unknown model: 'claude-3-opus'
Valid models: haiku, sonnet, opus
```

**Invalid Model Names:**
```yaml
model: claude-3-haiku       # Use: haiku
model: claude-sonnet        # Use: sonnet
model: claude-3-opus-20240229 # Use: opus
model: gpt-4                # Claude Code only
model: SONNET               # Case sensitive
```

**Correct Model Names:**
```yaml
model: haiku               # Fast, simple tasks
model: sonnet              # Balanced performance
model: opus                # Complex reasoning
```

### 4.2 Model Quota Exceeded

**Error Message:**
```
Rate limit exceeded for model 'opus'
Too many Opus agents running simultaneously
Current Opus agents: 14/10 limit
```

**Current Model Distribution (Optimized):**
- **Haiku**: 18 agents (35%) - Simple tasks
- **Sonnet**: 20 agents (38%) - Balanced work
- **Opus**: 6 agents (13%) - Complex reasoning only

**Solution:**
1. Check current Opus usage:
   ```bash
   grep -l "model: opus" ~/.claude/agents/*.md | wc -l
   ```

2. Consider downgrading to Sonnet:
   ```yaml
   # If task doesn't require deep reasoning:
   model: sonnet    # Instead of opus
   ```

3. Reserve Opus for:
   - Complex orchestration
   - Swiss localization (cultural understanding)
   - Content assembly requiring synthesis

### 4.3 Wrong Model for Task Complexity

**Performance Issues:**
```yaml
# Haiku agent struggling with complex research
name: competitor-analyzer
model: haiku              # Too simple for complex analysis
```

**Model Selection Guide:**
```yaml
# Use Haiku for:
name: twitter-formatter
model: haiku
description: Format content for Twitter character limits

# Use Sonnet for:
name: competitor-analyzer
model: sonnet
description: Analyze competitor strategies and positioning

# Use Opus for:
name: content-assembler
model: opus
description: Synthesize multiple content fragments into cohesive whole
```

---

## 5. Context Isolation Issues

### 5.1 Agents Trying to Share State

**Error Message:**
```
Context isolation violation: Agent attempting to access shared memory
Each agent runs in isolated context
```

**Invalid Approach:**
```yaml
# Agent trying to share variables
name: content-tracker
description: Track content state across multiple agents
```

**Solution - Use Input/Output JSON:**
```yaml
name: content-validator
description: Validate content and pass results to next agent

## Output
```json
{
  "validation_results": {
    "passed": true,
    "issues": [],
    "next_agent_input": "formatted content"
  }
}
```

### 5.2 Context Window Overflow

**Error Message:**
```
Context limit exceeded: Input too large for agent
Maximum context: 100k tokens for Haiku, 200k for Sonnet/Opus
```

**Prevention Strategies:**
```yaml
## Input
```json
{
  "content_fragment": "focused section only",
  "context_summary": "brief overview",
  "specific_task": "narrow scope"
}
```

**Solution - Break into smaller agents:**
```yaml
# Instead of one large agent:
name: content-processor
description: Process entire document

# Create specialized agents:
name: intro-processor
description: Process introduction sections only

name: body-processor
description: Process body content in chunks
```

### 5.3 Memory Limitations

**Error:**
```
Agent memory overflow: Too many concurrent operations
Reduce agent scope or split functionality
```

**Solution Pattern:**
```yaml
name: section-writer
description: Write single content section with specific focus

## Process
1. Focus on assigned section only
2. Output section content
3. Pass context to next agent via JSON
```

---

## 6. System Prompt Problems

### 6.1 Vague Instructions

**Poor Agent Definition:**
```yaml
name: content-helper
description: Help with content stuff
model: sonnet
tools: [Read, Write]
---

You are a content assistant. Help with various content tasks.
```

**Problems:**
- No clear responsibility
- Vague role definition
- Missing process steps
- No constraints

**Improved Version:**
```yaml
name: headline-optimizer
description: Optimize headlines for engagement and SEO
model: sonnet
tools: [Read]
---

You are a headline optimization specialist.

## Core Function
Improve headlines for maximum engagement while maintaining SEO value.

## Input
```json
{
  "original_headline": "current headline",
  "target_keywords": ["keyword1", "keyword2"],
  "platform": "blog|social|newsletter"
}
```

## Process
1. Analyze current headline strength
2. Test keyword integration
3. Optimize for platform requirements
4. Ensure clarity and engagement

## Output
```json
{
  "optimized_headline": "improved version",
  "engagement_score": 8.5,
  "seo_improvements": ["keyword placement", "length optimization"]
}
```

## Constraints
- MUST maintain original meaning
- MUST include target keywords
- NEVER exceed platform character limits
```

### 6.2 Missing JSON Specifications

**Error Pattern:**
```yaml
name: data-analyzer
---

You analyze data and provide insights.

# Missing structured input/output specifications
```

**Required Structure:**
```yaml
name: data-analyzer
---

You are a data analysis specialist.

## Input
```json
{
  "data_source": "source description",
  "analysis_type": "descriptive|predictive",
  "metrics": ["metric1", "metric2"]
}
```

## Output
```json
{
  "insights": [
    {
      "metric": "metric_name",
      "value": 123,
      "trend": "increasing|decreasing|stable",
      "recommendation": "action to take"
    }
  ]
}
```
```

### 6.3 Conflicting Constraints

**Problematic Constraints:**
```yaml
## Constraints
- MUST be comprehensive and detailed
- MUST be brief and concise
- MUST include all research sources
- NEVER exceed 100 words
```

**Solution - Clear Priorities:**
```yaml
## Constraints
- MUST prioritize accuracy over speed
- MUST cite sources for all claims
- MUST stay within 500-word limit
- NEVER sacrifice factual accuracy for brevity
```

---

## 7. Deployment Errors

### 7.1 Wrong Directory Location

**Error Message:**
```
Agent file not found in deployment directory
Expected: ~/.claude/agents/my-agent.md
Found: ~/project/agents/my-agent.md
```

**Correct Deployment Process:**
1. Create agent in source directory:
   ```bash
   # Create in project source
   nano ~/project/agents/my-agent.md
   ```

2. Deploy to Claude agents directory:
   ```bash
   # Copy to deployment location
   cp ~/project/agents/my-agent.md ~/.claude/agents/
   ```

3. Verify deployment:
   ```bash
   ls -la ~/.claude/agents/my-agent.md
   ```

### 7.2 File Permission Issues

**Error Message:**
```
Permission denied: Cannot read agent file
File permissions: -rw------- (600)
Required permissions: -rw-r--r-- (644)
```

**Solution:**
```bash
# Fix file permissions
chmod 644 ~/.claude/agents/my-agent.md

# Verify permissions
ls -la ~/.claude/agents/my-agent.md
```

### 7.3 Git Conflicts

**Error Message:**
```
Git conflict detected in agent file
Merge conflict markers found in YAML frontmatter
```

**Prevention:**
1. Always pull before creating agents:
   ```bash
   git pull origin main
   ```

2. Create agents in feature branches:
   ```bash
   git checkout -b feature/new-agent
   ```

3. Resolve conflicts before deployment:
   ```bash
   # Check for conflicts
   git status

   # Resolve manually, then:
   git add agents/my-agent.md
   git commit -m "feat: Add new agent"
   ```

---

## Quick Troubleshooting Checklist

### Before Creating Agent:
- [ ] Unique name not in use
- [ ] Clear single responsibility
- [ ] Appropriate model selection
- [ ] Minimal necessary tools

### YAML Validation:
- [ ] Starts and ends with `---`
- [ ] All required fields present
- [ ] 2-space indentation throughout
- [ ] No tabs in YAML
- [ ] Spaces after colons

### Testing Process:
```bash
# 1. Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('agent.md').read().split('---')[1])"

# 2. Deploy agent
cp agents/my-agent.md ~/.claude/agents/

# 3. Test basic functionality
/agent my-agent
"Simple test request"

# 4. Verify output format
# Check JSON structure matches specification
```

### Common Error Patterns:
1. **YAML syntax** - Check indentation and required fields
2. **Name conflicts** - Use unique, descriptive names
3. **Tool access** - Request minimal necessary permissions
4. **Model selection** - Match complexity to task requirements
5. **Context isolation** - Design for independent operation
6. **System prompts** - Provide clear, structured instructions
7. **Deployment** - Verify file location and permissions

---

## Error Recovery Procedures

### Agent Not Responding:
1. Check deployment:
   ```bash
   ls ~/.claude/agents/agent-name.md
   ```

2. Validate YAML:
   ```bash
   head -20 ~/.claude/agents/agent-name.md
   ```

3. Test with simple request:
   ```bash
   /agent agent-name
   "test"
   ```

### Performance Issues:
1. Check model assignment vs. task complexity
2. Reduce input size if context overflow
3. Simplify agent responsibility scope

### Output Format Problems:
1. Verify JSON specification in agent definition
2. Test with structured input
3. Check constraint conflicts

### Deployment Failures:
1. Verify file permissions (644)
2. Check directory location (`~/.claude/agents/`)
3. Resolve any Git conflicts

---

## Best Practices Summary

1. **Start Simple**: Create minimal viable agent first
2. **Test Early**: Deploy and test with simple inputs
3. **Iterate**: Refine based on actual performance
4. **Document**: Clear descriptions and constraints
5. **Isolate**: Single responsibility per agent
6. **Validate**: Check YAML syntax before deployment
7. **Monitor**: Track performance and error patterns

This guide covers the most common pitfalls in Claude Code agent creation. Following these patterns and solutions will prevent 90% of typical agent deployment issues.