#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('🔍 Verifying Sitara777 Admin Panel Deployment Setup...\n');

// Check if we're in the right directory
const projectRoot = path.resolve(__dirname);
console.log(`📁 Project root: ${projectRoot}`);

const backendDir = path.join(projectRoot, 'sitara777-admin-backend');
const frontendDir = path.join(projectRoot, 'sitara777-admin-frontend');

let success = true;

// Check directories exist
if (!fs.existsSync(backendDir)) {
  console.error('❌ sitara777-admin-backend directory not found');
  success = false;
} else {
  console.log('✅ sitara777-admin-backend directory found');
}

if (!fs.existsSync(frontendDir)) {
  console.error('❌ sitara777-admin-frontend directory not found');
  success = false;
} else {
  console.log('✅ sitara777-admin-frontend directory found');
}

// Check backend files
if (fs.existsSync(backendDir)) {
  const backendFiles = [
    'package.json',
    'render.yaml',
    'server.js'
  ];
  
  backendFiles.forEach(file => {
    const filePath = path.join(backendDir, file);
    if (fs.existsSync(filePath)) {
      console.log(`✅ ${file} found`);
    } else {
      console.error(`❌ ${file} not found`);
      success = false;
    }
  });
}

// Check frontend files
if (fs.existsSync(frontendDir)) {
  const frontendFiles = [
    'package.json',
    'public/index.html'
  ];
  
  frontendFiles.forEach(file => {
    const filePath = path.join(frontendDir, file);
    if (fs.existsSync(filePath)) {
      console.log(`✅ ${file} found`);
    } else {
      console.error(`❌ ${file} not found`);
      success = false;
    }
  });
}

// Check deployment files
const deploymentFiles = [
  'deploy_to_render.js',
  'deploy_to_render.bat',
  'deploy_to_render.sh',
  'AUTOMATIC_DEPLOYMENT_GUIDE.md',
  'DEPLOYMENT_SUMMARY.md'
];

deploymentFiles.forEach(file => {
  const filePath = path.join(projectRoot, file);
  if (fs.existsSync(filePath)) {
    console.log(`✅ ${file} found`);
  } else {
    console.error(`❌ ${file} not found`);
    success = false;
  }
});

// Final result
console.log('\n' + '='.repeat(50));
if (success) {
  console.log('🎉 All deployment files are properly set up!');
  console.log('\n🚀 To deploy automatically to Render:');
  console.log('   1. Initialize a git repository');
  console.log('   2. Connect to GitHub');
  console.log('   3. Use the Render blueprint with render.yaml');
  console.log('   4. Refer to AUTOMATIC_DEPLOYMENT_GUIDE.md for detailed instructions');
} else {
  console.log('❌ Some deployment files are missing or incorrectly configured');
  console.log('   Please check the errors above and ensure all files are present');
}
console.log('='.repeat(50));