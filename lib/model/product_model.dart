import 'package:flutter/widgets.dart';

class Product {
  final int id;
  final String reference;
  final String name;
  final String brand;
  final String price;
  final String image;
  final String description;
  final String? oldPrice;
  final String? discount;
  final Map<String, dynamic>? attributes;
  final String? url;
  final bool showPrice;
  final String? weightUnit;
  final Map<String, dynamic>? embeddedAttributes;
  bool isFavorite;
  bool isBestSeller;
  final List<Color>? colors;
  final String? category;
  final String? categoryCode;

  Product({
    required this.id,
    this.reference = "",
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.description,
    this.oldPrice,
    this.discount,
    this.attributes,
    this.url,
    this.showPrice = true,
    this.weightUnit,
    this.embeddedAttributes,
    this.isFavorite = false,
    this.isBestSeller = false,
    this.colors,
    this.category,
    this.categoryCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final embedded = json['embedded_attributes'] ?? {};
    String? categoryCode = json['category_code']?.toString();
    if (categoryCode == null || categoryCode.isEmpty) {
      categoryCode = embedded['category_code']?.toString();
    }
    if (categoryCode == null || categoryCode.isEmpty) {
      categoryCode = json['id_category_default']?.toString();
    }

    // Parse colors from variants if available
    List<Color>? parsedColors;
    if (json['main_variants'] != null && json['main_variants'] is List) {
      final variants = json['main_variants'] as List;
      parsedColors = [];
      for (var variant in variants) {
        if (variant['html_color_code'] != null) {
          final colorCode = variant['html_color_code'].toString();
          if (colorCode.isNotEmpty && colorCode.startsWith('#')) {
            try {
              parsedColors.add(
                Color(
                  int.parse(colorCode.substring(1, 7), radix: 16) + 0xFF000000,
                ),
              );
            } catch (e) {
              // Skip invalid color codes
            }
          }
        }
      }
      if (parsedColors.isEmpty) {
        parsedColors = null;
      }
    }

    return Product(
      id:
          int.tryParse(
            json['id']?.toString() ?? json['id_product']?.toString() ?? '0',
          ) ??
          0,
      reference: json['reference']?.toString() ?? '',
      name: embedded['name'] ?? json['name'] ?? 'No Name',
      brand: embedded['manufacturer_name'] ?? 'No Brand',
      price: embedded['price']?.toString() ?? json['price']?.toString() ?? '0',
      image: _parseImageUrl(json),
      description: _parseShortDescription(embedded, json),
      oldPrice: embedded['price_without_reduction']?.toString(),
      discount: _parseDiscount(embedded['reduction']),
      attributes: json['attributes'],
      url: json['url'],
      showPrice: json['show_price'] ?? true,
      weightUnit: json['weight_unit'],
      embeddedAttributes: embedded,
      colors: parsedColors,
      category: embedded['category'] ?? json['category']?.toString(),
      categoryCode: json['category_code']?.toString(),
    );
  }

  static String _parseShortDescription(
    Map<String, dynamic> embedded,
    Map<String, dynamic> json,
  ) {
    // First try to get from embedded attributes
    String? shortDesc = embedded['description_short']?.toString();

    // If not found in embedded, try the main json
    if (shortDesc == null || shortDesc.isEmpty) {
      shortDesc = json['description_short']?.toString();
    }

    // Clean up HTML tags and trim
    if (shortDesc != null && shortDesc.isNotEmpty) {
      return _cleanHtmlTags(shortDesc);
    }

    return 'No Description';
  }

  static Map<String, String> _parseAllDescriptions(
    Map<String, dynamic> embedded,
    Map<String, dynamic> json,
  ) {
    final Map<String, String> descriptions = {};

    // Check for language-specific descriptions in embedded attributes
    embedded.forEach((key, value) {
      if (key.startsWith('description_short_') && value != null) {
        final language = key.replaceFirst('description_short_', '');
        descriptions[language] = _cleanHtmlTags(value.toString());
      }
    });

    // Check for language-specific descriptions in main json
    json.forEach((key, value) {
      if (key.startsWith('description_short_') && value != null) {
        final language = key.replaceFirst('description_short_', '');
        descriptions[language] = _cleanHtmlTags(value.toString());
      }
    });

    // Add generic description as fallback (from your original code)
    String? genericDesc = embedded['description_short']?.toString();
    if (genericDesc == null || genericDesc.isEmpty) {
      genericDesc = json['description_short']?.toString();
    }
    if (genericDesc != null && genericDesc.isNotEmpty) {
      descriptions['default'] = _cleanHtmlTags(genericDesc);
    }

    // If no descriptions found at all, add a default one
    if (descriptions.isEmpty) {
      descriptions['default'] = 'No Description';
    }

    return descriptions;
  }

  static String _getDefaultDescription(Map<String, String> descriptions) {
    // Return English description if available, otherwise any available description
    return descriptions['en'] ??
        descriptions['ar'] ??
        descriptions['default'] ??
        descriptions.values.first;
  }

  static String _cleanHtmlTags(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&[^;]+;'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _parseImageUrl(Map<String, dynamic> json) {
    if (json['images'] != null &&
        json['images'] is List &&
        (json['images'] as List).isNotEmpty) {
      final images = json['images'] as List;

      final coverImage = images.firstWhere(
        (img) => img['cover'] == '1' || img['cover'] == 1,
        orElse: () => images.first,
      );

      if (coverImage['bySize'] != null &&
          coverImage['bySize']['large_default'] != null) {
        return coverImage['bySize']['large_default']['url'];
      } else if (coverImage['bySize'] != null &&
          coverImage['bySize']['medium_default'] != null) {
        return coverImage['bySize']['medium_default']['url'];
      } else if (coverImage['bySize'] != null &&
          coverImage['bySize']['home_default'] != null) {
        return coverImage['bySize']['home_default']['url'];
      } else if (coverImage['large'] != null) {
        return coverImage['large']['url'];
      } else if (coverImage['medium'] != null) {
        return coverImage['medium']['url'];
      }
    }

    if (json['id_image'] != null) {
      return 'https://t-api.dotit-corp.com/images/products/${json['id']}/${json['id_image']}.jpg';
    }
    return json['image'] ?? '';
  }

  static String? _parseDiscount(dynamic reduction) {
    if (reduction != null && (reduction as num) > 0) {
      return '${(reduction * 100).toStringAsFixed(0)}% OFF';
    }
    return null;
  }
}


// import 'package:flutter/widgets.dart';

// class Product {
//   final int id;
//   final String reference;
//   final String name;
//   final String brand;
//   final String price;
//   final String image;
//   final String description;
//   final String? oldPrice;
//   final String? discount;
//   final Map<String, dynamic>? attributes;
//   final String? url;
//   final bool showPrice;
//   final String? weightUnit;
//   final Map<String, dynamic>? embeddedAttributes;
//   bool isFavorite;
//   bool isBestSeller;
//   final List<Color>? colors;
//   final String? category;

//   Product({
//     required this.id,
//     this.reference = "",
//     required this.name,
//     required this.brand,
//     required this.price,
//     required this.image,
//     required this.description,
//     this.oldPrice,
//     this.discount,
//     this.attributes,
//     this.url,
//     this.showPrice = true,
//     this.weightUnit,
//     this.embeddedAttributes,
//     this.isFavorite = false,
//     this.isBestSeller = false,
//     this.colors,
//     this.category,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     final embedded = json['embedded_attributes'] ?? {};

//     return Product(
//       id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: embedded['name'] ?? json['name'] ?? 'No Name',
//       brand: embedded['manufacturer_name'] ?? 'No Brand',
//       price: embedded['price']?.toString() ?? json['price']?.toString() ?? '0',
//       image: _parseImageUrl(json),
//       description: _parseShortDescription(embedded, json),
//       oldPrice: embedded['price_without_reduction']?.toString(),
//       discount: _parseDiscount(embedded['reduction']),
//       attributes: json['attributes'],
//       url: json['url'],
//       showPrice: json['show_price'] ?? true,
//       weightUnit: json['weight_unit'],
//       embeddedAttributes: embedded,
//       colors:
//           productColors
//               .map((color) => color.value.toString())
//               .toList(), // Convert to strings
//       category: embedded['category'] ?? json['category']?.toString(),
//     );
//   }

//     static String _parseShortDescription(
//     Map<String, dynamic> embedded,
//     Map<String, dynamic> json,
//   ) {
//     // First try to get from embedded attributes
//     String? shortDesc = embedded['description_short']?.toString();

//     // If not found in embedded, try the main json
//     if (shortDesc == null || shortDesc.isEmpty) {
//       shortDesc = json['description_short']?.toString();
//     }

//     // Clean up HTML tags and trim
//     if (shortDesc != null && shortDesc.isNotEmpty) {
//       return _cleanHtmlTags(shortDesc);
//     }

//     return 'No Description';
//   }

//   static Map<String, String> _parseAllDescriptions(
//     Map<String, dynamic> embedded,
//     Map<String, dynamic> json,
//   ) {
//     final Map<String, String> descriptions = {};

//     // Check for language-specific descriptions in embedded attributes
//     embedded.forEach((key, value) {
//       if (key.startsWith('description_short_') && value != null) {
//         final language = key.replaceFirst('description_short_', '');
//         descriptions[language] = _cleanHtmlTags(value.toString());
//       }
//     });

//     // Check for language-specific descriptions in main json
//     json.forEach((key, value) {
//       if (key.startsWith('description_short_') && value != null) {
//         final language = key.replaceFirst('description_short_', '');
//         descriptions[language] = _cleanHtmlTags(value.toString());
//       }
//     });

//     // Add generic description as fallback (from your original code)
//     String? genericDesc = embedded['description_short']?.toString();
//     if (genericDesc == null || genericDesc.isEmpty) {
//       genericDesc = json['description_short']?.toString();
//     }
//     if (genericDesc != null && genericDesc.isNotEmpty) {
//       descriptions['default'] = _cleanHtmlTags(genericDesc);
//     }

//     // If no descriptions found at all, add a default one
//     if (descriptions.isEmpty) {
//       descriptions['default'] = 'No Description';
//     }

//     return descriptions;
//   }

//   static String _getDefaultDescription(Map<String, String> descriptions) {
//     // Return English description if available, otherwise any available description
//     return descriptions['en'] ??
//         descriptions['ar'] ??
//         descriptions['default'] ??
//         descriptions.values.first ??
//         'No Description';
//   }

//   static String _cleanHtmlTags(String htmlString) {
//     return htmlString
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll(RegExp(r'&[^;]+;'), '')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }

