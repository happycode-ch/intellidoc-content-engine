# Blog Post Creation Template

## Overview
This template replaces the non-functional blog-post-orchestrator with a working parallel agent invocation pattern.

## How to Use
1. Replace `[YOUR TOPIC]` with your actual topic in all sections
2. Copy the XML blocks and paste them directly into Claude Code
3. Execute each phase after the previous completes
4. Use content-assembler at the end to consolidate

## Typical Blog Post Workflow (1500-3000 words)

### Phase 1: Research & Planning (Parallel)
Copy this XML, replace [YOUR TOPIC], and paste into Claude Code:

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Research sources</parameter>
<parameter name="prompt">Research [YOUR TOPIC] focusing on recent developments, expert opinions, and authoritative sources. Find 5-7 high-quality sources.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">SEO research</parameter>
<parameter name="prompt">Find top 10 SEO keywords for [YOUR TOPIC]. Include search volume and competition data if available.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">competitor-analyzer</parameter>
<parameter name="description">Competition analysis</parameter>
<parameter name="prompt">Analyze top 3 competing articles about [YOUR TOPIC]. Identify gaps and opportunities for differentiation.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">audience-profiler</parameter>
<parameter name="description">Define audience</parameter>
<parameter name="prompt">Define target audience for [YOUR TOPIC] blog post. Include demographics, pain points, and interests.</parameter>
</invoke>
</function_calls>
```

### Phase 2: Content Structure (Sequential)
After Phase 1 completes:

```
Based on the research, please invoke:
1. angle-definer: Determine unique angle for [YOUR TOPIC] using research: [paste key findings]
2. outline-builder: Create detailed outline using angle: [paste angle] and keywords: [paste keywords]
```

### Phase 3: Content Creation (Parallel)
After outline is ready, use this XML pattern:

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Write introduction</parameter>
<parameter name="prompt">Write compelling introduction for [YOUR TOPIC] blog post. Hook readers with: [paste key angle/insight from Phase 2]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Create main content</parameter>
<parameter name="prompt">Create main content sections for [YOUR TOPIC] using outline: [paste outline from Phase 2]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">code-example-writer</parameter>
<parameter name="description">Provide code examples</parameter>
<parameter name="prompt">Provide working code examples for [YOUR TOPIC]. Include: [specify languages/frameworks needed]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">conclusion-writer</parameter>
<parameter name="description">Write conclusion</parameter>
<parameter name="prompt">Write conclusion with clear CTA for [YOUR TOPIC]. Main takeaways: [paste key points]</parameter>
</invoke>
</function_calls>
```

### Phase 4: Enhancement (Parallel)
```
Please enhance the content by invoking:

1. concept-explainer: Clarify complex concepts in [paste difficult sections]
2. quote-integrator: Add expert quotes about [YOUR TOPIC]
3. fact-verifier: Verify all claims in [paste key claims]
```

### Phase 5: Quality & Polish (Parallel)
```
For final polish, invoke:

1. grammar-checker: Review entire draft
2. readability-scorer: Assess and improve clarity
3. style-editor: Ensure consistent voice
4. link-validator: Check all links
```

### Phase 6: Final Assembly
```
Use content-assembler to combine all parts into final blog post
```

## Example: Creating "AI Implementation Best Practices" Blog Post

### Actual Phase 1 Command:
```
I need to create a blog post about "AI Implementation Best Practices for Startups". Please invoke these agents in parallel:

1. source-gatherer: Research AI implementation in startups, focusing on 2024-2025 trends
2. keyword-researcher: Find SEO keywords for "AI implementation startups"
3. competitor-analyzer: Analyze top articles about AI implementation for startups
4. audience-profiler: Define CTOs and tech founders as target audience
```

## Agent Combinations for Different Blog Types

### Technical Tutorial Blog
- Phase 1: source-gatherer, keyword-researcher, competitor-analyzer
- Phase 2: outline-builder, step-sequencer
- Phase 3: intro-writer, body-writer, code-example-writer, command-demonstrator
- Phase 4: error-handler, concept-explainer
- Phase 5: grammar-checker, readability-scorer

### News/Trending Topic Blog
- Phase 1: source-gatherer, fact-verifier, topic-scout
- Phase 2: angle-definer (focus on timeliness)
- Phase 3: intro-writer, body-writer, conclusion-writer
- Phase 4: fact-verifier (second pass), quote-integrator
- Phase 5: grammar-checker, style-editor

### Thought Leadership Blog
- Phase 1: source-gatherer, competitor-analyzer, trend-spotter
- Phase 2: angle-definer, outline-builder
- Phase 3: intro-writer, body-writer, conclusion-writer
- Phase 4: concept-explainer, quote-integrator
- Phase 5: readability-scorer, style-editor, improvement-advisor

## Tips for Success

1. **Batch Similar Tasks**: Group agents that don't depend on each other
2. **Use Research First**: Always gather information before writing
3. **Iterate if Needed**: Run quality checks and revise
4. **Save Outputs**: Each agent creates files in temp_agent_outputs/
5. **Final Assembly**: Always use content-assembler at the end

## Common Issues and Solutions

### Issue: Agents not running in parallel
**Solution**: Make sure you explicitly ask Claude Code to "invoke these agents in parallel" or "run simultaneously"

### Issue: Missing context between phases
**Solution**: Copy key outputs from previous phases and include in next phase prompts

### Issue: Content feels disconnected
**Solution**: Use content-assembler to unify voice and flow

## Model Efficiency Note
This approach uses appropriate models for each task:
- Haiku for simple formatting/validation (fast, cheap)
- Sonnet for research and writing components (balanced)
- Opus only for content-assembler (final quality)

Compare to old orchestrator: 100% Opus usage with no actual orchestration!