# Document-Driven Content Orchestration System

## System Overview

A **Main Orchestrator** instance manages all content generation operations, creating checkpoints between stages and coordinating separate Claude Code instances for each stage. The orchestrator persists throughout the entire process while worker instances spin up and down for specific tasks.

## Core Principle: Mirroring Human Content Workflows

This system intentionally mirrors how human content teams operate - with specialized roles, handoffs, reviews, and approvals. Each AI instance represents a human role (researcher, writer, editor), and checkpoints represent the natural handoff points in a real content creation process. This human-centered design ensures the AI system follows proven content creation methodologies rather than inventing new, untested workflows.

## Human Workflow Mapping

### Traditional Human Content Team → AI Instance Mapping

| Human Role | AI Instance | Typical Tasks |
|------------|-------------|---------------|
| Content Manager | Main Orchestrator | Assigns work, tracks progress, ensures quality gates |
| Research Analyst | research_orchestrator | Gathers sources, verifies facts, competitive analysis |
| Content Strategist | planning_orchestrator | Creates outlines, defines structure, sets tone |
| Content Writer | writing_orchestrator | Drafts content, implements narrative flow |
| Editor/QA | qa_orchestrator | Fact-checks, ensures brand voice, final polish |

### Human Process → System Process

**Human Team**: Kickoff meeting → Research phase → Strategy meeting → Writing → Editorial review → Publishing

**AI System**: Task spec → Research checkpoint → Planning checkpoint → Writing checkpoint → QA checkpoint → Final output

The checkpoints represent the same "handoff meetings" that occur in human teams - moments where work is reviewed, approved, and passed to the next specialist.

## Architecture

### Main Orchestrator Instance
**Instance**: `main_orchestrator` (Always Running)
- Creates initial checkpoint with task requirements
- Spins up stage-specific instances
- Receives completion signals from each instance
- Awaits human confirmation before proceeding
- Creates new checkpoints for next stage
- Manages 2-5 stages depending on content type

## Checkpoint Structure (XML Format)

```xml
<checkpoint>
  <metadata>
    <checkpoint_id>job_12345_stage_2</checkpoint_id>
    <stage>planning</stage>
    <status>ready</status>
    <timestamp>2025-01-20T10:30:00</timestamp>
  </metadata>
  
  <inputs>
    <file>research_notes.md</file>
    <file>verified_sources.json</file>
  </inputs>
  
  <instructions>
    <instruction_file>/instructions/planning/outline_structure.xml</instruction_file>
    <instruction_file>/instructions/planning/argument_flow.xml</instruction_file>
  </instructions>
  
  <requirements>
    <instance>planning_orchestrator</instance>
    <outputs>
      <required>content_outline.md</required>
      <required>section_specs.json</required>
    </outputs>
  </requirements>
  
  <human_confirmation>false</human_confirmation>
</checkpoint>
```

## Instruction Format: Hybrid Natural Language + XML

Instructions use **natural language** as the primary format, with **XML tags** for structure-critical elements like file references, requirements, and outputs.

```markdown
<!-- /instructions/writing/blog/narrative_flow.md -->
# Blog Writing Instructions

You are writing the main body content for a technical blog post. Your role is to transform the outline into engaging, informative prose that maintains technical accuracy while being accessible to senior developers.

## Required Inputs
<inputs>
  <file required="true">content_outline.md</file>
  <file required="true">research_notes.md</file>
  <file optional="true">verified_sources.json</file>
</inputs>

## Writing Process

Start by reading the content outline to understand the intended structure. Each section should flow naturally into the next, using transitional phrases that maintain reader engagement.

<requirements>
  <requirement priority="high">Hook reader within first 2 sentences</requirement>
  <requirement priority="high">One key point per paragraph</requirement>
  <requirement priority="medium">Include code examples where relevant</requirement>
</requirements>

Write in a conversational yet authoritative tone. Avoid academic stiffness but maintain technical precision. When introducing complex concepts, use the pattern: simple explanation → detailed explanation → practical example.

For technical sections, always provide concrete examples. Abstract concepts without implementation details frustrate readers and reduce article value.

## Expected Outputs
<outputs>
  <file>draft_content.md</file>
  <file>code_snippets.json</file>
</outputs>

## Quality Validation
<checks>
  <check>All claims supported by research_notes.md</check>
  <check>Technical accuracy verified against sources</check>
  <check>Word count: 1200-1800 words</check>
</checks>
```

