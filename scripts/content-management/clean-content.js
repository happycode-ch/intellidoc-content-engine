#!/usr/bin/env node
// File: scripts/content-management/clean-content.js
// Purpose: Node wrapper for clean-content.sh script
// Related: scripts/content-management/clean-content.sh, package.json
// AI-hints:
// - Wrapper script for NPM compatibility
// - Executes shell script via child_process
// - Part of NPM package scripts

const { execSync } = require('child_process');
const path = require('path');

// Get the shell script path
const scriptPath = path.join(__dirname, 'clean-content.sh');

try {
  // Execute the shell script
  execSync(`bash ${scriptPath}`, { stdio: 'inherit' });
} catch (error) {
  console.error('Error running clean-content.sh:', error.message);
  process.exit(1);
}