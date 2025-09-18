import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/bet_model.dart';
import '../utils/app_theme.dart';

class BettingService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  Future<void> placeBet(BetModel bet) async {
    try {
      await _database.child('bets').push().set(bet.toMap());
    } catch (e) {
      debugPrint('Error placing bet: $e');
      rethrow;
    }
  }

  Future<List<BetModel>> getUserBets(String userId, {int? limit}) async {
    try {
      Query query = _database.child('bets').orderByChild('userId').equalTo(userId);
      
      if (limit != null) {
        query = query.limitToLast(limit);
      }
      
      final snapshot = await query.get();
      
      if (!snapshot.exists) {
        return [];
      }
      
      final bets = <BetModel>[];
      for (final child in snapshot.children) {
        bets.add(BetModel.fromMap(
          child.key!,
          Map<String, dynamic>.from(child.value as Map),
        ));
      }
      
      return bets;
    } catch (e) {
      debugPrint('Error getting user bets: $e');
      return [];
    }
  }

  Stream<List<BetModel>> watchUserBets(String userId) {
    return _database
        .child('bets')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return [];
          
          final bets = <BetModel>[];
          final data = event.snapshot.value as Map;
          
          data.forEach((key, value) {
            bets.add(BetModel.fromMap(
              key,
              Map<String, dynamic>.from(value as Map),
            ));
          });
          
          return bets;
        });
  }

  Future<void> updateBetStatus(String betId, String status) async {
    try {
      await _database.child('bets').child(betId).update({
        'status': status,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error updating bet status: $e');
      rethrow;
    }
  }
}