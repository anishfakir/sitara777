# Sitara777 Admin Panel - Render Deployment

This guide explains how to deploy the Sitara777 Admin Panel on Render.

## Deployment Architecture

The application consists of two services:
1. **Backend API** (Node.js + Express)
2. **Frontend Web App** (React.js)

## Prerequisites

1. A Render account (free or paid)

## Deployment Steps

### 1. Fork the Repository

Fork this repository to your GitHub account.

### 2. Deploy to Render

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New" and select "Web Service"
3. Connect your GitHub repository
4. Configure the service:

#### Backend Service Configuration:
- **Name**: sitara777-admin-backend
- **Environment**: Node
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Plan**: Free or paid (depending on your needs)

#### Environment Variables for Backend:
Set the following environment variables in Render:
- `NODE_ENV`: production
- `PORT`: 5000
- `JWT_SECRET`: A strong secret key for JWT tokens

#### Frontend Service Configuration:
- **Name**: sitara777-admin-frontend
- **Environment**: Static Site
- **Build Command**: `npm install && npm run build`
- **Publish Directory**: `build`

#### Environment Variables for Frontend:
- `REACT_APP_API_URL`: The URL of your deployed backend (e.g., https://sitara777-admin-backend.onrender.com)

### 3. Deploy Services

1. Click "Create Web Service" for the backend
2. Wait for the deployment to complete
3. Create the frontend service using the same process

### 4. Configure Environment Variables

In the Render dashboard for each service:
1. Go to the service page
2. Click on "Environment" in the sidebar
3. Add all required environment variables

### 5. Set Up Custom Domain (Optional)

1. In the Render dashboard, go to your service
2. Click on "Settings"
3. Scroll to "Custom Domains"
4. Add your domain and follow the DNS instructions

## Environment Variables

### Backend (.env)
```env
NODE_ENV=production
PORT=5000
JWT_SECRET=your_jwt_secret_key
LOG_LEVEL=info
BCRYPT_SALT_ROUNDS=12
```

### Frontend (.env)
```env
REACT_APP_API_URL=https://your-backend-url.onrender.com
```

## Auto-Deployment

Render automatically re-deploys your application whenever you push changes to the connected GitHub repository.

## Monitoring and Logs

Render provides:
- Real-time logs
- Performance metrics
- Error tracking
- Uptime monitoring

Access these features through the Render dashboard.

## Scaling

Render automatically scales your services based on traffic. For production applications, consider upgrading to a paid plan for better performance and reliability.

## Troubleshooting

### Common Issues:

1. **CORS Errors**
   - Ensure your frontend URL is added to the CORS configuration in the backend

2. **Build Failures**
   - Check the build logs in Render
   - Ensure all dependencies are properly listed in package.json

### Getting Help

If you encounter issues:
1. Check the Render logs for error messages
2. Verify all environment variables are correctly set
3. Check the Render documentation: https://render.com/docs

## Support

For issues with this deployment configuration, please open an issue on the GitHub repository.