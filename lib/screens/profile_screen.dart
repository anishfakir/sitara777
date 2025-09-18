import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = true;
  bool _isUpdatingProfile = false;
  
  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final user = await _databaseService.getUser(currentUser.uid);
        if (mounted) {
          setState(() {
            _user = user;
            _isLoading = false;
            if (_user != null) {
              _nameController.text = _user!.profile.name;
              _emailController.text = _user!.profile.email ?? '';
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load profile: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildProfileContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Profile',
        style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppTheme.primaryMaroon,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (!_isEditing && _user != null)
          IconButton(
            onPressed: () => _toggleEditMode(),
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Profile',
          ),
        if (_isEditing)
          IconButton(
            onPressed: _isUpdatingProfile ? null : () => _saveProfile(),
            icon: _isUpdatingProfile 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save, color: Colors.white),
            tooltip: 'Save Changes',
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMaroon),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppTheme.largeSpacing),
          Text(
            'Loading Profile...',
            style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_user == null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _loadUserData,
      color: AppTheme.primaryMaroon,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            _buildProfileHeaderCard(),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Account Information
            _buildAccountInfoCard(),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Wallet Summary
            _buildWalletSummaryCard(),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Settings Section
            _buildSettingsCard(),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Actions Section
            _buildActionsCard(),
            
            const SizedBox(height: AppTheme.largeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: AppTheme.primaryCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryMaroon,
                    AppTheme.secondaryMaroon,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryMaroon.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _user!.profile.name.isNotEmpty 
                      ? _user!.profile.name.substring(0, 1).toUpperCase()
                      : 'U',
                  style: AppTheme.lightTextTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.mediumSpacing),
            
            // User Name
            if (_isEditing)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryMaroon.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryMaroon),
                  ),
                ),
                style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                _user!.profile.name,
                style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryMaroon,
                ),
                textAlign: TextAlign.center,
              ),
            
            const SizedBox(height: AppTheme.smallSpacing),
            
            // Phone Number
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _user!.profile.phone,
                  style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.smallSpacing),
            
            // Member Since
            Text(
              'Member since ${_formatDate(_user!.profile.createdAt)}',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Container(
      decoration: AppTheme.standardCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: AppTheme.primaryMaroon,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Text(
                  'Account Information',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Email
            if (_isEditing)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email, color: AppTheme.primaryMaroon),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryMaroon.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryMaroon),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              )
            else
              _buildInfoRow(
                'Email',
                _user!.profile.email?.isNotEmpty == true 
                    ? _user!.profile.email! 
                    : 'Not provided',
                Icons.email,
              ),
            
            if (!_isEditing) ...[
              const SizedBox(height: AppTheme.mediumSpacing),
              _buildInfoRow('User ID', _user!.userId, Icons.fingerprint),
              const SizedBox(height: AppTheme.mediumSpacing),
              _buildInfoRow('Status', 'Active', Icons.check_circle, color: Colors.green),
              const SizedBox(height: AppTheme.mediumSpacing),
              _buildInfoRow(
                'Last Login', 
                _formatDateTime(_user!.profile.lastLoginAt ?? DateTime.now()), 
                Icons.access_time
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSummaryCard() {
    return Container(
      decoration: AppTheme.standardCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryMaroon,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Text(
                  'Wallet Summary',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            Row(
              children: [
                Expanded(
                  child: _buildWalletStat(
                    'Current Balance',
                    '₹${_user!.wallet.balance.toStringAsFixed(2)}',
                    Icons.account_balance,
                    AppTheme.accentGold,
                  ),
                ),
                const SizedBox(width: AppTheme.mediumSpacing),
                Expanded(
                  child: _buildWalletStat(
                    'Total Deposited',
                    '₹${_user!.wallet.totalDeposited.toStringAsFixed(2)}',
                    Icons.arrow_downward,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.mediumSpacing),
            
            Row(
              children: [
                Expanded(
                  child: _buildWalletStat(
                    'Total Withdrawn',
                    '₹${_user!.wallet.totalWithdrawn.toStringAsFixed(2)}',
                    Icons.arrow_upward,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: AppTheme.mediumSpacing),
                Expanded(
                  child: _buildWalletStat(
                    'Total Winnings',
                    '₹${_user!.wallet.totalWinnings.toStringAsFixed(2)}',
                    Icons.emoji_events,
                    AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.mediumSpacing),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.lightTextTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: AppTheme.standardCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: AppTheme.primaryMaroon,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Text(
                  'Settings',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            _buildSettingsTile(
              'Notifications',
              'Receive betting and result notifications',
              Icons.notifications,
              _user!.settings.notifications,
              (value) => _updateNotificationSettings(value),
            ),
            
            const Divider(height: AppTheme.largeSpacing * 2),
            
            _buildSettingsInfoTile(
              'Language',
              _user!.settings.language.toUpperCase(),
              Icons.language,
            ),
            
            const SizedBox(height: AppTheme.mediumSpacing),
            
            _buildSettingsInfoTile(
              'Timezone',
              _user!.settings.timezone,
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryMaroon, size: 20),
        const SizedBox(width: AppTheme.smallSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryMaroon,
          activeTrackColor: AppTheme.primaryMaroon.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildSettingsInfoTile(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryMaroon, size: 20),
        const SizedBox(width: AppTheme.smallSpacing),
        Text(
          title,
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard() {
    return Container(
      decoration: AppTheme.standardCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings_applications,
                  color: AppTheme.primaryMaroon,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.smallSpacing),
                Text(
                  'Actions',
                  style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryMaroon,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            _buildActionButton(
              'Change Password',
              'Update your account password',
              Icons.lock,
              () => _showChangePasswordDialog(),
            ),
            
            const SizedBox(height: AppTheme.mediumSpacing),
            
            _buildActionButton(
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip,
              () => _showPrivacyPolicy(),
            ),
            
            const SizedBox(height: AppTheme.mediumSpacing),
            
            _buildActionButton(
              'Terms & Conditions',
              'View terms and conditions',
              Icons.description,
              () => _showTermsAndConditions(),
            ),
            
            const SizedBox(height: AppTheme.largeSpacing),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.mediumSpacing),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.smallSpacing),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryMaroon, size: 20),
            const SizedBox(width: AppTheme.smallSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTextTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppTheme.primaryMaroon, size: 20),
        const SizedBox(width: AppTheme.smallSpacing),
        Text(
          label,
          style: AppTheme.lightTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
              color: color ?? AppTheme.textSecondary,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.largeSpacing),
          Text(
            'Failed to load profile',
            style: AppTheme.lightTextTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.largeSpacing),
          ElevatedButton.icon(
            onPressed: _loadUserData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: AppTheme.primaryButtonStyle,
          ),
        ],
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers if canceling edit
        _nameController.text = _user!.profile.name;
        _emailController.text = _user!.profile.email ?? '';
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Name cannot be empty');
      return;
    }

    setState(() {
      _isUpdatingProfile = true;
    });

    try {
      final updatedProfile = _user!.profile.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim() 
            : null,
      );

      final updatedUser = _user!.copyWith(profile: updatedProfile);
      
      await _databaseService.updateUser(_user!.userId, updatedUser.toMap());
      
      setState(() {
        _user = updatedUser;
        _isEditing = false;
        _isUpdatingProfile = false;
      });

      _showSuccessSnackBar('Profile updated successfully');
    } catch (e) {
      setState(() {
        _isUpdatingProfile = false;
      });
      _showErrorSnackBar('Failed to update profile: $e');
    }
  }

  Future<void> _updateNotificationSettings(bool enabled) async {
    try {
      final updatedSettings = _user!.settings.copyWith(notifications: enabled);
      final updatedUser = _user!.copyWith(settings: updatedSettings);
      
      await _databaseService.updateUser(_user!.userId, updatedUser.toMap());
      
      setState(() {
        _user = updatedUser;
      });

      _showSuccessSnackBar(
        enabled ? 'Notifications enabled' : 'Notifications disabled'
      );
    } catch (e) {
      _showErrorSnackBar('Failed to update settings: $e');
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        ),
        title: Text(
          'Change Password',
          style: AppTheme.lightTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryMaroon,
          ),
        ),
        content: Text(
          'To change your password, you will be logged out and need to verify your phone number again.',
          style: AppTheme.lightTextTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        ),
        title: Text(
          'Privacy Policy',
          style: AppTheme.lightTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryMaroon,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. This app collects and uses your personal information only for providing betting services. We do not share your data with third parties without your consent.',
            style: AppTheme.lightTextTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: AppTheme.primaryButtonStyle,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        ),
        title: Text(
          'Terms & Conditions',
          style: AppTheme.lightTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryMaroon,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'By using this app, you agree to our terms of service. Betting involves risk, and you should only bet what you can afford to lose. Users must be of legal age to participate.',
            style: AppTheme.lightTextTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: AppTheme.primaryButtonStyle,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        ),
        title: Text(
          'Logout',
          style: AppTheme.lightTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.lightTextTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to logout: $e');
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }
}





