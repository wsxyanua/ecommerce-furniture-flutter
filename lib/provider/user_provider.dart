import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  UserSQ? _currentUser;
  bool _loading = false;
  String? _error;

  Future<void> fetchCurrentUser() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _currentUser = await _api.fetchCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateCurrentUser(UserSQ user) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _api.updateCurrentUser(user);
      if (updated != null) {
        _currentUser = updated;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void signOut() {
    _api.signOut();
    _currentUser = null;
    notifyListeners();
  }

  UserSQ? get currentUser => _currentUser;
  bool get isLoading => _loading;
  String? get error => _error;
}
