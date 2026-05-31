import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _selectedBloodType;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Pendonor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Lengkapi Profil Medis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data Anda dilindungi dan digunakan khusus untuk pencocokan kebutuhan darah darurat PMI.',
              style: TextStyle(color: AppTheme.textMuted, height: 1.5),
            ),
            const SizedBox(height: 32),
            const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap (Sesuai KTP)', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nomor Induk Kependudukan (NIK)', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Nomor WhatsApp', prefixIcon: Icon(Icons.phone_outlined)),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Golongan Darah', prefixIcon: Icon(Icons.water_drop_outlined, color: AppTheme.primaryRed)),
              value: _selectedBloodType,
              items: _bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _selectedBloodType = value),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Alamat Domisili Lengkap', prefixIcon: Icon(Icons.map_outlined)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: Submit Register ke API ASP.NET Core
                Navigator.pop(context);
              },
              child: const Text('Buat Akun'),
            ),
          ],
        ),
      ),
    );
  }
}