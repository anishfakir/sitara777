class PaymentTransaction {
  final String id;
  final String userId;
  final double amount;
  final String upiTransactionId;
  final String status; // pending, verified, rejected
  final DateTime timestamp;
  final String remark;
  final String? screenshotUrl; // For uploaded screenshot

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.upiTransactionId,
    required this.status,
    required this.timestamp,
    required this.remark,
    this.screenshotUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'upiTransactionId': upiTransactionId,
      'status': status,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'remark': remark,
      'screenshotUrl': screenshotUrl,
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      upiTransactionId: json['upiTransactionId'],
      status: json['status'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      remark: json['remark'],
      screenshotUrl: json['screenshotUrl'],
    );
  }
}