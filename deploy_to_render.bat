@echo off
echo Sitara777 Admin Panel - Render Deployment Script
echo =================================================

echo Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Checking Git installation...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed or not in PATH
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

echo Running deployment preparation script...
node deploy_to_render.js

if %errorlevel% equ 0 (
    echo.
    echo Deployment preparation completed successfully!
    echo.
    echo Next steps:
    echo 1. Push your code to GitHub
    echo 2. Go to https://dashboard.render.com
    echo 3. Create a new Blueprint service
    echo 4. Connect your GitHub repository
    echo 5. Select the render.yaml file
    echo 6. Click Apply to deploy
    echo.
    echo For detailed instructions, see AUTOMATIC_DEPLOYMENT_GUIDE.md
) else (
    echo.
    echo Deployment preparation failed. Please check the error messages above.
)

pause