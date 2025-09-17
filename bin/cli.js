#!/usr/bin/env node

const { Command } = require('commander');
const IntelliDocContentEngine = require('../index.js');
const path = require('path');
const fs = require('fs-extra');

const program = new Command();
const engine = new IntelliDocContentEngine();

program
  .name('intellidoc')
  .description('IntelliDoc Content Engine CLI - 54-agent content creation system')
  .version('1.0.0');

program
  .command('list')
  .description('List all available agents')
  .option('-c, --category <type>', 'Filter by category (orchestrators, core, swiss)')
  .action((options) => {
    const categories = engine.getAgentsByCategory();

    function displayCategory(name, agents, emoji) {
      if (agents.length > 0) {
        console.log(`\n${emoji} ${name} (${agents.length}):`);
        agents.forEach(agent => {
          const desc = agent.description || 'No description';
          const model = agent.model ? `[${agent.model}]` : '';
          console.log(`  ${agent.name} ${model} - ${desc}`);
        });
      }
    }

    if (!options.category) {
      console.log(`🤖 IntelliDoc Content Engine - Available Agents`);
      displayCategory('Orchestrators', categories.orchestrators, '🎭');
      displayCategory('Core Agents', categories.core, '⚙️');
      displayCategory('Swiss Localization', categories.swiss, '🇨🇭');
    } else {
      const category = options.category.toLowerCase();
      if (categories[category]) {
        displayCategory(category.charAt(0).toUpperCase() + category.slice(1), categories[category], '📋');
      } else {
        console.error(`Invalid category: ${category}. Available: orchestrators, core, swiss`);
        process.exit(1);
      }
    }
  });

program
  .command('status')
  .description('Check installation status')
  .action(() => {
    const stats = engine.getStats();

    console.log('🔍 IntelliDoc Content Engine Status\n');
    console.log(`📦 Package version: v${stats.version}`);
    console.log(`🤖 Total agents: ${stats.totalAgents}`);
    console.log(`  🎭 Orchestrators: ${stats.orchestrators}`);
    console.log(`  ⚙️  Core agents: ${stats.coreAgents}`);
    console.log(`  🇨🇭 Swiss agents: ${stats.swissAgents}`);
    console.log(`💻 Claude Code: ${stats.claudeCodeInstalled ? '✅ Installed' : '❌ Not found'}`);
    console.log(`📁 Agents directory: ${stats.agentsInstalled ? '✅ Ready' : '❌ Not found'}`);
    console.log(`🚀 Deployed agents: ${stats.installedAgents}/${stats.totalAgents}`);

    if (!stats.claudeCodeInstalled) {
      console.log('\n⚠️  Claude Code not detected. Install Claude Code first.');
    } else if (stats.installedAgents !== stats.totalAgents) {
      console.log('\n💡 Run "intellidoc setup" to install missing agents');
    } else {
      console.log('\n🎉 All agents installed and ready!');
      console.log('\nQuick start in Claude Code:');
      console.log('  /agent blog-post-orchestrator');
      console.log('  "Create a technical blog post about Docker"');
    }
  });

program
  .command('setup')
  .description('Setup agents and content directories')
  .option('--force', 'Force reinstall existing agents')
  .action(async (options) => {
    console.log('🚀 Setting up IntelliDoc Content Engine...\n');

    try {
      const setupScript = path.join(__dirname, '..', 'scripts', 'setup-agents.js');
      if (await fs.pathExists(setupScript)) {
        // Set force flag in environment for setup script
        if (options.force) {
          process.env.INTELLIDOC_FORCE_INSTALL = 'true';
        }
        require(setupScript);
      } else {
        console.error('❌ Setup script not found');
        process.exit(1);
      }
    } catch (error) {
      console.error('❌ Setup failed:', error.message);
      process.exit(1);
    }
  });

