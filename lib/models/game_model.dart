class GameModel {
  final String gameId;
  final String name;
  final String displayName;
  final String description;
  final GameType type;
  final String category;
  final String? bazaarId; // Reference to parent bazaar
  final String? icon;
  final String? banner;
  final bool isActive;
  final String openTime;
  final String closeTime;
  final String resultTime;
  final Map<String, BetType> betTypes;
  final GameRates rates;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? result;
  final DateTime? resultDeclaredAt;

  GameModel({
    required this.gameId,
    required this.name,
    required this.displayName,
    required this.description,
    this.type = GameType.matka,
    required this.category,
    this.bazaarId,
    this.icon,
    this.banner,
    this.isActive = true,
    required this.openTime,
    required this.closeTime,
    required this.resultTime,
    this.betTypes = const {},
    required this.rates,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.result,
    this.resultDeclaredAt,
  });

  // Getter for id (alias for gameId)
  String get id => gameId;

  // Getter for isOpenForBetting
  bool get isOpenForBetting => isBettingOpen;

  // Getters for time parsing (for compatibility with existing screens)
  DateTime get openTimeDateTime => _timeStringToDateTime(openTime);
  DateTime get closeTimeDateTime => _timeStringToDateTime(closeTime);
  DateTime get resultTimeDateTime => _timeStringToDateTime(resultTime);

  factory GameModel.fromMap(String gameId, Map<dynamic, dynamic> map) {
    return GameModel(
      gameId: gameId,
      name: map['name']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      type: GameType.fromString(map['type']?.toString() ?? 'matka'),
      category: map['category']?.toString() ?? '',
      bazaarId: map['bazaarId']?.toString(),
      icon: map['icon']?.toString(),
      banner: map['banner']?.toString(),
      isActive: map['isActive'] ?? true,
      openTime: map['openTime']?.toString() ?? '10:00',
      closeTime: map['closeTime']?.toString() ?? '20:00',
      resultTime: map['resultTime']?.toString() ?? '20:30',
      betTypes: (map['betTypes'] as Map<dynamic, dynamic>?)?.map(
            (key, value) => MapEntry(key.toString(), BetType.fromMap(value)),
          ) ??
          {},
      rates: GameRates.fromMap(map['rates'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      createdBy: map['createdBy']?.toString() ?? 'admin',
      result: map['result']?.toString(),
      resultDeclaredAt: map['resultDeclaredAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resultDeclaredAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'type': type.toString(),
      'category': category,
      'bazaarId': bazaarId,
      'icon': icon,
      'banner': banner,
      'isActive': isActive,
      'openTime': openTime,
      'closeTime': closeTime,
      'resultTime': resultTime,
      'betTypes': betTypes.map((key, value) => MapEntry(key, value.toMap())),
      'rates': rates.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'result': result,
      'resultDeclaredAt': resultDeclaredAt?.millisecondsSinceEpoch,
    };
  }

  GameModel copyWith({
    String? name,
    String? displayName,
    String? description,
    GameType? type,
    String? category,
    String? bazaarId,
    String? icon,
    String? banner,
    bool? isActive,
    String? openTime,
    String? closeTime,
    String? resultTime,
    Map<String, BetType>? betTypes,
    GameRates? rates,
    DateTime? updatedAt,
    String? result,
    DateTime? resultDeclaredAt,
  }) {
    return GameModel(
      gameId: gameId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      bazaarId: bazaarId ?? this.bazaarId,
      icon: icon ?? this.icon,
      banner: banner ?? this.banner,
      isActive: isActive ?? this.isActive,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      resultTime: resultTime ?? this.resultTime,
      betTypes: betTypes ?? this.betTypes,
      rates: rates ?? this.rates,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      createdBy: createdBy,
      result: result ?? this.result,
      resultDeclaredAt: resultDeclaredAt ?? this.resultDeclaredAt,
    );
  }

  bool get isBettingOpen {
    final now = DateTime.now();
    final openDateTime = _timeStringToDateTime(openTime);
    final closeDateTime = _timeStringToDateTime(closeTime);
    
    // Handle cases where close time is next day
    if (closeDateTime.isBefore(openDateTime)) {
      return now.isAfter(openDateTime) || now.isBefore(closeDateTime);
    }
    
    return now.isAfter(openDateTime) && now.isBefore(closeDateTime);
  }

  bool get isResultTime {
    final now = DateTime.now();
    final resultDateTime = _timeStringToDateTime(resultTime);
    final timeDiff = now.difference(resultDateTime).inMinutes.abs();
    return timeDiff <= 30; // Result time window is 30 minutes
  }

  DateTime _timeStringToDateTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

class BetType {
  final String betTypeId;
  final String name;
  final String displayName;
  final double minBet;
  final double maxBet;
  final double winMultiplier;
  final bool isActive;

  BetType({
    required this.betTypeId,
    required this.name,
    required this.displayName,
    this.minBet = 10.0,
    this.maxBet = 10000.0,
    required this.winMultiplier,
    this.isActive = true,
  });

  // Getter for id (alias for betTypeId)
  String get id => betTypeId;

  // Getter for multiplier (alias for winMultiplier)
  double get multiplier => winMultiplier;

  factory BetType.fromMap(Map<dynamic, dynamic> map) {
    return BetType(
      betTypeId: map['betTypeId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      minBet: (map['minBet'] ?? 10).toDouble(),
      maxBet: (map['maxBet'] ?? 10000).toDouble(),
      winMultiplier: (map['winMultiplier'] ?? 9.5).toDouble(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'betTypeId': betTypeId,
      'name': name,
      'displayName': displayName,
      'minBet': minBet,
      'maxBet': maxBet,
      'winMultiplier': winMultiplier,
      'isActive': isActive,
    };
  }

  BetType copyWith({
    String? name,
    String? displayName,
    double? minBet,
    double? maxBet,
    double? winMultiplier,
    bool? isActive,
  }) {
    return BetType(
      betTypeId: betTypeId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      minBet: minBet ?? this.minBet,
      maxBet: maxBet ?? this.maxBet,
      winMultiplier: winMultiplier ?? this.winMultiplier,
      isActive: isActive ?? this.isActive,
    );
  }
}

class GameRates {
  final double single;
  final double jodi;
  final double patti;
  final double halfSangam;
  final double fullSangam;

  GameRates({
    this.single = 9.5,
    this.jodi = 95.0,
    this.patti = 950.0,
    this.halfSangam = 1000.0,
    this.fullSangam = 10000.0,
  });

  factory GameRates.fromMap(Map<dynamic, dynamic> map) {
    return GameRates(
      single: (map['single'] ?? 9.5).toDouble(),
      jodi: (map['jodi'] ?? 95.0).toDouble(),
      patti: (map['patti'] ?? 950.0).toDouble(),
      halfSangam: (map['halfSangam'] ?? 1000.0).toDouble(),
      fullSangam: (map['fullSangam'] ?? 10000.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'single': single,
      'jodi': jodi,
      'patti': patti,
      'halfSangam': halfSangam,
      'fullSangam': fullSangam,
    };
  }

  GameRates copyWith({
    double? single,
    double? jodi,
    double? patti,
    double? halfSangam,
    double? fullSangam,
  }) {
    return GameRates(
      single: single ?? this.single,
      jodi: jodi ?? this.jodi,
      patti: patti ?? this.patti,
      halfSangam: halfSangam ?? this.halfSangam,
      fullSangam: fullSangam ?? this.fullSangam,
    );
  }

  double getRateForBetType(String betType) {
    switch (betType.toLowerCase()) {
      case 'single':
        return single;
      case 'jodi':
        return jodi;
      case 'patti':
        return patti;
      case 'half_sangam':
      case 'halfsangam':
        return halfSangam;
      case 'full_sangam':
      case 'fullsangam':
        return fullSangam;
      default:
        return single;
    }
  }
}

enum GameType {
  matka,
  casino,
  lottery;

  static GameType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'casino':
        return GameType.casino;
      case 'lottery':
        return GameType.lottery;
      default:
        return GameType.matka;
    }
  }

  @override
  String toString() {
    return name;
  }
}