import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/result_model.dart';
import '../models/game_model_flexible.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  late TabController _tabController;
  String _selectedFilter = 'all';
  String? _selectedGameId;
  List<GameModel> _games = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadGames();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    try {
      final games = await _databaseService.getGames();
      if (mounted) {
        setState(() {
          _games = games;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load games: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Filter Section
          _buildFilterSection(),
          
          // Results Content
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
                      labelColor: AppTheme.primaryMaroon,
                      unselectedLabelColor: AppTheme.textSecondary,
                      indicatorColor: AppTheme.primaryMaroon,
                      indicatorWeight: 3,
                      labelStyle: AppTheme.lightTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: AppTheme.lightTextTheme.titleMedium,
                      tabs: const [
                        Tab(text: 'All Results'),
                        Tab(text: 'Today'),
                        Tab(text: 'Recent'),
                      ],
                    ),
                  ),
                  
                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildResultsList('all'),
                        _buildResultsList('today'),
                        _buildResultsList('recent'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.largeSpacing),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Results',
        style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppTheme.primaryMaroon,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          onPressed: () => _showFilterDialog(),
          icon: Icon(
            _selectedGameId != null ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: Colors.white,
          ),
          tooltip: 'Filter by Game',
        ),
        IconButton(
          onPressed: () => _refreshResults(),
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.mediumSpacing),
      padding: const EdgeInsets.all(AppTheme.mediumSpacing),
      decoration: AppTheme.primaryCardDecoration,
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: AppTheme.primaryMaroon,
            size: 24,
          ),
          const SizedBox(width: AppTheme.smallSpacing),
          Text(
            'Live Results',
            style: AppTheme.lightTextTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMaroon,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.smallSpacing,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(String filter) {
    Stream<List<ResultModel>> resultsStream;
    
    switch (filter) {
      case 'today':
        resultsStream = _databaseService.getTodayResultsStream();
        break;
      case 'recent':
        resultsStream = _databaseService.getRecentResultsStream();
        break;
      default:
        resultsStream = _databaseService.getAllResultsStream();
    }

    // Apply game filter if selected
    if (_selectedGameId != null) {
      resultsStream = resultsStream.asyncMap((results) {
        return results.where((result) => result.gameId == _selectedGameId).toList();
      });
    }

    return StreamBuilder<List<ResultModel>>(
      stream: resultsStream,
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
                  size: 48,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Text(
                  'Error loading results',
                  style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                  ),
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final results = snapshot.data ?? [];
        
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 48,
                  color: AppTheme.secondaryTextColor,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Text(
                  'No results available',
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
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return _buildResultItem(result);
          },
        );
      },
    );
  }

  Widget _buildResultItem(ResultModel result) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.smallSpacing),
      elevation: 0,
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppTheme.mediumSpacing),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryMaroon.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          child: Center(
            child: Text(
              result.result,
              style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryMaroon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          result.gameName,
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              result.declaredAt.toLocal().toString().split('.').first,
              style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Bazaar: ${result.gameName}',
              style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.smallSpacing,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
          ),
          child: Text(
            'Declared',
            style: AppTheme.lightTextTheme.bodySmall?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.largeSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Game',
                    style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.mediumSpacing),
              ListTile(
                title: const Text('All Games'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: _selectedGameId,
                  onChanged: (value) {
                    setState(() {
                      _selectedGameId = null;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedGameId = null;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ..._games.map((game) {
                return ListTile(
                  title: Text(game.displayName),
                  subtitle: Text('${game.category} • ${game.openTime} - ${game.closeTime}'),
                  leading: Radio<String>(
                    value: game.id,
                    groupValue: _selectedGameId,
                    onChanged: (value) {
                      setState(() {
                        _selectedGameId = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _selectedGameId = game.id;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _refreshResults() {
    setState(() {});
    _showErrorSnackBar('Results refreshed');
  }
}