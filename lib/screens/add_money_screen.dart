import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'services/database_service.dart';
import 'services/upi_payment_service.dart';
import 'models/payment_transaction.dart';
import 'utils/app_theme.dart';
import 'widgets/loading_indicator.dart';
import 'package:uuid/uuid.dart';

class AddMoneyScreen extends StatefulWidget {
  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isProcessing = false;
  String? _selectedMethod = 'upi';
  double? _selectedAmount;
  
  // Predefined amount options
  final List<double> _amountOptions = [100, 200, 500, 1000, 2000, 5000];
  
  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }
  
  void _selectAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }
  
  Future<void> _initiateUpiPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      final user = Provider.of<UserData>(context, listen: false).currentUser;
      if (user == null) {
        _showError('User not found');
        return;
      }
      
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      
      // Create a pending transaction record
      final transactionId = Uuid().v4();
      final paymentTransaction = PaymentTransaction(
        id: transactionId,
        userId: user.uid,
        amount: amount,
        upiTransactionId: '', // Will be filled after payment
        status: 'pending',
        timestamp: DateTime.now(),
        remark: 'Wallet recharge for Sitara777',
      );
      
      await databaseService.addPaymentTransaction(paymentTransaction);
      
      // Launch UPI payment
      final success = await UpiPaymentService.launchUpiPayment(
        amount: amount,
        remark: 'Wallet recharge for Sitara777',
        onSuccess: () {
          // Payment successful in UPI app
          _showMessage('Payment initiated. Please enter transaction details.');
        },
        onFailure: () {
          // Payment failed in UPI app
          _showError('Payment failed. Please try again.');
        },
      );
      
      if (!success) {
        _showError('Unable to launch UPI app. Please check your UPI setup.');
      }
      
      // Navigate to verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpiVerificationScreen(
            transactionId: transactionId,
            amount: amount,
          ),
        ),
      );
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Money'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Amount',
                style: AppTheme.heading1,
              ),
              SizedBox(height: 16),
              
              // Amount options
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _amountOptions.map((amount) {
                  return ChoiceChip(
                    label: Text('₹${amount.toInt()}'),
                    selected: _selectedAmount == amount,
                    selectedColor: AppTheme.primaryColor,
                    onSelected: (selected) {
                      if (selected) {
                        _selectAmount(amount);
                      }
                    },
                  );
                }).toList(),
              ),
              
              SizedBox(height: 20),
              
              // Custom amount input
              Text(
                'Or Enter Custom Amount',
                style: AppTheme.bodyText1,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount < 10) {
                    return 'Minimum amount is ₹10';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 30),
              
              // Payment method selection
              Text(
                'Payment Method',
                style: AppTheme.heading1,
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
                  title: Text('UPI Payment'),
                  subtitle: Text('Pay via GPay, PhonePe, Paytm, etc.'),
                  trailing: Radio<String>(
                    value: 'upi',
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'upi';
                    });
                  },
                ),
              ),
              
              SizedBox(height: 30),
              
              // Process button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _initiateUpiPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                    ),
                  ),
                  child: _isProcessing
                      ? LoadingIndicator()
                      : Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Instructions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works?',
                        style: AppTheme.heading2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Enter the amount you want to add to your wallet\n'
                        '2. Select UPI as payment method\n'
                        '3. You will be redirected to your UPI app\n'
                        '4. Complete the payment in your UPI app\n'
                        '5. After payment, enter the UPI transaction ID\n'
                        '6. Your account will be credited after verification',
                        style: AppTheme.bodyText1,
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
}

// UPI Verification Screen
class UpiVerificationScreen extends StatefulWidget {
  final String transactionId;
  final double amount;

  UpiVerificationScreen({
    required this.transactionId,
    required this.amount,
  });

  @override
  _UpiVerificationScreenState createState() => _UpiVerificationScreenState();
}

class _UpiVerificationScreenState extends State<UpiVerificationScreen> {
  final _transactionIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isVerifying = false;
  
  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }
  
  Future<void> _verifyTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    
    final transactionId = _transactionIdController.text.trim();
    
    if (!UpiPaymentService.isValidUpiTransactionId(transactionId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid UPI transaction ID'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    setState(() {
      _isVerifying = true;
    });
    
    try {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      final user = Provider.of<UserData>(context, listen: false).currentUser;
      
      if (user == null) {
        _showError('User not found');
        return;
      }
      
      // Update transaction with UPI transaction ID
      await databaseService.updatePaymentTransaction(
        widget.transactionId,
        {
          'upiTransactionId': transactionId,
        },
      );
      
      // Simulate verification (in real app, call actual verification API)
      await Future.delayed(Duration(seconds: 2));
      final isVerified = await databaseService.verifyUpiTransaction(transactionId);
      
      if (isVerified) {
        // Update transaction status to verified
        await databaseService.updatePaymentTransactionStatus(
          widget.transactionId,
          'verified',
        );
        
        // Credit user's wallet
        await databaseService.creditUserWallet(
          userId: user.uid,
          amount: widget.amount,
          transactionType: TransactionType.recharge,
          description: 'UPI recharge - $transactionId',
        );
        
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment verified successfully! Wallet credited.'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        
        Navigator.pop(context, true); // Return success to previous screen
      } else {
        // Update transaction status to rejected
        await databaseService.updatePaymentTransactionStatus(
          widget.transactionId,
          'rejected',
        );
        
        _showError('Payment verification failed. Please check transaction ID.');
      }
    } catch (e) {
      _showError('An error occurred during verification: ${e.toString()}');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Payment'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount to be added',
                        style: AppTheme.bodyText1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₹${widget.amount.toStringAsFixed(0)}',
                        style: AppTheme.heading1.copyWith(
                          fontSize: 24,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Enter UPI Transaction ID',
                style: AppTheme.heading1,
              ),
              SizedBox(height: 8),
              
              TextFormField(
                controller: _transactionIdController,
                decoration: InputDecoration(
                  labelText: 'Transaction ID',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., TXN1234567890',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the UPI transaction ID';
                  }
                  if (!UpiPaymentService.isValidUpiTransactionId(value)) {
                    return 'Please enter a valid transaction ID';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 10),
              
              Text(
                'Note: You can find the transaction ID in your UPI app payment confirmation screen or in the payment receipt.',
                style: AppTheme.bodyText2.copyWith(
                  color: AppTheme.textColorSecondary,
                ),
              ),
              
              SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                    ),
                  ),
                  child: _isVerifying
                      ? LoadingIndicator()
                      : Text(
                          'Verify Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Alternative verification method
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Having trouble finding the transaction ID?',
                        style: AppTheme.heading2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'You can also upload a screenshot of your payment confirmation from your UPI app. Our team will manually verify your payment.',
                        style: AppTheme.bodyText1,
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement screenshot upload functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Screenshot upload coming soon!'),
                              backgroundColor: AppTheme.primaryOrange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                        ),
                        child: Text(
                          'Upload Payment Screenshot',
                          style: TextStyle(color: Colors.white),
                        ),
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
}