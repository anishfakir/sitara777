/*
SITARA777 FIREBASE REALTIME DATABASE STRUCTURE
==============================================

This file documents the complete Firebase Realtime Database structure
for real-time synchronization between Flutter app and Admin Panel.

Database URL: https://sitara777-admin-api-default-rtdb.asia-southeast1.firebasedatabase.app

ROOT STRUCTURE:
{
  "users": {
    "userId": {
      "profile": { ... },
      "wallet": { ... },
      "bids": { ... },
      "transactions": { ... }
    }
  },
  "games": {
    "gameId": { ... }
  },
  "results": {
    "resultId": { ... }
  },
  "transactions": {
    "transactionId": { ... }
  },
  "bids": {
    "bidId": { ... }
  },
  "recharges": {
    "rechargeId": { ... }
  },
  "withdrawals": {
    "withdrawalId": { ... }
  },
  "app_settings": { ... },
  "notifications": { ... }
}

DETAILED STRUCTURE:
*/

class FirebaseDatabaseStructure {
  // Root paths
  static const String users = 'users';
  static const String bazaars = 'bazaars';
  static const String games = 'games';
  static const String bets = 'bets';
  static const String results = 'results';
  static const String transactions = 'transactions';
  static const String bids = 'bids';
  static const String recharges = 'recharges';
  static const String withdrawals = 'withdrawals';
  static const String appSettings = 'app_settings';
  static const String notifications = 'notifications';

  // User structure
  static const String userProfile = 'profile';
  static const String userWallet = 'wallet';
  static const String userBids = 'bids';
  static const String userTransactions = 'transactions';
  static const String userSettings = 'settings';

  /*
  USERS STRUCTURE:
  {
    "users": {
      "userId": {
        "profile": {
          "uid": "string",
          "name": "string",
          "phone": "string",
          "email": "string (optional)",
          "avatar": "string (optional)",
          "createdAt": timestamp,
          "lastLogin": timestamp,
          "isActive": boolean,
          "deviceToken": "string (for notifications)"
        },
        "wallet": {
          "balance": number,
          "totalDeposited": number,
          "totalWithdrawn": number,
          "totalWinnings": number,
          "totalLosses": number,
          "lastUpdated": timestamp,
          "updatedBy": "string (admin/system)"
        },
        "bids": {
          "bidId": {
            "gameId": "string",
            "gameName": "string",
            "betType": "string",
            "betNumber": "string/number",
            "amount": number,
            "potentialWin": number,
            "status": "pending/won/lost",
            "placedAt": timestamp,
            "resultAt": timestamp (optional),
            "result": "string (optional)"
          }
        },
        "transactions": {
          "transactionId": {
            "type": "recharge/withdrawal/bet/win/loss",
            "amount": number,
            "description": "string",
            "status": "pending/approved/rejected/completed",
            "createdAt": timestamp,
            "processedAt": timestamp (optional),
            "processedBy": "string (optional)"
          }
        },
        "settings": {
          "notifications": boolean,
          "language": "string",
          "timezone": "string"
        }
      }
    }
  }

  GAMES STRUCTURE:
  {
    "games": {
      "gameId": {
        "name": "string",
        "displayName": "string",
        "description": "string",
        "type": "matka/casino/lottery",
        "category": "string",
        "icon": "string (url or asset)",
        "banner": "string (url)",
        "isActive": boolean,
        "openTime": "HH:mm",
        "closeTime": "HH:mm",
        "resultTime": "HH:mm",
        "betTypes": {
          "betTypeId": {
            "name": "string",
            "displayName": "string",
            "minBet": number,
            "maxBet": number,
            "winMultiplier": number,
            "isActive": boolean
          }
        },
        "rates": {
          "single": number,
          "jodi": number,
          "patti": number,
          "halfSangam": number,
          "fullSangam": number
        },
        "createdAt": timestamp,
        "updatedAt": timestamp,
        "createdBy": "string"
      }
    }
  }

  RESULTS STRUCTURE:
  {
    "results": {
      "resultId": {
        "gameId": "string",
        "gameName": "string",
        "date": "YYYY-MM-DD",
        "session": "open/close",
        "result": "string/number",
        "openPatti": "string (optional)",
        "closePatti": "string (optional)",
        "jodi": "string (optional)",
        "declaredAt": timestamp,
        "declaredBy": "string",
        "isVerified": boolean,
        "winningBids": ["bidId1", "bidId2"],
        "totalWinAmount": number,
        "totalBidAmount": number
      }
    }
  }

  TRANSACTIONS STRUCTURE:
  {
    "transactions": {
      "transactionId": {
        "userId": "string",
        "userName": "string",
        "userPhone": "string",
        "type": "recharge/withdrawal/bet_placed/bet_won/bet_lost/admin_credit/admin_debit",
        "amount": number,
        "previousBalance": number,
        "newBalance": number,
        "description": "string",
        "reference": "string (bidId/rechargeId/withdrawalId)",
        "status": "pending/approved/rejected/completed/failed",
        "paymentMethod": "string (optional)",
        "gatewayResponse": "object (optional)",
        "createdAt": timestamp,
        "processedAt": timestamp (optional),
        "processedBy": "string (optional)",
        "adminNotes": "string (optional)"
      }
    }
  }

  BIDS STRUCTURE:
  {
    "bids": {
      "bidId": {
        "userId": "string",
        "userName": "string",
        "userPhone": "string",
        "gameId": "string",
        "gameName": "string",
        "betType": "string",
        "betNumber": "string",
        "amount": number,
        "potentialWin": number,
        "winMultiplier": number,
        "session": "open/close/full",
        "date": "YYYY-MM-DD",
        "status": "pending/won/lost/cancelled",
        "placedAt": timestamp,
        "resultDeclaredAt": timestamp (optional),
        "result": "string (optional)",
        "winAmount": number (optional),
        "transactionId": "string"
      }
    }
  }

  RECHARGES STRUCTURE:
  {
    "recharges": {
      "rechargeId": {
        "userId": "string",
        "userName": "string",
        "userPhone": "string",
        "amount": number,
        "paymentMethod": "upi/paytm/phonepe/googlepay/bank_transfer",
        "paymentDetails": {
          "upiId": "string (optional)",
          "transactionId": "string (optional)",
          "screenshot": "string (optional)"
        },
        "status": "pending/approved/rejected",
        "requestedAt": timestamp,
        "processedAt": timestamp (optional),
        "processedBy": "string (optional)",
        "adminNotes": "string (optional)",
        "transactionId": "string (optional)"
      }
    }
  }

  WITHDRAWALS STRUCTURE:
  {
    "withdrawals": {
      "withdrawalId": {
        "userId": "string",
        "userName": "string",
        "userPhone": "string",
        "amount": number,
        "withdrawalMethod": "bank_transfer/upi/paytm",
        "accountDetails": {
          "accountNumber": "string (optional)",
          "ifscCode": "string (optional)",
          "accountHolderName": "string (optional)",
          "upiId": "string (optional)"
        },
        "status": "pending/approved/rejected/processed",
        "requestedAt": timestamp,
        "processedAt": timestamp (optional),
        "processedBy": "string (optional)",
        "adminNotes": "string (optional)",
        "transactionId": "string (optional)"
      }
    }
  }

  APP_SETTINGS STRUCTURE:
  {
    "app_settings": {
      "general": {
        "appName": "Sitara777",
        "appVersion": "1.0.0",
        "maintenanceMode": boolean,
        "maintenanceMessage": "string",
        "minAppVersion": "string",
        "forceUpdate": boolean
      },
      "betting": {
        "minBetAmount": number,
        "maxBetAmount": number,
        "maxDailyBet": number,
        "bettingEnabled": boolean,
        "autoResultDeclaration": boolean
      },
      "wallet": {
        "minRechargeAmount": number,
        "maxRechargeAmount": number,
        "minWithdrawalAmount": number,
        "maxWithdrawalAmount": number,
        "maxDailyWithdrawal": number,
        "withdrawalEnabled": boolean
      },
      "contact": {
        "supportPhone": "string",
        "supportEmail": "string",
        "whatsappNumber": "string",
        "telegramChannel": "string"
      },
      "payment": {
        "upiEnabled": boolean,
        "bankTransferEnabled": boolean,
        "supportedPaymentMethods": ["upi", "paytm", "phonepe"]
      }
    }
  }

  NOTIFICATIONS STRUCTURE:
  {
    "notifications": {
      "notificationId": {
        "title": "string",
        "message": "string",
        "type": "general/result/promotion/system",
        "targetUsers": "all/specific",
        "userIds": ["userId1", "userId2"] (optional),
        "imageUrl": "string (optional)",
        "actionType": "none/open_game/open_url",
        "actionData": "string (optional)",
        "isRead": boolean,
        "createdAt": timestamp,
        "createdBy": "string",
        "scheduledAt": timestamp (optional)
      }
    }
  }
  */
}

