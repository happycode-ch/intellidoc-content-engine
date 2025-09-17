#!/usr/bin/env node

const path = require('path');
const fs = require('fs');

class IntelliDocContentEngine {
  constructor() {
    this.agentsPath = path.join(__dirname, 'agents');
    this.claudeAgentsPath = path.join(process.env.HOME || process.env.USERPROFILE, '.claude', 'agents');
    this.version = '1.0.0';
  }

  getAvailableAgents() {
    try {
      const agentFiles = [];

      // Scan main agents directory
      if (fs.existsSync(this.agentsPath)) {
        const mainAgents = fs.readdirSync(this.agentsPath)
          .filter(file => file.endsWith('.md'))
          .map(file => file.replace('.md', ''));
        agentFiles.push(...mainAgents);
      }

      // Scan orchestration subdirectory
      const orchestrationPath = path.join(this.agentsPath, 'orchestration');
      if (fs.existsSync(orchestrationPath)) {
        const orchestrators = fs.readdirSync(orchestrationPath)
          .filter(file => file.endsWith('.md'))
          .map(file => file.replace('.md', ''));
        agentFiles.push(...orchestrators);
      }

      // Scan language_agents subdirectory
      const languagePath = path.join(this.agentsPath, 'language_agents');
      if (fs.existsSync(languagePath)) {
        const languageAgents = fs.readdirSync(languagePath)
          .filter(file => file.endsWith('.md'))
          .map(file => file.replace('.md', ''));
        agentFiles.push(...languageAgents);
      }

      return agentFiles.sort();
    } catch (error) {
      console.error('Error reading agents directory:', error.message);
      return [];
    }
  }

  getAgentInfo(agentName) {
    const possiblePaths = [
      path.join(this.agentsPath, `${agentName}.md`),
      path.join(this.agentsPath, 'orchestration', `${agentName}.md`),
      path.join(this.agentsPath, 'language_agents', `${agentName}.md`)
    ];

    for (const agentPath of possiblePaths) {
      if (fs.existsSync(agentPath)) {
        try {
          const content = fs.readFileSync(agentPath, 'utf8');
          const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);

          if (yamlMatch) {
            const yaml = require('yaml');
            const agentInfo = yaml.parse(yamlMatch[1]);
            agentInfo.path = agentPath;
            return agentInfo;
          }

          return { path: agentPath };
        } catch (error) {
          throw new Error(`Error reading agent ${agentName}: ${error.message}`);
        }
      }
    }

    throw new Error(`Agent ${agentName} not found`);
  }

  isClaudeCodeInstalled() {
    const claudeDir = path.dirname(this.claudeAgentsPath);
    return fs.existsSync(claudeDir);
  }

  isInstalled() {
    return fs.existsSync(this.claudeAgentsPath);
  }

  getInstalledAgents() {
    if (!this.isInstalled()) return [];

    try {
      return fs.readdirSync(this.claudeAgentsPath)
        .filter(file => file.endsWith('.md'))
        .map(file => file.replace('.md', ''))
        .sort();
    } catch (error) {
      console.error('Error reading installed agents:', error.message);
      return [];
    }
  }

  getAgentsByCategory() {
    const agents = this.getAvailableAgents();
    const categories = {
      orchestrators: [],
      core: [],
      swiss: []
    };

    agents.forEach(agent => {
      try {
        const info = this.getAgentInfo(agent);
        if (agent.includes('swiss-')) {
          categories.swiss.push({ name: agent, ...info });
        } else if (agent.includes('orchestrator')) {
          categories.orchestrators.push({ name: agent, ...info });
        } else {
          categories.core.push({ name: agent, ...info });
        }
      } catch (error) {
        // Skip agents with read errors
        categories.core.push({ name: agent, error: error.message });
      }
    });

    return categories;
  }

  getStats() {
    const available = this.getAvailableAgents();
    const installed = this.getInstalledAgents();
    const categories = this.getAgentsByCategory();

    return {
      version: this.version,
      totalAgents: available.length,
      installedAgents: installed.length,
      orchestrators: categories.orchestrators.length,
      coreAgents: categories.core.length,
      swissAgents: categories.swiss.length,
      claudeCodeInstalled: this.isClaudeCodeInstalled(),
      agentsInstalled: this.isInstalled()
    };
  }
}

module.exports = IntelliDocContentEngine;

// CLI usage when run directly
if (require.main === module) {
  const engine = new IntelliDocContentEngine();
  const stats = engine.getStats();

  console.log('🤖 IntelliDoc Content Engine');
  console.log(`📊 Available agents: ${stats.totalAgents}`);
  console.log(`🎭 Orchestrators: ${stats.orchestrators}`);
  console.log(`🇨🇭 Swiss agents: ${stats.swissAgents}`);
  console.log(`💻 Claude Code: ${stats.claudeCodeInstalled ? 'Installed' : 'Not found'}`);
  console.log(`✅ Agents deployed: ${stats.installedAgents}/${stats.totalAgents}`);
  console.log('\nRun "intellidoc --help" for more options');
}