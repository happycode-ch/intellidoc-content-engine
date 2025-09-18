#!/bin/bash

# Script to add temporal context to all agent files
# Date: September 18, 2025

TEMPORAL_CONTEXT='## Temporal Context
Current date: {{CURRENT_DATE}}
Temporal boundaries:
- Recent: Within last 30 days
- Current: Year 2025
- Upcoming: Next 90 days
- Historical: Before 2025

When referencing time:
- Use "currently" only for 2025 events
- Use "recently" only for events after August 2025
- Explicitly date all statistics and claims'

# List of all agents that need updating (excluding those already done)
AGENTS=(
  "topic-scout"
  "keyword-researcher"
  "competitor-analyzer"
  "ai-prompt-engineer"
  "angle-definer"
  "api-documenter"
  "audience-profiler"
  "chart-designer"
  "code-example-writer"
  "command-demonstrator"
  "concept-explainer"
  "conclusion-writer"
  "content-atomizer"
  "content-planner"
  "diagram-sketcher"
  "error-handler"
  "exercise-designer"
  "flow-optimizer"
  "grammar-checker"
  "improvement-advisor"
  "infographic-planner"
  "instagram-packager"
  "intro-writer"
  "link-validator"
  "linkedin-adapter"
  "metrics-collector"
  "newsletter-curator"
  "outline-builder"
  "quote-integrator"
  "readability-scorer"
  "solution-provider"
  "spec-writer"
  "step-sequencer"
  "style-editor"
  "template-selector"
  "thumbnail-creator"
  "trend-spotter"
  "twitter-formatter"
)

# Orchestrators that need temporal context
ORCHESTRATORS=(
  "tutorial-orchestrator"
  "series-orchestrator"
  "social-media-orchestrator"
  "whitepaper-orchestrator"
)

# Swiss agents
SWISS_AGENTS=(
  "swiss-compliance-checker"
  "swiss-french-translator"
  "swiss-german-translator"
  "swiss-italian-translator"
  "swiss-language-verifier"
  "swiss-localization-orchestrator"
)

# Function to add temporal context after Core Function line
add_temporal_to_agent() {
  local agent_file=$1
  echo "Processing: $agent_file"

  # Check if temporal context already exists
  if grep -q "## Temporal Context" "$agent_file"; then
    echo "  - Temporal context already exists, skipping"
    return
  fi

  # Create a temporary file
  temp_file=$(mktemp)

  # Process the file
  awk -v tc="$TEMPORAL_CONTEXT" '
    /^## Core Function/ {
      print
      getline
      print
      print ""
      print tc
      next
    }
    {print}
  ' "$agent_file" > "$temp_file"

  # Replace original with temporary
  mv "$temp_file" "$agent_file"
  echo "  - Added temporal context"
}

# Function to add temporal context to orchestrators
add_temporal_to_orchestrator() {
  local orch_file=$1
  echo "Processing orchestrator: $orch_file"

  # Check if temporal context already exists
  if grep -q "## Temporal Context" "$orch_file"; then
    echo "  - Temporal context already exists, skipping"
    return
  fi

  # Create a temporary file
  temp_file=$(mktemp)

  # Add both Context Variables and Temporal Context after initial description
  awk -v tc="$TEMPORAL_CONTEXT" '
    BEGIN { added = 0 }
    /^You are/ && !added {
      print
      print ""
      print "## Context Variables"
      print "Today'"'"'s date: {{INVOKE: date +%Y-%m-%d}}"
      print "Pass this date to all agents as {{CURRENT_DATE}}"
      print ""
      print tc
      added = 1
      next
    }
    {print}
  ' "$orch_file" > "$temp_file"

  # Replace original with temporary
  mv "$temp_file" "$orch_file"
  echo "  - Added context variables and temporal context"
}

echo "=== Adding Temporal Context to All Agents ==="
echo

# Process regular agents
echo "Processing regular agents..."
for agent in "${AGENTS[@]}"; do
  agent_path="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/${agent}.md"
  if [ -f "$agent_path" ]; then
    add_temporal_to_agent "$agent_path"
  else
    echo "Warning: Agent file not found - $agent_path"
  fi
done

echo
echo "Processing orchestrators..."
for orch in "${ORCHESTRATORS[@]}"; do
  orch_path="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/${orch}.md"
  if [ -f "$orch_path" ]; then
    add_temporal_to_orchestrator "$orch_path"
  else
    echo "Warning: Orchestrator file not found - $orch_path"
  fi
done

echo
echo "Processing Swiss localization agents..."
for swiss in "${SWISS_AGENTS[@]}"; do
  swiss_path="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/language_agents/${swiss}.md"
  if [ -f "$swiss_path" ]; then
    add_temporal_to_agent "$swiss_path"
  else
    echo "Warning: Swiss agent file not found - $swiss_path"
  fi
done

# Special case for content-assembler
echo
echo "Processing content-assembler..."
assembler_path="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/content-assembler-agent.md"
if [ -f "$assembler_path" ]; then
  add_temporal_to_agent "$assembler_path"
else
  echo "Warning: Content assembler file not found - $assembler_path"
fi

echo
echo "=== Temporal Context Addition Complete ==="
echo "Total agents processed: $(( ${#AGENTS[@]} + ${#ORCHESTRATORS[@]} + ${#SWISS_AGENTS[@]} + 1 ))"