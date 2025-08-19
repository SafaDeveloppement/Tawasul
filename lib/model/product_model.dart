// class Product {
//   final int id;
//   final String name;
//   final String brand;
//   final String price;
//   final String image;
//   final String description;
//   final String? oldPrice;
//   final String? discount;
//   bool isFavorite;
//   bool isBestSeller;
//   DateTime? dateAdded; // Add this field
//   DateTime? dateUpdated; // Add this field

//   Product({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.price,
//     required this.image,
//     required this.description,
//     this.oldPrice,
//     this.discount,
//     this.isFavorite = false,
//     this.isBestSeller = false,
//     this.dateAdded,
//     this.dateUpdated,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     // Parse date fields if available
//     DateTime? parseDate(String? dateString) {
//       if (dateString == null) return null;
//       try {
//         return DateTime.parse(dateString);
//       } catch (e) {
//         return null;
//       }
//     }

//     return Product(
//       id:
//           json['id_product'] != null
//               ? int.tryParse(json['id_product'].toString()) ?? 0
//               : 0,
//       name: json['name'] as String? ?? 'No Name',
//       brand: json['manufacturer_name'] as String? ?? 'No Brand',
//       price: json['price']?.toString() ?? '0',
//       image:
//           json['id_image'] != null
//               ? 'https://tawasul-shop.com/img/p/${json['id_image']}-large_default.jpg'
//               : '',
//       description: json['description_short'] as String? ?? 'No Description',
//       oldPrice: json['price_without_reduction']?.toString(),
//       discount:
//           json['reduction'] != null && json['reduction'] > 0
//               ? '${(json['reduction'] * 100).toStringAsFixed(0)}% OFF'
//               : null,
//       dateAdded: parseDate(json['date_add']),
//       dateUpdated: parseDate(json['date_upd']),
//     );
//   }
//   // Add getter for isNew based on date
//   bool get isNew {
//     if (dateAdded == null) return false;
//     // Consider product as "new" if added within last 30 days
//     return dateAdded!.isAfter(DateTime.now().subtract(Duration(days: 365)));
//   }
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Product && runtimeType == other.runtimeType && id == other.id;
//   @override
//   int get hashCode => id.hashCode;
// }

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
  DateTime? dateAdded;
  DateTime? dateUpdated;

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
    this.dateAdded,
    this.dateUpdated,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse date fields if available
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
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
      image:
          json['id_image'] != null
              ? 'https://tawasul-shop.com/img/p/${json['id_image']}-large_default.jpg'
              : '',
      description: json['description_short'] as String? ?? 'No Description',
      oldPrice: json['price_without_reduction']?.toString(),
      discount:
          json['reduction'] != null && json['reduction'] > 0
              ? '${(json['reduction'] * 100).toStringAsFixed(0)}% OFF'
              : null,
      dateAdded: parseDate(json['date_add']),
      dateUpdated: parseDate(json['date_upd']),
    );
  }

  bool get isNew {
    if (dateAdded == null) return id > 1000;
    return dateAdded!.isAfter(DateTime(2024, 1, 1));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
