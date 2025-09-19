# File: templates/news-article-template.md
# Purpose: Template for rapid news article creation
# Related: agents/, templates/CLAUDE.md
# AI-hints:
# - XML workflow pattern for parallel execution
# - Orchestrates multiple agents in phases
# - Direct invocation replaces orchestrator agents

# News Article Template

## Overview
Replaces news-orchestrator with rapid parallel invocation for time-sensitive content.

## Rapid News Article Workflow (< 30 minutes)

### Phase 1: Immediate Research (Parallel - 5 min)
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Find breaking news sources</parameter>
<parameter name="prompt">Find latest sources on [NEWS TOPIC] from last 24 hours. Focus on primary sources, official statements, eyewitness accounts.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">fact-verifier</parameter>
<parameter name="description">Verify claims</parameter>
<parameter name="prompt">Verify key claims about [NEWS TOPIC]: [list specific claims to verify]. Check multiple sources for confirmation.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">topic-scout</parameter>
<parameter name="description">Find trending angles</parameter>
<parameter name="prompt">Identify related trending topics and angles for [NEWS TOPIC]. What aspects are gaining traction on social media?</parameter>
</invoke>
</function_calls>
```

### Phase 2: Quick Creation (Parallel - 10 min)
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Write news lead</parameter>
<parameter name="prompt">Write news lead paragraph for [NEWS TOPIC] covering Who, What, When, Where, Why. Maximum 50 words. Hook: [paste key finding from Phase 1]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Create article body</parameter>
<parameter name="prompt">Create 300-500 word article body for [NEWS TOPIC]. Include: [paste verified facts from Phase 1]. Structure: inverted pyramid style.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">quote-integrator</parameter>
<parameter name="description">Add quotes</parameter>
<parameter name="prompt">Add official statements and expert quotes about [NEWS TOPIC]. Sources: [paste sources from Phase 1]. Include attribution.</parameter>
</invoke>
</function_calls>
```

### Phase 3: Polish & Publish (5 min)
```
Final checks:

1. fact-verifier: Second verification pass on all claims
2. grammar-checker: Quick review
3. content-assembler: Combine into final article
```

## News Types

### Breaking News
```
URGENT: [BREAKING NEWS]. Invoke:

1. source-gatherer: Find primary sources only
2. fact-verifier: Verify immediately
3. body-writer: Write 200-300 words
4. content-assembler: Publish-ready format
```

### Analysis/Opinion
```
Analysis of [NEWS EVENT]. Invoke:

1. source-gatherer: Gather multiple perspectives
2. angle-definer: Determine unique analysis angle
3. body-writer: 500-700 word analysis
4. quote-integrator: Expert opinions
5. conclusion-writer: Strong takeaway
```

### Follow-Up Story
```
Update on [PREVIOUS NEWS]. Invoke:

1. source-gatherer: Find new developments
2. fact-verifier: Verify updates
3. body-writer: Focus on what's new
4. content-assembler: Link to original story
```

## Speed Tips
- Skip enhancement phases for breaking news
- Use fact-verifier twice (before and after)
- Keep word count tight (300-500)
- Focus on primary sources only

## Example: Tech Company Announcement

```
Breaking: [COMPANY] announces [PRODUCT]. Invoke in parallel:

1. source-gatherer: Official announcement, press release, CEO statements
2. fact-verifier: Verify specifications, pricing, availability
3. competitor-analyzer: Quick competitive landscape check
4. body-writer: 400-word article with key details
```