// class Cart {
//   final String idCart;
//   final String idProduct;
//   final String idProductAttribute;
//   final int quantity;

//   Cart({
//     required this.idCart,
//     required this.idProduct,
//     this.idProductAttribute = "0",
//     this.quantity = 1,
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       idCart: json['id_cart']?.toString() ?? '0',
//       idProduct: json['id_product']?.toString() ?? '0',
//       idProductAttribute: json['id_product_attribute']?.toString() ?? '0',
//       quantity: json['quantity'] ?? json['qty'] ?? 1,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_cart': idCart,
//       'id_product': idProduct,
//       'id_product_attribute': idProductAttribute,
//       'quantity': quantity,
//     };
//   }
// }

import 'package:tawasul_application/model/product_model.dart';

class Cart {
  final String idCart;
  final String idProduct;
  final String idProductAttribute;
  final int quantity;
  final String productName;
  final String productImage;
  final double unitPrice;
  final double totalPrice;
  final String? selectedColor;
  final Product product;

  Cart({
    required this.idCart,
    required this.idProduct,
    required this.idProductAttribute,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.totalPrice,
    this.selectedColor,
    required this.product,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idCart: json['id_cart']?.toString() ?? '0',
      idProduct: json['id_product']?.toString() ?? '0',
      idProductAttribute: json['id_product_attribute']?.toString() ?? '0',
      quantity:
          int.tryParse(
            (json['cart_quantity'] ?? json['quantity'] ?? json['qty'] ?? 1)
                .toString(),
          ) ??
          1,
      productName: json['name']?.toString() ?? 'Unknown Product',
      productImage: json['image']?.toString() ?? '',
      unitPrice: _parsePrice(
        json['price'] ?? json['price_without_reduction'] ?? 0,
      ),
      totalPrice: _parsePrice(json['total'] ?? json['total_price'] ?? 0),

      product: Product.fromCartJson(json),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      final numericString = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(numericString) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cart': idCart,
      'id_product': idProduct,
      'id_product_attribute': idProductAttribute,
      'quantity': quantity,
      'name': productName,
      'image': productImage,
      'price': unitPrice,
      'total': totalPrice,
    };
  }
}

class CartResponse {
  final bool success;
  final String idCart;
  final List<Cart> products;
  final double totalPrice;
  final int totalItems;
  final String? message;

  CartResponse({
    required this.success,
    required this.idCart,
    required this.products,
    required this.totalPrice,
    required this.totalItems,
    this.message,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final products =
        (json['products'] as List<dynamic>? ?? [])
            .map((item) => Cart.fromJson(item))
            .toList();

    return CartResponse(
      success: json['success'] == true,
      idCart: json['id_cart']?.toString() ?? '0',
      products: products,
      totalPrice: _parsePrice(json['total_price'] ?? json['total']),
      totalItems:
          json['total_items'] is int
              ? json['total_items'] as int
              : products.length,
      message: json['message']?.toString(),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      final numericString = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(numericString) ?? 0.0;
    }
    return 0.0;
  }
}
