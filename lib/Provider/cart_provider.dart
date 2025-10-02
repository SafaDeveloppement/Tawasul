// import 'package:flutter/foundation.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/model/cart_model.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class CartProvider with ChangeNotifier {
//   List<CartItem> _cartItems = [];
//   int? _currentCartId;
//   bool _isLoading = false;
//   String _error = '';

//   // Getters
//   List<CartItem> get cartItems => List.unmodifiable(_cartItems);
//   int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
//   double get totalAmount => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
//   bool get isLoading => _isLoading;
//   bool get isSyncing => _isLoading;
//   String get error => _error;
//   bool get hasError => _error.isNotEmpty;
//   int? get cartId => _currentCartId;
//   bool get isEmpty => _cartItems.isEmpty;

//   /* ------------------------- CART OPERATIONS ------------------------- */

//   // INITIALIZE CART
//   Future<void> initialize() async {
//     try {
//       _setLoading(true);
//       await _loadLocalCart();

//       // If user is authenticated, try to sync with server
//       final token = await _getAuthToken();
//       if (token != null && token.isNotEmpty) {
//         await _tryLoadServerCart();
//       }
//     } catch (e) {
//       print(" Cart initialization warning: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // ADD TO CART - SIMPLIFIED (NO CART ID NEEDED)
//   Future<void> addToCart({
//     required Product product,
//     int quantity = 1,
//     int? productAttributeId,
//   }) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       // Get the correct attribute ID (null for simple products)
//       final attributeId = productAttributeId ?? product.getCartAttributeId();

//       print("➕ Adding to cart - Product: ${product.id}, "
//             "Attribute: ${attributeId ?? 'none'}, Qty: $quantity");

//       // Use simplified API call - no cart ID needed
//       final result = await ApiService.updateCart(
//         idProduct: product.id,
//         idProductAttribute: attributeId, // Can be null for simple products
//         quantity: quantity,
//       );

//       if (result['success'] == true) {
//         // Extract cart ID from response if available (for future operations)
//         if (result['id_cart'] != null) {
//           _currentCartId = result['id_cart'];
//           print(" Cart ID obtained: $_currentCartId");
//         }

//         // Add to local cart
//         _addToLocalCart(product, quantity, attributeId);

//         print(" Product added successfully to cart");
//       } else {
//         throw Exception(result['message'] ?? 'Failed to add to cart');
//       }
//     } catch (e) {
//       _setError('Failed to add to cart: $e');
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // REMOVE FROM CART - SIMPLIFIED
//   Future<void> removeFromCart({
//     required int productId,
//     int? productAttributeId,
//   }) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       print(" Removing from cart - Product: $productId, "
//             "Attribute: ${productAttributeId ?? 'none'}");

//       final result = await ApiService.deleteProductFromCart(
//         idProduct: productId,
//         idProductAttribute: productAttributeId, // Can be null for simple products
//       );

//       if (result['success'] == true) {
//         // Update local cart
//         _removeFromLocalCart(productId, productAttributeId);

//         print(" Product removed successfully");
//       } else {
//         throw Exception(result['message'] ?? 'Failed to remove from cart');
//       }
//     } catch (e) {
//       _setError('Failed to remove from cart: $e');
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // UPDATE QUANTITY - SIMPLIFIED
//   Future<void> updateQuantity({
//     required int productId,
//     int? productAttributeId,
//     required int newQuantity,
//   }) async {
//     try {
//       if (newQuantity <= 0) {
//         await removeFromCart(
//           productId: productId,
//           productAttributeId: productAttributeId,
//         );
//         return;
//       }

//       _setLoading(true);
//       _clearError();

//       print(" Updating quantity - Product: $productId, "
//             "Attribute: ${productAttributeId ?? 'none'}, Qty: $newQuantity");

//       final result = await ApiService.updateCart(
//         idProduct: productId,
//         idProductAttribute: productAttributeId, // Can be null for simple products
//         quantity: newQuantity,
//       );

//       if (result['success'] == true) {
//         _updateLocalQuantity(productId, productAttributeId, newQuantity);
//         print(" Quantity updated successfully");
//       } else {
//         throw Exception(result['message'] ?? 'Failed to update quantity');
//       }
//     } catch (e) {
//       _setError('Failed to update quantity: $e');
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // SYNC CART WITH SERVER
//   Future<void> syncCartWithServer() async {
//     try {
//       _setLoading(true);
//       _clearError();