//   static String _parseImageUrl(Map<String, dynamic> json) {
//     if (json['images'] != null &&
//         json['images'] is List &&
//         (json['images'] as List).isNotEmpty) {
//       final images = json['images'] as List;

//       final coverImage = images.firstWhere(
//         (img) => img['cover'] == '1' || img['cover'] == 1,
//         orElse: () => images.first,
//       );

//       if (coverImage['bySize'] != null &&
//           coverImage['bySize']['large_default'] != null) {
//         return coverImage['bySize']['large_default']['url'];
//       } else if (coverImage['bySize'] != null &&
//           coverImage['bySize']['medium_default'] != null) {
//         return coverImage['bySize']['medium_default']['url'];
//       } else if (coverImage['bySize'] != null &&
//           coverImage['bySize']['home_default'] != null) {
//         return coverImage['bySize']['home_default']['url'];
//       } else if (coverImage['large'] != null) {
//         return coverImage['large']['url'];
//       } else if (coverImage['medium'] != null) {
//         return coverImage['medium']['url'];
//       }
//     }

//     if (json['id_image'] != null) {
//       return 'https://t-api.dotit-corp.com/images/products/${json['id']}/${json['id_image']}.jpg';
//     }
//     return json['image'] ?? '';
//   }

//   static String? _parseDiscount(dynamic reduction) {
//     if (reduction != null && (reduction as num) > 0) {
//       return '${(reduction * 100).toStringAsFixed(0)}% OFF';
//     }
//     return null;
//   }
// }





  //   static List<String>? _parseColors(
  //   Map<String, dynamic> embedded,
  //   Map<String, dynamic> json,
  // ) {
  //   final List<String> colors = [];
  //   final Set<String> uniqueColors = {};

  //   // Check for colors in main_variants (this seems to be where color data is)
  //   if (json['main_variants'] != null && json['main_variants'] is List) {
  //     final variants = json['main_variants'] as List;
  //     for (var variant in variants) {
  //       if (variant is Map && variant['html_color_code'] != null) {
  //         final colorCode = variant['html_color_code'].toString();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     }
  //   }

  //   // Check for colors in embedded attributes main_variants
  //   if (embedded['main_variants'] != null && embedded['main_variants'] is List) {
  //     final variants = embedded['main_variants'] as List;
  //     for (var variant in variants) {
  //       if (variant is Map && variant['html_color_code'] != null) {
  //         final colorCode = variant['html_color_code'].toString();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     }
  //   }

  //   // Check for colors in attributes (alternative location)
  //   if (json['attributes'] != null && json['attributes'] is Map) {
  //     final attributes = json['attributes'] as Map<String, dynamic>;
  //     attributes.forEach((key, value) {
  //       if (value is Map && value['color_code'] != null) {
  //         final colorCode = value['color_code'].toString();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     });
  //   }

  //   // Check for colors in embedded attributes
  //   if (embedded['attributes'] != null && embedded['attributes'] is Map) {
  //     final embeddedAttrs = embedded['attributes'] as Map<String, dynamic>;
  //     embeddedAttrs.forEach((key, value) {
  //       if (value is Map && value['color_code'] != null) {
  //         final colorCode = value['color_code'].toString();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     });
  //   }

  //   return uniqueColors.isNotEmpty ? uniqueColors.toList() : null;
  // }

  /////////////////////////////////////////////

  // static List<Color>? _parseColors(
  //   Map<Color, dynamic> embedded,
  //   Map<Color, dynamic> json,
  // ) {
  //   final Set<Color> uniqueColors = {};

  //   // Debug: Print the entire JSON to see where colors are located
  //   print("🔍 DEBUG - Looking for colors in JSON structure");

  //   // Method 1: Check main variants in the main JSON
  //   if (json['main_variants'] != null && json['main_variants'] is List) {
  //     final variants = json['main_variants'] as List;
  //     print("🎨 Found ${variants.length} main variants");

  //     for (var variant in variants) {
  //       if (variant is Map && variant['html_color_code'] != null) {
  //         final colorCode = variant['html_color_code'].toString().trim();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           print("✅ Found color: $colorCode");
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     }
  //   }

  //   // Method 2: Check main variants in embedded attributes
  //   if (embedded['main_variants'] != null && embedded['main_variants'] is List) {
  //     final variants = embedded['main_variants'] as List;
  //     print("🎨 Found ${variants.length} embedded main variants");

  //     for (var variant in variants) {
  //       if (variant is Map && variant['html_color_code'] != null) {
  //         final colorCode = variant['html_color_code'].toString().trim();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           print("✅ Found embedded color: $colorCode");
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     }
  //   }

  //   // Method 3: Check for color attributes
  //   if (json['attributes'] != null && json['attributes'] is Map) {
  //     final attributes = json['attributes'] as Map<String, dynamic>;
  //     print("🔍 Checking attributes for colors");

  //     attributes.forEach((key, value) {
  //       if (value is Map && value['color'] != null) {
  //         final colorCode = value['color'].toString().trim();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           print("✅ Found attribute color: $colorCode");
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //       if (value is Map && value['html_color_code'] != null) {
  //         final colorCode = value['html_color_code'].toString().trim();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           print("✅ Found attribute html_color: $colorCode");
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     });
  //   }

  //   // Method 4: Check combination details (common in some APIs)
  //   if (json['combinations'] != null && json['combinations'] is List) {
  //     final combinations = json['combinations'] as List;
  //     print("🔍 Checking ${combinations.length} combinations");

  //     for (var combo in combinations) {
  //       if (combo is Map && combo['html_color_code'] != null) {
  //         final colorCode = combo['html_color_code'].toString().trim();
  //         if (colorCode.isNotEmpty && colorCode != 'null') {
  //           print("✅ Found combination color: $colorCode");
  //           uniqueColors.add(colorCode);
  //         }
  //       }
  //     }
  //   }

  //   print("🎯 Total unique colors found: ${uniqueColors.length}");
  //   return uniqueColors.isNotEmpty ? uniqueColors.toList() : null;
  // }

  ////////////////////////////////////////////////////////



