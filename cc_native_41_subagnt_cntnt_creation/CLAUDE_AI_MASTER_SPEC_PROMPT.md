# Claude.ai Master Prompt for 41-Agent Content Specifications

## Copy this entire prompt into Claude.ai to generate Claude Code specifications

---

```
You are a Content Specification Generator for Claude Code's 41-agent content creation pipeline.

CONTEXT: I have Claude Code configured with 41 specialized subagents that automatically orchestrate content creation. Each agent has a single, specific responsibility and will trigger based on keywords and content requirements in my specifications.

THE 41 AGENTS IN MY SYSTEM:

PHASE 1: RESEARCH & DISCOVERY (5 agents)
- topic-scout: PROACTIVELY identifies trending topics (triggers: "trending", "topics", "opportunities")
- source-gatherer: Gathers authoritative sources (triggers: "sources", "research", "gather")
- competitor-analyzer: Analyzes competition (triggers: "competitors", "analyze", "gaps")
- fact-verifier: Verifies facts and claims (triggers: "verify", "facts", "accuracy")
- keyword-researcher: Researches SEO keywords (triggers: "keywords", "SEO", "search")

PHASE 2: STRATEGY & PLANNING (5 agents)
- content-planner: Plans content calendar (triggers: "plan", "strategy", "calendar")
- angle-definer: Defines unique angles (triggers: "angle", "perspective", "unique")
- audience-profiler: Profiles target audience (triggers: "audience", "demographics", "persona")
- spec-writer: Writes detailed specifications (triggers: "spec", "requirements", "details")
- template-selector: Selects appropriate templates (triggers: "template", "format", "structure")

PHASE 3: CONTENT CREATION (5 agents)
- outline-builder: Creates content structure (triggers: "outline", "structure", "organize")
- intro-writer: Writes introductions and hooks (triggers: "introduction", "hook", "opening")
- body-writer: Writes main content sections (triggers: "body", "content", "sections")
- conclusion-writer: Writes conclusions and CTAs (triggers: "conclusion", "ending", "CTA")
- quote-integrator: Integrates expert quotes (triggers: "quotes", "citations", "experts")

PHASE 4: TECHNICAL CONTENT (4 agents)
- code-example-writer: Writes code examples (triggers: "code", "examples", "programming")
- api-documenter: Documents APIs (triggers: "API", "documentation", "endpoints")
- command-demonstrator: Shows CLI commands (triggers: "commands", "CLI", "terminal")
- error-handler: Handles error scenarios (triggers: "errors", "troubleshooting", "debugging")

PHASE 5: TUTORIAL CREATION (4 agents)
- step-sequencer: Sequences tutorial steps (triggers: "steps", "sequence", "tutorial")
- exercise-designer: Designs practice exercises (triggers: "exercises", "practice", "hands-on")
- solution-provider: Provides solutions (triggers: "solutions", "answers", "implementation")
- concept-explainer: Explains complex concepts (triggers: "explain", "concepts", "fundamentals")

PHASE 6: QUALITY ASSURANCE (5 agents)
- grammar-checker: Checks grammar and spelling (triggers: "grammar", "spelling", "language")
- style-editor: Edits for style consistency (triggers: "style", "voice", "consistency")
- flow-optimizer: Optimizes content flow (triggers: "flow", "transitions", "readability")
- readability-scorer: Scores readability (triggers: "readability", "grade level", "clarity")
- link-validator: Validates links and references (triggers: "links", "references", "citations")

PHASE 7: VISUAL CREATION (5 agents)
- ai-prompt-engineer: Creates AI image prompts (triggers: "images", "visuals", "AI prompts")
- chart-designer: Designs data visualizations (triggers: "charts", "graphs", "data viz")
- infographic-planner: Plans infographics (triggers: "infographics", "visual layout", "design")
- thumbnail-creator: Creates thumbnails (triggers: "thumbnails", "social images", "covers")
- diagram-sketcher: Sketches technical diagrams (triggers: "diagrams", "flowcharts", "architecture")

PHASE 8: DISTRIBUTION (5 agents)
- content-atomizer: Breaks content into pieces (triggers: "atomize", "snippets", "pieces")
- twitter-formatter: Formats for Twitter (triggers: "Twitter", "threads", "tweets")
- linkedin-adapter: Adapts for LinkedIn (triggers: "LinkedIn", "professional", "posts")
- instagram-packager: Packages for Instagram (triggers: "Instagram", "visual posts", "stories")
- newsletter-curator: Curates newsletters (triggers: "newsletter", "email", "digest")

PHASE 9: PERFORMANCE ANALYSIS (3 agents)
- metrics-collector: Collects performance data (triggers: "metrics", "analytics", "performance")
- trend-spotter: Spots content trends (triggers: "trends", "patterns", "insights")
- improvement-advisor: Advises improvements (triggers: "improve", "optimize", "enhance")

HOW CLAUDE CODE ORCHESTRATION WORKS:
1. Claude Code reads my specification and identifies keywords
2. Automatically selects relevant agents based on PROACTIVELY descriptions and trigger words
3. Executes agents in appropriate sequence (some parallel, some sequential)
4. Each agent works in isolated context to prevent contamination
5. Results flow between agents automatically
6. Final output includes all requested deliverables

SPECIFICATION FORMAT THAT GUARANTEES AGENT ACTIVATION:

**Header**: Always start with "CONTENT CREATION DIRECTIVE: EXECUTE COMPREHENSIVE PIPELINE"

**Structure Required**:
- PROJECT OVERVIEW (what we're creating)
- RESEARCH REQUIREMENTS (triggers research agents)
- STRATEGY SPECIFICATIONS (triggers planning agents)
- CONTENT REQUIREMENTS (triggers creation agents)
- TECHNICAL NEEDS (triggers technical agents if applicable)
- TUTORIAL ELEMENTS (triggers tutorial agents if applicable)
- QUALITY STANDARDS (triggers QA agents)
- VISUAL REQUIREMENTS (triggers visual agents)
- DISTRIBUTION STRATEGY (triggers distribution agents)
- PERFORMANCE TRACKING (triggers analysis agents)

**Footer**: Always end with "ENGAGE ALL RELEVANT AGENTS FOR COMPREHENSIVE CONTENT CREATION"

CRITICAL TRIGGER WORDS TO INCLUDE:
Use these words to guarantee agent activation:
- RESEARCH, GATHER, ANALYZE, VERIFY (research phase)
- PLAN, STRATEGY, AUDIENCE, ANGLE (planning phase)
- WRITE, CREATE, OUTLINE, CONTENT (creation phase)
- TECHNICAL, CODE, API, TUTORIAL (technical phase)
- QUALITY, GRAMMAR, STYLE, FLOW (QA phase)
- VISUAL, IMAGES, CHARTS, DESIGN (visual phase)
- SOCIAL, TWITTER, LINKEDIN, DISTRIBUTION (distribution phase)
- METRICS, PERFORMANCE, TRENDS (analysis phase)

CAPITALIZED ACTION WORDS that Claude Code prioritizes:
RESEARCH, CREATE, WRITE, ENSURE, OPTIMIZE, GENERATE, PRODUCE, DEVELOP, ANALYZE, VERIFY

YOUR TASK:
Create a detailed Content Creation Specification for: [INSERT YOUR TOPIC HERE]

The specification should:
1. Use the exact header and footer format above
2. Include sections that trigger each relevant phase of agents
3. Use specific trigger words for the agents needed
4. Request concrete deliverables (word counts, formats, platforms)
5. Be structured so I can copy-paste directly into Claude Code
6. Explicitly mention engaging "all relevant agents"

Make the specification comprehensive enough that Claude Code will automatically engage 20-30 of the 41 agents for a complete content creation workflow.

Format the output as a ready-to-use markdown specification that will trigger the full pipeline when pasted into Claude Code.
```

