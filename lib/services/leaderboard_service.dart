import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/leaderboard_model.dart';

class LeaderboardService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<LeaderboardModel>> getLeaderboard({int? limit}) async {
    try {
      Query query = _database.child('leaderboard').orderByChild('score');
      
      if (limit != null) {
        query = query.limitToLast(limit);
      }
      
      final snapshot = await query.get();
      
      if (!snapshot.exists) {
        return [];
      }

      final leaderboard = <LeaderboardModel>[];
      final data = snapshot.value as Map;
      
      data.forEach((key, value) {
        leaderboard.add(LeaderboardModel.fromMap(
          key,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      
      return leaderboard.reversed.toList(); // Return in descending order
    } catch (e) {
      debugPrint('Error getting leaderboard: $e');
      return [];
    }
  }

  Stream<List<LeaderboardModel>> watchLeaderboard({int? limit}) {
    return _database
        .child('leaderboard')
        .orderByChild('score')
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return [];
          
          final leaderboard = <LeaderboardModel>[];
          final data = event.snapshot.value as Map;
          
          data.forEach((key, value) {
            leaderboard.add(LeaderboardModel.fromMap(
              key,
              Map<String, dynamic>.from(value as Map),
            ));
          });
          
          leaderboard.sort((a, b) => b.score.compareTo(a.score));
          
          if (limit != null && leaderboard.length > limit) {
            return leaderboard.take(limit).toList();
          }
          
          return leaderboard;
        });
  }

  Future<LeaderboardModel?> getUserRank(String userId) async {
    try {
      final snapshot = await _database
          .child('leaderboard')
          .child(userId)
          .get();
      
      if (!snapshot.exists) {
        return null;
      }
      
      return LeaderboardModel.fromMap(
        userId,
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    } catch (e) {
      debugPrint('Error getting user rank: $e');
      return null;
    }
  }

  Future<void> updateUserScore(String userId, int score) async {
    try {
      await _database
          .child('leaderboard')
          .child(userId)
          .update({
            'score': score,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating user score: $e');
      rethrow;
    }
  }

  Future<void> incrementUserScore(String userId, int increment) async {
    try {
      final userRank = await getUserRank(userId);
      if (userRank != null) {
        await updateUserScore(userId, userRank.score + increment);
      } else {
        await updateUserScore(userId, increment);
      }
    } catch (e) {
      debugPrint('Error incrementing user score: $e');
      rethrow;
    }
  }

  Future<void> resetLeaderboard() async {
    try {
      await _database.child('leaderboard').remove();
    } catch (e) {
      debugPrint('Error resetting leaderboard: $e');
      rethrow;
    }
  }
}