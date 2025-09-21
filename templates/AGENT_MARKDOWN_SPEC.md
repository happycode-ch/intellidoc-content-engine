# templates/AGENT_MARKDOWN_SPEC.md
# Purpose: Define specification for building Claude Code agent markdown files
# Related: None
# AI-hints:
# - Project-agnostic specification
# - XML workflow pattern documentation
# - Direct invocation for parallel execution

# Claude Code Agent Markdown File Specification

## Overview
This specification defines how to create markdown files that enable parallel agent execution in Claude Code using XML patterns for workflow orchestration.

## Core XML Pattern

The foundation of parallel agent execution is a specific XML structure that Claude Code recognizes and executes in parallel.

### Required XML Structure
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">[agent-name]</parameter>
<parameter name="description">[brief-task-description]</parameter>
<parameter name="prompt">[detailed-instructions]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">[another-agent]</parameter>
<parameter name="description">[brief-task-description]</parameter>
<parameter name="prompt">[detailed-instructions]</parameter>
</invoke>
<!-- Additional agents in same function_calls block -->
</function_calls>
```

## Critical Requirements

### 1. XML Structure Rules
- **Single wrapper**: All agents must be within ONE `<function_calls>` block
- **Multiple invokes**: Each agent gets its own `<invoke>` block
- **Three parameters required**:
  - `subagent_type`: Exact agent name (must match agent file name)
  - `description`: Brief task description (3-5 words)
  - `prompt`: Detailed instructions for the agent

### 2. Parallel vs Sequential Execution

#### Parallel Execution (Simultaneous)
```xml
<function_calls>
<invoke name="Task">...</invoke>
<invoke name="Task">...</invoke>
<invoke name="Task">...</invoke>
</function_calls>
```
All agents execute at the same time.

#### Sequential Execution (One after another)
Run separate XML blocks or individual commands when tasks depend on each other:
```xml
<!-- Phase 1 -->
<function_calls>
<invoke name="Task">...</invoke>
</function_calls>

<!-- Wait for Phase 1 results, then Phase 2 -->
<function_calls>
<invoke name="Task">...</invoke>
</function_calls>
```

## Agent Markdown File Structure

### File Header (Required)
Every agent markdown file must start with:
```markdown
# [agent-type]/[agent-name].md
# Purpose: [Imperative verb + specific action, ≤80 chars]
# Related: [List related files or 'None']
# AI-hints:
# - [Key capability or constraint]
# - [Processing approach]
# - [Output format or expectation]
```

### Agent Definition Section
```yaml
name: [agent-name]
model: [haiku|sonnet|opus]  # Choose based on task complexity
tools: [Read, Write, WebSearch, etc.]  # Only necessary tools
```

### System Prompt Section
```markdown
## System Prompt

