import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  late SharedPreferences _prefs;

  // Wajib dipanggil di main.dart
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- GETTER & SETTER ONBOARDING ---
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool('has_seen_onboarding', value);
  }

  bool get hasSeenOnboarding => _prefs.getBool('has_seen_onboarding') ?? false;

  // --- GETTER & SETTER AUTH ---
  bool get isLoggedIn => _prefs.getBool('is_logged_in') ?? false;

  Map<String, dynamic>? get userData {
    final dataStr = _prefs.getString('user_data');
    if (dataStr != null) {
      return jsonDecode(dataStr) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveSession(String token, Map<String, dynamic> data) async {
    await _prefs.setString('qr_token', token);
    await _prefs.setString('user_data', jsonEncode(data));
    await _prefs.setBool('is_logged_in', true);
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    await _prefs.setString('user_data', jsonEncode(data));
  }

  Future<void> clearSession() async {
    final hasSeen = hasSeenOnboarding; // Simpan status onboarding biar gak ngulang
    await _prefs.clear();
    await setHasSeenOnboarding(hasSeen);
  }
}