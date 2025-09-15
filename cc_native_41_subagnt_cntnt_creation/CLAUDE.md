# 41-Agent Content Creation Module

## Module Purpose
This directory contains the 41 specialized agent definitions that comprise the content creation pipeline. Each agent follows Anthropic's single-responsibility principle and is optimized for specific content creation tasks.

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

### Agent Naming Conventions

**Pattern**: `[function]-[role].md`

**Examples**:
- `fact-verifier.md` (function: fact, role: verifier)
- `code-example-writer.md` (function: code-example, role: writer)
- `grammar-checker.md` (function: grammar, role: checker)

**Requirements**:
- Lowercase only
- Hyphen separated
- Descriptive of single function
- Maximum 3 words total

## Local Development Workflow

### Testing Individual Agents

1. **Syntax Validation**:
   ```bash
   # Check YAML frontmatter
   head -10 [agent-name].md | grep -E "^(name|description|model|tools):"
   ```

2. **Content Review**:
   ```bash
   # Check for required sections
   grep -E "^## (Core Function|Input|Process|Output|Constraints)" [agent-name].md
   ```

3. **Integration Test**:
   ```bash
   # Copy to active agents
   cp [agent-name].md ~/.claude/agents/

   # Verify Claude can see it
   /agents | grep [agent-name]
   ```

### Agent Quality Checklist

**Before Committing Changes**:
- [ ] YAML frontmatter is valid
- [ ] Single responsibility is clear
- [ ] Model selection is appropriate
- [ ] Tools are minimal necessary
- [ ] Process steps are actionable
- [ ] Constraints are specific
- [ ] Examples are concrete
- [ ] No security vulnerabilities

### Pipeline Orchestration Testing

1. **Phase Testing**:
   ```bash
   # Test related agents in sequence
   /agent topic-scout
   "Find trending topics in [domain]"

   /agent source-gatherer
   "Gather sources for [topic from scout]"
   ```

2. **Full Pipeline Test**:
   ```
   "Create a comprehensive technical article about [topic]"
   ```
   Monitor which agents activate automatically.

## Agent Specialization Patterns

### Research Agents (Phase 1)
- **Input**: Topic or domain
- **Process**: External source gathering
- **Output**: Structured data/sources
- **Tools**: WebSearch, WebFetch

### Content Creation Agents (Phase 3)
- **Input**: Research + outline
- **Process**: Content generation
- **Output**: Formatted text
- **Tools**: Read, Write

### Quality Assurance Agents (Phase 6)
- **Input**: Draft content
- **Process**: Review/correction
- **Output**: Improved content
- **Tools**: Read, Write (minimal)

### Distribution Agents (Phase 8)
- **Input**: Final content
- **Process**: Format adaptation
- **Output**: Platform-specific content
- **Tools**: Read, Write

## Agent Interaction Patterns

### Sequential Handoffs
```
research → planning → creation → quality → distribution
```

### Parallel Processing
```
Multiple research agents → Content synthesizer
Multiple QA agents → Final validator
```

### Error Handling
```
Agent fails → Fallback to manual
Missing input → Request clarification
Invalid output → Re-run with corrections
```

## Maintenance Guidelines

### Regular Reviews
- **Weekly**: Check agent performance logs
- **Monthly**: Review and update descriptions
- **Quarterly**: Audit tool permissions

### Version Control
```bash
# Tag stable agent sets
git tag -a "agents-v1.0" -m "Stable 41-agent set"

# Create feature branches for agent updates
git checkout -b "update-grammar-checker"
```

### Performance Monitoring
Track these metrics:
- Agent selection accuracy
- Task completion rates
- Model usage efficiency
- Tool access patterns

## Advanced Techniques

### Agent Composition
```bash
# Use multiple agents for complex tasks
/agent outline-builder
/agent intro-writer
/agent body-writer
/agent conclusion-writer
```

### Custom Workflows
```bash
# Create domain-specific agent chains
# Technical tutorial sequence
/agent step-sequencer → /agent code-example-writer → /agent exercise-designer
```

### Agent Debugging
```bash
# Test agent in isolation
/agent [name]
"Simple test case"

# Check agent selection
"[Complex request]"
# Monitor which agents activate
```

## Security & Safety

### Agent Constraints
- **NO** access to sensitive files
- **NO** arbitrary code execution
- **NO** external API calls (except research agents)
- **VALIDATE** all inputs and outputs

### Code Review Requirements
Changes to these agents require review:
- `body-writer.md` (Opus model)
- Any agent with `Bash` tools
- Research agents with web access

## Integration with Project Architecture

### File References
- Project overview: `@../.claude/CLAUDE.md`
- Implementation guide: `@./IMPLEMENTATION_GUIDE_41_AGENTS.md`
- Agent directory: This folder

### Deployment
```bash
# Install all agents
cp *.md ~/.claude/agents/

# Or project-specific installation
mkdir -p .claude/agents/
cp *.md .claude/agents/
```

## Troubleshooting

### Agent Not Triggering
1. Check agent name matches filename
2. Verify YAML frontmatter syntax
3. Confirm agent is in Claude's agents directory
4. Try explicit invocation: `/agent [name]`

### Wrong Agent Selected
1. Review description keywords
2. Check for description overlap
3. Be more specific in request
4. Use explicit agent selection

### Agent Performance Issues
1. Review model selection (haiku vs sonnet vs opus)
2. Optimize prompt clarity
3. Reduce tool dependencies
4. Split complex agents into simpler ones

---

*This module represents the core intelligence of the content engine - 41 specialized agents working in harmony to create exceptional content.*