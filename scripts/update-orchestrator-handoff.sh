#!/bin/bash

# Add research handoff rules to all orchestrators
ORCHESTRATORS=(
  "news-orchestrator"
  "tutorial-orchestrator"
  "series-orchestrator"
  "social-media-orchestrator"
  "whitepaper-orchestrator"
)

HANDOFF_RULES='- MUST preserve full research_document structure between agents
- MUST write research_document to `.tmp/research-{timestamp}.json`
- MUST pass research_document unchanged to all writing agents'

for orch in "${ORCHESTRATORS[@]}"; do
  orch_path="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/${orch}.md"

  if [ -f "$orch_path" ]; then
    echo "Updating $orch..."

    # Check if already has the rules
    if grep -q "preserve full research_document" "$orch_path"; then
      echo "  - Already has handoff rules, skipping"
      continue
    fi

    # Add the rules after "Orchestration Rules" section
    temp_file=$(mktemp)

    awk -v rules="$HANDOFF_RULES" '
      /^## Orchestration Rules/ {
        print
        in_rules = 1
        next
      }
      /^##/ && in_rules {
        print rules
        print ""
        in_rules = 0
      }
      {print}
      END {
        if (in_rules) {
          print rules
        }
      }
    ' "$orch_path" > "$temp_file"

    mv "$temp_file" "$orch_path"
    echo "  - Added handoff rules"
  fi
done

echo "Orchestrator handoff update complete"