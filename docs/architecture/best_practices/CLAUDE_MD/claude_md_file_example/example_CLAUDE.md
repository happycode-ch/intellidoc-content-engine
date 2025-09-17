# Subagents Project Orchestration

## Project Overview
This is a multi-category subagent development environment where specialized AI agents are organized by domain expertise. Each category (e.g., writing_subagents_project, code_subagents, etc.) contains focused subagents with specific capabilities and responsibilities.

## Project Architecture
- **Orchestration Level**: High-level coordination across subagent categories
- **Category Level**: Domain-specific subagent collections (each with own folder-level CLAUDE.md)
- **Individual Subagents**: Specialized agents within categories stored as .md files with YAML frontmatter

## File Naming Convention for Documentation

When creating documentation, planning files, or timestamped artifacts, use this format:

**Format**: `[seq]_YYYY-MM-DD_HHMMSS_[descriptive-name].md`

**Timezone**: Zürich, Switzerland (CET/CEST)

**Example**: `04_2025-09-05_170200_pdf-data-collection_implementation_plan.md`

- `04` - Sequential number (01, 02, 03...)
- `2025-09-05` - Date in ISO format
- `170200` - Time in 24-hour format (17:02:00)
- Descriptive name with underscores

This ensures chronological ordering and clear tracking across all project documentation.

## Directory Structure
```
/subagents/
  /writing_subagents_project/     # Content creation specialists
    /content_creation_subagents/   # Individual writing agents
    /reports/                      # Timestamped reports
    CLAUDE.md                      # Category-specific instructions

  /code_subagents/                 # Development specialists
    /agents/                       # Code-focused agents
    CLAUDE.md                      # Category-specific instructions

  /research_subagents/             # Research and analysis
    /agents/                       # Research agents
    CLAUDE.md                      # Category-specific instructions

  /automation_subagents/           # Task automation
    /agents/                       # Automation agents
    CLAUDE.md                      # Category-specific instructions
```

## Orchestration Patterns

### Category Selection Strategy
1. **Identify Task Domain**: Determine which category best fits the request
2. **Check Category Capabilities**: Review category-level CLAUDE.md for available agents
3. **Select Appropriate Subagent**: Choose specific agent within category
4. **Coordinate Multi-Category Tasks**: Use multiple categories for complex requests

### Cross-Category Workflows
```
User Request → Orchestrator Analysis → Category Selection → Subagent Invocation → Result Synthesis
```

### Parallel Processing Pattern
For tasks requiring multiple specializations:
- Research agents gather information
- Writing agents create content based on research
- Code agents implement technical solutions
- Automation agents handle repetitive tasks

## Subagent Management Guidelines

### Creating New Subagents
1. Determine appropriate category
2. Follow naming convention: `[category]-[specialization].md`
3. Include YAML frontmatter with:
   - name: descriptive-identifier
   - description: When to use (include "PROACTIVELY" for auto-trigger)
   - model: haiku/sonnet/opus (based on complexity)
   - tools: minimal necessary permissions

### Model Selection Criteria
- **Haiku**: Simple formatting, basic operations, documentation
- **Sonnet**: Standard development, content creation, analysis
- **Opus**: Complex reasoning, architecture, critical decisions

### Tool Access Philosophy
- Grant minimum necessary permissions
- Read-only for review/analysis agents
- Write permissions only when essential
- Bash access restricted to safe operations

## Communication Standards

### Inter-Agent Communication
- Use structured output formats (JSON, Markdown tables)
- Include clear handoff instructions
- Maintain context chain through explicit references
- Document assumptions and constraints

### Progress Tracking
- Create timestamped progress reports
- Use sequential numbering for related documents
- Maintain audit trail of agent invocations
- Store outputs in category-appropriate locations

## Quality Assurance

### Before Invoking Subagents
1. Verify task fits agent specialization
2. Check category-level constraints
3. Confirm required tools are available
4. Prepare clear, specific instructions

### After Subagent Execution
1. Validate output meets requirements
2. Check for completeness
3. Verify no security/safety violations
4. Document results with timestamp

## Performance Optimization

### Token Usage Strategy
- Use Haiku for initial analysis/filtering
- Employ Sonnet for main implementation
- Reserve Opus for critical validation
- Batch similar operations

### Context Management
- Summarize lengthy contexts before handoff
- Use external storage for persistent data
- Clear unnecessary context between major phases
- Maintain focused, relevant information

## Security & Compliance

### Guardrails
- No direct access to sensitive files (.env, secrets/)
- Validate all inputs before processing
- Sanitize outputs for sensitive information
- Implement rate limiting for resource-intensive operations

### Audit Requirements
- Log all subagent invocations
- Track model usage and costs
- Document decision rationale
- Maintain compliance with project policies

## Common Orchestration Tasks

### Multi-Stage Content Creation
1. Research subagent gathers information
2. Writing subagent creates draft
3. Review subagent checks quality
4. Formatting subagent finalizes output

### Technical Implementation
1. Architecture subagent designs solution
2. Code subagent implements
3. Test subagent validates
4. Documentation subagent updates docs

### Analysis & Reporting
1. Data collection subagent gathers metrics
2. Analysis subagent processes data
3. Visualization subagent creates charts
4. Report subagent generates documentation

## Best Practices

### DO
- Use category-level CLAUDE.md for specific guidance
- Leverage specialized agents for their strengths
- Maintain clear separation of concerns
- Document all orchestration decisions
- Follow timestamped naming convention

### DON'T
- Mix responsibilities across categories unnecessarily
- Grant excessive permissions to subagents
- Skip validation steps
- Ignore category-specific constraints
- Create duplicate agents across categories

## Monitoring & Maintenance

### Regular Reviews
- Weekly: Check agent performance metrics
- Monthly: Review and update agent descriptions
- Quarterly: Audit tool permissions and access
- Annually: Major architecture review

### Continuous Improvement
- Track common failure patterns
- Identify automation opportunities
- Refine agent specializations
- Update based on usage patterns

## Integration Points

### With External Systems
- MCP servers for database access
- API integrations for third-party services
- File system for persistent storage
- Version control for tracking changes

### With Development Workflow
- CI/CD pipeline integration
- Automated testing frameworks
- Documentation generation
- Code review processes

## Emergency Procedures

### If Subagent Fails
1. Check error logs for specific failure
2. Verify prerequisites were met
3. Try alternative agent in same category
4. Escalate to manual intervention if needed
5. Document failure for improvement

### If Orchestration Breaks
1. Revert to direct agent invocation
2. Use simpler workflow temporarily
3. Debug orchestration logic
4. Update CLAUDE.md with findings

## Future Enhancements

### Planned Improvements
- Automated agent selection based on task analysis
- Performance benchmarking system
- Cost optimization algorithms
- Enhanced inter-agent communication protocols

### Scaling Considerations
- Parallel agent execution capabilities
- Distributed processing for large tasks
- State persistence across sessions
- Advanced memory management

---

*This orchestration guide enables efficient coordination across multiple subagent categories while maintaining clear boundaries, consistent standards, and robust quality controls.*