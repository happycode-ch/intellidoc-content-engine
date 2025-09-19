# Tutorial Creation Template

## Overview
Replaces tutorial-orchestrator with working parallel invocation for step-by-step guides with exercises.

## Tutorial Workflow (Comprehensive Guide with Exercises)

### Phase 1: Research & Planning
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Research tutorial content</parameter>
<parameter name="prompt">Research [YOUR TOPIC] best practices, common pitfalls, and implementation patterns. Find authoritative documentation and tutorials.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">audience-profiler</parameter>
<parameter name="description">Define learner profile</parameter>
<parameter name="prompt">Define skill level and prerequisites for [YOUR TOPIC] learners. Include experience level, background knowledge needed.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">competitor-analyzer</parameter>
<parameter name="description">Analyze existing tutorials</parameter>
<parameter name="prompt">Analyze top 3 existing [YOUR TOPIC] tutorials. Identify what they cover well and gaps to fill.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">Tutorial SEO research</parameter>
<parameter name="prompt">Find tutorial-focused keywords for [YOUR TOPIC]. Include "how to", "step by step", "guide" variations.</parameter>
</invoke>
</function_calls>
```

### Phase 2: Tutorial Structure
```
Based on research, invoke sequentially:

1. outline-builder: Create tutorial outline for [YOUR TOPIC] with learning objectives
2. step-sequencer: Order steps progressively from basics to advanced
3. exercise-designer: Create 3-5 practice exercises for [YOUR TOPIC]
```

### Phase 3: Content Creation (Parallel)
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Write tutorial introduction</parameter>
<parameter name="prompt">Write tutorial introduction for [YOUR TOPIC] including prerequisites, what will be learned, and estimated completion time.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Create step-by-step instructions</parameter>
<parameter name="prompt">Create detailed step-by-step instructions for [YOUR TOPIC]. Use numbered steps with clear actions. Include: [paste outline from Phase 2]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">code-example-writer</parameter>
<parameter name="description">Provide code examples</parameter>
<parameter name="prompt">Provide complete working code examples for [YOUR TOPIC]. Include full context, not just snippets. Language: [specify language]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">command-demonstrator</parameter>
<parameter name="description">Show CLI commands</parameter>
<parameter name="prompt">Show exact commands/CLI usage for [YOUR TOPIC]. Include terminal output examples and explanations.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">concept-explainer</parameter>
<parameter name="description">Explain concepts</parameter>
<parameter name="prompt">Explain underlying concepts for [YOUR TOPIC]. Make complex ideas accessible with analogies and diagrams.</parameter>
</invoke>
</function_calls>
```

### Phase 4: Practical Elements (Parallel)
```
Add practical components. Invoke in parallel:

1. error-handler: Document common errors and solutions
2. solution-provider: Create exercise solutions with explanations
3. diagram-sketcher: Design visual aids for complex concepts
```

### Phase 5: Quality & Assembly
```
1. readability-scorer: Ensure clarity for target skill level
2. grammar-checker: Review all sections
3. content-assembler: Combine into complete tutorial
```

## Example: "Docker for Beginners" Tutorial

```
Create a tutorial about "Docker for Beginners". Invoke in parallel:

1. source-gatherer: Research Docker basics, containerization concepts
2. audience-profiler: Define developers new to containerization
3. competitor-analyzer: Analyze top Docker beginner tutorials
4. keyword-researcher: Find "Docker tutorial" related keywords
```

## Tutorial Types

### Hands-On Coding Tutorial
Focus on: code-example-writer, command-demonstrator, error-handler

### Conceptual Tutorial
Focus on: concept-explainer, diagram-sketcher, quote-integrator

### Workshop-Style Tutorial
Focus on: exercise-designer, solution-provider, step-sequencer