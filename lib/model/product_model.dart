// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class Product {
//   final int id;
//   final String reference;
//   final String name;
//   final String? brand;
//   final double price;
//   final String image;
//   final String description;
//   final double? oldPrice;
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
//   final String? categoryCode;
//   final int? categoryId;
//   final int stock;
//   final List<String> images;
//   final String shortDescription;
//   final int quantity;
//   final bool active;
//   final List<ProductCombination> combinations;

//   Product({
//     this.id = 0,
//     this.reference = "",
//     required this.name,
//     this.brand,
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
//     this.categoryCode,
//     this.categoryId,
//     this.stock = 0,
//     this.images = const [],
//     this.shortDescription = '',
//     this.quantity = 0,
//     this.active = true,
//     this.combinations = const [],
//   });

//   /* ------------------------- COLOR & STOCK MANAGEMENT METHODS ------------------------- */

//   // Get only color combinations (filter out SKU entries)
//   List<ProductCombination> get colorCombinations {
//     return combinations.where((comb) => comb.isColorCombination).toList();
//   }

//   // Get available colors (with stock > 0)
//   List<ProductCombination> get availableColors {
//     return colorCombinations.where((comb) => comb.isAvailable).toList();
//   }

//   // Get unavailable colors (with stock = 0)
//   List<ProductCombination> get unavailableColors {
//     return colorCombinations.where((comb) => !comb.isAvailable).toList();
//   }

//   // Check if a specific color is available by name
//   bool isColorAvailable(String colorName) {
//     return colorCombinations.any(
//       (comb) =>
//           comb.colorName.toLowerCase() == colorName.toLowerCase() &&
//           comb.isAvailable,
//     );
//   }

//   // Check if a specific color is available by ID
//   bool isColorAvailableById(int attributeId) {
//     return combinations.any(
//       (comb) => comb.id == attributeId && comb.isAvailable,
//     );
//   }

//   // Get default color (prioritizes available colors)
//   ProductCombination? get defaultColor {
//     // First try to find an available default color
//     final availableDefault = colorCombinations.firstWhereOrNull(
//       (comb) => comb.defaultOn && comb.isAvailable,
//     );

//     // If no available default, try any available color
//     return availableDefault ??
//         availableColors.firstOrNull() ??
//         colorCombinations.firstOrNull();
//   }

//   // Find combination by color name
//   ProductCombination? getCombinationByColorName(String colorName) {
//     try {
//       return colorCombinations.firstWhere(
//         (comb) => comb.colorName.toLowerCase() == colorName.toLowerCase(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   // Find combination by attribute ID
//   ProductCombination? getCombination(int attributeId) {
//     try {
//       return combinations.firstWhere((combo) => combo.id == attributeId);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get unique colors (group by color code to avoid duplicates)
//   List<ProductCombination> get uniqueColors {
//     final Map<String, ProductCombination> uniqueMap = {};

//     for (var combo in colorCombinations) {
//       if (combo.hasColor && !uniqueMap.containsKey(combo.color)) {
//         uniqueMap[combo.color] = combo;
//       }
//     }

//     return uniqueMap.values.toList();
//   }

//   /* ------------------------- CART OPERATION METHODS ------------------------- */

//   // Get the correct attribute ID for cart operations
//   int? getCartAttributeId([ProductCombination? selectedColor]) {
//     // If a specific color is selected, use its attribute ID
//     if (selectedColor != null) {
//       return selectedColor.id;
//     }

//     // For products with combinations, use the default available color
//     if (colorCombinations.isNotEmpty) {
//       return defaultColor?.id;
//     }

//     // For simple products, return null (no attribute needed)
//     return null;
//   }

//   // Check if product has combinations
//   bool get hasCombinations => combinations.isNotEmpty;

//   // Check if product has color combinations
//   bool get hasColorCombinations => colorCombinations.isNotEmpty;

//   // Get all available attribute IDs from combinations
//   List<int> getAvailableAttributeIds() {
//     if (combinations.isNotEmpty) {
//       return combinations.map((combo) => combo.id).toList();
//     }
//     return [];
//   }

//   // Check if a specific attribute ID is valid for this product
//   bool isValidAttributeId(int attributeId) {
//     if (!hasCombinations) {
//       return false; // Simple products don't need attribute IDs
//     }
//     return combinations.any((combo) => combo.id == attributeId);
//   }

//   // Check if attributes map is not empty
//   bool get hasAttributes {
//     return attributes != null && attributes!.isNotEmpty;
//   }

//   // Get attribute value by key from the attributes map
//   String? getAttributeValue(String key) {
//     return attributes?[key]?.toString();
//   }

//   /* ------------------------- STOCK MANAGEMENT ------------------------- */

//   // Overall product stock status (considers all combinations)
//   bool get inStock {
//     if (hasCombinations) {
//       return combinations.any((comb) => comb.inStock);
//     }
//     return stock > 0;
//   }

//   // Stock status for a specific color
//   bool isInStockForColor(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.inStock ?? false;
//   }

//   // Get stock quantity for a specific color
//   int getStockForColor(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.stock ?? 0;
//   }

//   /* ------------------------- FACTORY METHODS ------------------------- */

//   // Factory method for detailed product parsing
//   factory Product.fromDetailedJson(Map<String, dynamic> json) {
//     print('=== PARSING DETAILED PRODUCT JSON ===');
//     print('Product name: ${json['name']}');
//     print('Product ID: ${json['id_product']}');

//     // Parse images
//     final images = _parseImages(json['images'] as List<dynamic>?);
//     print('Parsed ${images.length} images');

//     // Parse combinations with color data
//     final combinations = _parseCombinations(json);
//     print('Parsed ${combinations.length} combinations');

//     // Use main image as the first image from images list, or fallback to existing logic
//     final mainImage = images.isNotEmpty ? images.first : _parseImageUrl(json);

//     // Parse category ID
//     final categoryId = _parseCategoryId(json);

//     return Product(
//       id:
//           json['id_product'] is int
//               ? json['id_product'] as int
//               : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand:
//           json['manufacturer']?.toString() ??
//           json['manufacturer_name']?.toString() ??
//           'Unknown Brand',
//       price: _parsePrice(json['price'] ?? json['price_attribute']),
//       image: mainImage,
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       stock:
//           json['quantity'] is int
//               ? json['quantity'] as int
//               : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       images: images,
//       shortDescription:
//           json['short_description']?.toString() ??
//           json['description_short']?.toString() ??
//           '',
//       quantity:
//           json['quantity'] is int
//               ? json['quantity'] as int
//               : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       active: json['active']?.toString() == '1',
//       combinations: combinations,
//       categoryId: categoryId,
//     );
//   }

//   // Factory method for basic product parsing
//   factory Product.fromJson(Map<String, dynamic> json) {
//     print('=== PARSING PRODUCT JSON ===');
//     print('Product name: ${json['name']}');

//     // Parse ID
//     final id = _parseProductId(json);
//     print('Parsed ID: $id');

//     // Parse combinations for this product
//     final combinations = _parseCombinations(json);

//     return Product(
//       id: id,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand: json['manufacturer']?.toString() ?? 'Unknown Brand',
//       price: _parsePrice(json['price']),
//       image: _parseImageUrl(json),
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       url: json['link']?.toString(),
//       showPrice: true,
//       stock:
//           json['stock'] is int
//               ? json['stock'] as int
//               : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
//       combinations: combinations,
//       categoryId: _parseCategoryId(json),
//     );
//   }

//   // Factory method for cart product parsing
//   factory Product.fromCartJson(Map<String, dynamic> json) {
//     return Product(
//       id:
//           json['id_product'] is int
//               ? json['id_product'] as int
//               : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand: json['manufacturer_name']?.toString() ?? 'Unknown Brand',
//       price: _parsePrice(json['price'] ?? json['price_attribute']),
//       image: _parseImageUrl(json),
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       stock:
//           json['quantity_available'] is int
//               ? json['quantity_available'] as int
//               : int.tryParse(json['quantity_available']?.toString() ?? '0') ??
//                   0,
//       images: _parseImages(json['images'] as List<dynamic>?),
//       shortDescription: json['description_short']?.toString() ?? '',
//       quantity:
//           json['cart_quantity'] is int
//               ? json['cart_quantity'] as int
//               : int.tryParse(json['cart_quantity']?.toString() ?? '0') ?? 0,
//       active: json['active']?.toString() == '1',
//       combinations: _parseCombinations(json),
//       categoryId: _parseCategoryId(json),
//     );
//   }

//   /* ------------------------- STATIC PARSING METHODS ------------------------- */

//   static List<String> _parseImages(List<dynamic>? imagesJson) {
//     if (imagesJson == null || imagesJson.isEmpty) return [];

//     final List<String> images = [];
//     for (var imageUrl in imagesJson) {
//       if (imageUrl is String && imageUrl.isNotEmpty) {
//         final validatedUrl = _validateImageUrl(imageUrl);
//         if (validatedUrl.isNotEmpty) {
//           images.add(validatedUrl);
//         }
//       } else if (imageUrl is Map<String, dynamic>) {
//         // Handle image object format
//         final url = imageUrl['url']?.toString();
//         if (url != null && url.isNotEmpty) {
//           final validatedUrl = _validateImageUrl(url);
//           if (validatedUrl.isNotEmpty) {
//             images.add(validatedUrl);
//           }
//         }
//       }
//     }
//     return images;
//   }

//   static List<ProductCombination> _parseCombinations(
//     Map<String, dynamic> json,
//   ) {
//     final List<ProductCombination> combinations = [];
//     final combinationsJson = json['combinations'] ?? json['combinaisons'];

//     if (combinationsJson != null && combinationsJson is List) {
//       // Group by id_product_attribute AND attribute type to handle duplicates properly
//       final Map<String, Map<String, dynamic>> uniqueCombinations = {};

//       for (var combo in combinationsJson) {
//         if (combo is Map<String, dynamic>) {
//           final id =
//               combo['id_product_attribute'] is int
//                   ? combo['id_product_attribute'] as int
//                   : int.tryParse(
//                         combo['id_product_attribute']?.toString() ?? '',
//                       ) ??
//                       0;

//           final attributes = combo['attributes']?.toString() ?? '';
//           final attributeType =
//               attributes.contains('لون')
//                   ? 'color'
//                   : attributes.contains('Sku')
//                   ? 'sku'
//                   : 'other';

//           // Create a unique key combining ID and type
//           final uniqueKey = '$id-$attributeType';

