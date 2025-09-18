class UserWallet {
  final double balance;
  final DateTime lastUpdated;

  UserWallet({
    this.balance = 0.0,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory UserWallet.fromMap(Map<String, dynamic> map) {
    return UserWallet(
      balance: (map['balance'] ?? 0.0).toDouble(),
      lastUpdated: map['lastUpdated'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'])
        : DateTime.now(),
    );
  }
}