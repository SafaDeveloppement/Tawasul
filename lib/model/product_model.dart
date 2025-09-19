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
    if (categoryCode == null || categoryCode.isEmpty) {
      categoryCode = '10'; // Default fallback category code
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


