# Content System Fixes Implementation Specification

**Version:** 1.0
**Date:** September 18, 2025
**Purpose:** Provide exact, actionable steps to fix temporal awareness, research handoff, and content routing issues

## Prerequisites

Before starting implementation:
1. Backup all agent files: `cp -r .claude/agents .claude/agents.backup-$(date +%Y%m%d)`
2. Ensure test content exists: `content/agi-mirage-linkedin-article.md`
3. Have the error report available: `docs/development/content_creation/reports/temporal-accuracy-fact-verification-gaps-analysis.md`

## Phase 1: Temporal Context Implementation

### 1.1 Temporal Context Template

Add this EXACT text block to EVERY agent file after the "## Core Function" line:

```markdown
## Temporal Context
Current date: {{CURRENT_DATE}}
Temporal boundaries:
- Recent: Within last 30 days
- Current: Year 2025
- Upcoming: Next 90 days
- Historical: Before 2025

When referencing time:
- Use "currently" only for 2025 events
- Use "recently" only for events after August 2025
- Explicitly date all statistics and claims
```

### 1.2 Agent Modification List

Apply template to ALL 52 agents. Priority order (high-impact first):

**Critical agents (modify first):**
1. `.claude/agents/fact-verifier.md` - Line 11 (after Core Function)
2. `.claude/agents/source-gatherer.md` - Line 11
3. `.claude/agents/body-writer.md` - Line 11
4. `.claude/agents/news-orchestrator.md` - Line 10
5. `.claude/agents/blog-post-orchestrator.md` - Line 10

**Research agents:**
6. `.claude/agents/topic-scout.md` - Line 11
7. `.claude/agents/keyword-researcher.md` - Line 11
8. `.claude/agents/competitor-analyzer.md` - Line 11

**All remaining agents** - Add after their "## Core Function" line

### 1.3 Orchestrator Date Passing

Modify orchestrators to pass current date. In each orchestrator, add at line 8 (before workflow):

```markdown
## Context Variables
Today's date: {{INVOKE: date +%Y-%m-%d}}
Pass this date to all agents as {{CURRENT_DATE}}
```

### 1.4 Verification Test

```bash
# Test prompt for temporal awareness
echo "Create a news article about AI developments, mentioning both 2024 and 2025 events" | \
  /agent news-orchestrator

# Expected: Article should properly distinguish past (2024) from current (2025)
# Failure indicator: "2025 analysis revealed" (wrong tense)
```

## Phase 2: Research-to-Writing Handoff Standardization

### 2.1 Standardized Research Output Format

Replace output sections in research agents with:

**For `source-gatherer.md`** (replace lines 29-41):
```json
{
  "research_document": {
    "sources": [
      {
        "url": "full URL here",
        "title": "exact article title",
        "author": "author name or organization",
        "publication_date": "YYYY-MM-DD",
        "quotes": [
          {
            "text": "exact quote from source",
            "context": "surrounding context",
            "page_location": "paragraph or section"
          }
        ],
        "statistics": [
          {
            "value": "43%",
            "metric": "AI performance on ARC",
            "date": "when statistic measured",
            "source_location": "where in document"
          }
        ],
        "key_points": ["summary point 1", "summary point 2"]
      }
    ],
    "metadata": {
      "search_date": "{{CURRENT_DATE}}",
      "total_sources": 5
    }
  }
}
```

**For `competitor-analyzer.md`** (similar structure with source preservation)
**For `keyword-researcher.md`** (add source URLs for keyword data)

### 2.2 Writing Agent Input Modifications

**For `body-writer.md`** (replace lines 14-22):
```json
{
  "outline": "section structure",
  "research_document": {
    "sources": [/* full structure from research agents */]
  },
  "tone": "writing style",
  "section_focus": "what to cover",
  "word_target": 1000,
  "citation_style": "inline|footnote|endnote"
}
```

Add after Process section:
```markdown
## Citation Requirements
- Every statistic MUST include [Source: {title}]({url})
- Direct quotes MUST use: "{quote}" - {author}, {publication}
- All claims MUST be traceable to research_document.sources
```

### 2.3 Orchestrator Handoff Preservation

In orchestrators, add at line 47 (in Orchestration Rules):

```markdown
- MUST preserve full research_document structure between agents
- MUST write research_document to `.tmp/research-{timestamp}.json`
- MUST pass research_document unchanged to all writing agents
```

### 2.4 Verification Test

```bash
# Generate test research
echo "Research AI scaling limits with 3 sources" | /agent source-gatherer > test-research.json

# Verify structure
jq '.research_document.sources[0].url' test-research.json  # Should return URL
jq '.research_document.sources[0].quotes' test-research.json  # Should have quotes

# Test handoff
echo "Write article using research from test-research.json" | /agent body-writer

# Success: Output contains source URLs and proper citations
# Failure: Output has claims without sources
```