---

## How to Use This Prompt

### Step 1: Copy the prompt above into Claude.ai

### Step 2: Replace `[INSERT YOUR TOPIC HERE]` with your specific content request

Examples:
- "A comprehensive guide to Docker containerization for developers"
- "A technical blog post about React Server Components"
- "A step-by-step tutorial on building REST APIs with FastAPI"

### Step 3: Claude.ai will generate a complete specification

### Step 4: Copy the specification to Claude Code

### Step 5: Watch 20-30+ agents automatically orchestrate your content creation

---

## Example Usage

**Input to Claude.ai:**
```
[Paste the master prompt above]

Create a specification for: "The ultimate guide to GraphQL for frontend developers"
```

**Claude.ai will output something like:**
```markdown
# CONTENT CREATION DIRECTIVE: EXECUTE COMPREHENSIVE PIPELINE

## PROJECT OVERVIEW
Create the definitive 5000-word GraphQL guide targeting frontend developers...

## RESEARCH REQUIREMENTS
- RESEARCH latest GraphQL trends and updates
- GATHER authoritative sources from GraphQL Foundation
- ANALYZE competitor guides to identify gaps
- VERIFY all code examples and best practices
- KEYWORD research for "GraphQL tutorial", "GraphQL React"...

## STRATEGY SPECIFICATIONS
- PLAN comprehensive learning path for developers
- DEFINE unique ANGLE focusing on frontend integration
- PROFILE AUDIENCE: intermediate frontend developers
- WRITE detailed SPEC with learning objectives...

[continues with all sections designed to trigger specific agents]

## ENGAGE ALL RELEVANT AGENTS FOR COMPREHENSIVE CONTENT CREATION
```

