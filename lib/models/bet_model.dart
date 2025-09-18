enum BetStatus { pending, won, lost, cancelled }

class BetModel {
  final String id;
  final String userId;
  final String gameId;
  final String gameName;
  final String betTypeId;
  final String betTypeName;
  final double amount;
  final String betNumber;
  final int timestamp;
  final DateTime placedAt;
  final BetStatus status;
  final double? winAmount;
  final String? result;

  BetModel({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.gameName,
    required this.betTypeId,
    required this.betTypeName,
    required this.amount,
    required this.betNumber,
    required this.timestamp,
    DateTime? placedAt,
    required this.status,
    this.winAmount,
    this.result,
  }) : this.placedAt = placedAt ?? DateTime.now();

  factory BetModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return BetModel(
      id: id,
      userId: data['userId'] ?? data['user_id'] ?? '',
      gameId: data['gameId'] ?? data['game_id'] ?? '',
      gameName: data['gameName'] ?? data['game_name'] ?? '',
      betTypeId: data['betTypeId'] ?? data['bet_type_id'] ?? '',
      betTypeName: data['betTypeName'] ?? data['bet_type_name'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      betNumber: data['betNumber'] ?? data['bet_number'] ?? '',
      timestamp: data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      placedAt: data['placedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(data['placedAt'])
          : DateTime.now(),
      status: BetStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => BetStatus.pending,
      ),
      winAmount: data['winAmount']?.toDouble() ?? data['win_amount']?.toDouble(),
      result: data['result'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'gameId': gameId, 
      'gameName': gameName,
      'betTypeId': betTypeId,
      'betTypeName': betTypeName,
      'amount': amount,
      'betNumber': betNumber,
      'timestamp': timestamp,
      'status': status.name,
      'winAmount': winAmount,
      'result': result,
    };
  }

  bool get isWon => status == BetStatus.won;
  bool get isLost => status == BetStatus.lost;
  bool get isPending => status == BetStatus.pending;
}
