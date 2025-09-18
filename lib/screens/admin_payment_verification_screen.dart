import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/payment_transaction.dart';
import 'services/database_service.dart';
import 'utils/app_theme.dart';
import 'widgets/loading_indicator.dart';

class AdminPaymentVerificationScreen extends StatefulWidget {
  @override
  _AdminPaymentVerificationScreenState createState() =>
      _AdminPaymentVerificationScreenState();
}

class _AdminPaymentVerificationScreenState
    extends State<AdminPaymentVerificationScreen> {
  String _filterStatus = 'pending'; // pending, verified, rejected, all

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Verification'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text('Pending'),
                  selected: _filterStatus == 'pending',
                  onSelected: (selected) {
                    setState(() {
                      _filterStatus = selected ? 'pending' : 'all';
                    });
                  },
                ),
                FilterChip(
                  label: Text('Verified'),
                  selected: _filterStatus == 'verified',
                  onSelected: (selected) {
                    setState(() {
                      _filterStatus = selected ? 'verified' : 'all';
                    });
                  },
                ),
                FilterChip(
                  label: Text('Rejected'),
                  selected: _filterStatus == 'rejected',
                  onSelected: (selected) {
                    setState(() {
                      _filterStatus = selected ? 'rejected' : 'all';
                    });
                  },
                ),
                FilterChip(
                  label: Text('All'),
                  selected: _filterStatus == 'all',
                  onSelected: (selected) {
                    setState(() {
                      _filterStatus = selected ? 'all' : 'pending';
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Payment transactions list
          Expanded(
            child: StreamBuilder<List<PaymentTransaction>>(
              stream: databaseService.getAllPaymentTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading transactions: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No payment transactions found'),
                  );
                }

                // Filter transactions based on status
                List<PaymentTransaction> transactions = snapshot.data!;
                if (_filterStatus != 'all') {
                  transactions = transactions
                      .where((transaction) => transaction.status == _filterStatus)
                      .toList();
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return _buildTransactionCard(transaction, databaseService);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
      PaymentTransaction transaction, DatabaseService databaseService) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${transaction.amount.toStringAsFixed(2)}',
                  style: AppTheme.heading1.copyWith(
                    color: transaction.status == 'verified'
                        ? AppTheme.primaryGreen
                        : transaction.status == 'rejected'
                            ? AppTheme.errorColor
                            : AppTheme.primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.status == 'verified'
                        ? AppTheme.primaryGreen
                        : transaction.status == 'rejected'
                            ? AppTheme.errorColor
                            : AppTheme.primaryOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Transaction ID: ${transaction.upiTransactionId}',
              style: AppTheme.bodyText1,
            ),
            SizedBox(height: 4),
            Text(
              'Remark: ${transaction.remark}',
              style: AppTheme.bodyText2,
            ),
            SizedBox(height: 4),
            Text(
              'Date: ${transaction.timestamp.toString()}',
              style: AppTheme.bodyText2.copyWith(
                color: AppTheme.textColorSecondary,
              ),
            ),
            SizedBox(height: 12),
            
            // Action buttons for pending transactions
            if (transaction.status == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Verify transaction
                        final isVerified = await databaseService
                            .verifyUpiTransaction(transaction.upiTransactionId);
                        
                        if (isVerified) {
                          await databaseService.updatePaymentTransactionStatus(
                              transaction.id, 'verified');
                          
                          // Credit user's wallet
                          // Note: In a real implementation, you would get the user ID from the transaction
                          // For now, we'll show a message that this step needs to be implemented
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Transaction verified. Wallet credit needs implementation.'),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Transaction verification failed'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error verifying transaction: $e'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Reject transaction
                        await databaseService.updatePaymentTransactionStatus(
                            transaction.id, 'rejected');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Transaction rejected'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                        setState(() {}); // Refresh the UI
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error rejecting transaction: $e'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}