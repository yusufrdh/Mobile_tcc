import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Mengekstrak palet Tailwind dari Web ke Flutter
  static const Color primaryRed = Color(0xFFDC2626); 
  static const Color primaryDark = Color(0xFFB91C1C); 
  static const Color primaryLight = Color(0xFFFFF1F2); 
  
  static const Color bgLight = Color(0xFFF7F8FB);
  static const Color surfaceWhite = Color(0xFFFFFFFF); // <-- Ini yang menyebabkan error sebelumnya
  
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF667085);
  
  static const Color borderLight = Color(0xFFE7EAF0);

  // Status Colors dari CSS Web
  static const Color safeBg = Color(0xFFDCFCE7);
  static const Color safeText = Color(0xFF166534);
  
  static const Color lowBg = Color(0xFFFEF3C7);
  static const Color lowText = Color(0xFF92400E);
  
  static const Color criticalBg = Color(0xFFFEE2E2);
  static const Color criticalText = Color(0xFF991B1B);

  // Box Shadow Panel Tailwind
  static List<BoxShadow> get panelShadow => [
    BoxShadow(
      color: const Color(0xFF1F2937).withOpacity(0.08),
      blurRadius: 30,
      offset: const Offset(0, 12),
    )
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: bgLight,
      primaryColor: primaryRed,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryRed, primary: primaryRed),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      ),
    );
  }
}