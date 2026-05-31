import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int _daysSinceLastDonation = 62;
  bool _isLoading = false;

  // Nilai stok makro (0.0 sampai 1.0)
  double stockO = 0.25; 
  double stockA = 0.80; 
  double stockB = 0.55; 

  int get daysSinceLastDonation => _daysSinceLastDonation;
  bool get isLoading => _isLoading;
  bool get isEligible => _daysSinceLastDonation >= 60;

  double get progressFraction => (_daysSinceLastDonation / 60).clamp(0.0, 1.0);

  Future<void> refreshData() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 1000));
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}