import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/session_manager.dart';
import '../../auth/pages/login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userData = SessionManager().userData;
    
    // Pengecekan ganda berbagai kemungkinan key dari backend
    final String displayName = userData?['full_name'] ?? userData?['fullName'] ?? userData?['name'] ?? 'Pendonor';
    final String displayEmail = userData?['email'] ?? 'Belum ada email';
    
    final String initials = displayName.trim().isNotEmpty 
        ? (displayName.trim().length >= 2 ? displayName.trim().substring(0, 2).toUpperCase() : displayName.trim()[0].toUpperCase())
        : 'PD';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: AppTheme.surfaceWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())).then((value) {
                if (value == true) setState(() {});
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(width: 82, height: 82, decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)), child: Center(child: Text(initials, style: const TextStyle(color: Color(0xFF991B1B), fontSize: 26, fontWeight: FontWeight.w900)))),
            const SizedBox(height: 16),
            Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text(displayEmail, style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
            const SizedBox(height: 28),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight), boxShadow: AppTheme.panelShadow),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('TOTAL DONOR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 0.5)),
                    SizedBox(height: 6),
                    Text('2 Kali', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
                  ]),
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.favorite_rounded, color: AppTheme.primaryRed, size: 26)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Align(alignment: Alignment.centerLeft, child: Text('Pengaturan Aplikasi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textDark, letterSpacing: -0.3))),
            const SizedBox(height: 12),
            _buildSettingsTile(Icons.notifications_outlined, 'Notifikasi Darurat', trailing: Switch(value: true, onChanged: (v) {}, activeColor: AppTheme.primaryRed, activeTrackColor: AppTheme.primaryLight)),
            _buildSettingsTile(Icons.security_outlined, 'Keamanan & Kata Sandi', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPage()))),
            _buildSettingsTile(Icons.help_outline_rounded, 'Pusat Bantuan & FAQ', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqPage()))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await SessionManager().clearSession();
                  if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
                },
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: AppTheme.primaryRed, width: 1.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                child: const Text('Keluar dari Akun', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight), boxShadow: AppTheme.panelShadow),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), leading: Icon(icon, color: AppTheme.textMuted, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 20),
        onTap: onTap,
      ),
    );
  }
}

class SecurityPage extends StatefulWidget { const SecurityPage({super.key}); @override State<SecurityPage> createState() => _SecurityPageState(); }
class _SecurityPageState extends State<SecurityPage> {
  bool _obscureOld = true, _obscureNew = true, _obscureConfirm = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight, appBar: AppBar(title: const Text('Keamanan & Kata Sandi'), backgroundColor: AppTheme.surfaceWhite, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight), boxShadow: AppTheme.panelShadow),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ubah Kata Sandi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark)), const SizedBox(height: 6),
              const Text('Pastikan kata sandi Anda kuat.', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)), const SizedBox(height: 24),
              _buildPasswordField('Kata Sandi Lama', _obscureOld, () => setState(() => _obscureOld = !_obscureOld)), const SizedBox(height: 16),
              _buildPasswordField('Kata Sandi Baru', _obscureNew, () => setState(() => _obscureNew = !_obscureNew)), const SizedBox(height: 16),
              _buildPasswordField('Konfirmasi Kata Sandi Baru', _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)), const SizedBox(height: 32),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Kata sandi berhasil diperbarui'), backgroundColor: Color(0xFF166534))); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)))),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPasswordField(String label, bool obscure, VoidCallback onToggle) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textDark)), const SizedBox(height: 8),
      TextField(obscureText: obscure, decoration: InputDecoration(filled: true, fillColor: AppTheme.bgLight, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.borderLight)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppTheme.primaryRed, width: 1.2)), suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppTheme.textMuted), onPressed: onToggle)))
    ]);
  }
}

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});
  @override
  Widget build(BuildContext context) {
    final faqs = [{'q': 'Apa saja syarat mendonor?', 'a': 'Berusia 17-60 tahun, berat badan min 45 kg, dll.'}, {'q': 'Berapa lama jarak waktu minimal antar donor?', 'a': 'Minimal 60 hari sejak donasi terakhir.'}];
    return Scaffold(
      backgroundColor: AppTheme.bgLight, appBar: AppBar(title: const Text('Pusat Bantuan & FAQ'), backgroundColor: AppTheme.surfaceWhite, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(padding: const EdgeInsets.all(24.0), itemCount: faqs.length, itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight), boxShadow: AppTheme.panelShadow),
          child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: ExpansionTile(iconColor: AppTheme.primaryRed, collapsedIconColor: AppTheme.textMuted, tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), title: Text(faqs[index]['q']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark)), children: [Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), child: Text(faqs[index]['a']!, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)))]))
        );
      }),
    );
  }
}