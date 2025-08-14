import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:password_vault_app/utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Settings page content',
          style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}