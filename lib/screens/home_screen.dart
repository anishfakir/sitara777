import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/user_model.dart' as user_model;
import '../models/game_model_flexible.dart';
import '../models/user_wallet.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_icons.dart';
import '../utils/app_icon_theme.dart';
import '../widgets/app_drawer_widget.dart';
import 'wallet_screen.dart';
import 'game_screen.dart';
import 'debug_screen.dart';
import 'bid_history_screen.dart';
import 'results_screen.dart';
import 'login_screen.dart';
import 'admin_login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final List<Widget> _children = [
    GameScreen(),
    WalletScreen(),
    ResultsScreen(),
    BidHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sitara777'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Admin access button (for testing)
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Bids',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildGameCard(BuildContext context, GameModel game) {
    final isOpen = game.isBettingOpen;
    final isResultTime = game.isResultTime;
    
    return Card(
      elevation: AppTheme.cardShadow.blurRadius,
      shadowColor: AppTheme.cardShadow.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(game: game),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.mediumSpacing),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.largeRadius),
            gradient: isOpen 
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryBlue.withOpacity(0.1),
                      AppTheme.secondaryBlue.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isOpen ? AppTheme.primaryBlue : AppTheme.secondaryTextColor,
                      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: Text(
                      game.icon ?? '🎯',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: AppTheme.smallSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.displayName,
                          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          game.category.toUpperCase(),
                          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.mediumSpacing),
              
              // Game Timing
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.smallSpacing,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open',
                          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        Text(
                          game.openTime,
                          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Close',
                          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        Text(
                          game.closeTime,
                          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Game Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isResultTime 
                      ? AppTheme.accentYellow
                      : isOpen 
                          ? AppTheme.primaryBlue
                          : AppTheme.secondaryTextColor,
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
                child: Text(
                  isResultTime 
                      ? 'Result Time'
                      : isOpen 
                          ? 'Betting Open'
                          : 'Betting Closed',
                  style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: isResultTime ? AppTheme.primaryBlue : AppTheme.onPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}