//           if (!uniqueCombinations.containsKey(uniqueKey)) {
//             uniqueCombinations[uniqueKey] = {...combo};
//           } else {
//             // Merge missing fields for the same type
//             final existing = uniqueCombinations[uniqueKey]!;
//             if (existing['color']?.toString().isEmpty ?? true) {
//               existing['color'] = combo['color'];
//             }
//             if ((existing['images'] as List?).isNullOrEmpty) {
//               existing['images'] = combo['images'];
//             }
//             if ((existing['stock'] == null || existing['stock'] == 0) &&
//                 combo['stock'] != null) {
//               existing['stock'] = combo['stock'];
//             }
//           }
//         }
//       }

//       // Create combinations from unique entries
//       for (var comboData in uniqueCombinations.values) {
//         try {
//           combinations.add(ProductCombination.fromJson(comboData));
//         } catch (e) {
//           print('Error parsing combination: $e');
//         }
//       }
//     }

//     print('✓ Found ${combinations.length} total combinations');
//     print(
//       '✓ Color combinations: ${combinations.where((c) => c.isColorCombination).length}',
//     );

//     return combinations;
//   }

//   static int? _parseCategoryId(Map<String, dynamic> json) {
//     // Check multiple possible fields for category ID
//     if (json['id_category'] != null) {
//       if (json['id_category'] is int) return json['id_category'] as int;
//       if (json['id_category'] is String) {
//         return int.tryParse(json['id_category'] as String);
//       }
//     }

//     if (json['id_category_default'] != null) {
//       if (json['id_category_default'] is int)
//         return json['id_category_default'] as int;
//       if (json['id_category_default'] is String) {
//         return int.tryParse(json['id_category_default'] as String);
//       }
//     }

//     if (json['category_id'] != null) {
//       if (json['category_id'] is int) return json['category_id'] as int;
//       if (json['category_id'] is String) {
//         return int.tryParse(json['category_id'] as String);
//       }
//     }

//     print(' No category ID found in product detail');
//     return null;
//   }

//   static int _parseProductId(Map<String, dynamic> json) {
//     // Priority 1: id_product (from your API response)
//     if (json['id_product'] != null) {
//       if (json['id_product'] is int) return json['id_product'] as int;
//       if (json['id_product'] is String) {
//         return int.tryParse(json['id_product'] as String) ?? 0;
//       }
//     }

//     // Priority 2: id (fallback)
//     if (json['id'] != null) {
//       if (json['id'] is int) return json['id'] as int;
//       if (json['id'] is String) {
//         return int.tryParse(json['id'] as String) ?? 0;
//       }
//     }

//     return 0;
//   }

//   static double _parsePrice(dynamic priceValue) {
//     if (priceValue == null) return 0.0;

//     if (priceValue is double) return priceValue;
//     if (priceValue is int) return priceValue.toDouble();
//     if (priceValue is String) {
//       final priceString = priceValue as String;
//       print('Parsing price string: "$priceString"');

//       try {
//         // Handle "LYD120.000" and "LYD0.000" format
//         final numericString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
//         print('Numeric string: "$numericString"');

//         if (numericString.isEmpty) return 0.0;

//         final parsed = double.tryParse(numericString) ?? 0.0;
//         print('Parsed price: $parsed');
//         return parsed;
//       } catch (e) {
//         print('Price parsing error: $e');
//         return 0.0;
//       }
//     }

//     return 0.0;
//   }

//   static String _parseImageUrl(Map<String, dynamic> json) {
//     // Priority 1: Direct 'image' field from API
//     if (json['image'] != null && json['image'].toString().isNotEmpty) {
//       final imageUrl = json['image'].toString().trim();
//       if (imageUrl != 'null' && imageUrl.isNotEmpty) {
//         return _validateImageUrl(imageUrl);
//       }
//     }

//     // Priority 2: id_image field (construct URL)
//     if (json['id_image'] != null) {
//       final imageId = json['id_image'].toString();
//       if (imageId.isNotEmpty && imageId != '0') {
//         return _validateImageUrl(
//           'https://tawasul-dev.app-staging.fr/img/p/$imageId.jpg',
//         );
//       }
//     }

//     return '';
//   }

//   static String _validateImageUrl(String url) {
//     if (url.isEmpty || url == 'null') return '';

//     // If URL already has protocol, return as-is
//     if (url.startsWith('http://') || url.startsWith('https://')) {
//       return url;
//     }

//     // If URL starts with //, add https:
//     if (url.startsWith('//')) {
//       return 'https:$url';
//     }

//     // If it's a relative path starting with /, prepend domain
//     if (url.startsWith('/')) {
//       return 'https://tawasul-dev.app-staging.fr$url';
//     }

//     // For any other case, assume it's a full URL missing protocol
//     return 'https://$url';
//   }

//   static String _parseDescription(Map<String, dynamic> json) {
//     // Priority 1: description field
//     String? description = json['description']?.toString();

//     // Priority 2: description_short field
//     if (description == null || description.isEmpty) {
//       description = json['description_short']?.toString();
//     }

//     // Priority 3: name as fallback
//     if (description == null || description.isEmpty) {
//       description = json['name']?.toString() ?? 'No description available';
//     }

//     return _cleanHtmlTags(description);
//   }

//   static Map<String, dynamic>? _parseAttributes(Map<String, dynamic> json) {
//     final attributes = <String, dynamic>{};

//     // Add combination data if available
//     if (json['id_product_attribute'] != null) {
//       attributes['id_product_attribute'] = json['id_product_attribute'];
//     }

//     // Add attribute descriptions
//     if (json['attributes_small'] != null) {
//       attributes['attributes_small'] = json['attributes_small'];
//     }
//     if (json['attributes'] != null) {
//       attributes['attributes'] = json['attributes'];
//     }

//     // Add any other relevant attribute data
//     if (json['reference'] != null) {
//       attributes['reference'] = json['reference'];
//     }
//     if (json['manufacturer_name'] != null) {
//       attributes['manufacturer_name'] = json['manufacturer_name'];
//     }

//     return attributes.isNotEmpty ? attributes : null;
//   }

//   static String _cleanHtmlTags(String htmlString) {
//     if (htmlString.isEmpty) return 'No description available';

//     // Replace line breaks first
//     String cleaned = htmlString.replaceAll(
//       RegExp(r'<br\s*/?>', caseSensitive: false),
//       '\n',
//     );

//     // Remove all other HTML tags
//     cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

//     // Decode common HTML entities
//     cleaned = cleaned
//         .replaceAll('&amp;', '&')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&quot;', '"')
//         .replaceAll('&#39;', "'")
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('&#160;', ' ');

//     // Clean up whitespace
//     cleaned = cleaned.replaceAll(RegExp(r'[ \t]+'), ' ');
//     cleaned = cleaned.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
//     cleaned = cleaned.trim();

//     return cleaned.isEmpty ? 'No description available' : cleaned;
//   }

//   static String? _parseDiscount(dynamic reduction) {
//     if (reduction == null) return null;

//     try {
//       double discountValue = 0.0;

//       if (reduction is double) {
//         discountValue = reduction;
//       } else if (reduction is int) {
//         discountValue = reduction.toDouble();
//       } else if (reduction is String) {
//         discountValue = double.tryParse(reduction) ?? 0.0;
//       }

//       if (discountValue > 0) {
//         return '${(discountValue * 100).toStringAsFixed(0)}% OFF';
//       }
//     } catch (e) {
//       print('Discount parsing error: $e');
//     }

//     return null;
//   }

//   /* ------------------------- HELPER METHODS ------------------------- */

//   Product copyWith({
//     int? id,
//     String? reference,
//     String? name,
//     String? brand,
//     double? price,
//     String? image,
//     String? description,
//     double? oldPrice,
//     String? discount,
//     Map<String, dynamic>? attributes,
//     String? url,
//     bool? showPrice,
//     String? weightUnit,
//     Map<String, dynamic>? embeddedAttributes,
//     bool? isFavorite,
//     bool? isBestSeller,
//     List<Color>? colors,
//     String? category,
//     String? categoryCode,
//     int? categoryId,
//     int? stock,
//     List<String>? images,
//     String? shortDescription,
//     int? quantity,
//     bool? active,
//     List<ProductCombination>? combinations,
//   }) {
//     return Product(
//       id: id ?? this.id,
//       reference: reference ?? this.reference,
//       name: name ?? this.name,
//       brand: brand ?? this.brand,
//       price: price ?? this.price,
//       image: image ?? this.image,
//       description: description ?? this.description,
//       oldPrice: oldPrice ?? this.oldPrice,
//       discount: discount ?? this.discount,
//       attributes: attributes ?? this.attributes,
//       url: url ?? this.url,
//       showPrice: showPrice ?? this.showPrice,
//       weightUnit: weightUnit ?? this.weightUnit,
//       embeddedAttributes: embeddedAttributes ?? this.embeddedAttributes,
//       isFavorite: isFavorite ?? this.isFavorite,
//       isBestSeller: isBestSeller ?? this.isBestSeller,
//       colors: colors ?? this.colors,
//       category: category ?? this.category,
//       categoryCode: categoryCode ?? this.categoryCode,
//       categoryId: categoryId ?? this.categoryId,
//       stock: stock ?? this.stock,
//       images: images ?? this.images,
//       shortDescription: shortDescription ?? this.shortDescription,
//       quantity: quantity ?? this.quantity,
//       active: active ?? this.active,
//       combinations: combinations ?? this.combinations,
//     );
//   }

//   // Price formatting
//   String get formattedPrice {
//     return 'LYD ${price.toStringAsFixed(3)}';
//   }

//   String? get formattedOldPrice {
//     return oldPrice != null ? 'LYD ${oldPrice!.toStringAsFixed(3)}' : null;
//   }

//   // Discount calculations
//   bool get hasDiscount {
//     return oldPrice != null && oldPrice! > price;
//   }

//   double? get discountPercentage {
//     if (oldPrice != null && oldPrice! > 0 && oldPrice! > price) {
//       return ((oldPrice! - price) / oldPrice!) * 100;
//     }
//     return null;
//   }

//   // Stock information
//   String get stockStatus {
//     if (inStock) {
//       if (stock > 10) return 'In Stock';
//       return 'Low Stock';
//     }
//     return 'Out of Stock';
//   }

//   // Combination info
//   String getCombinationInfo(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.attributes ?? 'Default';
//   }

