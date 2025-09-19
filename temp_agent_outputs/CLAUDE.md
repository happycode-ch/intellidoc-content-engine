# Temporary Agent Outputs Directory

## Purpose
Store intermediate outputs from agent workflows before final assembly

## Directory Management
This directory is automatically managed during agent execution:
- Files created here during multi-agent workflows
- Each agent writes its output with descriptive filename
- content-assembler reads from here to create final output
- Should be periodically cleaned to avoid clutter

## File Patterns
- `[agent-name]-output.md` - Standard agent output
- `[topic]-[agent].md` - Topic-specific outputs
- `[timestamp]-[agent].json` - JSON formatted data
- `[agent]-[date].txt` - Text outputs

## Common Commands

### Directory Management
```bash
# View current outputs
ls -la temp_agent_outputs/

# Count intermediate files
ls temp_agent_outputs/*.md 2>/dev/null | wc -l

# Clean old outputs (older than 7 days)
find temp_agent_outputs/ -type f -mtime +7 -delete

# Archive before cleaning
mkdir -p .archive/temp_outputs_$(date +%Y%m%d)
mv temp_agent_outputs/* .archive/temp_outputs_$(date +%Y%m%d)/
```

### Workflow Debugging
```bash
# Check specific agent output
cat temp_agent_outputs/[agent-name]-output.md

# View most recent outputs
ls -lt temp_agent_outputs/ | head -10

# Search for specific content
grep -r "[search term]" temp_agent_outputs/

# Check file sizes
du -sh temp_agent_outputs/*
```

### Cleanup Operations
```bash
# Remove all markdown files
rm temp_agent_outputs/*.md

# Keep only today's files
find temp_agent_outputs/ -type f -mtime +0 -delete

# Archive and clean
tar -czf temp_outputs_$(date +%Y%m%d).tar.gz temp_agent_outputs/
rm temp_agent_outputs/*
```

## Workflow Integration
1. **Agents write** - Each agent outputs to unique file
2. **Parallel execution** - Multiple files created simultaneously
3. **content-assembler reads** - Combines all outputs
4. **Final output** - Assembled content goes to `content/`
5. **Cleanup** - Remove intermediates after success

## Typical Files During Workflow

### Blog Post Creation
- `source-gatherer-output.md` - Research findings
- `keyword-researcher-output.md` - SEO keywords
- `intro-writer-output.md` - Introduction draft
- `body-writer-output.md` - Main content
- `conclusion-writer-output.md` - Closing section

### Tutorial Creation
- `outline-builder-output.md` - Structure
- `step-sequencer-output.md` - Ordered steps
- `code-example-writer-output.md` - Code samples
- `exercise-designer-output.md` - Practice problems

## Best Practices
- Clean after successful content assembly
- Archive before bulk deletion
- Check for incomplete workflows before cleaning
- Monitor directory size regularly

## AI-hints
- Intermediate storage for multi-agent workflows
- Not version controlled (in .gitignore)
- Each agent execution may overwrite previous outputs
- Essential for debugging agent pipeline issues
- Clean regularly to prevent disk usage issues
- Files here are temporary and expendable