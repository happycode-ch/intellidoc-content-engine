# Orchestration Agents Specification

## Overview
This specification defines orchestration agents that coordinate the 41-agent content creation pipeline. These agents use Claude Code's native agent creation process to intelligently select and coordinate subsets of the specialized agents based on content type and requirements.

## Architecture Pattern

### Two-Layer System
1. **Orchestration Layer**: Content-type-specific coordinators that select appropriate agent subsets
2. **Consolidation Layer**: Synthesis agents that merge specialized outputs into final deliverables

### Agent Creation Process
Each orchestration agent follows Claude Code's native agent development workflow:
1. Define use case and requirements
2. Let Claude Code generate the agent prompt automatically
3. Test and refine through iterative development
4. Deploy to `.claude/agents/` directory

## Proposed Orchestration Agents

### 1. Social Media Content Orchestrator

**Use Case**: "Create social media content packages from blog posts or standalone social content"

**Requirements**:
- Coordinate 3-5 agents maximum for speed
- Generate platform-specific content (Twitter, LinkedIn, Instagram)
- Optimize for engagement and brevity
- Target execution time: 3-5 minutes
- Output: Multi-platform content package

**Agent Subset**:
- content-atomizer (extract key points)
- twitter-formatter (Twitter/X optimization)
- linkedin-adapter (LinkedIn professional tone)
- instagram-packager (visual-focused content)

**Consolidation**: Platform-specific files + engagement strategy document

---

### 2. Blog Post Orchestrator

**Use Case**: "Create focused, publication-ready blog posts (1500-3000 words)"

**Requirements**:
- Balance quality with efficiency
- Coordinate 6-10 agents for comprehensive coverage
- Ensure SEO optimization and readability
- Target execution time: 8-15 minutes
- Output: Single, polished blog post

**Agent Subset**:
- topic-scout (trending research)
- outline-builder (structure)
- intro-writer (engaging hook)
- body-writer (core content)
- conclusion-writer (strong CTA)
- code-example-writer (if technical)
- grammar-checker (polish)
- readability-scorer (optimization)

**Consolidation**: Single markdown file ready for publication

---

### 3. Long-Form Content Orchestrator

**Use Case**: "Create comprehensive content like whitepapers, guides, or tutorials (3000+ words)"

**Requirements**:
- Coordinate 15-25 agents for maximum depth
- Include research, technical examples, and visual planning
- Maintain academic/professional quality standards
- Target execution time: 20-35 minutes
- Output: Complete content package with supporting materials

**Agent Subset**:
- **Research Phase**: topic-scout, source-gatherer, competitor-analyzer, fact-verifier
- **Planning Phase**: content-planner, spec-writer, audience-profiler
- **Creation Phase**: outline-builder, intro-writer, body-writer, conclusion-writer
- **Technical Phase**: code-example-writer, api-documenter, command-demonstrator
- **Quality Phase**: grammar-checker, style-editor, flow-optimizer, readability-scorer
- **Visual Phase**: chart-designer, infographic-planner

**Consolidation**: Main document + supporting assets + distribution package

---

### 4. Quick Article Orchestrator

**Use Case**: "Generate focused articles quickly for news, updates, or announcements (800-1500 words)"

**Requirements**:
- Minimal agent coordination for maximum speed
- Maintain quality while prioritizing efficiency
- Target execution time: 5-8 minutes
- Output: Publication-ready article

**Agent Subset**:
- outline-builder (quick structure)
- intro-writer (immediate hook)
- body-writer (focused content)
- conclusion-writer (clear ending)
- grammar-checker (basic polish)

**Consolidation**: Single article file with minimal supporting materials

## Content Consolidation Agents

### 1. Content Synthesizer

**Use Case**: "Merge multiple specialized agent outputs into cohesive final documents"

**Requirements**:
- Intelligent content integration (not simple concatenation)
- Maintain narrative flow and logical structure
- Preserve all essential information without duplication
- Support multiple output formats

### 2. Format Adapter

**Use Case**: "Convert consolidated content into platform-specific formats"

**Requirements**:
- Support blog markdown, documentation, PDF-ready, HTML
- Maintain content quality across format conversions
- Optimize for target platform requirements

### 3. Content Packager

**Use Case**: "Create complete content packages with metadata and distribution materials"

**Requirements**:
- Generate SEO metadata and descriptions
- Create social media promotional content
- Package visual assets and specifications
- Provide distribution checklists

## Implementation Guidelines

### Agent Prompt Development Process

1. **Define Use Case**: Clear, specific description of when and why to use the agent
2. **Specify Requirements**: Concrete parameters for success (time, word count, quality level)
3. **Agent Coordination**: Which specialized agents to invoke and in what sequence
4. **Output Format**: Exact structure and format of deliverables
5. **Quality Standards**: Measurable criteria for successful execution

### Claude Code Integration

Each orchestration agent should:
- Use the `Task` tool to invoke specialized agents
- Follow single responsibility principle (orchestration only)
- Include proper error handling and fallback strategies
- Provide clear status updates during execution
- Generate structured output with quality metrics

### Testing Strategy

1. **Unit Testing**: Each orchestration agent with simple content requests
2. **Integration Testing**: Full pipeline execution with complex requirements
3. **Performance Testing**: Measure execution times and resource usage
4. **Quality Testing**: Evaluate final output against professional standards

## Example Prompts for Agent Creation

### Social Media Orchestrator Prompt
```
Create an agent that coordinates social media content creation by:
- Analyzing source content or creating standalone social posts
- Selecting appropriate specialized agents (content-atomizer, platform formatters)
- Managing execution flow for 3-5 minute completion
- Generating platform-optimized content packages
- Focusing on engagement and viral potential
```

### Blog Post Orchestrator Prompt
```
Create an agent that manages blog post creation by:
- Determining optimal agent subset based on topic complexity
- Coordinating research, writing, and quality assurance phases
- Balancing comprehensive coverage with execution efficiency
- Producing publication-ready single documents
- Targeting 1500-3000 word professional blog posts
```

## Success Metrics

### Execution Efficiency
- Social Media: 3-5 minutes
- Blog Posts: 8-15 minutes
- Long-Form: 20-35 minutes
- Quick Articles: 5-8 minutes

### Quality Standards
- Content readability scores above 70
- Grammar and style consistency across all outputs
- Technical accuracy for code examples and data
- SEO optimization for web publication

### User Experience
- Single command generates complete deliverable
- Clear progress indication during execution
- Structured output with organized supporting materials
- Minimal manual assembly required

## Future Enhancements

### Advanced Orchestration
- Dynamic agent selection based on content analysis
- Parallel execution optimization for independent tasks
- Learning algorithms to improve agent selection over time
- Cost optimization through intelligent model selection

### Extended Content Types
- Video script orchestration
- Podcast episode planning
- Email campaign coordination
- Technical documentation generation

---

*This specification provides a framework for creating orchestration agents that make the 41-agent content pipeline practical for real-world content creation workflows.*