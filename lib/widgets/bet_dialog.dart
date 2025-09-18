import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_model_flexible.dart';
import '../models/user_model.dart';
import '../utils/app_theme.dart';
import '../utils/app_icons.dart';
import '../utils/app_icon_theme.dart';

class BetRequest {
  final double amount;
  final String number;

  BetRequest({required this.amount, required this.number});
}

class BetDialog extends StatefulWidget {
  final GameModel game;
  final UserModel user;
  final double minBet;
  final double maxBet;

  const BetDialog({
    super.key,
    required this.game,
    required this.user,
    required this.minBet,
    required this.maxBet,
  });

  @override
  State<BetDialog> createState() => _BetDialogState();
}

class _BetDialogState extends State<BetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _numberController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final number = _numberController.text;

    // Additional validation
    if (amount > widget.user.wallet.balance) {
      setState(() => _errorMessage = 'Insufficient balance');
      return;
    }

    if (amount < widget.minBet) {
      setState(() => _errorMessage = 'Minimum bet amount is ₹${widget.minBet}');
      return;
    }

    if (amount > widget.maxBet) {
      setState(() => _errorMessage = 'Maximum bet amount is ₹${widget.maxBet}');
      return;
    }

    // Clear error and submit
    setState(() => _errorMessage = null);
    Navigator.of(context).pop(BetRequest(amount: amount, number: number));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          AppIcons.awesome(AppIcons.money, color: AppTheme.primaryMaroon),
          const SizedBox(width: 8),
          const Text('Place Your Bet'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Bet Amount',
                prefixIcon: AppIcons.awesome(AppIcons.money, size: 20),
                prefixText: '₹',
                helperText: 'Min: ₹${widget.minBet}, Max: ₹${widget.maxBet}',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter bet amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: 'Select Number',
                prefixIcon: AppIcons.material(AppIcons.dice),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a number';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryMaroon,
          ),
          child: const Text('Place Bet'),
        ),
      ],
    );
  }
}