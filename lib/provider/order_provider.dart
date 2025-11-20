import 'package:flutter/cupertino.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<OrderModel> _orders = [];
  bool _loading = false;
  String? _error;
  bool _createSuccess = false;

  Future<void> fetchOrders() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _orders = await _api.fetchOrders();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> createOrder(OrderModel order) async {
    _loading = true; _error = null; _createSuccess = false; notifyListeners();
    try {
      final id = await _api.createOrder(order);
      _createSuccess = id != null;
      if (_createSuccess) {
        await fetchOrders();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  List<OrderModel> get orders => _orders;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get createSuccess => _createSuccess;
}