**XML Usage Guidelines:**
- File references: Always use `<file>` tags
- Requirements/rules: Use `<requirement>` tags with priority
- Outputs: Explicit `<outputs>` section
- Natural language: Everything else - context, explanations, techniques

## Stage Workflow

### Stage 0: Orchestration Initialization
**Main Orchestrator** creates initial checkpoint:
```yaml
checkpoint_0:
  task_spec: blog_post_task.yaml
  job_id: "job_12345"
  content_type: "blog_post"
  total_stages: 4
  current_stage: 0
  status: "initialized"
```

### Stage 1: Research & Discovery
1. **Main Orchestrator** creates checkpoint_1 with research requirements
2. Spins up `research_orchestrator` instance
3. Instance reads checkpoint_1 and instruction files:
   - `/instructions/research/source_discovery.md`
   - `/instructions/research/fact_verification.md`
4. Instance completes, signals orchestrator: "Stage 1 Complete"
5. Instance terminates
6. **Human confirms** to orchestrator that research is satisfactory
7. **Main Orchestrator** creates checkpoint_2

### Stage 2: Content Planning
1. **Main Orchestrator** reads checkpoint_2 requirements
2. Spins up `planning_orchestrator` instance
3. Instance reads:
   - Previous outputs (research_notes.md)
   - Planning instructions
4. Instance completes, signals orchestrator
5. Instance terminates
6. **Human confirms** planning is complete
7. **Main Orchestrator** creates checkpoint_3

### Stage 3: Content Writing
1. **Main Orchestrator** initiates writing stage
2. Spins up `writing_orchestrator` instance
3. Instance reads checkpoint_3 with:
   - Content outline
   - Writing instructions for specific content type
4. Instance completes draft, signals orchestrator
5. Instance terminates
6. **Human confirms** draft is ready for verification
7. **Main Orchestrator** creates checkpoint_4

### Stage 4: Verification & QA
1. **Main Orchestrator** initiates final stage
2. Spins up `qa_orchestrator` instance
3. Instance performs verification checks
4. Instance completes, signals orchestrator
5. Instance terminates
6. **Human confirms** content is publication-ready
7. **Main Orchestrator** marks job complete

## Main Orchestrator Functions

```python
# Pseudo-code for main orchestrator
class MainOrchestrator:
    def __init__(self, task_spec):
        self.task_spec = task_spec
        self.current_checkpoint = self.create_initial_checkpoint()
        
    def create_checkpoint(self, stage_num, previous_outputs):
        return {
            "checkpoint_id": f"{self.job_id}_stage_{stage_num}",
            "stage": self.task_spec.stages[stage_num],
            "previous_outputs": previous_outputs,
            "instructions": self.load_instructions(stage_num),
            "status": "ready"
        }
    
    def execute_stage(self, checkpoint):
        # Spin up appropriate instance
        instance = self.spawn_instance(checkpoint.instance_type)
        
        # Instance runs autonomously
        result = instance.execute(checkpoint)
        
        # Wait for completion signal
        if result.status == "complete":
            print(f"Stage {checkpoint.stage} complete")
            return result.outputs
    
    def await_human_confirmation(self):
        # Wait for human to confirm stage completion
        input("Please review outputs and confirm to proceed...")
        return True
    
    def run_pipeline(self):
        for stage in range(self.task_spec.total_stages):
            checkpoint = self.create_checkpoint(stage)
            outputs = self.execute_stage(checkpoint)
            
            if self.await_human_confirmation():
                self.current_checkpoint = self.create_checkpoint(
                    stage + 1, 
                    outputs
                )
```

## Communication Protocol

### Instance → Orchestrator Messages
- `"Stage X initialized"`
- `"Stage X in progress"`
- `"Stage X complete - outputs saved"`
- `"Stage X failed - [error details]"`

### Orchestrator → Human Prompts
- `"Research complete. Review research_notes.md. Proceed to planning? [y/n]"`
- `"Outline ready. Review content_outline.md. Proceed to writing? [y/n]"`
- `"Draft complete. Review draft_content.md. Proceed to verification? [y/n]"`
- `"Verification complete. Content ready for publication."`

## Directory Structure

