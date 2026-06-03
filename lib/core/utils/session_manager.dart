import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get hasSeenOnboarding => _prefs?.getBool('hasSeenOnboarding') ?? false;
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs?.setBool('hasSeenOnboarding', value);
  }

  bool get isLoggedIn => _prefs?.getString('qr_token') != null;
  String? get qrToken => _prefs?.getString('qr_token');
  
  Map<String, dynamic>? get userData {
    final dataString = _prefs?.getString('user_data');
    if (dataString != null) return jsonDecode(dataString);
    return null;
  }

  Future<void> saveSession(String token, Map<String, dynamic> user) async {
    await _prefs?.setString('qr_token', token);
    await _prefs?.setString('user_data', jsonEncode(user));
  }

  Future<void> updateUserData(Map<String, dynamic> updatedUser) async {
    await _prefs?.setString('user_data', jsonEncode(updatedUser));
  }

  Future<void> clearSession() async {
    await _prefs?.remove('qr_token');
    await _prefs?.remove('user_data');
    await _prefs?.remove('stock_cache');
    await _prefs?.remove('stock_cache_time');
  }
}