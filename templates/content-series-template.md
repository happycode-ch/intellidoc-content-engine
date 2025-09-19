# File: templates/content-series-template.md
# Purpose: Template for multi-part content series
# Related: agents/, templates/CLAUDE.md
# AI-hints:
# - XML workflow pattern for parallel execution
# - Orchestrates multiple agents in phases
# - Direct invocation replaces orchestrator agents

# Content Series Template

## Overview
Replaces series-orchestrator with structured approach for multi-part content series with maintained context.

## Content Series Workflow

### Phase 1: Series Planning
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">content-planner</parameter>
<parameter name="description">Plan series structure</parameter>
<parameter name="prompt">Plan [NUMBER]-part series about [TOPIC]. Define: overarching narrative, individual episode topics, progression/build-up, target length per part.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">audience-profiler</parameter>
<parameter name="description">Define series audience</parameter>
<parameter name="prompt">Define audience for [TOPIC] series. Include: commitment level for multi-part content, preferred format, consumption patterns.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">Series SEO strategy</parameter>
<parameter name="prompt">Research keywords for [NUMBER]-part series on [TOPIC]. Include series-specific terms, episode variations, long-tail opportunities.</parameter>
</invoke>
</function_calls>
```

### Phase 2: Create Part 1
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Series introduction</parameter>
<parameter name="prompt">Write introduction for Part 1 of [TOPIC] series. Hook readers, preview entire series, establish value proposition.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Part 1 content</parameter>
<parameter name="prompt">Write Part 1 content for [TOPIC] series. Focus: [PART 1 TOPIC]. Include hooks for Part 2. Length: [WORD COUNT].</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">conclusion-writer</parameter>
<parameter name="description">Part 1 conclusion</parameter>
<parameter name="prompt">Write conclusion for Part 1. Summarize key points, tease Part 2 content, include CTA to follow series.</parameter>
</invoke>
</function_calls>
```

### Phase 3: Create Subsequent Parts
For each additional part, maintain context by referencing previous parts:

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Part [N] introduction</parameter>
<parameter name="prompt">Write introduction for Part [N] of series. Recap Part [N-1], bridge to current topic: [PART N TOPIC].</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Part [N] content</parameter>
<parameter name="prompt">Write Part [N] content. Topic: [PART N TOPIC]. Build on: [paste key points from previous parts]. Length: [WORD COUNT].</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">conclusion-writer</parameter>
<parameter name="description">Part [N] conclusion</parameter>
<parameter name="prompt">Write conclusion for Part [N]. Connect to series arc, preview next part (or series conclusion if final).</parameter>
</invoke>
</function_calls>
```

### Phase 4: Series Conclusion (Final Part)
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">conclusion-writer</parameter>
<parameter name="description">Series finale</parameter>
<parameter name="prompt">Write series finale for [TOPIC]. Synthesize all [NUMBER] parts, provide actionable takeaways, strong final CTA.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">content-atomizer</parameter>
<parameter name="description">Series summary</parameter>
<parameter name="prompt">Create executive summary of entire [NUMBER]-part series. Extract key points from each part for overview document.</parameter>
</invoke>
</function_calls>
```

### Phase 5: Series Assembly
Use content-assembler for each part:
```
/agent content-assembler
"Assemble Part [N] of [TOPIC] series, maintaining consistent voice with previous parts"
```

## Series Types

### Educational Series
- Part 1: Fundamentals and basics
- Part 2: Intermediate concepts
- Part 3: Advanced techniques
- Part 4: Real-world applications
- Part 5: Future trends

### Problem-Solution Series
- Part 1: Problem identification
- Part 2: Root cause analysis
- Part 3: Solution options
- Part 4: Implementation guide
- Part 5: Results and optimization

### Journey/Transformation Series
- Part 1: Starting point/current state
- Part 2: Planning the change
- Part 3: Implementation challenges
- Part 4: Breakthrough moments
- Part 5: Final transformation

## Example: "AI Implementation" 5-Part Series

```xml
<!-- Part 1: Understanding AI Basics -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Series introduction</parameter>
<parameter name="prompt">Write introduction for Part 1 of "AI Implementation" series. Hook: AI transformation statistics. Preview all 5 parts.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">AI basics content</parameter>
<parameter name="prompt">Write Part 1: "Understanding AI Basics". Cover ML vs AI, common applications, business value. 1500 words.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">conclusion-writer</parameter>
<parameter name="description">Part 1 conclusion</parameter>
<parameter name="prompt">Conclude Part 1 with key AI concepts summary. Tease Part 2: "Assessing Your AI Readiness".</parameter>
</invoke>
</function_calls>
```

## Tips for Series Success

1. **Maintain narrative thread** - Each part should build on previous
2. **Consistent posting schedule** - Set expectations for release
3. **Cross-reference parts** - Link between episodes
4. **Create series landing page** - Central hub for all parts
5. **Track engagement** - Monitor drop-off between parts
6. **Repurpose as guide** - Combine all parts into comprehensive guide later