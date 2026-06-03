import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.dashboard_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.dashboard_rounded, size: 22),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.qr_code_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.qr_code_rounded, size: 22),
              ),
              label: 'Kartu',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.history_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.history_rounded, size: 22),
              ),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person_outline_rounded, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person_rounded, size: 22),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// DIUBAH JADI STATEFUL WIDGET BIAR BISA GANTI NAMA DINAMIS
class _HomeDashboardContent extends StatefulWidget {
  const _HomeDashboardContent();

  @override
  State<_HomeDashboardContent> createState() => _HomeDashboardContentState();
}

class _HomeDashboardContentState extends State<_HomeDashboardContent> {
  // Variabel untuk menampung nama
  String _fullName = "Memuat...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk menarik data dari session (login)
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user_data'); 
      if (userStr != null) {
        final user = jsonDecode(userStr);
        setState(() {
          _fullName = user['full_name'] ?? "Pendonor";
        });
      } else {
        setState(() {
          _fullName = "Pendonor (Guest)";
        });
      }
    } catch (e) {
      setState(() {
        _fullName = "Pendonor";
      });
    }
  }

  Future<void> _openMap({
    required String nama,
    required double lat,
    required double lng,
    required BuildContext context,
  }) async {
    debugPrint('Membuka maps ke: $nama | lat: $lat | lng: $lng');

    final Uri url = Uri.https(
      'www.google.com',
      '/maps/dir/',
      {
        'api': '1',
        'destination': '$lat,$lng',
        'travelmode': 'driving',
        'dir_action': 'navigate',
      },
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gagal membuka peta. Pastikan Google Maps terinstall pada perangkat Anda.',
            ),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lokasiStokData = [
      {
        'instansi': 'UTD PMI Kota Yogyakarta',
        'jarak': '1.8 KM',
        'lat': -7.8261016,
        'lng': 110.3920925,
        'stok': {'A+': 45, 'B+': 12, 'O-': 2, 'AB+': 19},
        'status': 'Pusat Distribusi',
      },
      {
        'instansi': 'RSUP Dr. Sardjito',
        'jarak': '2.5 KM',
        'lat': -7.7680643,
        'lng': 110.3730485,
        'stok': {'A+': 14, 'B+': 8, 'O-': 0, 'AB+': 4},
        'status': 'Stok Kritis',
      },
      {
        'instansi': 'RSA UGM Yogyakarta',
        'jarak': '4.2 KM',
        'lat': -7.7427862,
        'lng': 110.3504284,
        'stok': {'A+': 22, 'B+': 15, 'O-': 5, 'AB+': 7},
        'status': 'Aman',
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // NAMA BERUBAH DINAMIS DI SINI
              Text(
                _fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Badge(
                label: Text('1'),
                backgroundColor: AppTheme.primaryRed,
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: AppTheme.textDark,
                  size: 24,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmergencyPage()),
              ),
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
                  Icon(
                    Icons.local_hospital_rounded,
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Peta Distribusi & Stok Real-time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...lokasiStokData.map(
                (data) => _buildHospitalStockCard(data, context),
              ),
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
        boxShadow: AppTheme.panelShadow,
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
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.safeText,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIAP DONOR',
                      style: TextStyle(
                        color: AppTheme.safeText,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Masa tunggu 60 hari terpenuhi (Hari ke-62)',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cek Jadwal & Lokasi PMI',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJadwalPmiBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> dummyJadwal = [
      {
        'nama': 'UTD PMI Kota Yogyakarta',
        'alamat': 'Jl. Tegal Gendu No.25, Kotagede',
        'jadwal': '08:00 - 20:00 WIB',
        'jarak': '1.8 KM',
        'lat': -7.8261016,
        'lng': 110.3920925,
      },
      {
        'nama': 'RSUP Dr. Sardjito',
        'alamat': 'Jl. Kesehatan No.1, Sekip',
        'jadwal': '08:00 - 15:30 WIB',
        'jarak': '2.5 KM',
        'lat': -7.7680643,
        'lng': 110.3730485,
      },
      {
        'nama': 'RSA UGM Yogyakarta',
        'alamat': 'Jl. Kabupaten, Kronggahan, Trihanggo, Gamping',
        'jadwal': '08:00 - 15:30 WIB',
        'jarak': '4.2 KM',
        'lat': -7.7427862,
        'lng': 110.3504284,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jadwal & Lokasi Donor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih lokasi terdekat untuk mendonor hari ini.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            ...dummyJadwal.map(
              (lokasi) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lokasi['nama'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          lokasi['jarak'] as String,
                          style: const TextStyle(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lokasi['alamat'] as String,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lokasi['jadwal'] as String,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _openMap(
                          nama: lokasi['nama'] as String,
                          lat: (lokasi['lat'] as num).toDouble(),
                          lng: (lokasi['lng'] as num).toDouble(),
                          context: context,
                        ),
                        icon: const Icon(
                          Icons.directions_rounded,
                          size: 18,
                        ),
                        label: const Text('Petunjuk Arah'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryRed,
                          side: const BorderSide(
                            color: AppTheme.primaryRed,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalStockCard(
    Map<String, dynamic> data,
    BuildContext context,
  ) {
    final Map<String, int> stok = data['stok'] as Map<String, int>;
    final String status = data['status'] as String;

    Color badgeBg = const Color(0xFFEEF2F7);
    Color badgeText = const Color(0xFF344054);

    if (status.contains('Kritis')) {
      badgeBg = AppTheme.criticalBg;
      badgeText = AppTheme.criticalText;
    } else if (status.contains('Aman')) {
      badgeBg = AppTheme.safeBg;
      badgeText = AppTheme.safeText;
    } else if (status.contains('Distribusi')) {
      badgeBg = const Color(0xFFDBEAFE);
      badgeText = const Color(0xFF1E40AF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.panelShadow,
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
                    Text(
                      data['instansi'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data['jarak'] as String,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Material(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          child: InkWell(
                            onTap: () => _openMap(
                              nama: data['instansi'] as String,
                              lat: (data['lat'] as num).toDouble(),
                              lng: (data['lng'] as num).toDouble(),
                              context: context,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.navigation_rounded,
                                    size: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Arahkan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              color: AppTheme.borderLight,
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stok.entries.map((entry) {
              final bool isZero = entry.value == 0;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isZero ? AppTheme.criticalBg : AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isZero
                        ? AppTheme.criticalText.withOpacity(0.2)
                        : AppTheme.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color:
                            isZero ? AppTheme.criticalText : AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${entry.value} Pk',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color:
                            isZero ? AppTheme.criticalText : AppTheme.textDark,
                      ),
                    ),
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