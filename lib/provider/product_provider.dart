import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _allProducts = [];
  Product? _current;
  bool _loading = false;
  String? _error;

  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final list = await _api.fetchProducts();
      _allProducts = list;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _current = await _api.fetchProductById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  // Placeholder/stub methods for extended product lists (to be backed by API endpoints)
  List<Product> _newArchive = [];
  List<Product> _topSeller = [];
  List<Product> _bestReview = [];
  List<Product> _discount = [];
  List<ProductItem> _currentItems = [];
  List<Review> _currentReviews = [];
  List<Product> _searchResults = [];

  Future<void> fetchNewArchive({int limit = 10}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _newArchive = await _api.fetchNewArrivals(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopSeller({int limit = 10}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _topSeller = await _api.fetchTopSeller(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBestReview({int limit = 10}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _bestReview = await _api.fetchBestReview(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDiscount({int limit = 20}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _discount = await _api.fetchDiscount(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> searchByName(String name, {
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'timestamp',
    String order = 'desc',
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _searchResults = await _api.fetchProducts(
        name: name.isNotEmpty ? name : null,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        order: order,
        limit: 50,
      );
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductItems(String productId) async { /* TODO: implement via API */ }
  
  Future<void> fetchProductReviews(String productId, {int skip = 0, int limit = 20}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _currentReviews = await _api.fetchProductReviews(productId, skip: skip, limit: limit);
    } catch (e) {
      _error = e.toString();
      _currentReviews = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> addReview({
    required String productId,
    String? orderId,
    required double star,
    String? message,
    List<String>? img,
    Map<String, dynamic>? service,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final review = await _api.createReview(
        productId: productId,
        orderId: orderId,
        star: star,
        message: message,
        img: img,
        service: service,
      );
      if (review != null) {
        // Add to current reviews list
        _currentReviews.insert(0, review);
        // Update product review average if we have the current product
        if (_current != null && _current!.id == productId) {
          // Refresh product to get updated review_avg
          await fetchProductById(productId);
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> updateReview({
    required String reviewId,
    double? star,
    String? message,
    List<String>? img,
    Map<String, dynamic>? service,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _api.updateReview(
        reviewId: reviewId,
        star: star,
        message: message,
        img: img,
        service: service,
      );
      if (updated != null) {
        // Update in current reviews list
        final index = _currentReviews.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          _currentReviews[index] = updated;
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> deleteReview(String reviewId, String productId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final success = await _api.deleteReview(reviewId);
      if (success) {
        // Remove from current reviews list
        _currentReviews.removeWhere((r) => r.id == reviewId);
        // Refresh product to get updated review_avg
        if (_current != null && _current!.id == productId) {
          await fetchProductById(productId);
        }
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<Product> get getListProduct => _allProducts;

  List<Product> get getListNewArchiveProduct => _newArchive;

  List<Product> get getListTopSeller => _topSeller;

  List<Product> get getListReview => _bestReview;

  List<Product> get getListDiscount => _discount;

  Product? get getProductCurrent => _current;

  bool get isLoading => _loading;
  String? get error => _error;

  List<ProductItem> get getListProductItem => _currentItems;

  List<Review> get getListReviewProductItem => _currentReviews;

  List<Product> get getListProductByName => _searchResults;

}
