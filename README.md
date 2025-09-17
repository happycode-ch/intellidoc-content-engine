# IntelliDoc Content Engine
### 54-Agent Content Creation Pipeline for Claude Code (48 Core + 6 Swiss Localization)

**🚧 Work in Progress** - This project is under active development

*Transform your ideas into exceptional content with specialized AI agents working in perfect harmony.*

---

## ✨ What is the IntelliDoc Content Engine?

The IntelliDoc Content Engine is a sophisticated content creation system developed by IntelliDoc, powered by 54 specialized Claude Code agents (48 core + 6 Swiss localization). Each agent masters a single aspect of content creation—from research and strategy to writing and distribution—delivering precision and quality that surpasses traditional approaches.

**🎯 One Request, Complete Content Pipeline**
Simply say *"Write a technical blog post about Docker"* and watch as specialized agents automatically research, plan, create, polish, and format your content across multiple platforms.

---

## 🚀 Quick Start (5 Minutes)

### 1. Install All Agents
```bash
# Copy agents to your Claude Code directory
cp .claude/agents/*.md ~/.claude/agents/

# Or for project-specific installation
mkdir -p your-project/.claude/agents/
cp .claude/agents/*.md your-project/.claude/agents/
```

### 2. Verify Installation
```bash
# In Claude Code
/agents
```
You should see all 54 agents listed.

### 3. Create Your First Content
```
"Write a comprehensive guide about Kubernetes deployment strategies"
```
Claude Code automatically orchestrates the perfect combination of agents for your request.

---

## 🎭 The 54 Specialists

### 📊 **Phase 1: Research & Discovery** *(5 agents)*
- `topic-scout` - Discover trending topics
- `source-gatherer` - Collect authoritative sources
- `competitor-analyzer` - Analyze competitive landscape
- `fact-verifier` - Verify claims and statistics
- `keyword-researcher` - Research SEO opportunities

### 🎯 **Phase 2: Strategy & Planning** *(5 agents)*
- `content-planner` - Plan comprehensive content strategy
- `angle-definer` - Define unique perspectives
- `audience-profiler` - Profile target audiences
- `spec-writer` - Create detailed specifications
- `template-selector` - Choose optimal formats

### ✍️ **Phase 3: Content Creation** *(5 agents)*
- `outline-builder` - Structure compelling outlines
- `intro-writer` - Craft engaging introductions
- `body-writer` - Generate comprehensive main content *(Opus-powered)*
- `conclusion-writer` - Create memorable conclusions
- `quote-integrator` - Weave in expert insights

### 🔧 **Phase 4: Technical Content** *(4 agents)*
- `code-example-writer` - Create working code examples
- `api-documenter` - Document APIs clearly
- `command-demonstrator` - Show command usage
- `error-handler` - Handle edge cases

### 🎓 **Phase 5: Tutorial Creation** *(4 agents)*
- `step-sequencer` - Sequence learning steps
- `exercise-designer` - Design practice exercises
- `solution-provider` - Provide complete solutions
- `concept-explainer` - Explain complex concepts

### ✅ **Phase 6: Quality Assurance** *(5 agents)*
- `grammar-checker` - Perfect language mechanics
- `style-editor` - Ensure style consistency
- `flow-optimizer` - Optimize content flow
- `readability-scorer` - Maximize accessibility
- `link-validator` - Verify all references

### 🎨 **Phase 7: Visual Creation** *(5 agents)*
- `ai-prompt-engineer` - Create AI image prompts
- `chart-designer` - Design data visualizations
- `infographic-planner` - Plan infographic layouts
- `thumbnail-creator` - Generate thumbnails
- `diagram-sketcher` - Sketch technical diagrams

### 📱 **Phase 8: Distribution** *(5 agents)*
- `content-atomizer` - Break into shareable pieces
- `twitter-formatter` - Format for Twitter/X
- `linkedin-adapter` - Adapt for LinkedIn
- `instagram-packager` - Package for Instagram
- `newsletter-curator` - Curate email content

