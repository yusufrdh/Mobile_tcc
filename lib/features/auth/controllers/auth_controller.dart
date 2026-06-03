import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:8080/api/v1'; 
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // 1. FUNGSI LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    _setLoadingState(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mobile/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      _setLoadingState(false);

      if (response.statusCode == 200) {
        return {'success': true, 'data': _extractData(data), 'message': 'Login Berhasil'};
      } else {
        return {'success': false, 'message': data['error']?['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      _setLoadingState(false);
      return {'success': false, 'message': 'Gagal koneksi ke server.'};
    }
  }

  // 2. FUNGSI REGISTER PENDONOR BARU
  Future<Map<String, dynamic>> register(Map<String, dynamic> requestData) async {
    _setLoadingState(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mobile/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      _setLoadingState(false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': _extractData(data), 'message': 'Registrasi Berhasil'};
      } else {
        return {'success': false, 'message': data['error']?['message'] ?? 'Registrasi gagal'};
      }
    } catch (e) {
      _setLoadingState(false);
      return {'success': false, 'message': 'Gagal koneksi ke server.'};
    }
  }

  // 3. FUNGSI LUPA KATA SANDI
  Future<Map<String, dynamic>> forgotPassword(String email, String newPassword) async {
    _setLoadingState(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mobile/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      _setLoadingState(false);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Kata sandi berhasil diubah'};
      } else {
        return {'success': false, 'message': data['error']?['message'] ?? 'Gagal mengubah sandi'};
      }
    } catch (e) {
      _setLoadingState(false);
      return {'success': false, 'message': 'Gagal koneksi ke server.'};
    }
  }

  // 4. FUNGSI EDIT PROFILE
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updateData) async {
    _setLoadingState(true);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mobile/donor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      _setLoadingState(false);

      if (response.statusCode == 200) {
        return {'success': true, 'data': _extractData(data), 'message': 'Profil diperbarui'};
      } else {
        return {'success': false, 'message': data['error']?['message'] ?? 'Gagal update profil'};
      }
    } catch (e) {
      _setLoadingState(false);
      return {'success': false, 'message': 'Gagal koneksi ke server.'};
    }
  }

  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fungsi helper untuk anti-bug double nesting JSON dari Golang
  Map<String, dynamic> _extractData(dynamic data) {
    if (data['data'] != null) {
      if (data['data'] is Map && data['data'].containsKey('data')) {
        return data['data']['data'];
      }
      return data['data'];
    }
    return data;
  }
}