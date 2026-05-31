import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _currentStep = 1; // 1: Email, 2: OTP, 3: New Password
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _nextStep() {
    setState(() {
      if (_currentStep < 3) {
        _currentStep++;
      } else {
        // Alur akhir: Berhasil mengubah password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Kata sandi berhasil diperbarui. Silakan masuk kembali.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF166534),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text('Pemulihan Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.panelShadow,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentStepView(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepView() {
    if (_currentStep == 1) {
      return _buildEmailStep();
    } else if (_currentStep == 2) {
      return _buildOtpStep();
    } else {
      return _buildNewPasswordStep();
    }
  }

  // LANGKAH 1: INPUT EMAIL
  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Lupa Kata Sandi?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan alamat email yang terdaftar. Kami akan mengirimkan kode OTP untuk memverifikasi identitas Anda.',
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        const Text('Alamat Email', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgLight,
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppTheme.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.primaryRed, width: 1.2)),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Kirim Kode Verifikasi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  // LANGKAH 2: VERIFIKASI OTP
  Widget _buildOtpStep() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Verifikasi Kode OTP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark),
        ),
        const SizedBox(height: 8),
        Text(
          'Kode OTP keamanan telah dikirimkan ke ${_emailController.text.isNotEmpty ? _emailController.text : "email Anda"}.',
          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        const Text('Kode OTP (6 Digit)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 8),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppTheme.bgLight,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.primaryRed, width: 1.2)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Verifikasi Kode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Kirim Ulang Kode', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        )
      ],
    );
  }

  // LANGKAH 3: ATUR ULANG KATA SANDI
  Widget _buildNewPasswordStep() {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Kata Sandi Baru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark),
        ),
        const SizedBox(height: 8),
        const Text(
          'Buat kata sandi baru yang kuat dan unik demi menjaga keamanan data profil medis Anda.',
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        _buildPasswordField('Kata Sandi Baru', _newPasswordController, _obscureNew, () => setState(() => _obscureNew = !_obscureNew)),
        const SizedBox(height: 16),
        _buildPasswordField('Konfirmasi Kata Sandi Baru', _confirmPasswordController, _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Perbarui Kata Sandi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.primaryRed, width: 1.2)),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppTheme.textMuted),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}