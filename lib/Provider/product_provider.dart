import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tawasul_application/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _similarProducts = [];
  bool _isLoading = false;
  String _error = '';

  List<Product> get similarProducts => _similarProducts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<List<Product>> _getCategoryProducts({
    required String categoryCode,
    required String shopId,
  }) async {
    try {
      final url = 'http://t-api.dotit-corp.com/api/public/getCategoryProducts?code=$categoryCode&id-shop=$shopId';
      print(" API URL: $url");

      final response = await http.get(Uri.parse(url));
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Parsed Data: $data");

        if (data['response'] != null && data['response']['products'] != null) {
          final products = data['response']['products'];
          print(" Products found: ${products.length}");

          return (products as List).map<Product>((productJson) {
            return Product(
              id: int.tryParse(productJson['id_product']?.toString() ?? '0') ?? 0,
              reference: productJson['reference'] ?? 'N/A',
              name: productJson['name'] ?? 'No Name',
              brand: productJson['manufacturer_name'] ?? 'No Brand',
              price: productJson['price']?.toString() ?? '0',
              image: productJson['image'] ?? '',
              description: productJson['description_short'] ?? 'No Description',
              oldPrice: productJson['price_without_reduction']?.toString(),
              discount: productJson['reduction'] != null && productJson['reduction'] > 0
                  ? '${(productJson['reduction'] * 100).toStringAsFixed(0)}% OFF'
                  : null,
            );
          }).toList();
        }
        print(" No products found in response structure");
        return [];
      } else {
        print(" API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print(" Exception in _getCategoryProducts: $e");
      return [];
    }
  }

  Future<void> fetchSimilarProducts({
    required String categoryCode,
    required String shopId,
    int limit = 6,
    String? excludeProductId,
  }) async {
    print(" fetchSimilarProducts called with:");
    print("- categoryCode: $categoryCode");
    print("- shopId: $shopId");
    print("- excludeProductId: $excludeProductId");
    
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Use our new method instead of ApiServices
      final products = await _getCategoryProducts(
        categoryCode: categoryCode,
        shopId: shopId,
      );

      print(" API returned ${products.length} products");

      // Filter out the current product if excludeProductId is provided
      if (excludeProductId != null) {
        _similarProducts = products
            .where((product) => product.id.toString() != excludeProductId)
            .take(limit)
            .toList();
        print(" After filtering, ${_similarProducts.length} products remain");
      } else {
        _similarProducts = products.take(limit).toList();
        print(" No filtering, ${_similarProducts.length} products shown");
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(" Error in fetchSimilarProducts: $e");
      _error = 'Failed to load similar products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSimilarProducts() {
    _similarProducts = [];
    notifyListeners();
  }
}