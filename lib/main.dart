import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
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
    return MaterialApp(
      title: 'SecureVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: hasMasterPassword ? const AuthScreen() : const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}