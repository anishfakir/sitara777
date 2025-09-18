import 'dart:convert';

// Represents different types of bets available in a game
enum BetOptionType {
  single,
  jodi,
  patti,
  halfSangam,
  fullSangam,
  custom;

  static BetOptionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'single':
        return BetOptionType.single;
      case 'jodi':
        return BetOptionType.jodi;
      case 'patti':
        return BetOptionType.patti;
      case 'half_sangam':
      case 'halfsangam':
        return BetOptionType.halfSangam;
      case 'full_sangam':
      case 'fullsangam':
        return BetOptionType.fullSangam;
      default:
        return BetOptionType.custom;
    }
  }

  @override
  String toString() {
    switch (this) {
      case BetOptionType.single:
        return 'single';
      case BetOptionType.jodi:
        return 'jodi';
      case BetOptionType.patti:
        return 'patti';
      case BetOptionType.halfSangam:
        return 'half_sangam';
      case BetOptionType.fullSangam:
        return 'full_sangam';
      case BetOptionType.custom:
        return 'custom';
    }
  }
}

// Represents a betting option within a game
class BetOptionModel {
  final String betOptionId;
  final String gameId;
  final String bazaarId;
  final BetOptionType type;
  final String name;
  final String displayName;
  final String description;
  final double minBetAmount;
  final double maxBetAmount;
  final double winMultiplier;
  final bool isActive;
  final int sortOrder;
  final Map<String, dynamic> rules;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  BetOptionModel({
    required this.betOptionId,
    required this.gameId,
    required this.bazaarId,
    required this.type,
    required this.name,
    required this.displayName,
    required this.description,
    required this.minBetAmount,
    required this.maxBetAmount,
    required this.winMultiplier,
    this.isActive = true,
    this.sortOrder = 0,
    this.rules = const {},
    this.settings = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  // Create from Firebase data
  factory BetOptionModel.fromMap(String betOptionId, Map<dynamic, dynamic> map) {
    return BetOptionModel(
      betOptionId: betOptionId,
      gameId: map['gameId']?.toString() ?? '',
      bazaarId: map['bazaarId']?.toString() ?? '',
      type: BetOptionType.fromString(map['type']?.toString() ?? 'single'),
      name: map['name']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      minBetAmount: double.tryParse(map['minBetAmount']?.toString() ?? '10') ?? 10.0,
      maxBetAmount: double.tryParse(map['maxBetAmount']?.toString() ?? '1000') ?? 1000.0,
      winMultiplier: double.tryParse(map['winMultiplier']?.toString() ?? '9.5') ?? 9.5,
      isActive: map['isActive'] == true,
      sortOrder: int.tryParse(map['sortOrder']?.toString() ?? '0') ?? 0,
      rules: Map<String, dynamic>.from(map['rules'] ?? {}),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(map['createdAt']?.toString() ?? '0') ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(map['updatedAt']?.toString() ?? '0') ?? 0,
      ),
    );
  }

  // Convert to Firebase data
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'bazaarId': bazaarId,
      'type': type.toString(),
      'name': name,
      'displayName': displayName,
      'description': description,
      'minBetAmount': minBetAmount,
      'maxBetAmount': maxBetAmount,
      'winMultiplier': winMultiplier,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'rules': rules,
      'settings': settings,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // JSON serialization
  String toJson() => json.encode(toMap());

  factory BetOptionModel.fromJson(String betOptionId, String source) =>
      BetOptionModel.fromMap(betOptionId, json.decode(source));

  // Copy with modifications
  BetOptionModel copyWith({
    String? betOptionId,
    String? gameId,
    String? bazaarId,
    BetOptionType? type,
    String? name,
    String? displayName,
    String? description,
    double? minBetAmount,
    double? maxBetAmount,
    double? winMultiplier,
    bool? isActive,
    int? sortOrder,
    Map<String, dynamic>? rules,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BetOptionModel(
      betOptionId: betOptionId ?? this.betOptionId,
      gameId: gameId ?? this.gameId,
      bazaarId: bazaarId ?? this.bazaarId,
      type: type ?? this.type,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      minBetAmount: minBetAmount ?? this.minBetAmount,
      maxBetAmount: maxBetAmount ?? this.maxBetAmount,
      winMultiplier: winMultiplier ?? this.winMultiplier,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      rules: rules ?? this.rules,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Utility getters
  String get statusText => isActive ? 'Active' : 'Inactive';
  String get typeDisplayName => _getTypeDisplayName();
  
  String _getTypeDisplayName() {
    switch (type) {
      case BetOptionType.single:
        return 'Single';
      case BetOptionType.jodi:
        return 'Jodi';
      case BetOptionType.patti:
        return 'Patti';
      case BetOptionType.halfSangam:
        return 'Half Sangam';
      case BetOptionType.fullSangam:
        return 'Full Sangam';
      case BetOptionType.custom:
        return displayName;
    }
  }

  // Calculate potential win amount
  double calculateWinAmount(double betAmount) {
    return betAmount * winMultiplier;
  }

  // Validate bet amount
  bool isValidBetAmount(double amount) {
    return amount >= minBetAmount && amount <= maxBetAmount;
  }

  @override
  String toString() {
    return 'BetOptionModel(betOptionId: $betOptionId, name: $name, type: $type, winMultiplier: $winMultiplier)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BetOptionModel && other.betOptionId == betOptionId;
  }

  @override
  int get hashCode => betOptionId.hashCode;
}

