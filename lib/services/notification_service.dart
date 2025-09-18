import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // Initialize notifications
  static Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();
    
    // Get FCM token
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(token);
    }
    
    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _saveToken(newToken);
    });
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    // Handle message tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
    
    // Handle initial message if app is opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }
  
  // Request notification permissions
  static Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  
  // Save FCM token to SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    print('FCM Token: $token');
    // TODO: Send token to your server/Firebase Database if needed
  }
  
  // Get saved FCM token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
  
  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.notification?.title}');
    
    // Show local notification or update UI
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }
  
  // Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.notification?.title}');
    
    // Handle background logic
    if (message.data.isNotEmpty) {
      _processNotificationData(message.data);
    }
  }
  
  // Handle message tap
  static void _handleMessageTap(RemoteMessage message) {
    print('Message tapped: ${message.notification?.title}');
    
    // Navigate to specific screen based on message data
    if (message.data.isNotEmpty) {
      _handleNotificationNavigation(message.data);
    }
  }
  
  // Show local notification (you might want to use local_notifications package for better control)
  static void _showLocalNotification(RemoteMessage message) {
    // For now, just print the notification
    // In a real app, you'd use the local_notifications package
    print('Notification: ${message.notification?.title} - ${message.notification?.body}');
  }
  
  // Process notification data
  static void _processNotificationData(Map<String, dynamic> data) {
    final type = data['type'];
    
    switch (type) {
      case 'result_declared':
        // Handle result declaration
        final gameId = data['gameId'];
        final result = data['result'];
        print('Result declared for game $gameId: $result');
        break;
        
      case 'wallet_updated':
        // Handle wallet update
        final amount = data['amount'];
        print('Wallet updated: $amount');
        break;
        
      case 'bet_won':
        // Handle bet win
        final betId = data['betId'];
        final winAmount = data['winAmount'];
        print('Bet won: $betId, Amount: $winAmount');
        break;
        
      case 'announcement':
        // Handle general announcements
        final message = data['message'];
        print('Announcement: $message');
        break;
        
      default:
        print('Unknown notification type: $type');
    }
  }
  
  // Handle navigation based on notification
  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    
    switch (type) {
      case 'result_declared':
        // Navigate to results screen
        // NavigatorService.navigateTo('/results');
        break;
        
      case 'wallet_updated':
        // Navigate to wallet screen
        // NavigatorService.navigateTo('/wallet');
        break;
        
      case 'bet_won':
        // Navigate to bid history screen
        // NavigatorService.navigateTo('/bid-history');
        break;
        
      default:
        // Navigate to home screen
        // NavigatorService.navigateTo('/home');
    }
  }
  
  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }
  
  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
  
  // Subscribe to user-specific notifications
  static Future<void> subscribeToUserNotifications(String userId) async {
    await subscribeToTopic('user_$userId');
    await subscribeToTopic('general_announcements');
  }
  
  // Unsubscribe from user-specific notifications
  static Future<void> unsubscribeFromUserNotifications(String userId) async {
    await unsubscribeFromTopic('user_$userId');
  }
}
