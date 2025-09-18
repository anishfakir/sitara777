import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bet_model.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import '../widgets/app_drawer_widget.dart';
import 'package:intl/intl.dart';

class BidHistoryScreen extends StatefulWidget {
  const BidHistoryScreen({super.key});

  @override
  State<BidHistoryScreen> createState() => _BidHistoryScreenState();
}

class _BidHistoryScreenState extends State<BidHistoryScreen> with TickerProviderStateMixin {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: Icon(
                Icons.history,
                color: AppTheme.accentGold,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.smallSpacing),
            const Text(
              'Bid History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryMaroon,
        foregroundColor: AppTheme.onPrimaryTextColor,
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawerWidget(),
      body: _currentUser == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 64,
                    color: AppTheme.secondaryTextColor,
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  Text(
                    'Please login to view bid history',
                    style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<BetModel>>(
              stream: _databaseService.getUserBetsStream(_currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryMaroon,
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
                          'Error loading bid history',
                          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                            color: AppTheme.errorColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.smallSpacing),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          style: AppTheme.primaryButtonStyle,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final bets = snapshot.data ?? [];

                if (bets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.largeSpacing),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryMaroon.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.sports_esports_outlined,
                            size: 64,
                            color: AppTheme.primaryMaroon,
                          ),
                        ),
                        const SizedBox(height: AppTheme.largeSpacing),
                        Text(
                          'No bets placed yet',
                          style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.smallSpacing),
                        Text(
                          'Your betting history will appear here\nafter you place your first bet',
                          style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.largeSpacing),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.casino_outlined),
                          label: const Text('Place Your First Bet'),
                          style: AppTheme.primaryButtonStyle,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Enhanced Statistics Card
                    Container(
                      margin: const EdgeInsets.all(AppTheme.mediumSpacing),
                      decoration: AppTheme.primaryCardDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.largeSpacing),
                        child: Column(
                          children: [
                            Row(
                              children: [
                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGold,
                                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                                  ),
                                  child: Icon(
                                    Icons.analytics_outlined,
                                    color: AppTheme.primaryMaroon,
                                    size: 20,
                                  ),
                                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Expanded(
                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                      Text(
                        'Betting Statistics',
                                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                                          color: AppTheme.onPrimaryTextColor.withOpacity(0.8),
                        ),
                      ),
                                      const SizedBox(height: 4),
                      Text(
                        '${bets.length} Total Bets',
                        style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                                          color: AppTheme.onPrimaryTextColor,
                                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                                  ),
                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppTheme.mediumSpacing),
                            
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  'Won',
                                  bets.where((bet) => bet.status == BetStatus.won).length.toString(),
                                  Icons.emoji_events,
                                  AppTheme.primaryGreen,
                                ),
                                _buildStatItem(
                                  'Pending',
                                  bets.where((bet) => bet.status == BetStatus.pending).length.toString(),
                                  Icons.hourglass_empty,
                                  AppTheme.primaryBlue,
                                ),
                                _buildStatItem(
                                  'Lost',
                                  bets.where((bet) => bet.status == BetStatus.lost).length.toString(),
                                  Icons.close,
                                  AppTheme.primaryRed,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bets List with Tabs
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppTheme.mediumSpacing),
                        decoration: AppTheme.standardCardDecoration,
                        child: Column(
                          children: [
                            // Tab Bar
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppTheme.cardBorderRadius),
                                  topRight: Radius.circular(AppTheme.cardBorderRadius),
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelColor: AppTheme.primaryMaroon,
                                unselectedLabelColor: AppTheme.textSecondary,
                                indicatorColor: AppTheme.primaryMaroon,
                                indicatorWeight: 3,
                                labelStyle: AppTheme.lightTextTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelStyle: AppTheme.lightTextTheme.titleMedium,
                                tabs: const [
                                  Tab(text: 'All Bets'),
                                  Tab(text: 'Pending'),
                                  Tab(text: 'Won'),
                                  Tab(text: 'Lost'),
                                ],
                              ),
                            ),
                            
                            // Tab Content
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildBetsList(bets),
                                  _buildBetsList(bets.where((bet) => bet.status == BetStatus.pending).toList()),
                                  _buildBetsList(bets.where((bet) => bet.status == BetStatus.won).toList()),
                                  _buildBetsList(bets.where((bet) => bet.status == BetStatus.lost).toList()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.largeSpacing),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.onPrimaryTextColor,
          ),
        ),
        Text(
          title,
          style: AppTheme.lightTextTheme.bodySmall?.copyWith(
            color: AppTheme.onPrimaryTextColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBetsList(List<BetModel> bets) {
    if (bets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_outlined,
              size: 48,
              color: AppTheme.secondaryTextColor,
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            Text(
              'No bets found',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.mediumSpacing),
      itemCount: bets.length,
      itemBuilder: (context, index) {
        final bet = bets[index];
        return _buildBetItem(bet);
      },
    );
  }

  Widget _buildBetItem(BetModel bet) {
    Color statusColor;
    IconData statusIcon;
    
    switch (bet.status) {
      case BetStatus.won:
        statusColor = AppTheme.primaryGreen;
        statusIcon = Icons.emoji_events;
        break;
      case BetStatus.lost:
        statusColor = AppTheme.primaryRed;
        statusIcon = Icons.close;
        break;
      default:
        statusColor = AppTheme.primaryBlue;
        statusIcon = Icons.hourglass_empty;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.smallSpacing),
      elevation: 0,
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              ),
              child: Icon(statusIcon, color: statusColor, size: 16),
            ),
            const SizedBox(width: AppTheme.smallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bet.gameName,
                    style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(bet.timestamp).toLocal().toString().split('.').first,
                    style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${bet.amount.toStringAsFixed(2)}',
              style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${bet.betTypeName}: ${bet.betNumber}',
          style: AppTheme.lightTextTheme.bodyMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.mediumSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.smallSpacing,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            bet.status.toString().split('.').last.toUpperCase(),
                            style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                if (bet.result != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result',
                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      Text(
                        bet.result!,
                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.smallSpacing),
                ],
                if (bet.winAmount != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Winnings',
                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      Text(
                        '₹${bet.winAmount!.toStringAsFixed(2)}',
                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
