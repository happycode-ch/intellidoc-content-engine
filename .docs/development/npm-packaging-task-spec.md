# NPM Package Creation Task Specification

## Task Overview
Create an NPM package for the IntelliDoc Content Engine that allows users to install and use the 54-agent content creation system via `npm install`.

## Project Context
The IntelliDoc Content Engine is a sophisticated content creation system with:
- 54 specialized agents (48 core + 6 Swiss localization)
- Organized in 10 phases for comprehensive content workflows
- Uses Claude Code native agent framework
- Current structure: source agents in `agents/`, deployed via symlinks in `.claude/agents/`

## Task Requirements

### 1. Package Structure Setup
Create the following files in project root:

#### 1.1 package.json
```json
{
  "name": "intellidoc-content-engine",
  "version": "1.0.0",
  "description": "54-agent content creation system for Claude Code with Swiss localization",
  "main": "index.js",
  "bin": {
    "intellidoc": "./bin/cli.js"
  },
  "files": [
    "agents/**/*",
    ".claude/agents/**/*",
    "content/**/*",
    "bin/**/*",
    "scripts/**/*",
    "docs/**/*",
    "*.sh",
    "swiss-*.json",
    "*.md",
    "!.archive/**/*",
    "!node_modules/**/*",
    "!.git/**/*"
  ],
  "scripts": {
    "postinstall": "node scripts/setup-agents.js",
    "setup": "chmod +x *.sh && ./setup-content-dirs.sh",
    "verify": "./verify-agents.sh",
    "clean": "./clean-content.sh"
  },
  "keywords": [
    "claude-code",
    "agents",
    "content-creation",
    "ai",
    "orchestration",
    "swiss-localization",
    "multilingual",
    "blog-automation",
    "tutorial-creation"
  ],
  "author": "Your Name",
  "license": "MIT",
  "engines": {
    "node": ">=16.0.0"
  },
  "peerDependencies": {
    "@anthropic-ai/claude-code": ">=1.0.0"
  },
  "repository": {
    "type": "git",
    "url": "your-repo-url"
  },
  "homepage": "your-homepage-url",
  "bugs": {
    "url": "your-issues-url"
  }
}
```

#### 1.2 index.js (Main Entry Point)
```javascript
#!/usr/bin/env node

const path = require('path');
const fs = require('fs');

class IntelliDocContentEngine {
  constructor() {
    this.agentsPath = path.join(__dirname, 'agents');
    this.claudeAgentsPath = path.join(process.env.HOME || process.env.USERPROFILE, '.claude', 'agents');
  }

  getAvailableAgents() {
    const agentFiles = fs.readdirSync(this.agentsPath)
      .filter(file => file.endsWith('.md'))
      .map(file => file.replace('.md', ''));

    return agentFiles;
  }

  getAgentInfo(agentName) {
    const agentPath = path.join(this.agentsPath, `${agentName}.md`);
    if (!fs.existsSync(agentPath)) {
      throw new Error(`Agent ${agentName} not found`);
    }

    const content = fs.readFileSync(agentPath, 'utf8');
    const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);

    if (yamlMatch) {
      const yaml = require('yaml');
      return yaml.parse(yamlMatch[1]);
    }

    return {};
  }

  isInstalled() {
    return fs.existsSync(this.claudeAgentsPath);
  }

  getInstalledAgents() {
    if (!this.isInstalled()) return [];

    return fs.readdirSync(this.claudeAgentsPath)
      .filter(file => file.endsWith('.md'))
      .map(file => file.replace('.md', ''));
  }
}

module.exports = IntelliDocContentEngine;

// CLI usage when run directly
if (require.main === module) {
  const engine = new IntelliDocContentEngine();
  console.log('IntelliDoc Content Engine');
  console.log(`Available agents: ${engine.getAvailableAgents().length}`);
  console.log('Run "intellidoc --help" for more options');
}
```

#### 1.3 bin/cli.js (CLI Interface)
```javascript
#!/usr/bin/env node

const { Command } = require('commander');
const IntelliDocContentEngine = require('../index.js');
const path = require('path');
const fs = require('fs-extra');

const program = new Command();
const engine = new IntelliDocContentEngine();

program
  .name('intellidoc')
  .description('IntelliDoc Content Engine CLI')
  .version('1.0.0');

program
  .command('list')
  .description('List all available agents')
  .action(() => {
    const agents = engine.getAvailableAgents();
    console.log(`Available agents (${agents.length}):`);
    agents.forEach(agent => {
      try {
        const info = engine.getAgentInfo(agent);
        console.log(`  ${agent} - ${info.description || 'No description'}`);
      } catch (err) {
        console.log(`  ${agent} - Error reading agent info`);
      }
    });
  });

program
  .command('status')
  .description('Check installation status')
  .action(() => {
    const installed = engine.getInstalledAgents();
    const available = engine.getAvailableAgents();

    console.log(`Claude Code agents directory: ${engine.isInstalled() ? 'Found' : 'Not found'}`);
    console.log(`Available agents: ${available.length}`);
    console.log(`Installed agents: ${installed.length}`);

    if (installed.length !== available.length) {
      console.log('\nℹ️  Run "intellidoc setup" to install missing agents');
    }
  });

program
  .command('setup')
  .description('Setup agents and content directories')
  .action(async () => {
    const setupScript = path.join(__dirname, '..', 'scripts', 'setup-agents.js');
    if (fs.existsSync(setupScript)) {
      require(setupScript);
    } else {
      console.error('Setup script not found');
      process.exit(1);
    }
  });

program
  .command('verify')
  .description('Verify agent installation')
  .action(() => {
    const verifyScript = path.join(__dirname, '..', 'verify-agents.sh');
    if (fs.existsSync(verifyScript)) {
      const { execSync } = require('child_process');
      try {
        execSync(`bash "${verifyScript}"`, { stdio: 'inherit' });
      } catch (error) {
        console.error('Verification failed');
        process.exit(1);
      }
    } else {
      console.error('Verify script not found');
      process.exit(1);
    }
  });

program.parse();
```

