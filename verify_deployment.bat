@echo off
REM Deployment verification script for Windows

echo Verifying Sitara777 Admin Panel deployment setup...

REM Check if required files exist
echo Checking for required files...
if not exist "sitara777-admin-backend\package.json" (
  echo ERROR: sitara777-admin-backend\package.json not found
  exit /b 1
)

if not exist "sitara777-admin-frontend\package.json" (
  echo ERROR: sitara777-admin-frontend\package.json not found
  exit /b 1
)

if not exist "sitara777-admin-backend\server.js" (
  echo ERROR: sitara777-admin-backend\server.js not found
  exit /b 1
)

if not exist "sitara777-admin-backend\render.yaml" (
  echo ERROR: sitara777-admin-backend\render.yaml not found
  exit /b 1
)

echo All required files found!

REM Check backend dependencies
echo Checking backend dependencies...
cd sitara777-admin-backend
npm list express cors dotenv helmet morgan bcryptjs jsonwebtoken joi winston >nul 2>&1
if %errorlevel% neq 0 (
  echo ERROR: Missing required backend dependencies
  cd ..
  exit /b 1
)
cd ..

REM Check frontend dependencies
echo Checking frontend dependencies...
cd sitara777-admin-frontend
npm list react react-dom react-router-dom @mui/material @emotion/react @emotion/styled >nul 2>&1
if %errorlevel% neq 0 (
  echo ERROR: Missing required frontend dependencies
  cd ..
  exit /b 1
)
cd ..

echo All dependencies verified!

REM Check for build scripts
echo Checking build scripts...
cd sitara777-admin-backend
npm run | findstr "start" >nul
if %errorlevel% neq 0 (
  echo ERROR: Backend start script not found
  cd ..
  exit /b 1
)
cd ..

cd sitara777-admin-frontend
npm run | findstr "build" >nul
if %errorlevel% neq 0 (
  echo ERROR: Frontend build script not found
  cd ..
  exit /b 1
)
cd ..

echo All build scripts verified!

echo Deployment verification completed successfully!
echo You can now deploy to Render using the render.yaml configuration.