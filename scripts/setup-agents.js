const fs = require('fs-extra');
const path = require('path');
const os = require('os');

async function setupAgents() {
  try {
    console.log('🚀 Setting up IntelliDoc Content Engine...\n');

    // Determine Claude Code agents directory
    const homeDir = os.homedir();
    const claudeAgentsDir = path.join(homeDir, '.claude', 'agents');
    const forceInstall = process.env.INTELLIDOC_FORCE_INSTALL === 'true';

    // Check if Claude Code directory exists
    const claudeDir = path.dirname(claudeAgentsDir);
    if (!await fs.pathExists(claudeDir)) {
      console.log('⚠️  Claude Code directory not found at:', claudeDir);
      console.log('💡 This is normal if Claude Code isn\'t installed yet.');
      console.log('📝 Agents will be ready when Claude Code is installed.');
    }

    // Ensure Claude Code agents directory exists
    await fs.ensureDir(claudeAgentsDir);
    console.log(`✅ Claude agents directory ready: ${claudeAgentsDir}`);

    // Find all agent files to copy
    const packageRoot = path.join(__dirname, '..');
    const agentSources = [
      { dir: path.join(packageRoot, 'agents'), prefix: '' },
      { dir: path.join(packageRoot, 'agents', 'orchestration'), prefix: '' },
      { dir: path.join(packageRoot, 'agents', 'language_agents'), prefix: '' }
    ];

    let totalCopied = 0;
    let totalSkipped = 0;

    for (const source of agentSources) {
      if (await fs.pathExists(source.dir)) {
        const files = await fs.readdir(source.dir);

        for (const file of files) {
          if (file.endsWith('.md')) {
            const sourcePath = path.join(source.dir, file);
            const targetPath = path.join(claudeAgentsDir, file);

            // Check if file already exists
            if (await fs.pathExists(targetPath) && !forceInstall) {
              console.log(`⏭️  Skipped ${file} (already exists)`);
              totalSkipped++;
            } else {
              await fs.copy(sourcePath, targetPath, { overwrite: true });
              console.log(`📋 Installed ${file}`);
              totalCopied++;
            }
          }
        }
      }
    }

    console.log(`\n✅ Agent installation complete:`);
    console.log(`   📋 Installed: ${totalCopied} agents`);
    if (totalSkipped > 0) {
      console.log(`   ⏭️  Skipped: ${totalSkipped} existing agents`);
      console.log(`   💡 Use --force flag to overwrite existing agents`);
    }

    // Make shell scripts executable (content management)
    const contentManagementDir = path.join(packageRoot, 'scripts', 'content-management');
    if (await fs.pathExists(contentManagementDir)) {
      const shellScripts = await fs.readdir(contentManagementDir);
      for (const script of shellScripts) {
        if (script.endsWith('.sh')) {
          const scriptPath = path.join(contentManagementDir, script);
          await fs.chmod(scriptPath, 0o755);
        }
      }
      console.log('✅ Content management scripts ready');
    }

    // Make development scripts executable
    const developmentDir = path.join(packageRoot, 'scripts', 'development');
    if (await fs.pathExists(developmentDir)) {
      const shellScripts = await fs.readdir(developmentDir);
      for (const script of shellScripts) {
        if (script.endsWith('.sh')) {
          const scriptPath = path.join(developmentDir, script);
          await fs.chmod(scriptPath, 0o755);
        }
      }
      console.log('✅ Development scripts ready');
    }

    // Create content directories in current working directory
    const currentDir = process.cwd();
    const contentDir = path.join(currentDir, 'content');
    const contentSubdirs = ['blog', 'news', 'series', 'social', 'swiss', 'tutorials', 'whitepapers'];

    console.log(`\n📁 Setting up content directories in: ${contentDir}`);

    for (const subdir of contentSubdirs) {
      const dirPath = path.join(contentDir, subdir);
      await fs.ensureDir(dirPath);

      // Create .gitkeep files if they don't exist
      const gitkeepPath = path.join(dirPath, '.gitkeep');
      if (!await fs.pathExists(gitkeepPath)) {
        await fs.writeFile(gitkeepPath, '');
      }
    }

    console.log('✅ Content directories created');

    // Copy content .gitkeep structure if it doesn't exist
    const packageContentDir = path.join(packageRoot, 'content');
    if (await fs.pathExists(packageContentDir) && !await fs.pathExists(contentDir)) {
      await fs.copy(packageContentDir, contentDir);
      console.log('✅ Content structure copied from package');
    }

    console.log('\n🎉 IntelliDoc Content Engine setup complete!');
    console.log('\n📊 Quick status check:');

    // Show quick stats
    const IntelliDocContentEngine = require('../index.js');
    const engine = new IntelliDocContentEngine();
    const stats = engine.getStats();

    console.log(`   🤖 Total agents: ${stats.totalAgents}`);
    console.log(`   🚀 Deployed: ${stats.installedAgents}`);
    console.log(`   💻 Claude Code: ${stats.claudeCodeInstalled ? 'Ready' : 'Install Claude Code to use agents'}`);

    console.log('\n🚀 Quick start:');
    console.log('   intellidoc status  - Check installation');
    console.log('   intellidoc list    - See all agents');
    console.log('   intellidoc verify  - Run verification tests');

    if (stats.claudeCodeInstalled && stats.installedAgents > 0) {
      console.log('\n🎭 Usage in Claude Code:');
      console.log('   /agent blog-post-orchestrator');
      console.log('   "Create a technical blog post about Docker"');

      console.log('\n🇨🇭 Swiss localization:');
      console.log('   /agent swiss-localization-orchestrator');
      console.log('   "Create multilingual content for Swiss market"');
    }

  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    console.error('💡 Try running with --force flag or check permissions');

    // Additional troubleshooting info
    console.error('\n🔍 Troubleshooting:');
    console.error('   • Ensure Claude Code is installed');
    console.error('   • Check directory permissions');
    console.error('   • Try: sudo npm install -g intellidoc-content-engine');

    process.exit(1);
  }
}

// Run setup if called directly or via npm postinstall
if (require.main === module || process.env.npm_lifecycle_event === 'postinstall') {
  setupAgents();
}

module.exports = setupAgents;