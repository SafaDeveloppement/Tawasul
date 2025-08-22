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
    DateTime? parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      try {
        return DateTime.parse(dateString.replaceFirst(" ", "T"));
      } catch (_) {
        try {
          return DateTime.parse(dateString);
        } catch (e) {
          print("❌ Failed to parse date: $dateString, error: $e");
          return null;
        }
      }
    }

    return Product(
      id:
          json['id_product'] != null
              ? int.tryParse(json['id_product'].toString()) ?? 0
              : 0,
      name: json['name'] as String? ?? 'No Name',
      brand: json['manufacturer_name'] as String? ?? 'No Brand',
      price: json['price']?.toString() ?? '0',
      image: json['image'] as String? ?? '',
      description: json['description_short'] as String? ?? 'No Description',
      oldPrice: json['price_without_reduction']?.toString(),
      discount:
          json['reduction'] != null && json['reduction'] > 0
              ? '${(json['reduction'] * 100).toStringAsFixed(0)}% OFF'
              : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
