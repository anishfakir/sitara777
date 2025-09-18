import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  String _selectedWithdrawMethod = 'Bank Transfer';

  // Add missing methods for compatibility
  Stream<UserModel> getUserStream(String userId) {
    return _databaseService.getUserStream(userId).map((user) => user ?? UserModel(
      uid: userId,
      profile: UserProfile(
        uid: userId,
        name: 'User',
        phone: '',
        email: null,
        avatar: null,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      ),
      wallet: UserWallet(
        balance: 0.0,
        totalDeposited: 0.0,
        totalWithdrawn: 0.0,
        totalWinnings: 0.0,
        totalLosses: 0.0,
        lastUpdated: DateTime.now(),
        updatedBy: 'system',
      ),
      settings: UserSettings(
        notifications: true,
        language: 'en',
        timezone: 'UTC',
      ),
    ));
  }
  bool _isSubmitting = false;
  UserModel? _user;

  final List<String> _withdrawMethods = ['Bank Transfer', 'UPI', 'Paytm', 'PhonePe'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      try {
        final userData = await _databaseService.getUser(_currentUser!.uid);
        setState(() {
          _user = userData;
        });
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _submitWithdrawRequest() async {
    if (_amountController.text.isEmpty) {
      _showError('Please enter withdrawal amount');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount < 500) {
      _showError('Minimum withdrawal amount is ₹500');
      return;
    }

    if (_user == null || amount > _user!.walletBalance) {
      _showError('Insufficient wallet balance');
      return;
    }

    if (_accountController.text.trim().isEmpty) {
      _showError(_selectedWithdrawMethod == 'Bank Transfer' 
          ? 'Please enter account number' 
          : 'Please enter UPI ID/Mobile number');
      return;
    }

    if (_selectedWithdrawMethod == 'Bank Transfer' && _ifscController.text.trim().isEmpty) {
      _showError('Please enter IFSC code');
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter account holder name');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String description = 'Withdrawal request - $_selectedWithdrawMethod';
      if (_selectedWithdrawMethod == 'Bank Transfer') {
        description += ' (${_accountController.text.trim()})';
      } else {
        description += ' (${_accountController.text.trim()})';
      }

      final transaction = TransactionModel(
        id: '', // Will be generated
        userId: _currentUser!.uid,
        type: TransactionType.withdrawal,
        amount: amount,
        status: TransactionStatus.pending,
        createdAt: DateTime.now(),
        description: description,
        paymentMethod: _selectedWithdrawMethod,
        referenceId: _selectedWithdrawMethod == 'Bank Transfer' 
            ? '${_accountController.text.trim()}|${_ifscController.text.trim()}|${_nameController.text.trim()}'
            : '${_accountController.text.trim()}|${_nameController.text.trim()}',
      );

      await _databaseService.createTransaction(transaction);

      _showSuccess('Withdrawal request submitted successfully! It will be processed within 24-48 hours.');
      
      // Clear form
      _amountController.clear();
      _accountController.clear();
      _ifscController.clear();
      _nameController.clear();
      
      // Go back to wallet screen
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to submit withdrawal request: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Withdraw Money'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StreamBuilder<UserModel?>(
                      stream: _currentUser != null
                          ? getUserStream(_currentUser!.uid)
                          : null,
                      builder: (context, snapshot) {
                        final balance = snapshot.data?.walletBalance ?? 0.0;
                        return Text(
                          '₹${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Instructions Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Withdrawal Terms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Minimum withdrawal amount: ₹500\n'
                      '• Processing time: 24-48 hours\n'
                      '• Withdrawals are processed on business days\n'
                      '• Ensure account details are correct\n'
                      '• Contact support for any issues',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Withdrawal Method Selection
            const Text(
              'Select Withdrawal Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _withdrawMethods.map((method) {
                    return RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: _selectedWithdrawMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedWithdrawMethod = value!;
                        });
                      },
                      activeColor: const Color(0xFF1E3A8A),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Amount Input
            const Text(
              'Withdrawal Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                helperText: 'Minimum: ₹500',
              ),
            ),
            const SizedBox(height: 20),
            // Account Details
            const Text(
              'Account Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedWithdrawMethod == 'Bank Transfer') ...[
              TextFormField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              TextFormField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: _selectedWithdrawMethod == 'UPI' 
                      ? 'UPI ID' 
                      : 'Mobile Number',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Holder Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitWithdrawRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SUBMIT WITHDRAWAL REQUEST',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
