import 'package:firebase_database/firebase_database.dart';

enum RechargeRequestStatus {
  pending,
  approved,
  rejected,
}

class RechargeRequest {
  final String id;
  final String userId;
  final double amount;
  final String transactionId;
  final String paymentMethod;
  final RechargeRequestStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? rejectionReason;

  RechargeRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionId,
    required this.paymentMethod,
    this.status = RechargeRequestStatus.pending,
    required this.createdAt,
    this.processedAt,
    this.processedBy,
    this.rejectionReason,
  });

  factory RechargeRequest.fromMap(String id, Map<dynamic, dynamic> map) {
    return RechargeRequest(
      id: id,
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      transactionId: map['transactionId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      status: RechargeRequestStatus.values.firstWhere(
        (e) => e.toString() == 'RechargeRequestStatus.${map['status'] ?? 'pending'}',
        orElse: () => RechargeRequestStatus.pending,
      ),
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      processedAt: map['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['processedAt'])
          : null,
      processedBy: map['processedBy'],
      rejectionReason: map['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'processedBy': processedBy,
      'rejectionReason': rejectionReason,
    };
  }

  RechargeRequest copyWith({
    String? id,
    String? userId,
    double? amount,
    String? transactionId,
    String? paymentMethod,
    RechargeRequestStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    String? processedBy,
    String? rejectionReason,
  }) {
    return RechargeRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}