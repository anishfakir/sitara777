import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_profile_model.dart';

class UserProfileService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      final snapshot = await _database.child('profiles').child(userId).get();
      if (!snapshot.exists) {
        return null;
      }
      return UserProfileModel.fromMap(
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  Stream<UserProfileModel?> watchUserProfile(String userId) {
    return _database
        .child('profiles')
        .child(userId)
        .onValue
        .map((event) {
          if (!event.snapshot.exists) return null;
          return UserProfileModel.fromMap(
            Map<String, dynamic>.from(event.snapshot.value as Map),
          );
        });
  }

  Future<void> updateUserProfile(String userId, UserProfileModel profile) async {
    try {
      await _database
          .child('profiles')
          .child(userId)
          .update(profile.toMap());
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _database
          .child('profiles')
          .child(userId)
          .update({
            'profileImage': imageUrl,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating profile image: $e');
      rethrow;
    }
  }

  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await _database
          .child('profiles')
          .child(userId)
          .update({
            'displayName': displayName,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating display name: $e');
      rethrow;
    }
  }

  Future<void> updateBio(String userId, String bio) async {
    try {
      await _database
          .child('profiles')
          .child(userId)
          .update({
            'bio': bio,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Error updating bio: $e');
      rethrow;
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    try {
      await _database
          .child('profiles')
          .child(userId)
          .remove();
    } catch (e) {
      debugPrint('Error deleting user profile: $e');
      rethrow;
    }
  }
}