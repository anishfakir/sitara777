#!/bin/bash
# Deployment verification script

echo "Verifying Sitara777 Admin Panel deployment setup..."

# Check if required files exist
echo "Checking for required files..."
if [ ! -f "sitara777-admin-backend/package.json" ]; then
  echo "ERROR: sitara777-admin-backend/package.json not found"
  exit 1
fi

if [ ! -f "sitara777-admin-frontend/package.json" ]; then
  echo "ERROR: sitara777-admin-frontend/package.json not found"
  exit 1
fi

if [ ! -f "sitara777-admin-backend/server.js" ]; then
  echo "ERROR: sitara777-admin-backend/server.js not found"
  exit 1
fi

if [ ! -f "sitara777-admin-backend/render.yaml" ]; then
  echo "ERROR: sitara777-admin-backend/render.yaml not found"
  exit 1
fi

echo "All required files found!"

# Check backend dependencies
echo "Checking backend dependencies..."
cd sitara777-admin-backend
if ! npm list express cors dotenv helmet morgan bcryptjs jsonwebtoken joi winston > /dev/null 2>&1; then
  echo "ERROR: Missing required backend dependencies"
  exit 1
fi
cd ..

# Check frontend dependencies
echo "Checking frontend dependencies..."
cd sitara777-admin-frontend
if ! npm list react react-dom react-router-dom @mui/material @emotion/react @emotion/styled > /dev/null 2>&1; then
  echo "ERROR: Missing required frontend dependencies"
  exit 1
fi
cd ..

echo "All dependencies verified!"

# Check for build scripts
echo "Checking build scripts..."
cd sitara777-admin-backend
if ! npm run | grep -q "start"; then
  echo "ERROR: Backend start script not found"
  exit 1
fi
cd ..

cd sitara777-admin-frontend
if ! npm run | grep -q "build"; then
  echo "ERROR: Frontend build script not found"
  exit 1
fi
cd ..

echo "All build scripts verified!"

echo "Deployment verification completed successfully!"
echo "You can now deploy to Render using the render.yaml configuration."