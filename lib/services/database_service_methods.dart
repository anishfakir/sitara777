// Database Connection Test Methods
  Future<bool> testConnection() async {
    try {
      final ref = _database.ref('.info/connected');
      final snapshot = await ref.get();
      return snapshot.value as bool? ?? false;
    } catch (e) {
      debugPrint('❌ Error testing connection: $e');
      return false;
    }
  }

  // Get database information for debugging
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      return {
        'serverTimeOffset': await _database.getServerTime(),
        'persistenceEnabled': _database.persistenceEnabled,
        'app': _database.app.name,
        'databaseURL': _database.databaseURL,
      };
    } catch (e) {
      debugPrint('❌ Error getting database info: $e');
      return {};
    }
  }

  // Watch user transactions
  Stream<List<TransactionModel>> watchUserTransactions(String userId) {
    final ref = _database.ref('users/$userId/transactions');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) => 
        TransactionModel.fromMap(entry.key.toString(), Map<String, dynamic>.from(entry.value as Map))
      ).toList();
    });
  }

  // Get user data as a stream
  Stream<UserModel?> getUserStream(String userId) {
    final ref = _database.ref('users/$userId');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return UserModel.fromMap(userId, data);
    });
  }

  // Watch for game updates
  Stream<List<GameModel>> watchGamesByBazaar(String bazaarId) {
    final ref = _database.ref('bazaars/$bazaarId/games');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) =>
        GameModel.fromMap(entry.key.toString(), Map<String, dynamic>.from(entry.value as Map))
      ).toList();
    });
  }

  // Watch results
  Stream<List<Map<String, dynamic>>> watchResults() {
    final ref = _database.ref('results');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) => {
        'id': entry.key.toString(),
        ...Map<String, dynamic>.from(entry.value as Map),
      }).toList();
    });
  }

  // Watch user bets
  Stream<List<BetModel>> getUserBetsStream(String userId) {
    final ref = _database.ref('users/$userId/bets');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) => 
        BetModel.fromMap(entry.key.toString(), Map<String, dynamic>.from(entry.value as Map))
      ).toList();
    });
  }

  // Get all games
  Future<List<GameModel>> getGames() async {
    try {
      final ref = _database.ref('games');
      final snapshot = await ref.get();
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) =>
        GameModel.fromMap(entry.key.toString(), Map<String, dynamic>.from(entry.value as Map))
      ).toList();
    } catch (e) {
      debugPrint('❌ Error getting games: $e');
      return [];
    }
  }

  // Create a transaction
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      final ref = _database.ref('users/${transaction.userId}/transactions/${transaction.id}');
      await ref.set(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _database.ref('users/$userId').update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }