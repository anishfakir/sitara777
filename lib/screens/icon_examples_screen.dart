import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_icons.dart';
import '../utils/app_theme.dart';

/// This is an example widget demonstrating how to use different types of icons
/// in your Flutter app.
class IconExamplesScreen extends StatelessWidget {
  const IconExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Examples'),
        // Using AppIcons helper for Material Icons
        leading: AppIcons.material(
          AppIcons.menu,
          color: Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Material Icons (Built-in)',
              children: [
                _buildIconDemo(
                  'Standard Material Icon',
                  AppIcons.material(AppIcons.home),
                  'Icon(Icons.home_rounded)',
                ),
                _buildIconDemo(
                  'Colored Material Icon',
                  AppIcons.material(
                    AppIcons.notifications,
                    color: Colors.red,
                    size: 30,
                  ),
                  'Icon with color and size',
                ),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              title: 'Font Awesome Icons',
              children: [
                _buildIconDemo(
                  'Standard FA Icon',
                  AppIcons.awesome(AppIcons.wallet),
                  'FaIcon(FontAwesomeIcons.wallet)',
                ),
                _buildIconDemo(
                  'Colored FA Icon',
                  AppIcons.awesome(
                    AppIcons.whatsapp,
                    color: Colors.green,
                    size: 30,
                  ),
                  'FaIcon with color and size',
                ),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              title: 'SVG Icons',
              children: [
                _buildIconDemo(
                  'SVG Icon',
                  AppIcons.svg('logo'),
                  'SvgPicture.asset(...)',
                ),
                _buildIconDemo(
                  'Colored SVG',
                  AppIcons.svg(
                    'custom_icon',
                    color: Colors.blue,
                    size: 30,
                  ),
                  'SVG with color and size',
                ),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              title: 'Icons in Buttons',
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: AppIcons.awesome(AppIcons.play),
                  label: const Text('Play Game'),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () {},
                  icon: AppIcons.material(AppIcons.settings),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () {},
                  child: AppIcons.material(AppIcons.add),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              title: 'Status Icons',
              children: [
                ListTile(
                  leading: AppIcons.material(
                    AppIcons.success,
                    color: Colors.green,
                  ),
                  title: const Text('Success Status'),
                ),
                ListTile(
                  leading: AppIcons.material(
                    AppIcons.warning,
                    color: Colors.orange,
                  ),
                  title: const Text('Warning Status'),
                ),
                ListTile(
                  leading: AppIcons.material(
                    AppIcons.error,
                    color: Colors.red,
                  ),
                  title: const Text('Error Status'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: AppIcons.material(AppIcons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: AppIcons.material(AppIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.awesome(AppIcons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.awesome(AppIcons.bids),
            label: 'Bids',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.awesome(AppIcons.support),
            label: 'Support',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildIconDemo(String title, Widget icon, String code) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}