//   /* ------------------------- DEBUG & UTILITY METHODS ------------------------- */

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Product && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() {
//     return 'Product{id: $id, name: "$name", price: LYD $price, stock: $stock, colorCombinations: ${colorCombinations.length}}';
//   }

//   // Enhanced debug method
//   void printDebugInfo() {
//     print('=== PRODUCT DEBUG INFO ===');
//     print('ID: $id');
//     print('Name: $name');
//     print('Brand: $brand');
//     print('Price: LYD $price');
//     print('Stock: $stock ($stockStatus)');
//     print('Has Color Combinations: $hasColorCombinations');
//     print('Available Colors: ${availableColors.length}');
//     print('Unavailable Colors: ${unavailableColors.length}');
//     print('All Combinations: ${combinations.length}');
//     print('Color Combinations: ${colorCombinations.length}');
//     for (var combo in colorCombinations) {
//       print(
//         '  - Color: ${combo.colorName}, ID: ${combo.id}, Stock: ${combo.stock}, Available: ${combo.isAvailable}',
//       );
//     }
//     print('Default Color: ${defaultColor?.colorName}');
//     print('==========================');
//   }

//   // Convert to map for serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'reference': reference,
//       'name': name,
//       'brand': brand,
//       'price': price,
//       'image': image,
//       'description': description,
//       'oldPrice': oldPrice,
//       'discount': discount,
//       'attributes': attributes,
//       'url': url,
//       'stock': stock,
//       'images': images,
//       'shortDescription': shortDescription,
//       'quantity': quantity,
//       'active': active,
//       'combinations': combinations.map((combo) => combo.toJson()).toList(),
//       'categoryId': categoryId,
//     };
//   }
// }

// class ProductCombination {
//   final int id;
//   final String reference;
//   final int quantity;
//   final int stock;
//   final String attributes;
//   final double price;
//   final String color;
//   final bool defaultOn;
//   final List<String> images;

//   ProductCombination({
//     required this.id,
//     required this.reference,
//     required this.quantity,
//     required this.stock,
//     required this.attributes,
//     required this.price,
//     required this.color,
//     required this.defaultOn,
//     required this.images,
//   });

//   factory ProductCombination.fromJson(Map<String, dynamic> json) {
//     return ProductCombination(
//       id:
//           json['id_product_attribute'] is int
//               ? json['id_product_attribute'] as int
//               : int.tryParse(json['id_product_attribute']?.toString() ?? '') ??
//                   0,
//       reference: json['reference']?.toString() ?? '',
//       quantity:
//           json['quantity'] is int
//               ? json['quantity'] as int
//               : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       stock:
//           json['stock'] is int
//               ? json['stock'] as int
//               : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
//       attributes:
//           json['attributes_small']?.toString() ??
//           json['attributes']?.toString() ??
//           json['attribute_description']?.toString() ??
//           '',
//       price: Product._parsePrice(json['price_attribute'] ?? json['price']),
//       color: json['color']?.toString() ?? '',
//       defaultOn: json['default'] ?? false,
//       images: Product._parseImages(json['images'] as List<dynamic>?),
//     );
//   }

//   // CORRECTED: Availability based on stock, not default_on
//   bool get isAvailable => stock > 0;

//   // Check if this is a color combination (not SKU)
//   bool get isColorCombination => attributes.contains('لون') && color.isNotEmpty;

//   // Get color name from attributes
//   String get colorName {
//     if (attributes.contains(' - ')) {
//       return attributes.split(' - ').last.trim();
//     }
//     return attributes;
//   }

//   // Check if this combination has color data
//   bool get hasColor => color.isNotEmpty && isColorCombination;

//   // Get color from hex code
//   Color get colorValue {
//     if (color.isEmpty) return Colors.grey;

//     try {
//       String hexColor = color.replaceAll('#', '');
//       if (hexColor.length == 6) {
//         hexColor = 'FF$hexColor';
//       }
//       if (hexColor.length == 8) {
//         return Color(int.parse(hexColor, radix: 16));
//       }
//     } catch (e) {
//       print('Color parsing error for $color: $e');
//     }

//     return Colors.grey;
//   }

//   // Check if color is light (for text contrast)
//   bool get isLightColor {
//     final color = colorValue;
//     final luminance = color.computeLuminance();
//     return luminance > 0.5;
//   }

//   // Stock status
//   bool get inStock => isAvailable;

//   // Convert to map for serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'id_product_attribute': id,
//       'reference': reference,
//       'quantity': quantity,
//       'stock': stock,
//       'attributes': attributes,
//       'price': price,
//       'color': color,
//       'default': defaultOn,
//       'images': images,
//     };
//   }

//   ProductCombination copyWith({
//     int? id,
//     String? reference,
//     int? quantity,
//     int? stock,
//     String? attributes,
//     double? price,
//     String? color,
//     bool? defaultOn,
//     List<String>? images,
//   }) {
//     return ProductCombination(
//       id: id ?? this.id,
//       reference: reference ?? this.reference,
//       quantity: quantity ?? this.quantity,
//       stock: stock ?? this.stock,
//       attributes: attributes ?? this.attributes,
//       price: price ?? this.price,
//       color: color ?? this.color,
//       defaultOn: defaultOn ?? this.defaultOn,
//       images: images ?? this.images,
//     );
//   }

//   @override
//   String toString() {
//     return 'ProductCombination{id: $id, name: $colorName, stock: $stock, available: $isAvailable}';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ProductCombination &&
//           runtimeType == other.runtimeType &&
//           id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// extension FirstWhereOrNull<T> on Iterable<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     for (var element in this) {
//       if (test(element)) {
//         return element;
//       }
//     }
//     return null;
//   }
// }

// // Extension for firstOrNull utility
// extension FirstOrNull<T> on Iterable<T> {
//   T? firstOrNull() {
//     try {
//       return first;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// // Extension for null safety
// extension NullSafetyCheck on List? {
//   bool get isNullOrEmpty => this == null || this!.isEmpty;
// }

// // Extension for cart-specific operations
// extension CartProductExtension on Product {
//   // Check if this product can be added to cart
//   bool get canAddToCart => inStock && active;

//   // Check if specific color can be added to cart
//   bool canAddColorToCart(int attributeId) {
//     return isInStockForColor(attributeId) && active;
//   }

//   // Get max quantity that can be added to cart
//   int get maxCartQuantity {
//     return stock;
//   }

//   // Validate quantity for cart
//   bool isValidQuantity(int quantity) {
//     return quantity > 0 && quantity <= maxCartQuantity;
//   }

//   // Get display name with combination info
//   String getDisplayName([int? attributeId]) {
//     if (attributeId != null && hasCombinations) {
//       final combo = getCombination(attributeId);
//       if (combo != null) {
//         return '$name - ${combo.colorName}';
//       }
//     }
//     return name;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Product {
  final int id;
  final String reference;
  final String name;
  final String? brand;
  final double price;
  final String image;
  final String description;
  final double? oldPrice;
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
  final int? categoryId;
  final int stock;
  final List<String> images;
  final String shortDescription;
  final int quantity;
  final bool active;
  final List<ProductCombination> combinations;

  Product({
    this.id = 0,
    this.reference = "",
    required this.name,
    this.brand,
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
    this.categoryId,
    this.stock = 0,
    this.images = const [],
    this.shortDescription = '',
    this.quantity = 0,
    this.active = true,
    this.combinations = const [],
  });

  /* ------------------------- COLOR & STOCK MANAGEMENT METHODS ------------------------- */

  // Get only color combinations (filter out SKU entries)
  List<ProductCombination> get colorCombinations {
    return combinations.where((comb) => comb.isColorCombination).toList();
  }

  // Get available colors (with stock > 0)
  List<ProductCombination> get availableColors {
    return colorCombinations.where((comb) => comb.isAvailable).toList();
  }

  // Get unavailable colors (with stock = 0)
  List<ProductCombination> get unavailableColors {
    return colorCombinations.where((comb) => !comb.isAvailable).toList();
  }

  // Check if a specific color is available by name
  bool isColorAvailable(String colorName) {
    return colorCombinations.any(
      (comb) =>
          comb.colorName.toLowerCase() == colorName.toLowerCase() &&
          comb.isAvailable,
    );
  }

  // Check if a specific color is available by ID
  bool isColorAvailableById(int attributeId) {
    return combinations.any(
      (comb) => comb.id == attributeId && comb.isAvailable,
    );
  }

  // Get default color (prioritizes available colors)
  ProductCombination? get defaultColor {
    // First try to find an available default color
    final availableDefault = colorCombinations.firstWhereOrNull(
      (comb) => comb.defaultOn == 1 && comb.isAvailable,
    );

    // If no available default, try any available color
    return availableDefault ??
        availableColors.firstOrNull() ??
        colorCombinations.firstOrNull();
  }

  // Find combination by color name
  ProductCombination? getCombinationByColorName(String colorName) {
    try {
      return colorCombinations.firstWhere(
        (comb) => comb.colorName.toLowerCase() == colorName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Find combination by attribute ID
  ProductCombination? getCombination(int attributeId) {
    try {
      return combinations.firstWhere((combo) => combo.id == attributeId);
    } catch (e) {
      return null;
    }
  }

  // Get unique colors (group by color code to avoid duplicates)
  List<ProductCombination> get uniqueColors {
    final Map<String, ProductCombination> uniqueMap = {};

    for (var combo in colorCombinations) {
      if (combo.hasColor && !uniqueMap.containsKey(combo.codeColeur)) {
        uniqueMap[combo.codeColeur] = combo;
      }
    }

    return uniqueMap.values.toList();
  }

  /* ------------------------- CART OPERATION METHODS ------------------------- */

  // Get the correct attribute ID for cart operations
  int? getCartAttributeId([ProductCombination? selectedColor]) {
    // If a specific color is selected, use its attribute ID
    if (selectedColor != null) {
      return selectedColor.id;
    }

    // For products with combinations, use the default available color
    if (colorCombinations.isNotEmpty) {
      return defaultColor?.id;
    }

    // For simple products, return null (no attribute needed)
    return null;
  }

  // Check if product has combinations
  bool get hasCombinations => combinations.isNotEmpty;

  // Check if product has color combinations
  bool get hasColorCombinations => colorCombinations.isNotEmpty;

  // Get all available attribute IDs from combinations
  List<int> getAvailableAttributeIds() {
    if (combinations.isNotEmpty) {
      return combinations.map((combo) => combo.id).toList();
    }
    return [];
  }

  // Check if a specific attribute ID is valid for this product
  bool isValidAttributeId(int attributeId) {
    if (!hasCombinations) {
      return false; // Simple products don't need attribute IDs
    }
    return combinations.any((combo) => combo.id == attributeId);
  }

  // Check if attributes map is not empty
  bool get hasAttributes {
    return attributes != null && attributes!.isNotEmpty;
  }

  // Get attribute value by key from the attributes map
  String? getAttributeValue(String key) {
    return attributes?[key]?.toString();
  }

  /* ------------------------- STOCK MANAGEMENT ------------------------- */

  // Overall product stock status (considers all combinations)
  bool get inStock {
    if (hasCombinations) {
      return combinations.any((comb) => comb.inStock);
    }
    return stock > 0;
  }

  // Stock status for a specific color
  bool isInStockForColor(int attributeId) {
    final combo = getCombination(attributeId);
    return combo?.inStock ?? false;
  }

  // Get stock quantity for a specific color
  int getStockForColor(int attributeId) {
    final combo = getCombination(attributeId);
    return combo?.quantity ?? 0;
  }

  /* ------------------------- FACTORY METHODS ------------------------- */

  // Factory method for detailed product parsing
  factory Product.fromDetailedJson(Map<String, dynamic> json) {
    print('=== PARSING DETAILED PRODUCT JSON ===');
    print('Product name: ${json['name']}');
    print('Product ID: ${json['id_product']}');

    // Parse images
    final images = _parseImages(json['images'] as List<dynamic>?);
    print('Parsed ${images.length} images');

    // Parse combinations with color data - FIXED: Use enhanced parsing
    final combinations = _parseCombinationsEnhanced(json);
    print('Parsed ${combinations.length} combinations');

    // Use main image as the first image from images list, or fallback to existing logic
    final mainImage = images.isNotEmpty ? images.first : _parseImageUrl(json);

    // Parse category ID
    final categoryId = _parseCategoryId(json);

    return Product(
      id: json['id_product'] is int
          ? json['id_product'] as int
          : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
      reference: json['reference']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      brand: json['manufacturer']?.toString() ??
          json['manufacturer_name']?.toString() ??
          'Unknown Brand',
      price: _parsePrice(json['price'] ?? json['price_attribute']),
      image: mainImage,
      description: _parseDescription(json),
      oldPrice: _parsePrice(json['price_without_reduction']),
      discount: _parseDiscount(json['reduction']),
      attributes: _parseAttributes(json),
      stock: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      images: images,
      shortDescription: json['short_description']?.toString() ??
          json['description_short']?.toString() ??
          '',
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      active: json['active']?.toString() == '1',
      combinations: combinations,
      categoryId: categoryId,
    );
  }

  // Factory method for basic product parsing
  factory Product.fromJson(Map<String, dynamic> json) {
    print('=== PARSING PRODUCT JSON ===');
    print('Product name: ${json['name']}');

    // Parse ID
    final id = _parseProductId(json);
    print('Parsed ID: $id');

    // Parse combinations for this product
    final combinations = _parseCombinationsEnhanced(json);

    return Product(
      id: id,
      reference: json['reference']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      brand: json['manufacturer']?.toString() ?? 'Unknown Brand',
      price: _parsePrice(json['price']),
      image: _parseImageUrl(json),
      description: _parseDescription(json),
      oldPrice: _parsePrice(json['price_without_reduction']),
      discount: _parseDiscount(json['reduction']),
      attributes: _parseAttributes(json),
      url: json['link']?.toString(),
      showPrice: true,
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      combinations: combinations,
      categoryId: _parseCategoryId(json),
    );
  }

  // Factory method for cart product parsing
  factory Product.fromCartJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_product'] is int
          ? json['id_product'] as int
          : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
      reference: json['reference']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      brand: json['manufacturer_name']?.toString() ?? 'Unknown Brand',
      price: _parsePrice(json['price'] ?? json['price_attribute']),
      image: _parseImageUrl(json),
      description: _parseDescription(json),
      oldPrice: _parsePrice(json['price_without_reduction']),
      discount: _parseDiscount(json['reduction']),
      attributes: _parseAttributes(json),
      stock: json['quantity_available'] is int
          ? json['quantity_available'] as int
          : int.tryParse(json['quantity_available']?.toString() ?? '0') ?? 0,
      images: _parseImages(json['images'] as List<dynamic>?),
      shortDescription: json['description_short']?.toString() ?? '',
      quantity: json['cart_quantity'] is int
          ? json['cart_quantity'] as int
          : int.tryParse(json['cart_quantity']?.toString() ?? '0') ?? 0,
      active: json['active']?.toString() == '1',
      combinations: _parseCombinationsEnhanced(json),
      categoryId: _parseCategoryId(json),
    );
  }

  /* ------------------------- STATIC PARSING METHODS ------------------------- */

  static List<String> _parseImages(List<dynamic>? imagesJson) {
    if (imagesJson == null || imagesJson.isEmpty) return [];

    final List<String> images = [];
    for (var imageUrl in imagesJson) {
      if (imageUrl is String && imageUrl.isNotEmpty) {
        final validatedUrl = _validateImageUrl(imageUrl);
        if (validatedUrl.isNotEmpty) {
          images.add(validatedUrl);
        }
      } else if (imageUrl is Map<String, dynamic>) {
        // Handle image object format
        final url = imageUrl['url']?.toString();
        if (url != null && url.isNotEmpty) {
          final validatedUrl = _validateImageUrl(url);
          if (validatedUrl.isNotEmpty) {
            images.add(validatedUrl);
          }
        }
      }
    }
    return images;
  }

  // ENHANCED: Fixed combination parsing method
  static List<ProductCombination> _parseCombinationsEnhanced(
    Map<String, dynamic> json,
  ) {
    final List<ProductCombination> combinations = [];

    // Check multiple possible locations for combinations
    final combinationsJson = json['combinations'] ?? json['combinaisons'];

    if (combinationsJson != null && combinationsJson is List) {
      print("🔄 Found ${combinationsJson.length} raw combinations");

      // Filter out SKU entries and keep only color combinations
      final colorCombinations = combinationsJson.where((combo) {
        if (combo is! Map<String, dynamic>) return false;

        final colorCode = combo['color']?.toString() ?? '';
        final attributes = combo['attributes']?.toString() ?? '';

        // Keep entries that have color data and are not SKU entries
        final hasColor = colorCode.isNotEmpty && colorCode != "#";
        final isSku = attributes.contains("Sku") || attributes.contains("SKU");

        return hasColor && !isSku;
      }).toList();

      print("🎨 Filtered to ${colorCombinations.length} color combinations");

      // Create ProductCombination objects
      for (var comboData in colorCombinations) {
        try {
          final combination = ProductCombination.fromJson(comboData);

          // Debug info
          print("   ✅ ${combination.colorName}: ${combination.codeColeur} "
              "(Qty: ${combination.quantity}, Available: ${combination.isAvailable})");

          combinations.add(combination);
        } catch (e) {
          print('❌ Error parsing combination: $e');
          print('   Problematic data: $comboData');
        }
      }
    }

    // If no combinations but we have id_product_attribute in main object,
    // create a default combination
    if (combinations.isEmpty && json['id_product_attribute'] != null) {
      final attributeId = json['id_product_attribute'];
      combinations.add(
        ProductCombination(
          id: attributeId is int
              ? attributeId
              : int.tryParse(attributeId.toString()) ?? 0,
          reference: json['reference']?.toString() ?? '',
          quantity: json['quantity'] is int
              ? json['quantity'] as int
              : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
          attributes: json['attributes_small']?.toString() ??
              json['attributes']?.toString() ??
              '',
          price: _parsePrice(json['price_attribute'] ?? json['price']),
          inStock: (json['quantity'] ?? 0) > 0,
          defaultOn: json['default_on'] is int
              ? json['default_on'] as int
              : int.tryParse(json['default_on']?.toString() ?? '0') ?? 0,
          idAttributeGroup: json['id_attribute_group']?.toString() ?? '',
          idAttribute: json['id_attribute']?.toString() ?? '',
          codeColeur: json['code_coleur']?.toString() ?? '',
          name: json['name']?.toString() ?? '',
        ),
      );
    }

    print('✓ Found ${combinations.length} unique combinations');
    for (var combo in combinations) {
      print(
        '  - Combination ID: ${combo.id}, Color: ${combo.colorName}, Quantity: ${combo.quantity}, Available: ${combo.isAvailable}',
      );
    }

    return combinations;
  }

  // Keep original method for backward compatibility
  static List<ProductCombination> _parseCombinations(Map<String, dynamic> json) {
    return _parseCombinationsEnhanced(json);
  }

  static int? _parseCategoryId(Map<String, dynamic> json) {
    // Check multiple possible fields for category ID
    if (json['id_category'] != null) {
      if (json['id_category'] is int) return json['id_category'] as int;
      if (json['id_category'] is String) {
        return int.tryParse(json['id_category'] as String);
      }
    }

    if (json['id_category_default'] != null) {
      if (json['id_category_default'] is int)
        return json['id_category_default'] as int;
      if (json['id_category_default'] is String) {
        return int.tryParse(json['id_category_default'] as String);
      }
    }

    if (json['category_id'] != null) {
      if (json['category_id'] is int) return json['category_id'] as int;
      if (json['category_id'] is String) {
        return int.tryParse(json['category_id'] as String);
      }
    }

    print(' No category ID found in product detail');
    return null;
  }

  static int _parseProductId(Map<String, dynamic> json) {
    // Priority 1: id_product (from your API response)
    if (json['id_product'] != null) {
      if (json['id_product'] is int) return json['id_product'] as int;
      if (json['id_product'] is String) {
        return int.tryParse(json['id_product'] as String) ?? 0;
      }
    }

    // Priority 2: id (fallback)
    if (json['id'] != null) {
      if (json['id'] is int) return json['id'] as int;
      if (json['id'] is String) {
        return int.tryParse(json['id'] as String) ?? 0;
      }
    }

    return 0;
  }

  static double _parsePrice(dynamic priceValue) {
    if (priceValue == null) return 0.0;

    if (priceValue is double) return priceValue;
    if (priceValue is int) return priceValue.toDouble();
    if (priceValue is String) {
      final priceString = priceValue as String;
      print('Parsing price string: "$priceString"');

      try {
        // Handle "LYD120.000" and "LYD0.000" format
        final numericString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
        print('Numeric string: "$numericString"');

        if (numericString.isEmpty) return 0.0;

        final parsed = double.tryParse(numericString) ?? 0.0;
        print('Parsed price: $parsed');
        return parsed;
      } catch (e) {
        print('Price parsing error: $e');
        return 0.0;
      }
    }

    return 0.0;
  }

  static String _parseImageUrl(Map<String, dynamic> json) {
    // Priority 1: Direct 'image' field from API
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final imageUrl = json['image'].toString().trim();
      if (imageUrl != 'null' && imageUrl.isNotEmpty) {
        return _validateImageUrl(imageUrl);
      }
    }

    // Priority 2: id_image field (construct URL)
    if (json['id_image'] != null) {
      final imageId = json['id_image'].toString();
      if (imageId.isNotEmpty && imageId != '0') {
        return _validateImageUrl(
          'https://tawasul-dev.app-staging.fr/img/p/$imageId.jpg',
        );
      }
    }

    return '';
  }

  static String _validateImageUrl(String url) {
    if (url.isEmpty || url == 'null') return '';

    // If URL already has protocol, return as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // If URL starts with //, add https:
    if (url.startsWith('//')) {
      return 'https:$url';
    }

    // If it's a relative path starting with /, prepend domain
    if (url.startsWith('/')) {
      return 'https://tawasul-dev.app-staging.fr$url';
    }

    // For any other case, assume it's a full URL missing protocol
    return 'https://$url';
  }

  static String _parseDescription(Map<String, dynamic> json) {
    // Priority 1: description field
    String? description = json['description']?.toString();

    // Priority 2: description_short field
    if (description == null || description.isEmpty) {
      description = json['description_short']?.toString();
    }

    // Priority 3: name as fallback
    if (description == null || description.isEmpty) {
      description = json['name']?.toString() ?? 'No description available';
    }

    return _cleanHtmlTags(description);
  }

  static Map<String, dynamic>? _parseAttributes(Map<String, dynamic> json) {
    final attributes = <String, dynamic>{};

    // Add combination data if available
    if (json['id_product_attribute'] != null) {
      attributes['id_product_attribute'] = json['id_product_attribute'];
    }

    // Add attribute descriptions
    if (json['attributes_small'] != null) {
      attributes['attributes_small'] = json['attributes_small'];
    }
    if (json['attributes'] != null) {
      attributes['attributes'] = json['attributes'];
    }

    // Add any other relevant attribute data
    if (json['reference'] != null) {
      attributes['reference'] = json['reference'];
    }
    if (json['manufacturer_name'] != null) {
      attributes['manufacturer_name'] = json['manufacturer_name'];
    }

    return attributes.isNotEmpty ? attributes : null;
  }

  static String _cleanHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return 'No description available';

    // Replace line breaks first
    String cleaned = htmlString.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );

    // Remove all other HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode common HTML entities
    cleaned = cleaned
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#160;', ' ');

    // Clean up whitespace
    cleaned = cleaned.replaceAll(RegExp(r'[ \t]+'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
    cleaned = cleaned.trim();

    return cleaned.isEmpty ? 'No description available' : cleaned;
  }

  static String? _parseDiscount(dynamic reduction) {
    if (reduction == null) return null;

    try {
      double discountValue = 0.0;

      if (reduction is double) {
        discountValue = reduction;
      } else if (reduction is int) {
        discountValue = reduction.toDouble();
      } else if (reduction is String) {
        discountValue = double.tryParse(reduction) ?? 0.0;
      }

      if (discountValue > 0) {
        return '${(discountValue * 100).toStringAsFixed(0)}% OFF';
      }
    } catch (e) {
      print('Discount parsing error: $e');
    }

    return null;
  }

  /* ------------------------- HELPER METHODS ------------------------- */

  Product copyWith({
    int? id,
    String? reference,
    String? name,
    String? brand,
    double? price,
    String? image,
    String? description,
    double? oldPrice,
    String? discount,
    Map<String, dynamic>? attributes,
    String? url,
    bool? showPrice,
    String? weightUnit,
    Map<String, dynamic>? embeddedAttributes,
    bool? isFavorite,
    bool? isBestSeller,
    List<Color>? colors,
    String? category,
    String? categoryCode,
    int? categoryId,
    int? stock,
    List<String>? images,
    String? shortDescription,
    int? quantity,
    bool? active,
    List<ProductCombination>? combinations,
  }) {
    return Product(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      oldPrice: oldPrice ?? this.oldPrice,
      discount: discount ?? this.discount,
      attributes: attributes ?? this.attributes,
      url: url ?? this.url,
      showPrice: showPrice ?? this.showPrice,
      weightUnit: weightUnit ?? this.weightUnit,
      embeddedAttributes: embeddedAttributes ?? this.embeddedAttributes,
      isFavorite: isFavorite ?? this.isFavorite,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      colors: colors ?? this.colors,
      category: category ?? this.category,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryId: categoryId ?? this.categoryId,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      shortDescription: shortDescription ?? this.shortDescription,
      quantity: quantity ?? this.quantity,
      active: active ?? this.active,
      combinations: combinations ?? this.combinations,
    );
  }

  // Price formatting
  String get formattedPrice {
    return 'LYD ${price.toStringAsFixed(3)}';
  }

  String? get formattedOldPrice {
    return oldPrice != null ? 'LYD ${oldPrice!.toStringAsFixed(3)}' : null;
  }

  // Discount calculations
  bool get hasDiscount {
    return oldPrice != null && oldPrice! > price;
  }

  double? get discountPercentage {
    if (oldPrice != null && oldPrice! > 0 && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice!) * 100;
    }
    return null;
  }

  // Stock information
  String get stockStatus {
    if (inStock) {
      if (stock > 10) return 'In Stock';
      return 'Low Stock';
    }
    return 'Out of Stock';
  }

  // Combination info
  String getCombinationInfo(int attributeId) {
    final combo = getCombination(attributeId);
    return combo?.attributes ?? 'Default';
  }

  /* ------------------------- DEBUG & UTILITY METHODS ------------------------- */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: "$name", price: LYD $price, stock: $stock, colorCombinations: ${colorCombinations.length}}';
  }

  // Enhanced debug method
  void printDebugInfo() {
    print('=== PRODUCT DEBUG INFO ===');
    print('ID: $id');
    print('Name: $name');
    print('Brand: $brand');
    print('Price: LYD $price');
    print('Stock: $stock ($stockStatus)');
    print('Has Color Combinations: $hasColorCombinations');
    print('Available Colors: ${availableColors.length}');
    print('Unavailable Colors: ${unavailableColors.length}');
    print('All Combinations: ${combinations.length}');
    print('Color Combinations: ${colorCombinations.length}');
    for (var combo in colorCombinations) {
      print(
        '  - Color: ${combo.colorName}, ID: ${combo.id}, Quantity: ${combo.quantity}, Available: ${combo.isAvailable}',
      );
    }
    print('Default Color: ${defaultColor?.colorName}');
    print('==========================');
  }

  // Convert to map for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'name': name,
      'brand': brand,
      'price': price,
      'image': image,
      'description': description,
      'oldPrice': oldPrice,
      'discount': discount,
      'attributes': attributes,
      'url': url,
      'stock': stock,
      'images': images,
      'shortDescription': shortDescription,
      'quantity': quantity,
      'active': active,
      'combinations': combinations.map((combo) => combo.toJson()).toList(),
      'categoryId': categoryId,
    };
  }

  getImagesForColor(ProductCombination? selectedColor) {}
}

