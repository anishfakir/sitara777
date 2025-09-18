import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/match_model.dart';

class MatchService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<MatchModel>> getActiveMatches() async {
    try {
      final snapshot = await _database
          .child('matches')
          .orderByChild('status')
          .equalTo('active')
          .get();
      
      if (!snapshot.exists) {
        return [];
      }

      final matches = <MatchModel>[];
      final data = snapshot.value as Map;
      
      data.forEach((key, value) {
        matches.add(MatchModel.fromMap(
          key,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      
      return matches;
    } catch (e) {
      debugPrint('Error getting active matches: $e');
      return [];
    }
  }

  Stream<List<MatchModel>> watchActiveMatches() {
    return _database
        .child('matches')
        .orderByChild('status')
        .equalTo('active')
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return [];
          
          final matches = <MatchModel>[];
          final data = event.snapshot.value as Map;
          
          data.forEach((key, value) {
            matches.add(MatchModel.fromMap(
              key,
              Map<String, dynamic>.from(value as Map),
            ));
          });
          
          return matches;
        });
  }

  Future<MatchModel?> getMatchById(String matchId) async {
    try {
      final snapshot = await _database.child('matches').child(matchId).get();
      if (!snapshot.exists) {
        return null;
      }
      return MatchModel.fromMap(
        matchId,
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    } catch (e) {
      debugPrint('Error getting match: $e');
      return null;
    }
  }

  Stream<MatchModel?> watchMatch(String matchId) {
    return _database
        .child('matches')
        .child(matchId)
        .onValue
        .map((event) {
          if (!event.snapshot.exists) return null;
          return MatchModel.fromMap(
            matchId,
            Map<String, dynamic>.from(event.snapshot.value as Map),
          );
        });
  }

  Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _database
          .child('matches')
          .child(matchId)
          .update({
            'status': status,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating match status: $e');
      rethrow;
    }
  }

  Future<void> updateMatchScore(String matchId, Map<String, dynamic> score) async {
    try {
      await _database
          .child('matches')
          .child(matchId)
          .update({
            'score': score,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating match score: $e');
      rethrow;
    }
  }

  Future<void> completeMatch(String matchId, Map<String, dynamic> results) async {
    try {
      await _database
          .child('matches')
          .child(matchId)
          .update({
            'results': results,
            'status': 'completed',
            'completedAt': DateTime.now().toIso8601String(),
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error completing match: $e');
      rethrow;
    }
  }
}