#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🚀 Starting Sitara777 Admin Panel Deployment to Render...');

// Check if we're in the right directory
const projectRoot = path.resolve(__dirname);
console.log(`Project root: ${projectRoot}`);

const backendDir = path.join(projectRoot, 'sitara777-admin-backend');
const frontendDir = path.join(projectRoot, 'sitara777-admin-frontend');

if (!fs.existsSync(backendDir) || !fs.existsSync(frontendDir)) {
  console.error('❌ Error: Could not find backend or frontend directories');
  process.exit(1);
}

console.log('✅ Found project directories');

// Function to execute command with error handling
function executeCommand(command, cwd) {
  try {
    console.log(`🔧 Executing: ${command}`);
    const output = execSync(command, { 
      cwd: cwd || projectRoot,
      stdio: 'inherit',
      encoding: 'utf-8'
    });
    return output;
  } catch (error) {
    console.error(`❌ Command failed: ${command}`);
    console.error(error.message);
    process.exit(1);
  }
}

// Check if Git is initialized
try {
  executeCommand('git status', projectRoot);
} catch (error) {
  console.log('🔧 Initializing Git repository...');
  executeCommand('git init', projectRoot);
  executeCommand('git add .', projectRoot);
  executeCommand('git commit -m "Initial commit for Sitara777 Admin Panel"', projectRoot);
}

// Check if repository is connected to GitHub
try {
  const remote = executeCommand('git remote -v', projectRoot);
  if (!remote || remote.trim() === '') {
    console.log('⚠️  No Git remote found. Please connect this repository to GitHub before deployment.');
    console.log('   Instructions:');
    console.log('   1. Create a new repository on GitHub');
    console.log('   2. Run: git remote add origin <your-github-repo-url>');
    console.log('   3. Run: git push -u origin main');
    process.exit(1);
  }
} catch (error) {
  console.log('⚠️  Git remote check failed. Please ensure your repository is connected to GitHub.');
  process.exit(1);
}

console.log('✅ Git repository is ready for deployment');

// Verify backend configuration
console.log('🔧 Verifying backend configuration...');
const backendPackagePath = path.join(backendDir, 'package.json');
if (!fs.existsSync(backendPackagePath)) {
  console.error('❌ Backend package.json not found');
  process.exit(1);
}

const backendPackage = JSON.parse(fs.readFileSync(backendPackagePath, 'utf8'));
if (!backendPackage.scripts || !backendPackage.scripts.start) {
  console.error('❌ Backend start script not found in package.json');
  process.exit(1);
}

// Verify frontend configuration
console.log('🔧 Verifying frontend configuration...');
const frontendPackagePath = path.join(frontendDir, 'package.json');
if (!fs.existsSync(frontendPackagePath)) {
  console.error('❌ Frontend package.json not found');
  process.exit(1);
}

const frontendPackage = JSON.parse(fs.readFileSync(frontendPackagePath, 'utf8'));
if (!frontendPackage.scripts || !frontendPackage.scripts.build) {
  console.error('❌ Frontend build script not found in package.json');
  process.exit(1);
}

console.log('✅ Both backend and frontend configurations are valid');

// Check for render.yaml
const renderYamlPath = path.join(backendDir, 'render.yaml');
if (!fs.existsSync(renderYamlPath)) {
  console.error('❌ render.yaml not found in backend directory');
  process.exit(1);
}

console.log('✅ render.yaml found');

// Check for environment variables
const envPath = path.join(backendDir, '.env');
if (!fs.existsSync(envPath)) {
  console.log('⚠️  No .env file found in backend. Creating a template...');
  const envTemplate = `NODE_ENV=production
PORT=5000
JWT_SECRET=your_jwt_secret_key_here
LOG_LEVEL=info
BCRYPT_SALT_ROUNDS=12`;
  fs.writeFileSync(envPath, envTemplate);
  console.log('✅ Created .env template. Please update with your actual values.');
}

// Instructions for deployment
console.log('\n📋 Deployment Instructions:');
console.log('1. Push your code to GitHub:');
console.log('   git add .');
console.log('   git commit -m "Deploy to Render"');
console.log('   git push origin main\n');

console.log('2. Go to https://dashboard.render.com');
console.log('3. Click "New" and select "Blueprint"');
console.log('4. Connect your GitHub repository');
console.log('5. Select the render.yaml file in the backend directory');
console.log('6. Click "Apply" to deploy both services\n');

console.log('✅ Deployment preparation complete!');
console.log('💡 For fully automated deployment, enable auto-deploy in Render dashboard');