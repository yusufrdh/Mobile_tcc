import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleReset() async {
    final email = _emailController.text.trim();
    final newPass = _passwordController.text;

    if (email.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email dan Sandi Baru wajib diisi!')));
      return;
    }

    setState(() => _isLoading = true);
    final res = await AuthController().forgotPassword(email, newPass);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']), backgroundColor: Colors.green));
        Navigator.pop(context); // Kembali ke halaman Login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']), backgroundColor: AppTheme.primaryRed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(title: const Text('Lupa Kata Sandi'), backgroundColor: AppTheme.surfaceWhite),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight)),
          child: Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Masukkan email terdaftar dan kata sandi baru Anda.', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
              const SizedBox(height: 24),
              const Text('Email Akun', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
              const SizedBox(height: 8),
              TextField(controller: _emailController, decoration: InputDecoration(prefixIcon: const Icon(Icons.email_outlined, size: 20), filled: true, fillColor: AppTheme.bgLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              const Text('Kata Sandi Baru', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
              const SizedBox(height: 8),
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline, size: 20), filled: true, fillColor: AppTheme.bgLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none))),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleReset,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Ubah Kata Sandi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}