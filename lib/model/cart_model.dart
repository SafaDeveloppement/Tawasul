class CartItem {
  final String code;
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String? color;
  
  CartItem({
    required this.code,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    this.color,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      code: json['code'],
      name: json['name'] ?? 'Product',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? 'assets/images/placeholder.jpg',
      color: json['color'],
    );
  }
}

class CartSummary {
  final int nbItems;
  final double amount;
  final String cartId;
  final double minAmount;
  
  CartSummary({
    required this.nbItems,
    required this.amount,
    required this.cartId,
    required this.minAmount,
  });
  
  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      nbItems: json['nbItems'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      cartId: json['cartId']?.toString() ?? '',
      minAmount: (json['minAmount'] ?? 0).toDouble(),
    );
  }
}