// Firebase Database paths helper class
class FirebasePathHelper {
  // User paths
  static String userPath(String userId) => 'users/$userId';
  static String userProfilePath(String userId) => 'users/$userId/profile';
  static String userWalletPath(String userId) => 'users/$userId/wallet';
  static String userBidsPath(String userId) => 'users/$userId/bids';
  static String userTransactionsPath(String userId) => 'users/$userId/transactions';
  static String userSettingsPath(String userId) => 'users/$userId/settings';
  
  // Game paths
  static String gamePath(String gameId) => 'games/$gameId';
  static String gameBetTypesPath(String gameId) => 'games/$gameId/betTypes';
  static String gameRatesPath(String gameId) => 'games/$gameId/rates';
  
  // Result paths
  static String resultPath(String resultId) => 'results/$resultId';
  static String gameResultsPath(String gameId) => 'results';
  
  // Transaction paths
  static String transactionPath(String transactionId) => 'transactions/$transactionId';
  static String userTransactionPath(String userId, String transactionId) => 'users/$userId/transactions/$transactionId';
  
  // Bid paths
  static String bidPath(String bidId) => 'bids/$bidId';
  static String userBidPath(String userId, String bidId) => 'users/$userId/bids/$bidId';
  static String gameBidsPath(String gameId) => 'bids';
  
  // Recharge paths
  static String rechargePath(String rechargeId) => 'recharges/$rechargeId';
  static String userRechargesPath(String userId) => 'recharges';
  
  // Withdrawal paths
  static String withdrawalPath(String withdrawalId) => 'withdrawals/$withdrawalId';
  static String userWithdrawalsPath(String userId) => 'withdrawals';
  
  // Settings paths
  static String appSettingsPath() => 'app_settings';
  static String generalSettingsPath() => 'app_settings/general';
  static String bettingSettingsPath() => 'app_settings/betting';
  static String walletSettingsPath() => 'app_settings/wallet';
  
  // Notification paths
  static String notificationPath(String notificationId) => 'notifications/$notificationId';
  static String userNotificationsPath(String userId) => 'notifications';
}


