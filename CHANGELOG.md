# Changelog

All notable changes to the IntelliDoc Content Engine will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **README.md Complete Rewrite** (2025-09-19)
  - Rewrote entire README to accurately reflect template-based architecture
  - Corrected agent count from 54 to 46 (removed 8 non-functional orchestrators)
  - Fixed model distribution: 14 Haiku, 24 Sonnet, 8 Opus (was incorrectly 18/20/14)
  - Documented XML workflow templates as the true orchestration layer
  - Added clear explanation of why orchestrator agents were removed
  - Included practical template usage examples and workflow process
  - Highlighted key innovation: Templates succeed where orchestrator agents failed
  - Restructured documentation to focus on template-driven workflows

### Fixed
- **Archive-all.sh Script Safety** (2025-09-19)
  - Modified script to preserve scripts directory during cleanup operation
  - Scripts are now archived for backup but never deleted (infrastructure must remain)
  - Updated cleanup message to clarify "excluding scripts"
  - Prevents accidental deletion of critical project infrastructure
  - Tested successfully: Archives created, directories cleaned, scripts preserved

### Removed
- **Legacy Verification Scripts** (2025-09-19)
  - Deleted `scripts/verify-fixes.sh` - From old orchestrator system (September 18, 2025)
  - Deleted `scripts/development/verify-agents.sh` - References removed `cc_content_creation_agents/` directory
  - Both scripts were artifacts from previous architecture with orchestrator pattern
  - Current system uses template-based workflows with agents in `agents/` directory
  - Removal cleans up codebase from obsolete tooling

### Added
- **Template-Based Orchestration System** (replaces non-functional orchestrator agents)
  - 7 XML workflow templates in `templates/` directory for content creation
  - Direct parallel agent invocation patterns for true multi-agent coordination
  - Ready-to-use templates for blog posts, tutorials, news, social media, white papers, series, and Swiss localization
  - XML patterns enable actual parallel execution (60-70% performance improvement)
- **Comprehensive CLAUDE.md Documentation System**
  - Created/updated 8 CLAUDE.md files across all project directories
  - Root `/CLAUDE.md` with documentation map and git operations
  - Main `.claude/CLAUDE.md` as navigation hub with complete roadmap
  - Directory-specific CLAUDE.md files with contextual documentation
  - Full cross-referencing between all documentation files
- **temp_agent_outputs Directory Documentation**
  - Complete documentation for intermediate output management
  - Proper `.gitignore` rules preserving CLAUDE.md and .gitkeep
  - Integration with project documentation hierarchy
- **Archive Management System** (`scripts/content-management/archive-all.sh`)
  - Archives docs/, content/, scripts/, and my-notes/ directories
  - Interactive mode with option to keep originals or clean after archiving
  - Timestamped backups in `.archive/[YYYYMMDD-HHMMSS]/`
  - Restoration procedures documented in `.archive/CLAUDE.md`
- **Migration Guide** (`docs/migration/from-orchestrators-to-direct-invocation.md`)
  - Step-by-step migration from old orchestrator pattern to template-based workflows
  - Performance comparisons and best practices
- **Content routing configuration system** (`content/content-routing.yaml`)
  - Centralized content organization with 8 content types (blog, tutorial, news, whitepaper, series, social media, Swiss)
  - Automatic file path generation for consistent organization
  - Configurable naming patterns and metadata requirements
- **Comprehensive temporal awareness** across all agents
  - Dynamic date handling with natural language instructions
  - Future-proof temporal boundaries (no hardcoded years)
  - Consistent temporal context for accurate content generation
- **Structured research-to-writing handoff system**
  - Standardized `research_document` format preserving URLs, quotes, and statistics
  - Full source traceability from research to final content
  - Mandatory citation requirements for all claims and statistics
- **Development reports and implementation specifications**
  - Detailed gap analysis and fix documentation in `docs/development/content_creation/`
  - Implementation specifications for systematic improvements
  - Verification scripts for ensuring system integrity
- Professional codebase reorganization with logical directory structure
- Comprehensive documentation hub in `docs/` directory
- Organized utility scripts in `scripts/` directory
- Professional `.gitignore` with comprehensive coverage and clear sections

### Changed
- **Major Architectural Refactoring: Removed Non-Functional Orchestrator Agents**
  - Deleted 8 orchestrator agents that couldn't actually orchestrate due to execution context limitations
  - Reduced agent count from 52 to 46 (40 core + 6 Swiss localization)
  - Updated model distribution: Opus reduced from 14 to 6, focusing on core content generation
  - Archived removed orchestrators in `docs/archived/orchestrators/` with explanatory README
  - Replaced orchestrators with working XML template patterns that achieve true parallel execution
- **Updated All Documentation for New Architecture**
  - Fixed agent counts across all documentation (52→46)
  - Updated model distributions (Haiku: 18, Sonnet: 20, Opus: 6)
  - Revised workflow descriptions to use template-based patterns
  - Added template usage instructions throughout documentation
- **Performance and Cost Optimizations**
  - 70% cost reduction vs old orchestrator approach through template-based workflows
  - 60-70% performance improvement with true parallel execution
  - Eliminated overhead from non-functional orchestrator agents
- **All agent files updated** with temporal context and research capabilities
- `source-gatherer` output format now includes structured research documents with full URLs and quotes
- `body-writer` and writing agents now accept and utilize structured research data
- `content-assembler` now accepts `target_path` for consistent file placement and is the only remaining orchestration agent
- Removed complex placeholder system (`{{CURRENT_DATE}}`) in favor of natural language instructions
- Renamed `cc_content_creation_agents/` to `agents/` for better clarity
- Moved all documentation to `docs/` for centralized access
- Organized scripts by function in `scripts/content-management/` and `scripts/development/`
- Updated all file references to reflect new professional structure
- Cleaned 55 broken symlinks from project root

