import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static bool _isOnline = true;
  
  static bool get isOnline => _isOnline;
  
  static final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();
  
  static Stream<bool> get connectionStatusStream => 
      _connectionStatusController.stream;

  static Future<void> initialize() async {
    // Check initial connectivity status
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  static void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    
    if (wasOnline != _isOnline) {
      _connectionStatusController.add(_isOnline);
    }
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  static void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }

  static Widget buildConnectivityWrapper({
    required Widget child,
    Widget? offlineWidget,
  }) {
    return StreamBuilder<bool>(
      stream: connectionStatusStream,
      initialData: _isOnline,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        
        if (!isConnected) {
          return offlineWidget ?? _buildDefaultOfflineWidget();
        }
        
        return child;
      },
    );
  }

  static Widget _buildDefaultOfflineWidget() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection\nand try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final isConnected = await checkInternetConnection();
                if (isConnected) {
                  _updateConnectionStatus([ConnectivityResult.wifi]);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showConnectivitySnackBar(BuildContext context, bool isConnected) {
    final message = isConnected 
        ? 'Connection restored' 
        : 'No internet connection';
    
    final backgroundColor = isConnected ? Colors.green : Colors.red;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: isConnected ? 2 : 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
