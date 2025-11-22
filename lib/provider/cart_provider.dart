import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../services/DatabaseHandler.dart';

class CartProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  final DatabaseHandler _dbHandler = DatabaseHandler();

  List<Cart> _cartItems = [];
  bool _loading = false;
  String? _error;
  bool _synced = false;

  List<Cart> get cartItems => _cartItems;
  bool get isLoading => _loading;
  String? get error => _error;
  int get cartCount => _cartItems.length;
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> init() async {
    await loadCart();
  }

  Future<void> loadCart() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to fetch from API first
      final apiCart = await _api.fetchCart();
      _cartItems = apiCart;
      _synced = true;
      
      // Update local cache
      await _syncToLocal();
    } catch (e) {
      // Fallback to local SQLite if API fails
      await _dbHandler.retrieveCarts();
      _cartItems = _dbHandler.listCart;
      _synced = false;
      _error = 'Offline mode - data will sync when online';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(Cart cart) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final addedCart = await _api.addToCart(cart);
      if (addedCart != null) {
        // Check if item exists, update quantity
        final existingIndex = _cartItems.indexWhere((c) => c.idProduct == cart.idProduct && c.color == cart.color);
        if (existingIndex != -1) {
          _cartItems[existingIndex] = Cart(
            idCart: addedCart.idCart,
            imgProduct: addedCart.imgProduct,
            nameProduct: addedCart.nameProduct,
            color: addedCart.color,
            quantity: _cartItems[existingIndex].quantity + cart.quantity,
            idProduct: addedCart.idProduct,
            price: addedCart.price,
          );
        } else {
          _cartItems.add(addedCart);
        }
        
        // Sync to local
        await _dbHandler.insertCart(addedCart);
        _synced = true;
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to local
      _error = 'Added to cart offline - will sync later';
      await _dbHandler.insertCart(cart);
      await _dbHandler.retrieveCarts();
      _cartItems = _dbHandler.listCart;
      _synced = false;
      return true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromCart(Cart cart) async {
    if (cart.idCart == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final success = await _api.removeFromCart(cart.idCart!);
      if (success) {
        _cartItems.removeWhere((c) => c.idCart == cart.idCart);
        
        // Remove from local
        await _dbHandler.deleteCart(cart.idCart!);
        _synced = true;
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to local
      _error = 'Removed offline - will sync later';
      await _dbHandler.deleteCart(cart.idCart!);
      _cartItems.removeWhere((c) => c.idCart == cart.idCart);
      _synced = false;
      return true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity(Cart cart, int newQuantity) async {
    if (cart.idCart == null) return false;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API first
      final updatedCart = await _api.updateCartQuantity(cart.idCart!, newQuantity);
      if (updatedCart != null) {
        final index = _cartItems.indexWhere((c) => c.idCart == cart.idCart);
        if (index != -1) {
          _cartItems[index] = updatedCart;
        }
        
        // Update local
        await _dbHandler.updateCart(cart.idCart!, newQuantity);
        _synced = true;
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to local
      _error = 'Updated offline - will sync later';
      await _dbHandler.updateCart(cart.idCart!, newQuantity);
      final index = _cartItems.indexWhere((c) => c.idCart == cart.idCart);
      if (index != -1) {
        _cartItems[index] = Cart(
          idCart: cart.idCart,
          imgProduct: cart.imgProduct,
          nameProduct: cart.nameProduct,
          color: cart.color,
          quantity: newQuantity,
          idProduct: cart.idProduct,
          price: cart.price,
        );
      }
      _synced = false;
      return true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _loading = true;
    notifyListeners();

    try {
      // Remove all from API
      for (final cart in _cartItems) {
        if (cart.idCart != null) {
          await _api.removeFromCart(cart.idCart!);
        }
      }
      
      // Clear local
      for (final cart in _cartItems) {
        if (cart.idCart != null) {
          await _dbHandler.deleteCart(cart.idCart!);
        }
      }
      
      _cartItems.clear();
      _synced = true;
    } catch (e) {
      _error = 'Failed to clear cart';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> syncToServer() async {
    if (_synced) return;

    try {
      await loadCart();
    } catch (e) {
      _error = 'Sync failed - will retry later';
    }
  }

  Future<void> _syncToLocal() async {
    // Update local database with server data
    for (final cart in _cartItems) {
      if (cart.idCart != null) {
        await _dbHandler.insertCart(cart);
      }
    }
  }
}