## Phase 3: Content Routing Configuration

### 3.1 Create Content Routing File

Create `/home/anthonycalek/projects/intellidoc_content_engine/CODE/content/content-routing.yaml`:

```yaml
# Content Routing Configuration v1.0
# This file defines where all content types should be saved

version: "1.0"
base_path: "/home/anthonycalek/projects/intellidoc_content_engine/CODE/content/"

content_types:
  blog:
    folder: "blog/"
    naming_pattern: "{date}-{slug}/{slug}.md"
    example: "2025-09-18-ai-scaling/ai-scaling.md"
    metadata_required: ["title", "date", "author", "tags", "seo_description"]

  tutorial:
    folder: "tutorials/"
    naming_pattern: "{slug}/README.md"
    example: "docker-basics/README.md"
    metadata_required: ["title", "difficulty", "prerequisites", "duration"]

  news:
    folder: "news/"
    naming_pattern: "{date}-{slug}.md"
    example: "2025-09-18-openai-announcement.md"
    metadata_required: ["title", "date", "breaking", "source"]

  whitepaper:
    folder: "whitepapers/"
    naming_pattern: "{slug}-whitepaper.md"
    example: "ai-enterprise-adoption-whitepaper.md"
    metadata_required: ["title", "date", "author", "executive_summary"]

  series:
    folder: "series/"
    naming_pattern: "{series-slug}/part-{number}-{part-slug}.md"
    example: "ai-revolution/part-1-introduction.md"
    metadata_required: ["series_title", "part_number", "total_parts"]

  linkedin_article:
    folder: "social/linkedin/"
    naming_pattern: "{date}-{slug}-linkedin.md"
    example: "2025-09-18-ai-myths-linkedin.md"
    metadata_required: ["title", "date", "hashtags"]

  twitter_thread:
    folder: "social/twitter/"
    naming_pattern: "{date}-{slug}-thread.md"
    example: "2025-09-18-ai-news-thread.md"
    metadata_required: ["title", "date", "thread_length"]

  swiss_content:
    folder: "swiss/{language}/"
    naming_pattern: "{slug}-{language}.md"
    example: "swiss/de/ki-entwicklung-de.md"
    metadata_required: ["title", "date", "language", "canton_focus"]

# Routing rules map orchestrators to content types
routing_rules:
  - orchestrator: "blog-post-orchestrator"
    content_type: "blog"

  - orchestrator: "tutorial-orchestrator"
    content_type: "tutorial"

  - orchestrator: "news-orchestrator"
    content_type: "news"

  - orchestrator: "whitepaper-orchestrator"
    content_type: "whitepaper"

  - orchestrator: "series-orchestrator"
    content_type: "series"

  - orchestrator: "social-media-orchestrator"
    sub_rules:
      - platform: "linkedin"
        content_type: "linkedin_article"
      - platform: "twitter"
        content_type: "twitter_thread"

  - orchestrator: "swiss-localization-orchestrator"
    content_type: "swiss_content"

# Validation rules
validation:
  max_path_length: 255
  forbidden_characters: ["<", ">", ":", "\"", "|", "?", "*"]
  require_date_format: "YYYY-MM-DD"
```

### 3.2 Modify Content-Assembler

In `.claude/agents/content-assembler-agent.md`, modify input section (line 14):

```json
{
  "content_type": "blog/tutorial/news/whitepaper/social",
  "target_path": "/full/path/to/output/file.md",  // NEW REQUIRED FIELD
  "fragments": {/* existing structure */},
  "routing_config": "path/to/content-routing.yaml"  // NEW REQUIRED FIELD
}
```

Add before Output section:
```markdown
## File Writing Process
1. Validate target_path against routing_config rules
2. Create directory if it doesn't exist: `mkdir -p {directory}`
3. Write content to exact target_path
4. Log final path in assembly_report
5. NEVER write to any location not specified in target_path
```

### 3.3 Modify Orchestrators

Add to each orchestrator after Phase 1 (Research):

```markdown
### Phase 0: Path Configuration (First step)
1. Read content-routing.yaml
2. Determine content_type from orchestrator name
3. Generate target_path using naming_pattern
4. Pass target_path to content-assembler
```

Example for `blog-post-orchestrator.md` at line 13:
```markdown
### Phase 0: Output Configuration
1. Load routing: `content/content-routing.yaml`
2. Content type: `blog`
3. Generate path: `content/blog/{date}-{slug}/{slug}.md`
4. Ensure path is passed to content-assembler
```

