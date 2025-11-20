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

  Future<void> fetchNewArchive() async { /* TODO: implement via API */ }
  Future<void> fetchTopSeller() async { /* TODO: implement via API */ }
  Future<void> fetchBestReview() async { /* TODO: implement via API */ }
  Future<void> fetchDiscount() async { /* TODO: implement via API */ }
  Future<void> searchByName(String name) async { /* TODO: implement via API */ }
  Future<void> fetchProductItems(String productId) async { /* TODO: implement via API */ }
  Future<void> fetchProductReviews(String productId) async { /* TODO: implement via API */ }
  Future<void> addReview(String productId, Review review) async { /* TODO: implement via API */ }

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
