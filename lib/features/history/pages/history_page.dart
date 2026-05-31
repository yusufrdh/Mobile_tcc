import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy riwayat donasi
    final List<Map<String, dynamic>> dummyHistory = [
      {
        'date': '12 Maret 2026',
        'location': 'PMI Kota Yogyakarta',
        'type': 'Donor Sukarela',
        'status': 'Berhasil',
        'hb': '14.2 g/dL',
        'bp': '120/80',
      },
      {
        'date': '05 Januari 2026',
        'location': 'RSUP Dr. Sardjito',
        'type': 'Panggilan Darurat',
        'status': 'Berhasil',
        'hb': '13.8 g/dL',
        'bp': '115/75',
      },
      {
        'date': '10 November 2025',
        'location': 'Kampus Terpadu',
        'type': 'Donor Sukarela',
        'status': 'Dibatalkan (Medis)',
        'hb': '11.5 g/dL', // HB rendah sebagai alasan batal
        'bp': '110/70',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Donasi'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: dummyHistory.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          final isSuccess = item['status'] == 'Berhasil';

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['date'],
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          color: isSuccess ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: AppTheme.textMuted),
                    const SizedBox(width: 8),
                    Text(item['location'], style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.bloodtype_outlined, size: 18, color: AppTheme.primaryRed),
                    const SizedBox(width: 8),
                    Text(item['type'], style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  ],
                ),
                if (isSuccess) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppTheme.borderLight, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMedicalStat('Hemoglobin', item['hb']),
                      _buildMedicalStat('Tekanan Darah', item['bp']),
                    ],
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicalStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
      ],
    );
  }
}