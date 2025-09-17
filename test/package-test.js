#!/usr/bin/env node

const fs = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');

// Test the IntelliDoc Content Engine package
async function runTests() {
  console.log('🧪 Running IntelliDoc Content Engine Package Tests\n');

  let passed = 0;
  let failed = 0;

  function test(name, fn) {
    try {
      const result = fn();
      if (result) {
        console.log(`✅ ${name}`);
        passed++;
      } else {
        console.log(`❌ ${name}`);
        failed++;
      }
    } catch (error) {
      console.log(`❌ ${name} - Error: ${error.message}`);
      failed++;
    }
  }

  // Test 1: Package.json exists and is valid
  test('package.json exists and is valid', () => {
    const packagePath = path.join(__dirname, '..', 'package.json');
    if (!fs.existsSync(packagePath)) return false;

    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    return pkg.name === 'intellidoc-content-engine' &&
           pkg.version === '1.0.0' &&
           pkg.bin &&
           pkg.bin.intellidoc;
  });

  // Test 2: Main entry point exists
  test('index.js main entry point exists', () => {
    const indexPath = path.join(__dirname, '..', 'index.js');
    return fs.existsSync(indexPath);
  });

  // Test 3: CLI exists and is executable
  test('CLI exists and is executable', () => {
    const cliPath = path.join(__dirname, '..', 'bin', 'cli.js');
    if (!fs.existsSync(cliPath)) return false;

    const stats = fs.statSync(cliPath);
    return (stats.mode & parseInt('111', 8)) !== 0; // Check if executable
  });

  // Test 4: Setup script exists
  test('Setup script exists', () => {
    const setupPath = path.join(__dirname, '..', 'scripts', 'setup-agents.js');
    return fs.existsSync(setupPath);
  });

  // Test 5: Agent directories exist
  test('Agent directories structure exists', () => {
    const agentsPath = path.join(__dirname, '..', 'agents');
    const orchestrationPath = path.join(agentsPath, 'orchestration');
    const languagePath = path.join(agentsPath, 'language_agents');

    return fs.existsSync(agentsPath) &&
           fs.existsSync(orchestrationPath) &&
           fs.existsSync(languagePath);
  });

  // Test 6: Required agent files exist
  test('Key agent files exist', () => {
    const agentsPath = path.join(__dirname, '..', 'agents');
    const keyAgents = [
      'body-writer.md',
      path.join('orchestration', 'blog-post-orchestrator.md'),
      path.join('language_agents', 'swiss-german-translator.md')
    ];

    return keyAgents.every(agent => {
      const agentPath = path.join(agentsPath, agent);
      return fs.existsSync(agentPath);
    });
  });

  // Test 7: IntelliDocContentEngine class works
  test('IntelliDocContentEngine class instantiates', () => {
    const IntelliDocContentEngine = require('../index.js');
    const engine = new IntelliDocContentEngine();
    return engine && typeof engine.getAvailableAgents === 'function';
  });

  // Test 8: Can read available agents
  test('Can read available agents', () => {
    const IntelliDocContentEngine = require('../index.js');
    const engine = new IntelliDocContentEngine();
    const agents = engine.getAvailableAgents();
    return Array.isArray(agents) && agents.length > 50; // Should have 54+ agents
  });

  // Test 9: Can get agent stats
  test('Can get agent statistics', () => {
    const IntelliDocContentEngine = require('../index.js');
    const engine = new IntelliDocContentEngine();
    const stats = engine.getStats();
    return stats.totalAgents > 50 &&
           stats.orchestrators >= 6 &&
           stats.swissAgents >= 6;
  });

  // Test 10: Package files array is comprehensive
  test('Package files array includes all necessary files', () => {
    const packagePath = path.join(__dirname, '..', 'package.json');
    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    const files = pkg.files;

    const requiredPatterns = [
      'agents/**/*',
      'bin/**/*',
      'scripts/**/*',
      'docs/**/*'
    ];

    return requiredPatterns.every(pattern => files.includes(pattern));
  });

  // Test 11: NPM scripts are defined
  test('NPM scripts are properly defined', () => {
    const packagePath = path.join(__dirname, '..', 'package.json');
    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    const scripts = pkg.scripts;

    return scripts.postinstall &&
           scripts.setup &&
           scripts.verify &&
           scripts.test;
  });

  // Test 12: Dependencies are specified
  test('Required dependencies are specified', () => {
    const packagePath = path.join(__dirname, '..', 'package.json');
    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    const deps = pkg.dependencies;

    return deps.commander &&
           deps['fs-extra'] &&
           deps.yaml;
  });

  // Summary
  console.log(`\n📊 Test Summary:`);
  console.log(`   ✅ Passed: ${passed}`);
  console.log(`   ❌ Failed: ${failed}`);
  console.log(`   📈 Success Rate: ${Math.round((passed / (passed + failed)) * 100)}%`);

  if (failed === 0) {
    console.log('\n🎉 All tests passed! Package is ready for deployment.');
    process.exit(0);
  } else {
    console.log('\n⚠️  Some tests failed. Please fix issues before publishing.');
    process.exit(1);
  }
}

// Run tests if called directly
if (require.main === module) {
  runTests().catch(error => {
    console.error('❌ Test runner failed:', error.message);
    process.exit(1);
  });
}

module.exports = runTests;