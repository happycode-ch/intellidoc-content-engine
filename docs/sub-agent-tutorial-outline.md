# docs/sub-agent-tutorial-outline.md
**Purpose**: Create comprehensive tutorial outline for sub-agent development
**Related**: agents/CLAUDE.md, templates/CLAUDE.md, .claude/CLAUDE.md
**AI-hints**:
- Educational content structure
- Progression from basic to advanced concepts
- Hands-on learning approach
- Covers 46-agent system architecture

# Sub-Agent Development Tutorial: Complete Learning Outline

## Learning Objectives

### Primary Learning Outcomes
By the end of this tutorial, learners will be able to:
1. Design and implement specialized sub-agents using YAML configuration
2. Select appropriate models (haiku/sonnet/opus) based on task complexity
3. Configure tool inheritance patterns for secure, minimal access
4. Write effective system prompts that enforce single responsibility
5. Deploy agents to the Claude Code environment successfully
6. Test and validate agent behavior across different scenarios
7. Integrate agents into XML workflow templates for parallel execution
8. Identify and avoid common anti-patterns in agent design

### Secondary Objectives
- Understand the 46-agent ecosystem architecture
- Master template-based orchestration patterns
- Apply model optimization strategies for cost and performance
- Implement Swiss localization patterns for multilingual content

## Tutorial Structure Overview

**Duration**: 4-6 hours (8 modules)
**Format**: Progressive hands-on exercises with real examples
**Prerequisites**: Basic understanding of YAML, command line operations

---

## Module 1: Foundation Concepts (45 minutes)

### Learning Objectives
- Understand the single responsibility principle in agent design
- Grasp the 46-agent ecosystem structure
- Recognize the role of specialization vs consolidation

### 1.1 Introduction to the Agent Ecosystem (15 min)
**Content Coverage**:
- Overview of 46-agent system (40 core + 6 Swiss localization)
- 10-phase pipeline architecture
- Template-based orchestration philosophy
- Performance metrics: 70% cost reduction, 3-5x speed improvement

**Key Concepts**:
- Specialization over consolidation principle
- Context isolation benefits
- Parallel execution capabilities

**Learning Activity**:
- Analyze existing agent directory structure
- Map agents to their respective phases
- Identify common patterns across agent types

### 1.2 Agent Responsibilities and Boundaries (15 min)
**Content Coverage**:
- Single responsibility principle enforcement
- Clear input/output contracts
- Context isolation strategies

**Examples**:
- Good: `source-gatherer` - focused on research collection
- Bad: `content-creator` - too broad, multiple responsibilities

**Learning Activity**:
- Review 5 well-designed agents
- Identify responsibility boundaries
- Spot potential overlap issues

### 1.3 Model Distribution Strategy (15 min)
**Content Coverage**:
- Current optimized distribution: 18 Haiku, 20 Sonnet, 6 Opus
- Performance vs cost trade-offs
- Task complexity alignment

**Before/After Comparison**:
- Previous: 80% Opus (inefficient)
- Current: 13% Opus, 38% Sonnet, 35% Haiku (optimized)

**Learning Activity**:
- Categorize 10 random agents by complexity
- Predict appropriate model assignments
- Compare with actual optimized assignments

---

## Module 2: YAML Configuration Mastery (60 minutes)

### Learning Objectives
- Master all required YAML fields and their purposes
- Understand configuration validation rules
- Apply naming conventions consistently

### 2.1 YAML Structure Deep Dive (20 min)
**Required Fields**:
```yaml
---
name: agent-name                    # Must match filename
description: Single responsibility   # Include trigger keywords
model: haiku|sonnet|opus           # Based on complexity
tools: [minimal list]              # Absolute minimum required
---
```

**Field Rules**:
- `name`: Kebab-case, descriptive, matches filename without .md
- `description`: Concise, includes trigger keywords for discovery
- `model`: Strategic selection based on task complexity
- `tools`: Minimal necessary access (security principle)

**Learning Activity**:
- Create 3 different agent configurations
- Validate YAML syntax and field requirements
- Practice naming convention adherence

### 2.2 Description Field Optimization (15 min)
**Best Practices**:
- Include relevant trigger keywords
- Describe single clear responsibility
- Use action-oriented language

**Examples**:
```yaml
# Good
description: Collect authoritative sources and references for content topics

# Poor
description: Helps with research stuff
```

