import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconExampleScreen extends StatelessWidget {
  const IconExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Examples'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Material Icon
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Icons (Built-in):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                Icon(Icons.home, size: 30),
                Icon(Icons.favorite, size: 30, color: Colors.red),
                Icon(Icons.star, size: 30, color: Colors.yellow),
                Icon(Icons.settings, size: 30),
                Icon(Icons.person, size: 30),
                Icon(Icons.notifications, size: 30),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Font Awesome Icons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                FaIcon(FontAwesomeIcons.gamepad, size: 30),
                FaIcon(FontAwesomeIcons.trophy, size: 30, color: Colors.amber),
                FaIcon(FontAwesomeIcons.user, size: 30),
                FaIcon(FontAwesomeIcons.bell, size: 30),
                FaIcon(FontAwesomeIcons.heart, size: 30, color: Colors.red),
                FaIcon(FontAwesomeIcons.coins, size: 30, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Common Usage Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sports_esports),
              title: const Text('Active Games'),
              trailing: const FaIcon(FontAwesomeIcons.angleRight),
              onTap: () {},
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.wallet),
              title: const Text('My Wallet'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              trailing: const FaIcon(FontAwesomeIcons.trophy, color: Colors.amber),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gamepad),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}