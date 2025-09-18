// Flexible GameModel that handles both camelCase and snake_case field names
// This ensures compatibility with different admin panel naming conventions

class GameModel {
  final String gameId;
  final String name;
  final String displayName;
  final String description;
  final String type;
  final String category;
  final String? bazaarId;
  final String? icon;
  final String? banner;
  final bool isActive;
  final String openTime;
  final String closeTime;
  final String resultTime;
  final Map<String, dynamic> betOptions;
  final double minBetAmount;
  final double maxBetAmount;
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
    this.type = 'matka',
    required this.category,
    this.bazaarId,
    this.icon,
    this.banner,
    this.isActive = true,
    required this.openTime,
    required this.closeTime,
    required this.resultTime,
    this.betOptions = const {},
    this.minBetAmount = 10.0,
    this.maxBetAmount = 10000.0,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.result,
    this.resultDeclaredAt,
  });

  // Flexible factory constructor that handles multiple field naming conventions
  factory GameModel.fromMap(String gameId, Map<dynamic, dynamic> map) {
    // Helper function to get value with multiple possible keys
    dynamic getValue(List<String> keys, [dynamic defaultValue]) {
      for (String key in keys) {
        if (map.containsKey(key) && map[key] != null) {
          return map[key];
        }
      }
      return defaultValue;
    }

    // Helper function to get timestamp
    DateTime getTimestamp(List<String> keys, [DateTime? defaultValue]) {
      final value = getValue(keys);
      if (value == null) return defaultValue ?? DateTime.now();
      
      if (value is int) {
        // Handle both milliseconds and seconds
        return value > 1000000000000 
            ? DateTime.fromMillisecondsSinceEpoch(value)
            : DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
      
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return defaultValue ?? DateTime.now();
        }
      }
      
      return defaultValue ?? DateTime.now();
    }

    return GameModel(
      gameId: gameId,
      
      // Handle name variations
      name: getValue(['name', 'game_name', 'gameName'], '').toString(),
      
      // Handle display name variations
      displayName: getValue([
        'displayName', 'display_name', 'game_display_name', 
        'title', 'game_title', 'label'
      ], '').toString(),
      
      // Handle description variations
      description: getValue([
        'description', 'desc', 'game_description', 'details'
      ], '').toString(),
      
      // Handle type variations
      type: getValue([
        'type', 'game_type', 'gameType', 'category_type'
      ], 'matka').toString(),
      
      // Handle category variations
      category: getValue([
        'category', 'game_category', 'gameCategory', 'group'
      ], '').toString(),
      
      // Handle bazaar ID variations
      bazaarId: getValue([
        'bazaarId', 'bazaar_id', 'parentId', 'parent_id'
      ])?.toString(),
      
      // Handle icon variations
      icon: getValue([
        'icon', 'image', 'logo', 'game_icon'
      ])?.toString(),
      
      // Handle banner variations
      banner: getValue([
        'banner', 'cover', 'game_banner', 'header_image'
      ])?.toString(),
      
      // Handle active status variations
      isActive: getValue([
        'isActive', 'is_active', 'active', 'enabled', 'status'
      ], true) == true || getValue(['isActive', 'is_active', 'active', 'enabled']) == 1,
      
      // Handle time variations
      openTime: getValue([
        'openTime', 'open_time', 'start_time', 'startTime', 'opening_time'
      ], '10:00').toString(),
      
      closeTime: getValue([
        'closeTime', 'close_time', 'end_time', 'endTime', 'closing_time'
      ], '20:00').toString(),
      
      resultTime: getValue([
        'resultTime', 'result_time', 'declaration_time', 'declarationTime'
      ], '20:30').toString(),
      
      // Handle bet options variations
      betOptions: getValue([
        'betOptions', 'bet_options', 'betTypes', 'bet_types', 'options'
      ], {}) as Map<String, dynamic>,
      
      // Handle bet amounts
      minBetAmount: (getValue([
        'minBetAmount', 'min_bet_amount', 'minBet', 'min_bet', 'minimum_bet'
      ], 10) ?? 10).toDouble(),
      
      maxBetAmount: (getValue([
        'maxBetAmount', 'max_bet_amount', 'maxBet', 'max_bet', 'maximum_bet'
      ], 10000) ?? 10000).toDouble(),
      
      // Handle timestamps
      createdAt: getTimestamp([
        'createdAt', 'created_at', 'dateCreated', 'date_created', 'timestamp'
      ]),
      
      updatedAt: getTimestamp([
        'updatedAt', 'updated_at', 'dateUpdated', 'date_updated', 'last_modified'
      ]),
      
      // Handle creator variations
      createdBy: getValue([
        'createdBy', 'created_by', 'creator', 'author', 'admin_id'
      ], 'admin').toString(),
      
      // Handle result variations
      result: getValue([
        'result', 'game_result', 'winning_number', 'winner'
      ])?.toString(),
      
      // Handle result declared time
      resultDeclaredAt: getValue([
        'resultDeclaredAt', 'result_declared_at', 'result_time', 'declared_at'
      ]) != null ? getTimestamp([
        'resultDeclaredAt', 'result_declared_at', 'result_time', 'declared_at'
      ]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'type': type,
      'category': category,
      'bazaarId': bazaarId,
      'icon': icon,
      'banner': banner,
      'isActive': isActive,
      'openTime': openTime,
      'closeTime': closeTime,
      'resultTime': resultTime,
      'betOptions': betOptions,
      'minBetAmount': minBetAmount,
      'maxBetAmount': maxBetAmount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'result': result,
      'resultDeclaredAt': resultDeclaredAt?.millisecondsSinceEpoch,
    };
  }

  // Getters for compatibility
  String get id => gameId;
  bool get isOpenForBetting => isBettingOpen;
  
  // Add betTypes getter for compatibility
  Map<String, dynamic> get betTypes => betOptions;

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
    try {
      // Handle different time formats
      final cleanTime = timeString.trim().replaceAll(RegExp(r'[^\d:]'), '');
      final parts = cleanTime.split(':');
      
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      print('Error parsing time string: $timeString');
    }
    
    // Default fallback
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 10, 0);
  }

  GameModel copyWith({
    String? name,
    String? displayName,
    String? description,
    String? type,
    String? category,
    String? bazaarId,
    String? icon,
    String? banner,
    bool? isActive,
    String? openTime,
    String? closeTime,
    String? resultTime,
    Map<String, dynamic>? betOptions,
    double? minBetAmount,
    double? maxBetAmount,
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
      betOptions: betOptions ?? this.betOptions,
      minBetAmount: minBetAmount ?? this.minBetAmount,
      maxBetAmount: maxBetAmount ?? this.maxBetAmount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      createdBy: createdBy,
      result: result ?? this.result,
      resultDeclaredAt: resultDeclaredAt ?? this.resultDeclaredAt,
    );
  }
}