**Learning Activity**:
- Rewrite 5 poor descriptions
- Test keyword discoverability
- Validate against trigger word patterns

### 2.3 Configuration Validation (25 min)
**Validation Checklist**:
- YAML syntax correctness
- Required field presence
- Model-task complexity alignment
- Tool necessity justification

**Common Errors**:
- Missing fields
- Model over-provisioning
- Tool over-access
- Name/filename mismatch

**Hands-on Exercise**:
- Validate 10 agent configurations
- Fix identified issues
- Create validation script for batch checking

---

## Module 3: Tool Configuration and Security (60 minutes)

### Learning Objectives
- Implement minimal tool access principles
- Configure inheritance patterns correctly
- Apply security constraints appropriately

### 3.1 Tool Access Philosophy (20 min)
**Principle**: Each agent gets absolute minimum tools required for its function

**Tool Categories**:
- `Read, Write`: Content manipulation (high trust)
- `WebSearch, WebFetch`: Research agents (controlled)
- `Bash`: Code testing only (restricted)
- `Read` only: Analysis/review (safe)

**Security Implications**:
- Reduced attack surface
- Clear audit trails
- Failure isolation

### 3.2 Tool Assignment by Agent Type (25 min)
**Research Agents**: `WebSearch, WebFetch, Read`
```yaml
tools: WebSearch, WebFetch, Read
```

**Content Creators**: `Read, Write`
```yaml
tools: Read, Write
```

**Validators**: `Read` only
```yaml
tools: Read
```

**Code Testers**: `Read, Write, Bash` (special case)
```yaml
tools: Read, Write, Bash
```

**Learning Activity**:
- Audit existing agent tool assignments
- Identify over-provisioned agents
- Recommend tool reductions

### 3.3 Inheritance Patterns (15 min)
**Pattern Types**:
- Direct assignment (most common)
- Template inheritance (future enhancement)
- Role-based groups (organization)

**Current Implementation**:
All agents use direct assignment for clarity and security

**Exercise**:
- Design tool inheritance schema
- Map tools to agent roles
- Validate security boundaries

---

## Module 4: Model Selection Strategies (60 minutes)

### Learning Objectives
- Select appropriate models based on task complexity
- Understand performance/cost implications
- Apply optimization strategies effectively

### 4.1 Model Characteristics (20 min)
**Haiku (18 agents)**:
- **Strengths**: High speed, low cost, pattern recognition
- **Use Cases**: Formatting, validation, simple transformations
- **Limitations**: Complex reasoning, nuanced content

**Sonnet (20 agents)**:
- **Strengths**: Balanced performance, good reasoning, versatile
- **Use Cases**: Research, analysis, strategic planning, content components
- **Trade-offs**: Moderate cost, good quality

**Opus (6 agents)**:
- **Strengths**: Superior reasoning, content synthesis, context management
- **Use Cases**: Complex orchestration, core content creation, localization
- **Considerations**: High cost, slower execution

### 4.2 Task Complexity Assessment (25 min)
**Complexity Factors**:
- Input variability
- Reasoning depth required
- Context maintenance needs
- Output quality standards

**Assessment Framework**:
```
Simple (Haiku):
- Rule-based operations
- Format transformations
- Pattern matching
- Validation checks

Moderate (Sonnet):
- Research and analysis
- Content planning
- Quality assessment
- Strategic decisions

Complex (Opus):
- Multi-step orchestration
- Creative content synthesis
- Cross-context continuity
- Cultural adaptation
```

**Practical Exercise**:
- Assess 15 different tasks
- Assign appropriate models
- Justify selections with complexity factors

### 4.3 Cost-Performance Optimization (15 min)
**Optimization Results from September 2024**:
- Speed: 3-5x faster for simple tasks
- Cost: ~70% reduction in API costs
- Quality: Maintained for complex tasks
- Throughput: Higher concurrent execution

**Best Practices**:
- Start with simplest model that meets requirements
- Upgrade only when complexity demands it
- Monitor performance metrics
- Batch similar complexity tasks

**Learning Activity**:
- Calculate cost impact of model changes
- Design performance monitoring approach
- Create model selection decision tree

---

## Module 5: System Prompt Design Excellence (75 minutes)

### Learning Objectives
- Write clear, constraining system prompts
- Implement effective input/output specifications
- Design process flows that prevent scope creep

