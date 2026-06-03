import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/session_manager.dart';
import '../../home/pages/dashboard_page.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _selectedBloodType = 'A+';
  String _selectedGender = 'L';
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data ber-bintang (*) wajib diisi!')));
      return;
    }

    setState(() => _isLoading = true);

    final reqData = {
      "nik": _nikController.text.trim().isEmpty ? "00000" : _nikController.text.trim(),
      "full_name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "phone": _phoneController.text.trim(),
      "blood_type": _selectedBloodType,
      "gender": _selectedGender,
      "address": _addressController.text.trim().isEmpty ? "Yogyakarta" : _addressController.text.trim(),
    };

    final res = await AuthController().register(reqData);

    if (mounted) {
      setState(() => _isLoading = false);

      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final token = data['qr_token']?.toString() ?? '';
        
        await SessionManager().init();
        await SessionManager().saveSession(token, data);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil!'), backgroundColor: Colors.green));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashboardPage()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']), backgroundColor: AppTheme.primaryRed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(title: const Text('Daftar Pendonor Baru'), backgroundColor: AppTheme.surfaceWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField('Nama Lengkap *', _nameController, Icons.person_outline),
              _buildField('Email *', _emailController, Icons.email_outlined),
              _buildPasswordField(),
              _buildField('Nomor HP', _phoneController, Icons.phone_outlined),
              _buildField('NIK (KTP)', _nikController, Icons.badge_outlined),
              
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDropdown('Gol. Darah', ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'], _selectedBloodType, (val) => setState(() => _selectedBloodType = val!))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Jenis Kelamin', ['L', 'P'], _selectedGender, (val) => setState(() => _selectedGender = val!))),
                ],
              ),
              
              _buildField('Alamat Domisili', _addressController, Icons.location_on_outlined),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Daftar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          const SizedBox(height: 8),
          TextField(controller: controller, decoration: InputDecoration(prefixIcon: Icon(icon, size: 20), filled: true, fillColor: AppTheme.bgLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none))),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kata Sandi *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController, obscureText: _obscurePassword,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline, size: 20), filled: true, fillColor: AppTheme.bgLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none), suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: AppTheme.bgLight, borderRadius: BorderRadius.circular(6)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)),
        ),
      ],
    );
  }
}