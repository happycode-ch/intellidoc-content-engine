# AGENT TASK SPECIFICATION TEMPLATE

## TEMPLATE OVERVIEW
This template provides a structured format for creating task specifications that leverage the IntelliDoc Content Engine's 52-agent system. Use this when requesting content creation, ensuring optimal agent selection and execution.

---

# [CONTENT TITLE/PROJECT NAME]

## PROJECT OVERVIEW
**Content Type**: [blog/tutorial/news/whitepaper/social/series/other]
**Topic**: [Specific subject matter to be covered]
**Target Audience**: [Primary demographic, expertise level, industry]
**Business Goal**: [What this content should achieve]
**Deliverables**: [Specific outputs expected]
**Timeline**: [Urgency level - rapid/standard/comprehensive]
**Word Count Target**: [Range or specific count]

## ORCHESTRATOR SELECTION

### Primary Orchestrator
**Select based on content type**:
- `blog-post-orchestrator` - Technical blogs (1500-3000 words)
- `tutorial-orchestrator` - Step-by-step guides with exercises
- `news-orchestrator` - Rapid articles (<30 min)
- `social-media-orchestrator` - Platform-specific posts
- `whitepaper-orchestrator` - Authoritative long-form (5000-10000 words)
- `series-orchestrator` - Multi-part content series
- `swiss-localization-orchestrator` - Swiss multilingual content
- `content-pipeline-orchestrator` - Let system choose optimal pipeline

### Expected Agent Pipeline
**Based on content type, expect these phases**:
- Phase 1-2: Research & Strategy ([number] agents)
- Phase 3: Content Creation ([number] agents)
- Phase 4-5: Technical/Tutorial ([number] agents if applicable)
- Phase 6: Quality Assurance ([number] agents)
- Phase 7-8: Visual/Distribution ([number] agents if needed)
- Phase 9: Performance Analysis (if metrics required)
- Phase 10: Swiss Localization (if multilingual needed)

## CONTENT REQUIREMENTS

### Core Information to Include
```json
{
  "key_topics": [
    "[Topic 1 with specific angle]",
    "[Topic 2 with specific angle]",
    "[Topic 3 with specific angle]"
  ],
  "unique_angle": "[What makes this different from existing content]",
  "technical_depth": "[surface/moderate/deep]",
  "examples_needed": "[real-world/theoretical/code/visual]",
  "tone": "[professional/conversational/authoritative/educational]"
}
```

### Research & Validation Points
**Facts to verify**:
- [Statistic or claim 1]
- [Statistic or claim 2]
- [Technical specification or standard]

**Sources to reference**:
- [Authoritative source 1]
- [Industry report or study]
- [Documentation or official resource]

### Structure Requirements

#### For Blog Posts
- Hook: [Attention-grabbing opening approach]
- Problem: [Pain point to address]
- Solution: [Core value proposition]
- Examples: [2-3 specific use cases]
- Conclusion: [Clear takeaway or CTA]

#### For Tutorials
- Learning objectives: [What reader will achieve]
- Prerequisites: [Required knowledge/tools]
- Steps: [Number and general flow]
- Exercises: [Practice problems included]
- Solutions: [Provided separately or inline]

#### For Social Media
- Platforms: [twitter/linkedin/instagram]
- Post count: [Number of posts]
- Format: [thread/standalone/carousel]
- Hashtag strategy: [Professional/trending/branded]
- CTA: [Specific action desired]

#### For White Papers
- Executive summary: [Key points to cover]
- Sections: [Major topic divisions]
- Research depth: [Literature review/case studies/data analysis]
- Visual requirements: [Charts/diagrams/infographics]
- Appendices: [Supporting materials]

## SWISS MARKET ADAPTATION (if applicable)

### Localization Requirements
- **Languages needed**: [DE/FR/IT/EN or ALL]
- **Regional focus**: [Specific cantons or nationwide]
- **Compliance standards**: [FINMA/Data protection/Industry-specific]
- **Cultural considerations**: [Business etiquette/tone adjustments]

### Swiss Business Standards
- Conservative confidence over aggressive claims
- Konkret (specific) examples over vague promises
- Quality and precision emphasis
- Sustainability considerations
- Federal structure awareness

## QUALITY & VALIDATION REQUIREMENTS

### Content Standards
**Mandatory checks**:
- [ ] Factual accuracy with source verification
- [ ] Technical accuracy for specifications
- [ ] Authentic examples (or marked as illustrative)
- [ ] Statistics marked as [ACTUAL/PROJECTED/ILLUSTRATIVE]
- [ ] Compliance with regulatory requirements
- [ ] Accessibility standards met
- [ ] SEO optimization without keyword stuffing

### Tone & Style Guidelines
**Writing approach**:
- Professional level: [Entry/Intermediate/Expert/Executive]
- Warmth factor: [Formal/Professional/Approachable/Friendly]
- Technical terminology: [Avoid/Explain/Use freely]
- Example style: [Conceptual/Practical/Code-heavy]