### 5.1 Prompt Architecture (25 min)
**Standard Structure**:
```markdown
You are a [role] [doing what].

## Core Function
[Single, clear responsibility statement]

## Input
```json
{
  "field": "expected input structure"
}
```

## Process
1. [Step 1]
2. [Step 2]
...

## Output
```json
{
  "result": "output structure"
}
```

## Constraints
- MUST [requirement]
- NEVER [restriction]
```

**Design Principles**:
- Single responsibility enforcement
- Clear boundaries and constraints
- Structured input/output contracts
- Step-by-step process definition

### 5.2 Role Definition Best Practices (20 min)
**Effective Role Statements**:
```markdown
# Good
You are a research specialist gathering authoritative sources.

# Better
You are a content research specialist focused exclusively on gathering 5-7 authoritative sources from recognized publications.
```

**Role Characteristics**:
- Specific expertise area
- Clear scope boundaries
- Professional context
- Actionable focus

**Anti-patterns**:
- Vague generalist roles
- Multiple responsibilities
- Unclear boundaries
- Generic descriptions

### 5.3 Input/Output Contract Design (15 min)
**JSON Schema Benefits**:
- Clear data expectations
- Validation capabilities
- Integration readiness
- Documentation value

**Design Patterns**:
```json
// Simple input
{
  "topic": "content subject",
  "requirements": ["specific", "needs"]
}

// Complex input
{
  "content": "source material",
  "target_audience": "audience profile",
  "constraints": {
    "word_count": 1500,
    "tone": "professional"
  }
}
```

### 5.4 Constraint Engineering (15 min)
**MUST Constraints** (Required behaviors):
- MUST provide exactly 5-7 sources
- MUST include publication dates
- MUST verify source authority

**NEVER Constraints** (Prohibited behaviors):
- NEVER exceed assigned word count
- NEVER include promotional content
- NEVER assume user context

**Constraint Categories**:
- Quality standards
- Scope limitations
- Format requirements
- Behavioral boundaries

**Exercise**:
- Write complete system prompt for new agent
- Define comprehensive constraint set
- Validate prompt clarity and enforceability

---

## Module 6: Deployment and Environment Integration (60 minutes)

### Learning Objectives
- Deploy agents to .claude/agents/ directory correctly
- Understand symlink vs copy strategies
- Validate deployment success
- Troubleshoot common deployment issues

### 6.1 Deployment Process (20 min)
**Standard Deployment Steps**:
```bash
# 1. Validate agent configuration
grep -E "^name:|^description:|^model:|^tools:" agents/new-agent.md

# 2. Check file naming consistency
basename agents/new-agent.md .md  # Should match 'name' field

# 3. Deploy to Claude environment
cp agents/new-agent.md .claude/agents/

# 4. Verify deployment
ls -la .claude/agents/new-agent.md

# 5. Test basic functionality
/agent new-agent
"Simple test prompt"
```

**File Structure Requirements**:
- Source: `agents/[agent-name].md`
- Deployed: `.claude/agents/[agent-name].md`
- Consistent naming between source and deployed versions

### 6.2 Symlink vs Copy Strategy (15 min)
**Current Approach**: Direct copies for stability
**Benefits**:
- Version control clarity
- Deployment isolation
- Rollback capability

**Alternative**: Symlinks for development
```bash
# Development workflow
ln -s ../../agents/new-agent.md .claude/agents/new-agent.md
```

**Trade-offs**:
- Symlinks: Faster iteration, version sync risk
- Copies: Stable deployment, manual sync required

### 6.3 Deployment Validation (25 min)
**Validation Checklist**:
1. File presence verification
2. YAML header validation
3. Agent discovery test
4. Basic functionality test
5. Tool access verification

**Validation Script Example**:
```bash
#!/bin/bash
# validate-deployment.sh

AGENT_NAME=$1
SOURCE_FILE="agents/${AGENT_NAME}.md"
DEPLOYED_FILE=".claude/agents/${AGENT_NAME}.md"

# Check source exists
[ -f "$SOURCE_FILE" ] || { echo "Source not found"; exit 1; }

# Check deployment exists
[ -f "$DEPLOYED_FILE" ] || { echo "Deployment not found"; exit 1; }

# Validate YAML header
head -10 "$DEPLOYED_FILE" | grep -q "^name: $AGENT_NAME" || { echo "Name mismatch"; exit 1; }

echo "Deployment valid: $AGENT_NAME"
```

**Hands-on Exercise**:
- Deploy 3 test agents
- Run validation checks
- Fix identified issues

