# Sitara777 Admin Panel - Frontend

Professional admin panel frontend for the Sitara777 betting platform, built with React.js and Material-UI.

## Features

- **Modern UI**: Clean, responsive design with Material-UI components
- **Dashboard**: Analytics and overview of platform metrics
- **User Management**: View, update, and manage platform users
- **Game Management**: Create and manage betting games
- **Bet Management**: Monitor and process user bets
- **Payment Processing**: Handle recharge and withdrawal requests
- **Results Management**: Declare game results
- **Wallet Operations**: Manage user wallet balances
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Dark Theme**: Professional dark sidebar with accent colors

## Tech Stack

- **Framework**: React.js (v18+)
- **UI Library**: Material-UI (MUI)
- **Routing**: React Router v6
- **Charts**: Chart.js with react-chartjs-2
- **Data Grid**: MUI X Data Grid
- **HTTP Client**: Axios
- **Build Tool**: React Scripts (Create React App)

## Project Structure

```
src/
├── components/      # Reusable UI components
├── pages/           # Page components
├── services/        # API service layer
├── utils/           # Utility functions
└── App.js           # Main app component
```

## Setup Instructions

### Prerequisites

- Node.js (v14 or later)
- npm or yarn

### Installation

1. **Navigate to frontend directory**
   ```bash
   cd sitara777-admin-frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Variables**
   Create a `.env` file in the root directory:
   ```env
   REACT_APP_API_URL=http://localhost:5000
   ```

4. **Start the development server**
   ```bash
   npm start
   ```

5. **Build for production**
   ```bash
   npm run build
   ```

## Development

### Available Scripts

- `npm start` - Runs the app in development mode
- `npm run build` - Builds the app for production
- `npm test` - Runs the test suite
- `npm run eject` - Ejects the Create React App configuration

### Folder Structure

```
src/
├── components/
│   ├── Header.js
│   ├── Sidebar.js
│   ├── Dashboard.js
│   └── ...
├── pages/
│   ├── DashboardPage.js
│   ├── UsersPage.js
│   ├── GamesPage.js
│   ├── BetsPage.js
│   ├── PaymentsPage.js
│   ├── ResultsPage.js
│   ├── WalletPage.js
│   └── LoginPage.js
├── services/
│   └── api.js
└── utils/
    └── auth.js
```

## Deployment

### Render Deployment

This application is configured for deployment to Render as a static site:

1. Build the application: `npm run build`
2. Deploy the `build/` directory as a static site
3. Set the `REACT_APP_API_URL` environment variable to your backend URL

### Environment Variables for Production

- `REACT_APP_API_URL`: The URL of your deployed backend API

## Customization

### Theme

The application uses a custom Material-UI theme with:
- Dark sidebar
- Accent color: #FFD600
- White backgrounds
- Smooth elevation and shadows

### Responsive Design

The application is fully responsive and works on:
- Desktop browsers
- Tablet devices
- Mobile phones

Media queries are used for different screen sizes:
- Large screens: > 1200px
- Medium screens: 960px - 1200px
- Small screens: 600px - 960px
- Extra small screens: < 600px

## API Integration

The frontend communicates with the backend API through:
- Axios HTTP client
- JWT token authentication
- Error handling and loading states

### Base URL Configuration

The API base URL is configured through the `REACT_APP_API_URL` environment variable.

## Security Considerations

- All API requests include JWT authentication tokens
- Input validation on forms
- Protected routes for authenticated users only
- Secure storage of authentication tokens

## License

This project is proprietary to Sitara777 and should not be distributed without permission.