//       print(" Syncing cart with server...");

//       // If we have a cart ID, refresh from server
//       if (_currentCartId != null) {
//         await _refreshCartFromServer(_currentCartId!);
//       } else {
//         print(" No cart ID available for sync");
//       }
//     } catch (e) {
//       _setError('Cart sync failed: $e');
//       print(" Error in syncCartWithServer: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // REFRESH CART FROM SERVER (for shopping cart page)
//   Future<void> refreshCart() async {
//     if (_currentCartId != null) {
//       await _refreshCartFromServer(_currentCartId!);
//     } else {
//       print(" No cart ID available to refresh");
//     }
//   }

//   /* ------------------------- PRIVATE METHODS ------------------------- */

//   Future<void> _refreshCartFromServer(int cartId) async {
//     try {
//       final result = await ApiService.getProductCart(idCart: cartId);

//       if (result['success'] == true) {
//         await _parseServerCart(result);
//         print(" Cart refreshed from server: ${_cartItems.length} items");
//       } else {
//         throw Exception('Failed to refresh cart: ${result['message']}');
//       }
//     } catch (e) {
//       print(' Could not refresh cart from server: $e');
//     }
//   }

//   Future<void> _parseServerCart(Map<String, dynamic> result) async {
//     final List<dynamic> serverProducts = result['products'] ?? [];

//     // Update cart ID from server response
//     if (result['id_cart'] != null) {
//       _currentCartId = result['id_cart'];
//     }

//     // Clear and rebuild from server data
//     _cartItems.clear();

//     for (final productData in serverProducts) {
//       try {
//         final product = Product.fromCartJson(productData);
//         final attributeId = productData['id_product_attribute'];
//         final quantity = productData['cart_quantity'] ?? 1;

//         final cartItem = CartItem(
//           product: product,
//           quantity: quantity,
//           totalPrice: (productData['total'] ?? product.price * quantity).toDouble(),
//           idProductAttribute: attributeId, // Can be null for simple products
//         );

//         _cartItems.add(cartItem);
//       } catch (e) {
//         print(' Error parsing cart item: $e');
//       }
//     }

//     _saveLocalCart();
//     notifyListeners();
//   }

//   // LOAD CART FROM SERVER (for initialization)
//   Future<void> _tryLoadServerCart() async {
//     try {
//       // Try to get the latest cart from server if we have an ID
//       if (_currentCartId != null) {
//         await _refreshCartFromServer(_currentCartId!);
//       }
//     } catch (e) {
//       print(" Could not load server cart: $e");
//     }
//   }

//   // LOCAL CART HELPERS
//   void _addToLocalCart(Product product, int quantity, int? attributeId) {
//     final existingIndex = _cartItems.indexWhere(
//       (item) => item.product.id == product.id && item.idProductAttribute == attributeId
//     );

//     if (existingIndex != -1) {
//       _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
//         quantity: _cartItems[existingIndex].quantity + quantity,
//       );
//       _cartItems[existingIndex].calculateTotalPrice();
//     } else {
//       _cartItems.add(CartItem(
//         product: product,
//         quantity: quantity,
//         totalPrice: product.price * quantity,
//         idProductAttribute: attributeId, // Can be null for simple products
//       ));
//     }

//     _saveLocalCart();
//     notifyListeners();
//   }

//   void _removeFromLocalCart(int productId, int? attributeId) {
//     _cartItems.removeWhere(
//       (item) => item.product.id == productId && item.idProductAttribute == attributeId
//     );
//     _saveLocalCart();
//     notifyListeners();
//   }

//   void _updateLocalQuantity(int productId, int? attributeId, int newQuantity) {
//     final index = _cartItems.indexWhere(
//       (item) => item.product.id == productId && item.idProductAttribute == attributeId
//     );

//     if (index != -1) {
//       _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
//       _cartItems[index].calculateTotalPrice();
//       _saveLocalCart();
//       notifyListeners();
//     }
//   }

//   /* ------------------------- LOCAL STORAGE ------------------------- */

//   Future<void> _loadLocalCart() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final cartJson = prefs.getString('shopping_cart');

//       if (cartJson != null) {
//         final cartData = json.decode(cartJson);
//         _currentCartId = cartData['cartId'];

