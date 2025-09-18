import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final DatabaseService _databaseService = DatabaseService();
  bool _isConnected = false;
  Map<String, dynamic>? _databaseInfo;
  String? _connectionError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadDatabaseInfo();
  }

  Future<void> _checkConnection() async {
    setState(() => _isLoading = true);
    
    try {
      final connected = await _databaseService.testConnection();
      setState(() {
        _isConnected = connected;
        _connectionError = null;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _connectionError = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDatabaseInfo() async {
    try {
      final info = await _databaseService.getDatabaseInfo();
      setState(() => _databaseInfo = info);
    } catch (e) {
      setState(() => _databaseInfo = {'error': e.toString()});
    }
  }

  Future<void> _testGamesLoad() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading games...'), backgroundColor: Colors.blue),
      );
      
      final games = await _databaseService.getGames();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Loaded ${games.length} games successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Show games details
      _showGamesDialog(games);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error loading games: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showGamesDialog(List games) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Games Data (${games.length})'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: games.isEmpty
              ? const Center(child: Text('No games found'))
              : ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return Card(
                      child: ListTile(
                        title: Text(game.displayName ?? 'Unknown Game'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${game.gameId}'),
                            Text('Open: ${game.openTime} - Close: ${game.closeTime}'),
                            Text('Status: ${game.isBettingOpen ? 'Open' : 'Closed'}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _copyDatabaseUrl() {
    const url = 'https://sitara777-admin-api-default-rtdb.asia-southeast1.firebasedatabase.app';
    Clipboard.setData(const ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database URL copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Firebase Debug'),
        backgroundColor: AppTheme.primaryMaroon,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _checkConnection();
              _loadDatabaseInfo();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _checkConnection();
          await _loadDatabaseInfo();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isConnected ? Icons.cloud_done : Icons.cloud_off,
                            color: _isConnected ? Colors.green : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Firebase Connection',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  _isConnected ? 'Connected' : 'Disconnected',
                                  style: TextStyle(
                                    color: _isConnected ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isLoading) const CircularProgressIndicator(),
                        ],
                      ),
                      if (_connectionError != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Error: $_connectionError',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Database Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Database Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (_databaseInfo != null) ...[
                        _buildInfoRow('Region', 'Asia Southeast 1'),
                        _buildInfoRow('Games', '${_databaseInfo!['games'] ?? 0}'),
                        _buildInfoRow('Users', '${_databaseInfo!['users'] ?? 0}'),
                        _buildInfoRow('Bets', '${_databaseInfo!['bets'] ?? 0}'),
                        _buildInfoRow('Transactions', '${_databaseInfo!['transactions'] ?? 0}'),
                        _buildInfoRow('Results', '${_databaseInfo!['results'] ?? 0}'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Database URL:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            IconButton(
                              onPressed: _copyDatabaseUrl,
                              icon: const Icon(Icons.copy, size: 16),
                              tooltip: 'Copy URL',
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'https://sitara777-admin-api-default-rtdb.asia-southeast1.firebasedatabase.app',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
                          ),
                        ),
                      ] else
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Test Actions Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _testGamesLoad,
                          icon: const Icon(Icons.games),
                          label: const Text('Test Load Games'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryMaroon,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _checkConnection,
                          icon: const Icon(Icons.wifi),
                          label: const Text('Test Connection'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Real-time Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Real-time Connection Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<bool>(
                        stream: _databaseService.connectionStatus,
                        builder: (context, snapshot) {
                          final isConnected = snapshot.data ?? false;
                          final connectionState = snapshot.connectionState;
                          
                          return Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: connectionState == ConnectionState.waiting
                                      ? Colors.orange
                                      : isConnected
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                connectionState == ConnectionState.waiting
                                    ? 'Checking connection...'
                                    : isConnected
                                        ? 'Real-time connection active'
                                        : 'Real-time connection lost',
                                style: TextStyle(
                                  color: connectionState == ConnectionState.waiting
                                      ? Colors.orange
                                      : isConnected
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Instructions Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 Troubleshooting Guide',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. Check if your device has internet connection\n'
                        '2. Verify Firebase project is active in console\n'
                        '3. Ensure database rules allow read/write access\n'
                        '4. Check if games exist in Firebase console\n'
                        '5. Verify Asia Southeast region is correct\n'
                        '6. Try refreshing the connection',
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}