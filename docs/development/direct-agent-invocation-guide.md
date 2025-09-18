# Direct Agent Invocation Guide
## The Pattern That Actually Works

### Forget Orchestrators - Use Direct Parallel Invocation

## The Working Pattern

### Single Message, Multiple Agents
```python
# This is what actually triggers multi-agent execution:
# Multiple Task tool invocations in ONE message

Task("source-gatherer", "Research [topic]")
Task("fact-verifier", "Verify these claims: [claims]")
Task("body-writer", "Write 100 words about [topic]")
Task("keyword-researcher", "Find SEO keywords for [topic]")
Task("style-editor", "Polish this text: [text]")

# All execute IN PARALLEL!
```

## Common Agent Combinations

### Blog Post Creation (Parallel + Sequential)
```python
# Phase 1: Research (Parallel)
invoke_parallel([
    ("source-gatherer", "Research [topic] with focus on recent developments"),
    ("keyword-researcher", "Find top 10 SEO keywords for [topic]"),
    ("competitor-analyzer", "Analyze top 3 articles about [topic]"),
    ("fact-verifier", "Verify these key claims: [claims]")
])

# Phase 2: Writing (Parallel) - After research completes
invoke_parallel([
    ("intro-writer", "Hook about [topic] using research: [research]"),
    ("body-writer", "Main content using facts: [verified_facts]"),
    ("conclusion-writer", "CTA based on content: [main_points]")
])

# Phase 3: Assembly (Single)
invoke_single(
    ("content-assembler", "Combine all parts into cohesive blog post")
)
```

### Social Media Package
```python
# All in parallel - no dependencies
invoke_parallel([
    ("twitter-formatter", "Create Twitter thread about [topic]"),
    ("linkedin-adapter", "Professional post about [topic]"),
    ("instagram-packager", "Visual-first post about [topic]"),
    ("content-atomizer", "Extract key points from [content]")
])
```

### Quick Article
```python
# Minimal agent set for speed
invoke_parallel([
    ("source-gatherer", "Quick research on [breaking_news]"),
    ("fact-verifier", "Verify: [key_claims]"),
    ("body-writer", "300-word article on [topic]")
])
```

### Swiss Localization
```python
# Translate to all Swiss languages simultaneously
invoke_parallel([
    ("swiss-german-translator", "Translate to Züritschüüch: [content]"),
    ("swiss-french-translator", "Translate to Suisse Romand: [content]"),
    ("swiss-italian-translator", "Translate to Ticinese: [content]")
])

# Then verify all
invoke_single(
    ("swiss-compliance-checker", "Verify all translations for accuracy")
)
```

## Agent Groups for Common Tasks

### Research Group
```python
RESEARCH_AGENTS = [
    "source-gatherer",      # WebSearch, WebFetch
    "fact-verifier",        # WebSearch, WebFetch
    "keyword-researcher",   # WebSearch
    "competitor-analyzer",  # WebSearch, WebFetch
    "topic-scout"          # WebSearch
]
```

### Writing Group
```python
WRITING_AGENTS = [
    "intro-writer",         # Read, Write
    "body-writer",          # Read, Write
    "conclusion-writer",    # Read, Write
    "quote-integrator",     # Read, Write
    "concept-explainer"     # Read, Write
]
```

### Quality Group
```python
QA_AGENTS = [
    "grammar-checker",      # Read, Write
    "style-editor",         # Read, Write
    "flow-optimizer",       # Read, Write
    "readability-scorer",   # Read, Write
    "link-validator"        # Read, WebFetch
]
```

### Distribution Group
```python
DISTRIBUTION_AGENTS = [
    "twitter-formatter",    # Read, Write
    "linkedin-adapter",     # Read, Write
    "instagram-packager",   # Read, Write
    "content-atomizer",     # Read, Write
    "newsletter-curator"    # Read, Write
]
```

## Execution Patterns

### Pattern 1: Fully Parallel (No Dependencies)
```python
# When all agents can work independently
invoke_parallel([
    "agent-1",  # Does task A
    "agent-2",  # Does task B
    "agent-3",  # Does task C
    "agent-4"   # Does task D
])
# All complete simultaneously
```