---

## Module 7: Testing and Validation Approaches (75 minutes)

### Learning Objectives
- Design comprehensive test strategies
- Validate agent behavior across scenarios
- Implement continuous testing practices
- Debug common agent issues

### 7.1 Testing Strategy Framework (25 min)
**Test Categories**:

**Unit Testing** (Individual agent):
- Basic functionality
- Input validation
- Output format compliance
- Constraint adherence

**Integration Testing** (Agent in workflow):
- Template compatibility
- Phase coordination
- Context passing
- Error handling

**Performance Testing**:
- Response time measurement
- Resource utilization
- Concurrent execution
- Cost tracking

### 7.2 Unit Testing Methodology (25 min)
**Basic Functionality Tests**:
```bash
# Test 1: Simple valid input
/agent source-gatherer
"Research Python web frameworks focusing on recent developments"

# Expected: 5-7 authoritative sources with metadata

# Test 2: Edge case - broad topic
/agent source-gatherer
"Research technology"

# Expected: Request for topic refinement

# Test 3: Tool access validation
/agent source-gatherer
"Search for information and save results to file"

# Expected: Search completed, but no file creation (lacks Write tool)
```

**Output Validation**:
- JSON structure compliance
- Required field presence
- Data type correctness
- Constraint satisfaction

### 7.3 Integration Testing with Templates (25 min)
**Template Integration Test**:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Test research</parameter>
<parameter name="prompt">Research Docker containerization for blog post</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">Test SEO</parameter>
<parameter name="prompt">Find SEO keywords for Docker containerization</parameter>
</invoke>
</function_calls>
```

**Integration Validation Points**:
- Parallel execution success
- Output compatibility
- Context preservation
- Error propagation

**Exercise**:
- Design comprehensive test suite for chosen agent
- Execute tests and document results
- Identify and fix any issues

---

## Module 8: XML Workflow Integration and Advanced Patterns (75 minutes)

### Learning Objectives
- Integrate agents into XML workflow templates
- Master parallel execution patterns
- Design multi-phase workflows
- Implement error handling and fallbacks

### 8.1 XML Template Structure (25 min)
**Basic XML Pattern**:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">agent-name</parameter>
<parameter name="description">Brief task description</parameter>
<parameter name="prompt">Detailed instructions with context</parameter>
</invoke>
</function_calls>
```

**Parallel Execution**:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">agent-1</parameter>
<parameter name="description">Task 1</parameter>
<parameter name="prompt">Instructions for agent 1</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">agent-2</parameter>
<parameter name="description">Task 2</parameter>
<parameter name="prompt">Instructions for agent 2</parameter>
</invoke>
<!-- Both agents execute simultaneously -->
</function_calls>
```

**Sequential Phases**:
```xml
<!-- Phase 1 -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">research-agent</parameter>
<parameter name="description">Research phase</parameter>
<parameter name="prompt">Research [TOPIC]</parameter>
</invoke>
</function_calls>

