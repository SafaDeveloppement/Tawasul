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
  });

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
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    print('=== PARSING PRODUCT JSON ===');
    print('Product name: ${json['name']}');
    print('Raw image value: ${json['image']}');

    // Parse ID
    final id = _parseProductId(json);
    print('Parsed ID: $id');

    // Parse price
    final price = _parsePrice(json['price']);
    print('Parsed price: $price');

    // Parse image - SIMPLIFIED
    final image = _parseImageUrl(json);
    print('Final image URL: ${image.isNotEmpty ? image : "EMPTY"}');

    // Parse description
    final description = _parseDescription(json);
    print('Description length: ${description.length}');

    // Parse brand - handle null case properly
    final brand = json['manufacturer']?.toString() ?? 'Unknown Brand';
    print('Brand: $brand');

    return Product(
      id: id,
      reference: json['id_product']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      brand: brand,
      price: price,
      image: image, // This should now work correctly
      description: description,
      oldPrice: _parsePrice(json['price_without_reduction']),
      discount: _parseDiscount(json['reduction']),
      attributes: _parseAttributes(json['combinaisons'] as List<dynamic>?),
      url: json['link']?.toString(),
      showPrice: true,
      weightUnit: null,
      embeddedAttributes: _parseEmbeddedAttributes(json),
      isFavorite: false,
      isBestSeller: false,
      colors: _parseColors(json['combinaisons'] as List<dynamic>?),
      category: json['category_name']?.toString(),
      categoryCode: json['id_category_default']?.toString(),
      categoryId:
          json['id_category_default'] is int
              ? json['id_category_default'] as int
              : int.tryParse(json['id_category_default']?.toString() ?? ''),
      stock:
          json['stock'] is int
              ? json['stock'] as int
              : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
    );
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
    print('=== IMAGE PARSING START ===');
    print('Image field value: ${json['image']}');
    print('Image field type: ${json['image']?.runtimeType}');

    // Priority 1: Direct 'image' field from API
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final imageUrl = json['image'].toString().trim();
      print('Raw image URL: "$imageUrl"');

      // Check if it's not null string and not empty
      if (imageUrl != 'null' && imageUrl.isNotEmpty) {
        // Validate and return the URL
        final validatedUrl = _validateImageUrl(imageUrl);
        print('Validated image URL: $validatedUrl');
        return validatedUrl;
      }
    }

    print('No valid image URL found, returning empty string');
    return ''; // Return empty string for no image
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
      return 'https://tawasul-shop.com$url';
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

  static Map<String, dynamic>? _parseAttributes(List<dynamic>? combinaisons) {
    if (combinaisons == null || combinaisons.isEmpty) return null;

    final attributes = <String, dynamic>{};
    for (var combo in combinaisons) {
      if (combo is Map<String, dynamic>) {
        final group = combo['id_attribute_group']?.toString();
        final value = combo['name']?.toString();
        if (group != null && value != null && value.trim().isNotEmpty) {
          attributes[group] = value.trim();
        }
      }
    }

    return attributes.isNotEmpty ? attributes : null;
  }

  static List<Color>? _parseColors(List<dynamic>? combinaisons) {
    if (combinaisons == null || combinaisons.isEmpty) return null;

    final colors = <Color>[];
    final addedColorCodes = <String>{};

    for (var combo in combinaisons) {
      if (combo is Map<String, dynamic>) {
        final colorCode = combo['code_coleur']?.toString();
        if (colorCode != null &&
            colorCode.isNotEmpty &&
            colorCode.startsWith('#') &&
            !addedColorCodes.contains(colorCode)) {
          try {
            // Handle 3-digit and 6-digit hex codes
            String hexCode = colorCode.substring(1);
            if (hexCode.length == 3) {
              // Expand 3-digit to 6-digit hex
              hexCode = hexCode.split('').map((c) => c + c).join();
            }

            if (hexCode.length == 6) {
              final colorValue = int.parse(hexCode, radix: 16) + 0xFF000000;
              colors.add(Color(colorValue));
              addedColorCodes.add(colorCode);
            }
          } catch (e) {
            print('Color parsing error for $colorCode: $e');
          }
        }
      }
    }

    return colors.isNotEmpty ? colors : null;
  }

  static Map<String, dynamic> _parseEmbeddedAttributes(
    Map<String, dynamic> json,
  ) {
    final embedded = <String, dynamic>{};

    if (json['category_name'] != null) {
      embedded['category'] = json['category_name'];
    }
    if (json['manufacturer'] != null) {
      embedded['manufacturer_name'] = json['manufacturer'];
    }
    if (json['description'] != null) {
      embedded['description_short'] = json['description'];
    }
    if (json['price'] != null) {
      embedded['price'] = json['price'];
    }
    if (json['price_without_reduction'] != null) {
      embedded['price_without_reduction'] = json['price_without_reduction'];
    }

    return embedded;
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

  // Helper methods
  String get formattedPrice {
    return 'LYD ${price.toStringAsFixed(3)}';
  }

  String? get formattedOldPrice {
    return oldPrice != null ? 'LYD ${oldPrice!.toStringAsFixed(3)}' : null;
  }

  bool get hasDiscount {
    return oldPrice != null && oldPrice! > price;
  }

  double? get discountPercentage {
    if (oldPrice != null && oldPrice! > 0 && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice!) * 100;
    }
    return null;
  }

  bool get inStock {
    return stock > 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: "$name", price: LYD $price, image: "${image.isNotEmpty ? "✓" : "✗"}", stock: $stock}';
  }

  // Debug method
  void printDebugInfo() {
    print('=== PRODUCT DEBUG INFO ===');
    print('ID: $id');
    print('Name: $name');
    print('Brand: $brand');
    print('Price: LYD $price');
    print('Image URL: ${image.isNotEmpty ? image : "EMPTY"}');
    print('Image URL length: ${image.length}');
    print(
      'Description: ${description.substring(0, min(50, description.length))}...',
    );
    print('Category: $category');
    print('Stock: $stock');
    print('URL: $url');
    print('==========================');
  }

  int min(int a, int b) => a < b ? a : b;
}
