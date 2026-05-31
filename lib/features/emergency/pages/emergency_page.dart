import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panggilan Darurat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.warning_rounded, color: AppTheme.primaryRed, size: 64),
                    SizedBox(height: 24),
                    Text('DARURAT MEDIS', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    SizedBox(height: 8),
                    Text('4 Kantong Darah O-', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
                    SizedBox(height: 12),
                    Text(
                      'Dibutuhkan segera di RSUP Dr. Sardjito.\nEstimasi jarak: 2.3 KM dari lokasi Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textMuted, height: 1.5, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('SAYA SIAP DONOR'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppTheme.borderLight),
                ),
                child: const Text('Tidak Bisa Kali Ini', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}