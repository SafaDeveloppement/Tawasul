import 'package:tawasul_application/model/product_combination.dart.dart';
import 'package:collection/collection.dart';

class Product {
  final String name;
  final String image;
  final double price;
  final String description;
  final String categoryName;
  final int idAttributeDefault;
  final int idProduct;
  final int stock;
  final int stockProduct;
  List<ProductCombination> combinations = [];

  final String reference;
  final String shortDescription;
  final int quantity;
  final bool active;

  final List<String> images;

  final int categoryId;

  bool isFavorite;
  bool isBestSeller;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.categoryName,
    required this.idAttributeDefault,
    required this.idProduct,
    this.stock = 0,
    this.stockProduct = 20,
    required this.combinations,
    this.reference = "",

    this.shortDescription = '',
    this.quantity = 0,
    this.active = true,

    this.images = const [],

    this.categoryId = 16,

    this.isFavorite = false,
    this.isBestSeller = false,
  });

  List<String> get allImages {
    final all = <String>[];
    if (image.isNotEmpty) all.add(image);
    all.addAll(images);
    return all;
  }

  List<ProductCombination> get colorCombinations {
    return combinations
        .where((comb) => comb.colorCode.isNotEmpty && comb.colorCode != "#")
        .toList();
  }

  bool get hasColorCombinations => colorCombinations.isNotEmpty;

  bool get inStock {
    if (hasColorCombinations) {
      return colorCombinations.any((comb) => comb.isAvailable);
    }
    return stock > 0;
  }

  ProductCombination? get defaultColor {
    final availableDefault = colorCombinations.firstWhereOrNull(
      (comb) => comb.isDefault && comb.isAvailable,
    );
    return availableDefault ??
        colorCombinations.firstWhereOrNull((comb) => comb.isAvailable) ??
        colorCombinations.firstOrNull;
  }

  String get thumbnail => image.isNotEmpty ? image : images.firstOrNull ?? '';

  bool get hasMultipleImages => images.length > 1;

  factory Product.fromJson(Map<String, dynamic> json) {
    String rawPrice =
        json['price']?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '0';
    double parsedPrice = double.tryParse(rawPrice) ?? 0.0;

    return Product(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: parsedPrice,
      description: json['description'] ?? '',
      categoryName: json['category_name'] ?? '',
      idAttributeDefault:
          int.tryParse(json['id_attribute_default'].toString()) ?? 0,
      idProduct: int.tryParse(json['id_product'].toString()) ?? 0,
      stock: json['stock'],
      combinations:
          (json['combinaisons'] as List<dynamic>?)
              ?.map((e) => ProductCombination.fromJson(e))
              .toList() ??
          [],
    );
  }
  factory Product.fromCartJson(Map<String, dynamic> json) {
    double parsedPrice;
    if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toDouble();
    } else {
      String rawPrice =
          (json['price'] ?? json['price_attribute'] ?? '0').toString();
      rawPrice = rawPrice.replaceAll(RegExp(r'[^\d.]'), '');
      parsedPrice = double.tryParse(rawPrice) ?? 0.0;
    }
    return Product(
      idProduct:
          json['id_product'] is int
              ? json['id_product']
              : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? 'No Name',
      price: parsedPrice,
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      idAttributeDefault:
          int.tryParse(json['id_attribute_default']?.toString() ?? '0') ?? 0,
      stock: json['stock'],
      combinations:
          (json['combinaisons'] as List<dynamic>?)
              ?.map((e) => ProductCombination.fromJson(e))
              .toList() ??
          [],
    );
  }

  get qty => null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'stock': stock,
      'combinaisons': combinations.map((e) => e.toJson()).toList(),
    };
  }

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
      idProduct: id ?? this.idProduct,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      combinations: combinations ?? this.combinations,
      categoryName: '',
      idAttributeDefault: 0,
    );
  }

  static Product? fromDetailedJson(productData) {}

  getImagesForColor(ProductCombination? selectedColor) {}


  //   /* ------------------------- COLOR & STOCK MANAGEMENT METHODS ------------------------- */
  //   List<Map<String, dynamic>> get parsedColorsWithNames {
  //     if (colors == null || colors!.isEmpty) return [];
  //     final colorPairs = colors!.split(',');
  //     return colorPairs.map((pair) {
  //       final parts = pair.trim().split(':');
  //       if (parts.length != 2) return {'name': 'Unknown', 'color': Colors.grey};

  //       final colorName = parts[0].trim();
  //       final hexCode = parts[1].trim();

  //       Color parsedColor = Colors.grey;
  //       try {
  //         parsedColor = Color(int.parse(hexCode.replaceAll('#', '0xff')));
  //       } catch (_) {}

  //       return {'name': colorName, 'color': parsedColor};
  //     }).toList();
  //   }

  //   List<Color> get parsedColors {
  //     final Set<String> seen = {};
  //     final List<Color> colorsList = [];

  //     for (final comb in colorCombinations) {
  //       final hex = comb.codeColeur.trim();
  //       if (hex.isEmpty || hex == "#" || seen.contains(hex)) continue;

  //       try {
  //         final buffer = StringBuffer();
  //         if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  //         buffer.write(hex.replaceFirst('#', ''));
  //         final color = Color(int.parse(buffer.toString(), radix: 16));
  //         colorsList.add(color);
  //         seen.add(hex);
  //       } catch (e) {
  //         debugPrint("Invalid color hex: $hex");
  //       }
  //     }

  //     return colorsList;
  //   }

  //   List<ProductCombination> get colorCombinations {
  //     return combinations.where((comb) => comb.isColorCombination).toList();
  //   }

  //   List<ProductCombination> get availableColors {
  //     return colorCombinations.where((comb) => comb.isAvailable).toList();
  //   }

  //   List<ProductCombination> get unavailableColors {
  //     return colorCombinations.where((comb) => !comb.isAvailable).toList();
  //   }

  //   bool isColorAvailable(String colorName) {
  //     return colorCombinations.any(
  //       (comb) =>
  //           comb.colorName.toLowerCase() == colorName.toLowerCase() &&
  //           comb.isAvailable,
  //     );
  //   }

  //   bool isColorAvailableById(String attributeId) {
  //     return combinations.any(
  //       (comb) => comb.id_product_attribute == attributeId && comb.isAvailable,
  //     );
  //   }

  //   ProductCombination? get defaultColor {
  //     final availableDefault = colorCombinations.firstWhereOrNull(
  //       (comb) => comb.defaultOn == "1" && comb.isAvailable,
  //     );
  //     return availableDefault ??
  //         availableColors.firstOrNull() ??
  //         colorCombinations.firstOrNull();
  //   }

  //   ProductCombination? getCombinationByColorName(String colorName) {
  //     try {
  //       return colorCombinations.firstWhere(
  //         (comb) => comb.colorName.toLowerCase() == colorName.toLowerCase(),
  //       );
  //     } catch (e) {
  //       return null;
  //     }
  //   }

  //   ProductCombination? getCombination(String attributeId) {
  //     try {
  //       return combinations.firstWhere(
  //         (combo) => combo.id_product_attribute == attributeId,
  //       );
  //     } catch (e) {
  //       return null;
  //     }
  //   }

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
  //   String? getCartAttributeId([ProductCombination? selectedColor]) {
  //     if (selectedColor != null) {
  //       return selectedColor.id_product_attribute;
  //     }
  //     if (colorCombinations.isNotEmpty) {
  //       return defaultColor?.id_product_attribute;
  //     }
  //     return null;
  //   }

  //   bool get hasCombinations => combinations.isNotEmpty;
  //   bool get hasColorCombinations => colorCombinations.isNotEmpty;
  //   List<String> getAvailableAttributeIds() {
  //     if (combinations.isNotEmpty) {
  //       return combinations.map((combo) => combo.id_product_attribute).toList();
  //     }
  //     return [];
  //   }

  //   // Check if a specific attribute ID is valid for this product
  //   bool isValidAttributeId(String attributeId) {
  //     if (!hasCombinations) {
  //       return false; // Simple products don't need attribute IDs
  //     }
  //     return combinations.any(
  //       (combo) => combo.id_product_attribute == attributeId,
  //     );
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
  //   bool isInStockForColor(String attributeId) {
  //     final combo = getCombination(attributeId);
  //     return combo?.inStock ?? false;
  //   }

  //   int getStockForColor(String attributeId) {
  //     final combo = getCombination(attributeId);
  //     return combo?.qty ?? 0;
  //   }

  //   /* ------------------------- FACTORY METHODS ------------------------- */
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

  // //   // Factory method for cart product parsing
  //   factory Product.fromCartJson(Map<String, dynamic> json) {
  //     return Product(
  //       idProduct:
  //           json['id_product'] is int
  //               ? json['id_product'] as int
  //               : int.tryParse(json['id_product']?.toString() ?? '') ?? 0,
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

  //   // ENHANCED: Fixed combination parsing method
  //   static List<ProductCombination> _parseCombinationsEnhanced(
  //     Map<String, dynamic> json,
  //   ) {
  //     final List<ProductCombination> combinations = [];

  //     // Check multiple possible locations for combinations
  //     final combinationsJson = json['combinations'] ?? json['combinaisons'];

  //     if (combinationsJson != null && combinationsJson is List) {
  //       print(" Found ${combinationsJson.length} raw combinations");

  //       // Filter out SKU entries and keep only color combinations
  //       final colorCombinations =
  //           combinationsJson.where((combo) {
  //             if (combo is! Map<String, dynamic>) return false;

  //             final colorCode = combo['color']?.toString() ?? '';
  //             final attributes = combo['attributes']?.toString() ?? '';

  //             // Keep entries that have color data and are not SKU entries
  //             final hasColor = colorCode.isNotEmpty && colorCode != "#";
  //             final isSku =
  //                 attributes.contains("Sku") || attributes.contains("SKU");

  //             return hasColor && !isSku;
  //           }).toList();

  //       print(" Filtered to ${colorCombinations.length} color combinations");

  //       // Create ProductCombination objects
  //       for (var comboData in colorCombinations) {
  //         try {
  //           final combination = ProductCombination.fromJson(comboData);

  //           // Debug info
  //           print(
  //             "    ${combination.colorName}: ${combination.codeColeur} "
  //             "(Qty: ${combination.qty}, Available: ${combination.isAvailable})",
  //           );

  //           combinations.add(combination);
  //         } catch (e) {
  //           print(' Error parsing combination: $e');
  //           print('   Problematic data: $comboData');
  //         }
  //       }
  //     }
  //     if (combinations.isEmpty && json['id_product_attribute'] != null) {
  //       final attributeId = json['id_product_attribute'];
  //       combinations.add(
  //         ProductCombination(
  //           id_product_attribute:
  //               attributeId is String ? attributeId : (attributeId.toString()),
  //           reference: json['reference']?.toString() ?? '',
  //           qty:
  //               json['qty'] is int
  //                   ? json['qty'] as int
  //                   : int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
  //           attributes:
  //               json['attributes_small']?.toString() ??
  //               json['attributes']?.toString() ??
  //               '',
  //           price: _parsePrice(json['price_attribute'] ?? json['price']),
  //           inStock: (json['qty'] ?? 0) > 0,
  //           defaultOn:
  //               json['default_on'] is String
  //                   ? json['default_on'] as String
  //                   : (json['default_on']?.toString() ?? '0'),
  //           idAttributeGroup: json['id_attribute_group']?.toString() ?? '',
  //           idAttribute: json['id_attribute']?.toString() ?? '',
  //           codeColeur: json['code_coleur']?.toString() ?? '',
  //           name: json['name']?.toString() ?? '',
  //         ),
  //       );
  //     }

  //     print(' Found ${combinations.length} unique combinations');
  //     for (var combo in combinations) {
  //       print(
  //         '  - Combination ID: ${combo.id_product_attribute}, Color: ${combo.colorName}, Quantity: ${combo.qty}, Available: ${combo.isAvailable}',
  //       );
  //     }

  //     return combinations;
  //   }

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
  //   String getCombinationInfo(String attributeId) {
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
  //         '  - Color: ${combo.colorName}, ID: ${combo.id_product_attribute}, Quantity: ${combo.qty}, Available: ${combo.isAvailable}',
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

  //   getImagesForColor(ProductCombination? selectedColor) {}
  // }

  //   bool get isColorCombination {
  //     final hasColorData = codeColeur.isNotEmpty && codeColeur != "#";
  //     final isSkuEntry = attributes.contains("Sku") || attributes.contains("SKU");

  //     return hasColorData && !isSkuEntry;
  //   }

  //   String get colorName {
  //     // Extract from attributes like "لون - Blue" or "Color - White"
  //     if (attributes.contains(" - ")) {
  //       final parts = attributes.split(" - ");
  //       if (parts.length >= 2) {
  //         return parts[1].trim();
  //       }
  //     }
  //     if (name.isNotEmpty) return name;
  //     return "Color ${id_product_attribute}";
  //   }

  //   Color get colorValue {
  //     if (codeColeur.isEmpty || codeColeur == "#") return Colors.grey;
  //     try {
  //       String hexColor = codeColeur.replaceAll('#', '');
  //       if (hexColor.length == 3) {
  //         hexColor =
  //             'FF${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}';
  //       } else if (hexColor.length == 6) {
  //         hexColor = 'FF$hexColor';
  //       } else if (hexColor.length == 8) {
  //       } else {
  //         return Colors.grey;
  //       }

  //       return Color(int.parse(hexColor, radix: 16));
  //     } catch (e) {
  //       print('Color parsing error for "$codeColeur": $e');
  //       return Colors.grey;
  //     }
  //   }

  //   bool get isAvailable => qty > 0;
  //   bool get hasColor => codeColeur.isNotEmpty && name.isNotEmpty;
  //   Map<String, dynamic> toJson() {
  //     return {
  //       'id_product_attribute': id_product_attribute,
  //       'reference': reference,
  //       'quantity': qty,
  //       'attributes': attributes,
  //       'price': price,
  //       'inStock': inStock,
  //       'default_on': defaultOn,
  //       'id_attribute_group': idAttributeGroup,
  //       'id_attribute': idAttribute,
  //       'code_coleur': codeColeur,
  //       'name': name,
  //     };
  //   }

  // extension FirstWhereOrNull<T> on Iterable<T> {
  //   T? firstWhereOrNull(bool Function(T) test) {
  //     for (var element in this) {
  //       if (test(element)) {
  //         return element;
  //       }
  //     }
  //     return null;
  //   }

  //   split(String s) {}
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

  // extension CartProductExtension on Product {
  //   bool get canAddToCart => inStock && active;
  //   bool canAddColorToCart(String attributeId) {
  //     return isInStockForColor(attributeId) && active;
  //   }

  //   int get maxCartQuantity {
  //     return stock;
  //   }

  //   bool isValidQuantity(int qty) {
  //     return qty > 0 && qty <= maxCartQuantity;
  //   }

  //   String getDisplayName([String? attributeId]) {
  //     if (attributeId != null && hasCombinations) {
  //       final combo = getCombination(attributeId);
  //       if (combo != null) {
  //         return '$name - ${combo.colorName}';
  //       }
  //     }
  //     return name;
  //   }
}
