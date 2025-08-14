import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
import 'package:password_vault_app/providers/theme_provider.dart';
import 'package:password_vault_app/services/secure_storage_service.dart';
import 'package:password_vault_app/services/database_service.dart';
import 'package:password_vault_app/utils/theme.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    if (mounted) {
      setState(() {
        _isBiometricAvailable = canAuthenticateWithBiometrics;
        // You would typically load the user's preference from secure storage here
        // For now, we'll just assume it's disabled by default.
        _isBiometricEnabled = false; 
      });
    }
  }

  // Function to show a confirmation dialog for resetting the vault
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Iconsax.danger, color: AppTheme.error),
            SizedBox(width: 12),
            Text('Reset Vault'),
          ],
        ),
        content: const Text(
          'This action will delete your master password and all stored credentials. It is irreversible.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.lightImpact();
              final secureStorage = SecureStorageService();
              final dbService = DatabaseService();
              
              await secureStorage.deleteMasterPassword();
              await dbService.deleteDatabase();
              
              Provider.of<CredentialProvider>(context, listen: false).loadCredentials();

              if (ctx.mounted) {
                Navigator.of(ctx).popUntil((route) => route.isFirst);
                Navigator.of(ctx).pushReplacementNamed('/auth');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Function to show a confirmation dialog for logging out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Iconsax.logout_1, color: AppTheme.warning),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out? You will need to enter your master password again to access your vault.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              if (ctx.mounted) {
                Navigator.of(ctx).popUntil((route) => route.isFirst);
                Navigator.of(ctx).pushReplacementNamed('/auth');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              Color(0xFF0F0F10),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSectionHeader(context, 'App Appearance'),
              _buildThemeTile(context, themeProvider),
              
              const SizedBox(height: 20),
              _buildSectionHeader(context, 'Security'),
              _buildBiometricTile(context),
              _buildSettingTile(
                context,
                title: 'Reset Vault',
                subtitle: 'Permanently delete all passwords and your master key',
                icon: Iconsax.trash,
                color: AppTheme.error,
                onTap: () => _showResetDialog(context),
              ),

              const SizedBox(height: 20),
              _buildSectionHeader(context, 'General'),
              _buildSettingTile(
                context,
                title: 'About SecureVault',
                subtitle: 'View application information and licenses',
                icon: Iconsax.info_circle,
                color: AppTheme.accent,
                onTap: () {
                  HapticFeedback.selectionClick();
                  // TODO: Navigate to an About page
                },
              ),
              _buildSettingTile(
                context,
                title: 'Log out',
                subtitle: 'Sign out and return to the master password screen',
                icon: Iconsax.logout_1,
                color: AppTheme.primaryBlue,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 0,
      color: AppTheme.cardDark,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
          ),
          child: Icon(
            themeProvider.themeMode == ThemeMode.dark ? Iconsax.sun_1 : Iconsax.moon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
        ),
        title: Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          themeProvider.themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Switch(
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
            HapticFeedback.selectionClick();
          },
        ),
      ),
    );
  }

  Widget _buildBiometricTile(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.cardDark,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.success.withOpacity(0.2)),
          ),
          child: Icon(
            Iconsax.finger_scan,
            color: AppTheme.success,
            size: 24,
          ),
        ),
        title: Text(
          'Biometric Lock',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          _isBiometricAvailable
              ? 'Use fingerprint or face to unlock'
              : 'Biometric security not available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: _isBiometricAvailable
            ? Switch(
                value: _isBiometricEnabled,
                onChanged: (value) async {
                  HapticFeedback.selectionClick();
                  // TODO: Implement biometric toggle logic
                  // This is where you would securely store the user's preference
                  setState(() {
                    _isBiometricEnabled = value;
                  });
                },
              )
            : const Icon(Iconsax.close_circle, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: AppTheme.cardDark,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(Iconsax.arrow_right_3, color: AppTheme.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