### Specific Constraints
**MUST include**:
- [Mandatory element 1]
- [Mandatory element 2]
- [Specific call-to-action]

**MUST NOT include**:
- [Prohibited topic or approach]
- [Competitive mentions to avoid]
- [Technical details to keep confidential]

## AGENT-SPECIFIC INPUTS

### Phase 1-2: Research & Strategy Inputs
```json
{
  "research_scope": "[Specific areas to investigate]",
  "competitor_analysis": "[Companies/products to analyze]",
  "keyword_targets": "[SEO terms to target]",
  "audience_insights": "[Specific demographics to consider]"
}
```

### Phase 3: Content Creation Inputs
```json
{
  "intro_hook": "[Opening approach or question]",
  "body_structure": "[Linear/Problem-solution/Comparative]",
  "examples": ["[Example 1]", "[Example 2]"],
  "conclusion_cta": "[Specific action to drive]"
}
```

### Phase 7-8: Distribution Inputs
```json
{
  "primary_channel": "[Main distribution platform]",
  "adaptation_needed": ["[Platform 1]", "[Platform 2]"],
  "visual_style": "[Brand aesthetic/requirements]",
  "scheduling": "[Immediate/Scheduled/Series]"
}
```

## EXPECTED OUTPUT FORMAT

### Primary Deliverable
```markdown
# [Final Title]

## Metadata
- Word count: [actual count]
- Reading time: [minutes]
- Target audience: [confirmed audience]
- SEO keywords: [integrated terms]
- Distribution ready: [Yes/No with reason]

## Content
[Full formatted content according to type]

## Supporting Materials
- Social snippets: [If requested]
- Email version: [If requested]
- Visual specifications: [If included]
```

### Assembly Report
```json
{
  "fragments_processed": "[number]",
  "agents_used": ["[agent-1]", "[agent-2]", "..."],
  "quality_score": "[percentage or rating]",
  "issues_found": "[any problems or gaps]",
  "recommendations": "[improvement suggestions]"
}
```

## EXECUTION COMMAND

### Basic Command Structure
```bash
/agent [orchestrator-name]
"[Detailed prompt incorporating all requirements above]"
```

### Example Commands

#### For Blog Post
```bash
/agent blog-post-orchestrator
"Create a technical blog post about [topic] targeting [audience].
Focus on [key angle] with [examples].
Include [specific requirements].
Style: [tone and approach]
Length: [word count target]"
```

#### For Social Media
```bash
/agent social-media-orchestrator
"Create [platform] posts about [topic].
Key points: [list main points]
Include: [specific elements like links, CTAs]
Style: [professional/casual/engaging]
Format: [thread/standalone/series]"
```

#### For Comprehensive Content
```bash
/agent content-pipeline-orchestrator
"[Let the system determine optimal pipeline]
Topic: [subject matter]
Type: [content category]
Requirements: [specific needs]
Quality level: [standard/premium/enterprise]"
```

## VALIDATION CHECKLIST

Before submitting specification:
- [ ] Content type clearly identified
- [ ] Target audience precisely defined
- [ ] Unique angle differentiated
- [ ] Research points specified
- [ ] Structure requirements outlined
- [ ] Quality standards defined
- [ ] Constraints clearly stated
- [ ] Output format confirmed
- [ ] Execution command prepared

## NOTES SECTION

### Additional Context
[Any background information that helps agents understand the task better]

### Reference Materials
[Links to existing content, style guides, or examples]

### Success Metrics
[How you'll measure if the content achieved its goals]

### Post-Production Plans
[What happens after content is created - review process, publication timeline]

---

## USAGE INSTRUCTIONS

1. **Fill out all sections** relevant to your content type
2. **Delete sections** that don't apply (e.g., Swiss localization if not needed)
3. **Be specific** with requirements - vague instructions lead to generic content
4. **Include examples** where possible to guide agent understanding
5. **Specify constraints** clearly to avoid unwanted content
6. **Choose orchestrator** based on content type or use content-pipeline-orchestrator
7. **Validate** all facts and requirements before submission

## QUICK REFERENCE

### Content Type → Agent Count
- **Quick update**: 3-5 agents (5 min)
- **Blog post**: 8-15 agents (15 min)
- **Tutorial**: 20-25 agents (30 min)
- **Social campaign**: 5-8 agents (10 min)
- **White paper**: 25-35 agents (40 min)
- **Full pipeline**: 35-41 agents (60+ min)

### Model Usage by Complexity
- **Haiku** (35%): Formatting, validation, simple tasks
- **Sonnet** (38%): Research, planning, content components
- **Opus** (27%): Orchestration, core content, complex reasoning

### Key Principles
1. **Specialization over consolidation** - Each agent has single responsibility
2. **Minimal tool access** - Agents only get necessary permissions
3. **Quality through precision** - Specific inputs yield better outputs
4. **Orchestrated execution** - Let the system optimize agent selection

---

*Template Version: 1.0 | Based on IntelliDoc Content Engine v2.1 | January 2025*