class ProductCombination {
  final int id;
  final String reference;
  final int quantity;
  final String attributes;
  final double price;
  final bool inStock;
  final int defaultOn;
  final String idAttributeGroup;
  final String idAttribute;
  final String codeColeur;
  final String name;

  ProductCombination({
    required this.id,
    required this.reference,
    required this.quantity,
    required this.attributes,
    required this.price,
    this.inStock = true,
    this.defaultOn = 0,
    this.idAttributeGroup = '',
    this.idAttribute = '',
    this.codeColeur = '',
    this.name = '',
  });

  factory ProductCombination.fromJson(Map<String, dynamic> json) {
    return ProductCombination(
      id: json['id_product_attribute'] is int
          ? json['id_product_attribute'] as int
          : int.tryParse(json['id_product_attribute']?.toString() ?? '') ?? 0,
      reference: json['reference']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      attributes: json['attributes_small']?.toString() ??
          json['attributes']?.toString() ??
          json['attribute_description']?.toString() ??
          '',
      price: Product._parsePrice(json['price_attribute'] ?? json['price']),
      inStock: (json['quantity'] ?? 0) > 0,
      defaultOn: json['default_on'] is int
          ? json['default_on'] as int
          : int.tryParse(json['default_on']?.toString() ?? '0') ?? 0,
      idAttributeGroup: json['id_attribute_group']?.toString() ?? '',
      idAttribute: json['id_attribute']?.toString() ?? '',
      codeColeur: json['code_coleur']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  // IMPROVED: Better color detection
  bool get isColorCombination {
    // Check if this has color data and is not a SKU entry
    final hasColorData = codeColeur.isNotEmpty && codeColeur != "#";
    final isSkuEntry = attributes.contains("Sku") || attributes.contains("SKU");

    return hasColorData && !isSkuEntry;
  }

  // IMPROVED: More robust color name extraction
  String get colorName {
    // Extract from attributes like "لون - Blue" or "Color - White"
    if (attributes.contains(" - ")) {
      final parts = attributes.split(" - ");
      if (parts.length >= 2) {
        return parts[1].trim();
      }
    }

    // Fallback to name field if available
    if (name.isNotEmpty) return name;

    // Final fallback
    return "Color ${id}";
  }

  // IMPROVED: Better color parsing
  Color get colorValue {
    if (codeColeur.isEmpty || codeColeur == "#") return Colors.grey;

    try {
      String hexColor = codeColeur.replaceAll('#', '');

      // Handle different hex formats
      if (hexColor.length == 3) {
        hexColor =
            'FF${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}';
      } else if (hexColor.length == 6) {
        hexColor = 'FF$hexColor'; // Add alpha value
      } else if (hexColor.length == 8) {
        // Already has alpha, use as-is
      } else {
        return Colors.grey;
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      print('Color parsing error for "$codeColeur": $e');
      return Colors.grey;
    }
  }

  // IMPROVED: Availability check
  bool get isAvailable => quantity > 0;

  // Check if this combination has color data
  bool get hasColor => codeColeur.isNotEmpty && name.isNotEmpty;

  // Stock status alias for consistency
 // bool get inStock => isAvailable;

  // Convert to map for serialization
  Map<String, dynamic> toJson() {
    return {
      'id_product_attribute': id,
      'reference': reference,
      'quantity': quantity,
      'attributes': attributes,
      'price': price,
      'inStock': inStock,
      'default_on': defaultOn,
      'id_attribute_group': idAttributeGroup,
      'id_attribute': idAttribute,
      'code_coleur': codeColeur,
      'name': name,
    };
  }

  ProductCombination copyWith({
    int? id,
    String? reference,
    int? quantity,
    String? attributes,
    double? price,
    bool? inStock,
    int? defaultOn,
    String? idAttributeGroup,
    String? idAttribute,
    String? codeColeur,
    String? name,
  }) {
    return ProductCombination(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      quantity: quantity ?? this.quantity,
      attributes: attributes ?? this.attributes,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      defaultOn: defaultOn ?? this.defaultOn,
      idAttributeGroup: idAttributeGroup ?? this.idAttributeGroup,
      idAttribute: idAttribute ?? this.idAttribute,
      codeColeur: codeColeur ?? this.codeColeur,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'ProductCombination{id: $id, name: $name, available: $isAvailable, color: $codeColeur, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCombination &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? firstOrNull() {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }
}

extension NullSafetyCheck on List? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// Extension for cart-specific operations
extension CartProductExtension on Product {
  // Check if this product can be added to cart
  bool get canAddToCart => inStock && active;

  // Check if specific color can be added to cart
  bool canAddColorToCart(int attributeId) {
    return isInStockForColor(attributeId) && active;
  }

  // Get max quantity that can be added to cart
  int get maxCartQuantity {
    return stock;
  }

  // Validate quantity for cart
  bool isValidQuantity(int quantity) {
    return quantity > 0 && quantity <= maxCartQuantity;
  }

  // Get display name with combination info
  String getDisplayName([int? attributeId]) {
    if (attributeId != null && hasCombinations) {
      final combo = getCombination(attributeId);
      if (combo != null) {
        return '$name - ${combo.colorName}';
      }
    }
    return name;
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class Product {
//   final int id;
//   final String reference;
//   final String name;
//   final String? brand;
//   final double price;
//   final String image;
//   final String description;
//   final double? oldPrice;
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
//   final String? categoryCode;
//   final int? categoryId;
//   final int stock;
//   final List<String> images;
//   final String shortDescription;
//   final int quantity;
//   final bool active;
//   final List<ProductCombination> combinations;

//   Product({
//     this.id = 0,
//     this.reference = "",
//     required this.name,
//     this.brand,
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
//     this.categoryCode,
//     this.categoryId,
//     this.stock = 0,
//     this.images = const [],
//     this.shortDescription = '',
//     this.quantity = 0,
//     this.active = true,
//     this.combinations = const [],
//   });

//   /* ------------------------- COLOR & STOCK MANAGEMENT METHODS ------------------------- */

//   List<ProductCombination> get colorCombinations {
//     return combinations.where((comb) => comb.isColorCombination).toList();
//   }

//   List<ProductCombination> get availableColors {
//     return colorCombinations.where((comb) => comb.isAvailable).toList();
//   }

//   List<ProductCombination> get unavailableColors {
//     return colorCombinations.where((comb) => !comb.isAvailable).toList();
//   }

//   // Check if a specific color is available by name
//   bool isColorAvailable(String colorName) {
//     return colorCombinations.any(
//       (comb) =>
//           comb.colorName.toLowerCase() == colorName.toLowerCase() &&
//           comb.isAvailable,
//     );
//   }

//   // Check if a specific color is available by ID
//   bool isColorAvailableById(int attributeId) {
//     return combinations.any(
//       (comb) => comb.id == attributeId && comb.isAvailable,
//     );
//   }

//   // Get default color (prioritizes available colors)
//   ProductCombination? get defaultColor {
//     // First try to find default available color
//     var defaultCombo = colorCombinations.firstWhereOrNull(
//       (comb) => comb.defaultOn == 1 && comb.isAvailable,
//     );

//     // If no available default, try any default
//     defaultCombo ??= colorCombinations.firstWhereOrNull(
//       (comb) => comb.defaultOn == 1,
//     );

//     // If still no default, try first available - FIXED: Call the function
//     defaultCombo ??= availableColors.isNotEmpty ? availableColors.first : null;

//     // Final fallback: first color - FIXED: Call the function
//     defaultCombo ??=
//         colorCombinations.isNotEmpty ? colorCombinations.first : null;

//     print(
//       "🎯 Default color selected: ${defaultCombo?.colorName} "
//       "(Available: ${defaultCombo?.isAvailable})",
//     );

//     return defaultCombo;
//   }

//   bool get hasAvailableColors => availableColors.isNotEmpty;
//   List<String> getImagesForColor(ProductCombination? colorCombo) {
//     if (colorCombo == null || colorCombo.images.isEmpty) {
//       return images.isNotEmpty ? images : [image];
//     }
//     return colorCombo.images;
//   }

//   // Find combination by color name
//   ProductCombination? getCombinationByColorName(String colorName) {
//     try {
//       return colorCombinations.firstWhere(
//         (comb) => comb.colorName.toLowerCase() == colorName.toLowerCase(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   // Find combination by attribute ID
//   ProductCombination? getCombination(int attributeId) {
//     try {
//       return combinations.firstWhere((combo) => combo.id == attributeId);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get unique colors (group by color code to avoid duplicates)
//   List<ProductCombination> get uniqueColors {
//     final Map<String, ProductCombination> uniqueMap = {};

//     for (var combo in colorCombinations) {
//       if (combo.hasColor && !uniqueMap.containsKey(combo.codeColeur)) {
//         uniqueMap[combo.codeColeur] = combo;
//       }
//     }

//     return uniqueMap.values.toList();
//   }

//   /* ------------------------- CART OPERATION METHODS ------------------------- */

//   // Get the correct attribute ID for cart operations
//   int? getCartAttributeId([ProductCombination? selectedColor]) {
//     // If a specific color is selected, use its attribute ID
//     if (selectedColor != null) {
//       return selectedColor.id;
//     }

//     // For products with combinations, use the default available color
//     if (colorCombinations.isNotEmpty) {
//       return defaultColor?.id;
//     }

//     // For simple products, return null (no attribute needed)
//     return null;
//   }

//   // Check if product has combinations
//   bool get hasCombinations => combinations.isNotEmpty;

//   // Check if product has color combinations
//   bool get hasColorCombinations => colorCombinations.isNotEmpty;

//   // Get all available attribute IDs from combinations
//   List<int> getAvailableAttributeIds() {
//     if (combinations.isNotEmpty) {
//       return combinations.map((combo) => combo.id).toList();
//     }
//     return [];
//   }

//   // Check if a specific attribute ID is valid for this product
//   bool isValidAttributeId(int attributeId) {
//     if (!hasCombinations) {
//       return false; // Simple products don't need attribute IDs
//     }
//     return combinations.any((combo) => combo.id == attributeId);
//   }

//   // Check if attributes map is not empty
//   bool get hasAttributes {
//     return attributes != null && attributes!.isNotEmpty;
//   }

//   // Get attribute value by key from the attributes map
//   String? getAttributeValue(String key) {
//     return attributes?[key]?.toString();
//   }

//   /* ------------------------- STOCK MANAGEMENT ------------------------- */

//   // Overall product stock status (considers all combinations)
//   bool get inStock {
//     if (hasCombinations) {
//       return combinations.any((comb) => comb.inStock);
//     }
//     return stock > 0;
//   }

//   // Stock status for a specific color
//   bool isInStockForColor(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.inStock ?? false;
//   }

//   // Get stock quantity for a specific color
//   int getStockForColor(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.quantity ?? 0;
//   }

//   /* ------------------------- FACTORY METHODS ------------------------- */

//   // Factory method for detailed product parsing
//   factory Product.fromDetailedJson(Map<String, dynamic> json) {
//     print('=== PARSING DETAILED PRODUCT JSON ===');
//     print('Product name: ${json['name']}');
//     print('Product ID: ${json['id_product']}');

//     // Parse images
//     final images = _parseImages(json['images'] as List<dynamic>?);
//     print('Parsed ${images.length} images');

//     // Parse combinations with color data - FIXED: Use enhanced parsing
//     final combinations = _parseCombinationsEnhanced(json);
//     print('Parsed ${combinations.length} combinations');

//     // Use main image as the first image from images list, or fallback to existing logic
//     final mainImage = images.isNotEmpty ? images.first : _parseImageUrl(json);

//     // Parse category ID
//     final categoryId = _parseCategoryId(json);

//     return Product(
//       id:
//           json['id_product'] is int
//               ? json['id_product'] as int
//               : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand:
//           json['manufacturer']?.toString() ??
//           json['manufacturer_name']?.toString() ??
//           'Unknown Brand',
//       price: _parsePrice(json['price'] ?? json['price_attribute']),
//       image: mainImage,
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       stock:
//           json['quantity'] is int
//               ? json['quantity'] as int
//               : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       images: images,
//       shortDescription:
//           json['short_description']?.toString() ??
//           json['description_short']?.toString() ??
//           '',
//       quantity:
//           json['quantity'] is int
//               ? json['quantity'] as int
//               : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       active: json['active']?.toString() == '1',
//       combinations: combinations,
//       categoryId: categoryId,
//     );
//   }

//   // Factory method for basic product parsing
//   factory Product.fromJson(Map<String, dynamic> json) {
//     print('=== PARSING PRODUCT JSON ===');
//     print('Product name: ${json['name']}');

//     // Parse ID
//     final id = _parseProductId(json);
//     print('Parsed ID: $id');

//     // Parse combinations for this product
//     final combinations = _parseCombinationsEnhanced(json);

//     return Product(
//       id: id,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand: json['manufacturer']?.toString() ?? 'Unknown Brand',
//       price: _parsePrice(json['price']),
//       image: _parseImageUrl(json),
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       url: json['link']?.toString(),
//       showPrice: true,
//       stock:
//           json['stock'] is int
//               ? json['stock'] as int
//               : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
//       combinations: combinations,
//       categoryId: _parseCategoryId(json),
//     );
//   }

//   // Factory method for cart product parsing
//   factory Product.fromCartJson(Map<String, dynamic> json) {
//     return Product(
//       id:
//           json['id_product'] is int
//               ? json['id_product'] as int
//               : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
//       reference: json['reference']?.toString() ?? '',
//       name: json['name']?.toString() ?? 'No Name',
//       brand: json['manufacturer_name']?.toString() ?? 'Unknown Brand',
//       price: _parsePrice(json['price'] ?? json['price_attribute']),
//       image: _parseImageUrl(json),
//       description: _parseDescription(json),
//       oldPrice: _parsePrice(json['price_without_reduction']),
//       discount: _parseDiscount(json['reduction']),
//       attributes: _parseAttributes(json),
//       stock:
//           json['quantity_available'] is int
//               ? json['quantity_available'] as int
//               : int.tryParse(json['quantity_available']?.toString() ?? '0') ??
//                   0,
//       images: _parseImages(json['images'] as List<dynamic>?),
//       shortDescription: json['description_short']?.toString() ?? '',
//       quantity:
//           json['cart_quantity'] is int
//               ? json['cart_quantity'] as int
//               : int.tryParse(json['cart_quantity']?.toString() ?? '0') ?? 0,
//       active: json['active']?.toString() == '1',
//       combinations: _parseCombinationsEnhanced(json),
//       categoryId: _parseCategoryId(json),
//     );
//   }

//   /* ------------------------- STATIC PARSING METHODS ------------------------- */

//   static List<String> _parseImages(List<dynamic>? imagesJson) {
//     if (imagesJson == null || imagesJson.isEmpty) return [];

//     final List<String> images = [];
//     for (var imageUrl in imagesJson) {
//       if (imageUrl is String && imageUrl.isNotEmpty) {
//         final validatedUrl = _validateImageUrl(imageUrl);
//         if (validatedUrl.isNotEmpty) {
//           images.add(validatedUrl);
//         }
//       } else if (imageUrl is Map<String, dynamic>) {
//         // Handle image object format
//         final url = imageUrl['url']?.toString();
//         if (url != null && url.isNotEmpty) {
//           final validatedUrl = _validateImageUrl(url);
//           if (validatedUrl.isNotEmpty) {
//             images.add(validatedUrl);
//           }
//         }
//       }
//     }
//     return images;
//   }

//   // In Product class - update _parseCombinationsEnhanced
// static List<ProductCombination> _parseCombinationsEnhanced(
//   Map<String, dynamic> json,
// ) {
//   final List<ProductCombination> combinations = [];
//   final combinationsJson = json['combinations'] ?? json['combinaisons'];

//   if (combinationsJson != null && combinationsJson is List) {
//     print("🔄 Found ${combinationsJson.length} raw combinations");

//     // Parse ALL combinations first
//     for (var comboData in combinationsJson) {
//       try {
//         if (comboData is! Map<String, dynamic>) continue;
        
//         final combination = ProductCombination.fromJson(comboData);
//         combinations.add(combination);
        
//       } catch (e) {
//         print('❌ Error parsing combination: $e');
//       }
//     }

//     // Debug: print all parsed combinations
//     print("🎨 ALL PARSED COMBINATIONS (${combinations.length}):");
//     for (var combo in combinations) {
//       print("ID: ${combo.id}");
//       print("Attributes: '${combo.attributes}'");
//       print("Color Code: '${combo.codeColeur}'");
//       print("       Is Color: ${combo.isColorCombination}");
//       print("       Stock: ${combo.quantity}");
//     }

//     // Return ALL combinations - let the getter handle filtering
//     return combinations;
//   }

//   print(" No combinations found in product data");
//   return [];
// }

//   // Keep original method for backward compatibility
//   static List<ProductCombination> _parseCombinations(
//     Map<String, dynamic> json,
//   ) {
//     return _parseCombinationsEnhanced(json);
//   }

//   static int? _parseCategoryId(Map<String, dynamic> json) {
//     // Check multiple possible fields for category ID
//     if (json['id_category'] != null) {
//       if (json['id_category'] is int) return json['id_category'] as int;
//       if (json['id_category'] is String) {
//         return int.tryParse(json['id_category'] as String);
//       }
//     }

//     if (json['id_category_default'] != null) {
//       if (json['id_category_default'] is int)
//         return json['id_category_default'] as int;
//       if (json['id_category_default'] is String) {
//         return int.tryParse(json['id_category_default'] as String);
//       }
//     }

//     if (json['category_id'] != null) {
//       if (json['category_id'] is int) return json['category_id'] as int;
//       if (json['category_id'] is String) {
//         return int.tryParse(json['category_id'] as String);
//       }
//     }

//     print(' No category ID found in product detail');
//     return null;
//   }

//   static int _parseProductId(Map<String, dynamic> json) {
//     // Priority 1: id_product (from your API response)
//     if (json['id_product'] != null) {
//       if (json['id_product'] is int) return json['id_product'] as int;
//       if (json['id_product'] is String) {
//         return int.tryParse(json['id_product'] as String) ?? 0;
//       }
//     }

//     // Priority 2: id (fallback)
//     if (json['id'] != null) {
//       if (json['id'] is int) return json['id'] as int;
//       if (json['id'] is String) {
//         return int.tryParse(json['id'] as String) ?? 0;
//       }
//     }

//     return 0;
//   }

//   static double _parsePrice(dynamic priceValue) {
//     if (priceValue == null) return 0.0;

//     if (priceValue is double) return priceValue;
//     if (priceValue is int) return priceValue.toDouble();
//     if (priceValue is String) {
//       final priceString = priceValue as String;
//       print('Parsing price string: "$priceString"');

//       try {
//         // Handle "LYD120.000" and "LYD0.000" format
//         final numericString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
//         print('Numeric string: "$numericString"');

//         if (numericString.isEmpty) return 0.0;

//         final parsed = double.tryParse(numericString) ?? 0.0;
//         print('Parsed price: $parsed');
//         return parsed;
//       } catch (e) {
//         print('Price parsing error: $e');
//         return 0.0;
//       }
//     }

//     return 0.0;
//   }

//   static String _parseImageUrl(Map<String, dynamic> json) {
//     // Priority 1: Direct 'image' field from API
//     if (json['image'] != null && json['image'].toString().isNotEmpty) {
//       final imageUrl = json['image'].toString().trim();
//       if (imageUrl != 'null' && imageUrl.isNotEmpty) {
//         return _validateImageUrl(imageUrl);
//       }
//     }

//     // Priority 2: id_image field (construct URL)
//     if (json['id_image'] != null) {
//       final imageId = json['id_image'].toString();
//       if (imageId.isNotEmpty && imageId != '0') {
//         return _validateImageUrl(
//           'https://tawasul-dev.app-staging.fr/img/p/$imageId.jpg',
//         );
//       }
//     }

//     return '';
//   }

//   static String _validateImageUrl(String url) {
//     if (url.isEmpty || url == 'null') return '';

//     // If URL already has protocol, return as-is
//     if (url.startsWith('http://') || url.startsWith('https://')) {
//       return url;
//     }

//     // If URL starts with //, add https:
//     if (url.startsWith('//')) {
//       return 'https:$url';
//     }

//     // If it's a relative path starting with /, prepend domain
//     if (url.startsWith('/')) {
//       return 'https://tawasul-dev.app-staging.fr$url';
//     }

//     // For any other case, assume it's a full URL missing protocol
//     return 'https://$url';
//   }

//   static String _parseDescription(Map<String, dynamic> json) {
//     // Priority 1: description field
//     String? description = json['description']?.toString();

//     // Priority 2: description_short field
//     if (description == null || description.isEmpty) {
//       description = json['description_short']?.toString();
//     }

//     // Priority 3: name as fallback
//     if (description == null || description.isEmpty) {
//       description = json['name']?.toString() ?? 'No description available';
//     }

//     return _cleanHtmlTags(description);
//   }

//   static Map<String, dynamic>? _parseAttributes(Map<String, dynamic> json) {
//     final attributes = <String, dynamic>{};

//     // Add combination data if available
//     if (json['id_product_attribute'] != null) {
//       attributes['id_product_attribute'] = json['id_product_attribute'];
//     }

//     // Add attribute descriptions
//     if (json['attributes_small'] != null) {
//       attributes['attributes_small'] = json['attributes_small'];
//     }
//     if (json['attributes'] != null) {
//       attributes['attributes'] = json['attributes'];
//     }

//     // Add any other relevant attribute data
//     if (json['reference'] != null) {
//       attributes['reference'] = json['reference'];
//     }
//     if (json['manufacturer_name'] != null) {
//       attributes['manufacturer_name'] = json['manufacturer_name'];
//     }

//     return attributes.isNotEmpty ? attributes : null;
//   }

//   static String _cleanHtmlTags(String htmlString) {
//     if (htmlString.isEmpty) return 'No description available';

//     // Replace line breaks first
//     String cleaned = htmlString.replaceAll(
//       RegExp(r'<br\s*/?>', caseSensitive: false),
//       '\n',
//     );

//     // Remove all other HTML tags
//     cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

//     // Decode common HTML entities
//     cleaned = cleaned
//         .replaceAll('&amp;', '&')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&quot;', '"')
//         .replaceAll('&#39;', "'")
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll('&#160;', ' ');

//     // Clean up whitespace
//     cleaned = cleaned.replaceAll(RegExp(r'[ \t]+'), ' ');
//     cleaned = cleaned.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
//     cleaned = cleaned.trim();

//     return cleaned.isEmpty ? 'No description available' : cleaned;
//   }

//   static String? _parseDiscount(dynamic reduction) {
//     if (reduction == null) return null;

//     try {
//       double discountValue = 0.0;

//       if (reduction is double) {
//         discountValue = reduction;
//       } else if (reduction is int) {
//         discountValue = reduction.toDouble();
//       } else if (reduction is String) {
//         discountValue = double.tryParse(reduction) ?? 0.0;
//       }

//       if (discountValue > 0) {
//         return '${(discountValue * 100).toStringAsFixed(0)}% OFF';
//       }
//     } catch (e) {
//       print('Discount parsing error: $e');
//     }

//     return null;
//   }

//   /* ------------------------- HELPER METHODS ------------------------- */

//   Product copyWith({
//     int? id,
//     String? reference,
//     String? name,
//     String? brand,
//     double? price,
//     String? image,
//     String? description,
//     double? oldPrice,
//     String? discount,
//     Map<String, dynamic>? attributes,
//     String? url,
//     bool? showPrice,
//     String? weightUnit,
//     Map<String, dynamic>? embeddedAttributes,
//     bool? isFavorite,
//     bool? isBestSeller,
//     List<Color>? colors,
//     String? category,
//     String? categoryCode,
//     int? categoryId,
//     int? stock,
//     List<String>? images,
//     String? shortDescription,
//     int? quantity,
//     bool? active,
//     List<ProductCombination>? combinations,
//   }) {
//     return Product(
//       id: id ?? this.id,
//       reference: reference ?? this.reference,
//       name: name ?? this.name,
//       brand: brand ?? this.brand,
//       price: price ?? this.price,
//       image: image ?? this.image,
//       description: description ?? this.description,
//       oldPrice: oldPrice ?? this.oldPrice,
//       discount: discount ?? this.discount,
//       attributes: attributes ?? this.attributes,
//       url: url ?? this.url,
//       showPrice: showPrice ?? this.showPrice,
//       weightUnit: weightUnit ?? this.weightUnit,
//       embeddedAttributes: embeddedAttributes ?? this.embeddedAttributes,
//       isFavorite: isFavorite ?? this.isFavorite,
//       isBestSeller: isBestSeller ?? this.isBestSeller,
//       colors: colors ?? this.colors,
//       category: category ?? this.category,
//       categoryCode: categoryCode ?? this.categoryCode,
//       categoryId: categoryId ?? this.categoryId,
//       stock: stock ?? this.stock,
//       images: images ?? this.images,
//       shortDescription: shortDescription ?? this.shortDescription,
//       quantity: quantity ?? this.quantity,
//       active: active ?? this.active,
//       combinations: combinations ?? this.combinations,
//     );
//   }

//   // Price formatting
//   String get formattedPrice {
//     return 'LYD ${price.toStringAsFixed(3)}';
//   }

//   String? get formattedOldPrice {
//     return oldPrice != null ? 'LYD ${oldPrice!.toStringAsFixed(3)}' : null;
//   }

//   // Discount calculations
//   bool get hasDiscount {
//     return oldPrice != null && oldPrice! > price;
//   }

//   double? get discountPercentage {
//     if (oldPrice != null && oldPrice! > 0 && oldPrice! > price) {
//       return ((oldPrice! - price) / oldPrice!) * 100;
//     }
//     return null;
//   }

//   // Stock information
//   String get stockStatus {
//     if (inStock) {
//       if (stock > 10) return 'In Stock';
//       return 'Low Stock';
//     }
//     return 'Out of Stock';
//   }

//   // Combination info
//   String getCombinationInfo(int attributeId) {
//     final combo = getCombination(attributeId);
//     return combo?.attributes ?? 'Default';
//   }

//   /* ------------------------- DEBUG & UTILITY METHODS ------------------------- */

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Product && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() {
//     return 'Product{id: $id, name: "$name", price: LYD $price, stock: $stock, colorCombinations: ${colorCombinations.length}}';
//   }

//   // Enhanced debug method
//   void printDebugInfo() {
//     print('=== PRODUCT DEBUG INFO ===');
//     print('ID: $id');
//     print('Name: $name');
//     print('Brand: $brand');
//     print('Price: LYD $price');
//     print('Stock: $stock ($stockStatus)');
//     print('Has Color Combinations: $hasColorCombinations');
//     print('Available Colors: ${availableColors.length}');
//     print('Unavailable Colors: ${unavailableColors.length}');
//     print('All Combinations: ${combinations.length}');
//     print('Color Combinations: ${colorCombinations.length}');
//     for (var combo in colorCombinations) {
//       print(
//         '  - Color: ${combo.colorName}, ID: ${combo.id}, Quantity: ${combo.quantity}, Available: ${combo.isAvailable}',
//       );
//     }
//     print('Default Color: ${defaultColor?.colorName}');
//     print('==========================');
//   }

//   // Convert to map for serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'reference': reference,
//       'name': name,
//       'brand': brand,
//       'price': price,
//       'image': image,
//       'description': description,
//       'oldPrice': oldPrice,
//       'discount': discount,
//       'attributes': attributes,
//       'url': url,
//       'stock': stock,
//       'images': images,
//       'shortDescription': shortDescription,
//       'quantity': quantity,
//       'active': active,
//       'combinations': combinations.map((combo) => combo.toJson()).toList(),
//       'categoryId': categoryId,
//     };
//   }
// }

// class ProductCombination {
//   final int id;
//   final String reference;
//   final int quantity;
//   final String attributes;
//   final double price;
//   final bool inStock;
//   final int defaultOn;
//   final String idAttributeGroup;
//   final String idAttribute;
//   final String codeColeur;
//   final String name;
//   final List<String> images;

//   ProductCombination({
//     required this.id,
//     required this.reference,
//     required this.quantity,
//     required this.attributes,
//     required this.price,
//     this.inStock = true,
//     this.defaultOn = 0,
//     this.idAttributeGroup = '',
//     this.idAttribute = '',
//     this.codeColeur = '',
//     this.name = '',
//     this.images = const [],
//   });

//   factory ProductCombination.fromJson(Map<String, dynamic> json) {
//     // Parse images
//     final List<String> comboImages = [];
//     if (json['images'] is List) {
//       for (var image in json['images'] as List) {
//         if (image is String && image.isNotEmpty) {
//           comboImages.add(image);
//         }
//       }
//     }

//     return ProductCombination(
//       id:
//           json['id_product_attribute'] is int
//               ? json['id_product_attribute'] as int
//               : int.tryParse(json['id_product_attribute']?.toString() ?? '') ??
//                   0,
//       reference: json['reference']?.toString() ?? '',
//       quantity:
//           (json['quantity'] ?? json['stock']) is int
//               ? (json['quantity'] ?? json['stock']) as int
//               : int.tryParse(
//                     (json['quantity'] ?? json['stock'])?.toString() ?? '0',
//                   ) ??
//                   0,
//       attributes: json['attributes']?.toString() ?? '',
//       price: Product._parsePrice(json['price_attribute'] ?? json['price']),
//       inStock: ((json['quantity'] ?? json['stock']) ?? 0) > 0,
//       defaultOn: (json['default'] == true) ? 1 : 0,
//       idAttributeGroup: json['id_attribute_group']?.toString() ?? '',
//       idAttribute: json['id_attribute']?.toString() ?? '',
//       codeColeur: json['color']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       images: comboImages,
//     );
//   }

//   // FIXED: Improved color combination detection
//   // In ProductCombination class - FIXED VERSION
// bool get isColorCombination {
//   if (attributes.isEmpty) return false;
  
//   print("🔍 Checking if combination is color: '$attributes'");
  
//   // Check if this is a SKU entry (we want to exclude these)
//   final isSku = attributes.toLowerCase().contains('sku');
//   if (isSku) {
//     print("   ❌ Excluded - SKU entry");
//     return false;
//   }
  
//   // Check if we have valid color data
//   final hasColorData = codeColeur.isNotEmpty && 
//                        codeColeur != "#" && 
//                        codeColeur != "null";
  
//   // For Arabic: look for "لون" (color)
//   final isArabicColor = attributes.contains('لون');
//   // For English: look for "Color" 
//   final isEnglishColor = attributes.toLowerCase().contains('color');
  
//   final isColor = hasColorData && (isArabicColor || isEnglishColor);
  
//   print("   Color Data: $hasColorData, Arabic: $isArabicColor, English: $isEnglishColor → $isColor");
  
//   return isColor;
// }

//   // FIXED: Better color name extraction
//   // In ProductCombination class
// String get colorName {
//   print("🎨 Extracting color name from: '$attributes'");
  
//   if (attributes.contains(" - ")) {
//     final parts = attributes.split(" - ");
//     if (parts.length >= 2) {
//       final name = parts[1].trim();
//       print("   ✅ Extracted from pattern: '$name'");
//       return name;
//     }
//   }
  
//   // Try Arabic pattern: "لون - Blue"
//   if (attributes.contains("لون")) {
//     final regex = RegExp(r'لون\s*-\s*([^,]+)');
//     final match = regex.firstMatch(attributes);
//     if (match != null) {
//       final name = match.group(1)!.trim();
//       print("   ✅ Extracted from Arabic: '$name'");
//       return name;
//     }
//   }
  
//   // Try English pattern: "Color - Blue"
//   if (attributes.toLowerCase().contains("color")) {
//     final regex = RegExp(r'color\s*-\s*([^,]+)', caseSensitive: false);
//     final match = regex.firstMatch(attributes);
//     if (match != null) {
//       final name = match.group(1)!.trim();
//       print("   ✅ Extracted from English: '$name'");
//       return name;
//     }
//   }
  
//   // Final fallback
//   print("   ⚠️ Using fallback name");
//   return "Color $id";
// }

//   // FIXED: Better color value parsing
//   Color get colorValue {
//     if (codeColeur.isEmpty || codeColeur == "#" || codeColeur == "null") {
//       return Colors.grey;
//     }

//     try {
//       String hexColor = codeColeur.replaceAll('#', '');

//       if (hexColor.length == 6) {
//         hexColor = 'FF$hexColor'; // Add alpha value
//       } else if (hexColor.length == 3) {
//         hexColor =
//             'FF${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}';
//       }

//       if (hexColor.length == 8) {
//         return Color(int.parse(hexColor, radix: 16));
//       }
//     } catch (e) {
//       print('❌ Color parsing error for "$codeColeur": $e');
//     }

//     return Colors.grey;
//   }

//   bool get isAvailable => quantity > 0;
//   bool get hasColor =>
//       codeColeur.isNotEmpty && codeColeur != "#" && codeColeur != "null";

//   Map<String, dynamic> toJson() {
//     return {
//       'id_product_attribute': id,
//       'reference': reference,
//       'quantity': quantity,
//       'attributes': attributes,
//       'price': price,
//       'inStock': inStock,
//       'default_on': defaultOn,
//       'id_attribute_group': idAttributeGroup,
//       'id_attribute': idAttribute,
//       'code_coleur': codeColeur,
//       'name': name,
//       'images': images,
//     };
//   }

//   @override
//   String toString() {
//     return 'ProductCombination{id: $id, color: $colorName, code: $codeColeur, available: $isAvailable, quantity: $quantity}';
//   }
// }

// extension FirstWhereOrNull<T> on Iterable<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     for (var element in this) {
//       if (test(element)) {
//         return element;
//       }
//     }
//     return null;
//   }
// }

// extension FirstOrNull<T> on Iterable<T> {
//   T? firstOrNull() {
//     try {
//       return first;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// extension NullSafetyCheck on List? {
//   bool get isNullOrEmpty => this == null || this!.isEmpty;
// }

// // Extension for cart-specific operations
// extension CartProductExtension on Product {
//   // Check if this product can be added to cart
//   bool get canAddToCart => inStock && active;

//   // Check if specific color can be added to cart
//   bool canAddColorToCart(int attributeId) {
//     return isInStockForColor(attributeId) && active;
//   }

//   // Get max quantity that can be added to cart
//   int get maxCartQuantity {
//     return stock;
//   }

//   // Validate quantity for cart
//   bool isValidQuantity(int quantity) {
//     return quantity > 0 && quantity <= maxCartQuantity;
//   }

//   // Get display name with combination info
//   String getDisplayName([int? attributeId]) {
//     if (attributeId != null && hasCombinations) {
//       final combo = getCombination(attributeId);
//       if (combo != null) {
//         return '$name - ${combo.colorName}';
//       }
//     }
//     return name;
//   }
// }
