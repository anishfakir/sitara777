# Sitara777 - Flutter Betting App

A comprehensive Flutter Android application for a betting/gaming platform with Firebase integration.

## Features

### 🔐 Authentication
- Firebase Phone OTP Authentication
- Secure user registration and login
- No hardcoded users - all managed through Firebase

### 💰 Wallet System
- Real-time wallet balance from Firebase Database
- Recharge and withdrawal request system
- Transaction history tracking
- Admin-managed balance updates

### 🎮 Gaming Platform
- Dynamic game loading from Firebase
- Real-time betting with various bet types
- Live game results and announcements
- Comprehensive bid history

### 📱 Modern UI/UX
- Material Design 3
- Responsive design for various screen sizes
- Smooth animations and transitions
- Clean and intuitive interface

### 🔔 Notifications
- Firebase Cloud Messaging integration
- Real-time result notifications
- Wallet update alerts
- Admin announcements

### 🌐 Offline Support
- Connectivity monitoring
- Graceful offline handling
- Auto-retry mechanisms

## Technical Stack

- **Framework**: Flutter 3.24.5
- **Backend**: Firebase (Authentication, Realtime Database, Cloud Messaging)
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Connectivity**: connectivity_plus
- **OTP Input**: pinput

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── game_model.dart
│   ├── bet_model.dart
│   └── transaction_model.dart
├── screens/                  # App screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── wallet_screen.dart
│   ├── recharge_screen.dart
│   ├── withdraw_screen.dart
│   ├── bid_history_screen.dart
│   └── results_screen.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── database_service.dart
│   └── notification_service.dart
├── utils/                    # Utilities
│   ├── error_handler.dart
│   └── connectivity_service.dart
└── widgets/                  # Reusable widgets
    └── app_drawer.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.24.5 or later)
- Android Studio or VS Code
- Firebase Project
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sitara777
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at https://console.firebase.google.com
   - Enable Authentication (Phone Authentication)
   - Enable Realtime Database
   - Enable Cloud Messaging
   - Download `google-services.json` and place in `android/app/`
   - Update `lib/firebase_options.dart` with your project configuration

4. **Android Configuration**
   - Update `android/app/build.gradle` with your package name
   - Update `android/app/src/main/AndroidManifest.xml` with proper permissions
   - Ensure minimum SDK is set to 21

5. **Run the app**
   ```bash
   flutter run
   ```

## Admin Panel

This project includes a professional admin panel for managing the betting platform:

### Backend
- **Technology**: Node.js with Express
- **Location**: `sitara777-admin-backend/`
- **Features**: User management, game management, bet processing, payment handling, results declaration

### Frontend
- **Technology**: React.js with Material-UI
- **Location**: `sitara777-admin-frontend/`
- **Features**: Dashboard, responsive design, dark theme with accent colors

### Automatic Deployment
For automatic deployment to Render:
1. Run the deployment script: `node deploy_to_render.js`
2. Follow the instructions in `AUTOMATIC_DEPLOYMENT_GUIDE.md`

See individual README files in each directory for detailed setup instructions.

## Firebase Database Structure

### Users
```json
{
  "users": {
    "userId": {
      "uid": "string",
      "phoneNumber": "string",
      "name": "string",
      "walletBalance": "number",
      "createdAt": "timestamp",
      "lastLogin": "timestamp",
      "isActive": "boolean"
    }
  }
}
```

### Games
```json
{
  "games": {
    "gameId": {
      "id": "string",
      "name": "string",
      "description": "string",
      "openTime": "timestamp",
      "closeTime": "timestamp",
      "isActive": "boolean",
      "betTypes": [
        {
          "id": "string",
          "name": "string",
          "minBet": "number",
          "maxBet": "number",
          "multiplier": "number",
          "isActive": "boolean"
        }
      ],
      "result": "string",
      "resultDeclaredAt": "timestamp"
    }
  }
}
```

### Bets
```json
{
  "bets": {
    "betId": {
      "id": "string",
      "userId": "string",
      "gameId": "string",
      "gameName": "string",
      "betTypeId": "string",
      "betTypeName": "string",
      "amount": "number",
      "betNumber": "string",
      "placedAt": "timestamp",
      "status": "pending|won|lost|cancelled",
      "winAmount": "number",
      "result": "string"
    }
  }
}
```

### Transactions
```json
{
  "transactions": {
    "transactionId": {
      "id": "string",
      "userId": "string",
      "type": "recharge|withdrawal|bet|win|refund",
      "amount": "number",
      "status": "pending|completed|rejected|failed",
      "createdAt": "timestamp",
      "processedAt": "timestamp",
      "description": "string",
      "adminNote": "string",
      "paymentMethod": "string",
      "referenceId": "string"
    }
  }
}
```

## Configuration Notes

### Firebase Security Rules
Update your Firebase Realtime Database rules for security:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "games": {
      ".read": "auth != null",
      ".write": false
    },
    "bets": {
      "$betId": {
        ".read": "auth != null && data.child('userId').val() === auth.uid",
        ".write": "auth != null && newData.child('userId').val() === auth.uid"
      }
    },
    "transactions": {
      "$transactionId": {
        ".read": "auth != null && data.child('userId').val() === auth.uid",
        ".write": "auth != null && newData.child('userId').val() === auth.uid"
      }
    }
  }
}
```

### Important Notes

1. **Demo Configuration**: The current Firebase configuration uses demo/placeholder values. You MUST replace these with your actual Firebase project credentials.

2. **Phone Authentication**: Ensure you have properly configured phone authentication in Firebase console and added your app's SHA-1 fingerprint.

3. **Admin Panel**: This app is designed for end users. You'll need to create a separate admin panel to manage games, process transactions, and declare results.

4. **Production Deployment**: Before production:
   - Replace all demo Firebase credentials
   - Implement proper error logging
   - Add analytics
   - Setup proper security rules
   - Configure proper signing certificates

## Dependencies

- `firebase_core`: Firebase SDK initialization
- `firebase_auth`: Authentication services
- `firebase_database`: Realtime Database
- `firebase_messaging`: Push notifications
- `provider`: State management
- `shared_preferences`: Local storage
- `pinput`: OTP input field
- `intl`: Internationalization
- `connectivity_plus`: Network connectivity

## License

This project is for demonstration purposes. Ensure compliance with local laws and regulations regarding betting/gaming applications.

## Support

For technical support or questions about the implementation, please refer to the code comments and documentation within the source files.