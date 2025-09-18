#!/bin/bash

# Add Phase 0: Path Configuration to all orchestrators

echo "=== Adding Path Configuration to Orchestrators ==="

# Blog Post Orchestrator
echo "Updating blog-post-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/blog-post-orchestrator.md"
if [ -f "$orch_file" ]; then
  # Check if already has Phase 0
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    # Add Phase 0 before Phase 1
    sed -i '/### Phase 1: Research/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Content type: `blog`\
3. Generate path: `content/blog/{date}-{slug}/{slug}.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

# News Orchestrator
echo "Updating news-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/news-orchestrator.md"
if [ -f "$orch_file" ]; then
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    sed -i '/### Phase 1: Rapid Research/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Content type: `news`\
3. Generate path: `content/news/{date}-{slug}.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

# Tutorial Orchestrator
echo "Updating tutorial-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/tutorial-orchestrator.md"
if [ -f "$orch_file" ]; then
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    sed -i '/### Phase 1: Research/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Content type: `tutorial`\
3. Generate path: `content/tutorials/{slug}/README.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

# Whitepaper Orchestrator
echo "Updating whitepaper-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/whitepaper-orchestrator.md"
if [ -f "$orch_file" ]; then
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    sed -i '/### Phase 1: Deep Research/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Content type: `whitepaper`\
3. Generate path: `content/whitepapers/{slug}-whitepaper.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

# Series Orchestrator
echo "Updating series-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/series-orchestrator.md"
if [ -f "$orch_file" ]; then
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    sed -i '/### Phase 1: Series Planning/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Content type: `series`\
3. Generate path: `content/series/{series-slug}/part-{number}-{part-slug}.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

# Social Media Orchestrator
echo "Updating social-media-orchestrator..."
orch_file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/social-media-orchestrator.md"
if [ -f "$orch_file" ]; then
  if grep -q "Phase 0:" "$orch_file"; then
    echo "  - Already has Phase 0, skipping"
  else
    sed -i '/### Phase 1: Content Analysis/i\
### Phase 0: Output Configuration\
1. Load routing: `content/content-routing.yaml`\
2. Determine platform: linkedin or twitter\
3. Generate path based on platform:\
   - LinkedIn: `content/social/linkedin/{date}-{slug}-linkedin.md`\
   - Twitter: `content/social/twitter/{date}-{slug}-thread.md`\
4. Ensure path is passed to content-assembler\
' "$orch_file"
    echo "  - Added Phase 0"
  fi
fi

echo "=== Path Configuration Addition Complete ==="