program
  .command('verify')
  .description('Verify agent installation and functionality')
  .action(async () => {
    console.log('🔍 Verifying agent installation...\n');

    const stats = engine.getStats();
    let passed = 0;
    let failed = 0;

    // Check Claude Code installation
    console.log('1. Checking Claude Code installation...');
    if (stats.claudeCodeInstalled) {
      console.log('   ✅ Claude Code directory found');
      passed++;
    } else {
      console.log('   ❌ Claude Code directory not found');
      failed++;
    }

    // Check agents directory
    console.log('2. Checking agents directory...');
    if (stats.agentsInstalled) {
      console.log('   ✅ Agents directory exists');
      passed++;
    } else {
      console.log('   ❌ Agents directory missing');
      failed++;
    }

    // Check agent count
    console.log('3. Checking agent installation...');
    if (stats.installedAgents === stats.totalAgents) {
      console.log(`   ✅ All ${stats.totalAgents} agents installed`);
      passed++;
    } else {
      console.log(`   ⚠️  ${stats.installedAgents}/${stats.totalAgents} agents installed`);
      failed++;
    }

    // Check content directories
    console.log('4. Checking content directories...');
    const contentDir = path.join(process.cwd(), 'content');
    const requiredDirs = ['blog', 'news', 'series', 'social', 'swiss', 'tutorials', 'whitepapers'];

    let contentDirsExist = true;
    for (const dir of requiredDirs) {
      const dirPath = path.join(contentDir, dir);
      if (!await fs.pathExists(dirPath)) {
        contentDirsExist = false;
        break;
      }
    }

    if (contentDirsExist) {
      console.log('   ✅ Content directories ready');
      passed++;
    } else {
      console.log('   ❌ Content directories missing');
      failed++;
    }

    // Summary
    console.log(`\n📊 Verification Summary:`);
    console.log(`   ✅ Passed: ${passed}`);
    console.log(`   ❌ Failed: ${failed}`);

    if (failed === 0) {
      console.log('\n🎉 All verification checks passed!');
      process.exit(0);
    } else {
      console.log('\n⚠️  Some checks failed. Run "intellidoc setup" to fix issues.');
      process.exit(1);
    }
  });

program
  .command('info <agent>')
  .description('Get information about a specific agent')
  .action((agentName) => {
    try {
      const info = engine.getAgentInfo(agentName);

      console.log(`🤖 Agent Information: ${agentName}\n`);
      console.log(`📝 Description: ${info.description || 'No description'}`);
      console.log(`🧠 Model: ${info.model || 'Not specified'}`);
      console.log(`🛠️  Tools: ${info.tools ? (Array.isArray(info.tools) ? info.tools.join(', ') : info.tools) : 'None specified'}`);
      console.log(`📁 Path: ${info.path}`);

      // Check if installed
      const installed = engine.getInstalledAgents();
      const isInstalled = installed.includes(agentName);
      console.log(`🚀 Status: ${isInstalled ? '✅ Installed' : '❌ Not installed'}`);

    } catch (error) {
      console.error(`❌ Error: ${error.message}`);
      console.log('\n💡 Use "intellidoc list" to see available agents');
      process.exit(1);
    }
  });

program
  .command('uninstall')
  .description('Uninstall all agents from Claude Code')
  .option('--confirm', 'Skip confirmation prompt')
  .action(async (options) => {
    if (!options.confirm) {
      console.log('⚠️  This will remove all IntelliDoc agents from Claude Code.');
      console.log('Type "yes" to confirm:');

      const readline = require('readline');
      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
      });

      rl.question('', async (answer) => {
        rl.close();
        if (answer.toLowerCase() !== 'yes') {
          console.log('Uninstall cancelled.');
          return;
        }
        await performUninstall();
      });
    } else {
      await performUninstall();
    }

    async function performUninstall() {
      try {
        const installed = engine.getInstalledAgents();
        const claudeAgentsPath = engine.claudeAgentsPath;

        let removed = 0;
        for (const agent of installed) {
          const agentPath = path.join(claudeAgentsPath, `${agent}.md`);
          if (await fs.pathExists(agentPath)) {
            await fs.remove(agentPath);
            removed++;
          }
        }

        console.log(`✅ Removed ${removed} agents from Claude Code`);
        console.log('🔄 To reinstall, run: intellidoc setup');

      } catch (error) {
        console.error('❌ Uninstall failed:', error.message);
        process.exit(1);
      }
    }
  });

program.parse();