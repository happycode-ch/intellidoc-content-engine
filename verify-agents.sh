#!/bin/bash

echo "=== Agent Deployment Verification ==="
echo ""
echo "Total agents in .claude/agents/: $(ls -1 .claude/agents/*.md 2>/dev/null | wc -l)"
echo "Symbolic links: $(find .claude/agents -type l -name "*.md" 2>/dev/null | wc -l)"
echo "Regular files: $(find .claude/agents -type f -name "*.md" 2>/dev/null | wc -l)"
echo "Broken links: $(find .claude/agents -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l)"
echo ""
echo "Source organization:"
echo "  Main agents: $(ls -1 cc_content_creation_agents/*.md 2>/dev/null | grep -v CLAUDE.md | wc -l)"
echo "  Orchestrators: $(ls -1 cc_content_creation_agents/orchestration/*.md 2>/dev/null | wc -l)"
echo "  Language agents: $(ls -1 cc_content_creation_agents/language_agents/*.md 2>/dev/null | wc -l)"
echo "  TOTAL: $(($(ls -1 cc_content_creation_agents/*.md 2>/dev/null | grep -v CLAUDE.md | wc -l) + $(ls -1 cc_content_creation_agents/orchestration/*.md 2>/dev/null | wc -l) + $(ls -1 cc_content_creation_agents/language_agents/*.md 2>/dev/null | wc -l)))"
echo ""
echo "Model Distribution in deployment:"
echo "  Opus: $(grep -l "model: opus" .claude/agents/*.md 2>/dev/null | wc -l)"
echo "  Sonnet: $(grep -l "model: sonnet" .claude/agents/*.md 2>/dev/null | wc -l)"
echo "  Haiku: $(grep -l "model: haiku" .claude/agents/*.md 2>/dev/null | wc -l)"
echo ""

# Check for specific critical agents
critical_agents=("blog-post-orchestrator" "content-assembler-agent" "body-writer" "swiss-localization-orchestrator")
echo "Critical agents check:"
for agent in "${critical_agents[@]}"; do
    if [ -L ".claude/agents/$agent.md" ] && [ -e ".claude/agents/$agent.md" ]; then
        echo "  ✓ $agent.md exists and is valid"
    else
        echo "  ✗ $agent.md missing or broken!"
    fi
done
echo ""

# Test symlink functionality
test_file="ai-prompt-engineer.md"
if [ -L ".claude/agents/$test_file" ]; then
    echo "Symlink test for $test_file:"
    source_path=$(readlink .claude/agents/$test_file)
    echo "  Points to: $source_path"
    if [ -e ".claude/agents/$test_file" ]; then
        echo "  Status: ✓ Valid symlink"
    else
        echo "  Status: ✗ Broken symlink"
    fi
fi