```
content_system/
├── claude.md                     # System overview, navigation guide
├── orchestration/
│   ├── claude.md                 # Orchestration patterns, checkpoint format
│   ├── checkpoints/
│   │   ├── claude.md             # Checkpoint lifecycle, status meanings
│   │   └── [job_id]/
│   │       ├── checkpoint_0.xml
│   │       ├── checkpoint_1.xml
│   │       └── ...
│   └── task_specs/
│       ├── claude.md             # Task spec structure, stage definitions
│       ├── blog_post.yaml
│       └── ...
│
├── instructions/
│   ├── claude.md                 # Instruction format, XML usage patterns
│   ├── research/
│   │   ├── claude.md             # Research stage goals, output formats
│   │   ├── source_discovery.md
│   │   └── fact_verification.md
│   ├── planning/
│   │   ├── claude.md             # Planning objectives, outline standards
│   │   └── outline_structure.md
│   ├── writing/
│   │   ├── claude.md             # Writing styles, tone guidelines
│   │   ├── blog/
│   │   │   ├── claude.md         # Blog-specific patterns
│   │   │   └── narrative_flow.md
│   │   └── technical/
│   │       ├── claude.md         # Technical doc standards
│   │       └── api_documentation.md
│   └── verification/
│       ├── claude.md             # QA criteria, validation rules
│       └── fact_checking.md
│
├── artifacts/
│   ├── claude.md                 # Output formats, file naming conventions
│   └── [job_id]/
│       ├── claude.md             # Job context, stage progression
│       ├── stage_1_outputs/
│       ├── stage_2_outputs/
│       └── ...
│
└── logs/
    ├── claude.md                 # Log formats, debugging guide
    └── [job_id]/
        ├── orchestrator.log
        └── stage_[n].log
```

## Claude.md File Examples

### Root claude.md
```markdown
# Content Orchestration System

This system uses document-driven orchestration with separate Claude Code instances for each stage.

## Key Concepts
- Main orchestrator manages workflow
- Each stage runs in isolated instance
- XML tags for file references and requirements
- Natural language for instructions

## Navigation
- /orchestration - Control flow and checkpoints
- /instructions - Stage-specific guidance
- /artifacts - Generated content outputs
- /logs - Execution tracking

## File Patterns
- .md files: Natural language instructions with XML tags
- .xml files: Checkpoints and structured data
- .yaml files: Task specifications
```

### /instructions/writing/claude.md
```markdown
# Writing Instructions Directory

Contains all content generation instructions organized by type.

## Subdirectories
- /blog - Blog post writing patterns
- /technical - Technical documentation
- /social - Social media content
- /whitepaper - Long-form research

## File Usage
Each .md file contains natural language instructions with XML tags for:
- <inputs> - Required source files
- <outputs> - Expected deliverables
- <requirements> - Key rules with priorities

## Common Patterns
All writing instructions follow: inputs → process → outputs → validation
```

## Task Spec with Orchestration

```yaml
# blog_post_task.yaml
name: "Technical Blog Post"
orchestrator:
  require_human_confirmation: true
  checkpoint_on_failure: true
  
stages:
  - stage_1_research:
      instance: "research_orchestrator"
      instructions:
        - /instructions/research/source_discovery.md
        - /instructions/research/fact_verification.md
      outputs_required:
        - research_notes.md
        - verified_sources.json
      
  - stage_2_planning:
      instance: "planning_orchestrator"
      requires: ["stage_1_research"]
      instructions:
        - /instructions/planning/outline_structure.md
      outputs_required:
        - content_outline.md
        
  - stage_3_writing:
      instance: "writing_orchestrator"
      requires: ["stage_2_planning"]
      instructions:
        - /instructions/writing/blog/narrative_flow.md
      outputs_required:
        - draft_content.md
        
  - stage_4_verification:
      instance: "qa_orchestrator"
      requires: ["stage_3_writing"]
      instructions:
        - /instructions/verification/fact_checking.md
      outputs_required:
        - final_content.md
```

## Benefits of Main Orchestrator Pattern

- **Persistent Context**: Orchestrator maintains job state throughout
- **Human-in-the-Loop**: Manual quality gates between stages
- **Clean Recovery**: Can restart from any checkpoint if issues arise
- **Progress Tracking**: Always know exactly where in pipeline you are
- **Flexible Staging**: 2-5 stages depending on content complexity
- **Audit Trail**: Complete record of all checkpoints and confirmations