<!-- Phase 2 (after Phase 1 completes) -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">content-agent</parameter>
<parameter name="description">Content creation</parameter>
<parameter name="prompt">Create content using: [PASTE PHASE 1 RESULTS]</parameter>
</invoke>
</function_calls>
```

### 8.2 Multi-Phase Workflow Design (25 min)
**Phase Planning Strategy**:
1. **Dependency Analysis**: Which tasks require previous outputs?
2. **Parallelization Opportunities**: Which tasks can run simultaneously?
3. **Resource Optimization**: Balance Haiku/Sonnet/Opus usage
4. **Quality Gates**: Where to insert validation steps

**Example: Blog Post Workflow**
```
Phase 1 (Parallel): Research + Keywords + Audience + Competition
Phase 2 (Sequential): Content Planning (requires Phase 1 outputs)
Phase 3 (Parallel): Intro + Body + Conclusion (independent sections)
Phase 4 (Sequential): Assembly + QA (requires Phase 3 outputs)
```

**Context Passing Patterns**:
- Copy-paste between phases (current approach)
- Structured data formats for consistency
- Clear handoff instructions

### 8.3 Error Handling and Fallbacks (25 min)
**Common Error Scenarios**:
- Agent not found or misconfigured
- Invalid input format
- Tool access failures
- Resource limitations

**Error Handling Strategies**:
```xml
<!-- Fallback agent specification -->
<invoke name="Task">
<parameter name="subagent_type">backup-researcher</parameter>
<parameter name="description">Fallback research if primary fails</parameter>
<parameter name="prompt">Complete research for [TOPIC] using alternative approach</parameter>
</invoke>
```

**Quality Validation Steps**:
- Output format verification
- Content quality checks
- Completeness validation
- Consistency assessment

**Final Exercise - Complete Workflow Creation**:
- Design 4-phase workflow for tutorial creation
- Include parallel and sequential phases
- Add error handling considerations
- Test end-to-end execution

---

## Advanced Topics and Best Practices (30 minutes)

### 9.1 Common Patterns (10 min)
**Successful Patterns**:
- Research → Structure → Create → Assemble
- Parallel quality checks in final phase
- Model optimization by complexity
- Single responsibility enforcement

**Template Inheritance**:
- Base patterns for common workflows
- Specialized variants for specific content types
- Reusable component blocks

### 9.2 Anti-Patterns to Avoid (10 min)
**Configuration Anti-patterns**:
- Over-provisioning tools (security risk)
- Vague responsibility definitions
- Model selection based on preference vs requirement
- Missing constraint definitions

**Workflow Anti-patterns**:
- Sequential execution where parallel would work
- Opus usage for simple tasks
- Missing error handling
- Poor context passing between phases

### 9.3 Swiss Localization Special Considerations (10 min)
**Cultural Adaptation Requirements**:
- Language-specific nuances (Swiss German, French, Italian)
- Regulatory compliance (Swiss data protection, financial laws)
- Business etiquette and neutral tone
- Cantonal variation awareness

**Localization Workflow Pattern**:
```xml
<!-- Parallel translation -->
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">swiss-german-translator</parameter>
<parameter name="description">Translate to Swiss German</parameter>
<parameter name="prompt">Translate with cultural adaptation: [CONTENT]</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-french-translator</parameter>
<parameter name="description">Translate to Swiss French</parameter>
<parameter name="prompt">Translate with regional nuances: [CONTENT]</parameter>
</invoke>
</function_calls>
```

---

## Assessment and Certification (30 minutes)

### Final Project Requirements
Create a complete sub-agent from scratch:

1. **Agent Design** (10 points):
   - Single responsibility definition
   - Appropriate model selection
   - Minimal tool configuration
   - Comprehensive system prompt

2. **Deployment** (5 points):
   - Successful deployment to .claude/agents/
   - Validation testing completed
   - Documentation updated

3. **Integration** (10 points):
   - XML workflow template created
   - Multi-phase execution demonstrated
   - Error handling implemented

4. **Testing** (5 points):
   - Unit tests designed and executed
   - Integration tests completed
   - Performance metrics documented

### Evaluation Criteria
- **Technical Accuracy** (40%): Correct configuration and implementation
- **Best Practices** (30%): Following established patterns and principles
- **Innovation** (20%): Creative solutions and optimizations
- **Documentation** (10%): Clear documentation and knowledge transfer

### Certification Levels
- **Basic**: Successful agent creation and deployment
- **Intermediate**: Multi-phase workflow integration
- **Advanced**: Swiss localization or complex orchestration
- **Expert**: System optimization and pattern innovation

---

## Resources and References

### Essential Documentation
- `/agents/CLAUDE.md` - Complete agent system documentation
- `/templates/CLAUDE.md` - XML workflow patterns
- `/.claude/CLAUDE.md` - Main navigation and operations guide

### Code Examples
- Agent configurations in `/agents/` directory
- Template patterns in `/templates/` directory
- Deployment scripts in `/scripts/` directory

### Community and Support
- GitHub repository for collaboration
- Issue tracking for bug reports
- Pull request process for contributions

### Continuing Education
- Advanced orchestration patterns
- Performance optimization techniques
- Multi-language agent development
- Custom tool development

---

## Appendices

### Appendix A: Quick Reference Cards
- YAML configuration checklist
- Model selection decision tree
- Common XML patterns
- Troubleshooting guide

### Appendix B: Example Agents
- Complete agent configurations for each model type
- Before/after optimization examples
- Swiss localization samples

### Appendix C: Performance Metrics
- Benchmark comparisons
- Cost analysis spreadsheets
- Speed optimization results

---

*Total Tutorial Duration: 4-6 hours*
*Recommended Pace: 2-3 sessions of 2 hours each*
*Prerequisites: Basic YAML knowledge, command line familiarity*
*Outcome: Fully functional sub-agent development capability*