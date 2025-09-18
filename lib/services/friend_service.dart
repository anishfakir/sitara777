import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sitara777/models/friend_model.dart';

class FriendService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<FriendModel>> getFriendsList(String userId) async {
    try {
      final snapshot = await _database.child('friends').child(userId).get();
      if (!snapshot.exists) {
        return [];
      }

      final friends = <FriendModel>[];
      final data = snapshot.value as Map;
      
      data.forEach((key, value) {
        friends.add(FriendModel.fromMap(
          Map<String, dynamic>.from(value as Map),
        ));
      });
      
      return friends;
    } catch (e) {
      debugPrint('Error getting friends list: $e');
      return [];
    }
  }

  Stream<List<FriendModel>> watchFriendsList(String userId) {
    return _database
        .child('friends')
        .child(userId)
        .onValue
        .map((event) {
          if (event.snapshot.value == null) return [];
          
          final friends = <FriendModel>[];
          final data = event.snapshot.value as Map;
          
          data.forEach((key, value) {
            friends.add(FriendModel.fromMap(
              Map<String, dynamic>.from(value as Map),
            ));
          });
          
          return friends;
        });
  }

  Future<void> addFriend(String userId, FriendModel friend) async {
    try {
      await _database
          .child('friends')
          .child(userId)
          .child(friend.id)
          .set(friend.toMap());
    } catch (e) {
      debugPrint('Error adding friend: $e');
      rethrow;
    }
  }

  Future<void> removeFriend(String userId, String friendId) async {
    try {
      await _database
          .child('friends')
          .child(userId)
          .child(friendId)
          .remove();
    } catch (e) {
      debugPrint('Error removing friend: $e');
      rethrow;
    }
  }

  Future<void> updateFriendStatus(String userId, String friendId, String status) async {
    try {
      await _database
          .child('friends')
          .child(userId)
          .child(friendId)
          .update({
            'status': status,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating friend status: $e');
      rethrow;
    }
  }
}