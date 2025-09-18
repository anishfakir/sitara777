import 'package:firebase_database/firebase_database.dart';
import 'user_wallet.dart';

class UserModel {
  final String uid;
  final UserProfile profile;
  final UserWallet wallet;
  final Map<String, UserBid> bids;
  final Map<String, UserTransaction> transactions;
  final UserSettings settings;

  UserModel({
    required this.uid,
    required this.profile,
    required this.wallet,
    this.bids = const {},
    this.transactions = const {},
    required this.settings,
  });

  // Getters for compatibility with existing screens
  String get name => profile.name;
  String get phoneNumber => profile.phone;
  double get walletBalance => wallet.balance;
  String get userId => uid; // Alias for compatibility

  factory UserModel.fromMap(String uid, Map<dynamic, dynamic> map) {
    return UserModel(
      uid: uid,
      profile: UserProfile.fromMap(map['profile'] ?? {}),
      wallet: UserWallet.fromMap(map['wallet'] ?? {}),
      bids: (map['bids'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key.toString(), UserBid.fromMap(value)),
          ) ??
          {},
      transactions: (map['transactions'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key.toString(), UserTransaction.fromMap(value)),
          ) ??
          {},
      settings: UserSettings.fromMap(map['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile': profile.toMap(),
      'wallet': wallet.toMap(),
      'bids': bids.map((key, value) => MapEntry(key, value.toMap())),
      'transactions': transactions.map((key, value) => MapEntry(key, value.toMap())),
      'settings': settings.toMap(),
    };
  }

  UserModel copyWith({
    UserProfile? profile,
    UserWallet? wallet,
    Map<String, UserBid>? bids,
    Map<String, UserTransaction>? transactions,
    UserSettings? settings,
  }) {
    return UserModel(
      uid: uid,
      profile: profile ?? this.profile,
      wallet: wallet ?? this.wallet,
      bids: bids ?? this.bids,
      transactions: transactions ?? this.transactions,
      settings: settings ?? this.settings,
    );
  }
}

class UserProfile {
  final String uid;
  final String name;
  final String phone;
  final String? email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final String? deviceToken;

  UserProfile({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.avatar,
    required this.createdAt,
    required this.lastLogin,
    this.isActive = true,
    this.deviceToken,
  });

  // Getter for compatibility
  DateTime get lastLoginAt => lastLogin;

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    return UserProfile(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      avatar: map['avatar']?.toString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      lastLogin: DateTime.fromMillisecondsSinceEpoch(map['lastLogin'] ?? DateTime.now().millisecondsSinceEpoch),
      isActive: map['isActive'] ?? true,
      deviceToken: map['deviceToken']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'isActive': isActive,
      'deviceToken': deviceToken,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatar,
    DateTime? lastLogin,
    bool? isActive,
    String? deviceToken,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      phone: phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }
}

class UserWallet {
  final double balance;
  final double totalDeposited;
  final double totalWithdrawn;
  final double totalWinnings;
  final double totalLosses;
  final DateTime lastUpdated;
  final String? updatedBy;

  UserWallet({
    this.balance = 0.0,
    this.totalDeposited = 0.0,
    this.totalWithdrawn = 0.0,
    this.totalWinnings = 0.0,
    this.totalLosses = 0.0,
    required this.lastUpdated,
    this.updatedBy,
  });

  factory UserWallet.fromMap(Map<dynamic, dynamic> map) {
    return UserWallet(
      balance: (map['balance'] ?? 0).toDouble(),
      totalDeposited: (map['totalDeposited'] ?? 0).toDouble(),
      totalWithdrawn: (map['totalWithdrawn'] ?? 0).toDouble(),
      totalWinnings: (map['totalWinnings'] ?? 0).toDouble(),
      totalLosses: (map['totalLosses'] ?? 0).toDouble(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        map['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedBy: map['updatedBy']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'totalDeposited': totalDeposited,
      'totalWithdrawn': totalWithdrawn,
      'totalWinnings': totalWinnings,
      'totalLosses': totalLosses,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'updatedBy': updatedBy,
    };
  }

  UserWallet copyWith({
    double? balance,
    double? totalDeposited,
    double? totalWithdrawn,
    double? totalWinnings,
    double? totalLosses,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return UserWallet(
      balance: balance ?? this.balance,
      totalDeposited: totalDeposited ?? this.totalDeposited,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      totalLosses: totalLosses ?? this.totalLosses,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}

class UserBid {
  final String bidId;
  final String gameId;
  final String gameName;
  final String betType;
  final String betNumber;
  final double amount;
  final double potentialWin;
  final BidStatus status;
  final DateTime placedAt;
  final DateTime? resultAt;
  final String? result;

  UserBid({
    required this.bidId,
    required this.gameId,
    required this.gameName,
    required this.betType,
    required this.betNumber,
    required this.amount,
    required this.potentialWin,
    this.status = BidStatus.pending,
    required this.placedAt,
    this.resultAt,
    this.result,
  });

  factory UserBid.fromMap(Map<dynamic, dynamic> map) {
    return UserBid(
      bidId: map['bidId']?.toString() ?? '',
      gameId: map['gameId']?.toString() ?? '',
      gameName: map['gameName']?.toString() ?? '',
      betType: map['betType']?.toString() ?? '',
      betNumber: map['betNumber']?.toString() ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      potentialWin: (map['potentialWin'] ?? 0).toDouble(),
      status: BidStatus.fromString(map['status']?.toString() ?? 'pending'),
      placedAt: DateTime.fromMillisecondsSinceEpoch(
        map['placedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      resultAt: map['resultAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resultAt'])
          : null,
      result: map['result']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bidId': bidId,
      'gameId': gameId,
      'gameName': gameName,
      'betType': betType,
      'betNumber': betNumber,
      'amount': amount,
      'potentialWin': potentialWin,
      'status': status.toString(),
      'placedAt': placedAt.millisecondsSinceEpoch,
      'resultAt': resultAt?.millisecondsSinceEpoch,
      'result': result,
    };
  }
}

class UserTransaction {
  final String transactionId;
  final TransactionType type;
  final double amount;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? processedBy;

  UserTransaction({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.description,
    this.status = TransactionStatus.pending,
    required this.createdAt,
    this.processedAt,
    this.processedBy,
  });

  factory UserTransaction.fromMap(Map<dynamic, dynamic> map) {
    return UserTransaction(
      transactionId: map['transactionId']?.toString() ?? '',
      type: TransactionType.fromString(map['type']?.toString() ?? 'recharge'),
      amount: (map['amount'] ?? 0).toDouble(),
      description: map['description']?.toString() ?? '',
      status: TransactionStatus.fromString(map['status']?.toString() ?? 'pending'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      processedAt: map['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['processedAt'])
          : null,
      processedBy: map['processedBy']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'type': type.toString(),
      'amount': amount,
      'description': description,
      'status': status.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'processedBy': processedBy,
    };
  }
}

class UserSettings {
  final bool notifications;
  final String language;
  final String timezone;

  UserSettings({
    this.notifications = true,
    this.language = 'en',
    this.timezone = 'Asia/Kolkata',
  });

  factory UserSettings.fromMap(Map<dynamic, dynamic> map) {
    return UserSettings(
      notifications: map['notifications'] ?? true,
      language: map['language']?.toString() ?? 'en',
      timezone: map['timezone']?.toString() ?? 'Asia/Kolkata',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications,
      'language': language,
      'timezone': timezone,
    };
  }

  UserSettings copyWith({
    bool? notifications,
    String? language,
    String? timezone,
  }) {
    return UserSettings(
      notifications: notifications ?? this.notifications,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
    );
  }
}

// Enums
enum BidStatus {
  pending,
  won,
  lost,
  cancelled;

  static BidStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'won':
        return BidStatus.won;
      case 'lost':
        return BidStatus.lost;
      case 'cancelled':
        return BidStatus.cancelled;
      default:
        return BidStatus.pending;
    }
  }

  @override
  String toString() {
    return name;
  }
}

enum TransactionType {
  recharge,
  withdrawal,
  betPlaced,
  betWon,
  betLost,
  adminCredit,
  adminDebit;

  static TransactionType fromString(String type) {
    switch (type.toLowerCase().replaceAll('_', '')) {
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'betplaced':
        return TransactionType.betPlaced;
      case 'betwon':
        return TransactionType.betWon;
      case 'betlost':
        return TransactionType.betLost;
      case 'admincredit':
        return TransactionType.adminCredit;
      case 'admindebit':
        return TransactionType.adminDebit;
      default:
        return TransactionType.recharge;
    }
  }

  @override
  String toString() {
    switch (this) {
      case TransactionType.betPlaced:
        return 'bet_placed';
      case TransactionType.betWon:
        return 'bet_won';
      case TransactionType.betLost:
        return 'bet_lost';
      case TransactionType.adminCredit:
        return 'admin_credit';
      case TransactionType.adminDebit:
        return 'admin_debit';
      default:
        return name;
    }
  }
}

enum TransactionStatus {
  pending,
  approved,
  rejected,
  completed,
  failed;

  static TransactionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return TransactionStatus.approved;
      case 'rejected':
        return TransactionStatus.rejected;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }

  @override
  String toString() {
    return name;
  }
}