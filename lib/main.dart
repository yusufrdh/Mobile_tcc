import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BankDarahApp());
}

class BankDarahApp extends StatelessWidget {
  const BankDarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Bank Darah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}