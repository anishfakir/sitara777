import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/app_drawer_widget.dart';
import '../utils/app_theme.dart';
import '../utils/app_icons.dart';

class GameCard {
  final String name;
  final String number;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  GameCard({
    required this.name,
    required this.number,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });
}

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  int _selectedIndex = 2; // Start with Home selected

  final List<GameCard> _games = [
    GameCard(
      name: 'MILAN DAY',
      number: '234',
      openTime: '09:00 AM',
      closeTime: '11:00 AM',
      isClosed: true,
    ),
    GameCard(
      name: 'KALYAN',
      number: '890',
      openTime: '11:30 AM',
      closeTime: '01:30 PM',
    ),
    GameCard(
      name: 'RAJDHANI NIGHT',
      number: '567',
      openTime: '02:00 PM',
      closeTime: '04:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: const Text(
            'Sitara777',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.wallet, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: const AppDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hotline Number
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Hotline: 1800-123-4567',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Main Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMainButton(
                      'KING STARLINE',
                      FontAwesomeIcons.crown,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMainButton(
                      'King Jackpot',
                      FontAwesomeIcons.trophy,
                    ),
                  ),
                ],
              ),
            ),

            // WhatsApp Support
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildWhatsAppButton('WhatsApp Support 1'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildWhatsAppButton('WhatsApp Support 2'),
                  ),
                ],
              ),
            ),

            // Games List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _games.map((game) => _buildGameCard(game)).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.receipt),
            label: 'My Bids',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book),
            label: 'Passbook',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const FaIcon(FontAwesomeIcons.house, color: Colors.white),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wallet),
            label: 'Funds',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.headset),
            label: 'Support',
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(String text, IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[700],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          FaIcon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppButton(String text) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildGameCard(GameCard game) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  game.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (game.isClosed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Closed for Today',
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.number,
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Open: ${game.openTime} - Close: ${game.closeTime}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: game.isClosed ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.play, size: 16),
                  label: const Text('Play Game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}