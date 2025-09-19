#!/usr/bin/env node
// File: scripts/development/verify-agents.js
// Purpose: Verify agent deployment and symlink integrity
// Related: agents/, .claude/agents/, package.json
// AI-hints:
// - Checks agent deployment status
// - Verifies symlinks are valid
// - Part of NPM package scripts

const fs = require('fs');
const path = require('path');

console.log('=== Agent Deployment Verification ===');
console.log('');

// Paths
const claudeAgentsDir = path.join(process.cwd(), '.claude', 'agents');
const sourceAgentsDir = path.join(process.cwd(), 'agents');

// Check .claude/agents directory
if (!fs.existsSync(claudeAgentsDir)) {
  console.error('❌ .claude/agents directory not found');
  process.exit(1);
}

// Count agents
const deployedAgents = fs.readdirSync(claudeAgentsDir)
  .filter(file => file.endsWith('.md') && file !== 'CLAUDE.md');

console.log(`Total agents in .claude/agents/: ${deployedAgents.length}`);

// Check symlinks
let validLinks = 0;
let brokenLinks = 0;

deployedAgents.forEach(agent => {
  const linkPath = path.join(claudeAgentsDir, agent);
  try {
    const stats = fs.lstatSync(linkPath);
    if (stats.isSymbolicLink()) {
      // Check if target exists
      try {
        fs.accessSync(linkPath);
        validLinks++;
      } catch {
        brokenLinks++;
        console.log(`  ❌ Broken link: ${agent}`);
      }
    }
  } catch (error) {
    console.error(`  ❌ Error checking ${agent}: ${error.message}`);
  }
});

console.log(`Valid symlinks: ${validLinks}`);
console.log(`Broken links: ${brokenLinks}`);
console.log('');

// Count source agents
const countSourceAgents = (dir) => {
  let count = 0;
  const files = fs.readdirSync(dir);

  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stats = fs.statSync(filePath);

    if (stats.isDirectory() && file !== '.archive') {
      count += countSourceAgents(filePath);
    } else if (file.endsWith('.md') && file !== 'CLAUDE.md' && file !== 'README.md') {
      count++;
    }
  });

  return count;
};

if (fs.existsSync(sourceAgentsDir)) {
  const sourceCount = countSourceAgents(sourceAgentsDir);
  console.log(`Source agents in agents/: ${sourceCount}`);
}

// Model distribution
console.log('');
console.log('Model Distribution:');

const modelCounts = { opus: 0, sonnet: 0, haiku: 0 };

deployedAgents.forEach(agent => {
  const agentPath = path.join(claudeAgentsDir, agent);
  try {
    const content = fs.readFileSync(agentPath, 'utf8');
    if (content.includes('model: opus')) modelCounts.opus++;
    else if (content.includes('model: sonnet')) modelCounts.sonnet++;
    else if (content.includes('model: haiku')) modelCounts.haiku++;
  } catch (error) {
    // Ignore read errors for broken symlinks
  }
});

console.log(`  Opus: ${modelCounts.opus}`);
console.log(`  Sonnet: ${modelCounts.sonnet}`);
console.log(`  Haiku: ${modelCounts.haiku}`);
console.log('');

// Check critical agents
const criticalAgents = [
  'content-assembler.md',
  'body-writer.md',
  'source-gatherer.md',
  'keyword-researcher.md'
];

console.log('Critical agents check:');
criticalAgents.forEach(agent => {
  const agentPath = path.join(claudeAgentsDir, agent);
  if (fs.existsSync(agentPath)) {
    console.log(`  ✓ ${agent} exists`);
  } else {
    console.log(`  ✗ ${agent} missing!`);
  }
});

console.log('');
console.log('=== Verification Complete ===');

// Exit with error if there are broken links
if (brokenLinks > 0) {
  process.exit(1);
}