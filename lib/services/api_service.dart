import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/filter_model.dart';
import '../models/order_model.dart';

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
  Future<List<Product>> fetchProducts({int skip = 0, int limit = 20}) async {
    final res = await _dio.get('/products', queryParameters: {'skip': skip, 'limit': limit});
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
  Future<List<Banner1>> fetchBanners() async {
    final res = await _dio.get('/banners');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e)=> Banner1.fromJson(e as Map<String,dynamic>)).toList();
    }
    return [];
  }

  // CATEGORIES
  Future<List<Category>> fetchCategories() async {
    final res = await _dio.get('/categories');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e)=> Category.fromJson(e as Map<String,dynamic>)).toList();
    }
    return [];
  }

  // FILTER (assume single filter config)
  Future<FilterModel?> fetchFilter() async {
    final res = await _dio.get('/filters');
    if (res.statusCode == 200) {
      if (res.data is List) {
        final list = res.data as List;
        if (list.isNotEmpty) {
          return FilterModel.fromJson(list.first as Map<String,dynamic>);
        }
      } else if (res.data is Map<String,dynamic>) {
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
}