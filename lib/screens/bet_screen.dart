import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bazaar_model.dart';
import '../models/game_model_flexible.dart';
import '../models/bet_option_model.dart';
import '../models/user_model.dart';
import '../models/bet_model.dart';
import '../services/database_service.dart';
import '../services/betting_service.dart';
import '../utils/app_theme.dart';

class BetScreen extends StatefulWidget {
  final BazaarModel bazaar;
  final GameModel game;

  const BetScreen({
    super.key,
    required this.bazaar,
    required this.game,
  });

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  final BettingService _bettingService = BettingService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  
  late TabController _tabController;
  final TextEditingController _betNumberController = TextEditingController();
  final TextEditingController _betAmountController = TextEditingController();
  
  BetOptionModel? _selectedBetOption;
  double _potentialWin = 0.0;
  bool _isPlacingBet = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Single, Jodi, Patti, Half Sangam, Full Sangam
    _betAmountController.addListener(_calculatePotentialWin);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _betNumberController.dispose();
    _betAmountController.dispose();
    super.dispose();
  }

  void _calculatePotentialWin() {
    if (_selectedBetOption != null && _betAmountController.text.isNotEmpty) {
      final amount = double.tryParse(_betAmountController.text) ?? 0.0;
      setState(() {
        _potentialWin = _selectedBetOption!.calculateWinAmount(amount);
      });
    } else {
      setState(() {
        _potentialWin = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          '${widget.bazaar.displayName} • Place your bet',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: AppTheme.primaryMaroon,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.game.isBettingOpen
          ? _buildBettingInterface()
          : _buildClosedGameInterface(),
    );
  }

  Widget _buildBettingInterface() {
    return Column(
      children: [
        // Game Info Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(AppTheme.mediumSpacing),
          padding: const EdgeInsets.all(AppTheme.mediumSpacing),
          decoration: AppTheme.primaryCardDecoration,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeCard('Open', widget.game.openTime, Icons.play_arrow),
                  _buildTimeCard('Close', widget.game.closeTime, Icons.stop),
                  _buildTimeCard('Result', widget.game.resultTime, Icons.emoji_events),
                ],
              ),
            ],
          ),
        ),

        // Bet Types Tabs
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.mediumSpacing),
          decoration: AppTheme.standardCardDecoration,
          child: Column(
            children: [
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
                  unselectedLabelColor: AppTheme.secondaryTextColor,
                  indicatorColor: AppTheme.primaryMaroon,
                  indicatorWeight: 3,
                  isScrollable: true,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(text: 'Single'),
                    Tab(text: 'Jodi'),
                    Tab(text: 'Patti'),
                    Tab(text: 'Half Sangam'),
                    Tab(text: 'Full Sangam'),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBetTypeContent(BetOptionType.single),
                    _buildBetTypeContent(BetOptionType.jodi),
                    _buildBetTypeContent(BetOptionType.patti),
                    _buildBetTypeContent(BetOptionType.halfSangam),
                    _buildBetTypeContent(BetOptionType.fullSangam),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(String label, String time, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.onPrimaryTextColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.onPrimaryTextColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: AppTheme.onPrimaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBetTypeContent(BetOptionType betType) {
    // For now, we'll create mock bet options based on the bet type
    // In a real app, these would come from Firebase
    final betOptions = _getMockBetOptions(betType);
    
    if (betOptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.casino_outlined,
              size: 48,
              color: AppTheme.secondaryTextColor,
            ),
            const SizedBox(height: AppTheme.mediumSpacing),
            Text(
              'No ${betType.toString().split('.').last} options available',
              style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppTheme.mediumSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bet Type Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.mediumSpacing),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  betOptions.first.typeDisplayName,
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
                Text(
                  betOptions.first.description,
                  style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Row(
                  children: [
                    Text(
                      'Win Rate: ${betOptions.first.winMultiplier}x',
                      style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.mediumSpacing),
                    Text(
                      'Min: ₹${betOptions.first.minBetAmount.toStringAsFixed(0)}',
                      style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.smallSpacing),
                    Text(
                      'Max: ₹${betOptions.first.maxBetAmount.toStringAsFixed(0)}',
                      style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.largeSpacing),

          // Betting Form
          Expanded(
            child: _buildBettingForm(betOptions.first),
          ),
        ],
      ),
    );
  }

  Widget _buildBettingForm(BetOptionModel betOption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Place Your Bet',
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.mediumSpacing),

        // Bet Number Input
        TextFormField(
          controller: _betNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter Number',
            hintText: 'e.g., 123',
            prefixIcon: Icon(Icons.numbers, color: AppTheme.primaryMaroon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.primaryMaroon, width: 2),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.mediumSpacing),

        // Bet Amount Input
        TextFormField(
          controller: _betAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Bet Amount',
            hintText: '₹${betOption.minBetAmount.toStringAsFixed(0)} - ₹${betOption.maxBetAmount.toStringAsFixed(0)}',
            prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primaryMaroon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.primaryMaroon, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _selectedBetOption = betOption;
            });
          },
        ),
        const SizedBox(height: AppTheme.mediumSpacing),

        // Quick Amount Buttons
        Text(
          'Quick Select:',
          style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.smallSpacing),
        Wrap(
          spacing: AppTheme.smallSpacing,
          children: [10, 50, 100, 500, 1000].map((amount) {
            return OutlinedButton(
              onPressed: () {
                _betAmountController.text = amount.toString();
                setState(() {
                  _selectedBetOption = betOption;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryMaroon,
                side: BorderSide(color: AppTheme.primaryMaroon),
              ),
              child: Text('₹$amount'),
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.largeSpacing),

        // Potential Win Display
        if (_potentialWin > 0) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.mediumSpacing),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Potential Win:',
                  style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${_potentialWin.toStringAsFixed(2)}',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.largeSpacing),
        ],

        // Place Bet Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canPlaceBet() ? _placeBet : null,
            style: AppTheme.primaryButtonStyle.copyWith(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: AppTheme.mediumSpacing),
              ),
            ),
            child: _isPlacingBet
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Place Bet',
                    style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onPrimaryTextColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildClosedGameInterface() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_off,
              size: 80,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: AppTheme.largeSpacing),
            Text(
              'Betting Closed',
              style: AppTheme.lightTextTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: AppTheme.mediumSpacing),
            Text(
              'Betting is currently closed for ${widget.game.displayName}.',
              style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            Text(
              'Check back during betting hours: ${widget.game.openTime} - ${widget.game.closeTime}',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.extraLargeSpacing),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement notification reminder
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reminder feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Set Reminder'),
              style: AppTheme.accentButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  bool _canPlaceBet() {
    if (_isPlacingBet) return false;
    if (_betNumberController.text.isEmpty) return false;
    if (_betAmountController.text.isEmpty) return false;
    if (_selectedBetOption == null) return false;
    
    final amount = double.tryParse(_betAmountController.text) ?? 0.0;
    return _selectedBetOption!.isValidBetAmount(amount);
  }

  Future<void> _placeBet() async {
    if (!_canPlaceBet() || _currentUser == null) return;

    setState(() {
      _isPlacingBet = true;
    });

    try {
      final betModel = BetModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUser!.uid,
        gameId: widget.game.gameId,
        gameName: widget.game.displayName,
        betTypeId: _selectedBetOption!.betOptionId,
        betTypeName: _selectedBetOption!.name,
        amount: double.parse(_betAmountController.text),
        betNumber: _betNumberController.text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        placedAt: DateTime.now(),
        status: BetStatus.pending,
        winAmount: null,
        result: null,
      );

      await _bettingService.placeBet(betModel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bet placed successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Clear form
        _betNumberController.clear();
        _betAmountController.clear();
        setState(() {
          _potentialWin = 0.0;
          _selectedBetOption = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place bet: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingBet = false;
        });
      }
    }
  }

  List<BetOptionModel> _getMockBetOptions(BetOptionType betType) {
    // Mock bet options - in a real app, these would come from Firebase
    switch (betType) {
      case BetOptionType.single:
        return [
          BetOptionModel(
            betOptionId: 'single_${widget.game.gameId}',
            gameId: widget.game.gameId,
            bazaarId: widget.bazaar.bazaarId,
            type: BetOptionType.single,
            name: 'single',
            displayName: 'Single',
            description: 'Bet on a single digit (0-9)',
            minBetAmount: 10,
            maxBetAmount: 1000,
            winMultiplier: 9.5,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      case BetOptionType.jodi:
        return [
          BetOptionModel(
            betOptionId: 'jodi_${widget.game.gameId}',
            gameId: widget.game.gameId,
            bazaarId: widget.bazaar.bazaarId,
            type: BetOptionType.jodi,
            name: 'jodi',
            displayName: 'Jodi',
            description: 'Bet on a two-digit number (00-99)',
            minBetAmount: 10,
            maxBetAmount: 1000,
            winMultiplier: 95.0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      case BetOptionType.patti:
        return [
          BetOptionModel(
            betOptionId: 'patti_${widget.game.gameId}',
            gameId: widget.game.gameId,
            bazaarId: widget.bazaar.bazaarId,
            type: BetOptionType.patti,
            name: 'patti',
            displayName: 'Patti',
            description: 'Bet on a three-digit number (000-999)',
            minBetAmount: 10,
            maxBetAmount: 1000,
            winMultiplier: 950.0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      default:
        return [];
    }
  }
}

