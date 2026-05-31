import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password tidak boleh kosong.';
      notifyListeners();
      return false;
    }

    _setLoadingState(true);
    try {
      // Disiapkan untuk integrasi endpoint API ASP.NET Core
      await Future.delayed(const Duration(milliseconds: 1500));
      _setLoadingState(false);
      return true;
    } catch (e) {
      _setLoadingState(false);
      _errorMessage = 'Koneksi gagal. Silakan coba kembali.';
      return false;
    }
  }

  void _setLoadingState(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}