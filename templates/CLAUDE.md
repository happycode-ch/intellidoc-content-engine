# Workflow Templates - XML Orchestration Patterns

## Purpose
Replace orchestrator agents with direct XML patterns that enable true parallel agent execution

## Directory Structure
```
templates/
├── README.md                    # XML pattern documentation
├── blog-post-template.md        # Blog creation workflow
├── tutorial-template.md         # Step-by-step guides
├── social-media-template.md     # Multi-platform social
├── news-article-template.md     # Rapid news creation
├── whitepaper-template.md       # Long-form research
├── swiss-localization-template.md # Swiss translations
└── content-series-template.md   # Multi-part series
```

## How Templates Work
1. **Templates contain XML orchestration specs** - Not orchestrator agents
2. **Copy XML pattern from template**
3. **Replace placeholders** ([YOUR TOPIC], etc.)
4. **Paste into Claude Code**
5. **Agents execute in parallel**
6. **Use content-assembler to finalize**

## Common Commands

### Template Usage
```bash
# View available templates
ls -la *.md

# Copy blog post XML pattern
cat blog-post-template.md

# Check template structure
head -20 [template-name].md

# Find specific workflow phase
grep -n "Phase" *.md
```

### Workflow Execution
```bash
# Step 1: Choose template
cat [template-name].md

# Step 2: Copy XML block for phase
# (Copy the <function_calls>...</function_calls> block)

# Step 3: Replace placeholders in your editor
# [YOUR TOPIC] -> "Your actual topic"
# [paste X] -> paste results from previous phase

# Step 4: Paste into Claude Code
# XML triggers parallel execution

# Step 5: Final assembly
/agent content-assembler
"Combine all outputs into final deliverable"
```

## XML Pattern Structure
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">agent-name</parameter>
<parameter name="description">Brief task</parameter>
<parameter name="prompt">Detailed instructions</parameter>
</invoke>
<!-- Multiple agents in same block = parallel -->
</function_calls>
```

## Template Categories

### Content Creation
- `blog-post-template.md` - 1500-3000 word blogs
- `tutorial-template.md` - Hands-on guides with exercises
- `whitepaper-template.md` - 5000-10000 word authority pieces
- `content-series-template.md` - Multi-part content series

### Quick Content
- `news-article-template.md` - < 30 min rapid news
- `social-media-template.md` - Multi-platform in 2-3 min

### Localization
- `swiss-localization-template.md` - 3-language Swiss content

## Orchestration via Templates
**Key Insight**: Orchestration happens through XML patterns in templates, NOT through orchestrator agents. The templates ARE the orchestration layer.

## AI-hints
- Templates contain exact XML patterns for parallel execution
- XML must have single <function_calls> wrapper for parallelization
- Each template defines multi-phase workflows
- Templates replace non-functional orchestrator agents
- Direct invocation from Claude Code's top level required