//         final items = List<Map<String, dynamic>>.from(cartData['items'] ?? []);
//         _cartItems = items.map((item) => CartItem.fromJson(item)).toList();

//         print(" Cart loaded from local storage: ${_cartItems.length} items");
//         notifyListeners();
//       }
//     } catch (e) {
//       print(' Error loading local cart: $e');
//     }
//   }

//   Future<void> _saveLocalCart() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final cartData = {
//         'cartId': _currentCartId,
//         'items': _cartItems.map((item) => item.toJson()).toList(),
//         'lastUpdated': DateTime.now().toIso8601String(),
//       };

//       await prefs.setString('shopping_cart', json.encode(cartData));
//     } catch (e) {
//       print(' Error saving local cart: $e');
//     }
//   }

//   /* ------------------------- HELPER METHODS ------------------------- */

//   Future<String?> _getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _error = '';
//   }

//   /* ------------------------- PUBLIC METHODS ------------------------- */

//   bool isProductInCart(int productId, [int? attributeId]) {
//     return _cartItems.any(
//       (item) => item.product.id == productId &&
//                 (attributeId == null || item.idProductAttribute == attributeId)
//     );
//   }

//   CartItem? findCartItem(int productId, [int? attributeId]) {
//     try {
//       return _cartItems.firstWhere(
//         (item) => item.product.id == productId &&
//                   (attributeId == null || item.idProductAttribute == attributeId)
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   void clearCart() {
//     _cartItems.clear();
//     _currentCartId = null;
//     _saveLocalCart();
//     notifyListeners();
//   }

//   Future<void> clearLocalStorage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('shopping_cart');
//       _cartItems.clear();
//       _currentCartId = null;
//       notifyListeners();
//       print("🗑 Local cart storage cleared");
//     } catch (e) {
//       print(" Error clearing local cart storage: $e");
//     }
//   }

//   /* ------------------------- USER SESSION MANAGEMENT ------------------------- */

//   Future<void> onUserLogin() async {
//     try {
//       print(" User logged in, syncing cart with server...");
//       await syncCartWithServer();
//     } catch (e) {
//       print(" Error syncing cart after login: $e");
//     }
//   }

//   Future<void> onUserLogout() async {
//     try {
//       print(" User logged out, clearing cart...");
//       clearCart();
//       await clearLocalStorage();
//     } catch (e) {
//       print(" Error clearing cart on logout: $e");
//     }
//   }

//   /* ------------------------- ERROR HANDLING ------------------------- */

//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }

//   void retryLastOperation() async {
//     if (_error.isNotEmpty) {
//       print(" Retrying last operation...");
//       clearError();
//       await syncCartWithServer();
//     }
//   }

//   /* ------------------------- DEBUG METHODS ------------------------- */

//   void printCartDebugInfo() {
//     print("=== CART DEBUG INFO ===");
//     print("Cart ID: $_currentCartId");
//     print("Total Items: $totalItems");
//     print("Total Amount: $totalAmount");
//     print("Items in cart: ${_cartItems.length}");
//     print("Is Loading: $_isLoading");
//     print("Error: $_error");

//     for (final item in _cartItems) {
//       print(
//         "  - ${item.product.name} (Qty: ${item.quantity}, Price: ${item.totalPrice}, Attribute: ${item.idProductAttribute ?? 'none'})",
//       );
//     }
//     print("=======================");
//   }

//   Map<String, dynamic> getCartSummary() {
//     return {
//       'totalItems': totalItems,
//       'totalAmount': totalAmount,
//       'subtotal': totalAmount,
//       'shipping': 0.0,
//       'tax': 0.0,
//       'grandTotal': totalAmount,
//     };
//   }

//   Map<String, dynamic> getProductCartStatus(int productId, [int? attributeId]) {
//     final item = findCartItem(productId, attributeId);
//     return {
//       'inCart': item != null,
//       'quantity': item?.quantity ?? 0,
//       'totalPrice': item?.totalPrice ?? 0.0,
//     };
//   }
// }

// cart_provider.dart
import 'package:flutter/material.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;
  final int? idProductAttribute;
  final String? selectedColor;
  final double totalPrice;

  CartItem({
    required this.product,
    required this.quantity,
    this.idProductAttribute,
    this.selectedColor,
  }) : totalPrice = product.price * quantity;

  Map<String, dynamic> toApiParams() {
    return {
      'id_product': product.id,
      'id_product_attribute': idProductAttribute ?? 0,
      'qty': quantity,
    };
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      idProductAttribute: idProductAttribute,
      selectedColor: selectedColor,
    );
  }
}

