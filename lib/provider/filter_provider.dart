import 'package:flutter/cupertino.dart';
import '../models/filter_model.dart';
import '../services/api_service.dart';

class FilterProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  FilterModel? _filter;
  bool _loading = false;
  String? _error;

  Future<void> fetchFilter() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _filter = await _api.fetchFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  FilterModel? get filter => _filter;
  bool get isLoading => _loading;
  String? get error => _error;
}