### 📈 **Phase 9: Performance Analysis** *(3 agents)*
- `metrics-collector` - Gather performance data
- `trend-spotter` - Identify content trends
- `improvement-advisor` - Recommend optimizations

---

## 🎪 Common Workflows

### 📝 **Technical Blog Post**
```
"Create a technical blog post about GraphQL best practices"
```
**Agents**: research → planning → writing → code examples → quality → distribution

### 📚 **Step-by-Step Tutorial**
```
"Build a complete React authentication tutorial"
```
**Agents**: planning → sequencing → code examples → exercises → solutions → testing

### 📰 **Quick News Article**
```
"Write about the latest AI developments"
```
**Agents**: research → fact-checking → writing → formatting → social media

### 📖 **Comprehensive Guide**
```
"Create the ultimate guide to Docker containerization"
```
**Uses most agents**: Full research → strategy → creation → visuals → distribution → analysis

---

## 🧠 The Philosophy

### **Specialization Over Consolidation**
- ✅ 41 specialists doing one thing perfectly
- ❌ 10 generalists doing many things adequately

### **Precision Over Speed**
- ✅ Quality output worth the execution time
- ❌ Fast but mediocre results

### **Context Isolation**
- ✅ Each agent gets clean, focused context
- ❌ Contamination between tasks

### **Minimal Tool Access**
- ✅ Agents only access tools they need
- ❌ Excessive permissions and complexity

---

## 🎛️ Advanced Usage

### **Force Specific Agents**
```bash
/agent quote-integrator
"Add these expert quotes to my article: [quotes]"
```

### **Skip Phases for Speed**
```
"Quick draft without extensive research"
# Automatically skips research agents
```

### **Maximum Quality Mode**
```
"Publication-ready article with full QA"
# Engages all quality assurance agents
```

---

## ⚡ Performance

### **Execution Times**
- **Quick article**: 2-3 minutes
- **Technical blog post**: 5-10 minutes
- **Comprehensive guide**: 15-20 minutes

### **Cost Optimization**
- **29 Haiku agents** (low cost) for simple tasks
- **11 Sonnet agents** (medium cost) for complex reasoning
- **1 Opus agent** (high cost) for critical content generation

### **Quality Metrics**
- **Precision**: HIGH (specialized agents)
- **Consistency**: HIGH (single responsibility)
- **Maintainability**: HIGH (isolated agents)

---

## 🏗️ Architecture

### **Project Structure**
```
intellidoc-content-engine/
├── docs/                            # 📚 Comprehensive documentation
│   ├── README.md                    # Documentation index
│   ├── AGENT_MODEL_OPTIMIZATION_GUIDE.md
│   ├── architecture/                # Technical guides & best practices
│   ├── orchestration/               # Agent coordination specs
│   └── swiss-business/              # Swiss localization resources
├── agents/                          # 🤖 Agent definitions (source of truth)
│   ├── README.md                    # Agent system overview
│   ├── CLAUDE.md                    # Development guidelines
│   ├── [54 agent files]             # Core agent definitions
│   ├── orchestration/               # 7 orchestrator agents
│   └── language_agents/             # 6 Swiss localization agents
├── scripts/                         # 🛠️ Utilities & automation
│   ├── content-management/          # Content archiving & setup
│   ├── development/                 # Development utilities
│   └── pdf-build/                   # PDF export system
├── content/                         # 📄 Generated content output
│   ├── blog/                        # Blog posts
│   ├── tutorials/                   # Step-by-step guides
│   ├── social/                      # Social media content
│   ├── swiss/                       # Swiss localized content
│   └── .archive/                    # Archived content batches
├── .claude/                         # ⚙️ Claude Code configuration
│   ├── CLAUDE.md                    # Project configuration
│   └── agents/ → ../agents/         # Symlinks to agent definitions
├── LICENSE                          # MIT License
└── README.md                        # This file
```

