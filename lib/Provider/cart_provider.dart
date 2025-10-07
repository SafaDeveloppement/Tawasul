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
    int quantity = 1,
    String? productAttributeId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print(
        ' Adding to cart - Product: ${product.id}, '
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

      final response = await ApiService.updateCart({
        'id_product': product.id.toString(),
        'id_product_attribute': (productAttributeId ?? 0).toString(),
        'qty': quantity.toString(),
      });

      if (response['success'] == true) {
        final newCartId = response['id_cart'];
        if (newCartId != null && newCartId > 0) {
          _idCart = newCartId;
          print(' Cart ID updated: $_idCart');
        }
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
