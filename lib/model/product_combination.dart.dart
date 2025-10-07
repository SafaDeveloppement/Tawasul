// import 'package:flutter/material.dart';

// class ProductCombination {
//   final String idAttribute;
//   final int quantity;
//   final bool isDefault;
//   final String colorCode;
//   final String colorName;

//   const ProductCombination({
//     required this.idAttribute,
//     required this.quantity,
//     required this.isDefault,
//     required this.colorCode,
//     required this.colorName,
//   });

//   factory ProductCombination.fromJson(Map<String, dynamic> json) {
//     return ProductCombination(
//       idAttribute: json['id_product_attribute']?.toString() ?? '',
//       quantity: json['qty'],
//       isDefault: json['default_on']?.toString() == '1',
//       colorCode: json['code_coleur']?.toString() ?? '',
//       colorName: json['name']?.toString() ?? '',
//     );
//   }

//   bool get isAvailable => quantity > 0;

//   Color get colorValue {
//     if (colorCode.isEmpty || colorCode == "#") return Colors.grey;
//     try {
//       String hex = colorCode.replaceAll('#', '');
//       if (hex.length == 6) hex = 'FF$hex';
//       return Color(int.parse(hex, radix: 16));
//     } catch (e) {
//       return Colors.grey;
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_attribute': idAttribute,
//       'qty': quantity,
//       'default_on': isDefault ? '1' : '0',
//       'code_coleur': colorCode,
//       'name': colorName,
//     };
//   }

//   ProductCombination copyWith({        //??????????
//     String? idAttribute,
//     int? quantity,
//     bool? isDefault,
//     String? colorCode,
//     String? colorName,
//   }) {
//     return ProductCombination(
//       idAttribute: idAttribute ?? this.idAttribute,
//       quantity: quantity ?? this.quantity,
//       isDefault: isDefault ?? this.isDefault,
//       colorCode: colorCode ?? this.colorCode,
//       colorName: colorName ?? this.colorName,
//     );
//   }

//   @override
//   bool operator ==(Object other) =>     //????????
//       identical(this, other) ||
//       other is ProductCombination &&
//           runtimeType == other.runtimeType &&
//           idAttribute == other.idAttribute ;    

//   @override
//   int get hashCode => idAttribute.hashCode;

//   @override
//   String toString() {
//     return 'ProductCombination{id: $idAttribute, color: $colorName, quantity: $quantity, available: $isAvailable}';
//   }


// }



// product_combination.dart
import 'package:flutter/material.dart';

class ProductCombination {
  final String idAttribute;
  final int quantity;
  final bool isDefault;
  final String colorCode;
  final String colorName;

  const ProductCombination({
    required this.idAttribute,
    required this.quantity,
    required this.isDefault,
    required this.colorCode,
    required this.colorName,
  });

  factory ProductCombination.fromJson(Map<String, dynamic> json) {
    return ProductCombination(
      idAttribute: json['id_product_attribute']?.toString() ?? '',
      quantity: (json['qty'] is int) ? json['qty'] as int : int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      isDefault: json['default_on']?.toString() == '1',
      colorCode: json['code_coleur']?.toString() ?? '',
      colorName: json['name']?.toString() ?? '',
    );
  }

  bool get isAvailable => quantity > 0;

  Color get colorValue {
    if (colorCode.isEmpty || colorCode == "#") return Colors.grey;
    try {
      String hex = colorCode.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id_product_attribute': idAttribute,
      'qty': quantity,
      'default_on': isDefault ? '1' : '0',
      'code_coleur': colorCode,
      'name': colorName,
    };
  }

  ProductCombination copyWith({
    String? idAttribute,
    int? quantity,
    bool? isDefault,
    String? colorCode,
    String? colorName,
  }) {
    return ProductCombination(
      idAttribute: idAttribute ?? this.idAttribute,
      quantity: quantity ?? this.quantity,
      isDefault: isDefault ?? this.isDefault,
      colorCode: colorCode ?? this.colorCode,
      colorName: colorName ?? this.colorName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCombination &&
          runtimeType == other.runtimeType &&
          idAttribute == other.idAttribute;

  @override
  int get hashCode => idAttribute.hashCode;

  @override
  String toString() {
    return 'ProductCombination{id: $idAttribute, color: $colorName, quantity: $quantity, available: $isAvailable}';
  }
}