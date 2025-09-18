// Test Data Generator for Firebase
// Run this with: dart run test_data_generator.dart
// Make sure to have firebase_core and firebase_database in pubspec.yaml

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  print('🚀 Initializing Firebase...');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  print('✅ Firebase initialized successfully!');
  
  final database = FirebaseDatabase.instance;
  
  // Test connection
  try {
    print('\n🔍 Testing Firebase connection...');
    final testRef = database.ref('test');
    await testRef.set({'timestamp': DateTime.now().millisecondsSinceEpoch});
    print('✅ Firebase connection successful!');
    
    // Clean up test data
    await testRef.remove();
    
  } catch (e) {
    print('❌ Firebase connection failed: $e');
    exit(1);
  }
  
  // Create sample games
  print('\n📝 Creating sample games...');
  
  final gamesRef = database.ref('games');
  
  // Sample Game 1: Delhi Bazaar
  final game1Id = 'game_delhi_bazaar';
  final game1Data = {
    'name': 'delhi_bazaar',
    'displayName': 'Delhi Bazaar',
    'description': 'Classic Delhi Bazaar matka game',
    'type': 'matka',
    'category': 'bazaar',
    'icon': 'assets/icons/delhi.png',
    'banner': 'assets/banners/delhi_banner.png',
    'isActive': true,
    'openTime': '10:00',
    'closeTime': '11:00',
    'resultTime': '11:30',
    'betTypes': {
      'single': {
        'name': 'single',
        'displayName': 'Single',
        'minBet': 10,
        'maxBet': 1000,
        'winMultiplier': 9.5,
        'isActive': true
      },
      'jodi': {
        'name': 'jodi',
        'displayName': 'Jodi',
        'minBet': 10,
        'maxBet': 1000,
        'winMultiplier': 95.0,
        'isActive': true
      },
      'patti': {
        'name': 'patti',
        'displayName': 'Patti',
        'minBet': 10,
        'maxBet': 1000,
        'winMultiplier': 950.0,
        'isActive': true
      }
    },
    'rates': {
      'single': 9.5,
      'jodi': 95.0,
      'patti': 950.0,
      'halfSangam': 1000.0,
      'fullSangam': 10000.0
    },
    'createdAt': DateTime.now().millisecondsSinceEpoch,
    'updatedAt': DateTime.now().millisecondsSinceEpoch,
    'createdBy': 'system'
  };
  
  // Sample Game 2: Mumbai Bazaar
  final game2Id = 'game_mumbai_bazaar';
  final game2Data = {
    'name': 'mumbai_bazaar',
    'displayName': 'Mumbai Bazaar',
    'description': 'Popular Mumbai Bazaar matka game',
    'type': 'matka',
    'category': 'bazaar',
    'icon': 'assets/icons/mumbai.png',
    'banner': 'assets/banners/mumbai_banner.png',
    'isActive': true,
    'openTime': '12:00',
    'closeTime': '13:00',
    'resultTime': '13:30',
    'betTypes': {
      'single': {
        'name': 'single',
        'displayName': 'Single',
        'minBet': 10,
        'maxBet': 2000,
        'winMultiplier': 9.5,
        'isActive': true
      },
      'jodi': {
        'name': 'jodi',
        'displayName': 'Jodi',
        'minBet': 10,
        'maxBet': 2000,
        'winMultiplier': 95.0,
        'isActive': true
      }
    },
    'rates': {
      'single': 9.5,
      'jodi': 95.0,
      'patti': 950.0,
      'halfSangam': 1000.0,
      'fullSangam': 10000.0
    },
    'createdAt': DateTime.now().millisecondsSinceEpoch,
    'updatedAt': DateTime.now().millisecondsSinceEpoch,
    'createdBy': 'system'
  };
  
  // Sample Game 3: Kolkata Bazaar (Inactive for testing)
  final game3Id = 'game_kolkata_bazaar';
  final game3Data = {
    'name': 'kolkata_bazaar',
    'displayName': 'Kolkata Bazaar',
    'description': 'Traditional Kolkata Bazaar game',
    'type': 'matka',
    'category': 'bazaar',
    'icon': 'assets/icons/kolkata.png',
    'banner': 'assets/banners/kolkata_banner.png',
    'isActive': false, // Inactive for testing filtering
    'openTime': '14:00',
    'closeTime': '15:00',
    'resultTime': '15:30',
    'betTypes': {
      'single': {
        'name': 'single',
        'displayName': 'Single',
        'minBet': 5,
        'maxBet': 500,
        'winMultiplier': 9.5,
        'isActive': true
      }
    },
    'rates': {
      'single': 9.5,
      'jodi': 95.0,
      'patti': 950.0,
      'halfSangam': 1000.0,
      'fullSangam': 10000.0
    },
    'createdAt': DateTime.now().millisecondsSinceEpoch,
    'updatedAt': DateTime.now().millisecondsSinceEpoch,
    'createdBy': 'system'
  };
  
  try {
    // Add games to database
    await gamesRef.child(game1Id).set(game1Data);
    print('✅ Created Delhi Bazaar game');
    
    await gamesRef.child(game2Id).set(game2Data);
    print('✅ Created Mumbai Bazaar game');
    
    await gamesRef.child(game3Id).set(game3Data);
    print('✅ Created Kolkata Bazaar game (inactive)');
    
    print('\n🎉 Sample games created successfully!');
    
    // Verify data was created
    print('\n🔍 Verifying created data...');
    final snapshot = await gamesRef.get();
    if (snapshot.exists) {
      final games = snapshot.value as Map;
      print('📊 Total games in database: ${games.length}');
      games.forEach((key, value) {
        final gameData = value as Map;
        print('  - ${gameData['displayName']} (${gameData['isActive'] ? 'Active' : 'Inactive'})');
      });
    } else {
      print('❌ No games found after creation');
    }
    
  } catch (e) {
    print('❌ Error creating sample games: $e');
    exit(1);
  }
  
  print('\n✨ Test data generation completed!');
  print('📱 You can now test the Flutter app to see if games are displayed.');
  
  exit(0);
}