// class Product {
//   final int id;
//   final String reference;
//   final String name;
//   final String brand;
//   final String price;
//   final String image;
//   final String description;
//   final String? oldPrice;
//   final String? discount;
//   final Map<String, dynamic>? attributes;
//   final String? url;
//   final bool showPrice;
//   final String? weightUnit;
//   final Map<String, dynamic>? embeddedAttributes;
//   bool isFavorite;
//   bool isBestSeller;
//   final List<String>? colors;
//   final String? category;

//   Product({
//     required this.id,
//     this.reference = "",
//     required this.name,
//     required this.brand,
//     required this.price,
//     required this.image,
//     required this.description,
//     this.oldPrice,
//     this.discount,
//     this.attributes,
//     this.url,
//     this.showPrice = true,
//     this.weightUnit,
//     this.embeddedAttributes,
//     this.isFavorite = false,
//     this.isBestSeller = false,
//     this.colors,
//     this.category,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     final embedded = json['embedded_attributes'] ?? {};

//     return Product(
//       id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: embedded['name'] ?? json['name'] ?? 'No Name',
//       brand: embedded['manufacturer_name'] ?? 'No Brand',
//       price: embedded['price']?.toString() ?? json['price']?.toString() ?? '0',
//       image: _parseImageUrl(json),
//       description: _parseShortDescription(embedded, json),
//       oldPrice: embedded['price_without_reduction']?.toString(),
//       discount: _parseDiscount(embedded['reduction']),
//       attributes: json['attributes'],
//       url: json['url'],
//       showPrice: json['show_price'] ?? true,
//       weightUnit: json['weight_unit'],
//       embeddedAttributes: embedded,
//       colors: _parseColors(embedded, json),
//       category: embedded['category'] ?? json['category']?.toString(),
//     );
//   }

