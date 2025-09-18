import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user profile in database
      if (credential.user != null) {
        // Create default user profile
        final userProfile = UserProfile(
          uid: credential.user!.uid,
          name: 'New User',
          phone: '',
          email: email,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        
        // Create default user wallet
        final userWallet = UserWallet(
          balance: 0.0,
          totalDeposited: 0.0,
          totalWithdrawn: 0.0,
          totalWinnings: 0.0,
          totalLosses: 0.0,
          lastUpdated: DateTime.now(),
        );
        
        // Create default user settings
        final userSettings = UserSettings();
        
        // Create complete user model
        final userModel = UserModel(
          uid: credential.user!.uid,
          profile: userProfile,
          wallet: userWallet,
          settings: userSettings,
        );
        
        await _databaseService.createUser(credential.user!.uid, userModel);
      }

      return credential;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(newPassword);
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      if (_auth.currentUser != null) {
        await _databaseService.deleteUser(_auth.currentUser!.uid);
        await _auth.currentUser!.delete();
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}