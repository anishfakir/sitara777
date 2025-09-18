import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  
  String _selectedPaymentMethod = 'UPI';
  bool _isSubmitting = false;

  final List<String> _paymentMethods = ['UPI', 'Bank Transfer', 'Paytm', 'PhonePe', 'Google Pay'];
  final List<double> _quickAmounts = [100, 500, 1000, 2000, 5000, 10000];

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _submitRechargeRequest() async {
    if (_amountController.text.isEmpty) {
      _showError('Please enter recharge amount');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount < 100) {
      _showError('Minimum recharge amount is ₹100');
      return;
    }

    if (amount > 50000) {
      _showError('Maximum recharge amount is ₹50,000');
      return;
    }

    if (_referenceController.text.trim().isEmpty) {
      _showError('Please enter transaction reference/UPI ID');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final transaction = TransactionModel(
        id: '', // Will be generated
        userId: _currentUser!.uid,
        type: TransactionType.recharge,
        amount: amount,
        status: TransactionStatus.pending,
        createdAt: DateTime.now(),
        description: 'Recharge request - $_selectedPaymentMethod',
        paymentMethod: _selectedPaymentMethod,
        referenceId: _referenceController.text.trim(),
      );

      await _databaseService.createTransaction(transaction);

      _showSuccess('Recharge request submitted successfully! It will be processed within 24 hours.');
      
      // Clear form
      _amountController.clear();
      _referenceController.clear();
      
      // Go back to wallet screen
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to submit recharge request: $e');
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
        title: const Text('Recharge Wallet'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'How to Recharge',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Choose your payment method\n'
                      '2. Enter the amount you want to recharge\n'
                      '3. Make payment to our account\n'
                      '4. Enter transaction reference/UPI ID\n'
                      '5. Submit request for approval',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: const Text(
                        'Note: Recharge requests are processed within 24 hours',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Payment Method Selection
            const Text(
              'Select Payment Method',
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
                  children: _paymentMethods.map((method) {
                    return RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: const Color(0xFF1E3A8A),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Quick Amount Selection
            const Text(
              'Quick Select Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAmounts.map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    _amountController.text = amount.toStringAsFixed(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[800],
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('₹${amount.toStringAsFixed(0)}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Amount Input
            const Text(
              'Enter Amount',
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
                labelText: 'Recharge Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                helperText: 'Min: ₹100 | Max: ₹50,000',
              ),
            ),
            const SizedBox(height: 20),
            // Payment Details Card
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
                    Text(
                      'Payment Details for $_selectedPaymentMethod',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedPaymentMethod == 'UPI') ...[
                      _buildPaymentInfo('UPI ID', 'sitara777@upi'),
                      _buildPaymentInfo('Name', 'Sitara777 Gaming'),
                    ] else if (_selectedPaymentMethod == 'Bank Transfer') ...[
                      _buildPaymentInfo('Account Name', 'Sitara777 Gaming Pvt Ltd'),
                      _buildPaymentInfo('Account Number', '1234567890'),
                      _buildPaymentInfo('IFSC Code', 'HDFC0001234'),
                      _buildPaymentInfo('Bank', 'HDFC Bank'),
                    ] else ...[
                      _buildPaymentInfo('$_selectedPaymentMethod Number', '+91 9876543210'),
                      _buildPaymentInfo('Name', 'Sitara777 Gaming'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Reference Input
            const Text(
              'Transaction Reference',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _referenceController,
              decoration: InputDecoration(
                labelText: _selectedPaymentMethod == 'UPI' 
                    ? 'UPI Transaction ID' 
                    : _selectedPaymentMethod == 'Bank Transfer'
                        ? 'Bank Reference Number'
                        : 'Transaction ID',
                border: const OutlineInputBorder(),
                helperText: 'Enter the transaction reference from your payment app',
              ),
            ),
            const SizedBox(height: 30),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRechargeRequest,
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
                        'SUBMIT RECHARGE REQUEST',
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

  Widget _buildPaymentInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () {
              // Copy to clipboard functionality can be added here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
          ),
        ],
      ),
    );
  }
}
