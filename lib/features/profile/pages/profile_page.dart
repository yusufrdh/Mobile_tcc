import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.bgLight,
        title: const Text('Profil Pengguna'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Identitas Utama (.avatar.large)
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'YN',
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Yusuf Nur Ramadhan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            const Text(
              'yusuf.ramadhan@student.upnyk.ac.id',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 28),

            // Kartu Metrik Tunggal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.panelShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL DONOR',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 0.5),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '2 Kali',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textDark),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.favorite_rounded, color: AppTheme.primaryRed, size: 26),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Pengaturan Aplikasi
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pengaturan Aplikasi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textDark, letterSpacing: -0.3),
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              Icons.notifications_outlined,
              'Notifikasi Darurat',
              trailing: Switch(
                value: true,
                onChanged: (v) {},
                activeColor: AppTheme.primaryRed,
                activeTrackColor: AppTheme.primaryLight,
              ),
            ),
            _buildSettingsTile(
              context,
              Icons.security_outlined,
              'Keamanan & Kata Sandi',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SecurityPage()),
              ),
            ),
            _buildSettingsTile(
              context,
              Icons.help_outline_rounded,
              'Pusat Bantuan & FAQ',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FaqPage()),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Keluar (.btn.secondary & .btn.wide)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.primaryRed, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.panelShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: AppTheme.textMuted, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 20),
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// FEATURE: KEAMANAN & KATA SANDI (SECURITY)
// ==========================================
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text('Keamanan & Kata Sandi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: AppTheme.panelShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pastikan kata sandi Anda kuat untuk mengamankan data rekam medis donor.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField('Kata Sandi Lama', _obscureOld, () => setState(() => _obscureOld = !_obscureOld)),
                  const SizedBox(height: 16),
                  _buildPasswordField('Kata Sandi Baru', _obscureNew, () => setState(() => _obscureNew = !_obscureNew)),
                  const SizedBox(height: 16),
                  _buildPasswordField('Konfirmasi Kata Sandi Baru', _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Kata sandi berhasil diperbarui'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF166534),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, bool obscure, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        TextField(
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
}

// ==========================================
// FEATURE: PUSAT BANTUAN & FAQ (ACCORDION)
// ==========================================
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'q': 'Apa saja syarat utama untuk mendonorkan darah?',
        'a': 'Syarat utama meliputi: Berusia 17-60 hari, berat badan minimal 45 kg, kadar hemoglobin (HB) 12.5 - 17.0 g/dL, tekanan darah normal (sistole 100-140, diastole 70-90), serta tidak sedang mengonsumsi antibiotik atau obat tertentu dalam 3 hari terakhir.'
      },
      {
        'q': 'Berapa lama jarak waktu minimal antar donor darah?',
        'a': 'Sesuai dengan standar medis PMI dan kalkulasi sistem aplikasi, jarak waktu minimal antar donor darah lengkap (whole blood) adalah 60 hari sejak donasi terakhir Anda untuk memastikan regenerasi sel darah merah berjalan optimal.'
      },
      {
        'q': 'Bagaimana cara menggunakan Kartu Digital QR Code?',
        'a': 'Kartu Digital di tab menu menghasilkan QR Code unik yang terenkripsi secara otomatis. Cukup tunjukkan layar handphone Anda kepada petugas admin di unit PMI untuk dipindai melalui sistem Web Admin, sehingga proses check-in berjalan instan tanpa mengisi formulir kertas.'
      },
      {
        'q': 'Mengapa saya menerima Notifikasi Darurat (High-Priority)?',
        'a': 'Sistem mengirimkan push notification high-priority hanya jika ada Rumah Sakit terdekat yang mendesak membutuhkan suplai darah yang cocok dengan golongan darah Anda. Notifikasi ini dirancang untuk memicu aksi cepat pendonor demi menyelamatkan pasien.'
      }
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text('Pusat Bantuan & FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: AppTheme.panelShadow,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: AppTheme.primaryRed,
                collapsedIconColor: AppTheme.textMuted,
                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: Text(
                  faqs[index]['q']!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark, height: 1.3),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Text(
                      faqs[index]['a']!,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}