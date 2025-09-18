import 'package:flutter/material.dart';
import 'admin_payment_verification_screen.dart';
import 'users_management_screen.dart'; // This would be another admin screen
import 'utils/app_theme.dart';

class AdminPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Dashboard',
              style: AppTheme.heading1,
            ),
            SizedBox(height: 20),
            Text(
              'Manage your application from this panel',
              style: AppTheme.bodyText1,
            ),
            SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Payment Verification',
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPaymentVerificationScreen(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'User Management',
                  icon: Icons.people,
                  onTap: () {
                    // Navigate to user management screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Game Management',
                  icon: Icons.games,
                  onTap: () {
                    // Navigate to game management screen
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Reports',
                  icon: Icons.analytics,
                  onTap: () {
                    // Navigate to reports screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppTheme.primaryColor),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}import 'package:flutter/material.dart';
import 'admin_payment_verification_screen.dart';
import 'users_management_screen.dart'; // This would be another admin screen
import 'utils/app_theme.dart';

class AdminPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Dashboard',
              style: AppTheme.heading1,
            ),
            SizedBox(height: 20),
            Text(
              'Manage your application from this panel',
              style: AppTheme.bodyText1,
            ),
            SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Payment Verification',
                  icon: Icons.account_balance_wallet,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPaymentVerificationScreen(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'User Management',
                  icon: Icons.people,
                  onTap: () {
                    // Navigate to user management screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Game Management',
                  icon: Icons.games,
                  onTap: () {
                    // Navigate to game management screen
                  },
                ),
                _buildAdminCard(
                  context,
                  title: 'Reports',
                  icon: Icons.analytics,
                  onTap: () {
                    // Navigate to reports screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppTheme.primaryColor),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}