import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/controller/cart_controller.dart';
import 'package:tawasul_application/model/cart_model.dart';
import 'package:tawasul_application/model/product_model.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _cartItems = [];
  String? _currentCartId;
  bool _isLoading = false;
  double _totalPrice = 0.0;
  String? selectedColor;

  List<Cart> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get currentCartId => _currentCartId;
  double get totalPrice => _totalPrice;

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get hasItems => _cartItems.isNotEmpty;

  Future<void> initializeCart() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      print(" ===== INITIALIZING CART =====");

      // Step 1: Try to get stored cart ID
      _currentCartId = (await CartManager.getCurrentCartId()) as String?;
      print(" Step 1 - Stored cart ID: '$_currentCartId'");

      // Step 2: If we have a valid cart ID, load its items
      if (_currentCartId != null &&
          _currentCartId!.isNotEmpty &&
          _currentCartId != "0") {
        print(" Step 2 - Loading existing cart: $_currentCartId");
        await loadCartItems();
      } else {
        print(" Step 2 - No existing cart found");
        // Cart will be created when first product is added
        _cartItems.clear();
        _totalPrice = 0.0;
      }
    } catch (e) {
      print(" Cart initialization error: $e");
      // Initialize with empty cart on error
      _cartItems.clear();
      _totalPrice = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
      debugCartState();
    }
  }

  Future<void> _createNewCart() async {
    try {
      // Create cart by adding a product (most APIs create cart on first add)
      final success = await ApiService.addToCart(
        cartId: null, // This should trigger cart creation
        productId: '1', // Use a valid default product ID
        quantity: 0, // Add 0 quantity just to create cart
        productAttributeId: '0',
      );

      if (success == true) {
        // Now try to get the cart ID
        await _fetchCurrentCartId();
      }
    } catch (e) {
      print(" Create new cart error: $e");
    }
  }

  void debugCartState() {
    print(" === CART STATE DEBUG ===");
    print(" Cart ID: '$_currentCartId'");
    print(" Items Count: ${_cartItems.length}");
    print(" Total Price: $_totalPrice");
    print(" Is Loading: $_isLoading");

    if (_cartItems.isNotEmpty) {
      print(" Cart Items:");
      for (int i = 0; i < _cartItems.length; i++) {
        final item = _cartItems[i];
        print(
          "  $i: ${item.productName} x${item.quantity} (ID: ${item.idProduct})",
        );
      }
    } else {
      print(" Cart is empty");
    }
    print(" === END CART DEBUG ===");
  }

  // LOAD CART ITEMS - Main method to get cart by ID
  Future<void> loadCartItems() async {
    // if (_currentCartId == null ||
    //     _currentCartId!.isEmpty ||
    //     _currentCartId == "0") {
    //   print(" No valid cart ID to load items");
    //   _cartItems.clear();
    //   _totalPrice = 0.0;
    //   notifyListeners();
    //   return;
    // }

    _isLoading = true;
    notifyListeners();

    // try {
    //   //print(" Loading cart items for cart ID: $_currentCartId");

    //   final cartResponse = await ApiService.getCartById("");
    //   //_currentCartId!

    //   if (cartResponse.success) {
    //     _cartItems = cartResponse.products;
    //     _totalPrice = cartResponse.totalPrice;
    //     print(" Cart items loaded successfully:");
    //     print("   - Cart ID: ${cartResponse.idCart}");
    //     print("   - Items count: ${_cartItems.length}");
    //     print("   - Total price: $_totalPrice");
    //     print("   - Total items: $totalItems");

    //     for (var item in _cartItems) {
    //       print(
    //         "   ${item.productName} x${item.quantity} - LYD ${item.totalPrice}",
    //       );
    //     }
    //   } else {
    //     print(" Failed to load cart items - cart might be empty");
    //     _cartItems.clear();
    //     _totalPrice = 0.0;
    //   }
    // } catch (e) {
    //   print(" Load cart items error: $e");
    // } finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  void _handleEmptyCart() {
    _cartItems.clear();
    _totalPrice = 0.0;
    // _currentCartId = null;
    CartManager.clearCartId();
  }

  //ADD TO CART - Complete method with cart creation logic
  // Future<bool> addToCart({
  //   required Product product,
  //   required int quantity,
  //   String? productAttributeId,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     print(" Starting add to cart process...");

  //     final String? cartIdToUse =
  //         (_currentCartId == null ||
  //                 _currentCartId!.isEmpty ||
  //                 _currentCartId == "0")
  //             ? null
  //             : _currentCartId;

  //     print(" Cart ID to use: ${cartIdToUse ?? 'NULL (will create new cart)'}");

  //     final success = await ApiService.addToCart(
  //       cartId: cartIdToUse,
  //       productId: product.idProduct.toString(),
  //       quantity: quantity,
  //       productAttributeId: productAttributeId,
  //     );

  //     if (success == true) {
  //       if (_currentCartId == null ||
  //           _currentCartId!.isEmpty ||
  //           _currentCartId == "0") {
  //         await _fetchCurrentCartId();
  //       }
  //       await loadCartItems();
  //       print(" Product added to cart successfully!");
  //       return true;
  //     } else {
  //       throw Exception('Failed to add product to cart');
  //     }
  //   } catch (e) {
  //     print(" Add to cart error: $e");
  //     rethrow;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // ADD TO CART
  Future<bool> addToCart({
    required Product product,
    required int quantity,
    String? productAttributeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      print(" Starting add to cart process...");

      final String? cartIdToUse =
          (_currentCartId == null ||
                  _currentCartId!.isEmpty ||
                  _currentCartId == "0")
              ? null
              : _currentCartId;

      print(" Cart ID to use: ${cartIdToUse ?? 'NULL (will create new cart)'}");

      final result = await ApiService.addToCart(
        cartId: cartIdToUse,
        productId: product.idProduct.toString(),
        quantity: quantity,
        productAttributeId: productAttributeId.toString(),
      );

      if (result['success'] == true) {
        // Extract cart ID from the response if we didn't have one
        // if ((_currentCartId == null ||
        //         _currentCartId!.isEmpty ||
        //         _currentCartId == "0") &&
        //     result['id_cart'] != null) {
        //   _currentCartId = result['id_cart'].toString();
        //   await CartManager.saveCartId(_currentCartId!);
        //   print(" New cart ID saved: $_currentCartId");
        // }

        // Refresh cart items
        await loadCartItems();

        print(" Product added to cart successfully!");
        return true;
      } else {
        throw Exception(result['message'] ?? 'Failed to add product to cart');
      }
    } catch (e) {
      print(" Add to cart error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Future<bool> addToCart({
  //   required Product product,
  //   required int quantity,
  //   String? productAttributeId,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     print(" Starting add to cart process...");

  //     final String? cartIdToUse =
  //         (_currentCartId == null ||
  //                 _currentCartId!.isEmpty ||
  //                 _currentCartId == "0")
  //             ? null
  //             : _currentCartId;

  //     print(" Cart ID to use: ${cartIdToUse ?? 'NULL (will create new cart)'}");

  //     final success = await ApiService.addToCart(
  //       cartId: cartIdToUse,
  //       productId: product.idProduct.toString(),
  //       quantity: quantity,
  //       productAttributeId: productAttributeId,
  //     );

  //     if (success) {
  //       // If we didn't have a cart ID before, fetch it now
  //       if (_currentCartId == null ||
  //           _currentCartId!.isEmpty ||
  //           _currentCartId == "0") {
  //         await _fetchCurrentCartId();
  //       } else {
  //         // Refresh cart items
  //         await loadCartItems();
  //       }

  //       print(" Product added to cart successfully!");
  //       return true;
  //     } else {
  //       throw Exception('Failed to add product to cart');
  //     }
  //   } catch (e) {
  //     print(" Add to cart error: $e");
  //     rethrow;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> _fetchCurrentCartId() async {
  //   try {
  //     print(" Fetching current cart ID...");

  //     // Try to get cart using the getproductcart endpoint
  //     final response = await http.get(
  //       Uri.parse('${ApiService.baseUrl}/public/getproductcart'),
  //       headers: {'Accept': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['success'] == true && data['id_cart'] != null) {
  //         _currentCartId = data['id_cart'].toString();
  //         await CartManager.saveCartId(_currentCartId!);
  //         print(" Cart ID fetched and saved: $_currentCartId");

  //         // Load items for the new cart
  //         await loadCartItems();
  //       } else {
  //         print(" No cart ID found in response");
  //       }
  //     }
  //   } catch (e) {
  //     print(" Fetch cart ID error: $e");
  //   }
  // }
  Future<void> _fetchCurrentCartId() async {
    try {
      print(" Fetching current cart ID...");

      // Use getproductcart endpoint to get current cart
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/public/getproductcart'),
        headers: {'Accept': 'application/json'},
      );

      print(" Get cart response status: ${response.statusCode}");
      print(" Get cart response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(" Parsed response data: $data");

        if (data['success'] == true && data['id_cart'] != null) {
          _currentCartId = data['id_cart'].toString();
          //await CartManager.saveCartId(_currentCartId!);
          print(" Cart ID fetched and saved: $_currentCartId");

          // Load items for the new cart
          await loadCartItems();
        } else {
          print(" No cart ID found in response");
          print("   - Success: ${data['success']}");
          print("   - id_cart: ${data['id_cart']}");
        }
      } else {
        print(" HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print(" Fetch cart ID error: $e");
    }
  }

  Future<bool> removeFromCart({
    required String productId,
    required String attributeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_currentCartId != null) {
        final success = await ApiService.addToCart(
          cartId: _currentCartId!,
          productId: productId,
          quantity: 0, // Set quantity to 0 to remove
          productAttributeId: attributeId,
        );

        if (success == true) {
          await loadCartItems();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(" Remove from cart error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity({
    required String productId,
    required String attributeId,
    required int newQuantity,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_currentCartId != null) {
        final success = await ApiService.addToCart(
          cartId: _currentCartId!,
          productId: productId,
          quantity: newQuantity,
          productAttributeId: attributeId,
        );

        if (success == true) {
          await loadCartItems();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(" Update quantity error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncCartWithServer() async {
    if (_currentCartId != null &&
        _currentCartId!.isNotEmpty &&
        _currentCartId != "0") {
      await loadCartItems();
    }
  }
}






// Future<void> initializeCart() async {
  //   if (_isLoading) return;

  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     print(" ===== INITIALIZING CART =====");

  //     // Step 1: Try to get stored cart ID
  //     _currentCartId = await CartManager.getCurrentCartId();
  //     print(" Step 1 - Stored cart ID: '$_currentCartId'");

  //     // Step 2: If we have a valid cart ID, try to load it
  //     if (_currentCartId != null &&
  //         _currentCartId!.isNotEmpty &&
  //         _currentCartId != "0") {
  //       print(" Step 2 - Loading existing cart: $_currentCartId");
  //       await loadCartItems();

  //       if (_cartItems.isNotEmpty) {
  //         print(
  //           " Step 2a - Cart loaded successfully with ${_cartItems.length} items",
  //         );
  //         return;
  //       } else {
  //         print(" Step 2b - Cart ID exists but no items found");
  //         // Don't clear the cart ID yet - it might be a valid empty cart
  //       }
  //     }

  //     // Step 3: Create new cart if none exists
  //     if (_currentCartId == null ||
  //         _currentCartId!.isEmpty ||
  //         _currentCartId == "0") {
  //       print(" Step 3 - Creating new cart");
  //       await _createNewCart();
  //     }
  //   } catch (e) {
  //     print(" Cart initialization error: $e");
  //     // Don't clear cart on error - keep existing state
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //     debugCartState();
  //   }
  // }
