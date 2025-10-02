
import 'package:flutter/foundation.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/cart_model.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  int? _currentCartId;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isLoading => _isLoading;
  bool get isSyncing => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  int? get cartId => _currentCartId;
  bool get isEmpty => _cartItems.isEmpty;

  /* ------------------------- CART OPERATIONS ------------------------- */

  // INITIALIZE CART
  Future<void> initialize() async {
    try {
      _setLoading(true);
      await _loadLocalCart();
      
      // If user is authenticated, try to sync with server
      final token = await _getAuthToken();
      if (token != null && token.isNotEmpty) {
        await _tryLoadServerCart();
      }
    } catch (e) {
      print(" Cart initialization warning: $e");
    } finally {
      _setLoading(false);
    }
  }

  // ADD TO CART - SIMPLIFIED (NO CART ID NEEDED)
  Future<void> addToCart({
    required Product product,
    int quantity = 1,
    int? productAttributeId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Get the correct attribute ID (null for simple products)
      final attributeId = productAttributeId ?? product.getCartAttributeId();

      print("➕ Adding to cart - Product: ${product.id}, "
            "Attribute: ${attributeId ?? 'none'}, Qty: $quantity");

      // Use simplified API call - no cart ID needed
      final result = await ApiService.updateCart(
        idProduct: product.id,
        idProductAttribute: attributeId, // Can be null for simple products
        quantity: quantity,
      );

      if (result['success'] == true) {
        // Extract cart ID from response if available (for future operations)
        if (result['id_cart'] != null) {
          _currentCartId = result['id_cart'];
          print(" Cart ID obtained: $_currentCartId");
        }

        // Add to local cart
        _addToLocalCart(product, quantity, attributeId);
        
        print(" Product added successfully to cart");
      } else {
        throw Exception(result['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      _setError('Failed to add to cart: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // REMOVE FROM CART - SIMPLIFIED
  Future<void> removeFromCart({
    required int productId,
    int? productAttributeId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print(" Removing from cart - Product: $productId, "
            "Attribute: ${productAttributeId ?? 'none'}");

      final result = await ApiService.deleteProductFromCart(
        idProduct: productId,
        idProductAttribute: productAttributeId, // Can be null for simple products
      );

      if (result['success'] == true) {
        // Update local cart
        _removeFromLocalCart(productId, productAttributeId);
        
        print(" Product removed successfully");
      } else {
        throw Exception(result['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      _setError('Failed to remove from cart: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // UPDATE QUANTITY - SIMPLIFIED
  Future<void> updateQuantity({
    required int productId,
    int? productAttributeId,
    required int newQuantity,
  }) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(
          productId: productId,
          productAttributeId: productAttributeId,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      print(" Updating quantity - Product: $productId, "
            "Attribute: ${productAttributeId ?? 'none'}, Qty: $newQuantity");

      final result = await ApiService.updateCart(
        idProduct: productId,
        idProductAttribute: productAttributeId, // Can be null for simple products
        quantity: newQuantity,
      );

      if (result['success'] == true) {
        _updateLocalQuantity(productId, productAttributeId, newQuantity);
        print(" Quantity updated successfully");
      } else {
        throw Exception(result['message'] ?? 'Failed to update quantity');
      }
    } catch (e) {
      _setError('Failed to update quantity: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // SYNC CART WITH SERVER
  Future<void> syncCartWithServer() async {
    try {
      _setLoading(true);
      _clearError();

      print(" Syncing cart with server...");

      // If we have a cart ID, refresh from server
      if (_currentCartId != null) {
        await _refreshCartFromServer(_currentCartId!);
      } else {
        print(" No cart ID available for sync");
      }
    } catch (e) {
      _setError('Cart sync failed: $e');
      print(" Error in syncCartWithServer: $e");
    } finally {
      _setLoading(false);
    }
  }

  // REFRESH CART FROM SERVER (for shopping cart page)
  Future<void> refreshCart() async {
    if (_currentCartId != null) {
      await _refreshCartFromServer(_currentCartId!);
    } else {
      print(" No cart ID available to refresh");
    }
  }

  /* ------------------------- PRIVATE METHODS ------------------------- */

  Future<void> _refreshCartFromServer(int cartId) async {
    try {
      final result = await ApiService.getProductCart(idCart: cartId);
      
      if (result['success'] == true) {
        await _parseServerCart(result);
        print(" Cart refreshed from server: ${_cartItems.length} items");
      } else {
        throw Exception('Failed to refresh cart: ${result['message']}');
      }
    } catch (e) {
      print(' Could not refresh cart from server: $e');
    }
  }

  Future<void> _parseServerCart(Map<String, dynamic> result) async {
    final List<dynamic> serverProducts = result['products'] ?? [];
    
    // Update cart ID from server response
    if (result['id_cart'] != null) {
      _currentCartId = result['id_cart'];
    }
    
    // Clear and rebuild from server data
    _cartItems.clear();
    
    for (final productData in serverProducts) {
      try {
        final product = Product.fromCartJson(productData);
        final attributeId = productData['id_product_attribute'];
        final quantity = productData['cart_quantity'] ?? 1;
        
        final cartItem = CartItem(
          product: product,
          quantity: quantity,
          totalPrice: (productData['total'] ?? product.price * quantity).toDouble(),
          idProductAttribute: attributeId, // Can be null for simple products
        );
        
        _cartItems.add(cartItem);
      } catch (e) {
        print(' Error parsing cart item: $e');
      }
    }
    
    _saveLocalCart();
    notifyListeners();
  }

  // LOAD CART FROM SERVER (for initialization)
  Future<void> _tryLoadServerCart() async {
    try {
      // Try to get the latest cart from server if we have an ID
      if (_currentCartId != null) {
        await _refreshCartFromServer(_currentCartId!);
      }
    } catch (e) {
      print(" Could not load server cart: $e");
    }
  }

  // LOCAL CART HELPERS
  void _addToLocalCart(Product product, int quantity, int? attributeId) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.idProductAttribute == attributeId
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
      _cartItems[existingIndex].calculateTotalPrice();
    } else {
      _cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        totalPrice: product.price * quantity,
        idProductAttribute: attributeId, // Can be null for simple products
      ));
    }
    
    _saveLocalCart();
    notifyListeners();
  }

  void _removeFromLocalCart(int productId, int? attributeId) {
    _cartItems.removeWhere(
      (item) => item.product.id == productId && item.idProductAttribute == attributeId
    );
    _saveLocalCart();
    notifyListeners();
  }

  void _updateLocalQuantity(int productId, int? attributeId, int newQuantity) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId && item.idProductAttribute == attributeId
    );
    
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      _cartItems[index].calculateTotalPrice();
      _saveLocalCart();
      notifyListeners();
    }
  }

  /* ------------------------- LOCAL STORAGE ------------------------- */

  Future<void> _loadLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('shopping_cart');
      
      if (cartJson != null) {
        final cartData = json.decode(cartJson);
        _currentCartId = cartData['cartId'];
        
        final items = List<Map<String, dynamic>>.from(cartData['items'] ?? []);
        _cartItems = items.map((item) => CartItem.fromJson(item)).toList();
        
        print(" Cart loaded from local storage: ${_cartItems.length} items");
        notifyListeners();
      }
    } catch (e) {
      print(' Error loading local cart: $e');
    }
  }

  Future<void> _saveLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = {
        'cartId': _currentCartId,
        'items': _cartItems.map((item) => item.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString('shopping_cart', json.encode(cartData));
    } catch (e) {
      print(' Error saving local cart: $e');
    }
  }

  /* ------------------------- HELPER METHODS ------------------------- */

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = '';
  }

  /* ------------------------- PUBLIC METHODS ------------------------- */

  bool isProductInCart(int productId, [int? attributeId]) {
    return _cartItems.any(
      (item) => item.product.id == productId && 
                (attributeId == null || item.idProductAttribute == attributeId)
    );
  }

  CartItem? findCartItem(int productId, [int? attributeId]) {
    try {
      return _cartItems.firstWhere(
        (item) => item.product.id == productId && 
                  (attributeId == null || item.idProductAttribute == attributeId)
      );
    } catch (e) {
      return null;
    }
  }

  void clearCart() {
    _cartItems.clear();
    _currentCartId = null;
    _saveLocalCart();
    notifyListeners();
  }

  Future<void> clearLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('shopping_cart');
      _cartItems.clear();
      _currentCartId = null;
      notifyListeners();
      print("🗑 Local cart storage cleared");
    } catch (e) {
      print(" Error clearing local cart storage: $e");
    }
  }

  /* ------------------------- USER SESSION MANAGEMENT ------------------------- */

  Future<void> onUserLogin() async {
    try {
      print(" User logged in, syncing cart with server...");
      await syncCartWithServer();
    } catch (e) {
      print(" Error syncing cart after login: $e");
    }
  }

  Future<void> onUserLogout() async {
    try {
      print(" User logged out, clearing cart...");
      clearCart();
      await clearLocalStorage();
    } catch (e) {
      print(" Error clearing cart on logout: $e");
    }
  }

  /* ------------------------- ERROR HANDLING ------------------------- */

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void retryLastOperation() async {
    if (_error.isNotEmpty) {
      print(" Retrying last operation...");
      clearError();
      await syncCartWithServer();
    }
  }

  /* ------------------------- DEBUG METHODS ------------------------- */

  void printCartDebugInfo() {
    print("=== CART DEBUG INFO ===");
    print("Cart ID: $_currentCartId");
    print("Total Items: $totalItems");
    print("Total Amount: $totalAmount");
    print("Items in cart: ${_cartItems.length}");
    print("Is Loading: $_isLoading");
    print("Error: $_error");

    for (final item in _cartItems) {
      print(
        "  - ${item.product.name} (Qty: ${item.quantity}, Price: ${item.totalPrice}, Attribute: ${item.idProductAttribute ?? 'none'})",
      );
    }
    print("=======================");
  }

  Map<String, dynamic> getCartSummary() {
    return {
      'totalItems': totalItems,
      'totalAmount': totalAmount,
      'subtotal': totalAmount,
      'shipping': 0.0,
      'tax': 0.0,
      'grandTotal': totalAmount,
    };
  }

  Map<String, dynamic> getProductCartStatus(int productId, [int? attributeId]) {
    final item = findCartItem(productId, attributeId);
    return {
      'inCart': item != null,
      'quantity': item?.quantity ?? 0,
      'totalPrice': item?.totalPrice ?? 0.0,
    };
  }
}