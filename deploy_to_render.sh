#!/bin/bash

echo "Sitara777 Admin Panel - Render Deployment Script"
echo "================================================="

echo "Checking Node.js installation..."
if ! command -v node &> /dev/null
then
    echo "Error: Node.js is not installed or not in PATH"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "Checking Git installation..."
if ! command -v git &> /dev/null
then
    echo "Error: Git is not installed or not in PATH"
    echo "Please install Git from https://git-scm.com/"
    exit 1
fi

echo "Running deployment preparation script..."
node deploy_to_render.js

if [ $? -eq 0 ]; then
    echo ""
    echo "Deployment preparation completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Push your code to GitHub"
    echo "2. Go to https://dashboard.render.com"
    echo "3. Create a new Blueprint service"
    echo "4. Connect your GitHub repository"
    echo "5. Select the render.yaml file"
    echo "6. Click Apply to deploy"
    echo ""
    echo "For detailed instructions, see AUTOMATIC_DEPLOYMENT_GUIDE.md"
else
    echo ""
    echo "Deployment preparation failed. Please check the error messages above."
    exit 1
fi