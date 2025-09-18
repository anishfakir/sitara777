import 'dart:convert';

class BazaarModel {
  final String bazaarId;
  final String name;
  final String displayName;
  final String description;
  final String? icon;
  final String? banner;
  final bool isActive;
  final int sortOrder;
  final List<String> gameIds; // List of game IDs in this bazaar
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  BazaarModel({
    required this.bazaarId,
    required this.name,
    required this.displayName,
    required this.description,
    this.icon,
    this.banner,
    required this.isActive,
    this.sortOrder = 0,
    this.gameIds = const [],
    this.settings = const {},
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  // Create from Firebase data
  factory BazaarModel.fromMap(String bazaarId, Map<dynamic, dynamic> map) {
    return BazaarModel(
      bazaarId: bazaarId,
      name: map['name']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      icon: map['icon']?.toString(),
      banner: map['banner']?.toString(),
      isActive: map['isActive'] == true,
      sortOrder: int.tryParse(map['sortOrder']?.toString() ?? '0') ?? 0,
      gameIds: _parseGameIds(map['gameIds']),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(map['createdAt']?.toString() ?? '0') ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(map['updatedAt']?.toString() ?? '0') ?? 0,
      ),
      createdBy: map['createdBy']?.toString() ?? '',
    );
  }

  static List<String> _parseGameIds(dynamic gameIds) {
    if (gameIds == null) return [];
    if (gameIds is List) {
      return gameIds.map((id) => id.toString()).toList();
    }
    if (gameIds is Map) {
      return gameIds.keys.map((id) => id.toString()).toList();
    }
    return [];
  }

  // Convert to Firebase data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'icon': icon,
      'banner': banner,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'gameIds': gameIds,
      'settings': settings,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
    };
  }

  // JSON serialization
  String toJson() => json.encode(toMap());

  factory BazaarModel.fromJson(String bazaarId, String source) =>
      BazaarModel.fromMap(bazaarId, json.decode(source));

  // Copy with modifications
  BazaarModel copyWith({
    String? bazaarId,
    String? name,
    String? displayName,
    String? description,
    String? icon,
    String? banner,
    bool? isActive,
    int? sortOrder,
    List<String>? gameIds,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return BazaarModel(
      bazaarId: bazaarId ?? this.bazaarId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      banner: banner ?? this.banner,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      gameIds: gameIds ?? this.gameIds,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Utility getters
  bool get hasGames => gameIds.isNotEmpty;
  int get gameCount => gameIds.length;
  String get statusText => isActive ? 'Active' : 'Inactive';
  
  @override
  String toString() {
    return 'BazaarModel(bazaarId: $bazaarId, name: $name, displayName: $displayName, isActive: $isActive, gameCount: $gameCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BazaarModel && other.bazaarId == bazaarId;
  }

  @override
  int get hashCode => bazaarId.hashCode;
}