### Pattern 2: Sequential Phases
```python
# Phase 1
results_1 = invoke_parallel(["researcher", "analyzer"])

# Phase 2 (uses Phase 1 results)
results_2 = invoke_parallel(["writer-1", "writer-2"], context=results_1)

# Phase 3 (final assembly)
final = invoke_single("assembler", context=results_2)
```

### Pattern 3: Mixed Parallel/Sequential
```python
# Independent research happens while writing outline
invoke_parallel([
    "source-gatherer",     # Parallel
    "outline-builder"      # Parallel
])

# Then write sections based on outline
invoke_sequential([
    "intro-writer",        # Needs outline
    "body-writer",         # Needs intro context
    "conclusion-writer"    # Needs body context
])
```

## Practical Examples

### Example 1: Technical Blog Post
```python
# Research Phase (5 agents parallel)
invoke_parallel([
    ("source-gatherer", "Research Docker best practices 2025"),
    ("keyword-researcher", "Docker, containerization, DevOps keywords"),
    ("competitor-analyzer", "Analyze top Docker tutorials"),
    ("fact-verifier", "Verify Docker performance claims"),
    ("topic-scout", "Trending Docker topics")
])

# Content Creation (3 agents parallel)
invoke_parallel([
    ("body-writer", "1500-word technical guide on Docker"),
    ("code-example-writer", "3 Docker examples with explanations"),
    ("diagram-sketcher", "Container architecture diagram")
])

# Final Assembly
invoke_single(
    ("content-assembler", "Combine all elements into blog post")
)
```

### Example 2: News Article (Speed Priority)
```python
# Just 3 agents for speed
invoke_parallel([
    ("source-gatherer", "Breaking: AI announcement from [company]"),
    ("fact-verifier", "Verify announcement details"),
    ("body-writer", "300-word news article")
])
# Done in under 2 minutes
```

### Example 3: Social Media Campaign
```python
# Create all platform content simultaneously
invoke_parallel([
    ("content-atomizer", "Extract hooks from [article]"),
    ("twitter-formatter", "Thread with 5 tweets"),
    ("linkedin-adapter", "Professional summary"),
    ("instagram-packager", "Carousel with key points"),
    ("thumbnail-creator", "Eye-catching thumbnail")
])
```

## Best Practices

### 1. Identify Dependencies
- Research before writing
- Writing before editing
- All content before assembly

### 2. Maximize Parallelization
- Run independent tasks simultaneously
- Don't sequence unnecessarily
- Use parallel phases

### 3. Choose Right Agents
- Don't use opus agents for simple tasks
- Use haiku for formatting/validation
- Save opus for complex reasoning

### 4. Clear Prompts
- Each agent needs specific instructions
- Pass context explicitly
- Define expected output format

## Why This Works Better Than Orchestrators

| Orchestrators | Direct Invocation |
|--------------|-------------------|
| Single-threaded execution | True parallel execution |
| Can't spawn parallel tasks | Multiple agents simultaneously |
| Pretend to coordinate | Actually coordinate |
| Waste opus tokens | Use appropriate models |
| Add complexity | Simple and transparent |
| 3-5x slower | Optimized performance |

## Migration Path

### From Orchestrator:
```python
/agent blog-post-orchestrator
"Create blog about [topic]"
# Slow, single-agent execution
```

### To Direct Invocation:
```python
# Direct parallel execution
Task("source-gatherer", "Research [topic]")
Task("body-writer", "Write about [topic]")
Task("keyword-researcher", "SEO for [topic]")
# Fast, true multi-agent
```

## Summary

**Stop using orchestrators. Start using direct parallel agent invocation.**

The pattern is simple:
1. Identify independent tasks
2. Invoke agents in parallel
3. Use sequential phases only when needed
4. Let Claude Code handle the parallelization

This is how the 52-agent system was meant to work.

---

*Guide Version: 1.0*
*Last Updated: 2025-01-18*
*Status: This is the pattern that actually works*