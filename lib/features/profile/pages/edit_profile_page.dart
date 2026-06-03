import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/session_manager.dart';
import '../../auth/controllers/auth_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = SessionManager().userData;
    
    _nameController = TextEditingController(text: user?['full_name'] ?? user?['name'] ?? '');
    _phoneController = TextEditingController(text: user?['phone'] ?? '');
    _emailController = TextEditingController(text: user?['email'] ?? '');
    _addressController = TextEditingController(text: user?['address'] ?? '');
  }

  void _handleSave() async {
    setState(() => _isLoading = true);

    final reqData = {
      "qr_token": SessionManager().userData?['qr_token'] ?? '', // Token unik user (WAJIB)
      "full_name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "address": _addressController.text.trim(),
      "latitude": 0.0,
      "longitude": 0.0,
    };

    final res = await AuthController().updateProfile(reqData);

    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success'] == true) {
        // SIMPAN DATA BARU KE HP
        await SessionManager().updateUserData(res['data']);
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: Colors.green));
        Navigator.pop(context, true); // Kirim flag "true" ke ProfilePage biar me-refresh layarnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']), backgroundColor: AppTheme.primaryRed));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(title: const Text('Edit Profil'), backgroundColor: AppTheme.surfaceWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Nama Lengkap', _nameController),
              _buildField('Nomor HP', _phoneController),
              _buildField('Email', _emailController),
              _buildField('Alamat Domisili', _addressController, isMultiline: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          const SizedBox(height: 8),
          TextField(controller: controller, maxLines: isMultiline ? 3 : 1, decoration: InputDecoration(filled: true, fillColor: AppTheme.bgLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none))),
        ],
      ),
    );
  }
}