import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
import 'package:password_vault_app/providers/theme_provider.dart'; // Import the new ThemeProvider
import 'package:password_vault_app/screens/auth_screen.dart';
import 'package:password_vault_app/screens/home_screen.dart';
import 'package:password_vault_app/services/secure_storage_service.dart';
import 'package:password_vault_app/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0B),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  final SecureStorageService secureStorage = SecureStorageService();
  final hasMasterPassword = await secureStorage.hasMasterPassword();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CredentialProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add the ThemeProvider
      ],
      child: MyApp(hasMasterPassword: hasMasterPassword),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasMasterPassword;

  const MyApp({super.key, required this.hasMasterPassword});

  @override
  Widget build(BuildContext context) {
    // Consume the ThemeProvider to dynamically switch themes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SecureVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme, // Use a light theme as the base
          darkTheme: AppTheme.darkTheme, // Provide a dark theme
          themeMode: themeProvider.themeMode, // Control the theme mode
          home: hasMasterPassword ? const AuthScreen() : const HomeScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/auth': (context) => const AuthScreen(),
          },
        );
      },
    );
  }
}
