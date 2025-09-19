# Workflow Templates - Using XML for Parallel Agent Execution

## The XML Pattern

These templates use the specific XML structure that enables true parallel agent execution in Claude Code. When you paste these XML blocks directly into Claude Code, it will execute all agents within a single `<function_calls>` block in parallel.

## Critical XML Requirements

1. **Single `<function_calls>` wrapper** - ALL agents must be in ONE wrapper
2. **Multiple `<invoke>` blocks** - Each agent gets its own invoke
3. **Three required parameters**:
   - `subagent_type`: The exact agent name
   - `description`: Brief task description
   - `prompt`: Detailed instructions for the agent

## Example XML Structure

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">agent-name-1</parameter>
<parameter name="description">Short description</parameter>
<parameter name="prompt">Detailed instructions for agent 1</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">agent-name-2</parameter>
<parameter name="description">Short description</parameter>
<parameter name="prompt">Detailed instructions for agent 2</parameter>
</invoke>
<!-- More agents in same function_calls block -->
</function_calls>
```

## How to Use Templates

1. **Choose your template**:
   - `blog-post-template.md` - Blog creation workflow
   - `tutorial-template.md` - Tutorial with exercises
   - `social-media-template.md` - Multi-platform social
   - `news-article-template.md` - Rapid news creation
   - `whitepaper-template.md` - Long-form research
   - `swiss-localization-template.md` - Translation workflows

2. **Copy the XML blocks** from the template

3. **Replace placeholders**:
   - `[YOUR TOPIC]` with your actual topic
   - `[paste X]` with outputs from previous phases
   - Other placeholders as needed

4. **Paste into Claude Code** - The XML will trigger parallel execution

## Why XML?

- **Guaranteed parallel execution** - This exact structure ensures parallelization
- **No ambiguity** - Claude Code recognizes this pattern immediately
- **Full control** - You see exactly what will run and how
- **Proven pattern** - Discovered through extensive testing (see white paper)

## Sequential vs Parallel

### Parallel Execution (All at once)
```xml
<function_calls>
<invoke name="Task">...</invoke>
<invoke name="Task">...</invoke>
<invoke name="Task">...</invoke>
</function_calls>
```

### Sequential Execution (One after another)
Run separate XML blocks or individual commands sequentially when tasks depend on each other.

## Tips

- **Maximum agents per block**: Tested up to 10 agents successfully
- **Independent tasks only**: Agents in same block can't depend on each other
- **Copy-paste ready**: Templates contain working XML you can use immediately
- **Customize prompts**: Modify the prompt parameter for your specific needs

## Available Agents

Run `/agents` to see all 46 available agents, or check `agents/CLAUDE.md` for descriptions.

## Important Note

These XML templates replace the broken orchestrator agents that claimed to coordinate but actually didn't. This approach gives you:
- True parallel execution (60-70% faster)
- Transparent operation (see what runs)
- Cost efficiency (appropriate model usage)
- Flexibility (customize as needed)