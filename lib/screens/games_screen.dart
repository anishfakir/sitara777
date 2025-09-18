import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bazaar_model.dart';
import '../models/game_model_flexible.dart';
import '../services/database_service.dart';

import '../utils/app_theme.dart';
import 'bet_screen.dart';

class GamesScreen extends StatefulWidget {
  final BazaarModel bazaar;

  const GamesScreen({
    super.key,
    required this.bazaar,
  });

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryMaroon,
        foregroundColor: Colors.white,
        title: Text('🎮 ${widget.bazaar.displayName}'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<GameModel>>(
        stream: _databaseService.watchGamesByBazaar(widget.bazaar.bazaarId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.primaryMaroon,
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  Text(
                    'Loading games...',
                    style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  Text(
                    'Error loading games',
                    style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.smallSpacing),
                  Text(
                    'Please check your internet connection',
                    style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: AppTheme.primaryButtonStyle,
                  ),
                ],
              ),
            );
          }

          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.games_outlined,
                    size: 64,
                    color: AppTheme.secondaryTextColor,
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  Text(
                    'No games available',
                    style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.smallSpacing),
                  Text(
                    'Games will appear here when they become available in this game',
                    style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            color: AppTheme.primaryMaroon,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.mediumSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bazaar.displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.bazaar.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.largeSpacing),

                  // Games Section Header
                  Text(
                    'Games (${games.length})',
                    style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),

                  // Games Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: AppTheme.mediumSpacing,
                        mainAxisSpacing: AppTheme.mediumSpacing,
                      ),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return _buildGameCard(context, game as GameModel);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, GameModel game) {
    final isOpen = game.isBettingOpen;
    final isResultTime = game.isResultTime;
    final now = DateTime.now();
    final openTime = game.openTime;
    final closeTime = game.closeTime;
    final resultTime = game.resultTime;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (isResultTime) {
      statusText = 'RESULT TIME';
      statusColor = AppTheme.warningColor;
      statusIcon = Icons.timer;
    } else if (isOpen) {
      statusText = 'BETTING OPEN';
      statusColor = AppTheme.successColor;
      statusIcon = Icons.play_circle_filled;
    } else {
      statusText = 'CLOSED';
      statusColor = AppTheme.errorColor;
      statusIcon = Icons.pause_circle_filled;
    }

    return Card(
      elevation: AppTheme.smallElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BetScreen(
                bazaar: widget.bazaar,
                game: game,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.largeRadius),
            gradient: isOpen 
                ? LinearGradient(
                    colors: [
                      AppTheme.successColor.withOpacity(0.1),
                      AppTheme.successColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      AppTheme.secondaryTextColor.withOpacity(0.05),
                      AppTheme.secondaryTextColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.mediumSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryMaroon,
                        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Icon(
                        Icons.casino,
                        color: AppTheme.onPrimaryTextColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        game.displayName,
                        style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.mediumSpacing),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.mediumSpacing),

                // Time Info
                _buildTimeInfo('Open', game.openTime, Icons.play_arrow),
                const SizedBox(height: 4),
                _buildTimeInfo('Close', game.closeTime, Icons.stop),
                const SizedBox(height: 4),
                _buildTimeInfo('Result', game.resultTime, Icons.emoji_events),

                const Spacer(),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BetScreen(
                            bazaar: widget.bazaar,
                            game: game,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOpen ? AppTheme.primaryMaroon : AppTheme.secondaryTextColor,
                      foregroundColor: AppTheme.onPrimaryTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      isOpen ? 'Play Now' : 'View Game',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.secondaryTextColor,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryTextColor,
            fontSize: 11,
          ),
        ),
        Text(
          time,
          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
