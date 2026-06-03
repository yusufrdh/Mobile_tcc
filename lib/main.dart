import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/session_manager.dart';
import 'features/auth/pages/login_page.dart';
import 'features/home/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi SessionManager
  await SessionManager().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek status login
    Widget initialPage = const LoginPage();
    if (SessionManager().isLoggedIn) {
      initialPage = const DashboardPage();
    }

    return MaterialApp(
      title: 'Bank Darah Digital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: initialPage,
    );
  }
}