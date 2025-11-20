import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Category> _categories = [];
  bool _loading = false;
  String? _error;

  Future<void> fetchCategories() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _categories = await _api.fetchCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  List<Category> get categories => _categories;
  bool get isLoading => _loading;
  String? get error => _error;
}
