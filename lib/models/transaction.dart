class TransactionType {
  static const recharge = 'recharge';
  static const bet = 'bet';
  static const betWon = 'bet_won';
  static const adminCredit = 'admin_credit';
  static const adminDebit = 'admin_debit';
  
  static const all = [recharge, bet, betWon, adminCredit, adminDebit];
}

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String description;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      type: json['type'],
      description: json['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}