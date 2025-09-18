import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/firebase_config.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/bid_history_screen.dart';
import 'screens/results_screen.dart';
import 'screens/recharge_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/admin_login_screen.dart';
import 'services/database_service.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
        Provider<DatabaseService>(create: (context) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'Sitara777',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
        routes: {
          '/admin': (context) => AdminPanelScreen(),
          '/admin-login': (context) => AdminLoginScreen(),
          '/home': (context) => HomeScreen(),
          '/wallet': (context) => WalletScreen(),
          '/bid_history': (context) => BidHistoryScreen(),
          '/results': (context) => ResultsScreen(),
          '/recharge': (context) => RechargeScreen(),
        },
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return the main app screen
    return MainTabScreen();
  }
}

class MainTabScreen extends StatefulWidget {
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  
  // Create a list of screens for the bottom navigation
  final List<Widget> _screens = [
    HomeScreen(),
    WalletScreen(),
    BidHistoryScreen(),
    ResultsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.secondaryTextColor,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Bids',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Results',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}