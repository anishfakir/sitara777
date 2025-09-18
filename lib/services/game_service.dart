import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/game_model_flexible.dart';

class GameService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<GameModel>> getAvailableGames() async {
    try {
      final snapshot = await _database.child('games').get();
      if (!snapshot.exists) {
        return [];
      }

      final games = <GameModel>[];
      final data = snapshot.value as Map;
      
      data.forEach((key, value) {
        games.add(GameModel.fromMap(
          key,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      
      return games;
    } catch (e) {
      debugPrint('Error getting games: $e');
      return [];
    }
  }

  Stream<List<GameModel>> watchAvailableGames() {
    return _database
        .child('games')
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return [];
          
          final games = <GameModel>[];
          final data = event.snapshot.value as Map;
          
          data.forEach((key, value) {
            games.add(GameModel.fromMap(
              key,
              Map<String, dynamic>.from(value as Map),
            ));
          });
          
          return games;
        });
  }

  Future<GameModel?> getGameById(String gameId) async {
    try {
      final snapshot = await _database.child('games').child(gameId).get();
      if (!snapshot.exists) {
        return null;
      }
      return GameModel.fromMap(
        gameId,
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    } catch (e) {
      debugPrint('Error getting game: $e');
      return null;
    }
  }

  Stream<GameModel?> watchGame(String gameId) {
    return _database
        .child('games')
        .child(gameId)
        .onValue
        .map((event) {
          if (!event.snapshot.exists) return null;
          return GameModel.fromMap(
            gameId,
            Map<String, dynamic>.from(event.snapshot.value as Map),
          );
        });
  }

  Future<void> updateGameStatus(String gameId, String status) async {
    try {
      await _database
          .child('games')
          .child(gameId)
          .update({
            'status': status,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating game status: $e');
      rethrow;
    }
  }

  Future<void> updateGameResults(String gameId, Map<String, dynamic> results) async {
    try {
      await _database
          .child('games')
          .child(gameId)
          .update({
            'results': results,
            'status': 'completed',
            'completedAt': DateTime.now().toIso8601String(),
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating game results: $e');
      rethrow;
    }
  }
}