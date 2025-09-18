import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/user_model.dart' as user_model;
import '../models/bazaar_model.dart';
import '../models/game_model_flexible.dart';
import '../models/bet_model.dart';
import '../models/transaction_model.dart';
import '../models/result_model.dart';
import '../models/recharge_request.dart';
import '../models/withdrawal_request.dart';
import '../models/user_wallet.dart';
// Import TransactionType from user_model
import '../models/user_model.dart';
import 'models/transaction.dart';
import 'models/payment_transaction.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  
  late final FirebaseDatabase _database;

  DatabaseService._internal() {
    // Initialize Firebase instance
    _database = FirebaseDatabase.instanceFor(
      app: FirebaseDatabase.instance.app,
      databaseURL: 'https://sitara777-admin-api-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    try {
      // Enable offline persistence
      _database.setPersistenceEnabled(true);
      _database.setPersistenceCacheSizeBytes(10000000); // 10MB cache
      debugPrint('🔥 DatabaseService initialized with Asia region URL');
    } on Exception catch (e) {
      debugPrint('❌ Error initializing DatabaseService: $e');
    }
  }

  // ==================== CONNECTION OPERATIONS ====================

  Stream<bool> get connectionStatus {
    return _database.ref('.info/connected').onValue.map((event) => 
        event.snapshot.value as bool? ?? false);
  }

  Future<bool> testConnection() async {
    try {
      final snapshot = await _database.ref('.info/connected').get();
      return snapshot.value as bool? ?? false;
    } on Exception catch (e) {
      debugPrint('❌ Connection test failed: $e');
      return false;
    }
  }

  // ==================== USER OPERATIONS ====================
  
  Future<void> createUser(String userId, user_model.UserModel user) async {
    try {
      await _database.ref('users/$userId').set(user.toMap());
    } on Exception catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<user_model.UserModel?> getUser(String userId) async {
    try {
      final snapshot = await _database.ref('users/$userId').get();
      if (snapshot.exists && snapshot.value != null) {
        return user_model.UserModel.fromMap(userId, Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } on Exception catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Stream<user_model.UserModel?> getUserStream(String userId) {
    return _database.ref('users/$userId').onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return user_model.UserModel.fromMap(userId, Map<String, dynamic>.from(event.snapshot.value as Map));
      }
      return null;
    });
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      debugPrint('Updating user: $userId');
      await _database.ref('users/$userId').update(updates);
    } on Exception catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _database.ref('users/$userId').remove();
    } on Exception catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // ==================== GAME OPERATIONS ====================

  Stream<GameModel?> watchGame(String gameId) {
    return _database.ref('games/$gameId').onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return GameModel.fromMap(
          gameId,
          Map<String, dynamic>.from(event.snapshot.value as Map)
        );
      }
      return null;
    });
  }

  Future<GameModel?> getGame(String gameId) async {
    try {
      final snapshot = await _database.ref('games/$gameId').get();
      if (snapshot.exists && snapshot.value != null) {
        return GameModel.fromMap(
          gameId,
          Map<String, dynamic>.from(snapshot.value as Map)
        );
      }
      return null;
    } on Exception catch (e) {
      throw Exception('Failed to get game: $e');
    }
  }

  Future<List<GameModel>> getGames() async {
    try {
      final snapshot = await _database.ref('games').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final gamesData = Map<String, dynamic>.from(snapshot.value as Map);
      return gamesData.entries.map((e) {
        return GameModel.fromMap(e.key, Map<String, dynamic>.from(e.value as Map));
      }).toList();
    } on Exception catch (e) {
      throw Exception('Failed to get games: $e');
    }
  }

  Stream<List<GameModel>> watchGames() {
    return _database.ref('games').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }

      final gamesData = Map<String, dynamic>.from(event.snapshot.value as Map);
      return gamesData.entries.map((e) {
        return GameModel.fromMap(e.key, Map<String, dynamic>.from(e.value as Map));
      }).toList();
    });
  }

  Future<List<GameModel>> getGamesByBazaar(String bazaarId) async {
    try {
      print('🎮 Fetching games for bazaar: $bazaarId');
      final snapshot = await _database.ref('games').orderByChild('bazaarId').equalTo(bazaarId).get();
      
      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No games found for bazaar: $bazaarId');
        return <GameModel>[];
      }

      final gamesData = Map<String, dynamic>.from(snapshot.value as Map);
      final games = <GameModel>[];

      gamesData.forEach((key, value) {
        try {
          if (value != null) {
            final gameData = Map<String, dynamic>.from(value as Map);
            gameData['gameId'] = key; // Ensure gameId is set
            final game = GameModel.fromMap(key, gameData);
            games.add(game);
          }
        } catch (e) {
          print('⚠️ Error parsing game $key: $e');
        }
      });

      print('✅ Found ${games.length} games for bazaar: $bazaarId');
      return games;
    } catch (e) {
      print('❌ Error fetching games by bazaar: $e');
      return <GameModel>[];
    }
  }

  Stream<List<GameModel>> watchGamesByBazaar(String bazaarId) {
    print('👁️ Setting up real-time games listener for bazaar: $bazaarId');
    return _database.ref('games').orderByChild('bazaarId').equalTo(bazaarId).onValue.map((event) {
      print('🔄 Games data changed for bazaar: $bazaarId');

      if (!event.snapshot.exists || event.snapshot.value == null) {
        print('⚠️ No games in Firebase snapshot for bazaar: $bazaarId');
        return <GameModel>[];
      }

      try {
        final gamesData = Map<String, dynamic>.from(event.snapshot.value as Map);
        final games = <GameModel>[];

        gamesData.forEach((key, value) {
          try {
            if (value != null) {
              final gameData = Map<String, dynamic>.from(value as Map);
              gameData['gameId'] = key; // Ensure gameId is set
              final game = GameModel.fromMap(key, gameData);
              games.add(game);
            }
          } catch (e) {
            print('⚠️ Error parsing game $key: $e');
          }
        });

        print('🎮 Real-time games update for bazaar $bazaarId: ${games.length} games');
        return games;
      } catch (e) {
        print('❌ Error processing games stream: $e');
        return <GameModel>[];
      }
    });
  }

  // ==================== BETTING OPERATIONS ====================

  Future<String> placeBet(BetModel bet) async {
    try {
      print('🎲 Placing bet: ${bet.betTypeName} for ${bet.amount}');
      final betRef = _database.ref('bets').push();
      final betId = betRef.key!;
      
      final betData = bet.toMap();
      betData['id'] = betId;
      betData['placedAt'] = DateTime.now().millisecondsSinceEpoch;
      
      await betRef.set(betData);
      print('✅ Bet placed successfully: $betId');
      return betId;
    } catch (e) {
      print('❌ Error placing bet: $e');
      throw Exception('Failed to place bet: $e');
    }
  }

  Stream<List<BetModel>> getUserBetsStream(String userId) {
    print('👁️ Watching user bets: $userId');
    Query query = _database.ref('bets').orderByChild('userId').equalTo(userId);
    
    return query.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <BetModel>[];
      }

      final betsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final bets = <BetModel>[];

      betsData.forEach((key, value) {
        try {
          if (value != null) {
            final betData = Map<String, dynamic>.from(value as Map);
            betData['id'] = key; // Ensure id is set
            final bet = BetModel.fromMap(key, betData);
            bets.add(bet);
          }
        } catch (e) {
          print('⚠️ Error parsing bet $key: $e');
        }
      });

      // Sort by timestamp (newest first)
      bets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return bets;
    });
  }

  Future<List<BetModel>> getUserBets(String userId) async {
    try {
      print('🎯 Fetching user bets: $userId');
      final snapshot = await _database.ref('bets').orderByChild('userId').equalTo(userId).get();
      
      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No bets found for user: $userId');
        return <BetModel>[];
      }

      final betsData = Map<String, dynamic>.from(snapshot.value as Map);
      final bets = <BetModel>[];

      betsData.forEach((key, value) {
        try {
          if (value != null) {
            final betData = Map<String, dynamic>.from(value as Map);
            betData['id'] = key; // Ensure id is set
            final bet = BetModel.fromMap(key, betData);
            bets.add(bet);
          }
        } catch (e) {
          print('⚠️ Error parsing bet $key: $e');
        }
      });

      // Sort by timestamp (newest first)
      bets.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      print('✅ Found ${bets.length} bets for user: $userId');
      return bets;
    } catch (e) {
      print('❌ Error fetching user bets: $e');
      return <BetModel>[];
    }
  }

  // Get user's active bets for a game
  Stream<List<BetModel>> watchUserGameBets(String userId, String gameId) {
    return _database
        .ref('bets')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }

      final betsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final bets = <BetModel>[];

      betsData.forEach((key, value) {
        try {
          if (value != null) {
            final betData = Map<dynamic, dynamic>.from(value as Map);
            betData['id'] = key; // Ensure id is set
            final bet = BetModel.fromMap(key, betData);
            if (bet.gameId == gameId) {
              bets.add(bet);
            }
          }
        } catch (e) {
          print('⚠️ Error parsing bet $key: $e');
        }
      });

      return bets;
    });
  }

  Stream<user_model.UserModel?> watchUser(String userId) => getUserStream(userId);

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      print('🔄 Updating user profile: $userId with ${updates.keys}');
      await _database.ref('users/$userId/profile').update(updates);
      print('✅ User profile updated successfully');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      print('🔄 Updating data at: $path');
      await _database.ref(path).update(data);
      print('✅ Data updated successfully');
    } catch (e) {
      print('❌ Error updating data: $e');
      throw Exception('Failed to update data: $e');
    }
  }

  // ==================== BAZAAR OPERATIONS ====================
  
  Future<List<BazaarModel>> getBazaars() async {
    try {
      print('🏪 Fetching all bazaars...');
      final snapshot = await _database.ref('bazaars').get();
      
      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No bazaars found in Firebase');
        return <BazaarModel>[];
      }

      final bazaarsData = Map<String, dynamic>.from(snapshot.value as Map);
      final bazaars = <BazaarModel>[];

      bazaarsData.forEach((key, value) {
        try {
          if (value != null) {
            final bazaarData = Map<String, dynamic>.from(value as Map);
            bazaarData['bazaarId'] = key; // Ensure bazaarId is set
            final bazaar = BazaarModel.fromMap(key, bazaarData);
            bazaars.add(bazaar);
          }
        } catch (e) {
          print('⚠️ Error parsing bazaar $key: $e');
        }
      });

      print('✅ Found ${bazaars.length} bazaars');
      return bazaars;
    } catch (e) {
      print('❌ Error fetching bazaars: $e');
      return <BazaarModel>[];
    }
  }

  Stream<List<BazaarModel>> watchBazaars() {
    print('👁️ Setting up real-time bazaars listener...');
    return _database.ref('bazaars').onValue.map((event) {
      print('🔄 Bazaars data changed, processing...');

      if (!event.snapshot.exists || event.snapshot.value == null) {
        print('⚠️ No bazaars in Firebase snapshot');
        return <BazaarModel>[];
      }

      try {
        final bazaarsData = Map<String, dynamic>.from(event.snapshot.value as Map);
        final bazaars = <BazaarModel>[];

        bazaarsData.forEach((key, value) {
          try {
            if (value != null) {
              final bazaarData = Map<String, dynamic>.from(value as Map);
              bazaarData['bazaarId'] = key; // Ensure bazaarId is set
              final bazaar = BazaarModel.fromMap(key, bazaarData);
              bazaars.add(bazaar);
            }
          } catch (e) {
            print('⚠️ Error parsing bazaar $key: $e');
          }
        });

        print('🏪 Real-time bazaars update: ${bazaars.length} bazaars');
        return bazaars;
      } catch (e) {
        print('❌ Error processing bazaars stream: $e');
        return <BazaarModel>[];
      }
    });
  }

  // ==================== WALLET OPERATIONS ====================
  
  Stream<user_model.UserWallet?> watchUserWallet(String userId) {
    print('👁️ Watching user wallet: $userId');
    return _database.ref('users/$userId/wallet').onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final walletData = Map<String, dynamic>.from(event.snapshot.value as Map);
        return user_model.UserWallet.fromMap(walletData);
      }
      return null;
    });
  }

  // Add method for getting user wallet (non-stream)
  Future<user_model.UserWallet?> getUserWallet(String userId) async {
    try {
      print('💰 Fetching user wallet: $userId');
      final snapshot = await _database.ref('users/$userId/wallet').get();
      
      if (snapshot.exists && snapshot.value != null) {
        final walletData = Map<String, dynamic>.from(snapshot.value as Map);
        final wallet = user_model.UserWallet.fromMap(walletData);
        print('✅ User wallet fetched successfully');
        return wallet;
      }
      
      print('⚠️ No wallet found for user: $userId');
      return null;
    } catch (e) {
      print('❌ Error fetching user wallet: $e');
      return null;
    }
  }

  Future<void> updateUserWallet(String userId, Map<String, dynamic> updates) async {
    try {
      print('🔄 Updating user wallet: $userId with ${updates.keys}');
      await _database.ref('users/$userId/wallet').update(updates);
      print('✅ User wallet updated successfully');
    } catch (e) {
      print('❌ Error updating user wallet: $e');
      throw Exception('Failed to update user wallet: $e');
    }
  }

  // ==================== TRANSACTION OPERATIONS ====================
  
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      print('💰 Creating transaction: ${transaction.id}');
      await _database.ref('transactions/${transaction.id}').set(transaction.toMap());
      print('✅ Transaction created successfully');
    } catch (e) {
      print('❌ Error creating transaction: $e');
      throw Exception('Failed to create transaction: $e');
    }
  }

  Stream<List<TransactionModel>> watchUserTransactions(String userId, {int? limit}) {
    print('👁️ Watching user transactions: $userId');
    Query query = _database.ref('transactions').orderByChild('userId').equalTo(userId);
    
    if (limit != null) {
      query = query.limitToLast(limit);
    }
    
    return query.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <TransactionModel>[];
      }

      final transactionsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final transactions = <TransactionModel>[];

      transactionsData.forEach((key, value) {
        try {
          if (value != null) {
            final transactionData = Map<String, dynamic>.from(value as Map);
            transactionData['id'] = key; // Ensure id is set
            final transaction = TransactionModel.fromMap(key, transactionData);
            transactions.add(transaction);
          }
        } catch (e) {
          print('⚠️ Error parsing transaction $key: $e');
        }
      });

      // Sort by timestamp (newest first)
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return transactions;
    });
  }

  // Add alias method for compatibility
  Stream<List<TransactionModel>> getUserTransactionsStream(String userId) {
    return watchUserTransactions(userId);
  }

  // Add method for getting user transactions (non-stream)
  Future<List<TransactionModel>> getUserTransactions(String userId, {int? limit}) async {
    try {
      print('💳 Fetching user transactions: $userId');
      Query query = _database.ref('transactions').orderByChild('userId').equalTo(userId);
      
      if (limit != null) {
        query = query.limitToLast(limit);
      }
      
      final snapshot = await query.get();
      
      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No transactions found for user: $userId');
        return <TransactionModel>[];
      }

      final transactionsData = Map<String, dynamic>.from(snapshot.value as Map);
      final transactions = <TransactionModel>[];

      transactionsData.forEach((key, value) {
        try {
          if (value != null) {
            final transactionData = Map<String, dynamic>.from(value as Map);
            transactionData['id'] = key; // Ensure id is set
            final transaction = TransactionModel.fromMap(key, transactionData);
            transactions.add(transaction);
          }
        } catch (e) {
          print('⚠️ Error parsing transaction $key: $e');
        }
      });

      // Sort by timestamp (newest first)
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      print('✅ Found ${transactions.length} transactions for user: $userId');
      return transactions;
    } catch (e) {
      print('❌ Error fetching user transactions: $e');
      return <TransactionModel>[];
    }
  }

  // ==================== RECHARGE & WITHDRAWAL OPERATIONS ====================
  
  Future<void> createRechargeRequest(Map<String, dynamic> rechargeData) async {
    try {
      final rechargeId = _generateId();
      print('💰 Creating recharge request: $rechargeId');
      await _database.ref('rechargeRequests/$rechargeId').set(rechargeData);
      print('✅ Recharge request created successfully');
    } catch (e) {
      print('❌ Error creating recharge request: $e');
      throw Exception('Failed to create recharge request: $e');
    }
  }

  Future<void> createWithdrawalRequest(Map<String, dynamic> withdrawalData) async {
    try {
      final withdrawalId = _generateId();
      print('💰 Creating withdrawal request: $withdrawalId');
      await _database.ref('withdrawalRequests/$withdrawalId').set(withdrawalData);
      print('✅ Withdrawal request created successfully');
    } catch (e) {
      print('❌ Error creating withdrawal request: $e');
      throw Exception('Failed to create withdrawal request: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> watchRechargeRequests(String userId) {
    print('👁️ Watching recharge requests: $userId');
    return _database.ref('rechargeRequests').orderByChild('userId').equalTo(userId).onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Map<String, dynamic>>[];
      }

      final requestsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final requests = <Map<String, dynamic>>[];

      requestsData.forEach((key, value) {
        if (value != null) {
          final requestData = Map<String, dynamic>.from(value as Map);
          requestData['id'] = key;
          requests.add(requestData);
        }
      });

      return requests;
    });
  }

  Stream<List<Map<String, dynamic>>> watchWithdrawalRequests(String userId) {
    print('👁️ Watching withdrawal requests: $userId');
    return _database.ref('withdrawalRequests').orderByChild('userId').equalTo(userId).onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Map<String, dynamic>>[];
      }

      final requestsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final requests = <Map<String, dynamic>>[];

      requestsData.forEach((key, value) {
        if (value != null) {
          final requestData = Map<String, dynamic>.from(value as Map);
          requestData['id'] = key;
          requests.add(requestData);
        }
      });

      return requests;
    });
  }

  // ==================== RESULTS OPERATIONS ====================
  
  Future<List<Map<String, dynamic>>> getGameResults(String gameId, {int? limit}) async {
    try {
      print('🏆 Fetching results for game: $gameId');
      final snapshot = await _database.ref('results').orderByChild('gameId').equalTo(gameId).get();
      
      if (!snapshot.exists || snapshot.value == null) {
        print('⚠️ No results found for game: $gameId');
        return <Map<String, dynamic>>[];
      }

      final resultsData = Map<String, dynamic>.from(snapshot.value as Map);
      final results = <Map<String, dynamic>>[];

      resultsData.forEach((key, value) {
        if (value != null) {
          final resultData = Map<String, dynamic>.from(value as Map);
          resultData['id'] = key;
          results.add(resultData);
        }
      });

      if (limit != null && results.length > limit) {
        results.sort((a, b) => (b['declaredAt'] ?? 0).compareTo(a['declaredAt'] ?? 0));
        final limitedResults = results.take(limit).toList();
        return limitedResults;
      }

      print('✅ Found ${results.length} results for game: $gameId');
      return results;
    } catch (e) {
      print('❌ Error fetching game results: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Stream<List<ResultModel>> getTodayResultsStream() {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return _database.ref('results').orderByChild('date').equalTo(todayStr).onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <ResultModel>[];
      }

      final resultsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final results = <ResultModel>[];

      resultsData.forEach((key, value) {
        if (value != null) {
          try {
            final resultData = Map<dynamic, dynamic>.from(value as Map);
            final result = ResultModel.fromMap(key, resultData);
            results.add(result);
          } catch (e) {
            debugPrint('Error parsing result: $e');
          }
        }
      });

      // Sort by declared time descending
      results.sort((a, b) => b.declaredAt.compareTo(a.declaredAt));
      return results;
    });
  }

  Stream<List<ResultModel>> getRecentResultsStream() {
    final now = DateTime.now();
    final oneDayAgo = now.subtract(Duration(days: 1));
    
    return _database.ref('results').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <ResultModel>[];
      }

      final resultsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final results = <ResultModel>[];

      resultsData.forEach((key, value) {
        if (value != null) {
          try {
            final resultData = Map<dynamic, dynamic>.from(value as Map);
            final result = ResultModel.fromMap(key, resultData);
            
            // Only include recent results (within last 24 hours)
            if (result.declaredAt.isAfter(oneDayAgo)) {
              results.add(result);
            }
          } catch (e) {
            debugPrint('Error parsing result: $e');
          }
        }
      });

      // Sort by declared time descending
      results.sort((a, b) => b.declaredAt.compareTo(a.declaredAt));
      return results;
    });
  }

  Stream<List<ResultModel>> getAllResultsStream() {
    return _database.ref('results').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <ResultModel>[];
      }

      final resultsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final results = <ResultModel>[];

      resultsData.forEach((key, value) {
        if (value != null) {
          try {
            final resultData = Map<dynamic, dynamic>.from(value as Map);
            final result = ResultModel.fromMap(key, resultData);
            results.add(result);
          } catch (e) {
            debugPrint('Error parsing result: $e');
          }
        }
      });

      // Sort by declared time descending
      results.sort((a, b) => b.declaredAt.compareTo(a.declaredAt));
      return results;
    });
  }

  Stream<List<TransactionModel>> watchUserTransactionsByType(String userId, TransactionType type) {
    return _database.ref('transactions')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <TransactionModel>[];
      }

      final transactionsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final transactions = <TransactionModel>[];

      transactionsData.forEach((key, value) {
        if (value != null) {
          try {
            final transactionData = Map<String, dynamic>.from(value as Map);
            final transaction = TransactionModel.fromMap(key, transactionData);
            
            // Filter by transaction type
            if (transaction.type == type) {
              transactions.add(transaction);
            }
          } catch (e) {
            debugPrint('Error parsing transaction: $e');
          }
        }
      });

      // Sort by timestamp descending (newest first)
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return transactions;
    });
  }

  // ==================== UTILITY METHODS ====================
  
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           (1000 + DateTime.now().microsecond).toString();
  }

  // Public method for generating IDs
  String generateId() => _generateId();

  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      print('📊 Getting database info...');
      final gamesSnapshot = await _database.ref('games').get();
      final usersSnapshot = await _database.ref('users').get();
      final betsSnapshot = await _database.ref('bets').get();
      final transactionsSnapshot = await _database.ref('transactions').get();
      final resultsSnapshot = await _database.ref('results').get();

      final info = {
        'games': gamesSnapshot.exists ? (gamesSnapshot.value as Map).length : 0,
        'users': usersSnapshot.exists ? (usersSnapshot.value as Map).length : 0,
        'bets': betsSnapshot.exists ? (betsSnapshot.value as Map).length : 0,
        'transactions': transactionsSnapshot.exists ? (transactionsSnapshot.value as Map).length : 0,
        'results': resultsSnapshot.exists ? (resultsSnapshot.value as Map).length : 0,
        'databaseUrl': 'https://sitara777-admin-api-default-rtdb.asia-southeast1.firebasedatabase.app',
        'region': 'asia-southeast1',
      };

      print('📈 Database info: $info');
      return info;
    } catch (e) {
      print('❌ Error getting database info: $e');
      return {'error': e.toString()};
    }
  }

  Stream<List<Map<String, dynamic>>> watchResults() {
    return _database.ref('results').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Map<String, dynamic>>[];
      }

      final resultsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final results = <Map<String, dynamic>>[];

      resultsData.forEach((key, value) {
        if (value != null) {
          final resultData = Map<dynamic, dynamic>.from(value as Map);
          resultData['id'] = key;
          results.add(Map<String, dynamic>.from(resultData));
        }
      });

      return results;
    });
  }

  Future<Map<String, dynamic>?> readData(String path) async {
    try {
      print('📖 Reading data from: $path');
      final snapshot = await _database.ref(path).get();
      
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
        print('✅ Data read successfully');
        return Map<String, dynamic>.from(data);
      }
      
      print('⚠️ No data found at: $path');
      return null;
    } catch (e) {
      print('❌ Error reading data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAppSettings() async {
    try {
      print('⚙️ Fetching app settings...');
      final snapshot = await _database.ref('appSettings').get();
      
      if (snapshot.exists && snapshot.value != null) {
        final settings = Map<dynamic, dynamic>.from(snapshot.value as Map);
        print('✅ App settings fetched successfully');
        return Map<String, dynamic>.from(settings);
      }
      
      print('⚠️ No app settings found');
      return null;
    } catch (e) {
      print('❌ Error fetching app settings: $e');
      return null;
    }
  }

  Future<void> performBatchUpdate(Map<String, dynamic> updates) async {
    try {
      debugPrint('Performing batch update...');
      await _database.ref().update(updates);
      debugPrint('Batch update completed successfully');
    } catch (e) {
      debugPrint('Error performing batch update: $e');
      throw Exception('Failed to perform batch update: $e');
    }
  }

  // Get wallet statistics
  Future<Map<String, dynamic>> getWalletStatistics() async {
    try {
      final transactions = await _database.ref('transactions').get();
      final data = transactions.value as Map? ?? {};
      
      int totalTransactions = 0;
      double totalInflow = 0.0;
      double totalOutflow = 0.0;
      
      data.forEach((key, value) {
        try {
          final txn = Map<String, dynamic>.from(value as Map);
          totalTransactions++;
          if (txn['type'] == 'credit') {
            totalInflow += (txn['amount'] ?? 0.0) as double;
          } else {
            totalOutflow += (txn['amount'] ?? 0.0) as double;
          }
        } catch (e) {
          debugPrint('Error parsing transaction for statistics: $e');
        }
      });
      
      return {
        'totalTransactions': totalTransactions,
        'totalInflow': totalInflow,
        'totalOutflow': totalOutflow,
        'netFlow': totalInflow - totalOutflow,
      };
    } catch (e) {
      debugPrint('Error getting wallet statistics: $e');
      rethrow;
    }
  }
  
  // Add a new payment transaction
  Future<void> addPaymentTransaction(PaymentTransaction transaction) async {
    try {
      await _firestore
          .collection('paymentTransactions')
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      print('Error adding payment transaction: $e');
      rethrow;
    }
  }
  
  // Get payment transactions for a user
  Stream<List<PaymentTransaction>> getUserPaymentTransactions(String userId) {
    try {
      return _firestore
          .collection('paymentTransactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PaymentTransaction.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print('Error fetching user payment transactions: $e');
      return Stream.value([]);
    }
  }
  
  // Get all payment transactions (for admin panel)
  Stream<List<PaymentTransaction>> getAllPaymentTransactions() {
    try {
      return _firestore
          .collection('paymentTransactions')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PaymentTransaction.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print('Error fetching all payment transactions: $e');
      return Stream.value([]);
    }
  }
  
  // Update payment transaction
  Future<void> updatePaymentTransaction(
      String transactionId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('paymentTransactions')
          .doc(transactionId)
          .update(data);
    } catch (e) {
      print('Error updating payment transaction: $e');
      rethrow;
    }
  }
  
  // Update payment transaction status
  Future<void> updatePaymentTransactionStatus(
      String transactionId, String status) async {
    try {
      await _firestore
          .collection('paymentTransactions')
          .doc(transactionId)
          .update({'status': status});
    } catch (e) {
      print('Error updating payment transaction status: $e');
      rethrow;
    }
  }
  
  // Verify UPI transaction by ID
  Future<bool> verifyUpiTransaction(String upiTransactionId) async {
    try {
      // In a real implementation, you would integrate with a UPI verification API
      // For now, we'll simulate verification
      // You could integrate with services like Razorpay, Paytm, etc. for actual verification
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      return true; // Simulate successful verification
    } catch (e) {
      print('Error verifying UPI transaction: $e');
      return false;
    }
  }
  
  // Credit user wallet
  Future<void> creditUserWallet({
    required String userId,
    required double amount,
    required TransactionType transactionType,
    required String description,
  }) async {
    try {
      // Create transaction record
      final transaction = TransactionModel(
        id: Uuid().v4(),
        userId: userId,
        amount: amount,
        type: transactionType,
        description: description,
        timestamp: DateTime.now(),
      );
      
      // Add transaction to user's transaction list
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());
      
      // Update user's wallet balance
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final currentBalance = userData['walletBalance'] ?? 0.0;
        final newBalance = currentBalance + amount;
        
        await _firestore.collection('users').doc(userId).update({
          'walletBalance': newBalance,
        });
      }
    } catch (e) {
      print('Error crediting user wallet: $e');
      rethrow;
    }
  }
}