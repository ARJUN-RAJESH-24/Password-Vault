import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:password_vault_app/models/credential.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
import 'package:password_vault_app/screens/add_credential_screen.dart';
import 'package:password_vault_app/utils/theme.dart';

class ViewCredentialScreen extends StatefulWidget {
  final Credential credential;

  const ViewCredentialScreen({super.key, required this.credential});

  @override
  State<ViewCredentialScreen> createState() => _ViewCredentialScreenState();
}

class _ViewCredentialScreenState extends State<ViewCredentialScreen>
    with TickerProviderStateMixin {
  late String _decryptedPassword;
  bool _isPasswordVisible = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _decryptedPassword = Provider.of<CredentialProvider>(context, listen: false)
        .decryptPassword(widget.credential.encryptedPassword);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.successImpact();
    
    // Trigger pulse animation
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.copy, color: Colors.white),
            const SizedBox(width: 12),
            Text('$type copied to clipboard'),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteCredential() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Iconsax.danger, color: AppTheme.error),
            SizedBox(width: 12),
            Text('Delete Password'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this password? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<CredentialProvider>(context, listen: false)
                  .deleteCredential(widget.credential.id!);
              if (mounted) {
                HapticFeedback.successImpact();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home screen
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('google') || lowerTitle.contains('gmail')) {
      return Iconsax.google;
    } else if (lowerTitle.contains('facebook') || lowerTitle.contains('meta')) {
      return Iconsax.facebook;
    } else if (lowerTitle.contains('twitter') || lowerTitle.contains('x')) {
      return Iconsax.twitter;
    } else if (lowerTitle.contains('instagram')) {
      return Iconsax.instagram;
    } else if (lowerTitle.contains('linkedin')) {
      return Iconsax.linkedin;
    } else if (lowerTitle.contains('github')) {
      return Iconsax.code;
    } else if (lowerTitle.contains('netflix')) {
      return Iconsax.video_play;
    } else if (lowerTitle.contains('spotify')) {
      return Iconsax.music;
    } else if (lowerTitle.contains('amazon')) {
      return Iconsax.shop;
    } else if (lowerTitle.contains('apple')) {
      return Iconsax.apple;
    } else if (lowerTitle.contains('microsoft')) {
      return Iconsax.microsoft;
    } else if (lowerTitle.contains('dropbox')) {
      return Iconsax.cloud;
    } else if (lowerTitle.contains('bank') || lowerTitle.contains('finance')) {
      return Iconsax.bank;
    } else if (lowerTitle.contains('mail') || lowerTitle.contains('email')) {
      return Iconsax.sms;
    } else {
      return Iconsax.lock_1;
    }
  }

  Color _getServiceColor(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('google') || lowerTitle.contains('gmail')) {
      return const Color(0xFF4285F4);
    } else if (lowerTitle.contains('facebook') || lowerTitle.contains('meta')) {
      return const Color(0xFF1877F2);
    } else if (lowerTitle.contains('twitter') || lowerTitle.contains('x')) {
      return const Color(0xFF1DA1F2);
    } else if (lowerTitle.contains('instagram')) {
      return const Color(0xFFE4405F);
    } else if (lowerTitle.contains('linkedin')) {
      return const Color(0xFF0A66C2);
    } else if (lowerTitle.contains('github')) {
      return const Color(0xFF333333);
    } else if (lowerTitle.contains('netflix')) {
      return const Color(0xFFE50914);
    } else if (lowerTitle.contains('spotify')) {
      return const Color(0xFF1DB954);
    } else if (lowerTitle.contains('amazon')) {
      return const Color(0xFFFF9900);
    } else if (lowerTitle.contains('apple')) {
      return const Color(0xFF007AFF);
    } else if (lowerTitle.contains('microsoft')) {
      return const Color(0xFF00A1F1);
    } else if (lowerTitle.contains('dropbox')) {
      return const Color(0xFF0061FF);
    } else if (lowerTitle.contains('bank') || lowerTitle.contains('finance')) {
      return AppTheme.success;
    } else if (lowerTitle.contains('mail') || lowerTitle.contains('email')) {
      return AppTheme.accent;
    } else {
      return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 400),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildInfoCard(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
              },
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, _) => 
                        AddCredentialScreen(credential: widget.credential),
                    transitionsBuilder: (context, animation, _, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      );
                    },
                  ),
                );
              },
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: () {
                HapticFeedback.selectionClick();
                _deleteCredential();
              },
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _getServiceColor(widget.credential.title).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getServiceColor(widget.credential.title).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            _getServiceIcon(widget.credential.title),
            color: _getServiceColor(widget.credential.title),
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.credential.title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to copy information',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInfoRow(
              'Username',
              widget.credential.username,
              Iconsax.user,
              () => _copyToClipboard(widget.credential.username, 'Username'),
            ),
            const SizedBox(height: 24),
            _buildPasswordRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Spacer(),
            Icon(Iconsax.copy, color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () => _copyToClipboard(_decryptedPassword, 'Password'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.key, color: AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isPasswordVisible 
                            ? _decryptedPassword 
                            : '•' * _decryptedPassword.length,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),
                  Icon(Iconsax.copy, color: AppTheme.textSecondary, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCredentialScreen(credential: widget.credential),
                  ),
                );
              },
              icon: const Icon(Iconsax.edit, color: AppTheme.primaryBlue),
              label: const Text(
                'Edit',
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.error.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextButton.icon(
              onPressed: _deleteCredential,
              icon: const Icon(Iconsax.trash, color: AppTheme.error),
              label: const Text(
                'Delete',
                style: TextStyle(color: AppTheme.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}