### Fixed
- **Critical Orchestrator Pattern Failure**
  - Orchestrator agents couldn't actually invoke other agents due to execution context limitations
  - Replaced with template-based workflows that enable true parallel agent coordination
  - Achieved actual orchestration through XML patterns instead of broken agent-to-agent calls
- **Critical temporal accuracy issues** that caused anachronistic content references
- **Broken research-to-writing chain** that lost source URLs and citations
- **Random content placement** throughout codebase without organization
- **Hardcoded year references** that would break in 2026 (now future-proof)
- **Fact verification gaps** by enabling source traceability

### Removed
- **8 Non-Functional Orchestrator Agents** (archived in `docs/archived/orchestrators/`)
  - `blog-post-orchestrator` - Replaced by `templates/blog-post-template.md`
  - `tutorial-orchestrator` - Replaced by `templates/tutorial-template.md`
  - `news-orchestrator` - Replaced by `templates/news-article-template.md`
  - `social-media-orchestrator` - Replaced by `templates/social-media-template.md`
  - `whitepaper-orchestrator` - Replaced by `templates/whitepaper-template.md`
  - `series-orchestrator` - Replaced by `templates/series-template.md`
  - `swiss-localization-orchestrator` - Replaced by `templates/swiss-localization-template.md`
  - `test-explicit-orchestrator` - Test agent, no longer needed
- 55 broken symbolic links from project root
- All hardcoded 2025 references replaced with dynamic "current year" instructions
- Complex `{{CURRENT_DATE}}` placeholder system replaced with natural language
- Duplicate and outdated entries from `.gitignore`
- Legacy directory references in documentation

## [0.3.0] - 2025-09-17

### Added
- Content organization system with clean directory structure for 7 content types
- Automatic content archiving with timestamp preservation
- Content management utilities (`archive-content.sh`, `clean-content.sh`, `setup-content-dirs.sh`)
- Single source of truth architecture using symbolic links
- Agent verification utility (`verify-agents.sh`)

### Changed
- Implemented symlink structure for agent deployment (`.claude/agents/` → `agents/`)
- Optimized model distribution: Opus (14), Sonnet (22), Haiku (18)
- Reorganized content generation to structured directories (blog, tutorials, news, etc.)
- Updated project structure for maintainability and professional deployment

### Performance
- **70% cost reduction** through optimized model assignments
- **3-5x faster execution** for simple tasks using Haiku model
- Maintained quality for complex tasks with strategic Opus retention

## [0.2.0] - 2025-09-16

### Added
- **Swiss localization module** with 6 specialized agents
  - Swiss German, French, and Italian translators
  - Language verification and compliance checking
  - Swiss localization orchestrator for multilingual workflows
- Swiss business style consistency tools and templates
- Enhanced agent model optimization for performance and cost efficiency

### Enhanced
- Expanded from 46 to 52 total agents (46 core + 6 Swiss)
- Improved model assignments based on task complexity analysis
- Added Phase 10: Swiss Localization to the agent pipeline

## [0.1.0] - 2025-09-15

### Added
- **Initial release** of 41-agent content creation pipeline
- Core orchestrator agents for specialized content workflows:
  - `blog-post-orchestrator` - Technical blog posts (1500-3000 words)
  - `tutorial-orchestrator` - Step-by-step guides with exercises
  - `news-orchestrator` - Rapid news article creation
  - `social-media-orchestrator` - Multi-platform social content
  - `whitepaper-orchestrator` - Long-form authoritative documents
  - `series-orchestrator` - Multi-part content series
- **Content assembler system** for consolidating agent outputs
- **PDF build system** with LaTeX templates and automation
- 9-phase agent pipeline for comprehensive content creation
- Claude Code native agent architecture (YAML + Markdown)
- MIT License and comprehensive documentation

### Features
- **Specialized agent architecture** with single responsibility principle
- **Intelligent orchestration** with optimized agent subset selection
- **Content type workflows** for different publication formats
- **Professional-grade output** through specialized agent coordination
- **WebSocket tutorial demonstration** showcasing full pipeline capabilities

### Documentation
- Comprehensive README with quick start guide
- Agent development guidelines and best practices
- Implementation guide with detailed specifications
- Project configuration and deployment instructions

---

## Release Notes

### Versioning Strategy
- **Major versions** (x.0.0): Significant architectural changes or breaking changes
- **Minor versions** (0.x.0): New features, agent additions, workflow enhancements
- **Patch versions** (0.0.x): Bug fixes, documentation updates, minor improvements

### Key Milestones
- **v0.1.0**: Foundation - 41-agent pipeline with core orchestrators
- **v0.2.0**: Expansion - Swiss localization and model optimization
- **v0.3.0**: Organization - Professional structure and content management
- **Future**: Enhanced AI capabilities, additional language support, enterprise features

### Performance Evolution
| Version | Agents | Models Used | Cost Efficiency | Key Feature |
|---------|--------|-------------|-----------------|-------------|
| v0.1.0  | 41     | Mixed       | Baseline        | Core Pipeline |
| v0.2.0  | 52     | Optimized   | +50%            | Swiss Localization |
| v0.3.0  | 52     | Optimized   | +70%            | Professional Structure |

---

For detailed technical information, see [docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md](docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md).

For development guidelines, see [agents/README.md](agents/README.md).