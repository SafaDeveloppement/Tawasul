class Product {
  final int id;
  final String name;
  final String brand;
  final String price;
  final String image;
  final String description;
  final String? oldPrice;
  final String? discount;
  bool isFavorite;
  bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.description,
    this.oldPrice,
    this.discount,
    this.isFavorite = false,
    this.isBestSeller = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0, 
      name: json['name'] as String? ?? 'No Name',
      brand: json['brand'] as String? ?? 'No Brand',
      price: json['price']?.toString() ?? '0.00', // Convert to string if number
      image: json['image'] as String? ?? '', // Default empty string
      description: json['description'] as String? ?? 'No Description',
      oldPrice: json['oldPrice']?.toString(), // Nullable
      discount: json['discount']?.toString(), // Nullable
      isFavorite: json['isFavorite'] as bool? ?? false,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}