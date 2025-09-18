import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WalletService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  Future<double> getWalletBalance(String userId) async {
    try {
      final snapshot = await _database.child('wallets').child(userId).get();
      if (snapshot.exists) {
        return (snapshot.value as Map)['balance']?.toDouble() ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error getting wallet balance: $e');
      return 0.0;
    }
  }

  Future<void> addToWallet(String userId, double amount) async {
    try {
      final currentBalance = await getWalletBalance(userId);
      await _database.child('wallets').child(userId).update({
        'balance': currentBalance + amount,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error adding to wallet: $e');
      rethrow;
    }
  }

  Future<void> deductFromWallet(String userId, double amount) async {
    try {
      final currentBalance = await getWalletBalance(userId);
      if (currentBalance < amount) {
        throw Exception('Insufficient balance');
      }
      
      await _database.child('wallets').child(userId).update({
        'balance': currentBalance - amount,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error deducting from wallet: $e');
      rethrow;
    }
  }

  Stream<double> watchWalletBalance(String userId) {
    return _database
        .child('wallets')
        .child(userId)
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return 0.0;
          final data = event.snapshot.value as Map;
          return data['balance']?.toDouble() ?? 0.0;
        });
  }

  Stream<List<Map<String, dynamic>>> watchRechargeRequests() {
    // TODO: Implement this method
    return Stream.value([]);
  }

  Stream<List<Map<String, dynamic>>> watchWithdrawalRequests() {
    // TODO: Implement this method
    return Stream.value([]);
  }

  Future<Map<String, dynamic>> getWalletStatistics() async {
    // TODO: Implement this method
    return {};
  }
}