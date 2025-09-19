# File: templates/social-media-template.md
# Purpose: Template for multi-platform social media content
# Related: agents/, templates/CLAUDE.md
# AI-hints:
# - XML workflow pattern for parallel execution
# - Orchestrates multiple agents in phases
# - Direct invocation replaces orchestrator agents

# Social Media Content Template

## Overview
Replaces social-media-orchestrator with parallel invocation for multi-platform content.

## Social Media Package Workflow

### Option 1: Create New Social Content
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">twitter-formatter</parameter>
<parameter name="description">Create Twitter thread</parameter>
<parameter name="prompt">Create Twitter/X thread about [YOUR TOPIC]. Maximum 10 tweets. Focus on: [key message/angle]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">linkedin-adapter</parameter>
<parameter name="description">Write LinkedIn post</parameter>
<parameter name="prompt">Write professional LinkedIn post about [YOUR TOPIC]. Target audience: [professionals/industry]. Include relevant hashtags.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">instagram-packager</parameter>
<parameter name="description">Create Instagram carousel</parameter>
<parameter name="prompt">Create Instagram carousel content for [YOUR TOPIC]. 5-8 slides, visual-first approach. Key points: [list main points]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">content-atomizer</parameter>
<parameter name="description">Extract key points</parameter>
<parameter name="prompt">Extract key points, quotes, and statistics from [YOUR TOPIC] for social media use.</parameter>
</invoke>
</function_calls>
```

### Option 2: Repurpose Existing Content
```
Transform [EXISTING ARTICLE/BLOG] into social content. Invoke in parallel:

1. content-atomizer: Extract key points from [paste article]
2. twitter-formatter: Create thread from main points
3. linkedin-adapter: Create professional summary post
4. instagram-packager: Design visual-first carousel
5. quote-integrator: Pull quotable moments
```

### Enhancement (Optional)
```
Enhance social content with:

1. ai-prompt-engineer: Create prompts for AI image generation
2. trend-spotter: Identify trending angles to emphasize
3. keyword-researcher: Find platform-specific hashtags
```

## Platform-Specific Templates

### Twitter/X Thread
```
Create Twitter thread about [TOPIC]:
1. twitter-formatter: Create 5-10 tweet thread
2. content-atomizer: Extract tweetable facts
3. trend-spotter: Identify viral angles
```

### LinkedIn Article
```
Create LinkedIn post about [TOPIC]:
1. linkedin-adapter: Professional long-form post
2. audience-profiler: Define professional audience
3. conclusion-writer: Add strong professional CTA
```

### Instagram Carousel
```
Create Instagram content about [TOPIC]:
1. instagram-packager: Design 5-8 slide carousel
2. ai-prompt-engineer: Create image generation prompts
3. content-atomizer: Extract visual-friendly points
```

## Quick Social Campaign Example

```
Create social campaign for "AI Tools for Small Business". Invoke in parallel:

1. twitter-formatter: "5 AI tools every small business needs in 2025"
2. linkedin-adapter: "How small businesses leverage AI for growth"
3. instagram-packager: "AI transformation stories - visual carousel"
4. content-atomizer: Extract stats and key benefits
```

## Tips
- Run all platforms in parallel for speed
- Use content-atomizer first if repurposing
- Platform-specific hashtags matter
- Visual platforms need ai-prompt-engineer