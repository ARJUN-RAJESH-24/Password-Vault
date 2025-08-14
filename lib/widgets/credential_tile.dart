import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:password_vault_app/models/credential.dart';
import 'package:password_vault_app/screens/view_credential_screen.dart';
import 'package:password_vault_app/utils/theme.dart';

class CredentialTile extends StatefulWidget {
  final Credential credential;

  const CredentialTile({super.key, required this.credential});

  @override
  State<CredentialTile> createState() => _CredentialTileState();
}

class _CredentialTileState extends State<CredentialTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.selectionClick();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
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
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, _) => 
                ViewCredentialScreen(credential: widget.credential),
            transitionsBuilder: (context, animation, _, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isPressed 
                        ? AppTheme.primaryBlue.withOpacity(0.5)
                        : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Service icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getServiceColor(widget.credential.title)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _getServiceColor(widget.credential.title)
                                .withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _getServiceIcon(widget.credential.title),
                          color: _getServiceColor(widget.credential.title),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.credential.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.user,
                                  size: 14,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.credential.username,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Arrow indicator
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.arrow_right_3,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}