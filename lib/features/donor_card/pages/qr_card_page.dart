import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/session_manager.dart';

class QrCardPage extends StatelessWidget {
  const QrCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = SessionManager().userData;
    final String fullName = userData?['full_name'] ?? 'Pendonor';
    final String bloodType = userData?['blood_type'] ?? '-';
    final String qrToken = userData?['qr_token'] ?? 'INVALID_TOKEN';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(title: const Text('Kartu Pendonor'), backgroundColor: AppTheme.surfaceWhite),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.panelShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Scan Kartu QR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
                const SizedBox(height: 8),
                const Text('Tunjukkan ke petugas PMI saat donor.', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                const SizedBox(height: 32),
                
                // QR CODE GENERATOR
                QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: AppTheme.textDark,
                ),
                
                const SizedBox(height: 32),
                const Divider(color: AppTheme.borderLight),
                const SizedBox(height: 16),
                
                // DATA DIRI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDataColumn('NAMA', fullName),
                    _buildDataColumn('GOL. DARAH', bloodType),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
      ],
    );
  }
}