### 3.4 Verification Test

```bash
# Test blog post routing
echo "Create blog post about Docker basics" | /agent blog-post-orchestrator
ls -la content/blog/  # Should contain new dated folder

# Test news routing
echo "Breaking news about OpenAI" | /agent news-orchestrator
ls -la content/news/  # Should contain new file with date

# Test social routing
echo "Create LinkedIn article about AI" | /agent social-media-orchestrator
ls -la content/social/linkedin/  # Should contain new file

# Failure indicator: Files appear in root or wrong folders
find content -name "*.md" -mmin -5  # Shows recently created files
```

## Phase 4: Verification Suite

### 4.1 Pre-Implementation Baseline

```bash
# Capture current broken state
echo "Write article about recent AI developments including 2024 and 2025" | \
  /agent blog-post-orchestrator > baseline-broken.md

# Document issues:
# - Wrong temporal references
# - No source citations
# - Random file location
```

### 4.2 Post-Implementation Tests

Create `scripts/verify-fixes.sh`:

```bash
#!/bin/bash
# Comprehensive verification of all fixes

echo "=== Content System Fix Verification ==="

# Test 1: Temporal Awareness
echo "TEST 1: Temporal Awareness"
RESULT=$(echo "Write about Claude 3.5 Opus delay and current 2025 developments" | /agent fact-verifier)
if echo "$RESULT" | grep -q "2025.*current"; then
  echo "✅ Temporal awareness working"
else
  echo "❌ Temporal awareness failed"
fi

# Test 2: Source Preservation
echo "TEST 2: Source Preservation"
RESEARCH=$(echo "Research AI scaling limits" | /agent source-gatherer)
if echo "$RESEARCH" | jq -e '.research_document.sources[0].url' > /dev/null; then
  echo "✅ Source URLs preserved"
else
  echo "❌ Source URLs missing"
fi

# Test 3: Content Routing
echo "TEST 3: Content Routing"
echo "Create test blog post" | /agent blog-post-orchestrator
if [ -d "content/blog/$(date +%Y-%m-%d)-"* ]; then
  echo "✅ Content routed correctly"
else
  echo "❌ Content routing failed"
fi

# Test 4: Citation Chain
echo "TEST 4: Citation Chain"
ARTICLE=$(echo "Write article with sources" | /agent blog-post-orchestrator)
if echo "$ARTICLE" | grep -q "\[Source:.*\](http"; then
  echo "✅ Citations preserved"
else
  echo "❌ Citations missing"
fi

echo "=== Verification Complete ==="
```

### 4.3 Acceptance Criteria Checklist

```yaml
acceptance_criteria:
  temporal_awareness:
    - [ ] All agents have temporal context section
    - [ ] Current date passed correctly
    - [ ] No anachronistic references in output
    - [ ] Correct tense for all time references

  source_preservation:
    - [ ] Research outputs include URLs
    - [ ] Quotes preserved with attribution
    - [ ] Statistics include dates and sources
    - [ ] Citations appear in final content

  content_routing:
    - [ ] content-routing.yaml exists and valid
    - [ ] All orchestrators read routing config
    - [ ] Content appears in correct folders
    - [ ] No files in unexpected locations

  system_integrity:
    - [ ] All 52 agents modified
    - [ ] No agents broken by changes
    - [ ] Backward compatibility maintained
    - [ ] Performance not degraded
```

## Phase 5: Rollback Procedure

If issues occur:

```bash
# Quick rollback
cp -r .claude/agents.backup-$(date +%Y%m%d)/* .claude/agents/

# Remove routing file if needed
rm content/content-routing.yaml

# Clean up test content
./scripts/content-management/clean-content.sh
```

## Implementation Order

1. **Day 1**: Phase 1 (Temporal) - 2 hours
   - Modify 52 agents with temporal context
   - Test with news and blog orchestrators

2. **Day 2**: Phase 2 (Research Handoff) - 3 hours
   - Update research agent outputs
   - Update writer agent inputs
   - Test source preservation

3. **Day 3**: Phase 3 (Routing) - 2 hours
   - Create routing configuration
   - Modify orchestrators and assembler
   - Test file placement

4. **Day 4**: Phase 4 (Verification) - 1 hour
   - Run full test suite
   - Document results
   - Fix any issues

## Success Metrics

- Zero temporal errors in generated content
- 100% of sources traceable from research to output
- 100% of content in correct folders
- All verification tests passing

## Notes for Implementing Agent

1. Use exact line numbers provided
2. Make changes in order specified
3. Test after each phase before proceeding
4. Keep backup of all original files
5. Document any deviations from spec

---

*This specification provides concrete, actionable steps. An agent following this can fix all identified issues systematically.*