#!/bin/bash

# Script to fix temporal hardcoding and remove placeholders
# Date: September 18, 2025
# Purpose: Make temporal context dynamic and future-proof

echo "=== Fixing Temporal Hardcoding and Placeholders ==="
echo "This will:"
echo "1. Remove hardcoded 2025 references"
echo "2. Remove {{CURRENT_DATE}} placeholders"
echo "3. Update orchestrator context variables"
echo "4. Fix source-gatherer JSON format"
echo

# Function to fix regular agent temporal context
fix_agent_temporal() {
  local file=$1
  echo "Processing: $file"

  # Create a temporary file
  temp_file=$(mktemp)

  # Apply all replacements
  sed -e 's/Current date: {{CURRENT_DATE}}/Current date: Use today'"'"'s date/' \
      -e 's/Year 2025/The current year/g' \
      -e 's/Before 2025/Before the current year/g' \
      -e 's/only for 2025 events/only for events in the current year/g' \
      -e 's/only for events after August 2025/only for events within the last 90 days/g' \
      "$file" > "$temp_file"

  # Replace original with temp
  mv "$temp_file" "$file"
  echo "  ✅ Fixed temporal context"
}

# Function to fix orchestrator files
fix_orchestrator() {
  local file=$1
  echo "Processing orchestrator: $file"

  # Create a temporary file
  temp_file=$(mktemp)

  # Apply orchestrator-specific replacements
  sed -e 's/Today'"'"'s date: {{INVOKE: date +%Y-%m-%d}}/Today'"'"'s date: Use today'"'"'s date (determine dynamically)/' \
      -e '/Pass this date to all agents as {{CURRENT_DATE}}/c\Pass the current date context to all agents' \
      -e 's/Current date: {{CURRENT_DATE}}/Current date: Use today'"'"'s date/' \
      -e 's/Year 2025/The current year/g' \
      -e 's/Before 2025/Before the current year/g' \
      -e 's/only for 2025 events/only for events in the current year/g' \
      -e 's/only for events after August 2025/only for events within the last 90 days/g' \
      -e 's/Generate path: `content\/\([^\/]*\)\/{date}-{slug}/Generate path using today'"'"'s date: `content\/\1\/[current-date]-{slug}/g' \
      "$file" > "$temp_file"

  # Replace original with temp
  mv "$temp_file" "$file"
  echo "  ✅ Fixed orchestrator temporal context and variables"
}

# Function to fix source-gatherer specifically
fix_source_gatherer() {
  local file="/home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/source-gatherer.md"

  if [ -f "$file" ]; then
    echo "Processing source-gatherer special case..."

    # Create a temporary file
    temp_file=$(mktemp)

    # Apply all replacements including the JSON format fix
    sed -e 's/Current date: {{CURRENT_DATE}}/Current date: Use today'"'"'s date/' \
        -e 's/Year 2025/The current year/g' \
        -e 's/Before 2025/Before the current year/g' \
        -e 's/only for 2025 events/only for events in the current year/g' \
        -e 's/only for events after August 2025/only for events within the last 90 days/g' \
        -e 's/"search_date": "{{CURRENT_DATE}}"/"search_date": "[today'"'"'s date in YYYY-MM-DD format]"/' \
        "$file" > "$temp_file"

    # Replace original with temp
    mv "$temp_file" "$file"
    echo "  ✅ Fixed source-gatherer with JSON format update"
  else
    echo "  ⚠️  source-gatherer.md not found"
  fi
}

# Process all regular agents
echo
echo "=== Processing Regular Agents ==="
for agent_file in /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/*.md; do
  # Skip CLAUDE.md, README.md, and template files
  basename=$(basename "$agent_file")
  if [[ "$basename" == "CLAUDE.md" ]] || [[ "$basename" == "README.md" ]] || [[ "$basename" == *"template"* ]]; then
    echo "Skipping documentation file: $basename"
    continue
  fi

  # Special handling for source-gatherer
  if [[ "$basename" == "source-gatherer.md" ]]; then
    fix_source_gatherer
  else
    fix_agent_temporal "$agent_file"
  fi
done

# Process orchestrators
echo
echo "=== Processing Orchestrators ==="
for orch_file in /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/orchestration/*.md; do
  basename=$(basename "$orch_file")

  # Check if it's an orchestrator (not content-assembler)
  if [[ "$basename" == *"orchestrator"* ]]; then
    fix_orchestrator "$orch_file"
  else
    # Regular agent processing for content-assembler
    fix_agent_temporal "$orch_file"
  fi
done

# Process Swiss language agents
echo
echo "=== Processing Swiss Language Agents ==="
for swiss_file in /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/language_agents/*.md; do
  basename=$(basename "$swiss_file")

  # Special handling for swiss-localization-orchestrator
  if [[ "$basename" == "swiss-localization-orchestrator.md" ]]; then
    fix_orchestrator "$swiss_file"
  else
    fix_agent_temporal "$swiss_file"
  fi
done

# Verify the changes
echo
echo "=== Verification ==="

# Check for remaining placeholders
echo "Checking for remaining {{CURRENT_DATE}} placeholders..."
remaining_placeholders=$(grep -r "{{CURRENT_DATE}}" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null | grep -v "CLAUDE.md" | grep -v "README.md" | wc -l)
if [ "$remaining_placeholders" -eq 0 ]; then
  echo "  ✅ No {{CURRENT_DATE}} placeholders remaining"
else
  echo "  ⚠️  Found $remaining_placeholders remaining placeholders"
  grep -r "{{CURRENT_DATE}}" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null | grep -v "CLAUDE.md" | grep -v "README.md"
fi

echo "Checking for remaining {{INVOKE}} placeholders..."
remaining_invoke=$(grep -r "{{INVOKE:" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null | wc -l)
if [ "$remaining_invoke" -eq 0 ]; then
  echo "  ✅ No {{INVOKE}} placeholders remaining"
else
  echo "  ⚠️  Found $remaining_invoke remaining INVOKE placeholders"
  grep -r "{{INVOKE:" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null
fi

echo "Checking for remaining hardcoded 2025 references..."
remaining_2025=$(grep -r "Year 2025\|Before 2025\|for 2025 events\|after August 2025" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null | grep -v "CLAUDE.md" | grep -v "README.md" | wc -l)
if [ "$remaining_2025" -eq 0 ]; then
  echo "  ✅ No hardcoded 2025 references remaining"
else
  echo "  ⚠️  Found $remaining_2025 hardcoded 2025 references"
  grep -r "Year 2025\|Before 2025\|for 2025 events\|after August 2025" /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents --include="*.md" 2>/dev/null | grep -v "CLAUDE.md" | grep -v "README.md"
fi

# Check that source-gatherer was properly updated
echo "Checking source-gatherer JSON format..."
if grep -q '"search_date": "\[today'"'"'s date in YYYY-MM-DD format\]"' /home/anthonycalek/projects/intellidoc_content_engine/CODE/agents/source-gatherer.md 2>/dev/null; then
  echo "  ✅ source-gatherer JSON format properly updated"
else
  echo "  ⚠️  source-gatherer JSON format may need manual review"
fi

echo
echo "=== Temporal Hardcoding Fix Complete ==="
echo "All agents are now:"
echo "- Using dynamic date references (no placeholders)"
echo "- Referencing 'the current year' instead of hardcoded 2025"
echo "- Future-proof for any year"
echo
echo "The system will now work correctly in 2026 and beyond!"