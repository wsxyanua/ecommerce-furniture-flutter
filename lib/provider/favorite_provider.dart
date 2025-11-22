import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../services/api_service.dart';
import '../services/DatabaseHandler.dart';

class FavoriteProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  final DatabaseHandler _dbHandler = DatabaseHandler();

  List<Favorite> _favorites = [];
  bool _loading = false;
  String? _error;
  bool _synced = false;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _loading;
  String? get error => _error;
  int get favoriteCount => _favorites.length;

  bool isFavorite(String productId) {
    return _favorites.any((f) => f.idProduct == productId);
  }

  Future<void> init() async {
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final apiFavorites = await _api.fetchFavorites();
      _favorites = apiFavorites;
      _synced = true;
      
      // Update local cache
      await _syncToLocal();
    } catch (e) {
      // Fallback to local
      await _dbHandler.retrieveFavorites();
      _favorites = _dbHandler.listFavorite;
      _synced = false;
      _error = 'Offline mode - data will sync when online';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite(Favorite favorite) async {
    final isFav = isFavorite(favorite.idProduct);
    
    if (isFav) {
      return await removeFavorite(favorite);
    } else {
      return await addFavorite(favorite);
    }
  }

  Future<bool> addFavorite(Favorite favorite) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final added = await _api.addFavorite(favorite);
      if (added != null) {
        _favorites.add(added);
        
        // Sync to local
        await _dbHandler.insertFavorite(added);
        _synced = true;
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to local
      _error = 'Added to favorites offline - will sync later';
      await _dbHandler.insertFavorite(favorite);
      await _dbHandler.retrieveFavorites();
      _favorites = _dbHandler.listFavorite;
      _synced = false;
      return true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFavorite(Favorite favorite) async {
    if (favorite.idFavorite == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final success = await _api.removeFavorite(favorite.idFavorite!);
      if (success) {
        _favorites.removeWhere((f) => f.idFavorite == favorite.idFavorite);
        
        // Remove from local
        await _dbHandler.deleteFavorite(favorite.idFavorite!);
        _synced = true;
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to local
      _error = 'Removed offline - will sync later';
      await _dbHandler.deleteFavorite(favorite.idFavorite!);
      _favorites.removeWhere((f) => f.idFavorite == favorite.idFavorite);
      _synced = false;
      return true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> clearFavorites() async {
    _loading = true;
    notifyListeners();

    try {
      // Remove all from API
      for (final fav in _favorites) {
        if (fav.idFavorite != null) {
          await _api.removeFavorite(fav.idFavorite!);
        }
      }
      
      // Clear local
      for (final fav in _favorites) {
        if (fav.idFavorite != null) {
          await _dbHandler.deleteFavorite(fav.idFavorite!);
        }
      }
      
      _favorites.clear();
      _synced = true;
    } catch (e) {
      _error = 'Failed to clear favorites';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> syncToServer() async {
    if (_synced) return;

    try {
      await loadFavorites();
    } catch (e) {
      _error = 'Sync failed - will retry later';
    }
  }

  Future<void> _syncToLocal() async {
    // Update local database with server data
    for (final fav in _favorites) {
      if (fav.idFavorite != null) {
        await _dbHandler.insertFavorite(fav);
      }
    }
  }
}
