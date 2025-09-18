import 'package:firebase_database/firebase_database.dart';

enum WithdrawalRequestStatus {
  pending,
  approved,
  rejected,
  processing,
  completed,
}

class WithdrawalRequest {
  final String id;
  final String userId;
  final double amount;
  final String accountNumber;
  final String accountName;
  final String bankName;
  final String ifscCode;
  final WithdrawalRequestStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? rejectionReason;
  final String? transactionId;

  WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.ifscCode,
    this.status = WithdrawalRequestStatus.pending,
    required this.createdAt,
    this.processedAt,
    this.processedBy,
    this.rejectionReason,
    this.transactionId,
  });

  factory WithdrawalRequest.fromMap(String id, Map<dynamic, dynamic> map) {
    return WithdrawalRequest(
      id: id,
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      accountNumber: map['accountNumber'] ?? '',
      accountName: map['accountName'] ?? '',
      bankName: map['bankName'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      status: WithdrawalRequestStatus.values.firstWhere(
        (e) => e.toString() == 'WithdrawalRequestStatus.${map['status'] ?? 'pending'}',
        orElse: () => WithdrawalRequestStatus.pending,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      processedAt: map['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['processedAt'])
          : null,
      processedBy: map['processedBy'],
      rejectionReason: map['rejectionReason'],
      transactionId: map['transactionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'processedBy': processedBy,
      'rejectionReason': rejectionReason,
      'transactionId': transactionId,
    };
  }

  WithdrawalRequest copyWith({
    String? id,
    String? userId,
    double? amount,
    String? accountNumber,
    String? accountName,
    String? bankName,
    String? ifscCode,
    WithdrawalRequestStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    String? processedBy,
    String? rejectionReason,
    String? transactionId,
  }) {
    return WithdrawalRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bankName: bankName ?? this.bankName,
      ifscCode: ifscCode ?? this.ifscCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}