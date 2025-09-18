# Sitara777 Admin Panel - Backend

Professional admin panel backend for the Sitara777 betting platform, built with Node.js and Express.

## Features

- **Admin Authentication**: Secure JWT-based authentication
- **User Management**: View, update, and manage platform users
- **Game Management**: Create and manage betting games
- **Bet Management**: Monitor and process user bets
- **Payment Processing**: Handle recharge and withdrawal requests
- **Results Management**: Declare game results
- **Wallet Operations**: Manage user wallet balances
- **Dashboard**: Analytics and overview of platform metrics
- **Security**: Helmet, CORS, input validation, and rate limiting

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Authentication**: JWT, bcryptjs
- **Validation**: Joi
- **Security**: Helmet, CORS, Morgan
- **Logging**: Winston
- **Testing**: Jest, Supertest

## Project Structure

```
src/
├── controllers/     # Request handlers
├── middleware/      # Custom middleware
├── routes/          # API routes
├── utils/           # Utility functions
└── validations/     # Input validation schemas
```

## Setup Instructions

### Prerequisites

- Node.js (v14 or later)
- npm or yarn

### Installation

1. **Navigate to backend directory**
   ```bash
   cd sitara777-admin-backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Variables**
   Create a `.env` file in the root directory:
   ```env
   NODE_ENV=development
   PORT=5000
   JWT_SECRET=your_jwt_secret_key
   LOG_LEVEL=info
   BCRYPT_SALT_ROUNDS=12
   ```

4. **Start the development server**
   ```bash
   npm run dev
   ```

5. **For production**
   ```bash
   npm start
   ```

## API Endpoints

### Authentication
- `POST /api/auth/login` - Admin login
- `POST /api/auth/logout` - Admin logout
- `GET /api/auth/profile` - Get admin profile

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Games
- `GET /api/games` - Get all games
- `POST /api/games` - Create new game
- `PUT /api/games/:id` - Update game
- `DELETE /api/games/:id` - Delete game

### Bets
- `GET /api/bets` - Get all bets
- `GET /api/bets/:id` - Get bet by ID
- `PUT /api/bets/:id` - Update bet status

### Results
- `GET /api/results` - Get all results
- `POST /api/results` - Declare new result
- `PUT /api/results/:id` - Update result

### Transactions
- `GET /api/transactions` - Get all transactions
- `PUT /api/transactions/:id` - Update transaction status

### Dashboard
- `GET /api/dashboard/stats` - Get dashboard statistics
- `GET /api/dashboard/charts` - Get chart data

## Testing

Run the test suite:
```bash
npm test
```

## Deployment

### Render Deployment

This application is configured for deployment to Render using the `render.yaml` blueprint:

1. Push code to GitHub
2. Create a new Blueprint service in Render
3. Connect your GitHub repository
4. Select the `render.yaml` file
5. Deploy

### Environment Variables for Production

- `NODE_ENV`: production
- `PORT`: 5000
- `JWT_SECRET`: Strong secret key

## Security Considerations

- All API endpoints are protected with JWT authentication
- Input validation on all routes
- Helmet for security headers
- CORS configured for frontend domain
- Rate limiting (to be implemented)
- Passwords hashed with bcrypt

## License

This project is proprietary to Sitara777 and should not be distributed without permission.