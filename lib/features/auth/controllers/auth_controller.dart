import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:8080/api/v1';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> login(String email, String password) async {
    _setLoadingState(true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mobile/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      _setLoadingState(false);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data'], 'message': 'Login Berhasil'};
      } else {
        return {
          'success': false, 
          'message': data['error']?['message'] ?? 'Login gagal'
        };
      }
    } catch (e) {
      _setLoadingState(false);
      return {
        'success': false, 
        'message': 'Gagal koneksi ke server.'
      };
    }
  }

  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}