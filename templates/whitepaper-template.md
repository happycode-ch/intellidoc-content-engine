# File: templates/whitepaper-template.md
# Purpose: Template for long-form authoritative content
# Related: agents/, templates/CLAUDE.md
# AI-hints:
# - XML workflow pattern for parallel execution
# - Orchestrates multiple agents in phases
# - Direct invocation replaces orchestrator agents

# Whitepaper Creation Template

## Overview
Replaces whitepaper-orchestrator with comprehensive parallel invocation for authoritative long-form content (5000-10000 words).

## Whitepaper Workflow

### Phase 1: Deep Research (Parallel - 2 hours)
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Deep research</parameter>
<parameter name="prompt">Find 15-20 authoritative sources on [TOPIC]. Include academic papers, industry reports, case studies, expert analyses from last 2 years.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">competitor-analyzer</parameter>
<parameter name="description">Analyze existing whitepapers</parameter>
<parameter name="prompt">Analyze existing whitepapers about [TOPIC]. Focus on structure, depth, unique insights, and gaps in coverage.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">fact-verifier</parameter>
<parameter name="description">Verify statistics</parameter>
<parameter name="prompt">Verify all statistics and claims about [TOPIC]. Focus on ROI data, implementation metrics, industry benchmarks.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">Technical terminology research</parameter>
<parameter name="prompt">Research technical terminology and industry jargon for [TOPIC]. Include acronyms, technical concepts, regulatory terms.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">audience-profiler</parameter>
<parameter name="description">Define decision makers</parameter>
<parameter name="prompt">Define C-suite and technical decision makers interested in [TOPIC]. Include pain points, decision criteria, objections.</parameter>
</invoke>
</function_calls>
```

### Phase 2: Structure & Strategy
```
Plan whitepaper structure:

1. angle-definer: Determine authoritative perspective
2. outline-builder: Create detailed 10-15 section outline
3. content-planner: Plan graphics, charts, data visualizations
```

### Phase 3: Content Creation (Parallel Batches)

#### Batch 1: Introduction & Problem Statement
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">intro-writer</parameter>
<parameter name="description">Executive summary</parameter>
<parameter name="prompt">Write executive summary and introduction for [TOPIC] whitepaper. 500 words covering key findings, value proposition, methodology overview.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Problem statement</parameter>
<parameter name="prompt">Write problem statement and industry context for [TOPIC]. 1000 words covering current challenges, market forces, urgency.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">quote-integrator</parameter>
<parameter name="description">Industry quotes</parameter>
<parameter name="prompt">Add industry leader quotes about [TOPIC]. Focus on C-suite perspectives, analyst insights, expert predictions.</parameter>
</invoke>
</function_calls>
```

#### Batch 2: Core Content
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Main solution sections</parameter>
<parameter name="prompt">Write main solution/methodology sections for [TOPIC]. 2000-3000 words covering approach, implementation, benefits. Structure: [paste outline]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">concept-explainer</parameter>
<parameter name="description">Technical deep dives</parameter>
<parameter name="prompt">Explain technical concepts for [TOPIC] in depth. Include frameworks, architectures, methodologies. Target: technical decision makers.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">code-example-writer</parameter>
<parameter name="description">Technical implementations</parameter>
<parameter name="prompt">Provide technical implementation examples for [TOPIC]. Include architecture diagrams, code samples, configuration examples.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">diagram-sketcher</parameter>
<parameter name="description">Create diagrams</parameter>
<parameter name="prompt">Design technical diagrams and flowcharts for [TOPIC]. Include system architecture, process flows, decision trees.</parameter>
</invoke>
</function_calls>
```

#### Batch 3: Evidence & Support
```
1. source-gatherer: Case studies and examples
2. fact-verifier: Verify all data points
3. chart-designer: Data visualization specs
4. quote-integrator: Expert testimonials
```

### Phase 4: Conclusion & Polish
```
1. conclusion-writer: Recommendations and next steps
2. improvement-advisor: Strategic improvements
3. readability-scorer: Ensure executive readability
4. grammar-checker: Professional polish
5. content-assembler: Compile final whitepaper
```

## Whitepaper Types

### Technical Whitepaper
Focus on: code-example-writer, diagram-sketcher, concept-explainer, command-demonstrator

### Business Strategy Whitepaper
Focus on: quote-integrator, chart-designer, competitor-analyzer, trend-spotter

### Research/Academic Whitepaper
Focus on: source-gatherer, fact-verifier, methodology documentation, peer review

## Example: "Enterprise AI Implementation Strategy"

```
Phase 1 - Research (invoke in parallel):
1. source-gatherer: Research enterprise AI adoption 2023-2025
2. competitor-analyzer: Analyze McKinsey, Gartner, Forrester reports
3. fact-verifier: Verify ROI statistics and case studies
4. audience-profiler: Target CIOs and Digital Transformation leaders

Phase 2 - Structure:
1. outline-builder: 12 sections from problem to implementation roadmap
2. content-planner: Plan 5 charts, 3 diagrams, 2 case studies

Phase 3 - Write (multiple parallel batches):
[Continue with batched content creation...]
```

## Quality Standards
- Minimum 20 authoritative sources
- Executive summary under 500 words
- Each section 500-1000 words
- Professional graphics and charts
- Peer review before publication