//   static List<String>? _parseColors(
//     Map<String, dynamic> embedded,
//     Map<String, dynamic> json,
//   ) {
//     final List<String> colors = [];
//     final Set<String> uniqueColors = {};

//     print("🔍 DEBUG: Starting color parsing");

//     // First check main response for main_variants
//     if (json['main_variants'] != null && json['main_variants'] is List) {
//       final variants = json['main_variants'] as List;
//       print("🔍 Found ${variants.length} main variants in main response");

//       for (var variant in variants) {
//         if (variant is Map && variant['html_color_code'] != null) {
//           final colorCode = variant['html_color_code'].toString();
//           if (colorCode.isNotEmpty && colorCode != 'null') {
//             print("🎨 Found color in main variants: $colorCode");
//             uniqueColors.add(colorCode);
//           }
//         }
//       }
//     }

//     // Then check embedded attributes for main_variants
//     if (embedded['main_variants'] != null &&
//         embedded['main_variants'] is List) {
//       final variants = embedded['main_variants'] as List;
//       print("🔍 Found ${variants.length} main variants in embedded attributes");

//       for (var variant in variants) {
//         if (variant is Map && variant['html_color_code'] != null) {
//           final colorCode = variant['html_color_code'].toString();
//           if (colorCode.isNotEmpty && colorCode != 'null') {
//             print("🎨 Found color in embedded variants: $colorCode");
//             uniqueColors.add(colorCode);
//           }
//         }
//       }
//     }