### **Agent File Format**
```yaml
---
name: agent-name
description: Single responsibility description
model: haiku|sonnet|opus
tools: Read, Write, WebSearch, etc.
---

[Agent implementation...]
```

---

## 📄 PDF Export System (Experimental)

### **Professional Document Generation**
Convert your generated content to beautifully formatted PDFs with professional typography and layout.

### **Quick Start**
```bash
# Generate PDF from markdown
cd pdf-build/
make pdf FILE=../your-document.md

# Or use the build script
./build.sh ../your-document.md
```

### **Features**
- Professional typography (Source Sans Pro, Fira Code)
- Dark syntax highlighting for code blocks
- Book-quality layout (O'Reilly/Pragmatic style)
- Multiple output formats (PDF, ePub)
- Automated dependency management

### **Installation**
```bash
# Check and install dependencies
cd pdf-build/
make check-deps
make install-fonts
make get-template
```

For detailed PDF export documentation, see [`pdf-build/README.md`](pdf-build/README.md)

---

## 🛠️ Customization

### **Adding New Agents**
1. Create agent file: `new-function.md`
2. Follow the standard template
3. Place in `.claude/agents/`
4. Agent automatically available

### **Modifying Existing Agents**
1. Backup: `cp agent.md agent.md.backup`
2. Edit the agent file
3. Test: `/agent agent-name`
4. Deploy: Copy to agents directory

### **Creating Workflows**
Combine agents for custom workflows:
```bash
/agent outline-builder
/agent intro-writer
/agent body-writer
/agent conclusion-writer
```

---

## 🚨 Troubleshooting

### **Agents Not Triggering**
- ✅ Verify agents in `.claude/agents/`
- ✅ Check file names match exactly
- ✅ Use `/agents` to list available
- ✅ Try explicit: `/agent [name]`

### **Wrong Agent Selected**
- ✅ Be more specific in requests
- ✅ Use explicit agent invocation
- ✅ Review agent descriptions

### **Slow Execution**
- ✅ Normal for 41-agent precision
- ✅ Quality over speed by design
- ✅ Results worth the wait

---

## 📚 Documentation

- **📚 Documentation Hub**: [`docs/README.md`](docs/README.md)
- **⚙️ Project Configuration**: [`.claude/CLAUDE.md`](.claude/CLAUDE.md)
- **🔧 Agent System Guide**: [`agents/README.md`](agents/README.md)
- **⚡ Model Optimization**: [`docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md`](docs/AGENT_MODEL_OPTIMIZATION_GUIDE.md)
- **🛠️ Scripts & Utilities**: [`scripts/`](scripts/)
- **📄 PDF Export Guide**: [`scripts/pdf-build/README.md`](scripts/pdf-build/README.md)

---

## 🤝 Contributing

### **Improvements Welcome**
- 🐛 Bug fixes in agent logic
- ✨ New specialized agents
- 📚 Documentation enhancements
- 🎯 Performance optimizations

### **Guidelines**
- Maintain single-responsibility principle
- Follow existing agent patterns
- Test thoroughly before submitting
- Update documentation

---

## 📄 License

MIT License - see [`LICENSE`](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Anthropic** for Claude Code and agent architecture principles
- **Claude Code Community** for best practices and patterns
- **Content Creators** who inspired the specialized agent approach

---

## 🎯 Why the IntelliDoc Content Engine?

> *"In the world of AI agents, a specialist who does one thing perfectly beats a generalist who does many things adequately."*

The IntelliDoc Content Engine embodies this philosophy with 41 specialists working as an orchestra, each playing their instrument perfectly to create content that exceeds what any single agent could achieve.

**Ready to transform your content creation?** Start with the Quick Start guide above and experience the power of specialized AI collaboration.

---

*🤖 Powered by Claude Code | 🎭 41 Specialized Agents | 🏢 Developed by IntelliDoc | 🚀 Ready to Deploy*