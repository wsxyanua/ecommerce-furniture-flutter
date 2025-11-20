import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../services/api_service.dart';

class BannerProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Banner1> _banners = [];
  bool _loading = false;
  String? _error;

  Future<void> fetchBanners() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _banners = await _api.fetchBanners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  List<Banner1> get banners => _banners;
  bool get isLoading => _loading;
  String? get error => _error;
}
