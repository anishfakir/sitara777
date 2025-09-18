# Sitara777 Admin Panel - Render Deployment Guide

## Prerequisites
1. A Render account (sign up at https://render.com)
2. A GitHub account
3. Git installed on your local machine

## Deployment Steps

### 1. Prepare Your Repository
1. Ensure your code is committed and pushed to a GitHub repository
2. The repository should have the following structure:
   ```
   your-repo/
   ├── sitara777-admin-backend/
   │   ├── package.json
   │   ├── server.js
   │   ├── render.yaml
   │   └── ...
   └── sitara777-admin-frontend/
       ├── package.json
       └── ...
   ```

### 2. Deploy the Backend API
1. Go to https://dashboard.render.com
2. Click "New" and select "Web Service"
3. Connect your GitHub repository
4. Configure the service:
   - **Name**: sitara777-admin-backend
   - **Environment**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free (or choose a paid plan for production)

5. Add environment variables:
   - `NODE_ENV`: production
   - `PORT`: 5000
   - `JWT_SECRET`: [Generate a strong secret key]

6. Click "Create Web Service"

### 3. Deploy the Frontend
1. While the backend is deploying, create another web service:
2. Click "New" and select "Static Site"
3. Use the same repository
4. Configure the service:
   - **Name**: sitara777-admin-frontend
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `build`

5. Add environment variables:
   - `REACT_APP_API_URL`: [URL of your deployed backend, e.g., https://sitara777-admin-backend.onrender.com]

6. Click "Create Static Site"

### 4. Update Environment Variables
After both services are created:
1. Go to your backend service in the Render dashboard
2. Click "Environment" in the sidebar
3. Make sure all required environment variables are set
4. Do the same for the frontend service

### 5. Test Your Deployment
1. Once both services show "Live" status, visit your frontend URL
2. The admin panel should load and be able to communicate with the backend
3. Test login with the default credentials:
   - Email: admin@example.com
   - Password: admin123

## Environment Variables

### Backend (.env)
```env
NODE_ENV=production
PORT=5000
JWT_SECRET=your-super-secret-jwt-key-here
LOG_LEVEL=info
BCRYPT_SALT_ROUNDS=12
```

### Frontend (.env)
```env
REACT_APP_API_URL=https://your-backend-url.onrender.com
```

## Auto-Deployment
Render automatically re-deploys your services whenever you push changes to the connected GitHub repository branch.

## Custom Domain (Optional)
1. In the Render dashboard, go to your service
2. Click on "Settings"
3. Scroll to "Custom Domains"
4. Add your domain and follow the DNS instructions

## Troubleshooting

### Common Issues:
1. **CORS Errors**: Ensure your frontend URL is correctly set in the `REACT_APP_API_URL` environment variable
2. **Build Failures**: Check the build logs in Render for dependency issues
3. **Application Errors**: Check the application logs in Render for runtime errors

### Support
For issues with this deployment configuration, please open an issue on your GitHub repository.