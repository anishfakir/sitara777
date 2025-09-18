import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/game_model_flexible.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_icons.dart';
import '../utils/app_icon_theme.dart';

class GameScreen extends StatefulWidget {
  final GameModel game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String? _error;

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      try {
        final userData = await _databaseService.getUser(_currentUser!.uid);
        setState(() {
          _user = userData;
          _isLoading = false;
          _error = null;
        });
      } catch (e) {
        print('Error loading user data: $e');
        setState(() {
          _isLoading = false;
          _error = 'Failed to load user data. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.game.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: AppIcons.material(AppIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: AppIcons.awesome(AppIcons.info),
            onPressed: () => _showGameInfo(context),
          ),
        ],
        backgroundColor: AppTheme.primaryMaroon,
        foregroundColor: AppTheme.onPrimaryTextColor,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMaroon),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading game details...',
                    style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcons.awesome(AppIcons.error, 
                        size: 48, 
                        color: Colors.red[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AppIconTheme.buildActionButton(
                        text: 'Try Again',
                        icon: AppIcons.refresh,
                        onPressed: _loadUserData,
                        useFontAwesome: true,
                        color: AppTheme.primaryMaroon,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGameInfoCard(),
                  const SizedBox(height: 16),
                  _buildUserInfoCard(),
                  const SizedBox(height: 16),
                  _buildBettingStatusCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildGameInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcons.awesome(AppIcons.gamepad, color: AppTheme.primaryMaroon),
                const SizedBox(width: 12),
                Text(
                  'Game Information',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRowWithIcon(
              AppIcons.dice,
              'Game ID',
              widget.game.gameId,
            ),
            _buildInfoRowWithIcon(
              AppIcons.clock,
              'Open Time',
              widget.game.openTime,
              useFontAwesome: true,
            ),
            _buildInfoRowWithIcon(
              AppIcons.clock,
              'Close Time',
              widget.game.closeTime,
              useFontAwesome: true,
            ),
            _buildInfoRowWithIcon(
              AppIcons.trophy,
              'Result Time',
              widget.game.resultTime,
              useFontAwesome: true,
            ),
            _buildInfoRowWithIcon(
              widget.game.isBettingOpen ? AppIcons.play : AppIcons.stop,
              'Status',
              widget.game.isBettingOpen ? 'Open' : 'Closed',
              useFontAwesome: true,
              valueColor: widget.game.isBettingOpen ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    if (_user == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcons.material(AppIcons.profile, color: AppTheme.primaryMaroon),
                const SizedBox(width: 12),
                Text(
                  'User Information',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRowWithIcon(
              AppIcons.profile,
              'Name',
              _user!.profile.name,
            ),
            _buildInfoRowWithIcon(
              AppIcons.phone,
              'Phone',
              _user!.profile.phone,
            ),
            _buildInfoRowWithIcon(
              AppIcons.money,
              'Balance',
              '₹${_user!.wallet.balance.toStringAsFixed(2)}',
              useFontAwesome: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBettingStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcons.awesome(
                  widget.game.isBettingOpen ? AppIcons.play : AppIcons.stop,
                  color: widget.game.isBettingOpen ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  'Betting Status',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: AppIconTheme.buildGameStatusIcon(
                widget.game.isBettingOpen ? 'open' : 'closed',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.game.isBettingOpen 
                  ? 'You can place bets now!'
                  : 'Betting is currently closed for this game.',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (widget.game.isBettingOpen) ... [
              const SizedBox(height: 24),
              AppIconTheme.buildActionButton(
                text: 'Place Bet',
                icon: AppIcons.money,
                onPressed: () {
                  // TODO: Implement betting logic
                },
                useFontAwesome: true,
                color: AppTheme.primaryMaroon,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowWithIcon(
    IconData icon,
    String label,
    String value, {
    bool useFontAwesome = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: useFontAwesome
                ? AppIcons.awesome(icon, size: 16, color: AppTheme.textSecondary)
                : AppIcons.material(icon, size: 20, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            AppIcons.awesome(AppIcons.info),
            const SizedBox(width: 8),
            const Text('Game Rules'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Minimum bet amount: ₹10',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '2. Maximum bet amount: ₹10,000',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '3. Betting closes 5 minutes before result',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