#### 1.4 scripts/setup-agents.js (Postinstall Script)
```javascript
const fs = require('fs-extra');
const path = require('path');
const os = require('os');

async function setupAgents() {
  try {
    console.log('🚀 Setting up IntelliDoc Content Engine...');

    // Determine Claude Code agents directory
    const homeDir = os.homedir();
    const claudeAgentsDir = path.join(homeDir, '.claude', 'agents');

    // Ensure Claude Code agents directory exists
    await fs.ensureDir(claudeAgentsDir);
    console.log(`✅ Claude agents directory ready: ${claudeAgentsDir}`);

    // Copy agents from package to Claude Code
    const packageAgentsDir = path.join(__dirname, '..', 'agents');
    const agentFiles = await fs.readdir(packageAgentsDir);

    let copiedCount = 0;
    for (const file of agentFiles) {
      if (file.endsWith('.md')) {
        const sourcePath = path.join(packageAgentsDir, file);
        const targetPath = path.join(claudeAgentsDir, file);

        await fs.copy(sourcePath, targetPath, { overwrite: true });
        copiedCount++;
      }
    }

    console.log(`✅ Installed ${copiedCount} agents to Claude Code`);

    // Make shell scripts executable
    const packageRoot = path.join(__dirname, '..');
    const shellScripts = ['setup-content-dirs.sh', 'verify-agents.sh', 'clean-content.sh'];

    for (const script of shellScripts) {
      const scriptPath = path.join(packageRoot, script);
      if (await fs.pathExists(scriptPath)) {
        await fs.chmod(scriptPath, 0o755);
      }
    }

    console.log('✅ Made shell scripts executable');

    // Create content directories
    const contentDir = path.join(process.cwd(), 'content');
    const contentSubdirs = ['blog', 'news', 'series', 'social', 'swiss', 'tutorials', 'whitepapers'];

    for (const subdir of contentSubdirs) {
      const dirPath = path.join(contentDir, subdir);
      await fs.ensureDir(dirPath);

      // Create .gitkeep files
      const gitkeepPath = path.join(dirPath, '.gitkeep');
      if (!await fs.pathExists(gitkeepPath)) {
        await fs.writeFile(gitkeepPath, '');
      }
    }

    console.log('✅ Content directories created');

    console.log('\n🎉 IntelliDoc Content Engine setup complete!');
    console.log('\nQuick start:');
    console.log('  intellidoc status  - Check installation');
    console.log('  intellidoc list    - See all agents');
    console.log('\nUsage in Claude Code:');
    console.log('  /agent blog-post-orchestrator');
    console.log('  "Create a technical blog post about Docker"');

  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    process.exit(1);
  }
}

// Run setup if called directly or via npm postinstall
if (require.main === module || process.env.npm_lifecycle_event === 'postinstall') {
  setupAgents();
}

module.exports = setupAgents;
```

### 2. Documentation Updates

#### 2.1 README.md (Package README)
Create a comprehensive README that includes:
- Installation instructions
- Quick start guide
- Agent overview
- Usage examples
- CLI reference
- Troubleshooting

#### 2.2 Update existing .gitignore
Add NPM-specific exclusions:
```
# NPM
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json
yarn.lock

# Distribution
dist/
build/
```

### 3. Testing Strategy

#### 3.1 Package Testing
1. Create test installation in temporary directory
2. Verify all agents are properly copied
3. Test CLI commands work correctly
4. Confirm content directories are created
5. Validate agent functionality in Claude Code

#### 3.2 Integration Testing
1. Test with fresh Claude Code installation
2. Verify orchestrator workflows function
3. Check Swiss localization agents work
4. Validate content generation pipeline

### 4. Publishing Preparation

#### 4.1 Pre-publish Checklist
- [ ] All agent files are included in `files` array
- [ ] Shell scripts have proper permissions
- [ ] Documentation is complete and accurate
- [ ] Version number follows semantic versioning
- [ ] Repository URL is correct
- [ ] License file exists

#### 4.2 Publishing Commands
```bash
# Dry run to see what would be published
npm pack

# Publish to NPM registry
npm publish
```

### 5. Post-Installation User Experience

Users should be able to:
1. Install with: `npm install -g intellidoc-content-engine`
2. Verify installation: `intellidoc status`
3. Start creating content immediately in Claude Code
4. Use all 54 agents without manual setup

### 6. Error Handling

The setup should gracefully handle:
- Missing Claude Code installation
- Permission issues
- Existing agent conflicts
- Network connectivity problems during installation

### 7. Success Criteria

- [ ] Package installs without errors
- [ ] All 54 agents are deployed to Claude Code
- [ ] Content directories are created
- [ ] CLI tools work correctly
- [ ] Orchestrators function in Claude Code
- [ ] Swiss localization agents are available
- [ ] Documentation is clear and complete

## Implementation Notes

1. **Preserve existing structure**: Don't modify current symlink system, work alongside it
2. **Cross-platform compatibility**: Ensure Windows/Mac/Linux support
3. **Version management**: Plan for future updates and migrations
4. **User feedback**: Provide clear status messages during installation
5. **Rollback capability**: Allow users to uninstall cleanly if needed

## Dependencies

Add to package.json:
```json
"dependencies": {
  "commander": "^9.4.0",
  "fs-extra": "^11.1.0",
  "yaml": "^2.3.0"
}
```

This specification provides a complete roadmap for creating a professional NPM package that seamlessly integrates the IntelliDoc Content Engine with Claude Code's agent system.