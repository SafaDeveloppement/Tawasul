// import 'package:tawasul_application/model/product_model.dart';

// class CartItem {
//   final Product product;
//   int quantity;
//   final String? selectedColor;
//   final String? selectedSize;
//   double totalPrice;
//   final int? idProductAttribute;

//   CartItem({
//     required this.product,
//     required this.quantity,
//     this.selectedColor,
//     this.selectedSize,
//     required this.totalPrice,
//     this.idProductAttribute,
//   });

//   void calculateTotalPrice() {
//     totalPrice = product.price * quantity;
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_product': product.id,
//       'id_product_attribute': idProductAttribute,
//       'quantity': quantity,
//       'product_name': product.name,
//       'product_price': product.price,
//       'product_image': product.image,
//       'selected_color': selectedColor,
//       'selected_size': selectedSize,
//       'total_price': totalPrice,
//     };
//   }

//   // Create CartItem from JSON
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     final product = Product(
//       id: json['id_product'] ?? 0,
//       name: json['product_name'] ?? '',
//       price: json['product_price'] ?? 0.0,
//       oldPrice: json['product_old_price'],
//       image: json['product_image'] ?? '',
//       images: json['product_images'] != null 
//           ? List<String>.from(json['product_images'])
//           : [],
//       description: json['product_description'] ?? '',
//       shortDescription: json['product_short_description'] ?? '',
//       brand: json['product_brand'] ?? '',
//       stock: json['product_stock'] ?? 0,
//       categoryId: json['product_category_id'] ?? 0,
//       reference: json['product_reference'] ?? '',
//     );

//     return CartItem(
//       product: product,
//       quantity: json['quantity'] ?? 1,
//       selectedColor: json['selected_color'],
//       selectedSize: json['selected_size'],
//       totalPrice: (json['total_price'] ?? product.price).toDouble(),
//       idProductAttribute: json['id_product_attribute'],
//     );
//   }

//   // Copy with method for immutability
//   CartItem copyWith({
//     Product? product,
//     int? quantity,
//     String? selectedColor,
//     String? selectedSize,
//     double? totalPrice,
//     int? idProductAttribute,
//   }) {
//     return CartItem(
//       product: product ?? this.product,
//       quantity: quantity ?? this.quantity,
//       selectedColor: selectedColor ?? this.selectedColor,
//       selectedSize: selectedSize ?? this.selectedSize,
//       totalPrice: totalPrice ?? this.totalPrice,
//       idProductAttribute: idProductAttribute ?? this.idProductAttribute,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
    
//     return other is CartItem &&
//         other.product.id == product.id &&
//         other.selectedColor == selectedColor &&
//         other.selectedSize == selectedSize &&
//         other.idProductAttribute == idProductAttribute;
//   }

//   @override
//   int get hashCode {
//     return Object.hash(
//       product.id,
//       selectedColor,
//       selectedSize,
//       idProductAttribute,
//     );
//   }

//   @override
//   String toString() {
//     return 'CartItem(product: ${product.name}, quantity: $quantity, color: $selectedColor, total: $totalPrice)';
//   }
// }

// class CartSummary {
//   final double subtotal;
//   final double shipping;
//   final double tax;
//   final double discount;
//   final double total;
//   final int totalItems;

//   CartSummary({
//     required this.subtotal,
//     required this.shipping,
//     required this.tax,
//     required this.discount,
//     required this.total,
//     required this.totalItems,
//   });

//   factory CartSummary.fromJson(Map<String, dynamic> json) {
//     return CartSummary(
//       subtotal: (json['subtotal'] ?? 0.0).toDouble(),
//       shipping: (json['shipping'] ?? 0.0).toDouble(),
//       tax: (json['tax'] ?? 0.0).toDouble(),
//       discount: (json['discount'] ?? 0.0).toDouble(),
//       total: (json['total'] ?? 0.0).toDouble(),
//       totalItems: (json['total_items'] ?? 0).toInt(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'subtotal': subtotal,
//       'shipping': shipping,
//       'tax': tax,
//       'discount': discount,
//       'total': total,
//       'total_items': totalItems,
//     };
//   }

//   CartSummary copyWith({
//     double? subtotal,
//     double? shipping,
//     double? tax,
//     double? discount,
//     double? total,
//     int? totalItems,
//   }) {
//     return CartSummary(
//       subtotal: subtotal ?? this.subtotal,
//       shipping: shipping ?? this.shipping,
//       tax: tax ?? this.tax,
//       discount: discount ?? this.discount,
//       total: total ?? this.total,
//       totalItems: totalItems ?? this.totalItems,
//     );
//   }

//   @override
//   String toString() {
//     return 'CartSummary(subtotal: $subtotal, shipping: $shipping, tax: $tax, discount: $discount, total: $total, totalItems: $totalItems)';
//   }
// }

// class CartResponse {
//   final bool success;
//   final String message;
//   final List<CartItem> cartItems;
//   final CartSummary summary;
//   final Map<String, dynamic>? rawData;

//   CartResponse({
//     required this.success,
//     required this.message,
//     required this.cartItems,
//     required this.summary,
//     this.rawData,
//   });

//   factory CartResponse.fromJson(Map<String, dynamic> json) {
//     final List<CartItem> items = [];
    
//     if (json['products'] != null && json['products'] is List) {
//       items.addAll(
//         (json['products'] as List).map((item) => CartItem.fromJson(item)).toList(),
//       );
//     }

//     final summary = json['summary'] != null 
//         ? CartSummary.fromJson(Map<String, dynamic>.from(json['summary']))
//         : CartSummary(
//             subtotal: 0.0,
//             shipping: 0.0,
//             tax: 0.0,
//             discount: 0.0,
//             total: 0.0,
//             totalItems: 0,
//           );

//     return CartResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       cartItems: items,
//       summary: summary,
//       rawData: json,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'products': cartItems.map((item) => item.toJson()).toList(),
//       'summary': summary.toJson(),
//     };
//   }

//   @override
//   String toString() {
//     return 'CartResponse(success: $success, message: $message, items: ${cartItems.length}, total: ${summary.total})';
//   }
// }

// class UpdateCartRequest {
//   final int idProduct;
//   final int idProductAttribute;
//   final int quantity;
//   final String operation; // 'up' or 'down'

//   UpdateCartRequest({
//     required this.idProduct,
//     required this.idProductAttribute,
//     required this.quantity,
//     this.operation = 'up',
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id_product': idProduct,
//       'id_product_attribute': idProductAttribute,
//       'quantity': quantity,
//       'op': operation,
//     };
//   }

//   Map<String, String> toQueryParams() {
//     return {
//       'id_product': idProduct.toString(),
//       'id_product_attribute': idProductAttribute.toString(),
//       'op': operation,
//     };
//   }

//   @override
//   String toString() {
//     return 'UpdateCartRequest(idProduct: $idProduct, idProductAttribute: $idProductAttribute, quantity: $quantity, operation: $operation)';
//   }
// }

// class UpdateCartResponse {
//   final bool success;
//   final String message;
//   final CartSummary? summary;
//   final Map<String, dynamic>? cartData;
//   final Map<String, dynamic>? rawData;

//   UpdateCartResponse({
//     required this.success,
//     required this.message,
//     this.summary,
//     this.cartData,
//     this.rawData,
//   });

//   factory UpdateCartResponse.fromJson(Map<String, dynamic> json) {
//     final summary = json['summary'] != null 
//         ? CartSummary.fromJson(Map<String, dynamic>.from(json['summary']))
//         : null;

//     return UpdateCartResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       summary: summary,
//       cartData: json['cart'],
//       rawData: json,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'summary': summary?.toJson(),
//       'cart': cartData,
//     };
//   }

//   @override
//   String toString() {
//     return 'UpdateCartResponse(success: $success, message: $message)';
//   }
// }

// class CartSyncData {
//   final List<CartItem> serverItems;
//   final List<CartItem> localItems;
//   final List<CartItem> itemsToAdd;
//   final List<CartItem> itemsToUpdate;
//   final List<CartItem> itemsToRemove;

//   CartSyncData({
//     required this.serverItems,
//     required this.localItems,
//     required this.itemsToAdd,
//     required this.itemsToUpdate,
//     required this.itemsToRemove,
//   });

//   bool get hasChanges {
//     return itemsToAdd.isNotEmpty || itemsToUpdate.isNotEmpty || itemsToRemove.isNotEmpty;
//   }

//   @override
//   String toString() {
//     return 'CartSyncData(toAdd: ${itemsToAdd.length}, toUpdate: ${itemsToUpdate.length}, toRemove: ${itemsToRemove.length})';
//   }
// }

// // Extension methods for List<CartItem>
// extension CartItemsExtensions on List<CartItem> {
//   double get subtotal {
//     return fold(0.0, (sum, item) => sum + item.totalPrice);
//   }

//   int get totalQuantity {
//     return fold(0, (sum, item) => sum + item.quantity);
//   }

//   bool containsProduct(int productId, [String? color, String? size]) {
//     return any((item) =>
//         item.product.id == productId &&
//         item.selectedColor == color &&
//         item.selectedSize == size);
//   }

//   CartItem? findItem(int productId, [String? color, String? size]) {
//     try {
//       return firstWhere((item) =>
//           item.product.id == productId &&
//           item.selectedColor == color &&
//           item.selectedSize == size);
//     } catch (e) {
//       return null;
//     }
//   }

//   List<CartItem> getItemsByProductId(int productId) {
//     return where((item) => item.product.id == productId).toList();
//   }

//   Map<String, dynamic> toApiFormat() {
//     return {
//       'products': map((item) => item.toJson()).toList(),
//       'total_items': totalQuantity,
//       'subtotal': subtotal,
//     };
//   }
// }

// // Helper class for cart calculations
// class CartCalculator {
//   static double calculateTotal({
//     required double subtotal,
//     required double shipping,
//     required double tax,
//     required double discount,
//   }) {
//     return subtotal + shipping + tax - discount;
//   }

//   static double calculateTax(double subtotal, double taxRate) {
//     return subtotal * (taxRate / 100);
//   }

//   static double applyDiscount(double subtotal, double discountAmount, [double? discountPercentage]) {
//     if (discountPercentage != null) {
//       return subtotal * (discountPercentage / 100);
//     }
//     return discountAmount;
//   }
// }


import 'package:tawasul_application/model/product_model.dart';

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
      products: (json['products'] as List? ?? [])
          .map((productJson) => Product.fromCartJson(productJson))
          .toList(),
    );
  }
}

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
      'id_product': product.idProduct,
      'id_product_attribute': idProductAttribute ?? 0,
      'qty': quantity,
    };
  }

  
}