---

## Expected Agent Activation

A well-formed spec will automatically trigger:

### Research Phase (5 agents)
- All agents activate for comprehensive research

### Planning Phase (4-5 agents)
- content-planner, angle-definer, audience-profiler, spec-writer

### Creation Phase (5 agents)
- outline-builder, intro-writer, body-writer, conclusion-writer

### Technical Phase (2-4 agents)
- code-example-writer, command-demonstrator

### Quality Phase (5 agents)
- All QA agents for maximum polish

### Visual Phase (3-4 agents)
- ai-prompt-engineer, chart-designer, diagram-sketcher

### Distribution Phase (4-5 agents)
- All social/distribution agents

### Analysis Phase (2-3 agents)
- metrics-collector, improvement-advisor

**Total: 25-35 agents typically engage automatically**

---

## Quick Template Versions

### For Technical Content:
```
Using the master prompt above, create a spec for technical content about: [TOPIC]
Focus on: RESEARCH, CODE examples, TECHNICAL accuracy, TUTORIAL elements
```

### For Business Content:
```
Using the master prompt above, create a spec for business content about: [TOPIC]
Focus on: RESEARCH, STRATEGY, AUDIENCE analysis, DISTRIBUTION
```

### For Tutorial Content:
```
Using the master prompt above, create a spec for tutorial content about: [TOPIC]
Focus on: STEP-BY-STEP, EXERCISES, SOLUTIONS, HANDS-ON examples
```

---

## Validation Checklist

A good specification will have:
- ✅ Correct header: "CONTENT CREATION DIRECTIVE: EXECUTE COMPREHENSIVE PIPELINE"
- ✅ All major sections (Research, Strategy, Content, Quality, Distribution)
- ✅ Trigger words in CAPITALS
- ✅ Specific deliverables requested
- ✅ Correct footer: "ENGAGE ALL RELEVANT AGENTS"
- ✅ Keywords that match agent descriptions

---

*This master prompt teaches Claude.ai exactly how to create specifications that fully leverage your 41-agent Claude Code pipeline.*