import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../donor_card/pages/qr_card_page.dart';
import '../../emergency/pages/emergency_page.dart';
import '../../history/pages/history_page.dart';
import '../../profile/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const _HomeDashboardContent(),
    const QrCardPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F2937).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.dashboard_outlined, size: 22)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.dashboard_rounded, size: 22)),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.qr_code_outlined, size: 22)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.qr_code_rounded, size: 22)),
              label: 'Kartu',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.history_outlined, size: 22)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.history_rounded, size: 22)),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline_rounded, size: 22)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_rounded, size: 22)),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lokasiStokData = [
      {
        'instansi': 'UTD PMI Kota Yogyakarta',
        'jarak': '1.8 KM',
        'stok': {'A+': 45, 'B+': 12, 'O-': 2, 'AB+': 19},
        'status': 'Pusat Distribusi' // info badge
      },
      {
        'instansi': 'RSUP Dr. Sardjito',
        'jarak': '2.5 KM',
        'stok': {'A+': 14, 'B+': 8, 'O-': 0, 'AB+': 4},
        'status': 'Stok Kritis' // critical badge
      },
      {
        'instansi': 'RSA UGM Yogyakarta',
        'jarak': '4.2 KM',
        'stok': {'A+': 22, 'B+': 15, 'O-': 5, 'AB+': 7},
        'status': 'Aman' // safe badge
      },
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          backgroundColor: AppTheme.bgLight,
          surfaceTintColor: AppTheme.bgLight,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selamat Datang,', style: TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.normal)),
              Text('Yusuf Nur Ramadhan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Badge(
                label: Text('1'),
                backgroundColor: AppTheme.primaryRed,
                child: Icon(Icons.notifications_active_outlined, color: AppTheme.textDark, size: 24),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyPage())),
            ),
            const SizedBox(width: 16),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildEligibilityCard(context),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Icon(Icons.local_hospital_rounded, color: AppTheme.primaryRed, size: 20),
                  SizedBox(width: 8),
                  Text('Peta Distribusi & Stok Real-time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark, letterSpacing: -0.3)),
                ],
              ),
              const SizedBox(height: 16),
              ...lokasiStokData.map((data) => _buildHospitalStockCard(data)),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildEligibilityCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.panelShadow, // Menggunakan shadow spesifik dari CSS
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.safeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppTheme.safeText, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SIAP DONOR', style: TextStyle(color: AppTheme.safeText, fontWeight: FontWeight.w900, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Masa tunggu 60 hari terpenuhi (Hari ke-62)', style: TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showJadwalPmiBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed, // Tailwind red-600
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), // Sesuai button web
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Cek Jadwal & Lokasi PMI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), // Font-weight 800 sesuai btn css
            ),
          )
        ],
      ),
    );
  }

  void _showJadwalPmiBottomSheet(BuildContext context) {
    final List<Map<String, String>> dummyJadwal = [
      {'nama': 'UTD PMI Kota Yogyakarta', 'alamat': 'Jl. Tegalgendu No.25', 'jadwal': '08:00 - 20:00 WIB', 'jarak': '1.8 KM'},
      {'nama': 'RSUP Dr. Sardjito', 'alamat': 'Jl. Kesehatan No.1', 'jadwal': '08:00 - 15:30 WIB', 'jarak': '2.5 KM'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jadwal & Lokasi Donor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),
            ...dummyJadwal.map((lokasi) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.surfaceWhite, border: Border.all(color: AppTheme.borderLight), borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(lokasi['nama']!, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                    Text(lokasi['jarak']!, style: const TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w800))
                  ]),
                  const SizedBox(height: 8),
                  Text(lokasi['alamat']!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  Text(lokasi['jadwal']!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalStockCard(Map<String, dynamic> data) {
    final Map<String, int> stok = data['stok'];
    final String status = data['status'];
    
    // Menentukan style badge berdasarkan CSS Web
    Color badgeBg = const Color(0xFFEEF2F7);
    Color badgeText = const Color(0xFF344054);

    if (status.contains('Kritis')) {
      badgeBg = AppTheme.criticalBg;
      badgeText = AppTheme.criticalText;
    } else if (status.contains('Aman')) {
      badgeBg = AppTheme.safeBg;
      badgeText = AppTheme.safeText;
    } else if (status.contains('Distribusi')) {
      badgeBg = const Color(0xFFDBEAFE); // Info badge (blue)
      badgeText = const Color(0xFF1E40AF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.panelShadow, // Shadow dari Tailwind
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['instansi'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textDark)),
                    const SizedBox(height: 4),
                    Text('${data['jarak']} dari lokasi Anda', style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)), // Pill shape
                child: Text(status, style: TextStyle(color: badgeText, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(color: AppTheme.borderLight, height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stok.entries.map((entry) {
              final isZero = entry.value == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isZero ? AppTheme.criticalBg : AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isZero ? AppTheme.criticalText.withOpacity(0.2) : AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    Text(entry.key, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: isZero ? AppTheme.criticalText : AppTheme.textMuted)),
                    const SizedBox(height: 2),
                    Text('${entry.value} Pk', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isZero ? AppTheme.criticalText : AppTheme.textDark)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}