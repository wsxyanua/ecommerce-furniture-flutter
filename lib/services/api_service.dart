import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/filter_model.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  String? _token;

  void setToken(String? token) {
    _token = token;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  // PRODUCTS
  Future<List<Product>> fetchProducts({
    int skip = 0,
    int limit = 20,
    String? name,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'timestamp',
    String order = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    
    if (name != null) queryParams['name'] = name;
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    queryParams['sort_by'] = sortBy;
    queryParams['order'] = order;
    
    final res = await _dio.get('/products', queryParameters: queryParams);
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Product?> fetchProductById(String id) async {
    final res = await _dio.get('/products/$id');
    if (res.statusCode == 200) {
      return Product.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Product>> fetchNewArrivals({int limit = 10}) async {
    final res = await _dio.get('/products/special/new-arrivals', queryParameters: {'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Product>> fetchTopSeller({int limit = 10}) async {
    final res = await _dio.get('/products/special/top-seller', queryParameters: {'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Product>> fetchBestReview({int limit = 10}) async {
    final res = await _dio.get('/products/special/best-review', queryParameters: {'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Product>> fetchDiscount({int limit = 20}) async {
    final res = await _dio.get('/products/special/discount', queryParameters: {'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // USERS
  Future<UserSQ?> fetchCurrentUser() async {
    final res = await _dio.get('/users/me');
    if (res.statusCode == 200) {
      return UserSQ.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<UserSQ?> updateCurrentUser(UserSQ user) async {
    final res = await _dio.put('/users/me', data: jsonEncode({
      'full_name': user.fullName,
      'address': user.address,
      'img': user.img,
      'birth_date': user.birthDate,
      'gender': user.gender,
    }));
    if (res.statusCode == 200) {
      return UserSQ.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  // AUTH
  Future<String?> login({String? email, String? phone, required String password}) async {
    final payload = {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'password': password,
    };
    final res = await _dio.post('/auth/login', data: jsonEncode(payload));
    if (res.statusCode == 200) {
      final token = res.data['access_token'] as String?;
      setToken(token);
      return token;
    }
    return null;
  }

  Future<String?> register({String? email, String? phone, String? fullName, required String password}) async {
    final payload = {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (fullName != null) 'full_name': fullName,
      'password': password,
    };
    final res = await _dio.post('/auth/register', data: jsonEncode(payload));
    if (res.statusCode == 200) {
      final token = res.data['access_token'] as String?;
      setToken(token);
      return token;
    }
    return null;
  }

  // ORDERS
  Future<List<OrderModel>> fetchOrders() async {
    final res = await _dio.get('/orders');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) {
        // each element: { order: {...}, items: [...] }
        final map = e as Map<String, dynamic>;
        final orderData = map['order'] as Map<String, dynamic>;
        orderData['items'] = map['items'];
        return OrderModel.fromJson(orderData);
      }).toList();
    }
    return [];
  }

  Future<String?> createOrder(OrderModel order) async {
    final res = await _dio.post('/orders', data: jsonEncode({
      'full_name': order.fullName,
      'address': order.address,
      'city': order.city,
      'country': order.country,
      'phone': order.phone,
      'payment_method': order.paymentMethod,
      'sub_total': order.subTotal,
      'total_order': order.totalOrder,
      'vat': order.vat,
      'delivery_fee': order.deliveryFee,
      'note': order.note,
      'items': order.cartList.map((e) => e.toJson()).toList(),
    }));
    if (res.statusCode == 200) {
      return res.data['order_id'] as String?;
    }
    return null;
  }

  void signOut() {
    setToken(null);
  }

  // BANNERS
  Future<List<Banner1>> fetchBanners({int skip = 0, int limit = 50, String? status}) async {
    final queryParams = <String, dynamic>{'skip': skip, 'limit': limit};
    if (status != null) queryParams['status'] = status;
    
    final res = await _dio.get('/banners', queryParameters: queryParams);
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e)=> Banner1.fromJson(e as Map<String,dynamic>)).toList();
    }
    return [];
  }

  // CATEGORIES
  Future<List<Category>> fetchCategories({int skip = 0, int limit = 100}) async {
    final res = await _dio.get('/categories', queryParameters: {'skip': skip, 'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e)=> Category.fromJson(e as Map<String,dynamic>)).toList();
    }
    return [];
  }

  // FILTER (assume single filter config)
  Future<FilterModel?> fetchFilter({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    
    final res = await _dio.get('/filters', queryParameters: queryParams);
    if (res.statusCode == 200) {
      if (res.data is Map<String,dynamic>) {
        return FilterModel.fromJson(res.data as Map<String,dynamic>);
      }
    }
    return null;
  }

  // COUNTRIES
  Future<List<Country>> fetchCountries() async {
    final res = await _dio.get('/countries');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e){
        final m = e as Map<String,dynamic>;
        return Country(name: m['name'] ?? '', id: m['id'] ?? '', city: (m['city'] as List?)?.map((e)=> e.toString()).toList() ?? []);
      }).toList();
    }
    return [];
  }

  // CART
  Future<List<Cart>> fetchCart() async {
    final res = await _dio.get('/cart');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Cart.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Cart?> addToCart(Cart item) async {
    final res = await _dio.post('/cart', data: jsonEncode({
      'product_id': item.idProduct,
      'name': item.nameProduct,
      'img': item.imgProduct,
      'color': item.color,
      'quantity': item.quantity,
      'price': item.price,
    }));
    if (res.statusCode == 200) {
      return Cart.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> removeFromCart(int itemId) async {
    final res = await _dio.delete('/cart/$itemId');
    return res.statusCode == 200;
  }

  Future<Cart?> updateCartQuantity(int itemId, int quantity) async {
    final res = await _dio.patch('/cart/$itemId', data: jsonEncode({'quantity': quantity}));
    if (res.statusCode == 200) {
      return Cart.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  // FAVORITES
  Future<List<Favorite>> fetchFavorites() async {
    final res = await _dio.get('/favorites');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Favorite.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Favorite?> addFavorite(Favorite item) async {
    final res = await _dio.post('/favorites', data: jsonEncode({
      'product_id': item.idProduct,
      'name': item.nameProduct,
      'img': item.imgProduct,
      'price': item.price.toString(),
    }));
    if (res.statusCode == 200) {
      return Favorite.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> removeFavorite(int itemId) async {
    final res = await _dio.delete('/favorites/$itemId');
    return res.statusCode == 200;
  }

  // REVIEWS
  Future<List<Review>> fetchProductReviews(String productId, {int skip = 0, int limit = 20, String sortBy = 'created_at', String order = 'desc'}) async {
    final res = await _dio.get('/products/$productId/reviews', queryParameters: {
      'skip': skip,
      'limit': limit,
      'sort_by': sortBy,
      'order': order,
    });
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Review?> createReview({
    required String productId,
    String? orderId,
    required double star,
    String? message,
    List<String>? img,
    Map<String, dynamic>? service,
  }) async {
    final payload = {
      'product_id': productId,
      if (orderId != null) 'order_id': orderId,
      'star': star,
      if (message != null) 'message': message,
      if (img != null) 'img': img,
      if (service != null) 'service': service,
    };
    final res = await _dio.post('/products/$productId/reviews', data: jsonEncode(payload));
    if (res.statusCode == 201) {
      return Review.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<Review?> updateReview({
    required String reviewId,
    double? star,
    String? message,
    List<String>? img,
    Map<String, dynamic>? service,
  }) async {
    final payload = {
      if (star != null) 'star': star,
      if (message != null) 'message': message,
      if (img != null) 'img': img,
      if (service != null) 'service': service,
    };
    final res = await _dio.patch('/reviews/$reviewId', data: jsonEncode(payload));
    if (res.statusCode == 200) {
      return Review.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> deleteReview(String reviewId) async {
    final res = await _dio.delete('/reviews/$reviewId');
    return res.statusCode == 204;
  }

  Future<List<Review>> fetchMyReviews({int skip = 0, int limit = 20}) async {
    final res = await _dio.get('/users/me/reviews', queryParameters: {'skip': skip, 'limit': limit});
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}