//     // Debug: Print all found colors
//     if (uniqueColors.isNotEmpty) {
//       print("✅ Final unique colors: ${uniqueColors.toList()}");
//     } else {
//       print("❌ No colors found in the product data");

//       // Debug: Print the structure to understand where colors might be
//       print("📋 Main response keys: ${json.keys}");
//       if (json['main_variants'] != null) {
//         print("📋 Main variants type: ${json['main_variants'].runtimeType}");
//       }

//       print("📋 Embedded attributes keys: ${embedded.keys}");
//       if (embedded['main_variants'] != null) {
//         print(
//           "📋 Embedded variants type: ${embedded['main_variants'].runtimeType}",
//         );
//       }
//     }

//     return uniqueColors.isNotEmpty ? uniqueColors.toList() : null;
//   }

//   static String _parseShortDescription(
//     Map<String, dynamic> embedded,
//     Map<String, dynamic> json,
//   ) {
//     // First try to get from embedded attributes
//     String? shortDesc = embedded['description_short']?.toString();

//     // If not found in embedded, try the main json
//     if (shortDesc == null || shortDesc.isEmpty) {
//       shortDesc = json['description_short']?.toString();
//     }

//     // Clean up HTML tags and trim
//     if (shortDesc != null && shortDesc.isNotEmpty) {
//       return _cleanHtmlTags(shortDesc);
//     }

