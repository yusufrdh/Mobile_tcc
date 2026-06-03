import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/session_manager.dart';
import 'features/auth/pages/login_page.dart';
import 'features/home/pages/dashboard_page.dart';

// Halaman Onboarding terintegrasi agar tidak error import missing file
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.favorite_rounded, color: AppTheme.primaryRed, size: 80),
              const SizedBox(height: 32),
              const Text('Selamat Datang di Pahlawan Darah', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark, letterSpacing: -0.5)),
              const SizedBox(height: 16),
              const Text('Pantau kelayakan donor dan dapatkan notifikasi darurat.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.5)),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await SessionManager().setHasSeenOnboarding(true);
                  if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                child: const Text('Mulai Sekarang', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager().init();

  Widget initialScreen;
  if (!SessionManager().hasSeenOnboarding) {
    initialScreen = const OnboardingPage();
  } else if (SessionManager().isLoggedIn) {
    initialScreen = const DashboardPage();
  } else {
    initialScreen = const LoginPage();
  }

  runApp(BankDarahApp(initialScreen: initialScreen));
}

class BankDarahApp extends StatelessWidget {
  final Widget initialScreen;
  const BankDarahApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Bank Darah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: initialScreen,
    );
  }
}