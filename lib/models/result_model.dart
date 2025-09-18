import '../models/user_model.dart';

class ResultModel {
  final String resultId;
  final String gameId;
  final String gameName;
  final String date;
  final ResultSession session;
  final String result;
  final String? openPatti;
  final String? closePatti;
  final String? jodi;
  final DateTime declaredAt;
  final String declaredBy;
  final bool isVerified;
  final List<String> winningBids;
  final double totalWinAmount;
  final double totalBidAmount;

  ResultModel({
    required this.resultId,
    required this.gameId,
    required this.gameName,
    required this.date,
    required this.session,
    required this.result,
    this.openPatti,
    this.closePatti,
    this.jodi,
    required this.declaredAt,
    required this.declaredBy,
    this.isVerified = false,
    this.winningBids = const [],
    this.totalWinAmount = 0.0,
    this.totalBidAmount = 0.0,
  });

  factory ResultModel.fromMap(String resultId, Map<dynamic, dynamic> map) {
    return ResultModel(
      resultId: resultId,
      gameId: map['gameId']?.toString() ?? '',
      gameName: map['gameName']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      session: ResultSession.fromString(map['session']?.toString() ?? 'open'),
      result: map['result']?.toString() ?? '',
      openPatti: map['openPatti']?.toString(),
      closePatti: map['closePatti']?.toString(),
      jodi: map['jodi']?.toString(),
      declaredAt: DateTime.fromMillisecondsSinceEpoch(
        map['declaredAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      declaredBy: map['declaredBy']?.toString() ?? 'admin',
      isVerified: map['isVerified'] ?? false,
      winningBids: (map['winningBids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalWinAmount: (map['totalWinAmount'] ?? 0).toDouble(),
      totalBidAmount: (map['totalBidAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'gameName': gameName,
      'date': date,
      'session': session.toString(),
      'result': result,
      'openPatti': openPatti,
      'closePatti': closePatti,
      'jodi': jodi,
      'declaredAt': declaredAt.millisecondsSinceEpoch,
      'declaredBy': declaredBy,
      'isVerified': isVerified,
      'winningBids': winningBids,
      'totalWinAmount': totalWinAmount,
      'totalBidAmount': totalBidAmount,
    };
  }

  ResultModel copyWith({
    String? gameId,
    String? gameName,
    String? date,
    ResultSession? session,
    String? result,
    String? openPatti,
    String? closePatti,
    String? jodi,
    DateTime? declaredAt,
    String? declaredBy,
    bool? isVerified,
    List<String>? winningBids,
    double? totalWinAmount,
    double? totalBidAmount,
  }) {
    return ResultModel(
      resultId: resultId,
      gameId: gameId ?? this.gameId,
      gameName: gameName ?? this.gameName,
      date: date ?? this.date,
      session: session ?? this.session,
      result: result ?? this.result,
      openPatti: openPatti ?? this.openPatti,
      closePatti: closePatti ?? this.closePatti,
      jodi: jodi ?? this.jodi,
      declaredAt: declaredAt ?? this.declaredAt,
      declaredBy: declaredBy ?? this.declaredBy,
      isVerified: isVerified ?? this.isVerified,
      winningBids: winningBids ?? this.winningBids,
      totalWinAmount: totalWinAmount ?? this.totalWinAmount,
      totalBidAmount: totalBidAmount ?? this.totalBidAmount,
    );
  }

  String get formattedDate {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final dateTime = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      // If parsing fails, return original date
    }
    return date;
  }

  bool get isToday {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return date == todayStr;
  }

  bool get isRecent {
    final resultDateTime = declaredAt;
    final now = DateTime.now();
    final difference = now.difference(resultDateTime);
    return difference.inHours <= 24;
  }
}

class BidModel {
  final String bidId;
  final String userId;
  final String userName;
  final String userPhone;
  final String gameId;
  final String gameName;
  final String betType;
  final String betNumber;
  final double amount;
  final double potentialWin;
  final double winMultiplier;
  final BidSession session;
  final String date;
  final BidStatus status;
  final DateTime placedAt;
  final DateTime? resultDeclaredAt;
  final String? result;
  final double? winAmount;
  final String transactionId;

  BidModel({
    required this.bidId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.gameId,
    required this.gameName,
    required this.betType,
    required this.betNumber,
    required this.amount,
    required this.potentialWin,
    required this.winMultiplier,
    required this.session,
    required this.date,
    this.status = BidStatus.pending,
    required this.placedAt,
    this.resultDeclaredAt,
    this.result,
    this.winAmount,
    required this.transactionId,
  });

  factory BidModel.fromMap(String bidId, Map<dynamic, dynamic> map) {
    return BidModel(
      bidId: bidId,
      userId: map['userId']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      userPhone: map['userPhone']?.toString() ?? '',
      gameId: map['gameId']?.toString() ?? '',
      gameName: map['gameName']?.toString() ?? '',
      betType: map['betType']?.toString() ?? '',
      betNumber: map['betNumber']?.toString() ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      potentialWin: (map['potentialWin'] ?? 0).toDouble(),
      winMultiplier: (map['winMultiplier'] ?? 9.5).toDouble(),
      session: BidSession.fromString(map['session']?.toString() ?? 'full'),
      date: map['date']?.toString() ?? '',
      status: BidStatus.fromString(map['status']?.toString() ?? 'pending'),
      placedAt: DateTime.fromMillisecondsSinceEpoch(
        map['placedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      resultDeclaredAt: map['resultDeclaredAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resultDeclaredAt'])
          : null,
      result: map['result']?.toString(),
      winAmount: map['winAmount']?.toDouble(),
      transactionId: map['transactionId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'gameId': gameId,
      'gameName': gameName,
      'betType': betType,
      'betNumber': betNumber,
      'amount': amount,
      'potentialWin': potentialWin,
      'winMultiplier': winMultiplier,
      'session': session.toString(),
      'date': date,
      'status': status.toString(),
      'placedAt': placedAt.millisecondsSinceEpoch,
      'resultDeclaredAt': resultDeclaredAt?.millisecondsSinceEpoch,
      'result': result,
      'winAmount': winAmount,
      'transactionId': transactionId,
    };
  }

  BidModel copyWith({
    String? userId,
    String? userName,
    String? userPhone,
    String? gameId,
    String? gameName,
    String? betType,
    String? betNumber,
    double? amount,
    double? potentialWin,
    double? winMultiplier,
    BidSession? session,
    String? date,
    BidStatus? status,
    DateTime? placedAt,
    DateTime? resultDeclaredAt,
    String? result,
    double? winAmount,
    String? transactionId,
  }) {
    return BidModel(
      bidId: bidId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      gameId: gameId ?? this.gameId,
      gameName: gameName ?? this.gameName,
      betType: betType ?? this.betType,
      betNumber: betNumber ?? this.betNumber,
      amount: amount ?? this.amount,
      potentialWin: potentialWin ?? this.potentialWin,
      winMultiplier: winMultiplier ?? this.winMultiplier,
      session: session ?? this.session,
      date: date ?? this.date,
      status: status ?? this.status,
      placedAt: placedAt ?? this.placedAt,
      resultDeclaredAt: resultDeclaredAt ?? this.resultDeclaredAt,
      result: result ?? this.result,
      winAmount: winAmount ?? this.winAmount,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  bool get isPending => status == BidStatus.pending;
  bool get isWon => status == BidStatus.won;
  bool get isLost => status == BidStatus.lost;
  bool get isCancelled => status == BidStatus.cancelled;
}

class ResultTransactionModel {
  final String transactionId;
  final String userId;
  final String userName;
  final String userPhone;
  final TransactionType type;
  final double amount;
  final double previousBalance;
  final double newBalance;
  final String description;
  final String? reference;
  final TransactionStatus status;
  final String? paymentMethod;
  final Map<String, dynamic>? gatewayResponse;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? adminNotes;

  ResultTransactionModel({
    required this.transactionId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.type,
    required this.amount,
    required this.previousBalance,
    required this.newBalance,
    required this.description,
    this.reference,
    this.status = TransactionStatus.pending,
    this.paymentMethod,
    this.gatewayResponse,
    required this.createdAt,
    this.processedAt,
    this.processedBy,
    this.adminNotes,
  });

  factory ResultTransactionModel.fromMap(String transactionId, Map<dynamic, dynamic> map) {
    return ResultTransactionModel(
      transactionId: transactionId,
      userId: map['userId']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      userPhone: map['userPhone']?.toString() ?? '',
      type: TransactionType.fromString(map['type']?.toString() ?? 'recharge'),
      amount: (map['amount'] ?? 0).toDouble(),
      previousBalance: (map['previousBalance'] ?? 0).toDouble(),
      newBalance: (map['newBalance'] ?? 0).toDouble(),
      description: map['description']?.toString() ?? '',
      reference: map['reference']?.toString(),
      status: TransactionStatus.fromString(map['status']?.toString() ?? 'pending'),
      paymentMethod: map['paymentMethod']?.toString(),
      gatewayResponse: map['gatewayResponse'] as Map<String, dynamic>?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      processedAt: map['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['processedAt'])
          : null,
      processedBy: map['processedBy']?.toString(),
      adminNotes: map['adminNotes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'type': type.toString(),
      'amount': amount,
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'description': description,
      'reference': reference,
      'status': status.toString(),
      'paymentMethod': paymentMethod,
      'gatewayResponse': gatewayResponse,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'processedBy': processedBy,
      'adminNotes': adminNotes,
    };
  }

  ResultTransactionModel copyWith({
    String? userId,
    String? userName,
    String? userPhone,
    TransactionType? type,
    double? amount,
    double? previousBalance,
    double? newBalance,
    String? description,
    String? reference,
    TransactionStatus? status,
    String? paymentMethod,
    Map<String, dynamic>? gatewayResponse,
    DateTime? createdAt,
    DateTime? processedAt,
    String? processedBy,
    String? adminNotes,
  }) {
    return ResultTransactionModel(
      transactionId: transactionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      previousBalance: previousBalance ?? this.previousBalance,
      newBalance: newBalance ?? this.newBalance,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      gatewayResponse: gatewayResponse ?? this.gatewayResponse,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      adminNotes: adminNotes ?? this.adminNotes,
    );
  }

  bool get isCredit => [
        TransactionType.recharge,
        TransactionType.betWon,
        TransactionType.adminCredit
      ].contains(type);

  bool get isDebit => [
        TransactionType.withdrawal,
        TransactionType.betPlaced,
        TransactionType.betLost,
        TransactionType.adminDebit
      ].contains(type);
}

// Additional enums
enum ResultSession {
  open,
  close;

  static ResultSession fromString(String session) {
    switch (session.toLowerCase()) {
      case 'close':
        return ResultSession.close;
      default:
        return ResultSession.open;
    }
  }

  @override
  String toString() {
    return name;
  }
}

enum BidSession {
  open,
  close,
  full;

  static BidSession fromString(String session) {
    switch (session.toLowerCase()) {
      case 'open':
        return BidSession.open;
      case 'close':
        return BidSession.close;
      default:
        return BidSession.full;
    }
  }

  @override
  String toString() {
    return name;
  }
}

