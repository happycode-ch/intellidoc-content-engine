# Orchestrator Prompt Requirements Analysis

## Executive Summary

After testing, we discovered that adding the Task tool to orchestrators is **necessary but not sufficient**. The orchestrators also need explicit instructions in their prompts to actually USE the Task tool to invoke other agents.

## The Core Problem

**Current Reality**: Orchestrators have Task tool access but still act as single agents
**Root Cause**: Their prompts don't explicitly instruct them to use Task for each agent
**Solution Required**: Update orchestrator prompts with explicit Task usage instructions

## Current vs Required Prompt Structure

### Current (BROKEN) Prompt Structure
Most orchestrators currently have prompts like this:

```markdown
## Fixed Agent Pipeline
Your workflow ALWAYS follows this sequence:

### Phase 1: Research
1. topic-scout - Identify trending angles
2. source-gatherer - Collect sources
3. fact-verifier - Verify claims
```

**Problem**: Lists agents but doesn't say HOW to invoke them

### Required (WORKING) Prompt Structure
Orchestrators need explicit Task instructions:

```markdown
## Fixed Agent Pipeline
Your workflow ALWAYS follows this sequence using the Task tool:

### Phase 1: Research (MUST USE TASK TOOL)
1. Use Task to invoke topic-scout with:
   - subagent_type: "topic-scout"
   - description: "Find trending topics"
   - prompt: [detailed instructions with context]

2. Use Task to invoke source-gatherer with:
   - subagent_type: "source-gatherer"
   - description: "Collect sources"
   - prompt: [pass output from topic-scout]
```

## Example Prompt Updates Needed

### Example 1: Social Media Orchestrator

**Current (Ineffective)**:
```markdown
### Phase 1: Analysis
1. content-atomizer - Extract key points
2. twitter-formatter - Format for Twitter
3. linkedin-adapter - Adapt for LinkedIn
```

**Required (Effective)**:
```markdown
### Phase 1: Analysis (USE TASK TOOL - DO NOT CREATE CONTENT DIRECTLY)
1. INVOKE via Task tool:
   - Agent: content-atomizer
   - Pass: Full source content
   - Expect: Bullet points of key facts

2. INVOKE via Task tool:
   - Agent: twitter-formatter
   - Pass: Key points from content-atomizer
   - Expect: 280-character formatted post

3. INVOKE via Task tool:
   - Agent: linkedin-adapter
   - Pass: Same key points
   - Expect: Professional LinkedIn version

CRITICAL: You MUST use Task tool for EACH agent. Do NOT generate content yourself.
```

### Example 2: Tutorial Orchestrator

**Current (Ineffective)**:
```markdown
### Content Creation
1. outline-builder - Create structure
2. intro-writer - Write introduction
3. step-sequencer - Order steps
4. exercise-designer - Create exercises
```

**Required (Effective)**:
```markdown
### Content Creation (MANDATORY TASK TOOL USAGE)
You MUST invoke these agents IN ORDER using Task tool:

1. Task(subagent_type="outline-builder",
        description="Build tutorial outline",
        prompt="Create outline for [topic] with [requirements]")
   OUTPUT: Structured outline to pass forward

2. Task(subagent_type="intro-writer",
        description="Write introduction",
        prompt=f"Using outline: {outline}, write engaging intro")
   OUTPUT: Introduction text to include

3. Task(subagent_type="step-sequencer",
        description="Sequence tutorial steps",
        prompt=f"Order these steps logically: {outline}")
   OUTPUT: Ordered step list

4. Task(subagent_type="exercise-designer",
        description="Create practice exercises",
        prompt=f"Design exercises for steps: {steps}")
   OUTPUT: Exercises with solutions

REMEMBER: You orchestrate, you don't create. Use Task for EVERY agent.
```

### Example 3: Swiss Localization Orchestrator

**Current (Ineffective)**:
```markdown
Translate content to Swiss languages:
- swiss-german-translator
- swiss-french-translator
- swiss-italian-translator
```

**Required (Effective)**:
```markdown
MANDATORY: Use Task tool to invoke each translator:

For German:
Task(subagent_type="swiss-german-translator",
     description="Translate to Swiss German",
     prompt=f"Translate to Züritschüüch: {content}")

For French:
Task(subagent_type="swiss-french-translator",
     description="Translate to Swiss French",
     prompt=f"Translate to Suisse Romand French: {content}")

For Italian:
Task(subagent_type="swiss-italian-translator",
     description="Translate to Swiss Italian",
     prompt=f"Translate to Ticinese Italian: {content}")

Then invoke verifier:
Task(subagent_type="swiss-compliance-checker",
     description="Verify translations",
     prompt="Check all translations for accuracy")

DO NOT TRANSLATE DIRECTLY. You MUST use Task for each translation.
```

## Key Principles for Orchestrator Prompts

### 1. Explicit Task Usage
```markdown
❌ BAD: "Use agent-name for task"
✅ GOOD: "Use Task tool to invoke agent-name"
✅ BETTER: "Task(subagent_type='agent-name', prompt='...')"
```

### 2. Prohibition of Direct Action
```markdown
MUST INCLUDE:
- "Do NOT create content directly"
- "You are an ORCHESTRATOR, not a creator"
- "ONLY coordinate other agents via Task tool"
```

### 3. Context Passing Instructions
```markdown
MUST SPECIFY:
- What output to capture from each agent
- How to pass context to next agent
- Format for maintaining state between agents
```

### 4. Verification Requirements
```markdown
ADD CHECKS:
- "Verify each agent completes before proceeding"
- "Pass ALL outputs to final assembler"
- "Confirm Task tool usage for EACH step"
```

## Implementation Strategy

### Phase 1: Critical Updates
1. **blog-post-orchestrator** ✅ (already updated)
2. **tutorial-orchestrator** - High usage, needs explicit Task instructions
3. **social-media-orchestrator** - Simple pipeline, good for testing

### Phase 2: Complex Orchestrators
4. **whitepaper-orchestrator** - 30+ agents need clear sequencing
5. **series-orchestrator** - Multi-part coordination
6. **news-orchestrator** - Speed-critical pipeline

### Phase 3: Specialized
7. **swiss-localization-orchestrator** - Multiple language paths

## Success Metrics

After prompt updates, we should see:

1. **Execution logs showing**: "Invoking agent: [name]" for each step
2. **Multiple output files** in temp directories
3. **Longer execution times** (3-5 minutes vs 30 seconds)
4. **Context passing** visible between agents
5. **Clear handoffs** in the output

## Testing Protocol

### Test 1: Simple Chain (3-4 agents)
- Source → Formatter → Validator → Assembler
- Expected: 4 distinct agent calls
- Success: Each agent output visible

### Test 2: Parallel Execution
- Multiple agents called simultaneously
- Expected: Parallel processing evidence
- Success: Faster than sequential

### Test 3: Complex Pipeline
- 10+ agents with dependencies
- Expected: Proper sequencing
- Success: All agents execute in order

## Conclusion

The orchestrators have the tools but lack the instructions. Without explicit "Use Task to invoke [agent]" commands, they default to doing work themselves. This is a prompt engineering issue, not a technical limitation.

**Next Step**: Create test specification with explicit agent requirements and test if proper prompting enables true multi-agent execution.

---

*Report Date: 2025-01-18*
*Finding: Orchestrator prompts need explicit Task usage instructions*
*Impact: Currently prevents 52-agent system from functioning as designed*