[Clear, specific instructions defining the agent's single responsibility]

### Core Task
[Precise description of what this agent does]

### Input Requirements
[What the agent expects to receive]

### Output Format
[Exact format of the agent's output]

### Constraints
[Any limitations or rules the agent must follow]
```

## Template Structure for Workflows

### Basic Template Layout
```markdown
# [workflow-type]-template.md
# Purpose: [Workflow purpose]
# Related: [Related templates or agents]
# AI-hints:
# - XML workflow pattern for parallel execution
# - [Number] phases for completion
# - Direct invocation model

# [Workflow Name]

## Overview
[Brief description of what this workflow accomplishes]

## Phase 1: [Phase Name]
[Description of this phase's goal]

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">[agent-1]</parameter>
<parameter name="description">[task]</parameter>
<parameter name="prompt">[PLACEHOLDER: YOUR INPUT]</parameter>
</invoke>
<!-- Additional agents for this phase -->
</function_calls>
```

## Phase 2: [Phase Name]
[Description requiring Phase 1 outputs]

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">[agent-2]</parameter>
<parameter name="description">[task]</parameter>
<parameter name="prompt">[paste Phase 1 results here]</parameter>
</invoke>
</function_calls>
```

## Final Assembly
[Instructions for combining all outputs]
```

## Best Practices

### 1. Agent Design Principles
- **Single Responsibility**: Each agent does ONE thing well
- **Context Isolation**: Clean context prevents contamination
- **Minimal Tool Access**: Only necessary permissions
- **Clear Output Format**: Predictable, parseable results

### 2. Workflow Design
- **Independent Tasks**: Group only non-dependent tasks in parallel
- **Phase Separation**: Use phases for dependent operations
- **Placeholder Strategy**: Use clear placeholders like `[YOUR TOPIC]`
- **Result Passing**: Explicit instructions for passing data between phases

### 3. Model Selection
- **haiku**: Simple tasks, formatting, basic analysis
- **sonnet**: Complex logic, creative content, detailed analysis
- **opus**: Critical thinking, synthesis, final assembly

### 4. Performance Optimization
- **Maximum agents per block**: 10 tested successfully
- **Parallel when possible**: 60-70% faster than sequential
- **Appropriate model selection**: Cost and speed optimization
- **Tool minimization**: Fewer tools = faster execution

## Implementation Checklist

### For Individual Agents
- [ ] Proper file header with path, purpose, and AI-hints
- [ ] Agent name matches filename
- [ ] Model appropriate for task complexity
- [ ] Only necessary tools included
- [ ] Clear system prompt with single responsibility
- [ ] Defined input/output formats
- [ ] Explicit constraints documented

### For Workflow Templates
- [ ] Overview explains workflow purpose
- [ ] Phases clearly separated and numbered
- [ ] XML blocks properly formatted
- [ ] Placeholders clearly marked
- [ ] Dependencies between phases noted
- [ ] Final assembly instructions included
- [ ] Example usage provided

## Common Patterns

### Research → Analysis → Output
```xml
<!-- Phase 1: Parallel Research -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">researcher-1</parameter>
<parameter name="description">Research topic</parameter>
<parameter name="prompt">[TOPIC]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">researcher-2</parameter>
<parameter name="description">Gather sources</parameter>
<parameter name="prompt">[TOPIC]</parameter>
</invoke>
</function_calls>

<!-- Phase 2: Analysis -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">analyzer</parameter>
<parameter name="description">Analyze findings</parameter>
<parameter name="prompt">[paste research results]</parameter>
</invoke>
</function_calls>

<!-- Phase 3: Output Generation -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">writer</parameter>
<parameter name="description">Create output</parameter>
<parameter name="prompt">[paste analysis]</parameter>
</invoke>
</function_calls>
```

### Multi-Format Output
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">formatter-markdown</parameter>
<parameter name="description">Format as markdown</parameter>
<parameter name="prompt">[CONTENT]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">formatter-html</parameter>
<parameter name="description">Format as HTML</parameter>
<parameter name="prompt">[CONTENT]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">formatter-json</parameter>
<parameter name="description">Format as JSON</parameter>
<parameter name="prompt">[CONTENT]</parameter>
</invoke>
</function_calls>
```

## Troubleshooting

### Common Issues
1. **Agents not executing in parallel**
   - Ensure all agents are in single `<function_calls>` block
   - Verify XML syntax is exact

2. **Agent not found**
   - Check agent name matches filename exactly
   - Ensure agent is deployed to correct directory

3. **Context contamination**
   - Agents sharing unintended information
   - Solution: Clearer prompts, explicit boundaries

4. **Output inconsistency**
   - Define exact output format in system prompt
   - Provide examples in agent instructions

## Summary

This specification enables:
- **True parallel execution** through XML patterns
- **Predictable workflows** via template structure
- **Optimal performance** with appropriate model selection
- **Maintainable systems** through clear documentation

The key is the XML pattern within a single `<function_calls>` block, which triggers Claude Code's parallel execution capability.