class CartResponse {
  final bool success;
  final int idCart;
  final List<Product> products;

  CartResponse({
    required this.success,
    required this.idCart,
    required this.products,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'] ?? false,
      idCart: json['id_cart'] ?? 0,
      products:
          (json['products'] as List? ?? [])
              .map((productJson) => Product.fromCartJson(productJson))
              .toList(),
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  int _idCart = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  List<CartItem> get cartItems => _cartItems;
  int get idCart => _idCart;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isCartEmpty => _cartItems.isEmpty;

  // Key method: Add or Update Cart (handles cart creation)
  Future<void> addToCart({
    required Product product,
    int quantity = 1, // Default quantity = 1
    int? productAttributeId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print(
        '🛒 Adding to cart - Product: ${product.id}, '
        'Attribute: $productAttributeId, Quantity: $quantity',
      );

      final params = {
        'id_product': product.id.toString(),
        'id_product_attribute': (productAttributeId ?? 0).toString(),
        'qty': quantity.toString(),
      };

      // If we have a cart ID, include it (for updating existing cart)
      if (_idCart > 0) {
        params['id_cart'] = _idCart.toString();
        print(' Using existing cart ID: $_idCart');
      } else {
        print(' Creating new cart (no existing cart ID)');
      }

      final response = await ApiService.updateCart(params);

      if (response['success'] == true) {
        // Update cart ID from response (this handles cart creation)
        final newCartId = response['id_cart'];
        if (newCartId != null && newCartId > 0) {
          _idCart = newCartId;
          print(' Cart ID updated: $_idCart');
        }

        // Refresh cart items from API response
        await _refreshCartFromApi();

        print(' Product added to cart successfully');
        notifyListeners();
      } else {
        final errorMsg = response['message'] ?? 'Failed to add product to cart';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print(' Add to cart error: $e');
      _setError('Failed to add product to cart: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Get products from cart (following Postman test)
  Future<void> getProductCart() async {
    try {
      _setLoading(true);
      _clearError();

      if (_idCart == 0) {
        print('🛒 No cart ID available, skipping getProductCart');
        _cartItems = [];
        notifyListeners();
        return;
      }

      print(' Fetching cart products for cart ID: $_idCart');
      final response = await ApiService.getProductCart(_idCart);

      if (response['success'] == true) {
        _idCart = response['id_cart'] ?? _idCart;
        await _refreshCartFromApi();
        print(' Cart products loaded successfully');
      } else {
        final errorMsg = response['message'] ?? 'Failed to load cart';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print(' Get product cart error: $e');
      _setError('Failed to load cart: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Remove product from cart (following Postman test)
  Future<void> removeFromCart({
    required int productId,
    required int productAttributeId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (_idCart == 0) {
        throw Exception('No cart exists to remove from');
      }

      print(
        ' Removing product from cart - '
        'Product: $productId, Attribute: $productAttributeId, Cart: $_idCart',
      );

      final response = await ApiService.deleteProductCart(
        idCart: _idCart,
        productId: productId,
        productAttributeId: productAttributeId,
      );

      if (response['success'] == true) {
        await _refreshCartFromApi();
        print(' Product removed from cart successfully');
        notifyListeners();
      } else {
        final errorMsg =
            response['message'] ?? 'Failed to remove product from cart';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print(' Remove from cart error: $e');
      _setError('Failed to remove product: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update quantity (uses the same updateCart API)
  Future<void> updateQuantity({
    required int productId,
    required int productAttributeId,
    required int newQuantity,
  }) async {
    try {
      _clearError();

      if (newQuantity <= 0) {
        print(' Quantity is 0 or less, removing product from cart');
        await removeFromCart(
          productId: productId,
          productAttributeId: productAttributeId,
        );
        return;
      }

      print(
        ' Updating quantity - '
        'Product: $productId, Attribute: $productAttributeId, New Qty: $newQuantity',
      );

      final params = {
        'id_product': productId.toString(),
        'id_product_attribute': productAttributeId.toString(),
        'qty': newQuantity.toString(),
      };

      if (_idCart > 0) {
        params['id_cart'] = _idCart.toString();
      }

      final response = await ApiService.updateCart(params);

      if (response['success'] == true) {
        _idCart = response['id_cart'] ?? _idCart;
        await _refreshCartFromApi();
        print(' Quantity updated successfully');
        notifyListeners();
      } else {
        final errorMsg = response['message'] ?? 'Failed to update quantity';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print(' Update quantity error: $e');
      _setError('Failed to update quantity: $e');
      rethrow;
    }
  }

  // Refresh cart from API
  Future<void> _refreshCartFromApi() async {
    if (_idCart == 0) {
      _cartItems = [];
      return;
    }

    try {
      final response = await ApiService.getProductCart(_idCart);
      if (response['success'] == true) {
        _idCart = response['id_cart'] ?? _idCart;
        final productsJson = response['products'] as List<dynamic>? ?? [];

        _cartItems =
            productsJson.map((productJson) {
              final product = Product.fromCartJson(productJson);
              return CartItem(
                product: product,
                quantity: product.quantity,
                idProductAttribute: productJson['id_product_attribute'],
                selectedColor: productJson['attributes_small']?.toString(),
              );
            }).toList();

        print(' Cart refreshed - ${_cartItems.length} items in cart');
      } else {
        throw Exception('Failed to refresh cart from API');
      }
    } catch (e) {
      print(' Refresh cart error: $e');
      throw e;
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      _setLoading(true);
      _clearError();

      if (_idCart == 0) {
        _cartItems.clear();
        notifyListeners();
        return;
      }

      print(' Clearing entire cart - Cart ID: $_idCart');

      // Remove all items one by one
      final itemsToRemove = List.from(_cartItems);
      for (final item in itemsToRemove) {
        await removeFromCart(
          productId: item.product.id,
          productAttributeId: item.idProductAttribute ?? 0,
        );
      }

      _cartItems.clear();
      print(' Cart cleared successfully');
      notifyListeners();
    } catch (e) {
      print(' Clear cart error: $e');
      _setError('Failed to clear cart: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Sync cart with server (for checkout)
  Future<void> syncCartWithServer() async {
    try {
      _clearError();
      await getProductCart();
    } catch (e) {
      print(' Sync cart error: $e');
      _setError('Failed to sync cart: $e');
      rethrow;
    }
  }

  // Refresh cart (public method)
  Future<void> refreshCart() async {
    try {
      _clearError();
      if (_idCart > 0) {
        await getProductCart();
      } else {
        print(' No cart ID available for refresh');
      }
    } catch (e) {
      print(' Refresh cart error: $e');
      _setError('Failed to refresh cart: $e');
    }
  }

  // Check if product is in cart
  bool isProductInCart(int productId, [int? productAttributeId]) {
    return _cartItems.any(
      (item) =>
          item.product.id == productId &&
          item.idProductAttribute == (productAttributeId ?? 0),
    );
  }

  // Get quantity of specific product in cart
  int getProductQuantity(int productId, [int? productAttributeId]) {
    final item = _cartItems.firstWhere(
      (item) =>
          item.product.id == productId &&
          item.idProductAttribute == (productAttributeId ?? 0),
      orElse:
          () => CartItem(
            product: Product(name: '', price: 0, image: '', description: ''),
            quantity: 0,
          ),
    );
    return item.quantity;
  }

  // Set cart ID manually (useful for persistence)
  void setCartId(int cartId) {
    if (cartId > 0) {
      _idCart = cartId;
      print(' Manual cart ID set: $_idCart');
      notifyListeners();
    }
  }

  // Clear error state
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Reset cart (logout scenario)
  void resetCart() {
    _cartItems.clear();
    _idCart = 0;
    _errorMessage = '';
    print(' Cart reset completely');
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  // Debug information
  void printDebugInfo() {
    print('=== CART DEBUG INFO ===');
    print('Cart ID: $_idCart');
    print('Total Items: $totalItems');
    print('Total Amount: $totalAmount');
    print('Items in cart: ${_cartItems.length}');
    for (var i = 0; i < _cartItems.length; i++) {
      final item = _cartItems[i];
      print(
        '  $i. ${item.product.name} - Qty: ${item.quantity} - '
        'Attribute: ${item.idProductAttribute} - '
        'Price: ${item.totalPrice}',
      );
    }
    print('Loading: $_isLoading');
    print('Error: $_errorMessage');
    print('========================');
  }
}
