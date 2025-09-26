// import 'package:flutter/foundation.dart';
// import 'package:tawasul_application/model/product_model.dart';

// class CartItem {
//   final Product product;
//   int quantity;
//   final String? selectedColor;

//   CartItem({required this.product, this.quantity = 1, this.selectedColor});

//   double get totalPrice {
//     RegExp regex = RegExp(r'(\d+\.?\d*)');
//     Match? match = regex.firstMatch(product.price);
//     if (match != null) {
//       return double.parse(match.group(1)!) * quantity;
//     }
//     return 0.0;
//   }
// }

// class CartProvider with ChangeNotifier {
//   List<CartItem> _cartItems = [];

//   List<CartItem> get cartItems => _cartItems;

//   int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

//   double get totalAmount =>
//       _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

//   void addToCart(Product product, {int quantity = 1, String? color}) {
//     final existingItemIndex = _cartItems.indexWhere(
//       (item) => item.product.id == product.id && item.selectedColor == color,
//     );

//     if (existingItemIndex != -1) {
//       _cartItems[existingItemIndex].quantity += quantity;
//     } else {
//       _cartItems.add(
//         CartItem(product: product, quantity: quantity, selectedColor: color),
//       );
//     }
//     notifyListeners();
//   }

//   void updateQuantity(int productId, String? color, int newQuantity) {
//     final itemIndex = _cartItems.indexWhere(
//       (item) => item.product.id == productId && item.selectedColor == color,
//     );

//     if (itemIndex != -1) {
//       if (newQuantity <= 0) {
//         _cartItems.removeAt(itemIndex);
//       } else {
//         _cartItems[itemIndex].quantity = newQuantity;
//       }
//       notifyListeners();
//     }
//   }

//   void removeFromCart(int productId, String? color) {
//     _cartItems.removeWhere(
//       (item) => item.product.id == productId && item.selectedColor == color,
//     );
//     notifyListeners();
//   }

//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }

//   bool isInCart(Product product, {String? color}) {
//     return _cartItems.any(
//       (item) => item.product.id == product.id && item.selectedColor == color,
//     );
//   }

//   int getItemQuantity(Product product, {String? color}) {
//     final item = _cartItems.firstWhere(
//       (item) => item.product.id == product.id && item.selectedColor == color,
//       orElse: () => CartItem(product: product, quantity: 0),
//     );
//     return item.quantity;
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:tawasul_application/model/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedColor;

  CartItem({required this.product, this.quantity = 1, this.selectedColor});

  double get totalPrice {
    return product.price * quantity;
  }

  Map<String, dynamic> toApiMap() {
    return {
      'code': product.reference,
      'quantity': quantity,
      'operator': 'up',
      if (selectedColor != null) 'color': selectedColor,
    };
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(Product product, {int quantity = 1, String? color}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.selectedColor == color,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(product: product, quantity: quantity, selectedColor: color),
      );
    }
    notifyListeners();
  }

  void updateQuantity(int productId, String? color, int newQuantity) {
    final itemIndex = _cartItems.indexWhere(
      (item) => item.product.id == productId && item.selectedColor == color,
    );

    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        _cartItems[itemIndex].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId, String? color) {
    _cartItems.removeWhere(
      (item) => item.product.id == productId && item.selectedColor == color,
    );
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(Product product, {String? color}) {
    return _cartItems.any(
      (item) => item.product.id == product.id && item.selectedColor == color,
    );
  }

  int getItemQuantity(Product product, {String? color}) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == product.id && item.selectedColor == color,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }

  List<Map<String, dynamic>> getCartDetailsForApi() {
    return _cartItems.map((item) => item.toApiMap()).toList();
  }
}