//     return 'No Description';
//   }

//   static Map<String, String> _parseAllDescriptions(
//     Map<String, dynamic> embedded,
//     Map<String, dynamic> json,
//   ) {
//     final Map<String, String> descriptions = {};

//     // Check for language-specific descriptions in embedded attributes
//     embedded.forEach((key, value) {
//       if (key.startsWith('description_short_') && value != null) {
//         final language = key.replaceFirst('description_short_', '');
//         descriptions[language] = _cleanHtmlTags(value.toString());
//       }
//     });

//     // Check for language-specific descriptions in main json
//     json.forEach((key, value) {
//       if (key.startsWith('description_short_') && value != null) {
//         final language = key.replaceFirst('description_short_', '');
//         descriptions[language] = _cleanHtmlTags(value.toString());
//       }
//     });

//     // Add generic description as fallback (from your original code)
//     String? genericDesc = embedded['description_short']?.toString();
//     if (genericDesc == null || genericDesc.isEmpty) {
//       genericDesc = json['description_short']?.toString();
//     }
//     if (genericDesc != null && genericDesc.isNotEmpty) {
//       descriptions['default'] = _cleanHtmlTags(genericDesc);
//     }

//     // If no descriptions found at all, add a default one
//     if (descriptions.isEmpty) {
//       descriptions['default'] = 'No Description';
//     }

//     return descriptions;
//   }

//   static String _getDefaultDescription(Map<String, String> descriptions) {
//     // Return English description if available, otherwise any available description
//     return descriptions['en'] ??
//         descriptions['ar'] ??
//         descriptions['default'] ??
//         descriptions.values.first ??
//         'No Description';
//   }

//   static String _cleanHtmlTags(String htmlString) {
//     return htmlString
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll(RegExp(r'&[^;]+;'), '')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }

//   static String _parseImageUrl(Map<String, dynamic> json) {
//     if (json['images'] != null &&
//         json['images'] is List &&
//         (json['images'] as List).isNotEmpty) {
//       final images = json['images'] as List;

//       final coverImage = images.firstWhere(
//         (img) => img['cover'] == '1' || img['cover'] == 1,
//         orElse: () => images.first,
//       );

//       if (coverImage['bySize'] != null &&
//           coverImage['bySize']['large_default'] != null) {
//         return coverImage['bySize']['large_default']['url'];
//       } else if (coverImage['bySize'] != null &&
//           coverImage['bySize']['medium_default'] != null) {
//         return coverImage['bySize']['medium_default']['url'];
//       } else if (coverImage['bySize'] != null &&
//           coverImage['bySize']['home_default'] != null) {
//         return coverImage['bySize']['home_default']['url'];
//       } else if (coverImage['large'] != null) {
//         return coverImage['large']['url'];
//       } else if (coverImage['medium'] != null) {
//         return coverImage['medium']['url'];
//       }
//     }

//     if (json['id_image'] != null) {
//       return 'https://t-api.dotit-corp.com/images/products/${json['id']}/${json['id_image']}.jpg';
//     }
//     return json['image'] ?? '';
//   }

//   static String? _parseDiscount(dynamic reduction) {
//     if (reduction != null && (reduction as num) > 0) {
//       return '${(reduction * 100).toStringAsFixed(0)}% OFF';
//     }
//     return null;
//   }
// }
