import '../models/user_model.dart';

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? description;
  final String? adminNote;
  final String? paymentMethod;
  final String? referenceId;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.processedAt,
    this.description,
    this.adminNote,
    this.paymentMethod,
    this.referenceId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: TransactionType.fromString(json['type'] ?? 'recharge'),
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: TransactionStatus.fromString(json['status'] ?? 'pending'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      processedAt: json['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['processedAt'])
          : null,
      description: json['description'],
      adminNote: json['adminNote'],
      paymentMethod: json['paymentMethod'],
      referenceId: json['referenceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'amount': amount,
      'status': status.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'description': description,
      'adminNote': adminNote,
      'paymentMethod': paymentMethod,
      'referenceId': referenceId,
    };
  }

  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isRejected => status == TransactionStatus.rejected;
  bool get isFailed => status == TransactionStatus.failed;

  String get statusText {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.approved:
        return 'Approved';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.rejected:
        return 'Rejected';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String get typeText {
    switch (type) {
      case TransactionType.recharge:
        return 'Recharge';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.betPlaced:
        return 'Bet';
      case TransactionType.betWon:
        return 'Win';
      case TransactionType.betLost:
        return 'Loss';
      case TransactionType.adminCredit:
        return 'Admin Credit';
      case TransactionType.adminDebit:
        return 'Admin Debit';
    }
  }

  // Add missing methods for DatabaseService compatibility
  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      userId: data['userId'] ?? data['user_id'] ?? '',
      type: TransactionType.fromString(data['type'] ?? 'recharge'),
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: TransactionStatus.fromString(data['status'] ?? 'pending'),
      createdAt: data['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : data['timestamp'] != null 
              ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
              : DateTime.now(),
      processedAt: data['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['processedAt'])
          : null,
      description: data['description'],
      adminNote: data['adminNote'] ?? data['admin_note'],
      paymentMethod: data['paymentMethod'] ?? data['payment_method'],
      referenceId: data['referenceId'] ?? data['reference_id'],
    );
  }

  Map<String, dynamic> toMap() => toJson();

  // Add timestamp getter for compatibility
  DateTime get timestamp => createdAt;
}
