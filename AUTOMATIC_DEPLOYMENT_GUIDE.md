# Sitara777 Admin Panel - Automatic Deployment to Render

This guide explains how to automatically deploy the Sitara777 Admin Panel to Render with minimal manual intervention.

## Prerequisites

1. Node.js installed on your local machine
2. A GitHub account
3. A Render account (free or paid)

## Automatic Deployment Process

### 1. Prepare Your Repository

```bash
# Navigate to your project directory
cd sitara777

# Initialize git if not already done
git init
git add .
git commit -m "Initial commit for Sitara777 Admin Panel"

# Connect to your GitHub repository
git remote add origin https://github.com/yourusername/sitara777.git
git branch -M main
git push -u origin main
```

### 2. Use the Automated Deployment Script

Run our deployment automation script:

```bash
node deploy_to_render.js
```

This script will:
- Verify your project structure
- Check Git configuration
- Validate backend and frontend configurations
- Ensure all necessary files are present

### 3. Deploy via Render Blueprint

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New" and select "Blueprint"
3. Connect your GitHub repository
4. Select the `render.yaml` file from the backend directory
5. Click "Apply" to automatically deploy both services

### 4. Configure Environment Variables

Render will automatically detect environment variables from your `render.yaml`. However, you should update the JWT secret:

1. In the Render dashboard, go to your backend service
2. Click on "Environment" in the sidebar
3. Update the `JWT_SECRET` value with a strong secret key

### 5. Enable Auto-Deployment

To enable automatic deployment on every git push:

1. In the Render dashboard, go to your service
2. Click on "Settings"
3. Scroll to "Auto-Deploy"
4. Select "Yes" for auto-deployment

## Deployment Architecture

The `render.yaml` blueprint automatically creates two services:

1. **Backend API** (Node.js + Express)
   - Environment: Node
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Port: 5000

2. **Frontend Web App** (React.js)
   - Environment: Static Site
   - Build Command: `npm install && npm run build`
   - Publish Directory: `build`

## Environment Variables

### Backend
- `NODE_ENV`: production
- `PORT`: 5000
- `JWT_SECRET`: Your JWT secret key (must be updated)

### Frontend
- `REACT_APP_API_URL`: Automatically set to your backend service URL

## Monitoring Deployment

1. View deployment logs in the Render dashboard
2. Check service health with the `/api/health` endpoint
3. Monitor performance metrics in Render

## Updating Your Application

To update your deployed application:

1. Make changes to your code
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "Update application"
   git push origin main
   ```
3. Render will automatically deploy the changes

## Troubleshooting

### Common Issues

1. **Deployment fails**
   - Check the build logs in Render
   - Ensure all dependencies are in package.json
   - Verify the render.yaml file syntax

2. **Application not responding**
   - Check if services are running in Render
   - Verify environment variables
   - Check application logs

3. **CORS errors**
   - Ensure your frontend URL is in the CORS configuration

### Getting Help

If you encounter issues:
1. Check Render logs for error messages
2. Verify all environment variables are correctly set
3. Check the Render documentation: https://render.com/docs

## Support

For issues with this deployment configuration, please open an issue on the GitHub repository.