import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import 'add_money_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    if (_currentUser != null) {
      final user = await _databaseService.getUser(_currentUser!.uid);
      setState(() {
        _walletBalance = user?.walletBalance ?? 0.0;
      });
    }
  }

  Future<void> _refreshWallet() async {
    await _fetchWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWallet,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Wallet Balance Card
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹${_walletBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMoneyScreen(),
                            ),
                          ).then((value) {
                            if (value == true) {
                              // Refresh wallet balance after successful payment
                              _refreshWallet();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Add Money',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Recent Transactions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: AppTheme.heading1,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to full transaction history
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Transactions List
              _buildTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_currentUser == null) {
      return Center(
        child: Text('Please login to view transactions'),
      );
    }

    return StreamBuilder<List<TransactionModel>>(
      stream: _databaseService.watchUserTransactions(_currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
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
                  'Error loading transactions',
                  style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
          );
        }

        final transactions = snapshot.data ?? [];
        
        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 48,
                  color: AppTheme.secondaryTextColor,
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Text(
                  'No transactions yet',
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
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionItem(transaction);
          },
        );
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    // Determine if it's a credit transaction
    final isCredit = transaction.type == TransactionType.recharge || 
                    transaction.type == TransactionType.betWon || 
                    transaction.type == TransactionType.adminCredit;
    
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCredit ? AppTheme.primaryGreen.withOpacity(0.1) : AppTheme.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          child: Icon(
            isCredit ? Icons.add_circle : Icons.remove_circle,
            color: isCredit ? AppTheme.primaryGreen : AppTheme.primaryRed,
            size: 24,
          ),
        ),
        title: Text(
          transaction.description ?? 'Transaction',
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              transaction.timestamp.toLocal().toString().split('.').first,
              style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            if (transaction.referenceId != null) ...[
              const SizedBox(height: 2),
              Text(
                'Ref: ${transaction.referenceId}',
                style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ],
        ),
        trailing: Text(
          '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            color: isCredit ? AppTheme.primaryGreen : AppTheme.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
