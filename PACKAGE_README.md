# File: PACKAGE_README.md
# Purpose: Project file
# AI-hints:
# - Markdown documentation file
# - Part of distributed documentation system

# IntelliDoc Content Engine NPM Package

### 54-Agent Content Creation System for Claude Code

*Transform your ideas into exceptional content with specialized AI agents working in perfect harmony.*

[![npm version](https://badge.fury.io/js/intellidoc-content-engine.svg)](https://badge.fury.io/js/intellidoc-content-engine)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 Quick Installation

```bash
# Install globally for system-wide access
npm install -g intellidoc-content-engine

# Verify installation
intellidoc status

# Start creating content in Claude Code!
```

---

## ✨ What is the IntelliDoc Content Engine?

The IntelliDoc Content Engine is a sophisticated NPM package that deploys 54 specialized Claude Code agents directly to your system. Each agent masters a single aspect of content creation—from research and strategy to writing and distribution—delivering precision and quality that surpasses traditional approaches.

**🎯 One Command, Complete Content Pipeline**
Simply install the package and watch as specialized agents automatically deploy to Claude Code, ready for immediate content creation across multiple platforms.

---

## 🎭 The 54 Specialists

### 📊 **Phase 1: Research & Discovery** *(5 agents)*
- `topic-scout` - Discover trending topics and opportunities
- `source-gatherer` - Collect authoritative sources and references
- `competitor-analyzer` - Analyze competitive landscape
- `fact-verifier` - Verify claims and statistics
- `keyword-researcher` - Research SEO opportunities

### 🎯 **Phase 2: Strategy & Planning** *(5 agents)*
- `content-planner` - Plan comprehensive content strategy
- `angle-definer` - Define unique perspectives and approaches
- `audience-profiler` - Profile target audiences
- `spec-writer` - Create detailed content specifications
- `template-selector` - Choose optimal content formats

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
- `error-handler` - Handle edge cases and troubleshooting

### 🎓 **Phase 5: Tutorial Creation** *(4 agents)*
- `step-sequencer` - Sequence learning steps logically
- `exercise-designer` - Design practice exercises
- `solution-provider` - Provide complete solutions
- `concept-explainer` - Explain complex concepts clearly

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

### 🇨🇭 **Phase 10: Swiss Localization** *(6 agents)*
- `swiss-german-translator` - Swiss German localization
- `swiss-french-translator` - Swiss French localization
- `swiss-italian-translator` - Swiss Italian localization
- `swiss-language-verifier` - Multi-language verification
- `swiss-compliance-checker` - Swiss regulatory compliance
- `swiss-localization-orchestrator` - Multilingual coordination

### 🎪 **Orchestration Layer** *(7 agents)*
- `blog-post-orchestrator` - Technical blog posts (1500-3000 words)
- `tutorial-orchestrator` - Step-by-step guides with exercises
- `news-orchestrator` - Rapid news articles
- `whitepaper-orchestrator` - Long-form authoritative documents
- `social-media-orchestrator` - Multi-platform social content
- `series-orchestrator` - Multi-part content series
- `content-assembler` - Consolidates all content fragments

---

## 📋 Prerequisites

- **Node.js** 16.0.0 or higher
- **Claude Code** installed and configured
- **Operating System**: Windows, macOS, or Linux

---

## 🛠️ Installation Guide

### Method 1: Global Installation (Recommended)

```bash
# Install globally for system-wide access
npm install -g intellidoc-content-engine

# Verify installation
intellidoc status

# Check all available agents
intellidoc list
```

### Method 2: Local Project Installation

```bash
# Install in your project
npm install intellidoc-content-engine

# Run setup manually
npx intellidoc setup

# Verify local installation
npx intellidoc status
```

### Method 3: Direct Source Installation

```bash
# Clone from GitHub
git clone https://github.com/happycode-ch/intellidoc-content-engine.git
cd intellidoc-content-engine

# Install dependencies
npm install

# Link globally
npm link

# Verify installation
intellidoc status
```

---

## 🚀 Quick Start Guide

### 1. Verify Installation
```bash
intellidoc status
```

### 2. Create Your First Content
In Claude Code, simply use any orchestrator agent:

```
/agent blog-post-orchestrator
"Create a comprehensive guide about Docker containerization"
```

### 3. Explore Available Agents
```bash
# List all agents
intellidoc list

# List by category
intellidoc list --category orchestrators
intellidoc list --category swiss

# Get info about specific agent
intellidoc info blog-post-orchestrator
```

---

## 🎪 Common Workflows

### 📝 **Technical Blog Post**
```
/agent blog-post-orchestrator
"Create a technical blog post about GraphQL best practices"
```
**Result**: Complete blog post with code examples, SEO optimization, and multi-platform distribution ready.

### 📚 **Step-by-Step Tutorial**
```
/agent tutorial-orchestrator
"Build a complete React authentication tutorial with exercises"
```
**Result**: Comprehensive tutorial with exercises, solutions, and progressive learning structure.

### 📰 **Quick News Article**
```
/agent news-orchestrator
"Write about the latest AI developments announced today"
```
**Result**: Fact-checked news article with sources, social media variants, and publication-ready format.

### 🌐 **Swiss Multilingual Content**
```
/agent swiss-localization-orchestrator
"Create blog post about fintech regulations for Swiss market"
```
**Result**: Content in German, French, and Italian with Swiss compliance checking.

### 📖 **Comprehensive Guide**
```
/agent whitepaper-orchestrator
"Create authoritative white paper on blockchain security"
```
**Result**: 5000-10000 word professional document with research, citations, and executive summary.

---

## 🔧 CLI Reference

### Core Commands

```bash
# Check installation status
intellidoc status

# List all available agents
intellidoc list

# List agents by category
intellidoc list --category [orchestrators|core|swiss]

# Get agent information
intellidoc info <agent-name>

# Setup/reinstall agents
intellidoc setup

# Force reinstall existing agents
intellidoc setup --force

# Verify installation
intellidoc verify

# Uninstall all agents
intellidoc uninstall

# Show help
intellidoc --help
```

### Examples

```bash
# Check if everything is working
intellidoc status

# See all orchestrator agents
intellidoc list --category orchestrators

# Learn about the blog orchestrator
intellidoc info blog-post-orchestrator

# Reinstall agents if something is wrong
intellidoc setup --force

# Run comprehensive verification
intellidoc verify
```

---

## 📁 Directory Structure

After installation, you'll find:

```
~/.claude/agents/          # All 54 agents deployed here
├── blog-post-orchestrator.md
├── tutorial-orchestrator.md
├── swiss-german-translator.md
└── [51 more agents...]

./content/                 # Content output directories
├── blog/
├── tutorials/
├── news/
├── social/
├── swiss/
├── series/
└── whitepapers/
```

---

## ⚡ Performance & Cost Optimization

### **Execution Times**
- **Quick article**: 2-3 minutes
- **Technical blog post**: 5-10 minutes
- **Comprehensive tutorial**: 15-20 minutes
- **Swiss multilingual content**: 8-12 minutes

### **Cost Optimization**
- **18 Haiku agents** (35%) - Fast, low-cost formatting and validation
- **22 Sonnet agents** (41%) - Balanced analysis and content creation
- **14 Opus agents** (26%) - Complex orchestration and premium content

### **Quality Metrics**
- **Precision**: HIGH (specialized single-responsibility agents)
- **Consistency**: HIGH (isolated agent contexts)
- **Maintainability**: HIGH (modular architecture)
- **Performance**: 70% cost reduction vs. all-Opus approach

---

## 🔍 Troubleshooting

### **Agents Not Found**
```bash
# Check Claude Code installation
ls ~/.claude/

# Reinstall agents
intellidoc setup --force

# Verify deployment
intellidoc verify
```

### **Permission Issues**
```bash
# Fix permissions (Linux/Mac)
sudo chown -R $USER ~/.claude/

# Reinstall with proper permissions
sudo npm install -g intellidoc-content-engine
```

### **Partial Installation**
```bash
# Check what's missing
intellidoc status

# Force complete reinstall
intellidoc uninstall --confirm
intellidoc setup
```

### **Content Directories Missing**
```bash
# Recreate content structure
intellidoc setup

# Or manually
mkdir -p content/{blog,tutorials,news,social,swiss,series,whitepapers}
```

### **Claude Code Integration Issues**
1. Verify Claude Code is installed: `claude --version`
2. Check agents directory: `ls ~/.claude/agents/`
3. Restart Claude Code after installation
4. Try explicit agent invocation: `/agent blog-post-orchestrator`

---

## 🔄 Updating

```bash
# Update to latest version
npm update -g intellidoc-content-engine

# Verify update
intellidoc status

# Redeploy agents if needed
intellidoc setup --force
```

---

## 🗑️ Uninstalling

```bash
# Remove all agents from Claude Code
intellidoc uninstall --confirm

# Uninstall NPM package
npm uninstall -g intellidoc-content-engine

# Clean up content directories (optional)
rm -rf content/
```

---

## 🤝 Support & Community

### **Getting Help**
- 📚 **Documentation**: [GitHub Wiki](https://github.com/happycode-ch/intellidoc-content-engine/wiki)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/happycode-ch/intellidoc-content-engine/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/happycode-ch/intellidoc-content-engine/discussions)

### **Contributing**
- 🔧 **Development**: See [CONTRIBUTING.md](CONTRIBUTING.md)
- 🌟 **Feature Requests**: [GitHub Issues](https://github.com/happycode-ch/intellidoc-content-engine/issues)
- 📝 **Documentation**: Submit PRs for improvements

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🎯 Why Choose IntelliDoc Content Engine?

> *"In the world of AI agents, a specialist who does one thing perfectly beats a generalist who does many things adequately."*

### **✅ What You Get**
- **54 specialized agents** ready for immediate use
- **Zero configuration** - works out of the box
- **Multi-platform content** - blog, social, tutorials, white papers
- **Swiss localization** - German, French, Italian support
- **Professional workflows** - research to publication
- **Cost optimized** - 70% savings through smart model allocation

### **❌ What You Don't Get**
- Complex setup procedures
- Generic, one-size-fits-all agents
- Limited content types
- Manual deployment headaches
- High API costs from overusing expensive models

---

**Ready to transform your content creation?** Install now and experience the power of specialized AI collaboration.

```bash
npm install -g intellidoc-content-engine
intellidoc status
```

*🤖 Powered by Claude Code | 🎭 54 Specialized Agents | 🇨🇭 Swiss Localization Ready*