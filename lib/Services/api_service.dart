import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/model/carrier_model.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/model/shop_model.dart';
import 'package:tawasul_application/model/store_details_model.dart';

class ApiService {
  static const String baseUrl = "http://t-api.dotit-corp.com/api";
  static const int timeoutSeconds = 30;

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final token = await _getAuthToken();
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept-Language': language,
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      return headers;
    } catch (e) {
      return {'Content-Type': 'application/json'};
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    try {
      final token = await _getAuthToken();
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept-Language': language,
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      return headers;
    } catch (e) {
      return {'Content-Type': 'application/json'};
    }
  }

  //LOGIN
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      debugPrint(" STARTING LOGIN PROCESS");

      // Create the request body
      final Map<String, dynamic> requestBodyMap = {
        'username': username.trim(),
        'password': password.trim(),
      };

      final requestBody = jsonEncode(requestBodyMap);

      final response = await http
          .post(
            Uri.parse('$baseUrl/public/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: requestBody,
          )
          .timeout(Duration(seconds: timeoutSeconds));
      developer.log(response.body);
      debugPrint("Making API call to: $baseUrl/public/login");
      debugPrint("Request body: $requestBody");
      debugPrint(
        "Headers: ${{'Content-Type': 'application/json', 'Accept': 'application/json'}}",
      );

      // Handle empty response
      if (response.body.isEmpty) {
        debugPrint("EMPTY RESPONSE FROM SERVER");
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        debugPrint("LOGIN SUCCESSFUL! TOKEN RECEIVED");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseData['token']);
        return {'success': true, 'token': responseData['token']};
      } else {
        debugPrint("LOGIN FAILED: ${responseData['message']}");
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid login credentials',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      debugPrint("Error type: ${e.runtimeType}");
      debugPrint(" Stack trace: ${e.toString()}");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // authToken = null;
  }

  //Product detail
  static Future<Product?> getProductDetail({
    required String code,
    required String shopId,
  }) async {
    try {
      final url = '$baseUrl/public/getProduct?code=$code&id-shop=$shopId';
      print(" Request URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print(" Raw API Response: ${response.body}");
      final data = jsonDecode(response.body);
      print(" DEBUG - Full response structure:");
      _printJsonStructure(data, 0);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['response'] != null) {
          if (data['response'] is List && data['response'].isNotEmpty) {
            return Product.fromJson(data['response'][0]);
          } else if (data['response']['product'] != null) {
            return Product.fromJson(data['response']['product']);
          }
        }

        print(" No valid product found in response");
        return null;
      } else {
        print(" API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Exception in getProductDetail: $e");
      return null;
    }
  }

  static void _printJsonStructure(dynamic json, int indent) {
    if (json is Map) {
      json.forEach((key, value) {
        print('${'  ' * indent}$key: ${value.runtimeType}');
        if (value is Map || value is List) {
          _printJsonStructure(value, indent + 1);
        }
      });
    } else if (json is List) {
      if (json.isNotEmpty) {
        print('${'  ' * indent}List[0]: ${json[0].runtimeType}');
        if (json[0] is Map || json[0] is List) {
          _printJsonStructure(json[0], indent + 1);
        }
      }
    }
  }

  // GET FAVORITE PRODUCTS
  static Future<List<Product>> getFavoriteProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/user/favorites'),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response'] != null && data['response'] is List) {
          return data['response'].map<Product>((productJson) {
            return Product(
              id: int.tryParse(productJson['id']?.toString() ?? '0') ?? 0,
              name: productJson['name'] ?? 'No Name',
              brand: productJson['brand'] ?? 'No Brand',
              price: productJson['price']?.toString() ?? '0',
              image: productJson['image'] ?? '',
              description: productJson['description'] ?? 'No Description',

              oldPrice: productJson['oldPrice']?.toString(),
              discount: productJson['discount']?.toString(),
              isFavorite: true,
              reference: productJson['reference'] ?? 'N/A',
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching favorite products: $e");
      return [];
    }
  }

  // TOGGLE FAVORITE STATUS
  static Future<bool> toggleFavorite(int productId, bool isFavorite) async {
    try {
      final endpoint =
          isFavorite
              ? '$baseUrl/user/favorites/add'
              : '$baseUrl/user/favorites/remove';

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: await _getAuthHeaders(),
            body: jsonEncode({'product_id': productId}),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      return response.statusCode == 200;
    } catch (e) {
      print("Error toggling favorite: $e");
      return false;
    }
  }

  // FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/public/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      final responseData = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': responseData['message'] ?? 'Password reset email sent',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send password reset email',
      };
    }
  }

  // GET CATEGORY PRODUCTS
  static Future<List<Product>> getCategoryProducts({
    required String categoryCode,
    required String shopId,
  }) async {
    try {
      final url =
          '$baseUrl/public/getCategoryProducts?code=$categoryCode&id-shop=$shopId';
      print(" API URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Parsed Data: $data");

        if (data['response'] != null && data['response']['products'] != null) {
          final products = data['response']['products'];

          print(" Products found: ${products.length}");

          for (
            var i = 0;
            i < (products.length > 3 ? 3 : products.length);
            i++
          ) {
            final product = products[i];
            print(
              "Product ${i + 1}: ${product['name']} - Added: ${product['date_add']}",
            );
          }

          return (products as List).map<Product>((productJson) {
            return Product(
              id:
                  int.tryParse(productJson['id_product']?.toString() ?? '0') ??
                  0,
              reference: productJson['reference'] ?? 'N/A',

              name: productJson['name'] ?? 'No Name',
              brand: productJson['manufacturer_name'] ?? 'No Brand',
              price: productJson['price']?.toString() ?? '0',
              image: productJson['image'] ?? '',
              description: productJson['description_short'] ?? 'No Description',
              oldPrice: productJson['price_without_reduction']?.toString(),
              discount:
                  productJson['reduction'] != null &&
                          productJson['reduction'] > 0
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
      print(" Exception in getCategoryProducts: $e");
      return [];
    }
  }

  // // GET CATEGORY PRODUCTS
  // static Future<List<Product>> getCategoryProducts({
  //   required String categoryCode,
  //   required String shopId,
  // }) async {
  //   try {
  //     final url =
  //         '$baseUrl/public/getCategoryProducts?code=$categoryCode&id-shop=$shopId';
  //     print("📦 API URL: $url");

  //     final response = await http
  //         .get(Uri.parse(url), headers: await _getAuthHeaders())
  //         .timeout(Duration(seconds: timeoutSeconds));

  //     print("📦 Status Code: ${response.statusCode}");

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data['response'] != null && data['response']['products'] != null) {
  //         final products = data['response']['products'];
  //         print("📦 Products found: ${products.length}");

  //         // Parse and sort by date_add (newest first)
  //         final productList =
  //             (products as List).map<Product>((productJson) {
  //               return Product(
  //                 id:
  //                     int.tryParse(
  //                       productJson['id_product']?.toString() ?? '0',
  //                     ) ??
  //                     0,
  //                 reference: productJson['reference'] ?? 'N/A',
  //                 name: productJson['name'] ?? 'No Name',
  //                 brand: productJson['manufacturer_name'] ?? 'No Brand',
  //                 price: productJson['price']?.toString() ?? '0',
  //                 image: _parseProductImage(productJson), // Use helper function
  //                 description:
  //                     productJson['description_short'] ?? 'No Description',
  //                 oldPrice: productJson['price_without_reduction']?.toString(),
  //                 discount:
  //                     productJson['reduction'] != null &&
  //                             productJson['reduction'] > 0
  //                         ? '${(productJson['reduction'] * 100).toStringAsFixed(0)}% OFF'
  //                         : null,
  //               );
  //             }).toList();

  //         // Sort by date_add (newest first)
  //         productList.sort((a, b) {
  //           // You might need to parse date_add if it's available in the response
  //           return 0; // Placeholder - implement actual date sorting
  //         });

  //         return productList;
  //       }
  //       print("❌ No products found in response structure");
  //       return [];
  //     } else {
  //       print("❌ API Error: ${response.statusCode}");
  //       return [];
  //     }
  //   } catch (e) {
  //     print("❌ Exception in getCategoryProducts: $e");
  //     return [];
  //   }
  // }

  // Helper function to parse product image
  static String _parseProductImage(Map<String, dynamic> productJson) {
    // Check if cover_image_id is available
    if (productJson['cover_image_id'] != null) {
      final imageId = productJson['cover_image_id'].toString();
      return 'https://t-api.dotit-corp.com/images/products/${productJson['id_product']}/$imageId.jpg';
    }

    // Check if id_image is available
    if (productJson['id_image'] != null) {
      final imageId = productJson['id_image'].toString();
      return 'https://t-api.dotit-corp.com/images/products/${productJson['id_product']}/$imageId.jpg';
    }

    return ''; // Return empty string if no image found
  }

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      // Try parsing with space replacement
      return DateTime.parse(dateString.replaceFirst(" ", "T"));
    } catch (_) {
      try {
        // Fallback to simple parsing without T
        return DateTime.parse(dateString);
      } catch (e) {
        print(" Error parsing date: $dateString, error: $e");
        return null;
      }
    }
  }

  // RESET PASSWORD
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/public/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'token': token,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      final responseData = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': responseData['message'] ?? 'Password reset successfully',
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to reset password'};
    }
  }

  // TEST API CONNECTION
  static Future<void> testApiConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getCategoryProducts?code=10&id-shop=4'),
          )
          .timeout(Duration(seconds: 10));

      print(" API Connection Test:");
      print(" Status Code: ${response.statusCode}");
      print(" Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" API Connection Successful!");
        print(" Response Structure: ${data.keys.toList()}");
      } else {
        print(" API Connection Failed!");
      }
    } catch (e) {
      print(" API Connection Error: $e");
    }
  }

  static String formatImagePath(dynamic imageId) {
    if (imageId == null || imageId.toString().isEmpty) return '';

    final String id = imageId.toString();

    // Handle the format "1875-282588" by taking the part after dash
    String imageIdPart = id;
    if (id.contains('-')) {
      imageIdPart = id.split('-')[1];
    }

    // For 282588, create path: 2/8/2/5/8/8/282588
    if (imageIdPart.length >= 6) {
      final digits = imageIdPart.split('');
      return '${digits[0]}/${digits[1]}/${digits[2]}/${digits[3]}/${digits[4]}/${digits[5]}/$imageIdPart';
    }

    return imageIdPart;
  }

  // Update the getProductsFromCategory method to handle the actual API structure
  static Future<List<Product>> getProductsFromCategory(
    String categoryName,
  ) async {
    try {
      print("Getting products for category: $categoryName");

      // First get the category code
      final categoryCode = await getCategoryCodeByName(categoryName);

      if (categoryCode.isEmpty) {
        print(" Could not find category code for $categoryName");
        return [];
      }

      print(" Using category code: $categoryCode");

      //Extract products from the category structure
      final categoryData = await getCategoryStructure();

      if (categoryData['response'] != null &&
          categoryData['response'] is List) {
        final rootCategories = List<Map<String, dynamic>>.from(
          categoryData['response'],
        );

        // Recursively search for the category and extract products
        final products = _extractProductsFromCategoryRecursive(
          rootCategories,
          categoryCode,
        );

        print(" Extracted ${products.length} products from category structure");
        return products;
      }

      return [];
    } catch (e) {
      print("Error getting products for category $categoryName: $e");
      return [];
    }
  }

  // Helper method to extract products from category structure recursively
  static List<Product> _extractProductsFromCategoryRecursive(
    List<Map<String, dynamic>> categories,
    String targetCode,
  ) {
    final List<Product> products = [];

    for (var category in categories) {
      // Check if this is the target category
      if (category['code']?.toString() == targetCode) {
        print(" Found target category: ${category['name']}");

        // If this category has products directly, extract them
        if (category['products'] != null && category['products'] is List) {
          final categoryProducts = List<Map<String, dynamic>>.from(
            category['products'],
          );
          for (var product in categoryProducts) {
            products.add(Product.fromJson(product));
          }
        }

        // Also check child categories for products
        if (category['childs'] != null && category['childs'] is List) {
          final childCategories = List<Map<String, dynamic>>.from(
            category['childs'],
          );
          for (var child in childCategories) {
            if (child['products'] != null && child['products'] is List) {
              final childProducts = List<Map<String, dynamic>>.from(
                child['products'],
              );
              for (var product in childProducts) {
                products.add(Product.fromJson(product));
              }
            }
          }
        }

        break;
      }

      // Recursively search child categories
      if (category['childs'] != null && category['childs'] is List) {
        final childCategories = List<Map<String, dynamic>>.from(
          category['childs'],
        );
        products.addAll(
          _extractProductsFromCategoryRecursive(childCategories, targetCode),
        );
      }
    }

    return products;
  }

  // Helper method to extract products from category structure
  static List<Product> _extractProductsFromCategory(
    Map<String, dynamic> category,
  ) {
    final List<Product> products = [];

    // Recursively extract products from all subcategories
    void extractFromSubcategories(Map<String, dynamic> currentCategory) {
      // If this category has products directly (check based on your API structure)
      if (currentCategory['products'] != null &&
          currentCategory['products'] is List) {
        final categoryProducts = List<Map<String, dynamic>>.from(
          currentCategory['products'],
        );
        for (var product in categoryProducts) {
          products.add(Product.fromJson(product));
        }
      }

      // Recursively check child categories
      if (currentCategory['childs'] != null &&
          currentCategory['childs'] is List) {
        final childCategories = List<Map<String, dynamic>>.from(
          currentCategory['childs'],
        );
        for (var child in childCategories) {
          extractFromSubcategories(child);
        }
      }
    }

    extractFromSubcategories(category);
    print(" Extracted ${products.length} products from ${category['name']}");
    return products;
  }

  static Future<List<Product>> getProductsUsingCategoryCode(
    String categoryName,
  ) async {
    try {
      final categoryCode = await getCategoryCodeByName(categoryName);
      if (categoryCode.isEmpty) {
        print(" Could not find category code for $categoryName");
        return [];
      }

      print(" Using category code: $categoryCode for $categoryName");
      return [];
    } catch (e) {
      print("Error getting products using category code: $e");
      return [];
    }
  }

  //Get Category Structure
  static Future<Map<String, dynamic>> getCategoryStructure() async {
    try {
      final url = '$baseUrl/public/getCategories';
      print(" Fetching category structure from: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print(" Failed to fetch category structure: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print(" Exception in getCategoryStructure: $e");
      return {};
    }
  }
  // Similar product part

  static Future<String?> getProductCategoryCode(int productId) async {
    try {
      final url = '$baseUrl/public/getProductCategory?product_id=$productId';
      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['category_code']?.toString();
      }

      final productDetail = await getProductDetail(
        code: productId.toString(),
        shopId: '4',
      );

      return productDetail?.categoryCode;
    } catch (e) {
      print("Error fetching product category: $e");
      return null;
    }
  }

  //debug api response
  static Future<void> debugApiResponse() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/getCategories'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("=== API RESPONSE DEBUG ===");
        print("Full response: $data");

        if (data['response'] != null && data['response'] is List) {
          final categories = List<Map<String, dynamic>>.from(data['response']);
          print("Root categories count: ${categories.length}");

          for (var i = 0; i < categories.length; i++) {
            final category = categories[i];
            print(
              "${i + 1}. ${category['name']} (ID: ${category['id']}, Code: ${category['code']})",
            );

            if (category['childs'] != null && category['childs'] is List) {
              final childs = List<Map<String, dynamic>>.from(
                category['childs'],
              );
              print("   Childs: ${childs.length}");

              for (var j = 0; j < childs.length; j++) {
                final child = childs[j];
                print(
                  "   └─ ${j + 1}. ${child['name']} (ID: ${child['id']}, Code: ${child['code']})",
                );
              }
            }
          }
        }
        print("=== END DEBUG ===");
      } else {
        print(" API request failed: ${response.statusCode}");
      }
    } catch (e) {
      print(" Debug API error: $e");
    }
  }

  // Get Category Code By Name method
  static Future<String> getCategoryCodeByName(String categoryName) async {
    try {
      final categoryData = await getCategoryStructure();

      print(" Parsing category structure for: $categoryName");
      print("Full response: $categoryData");

      if (categoryData['response'] != null &&
          categoryData['response'] is List) {
        final rootCategories = List<Map<String, dynamic>>.from(
          categoryData['response'],
        );

        print(" Root categories found: ${rootCategories.length}");

        // Print all root categories for debugging
        for (var i = 0; i < rootCategories.length; i++) {
          final category = rootCategories[i];
          print("   ${i + 1}. ${category['name']} (ID: ${category['id']})");

          // Check if this is the "Accueil" category
          if (category['name'] == 'Accueil' || category['id'] == '2') {
            print(" Found Accueil category!");

            if (category['childs'] != null && category['childs'] is List) {
              final childCategories = List<Map<String, dynamic>>.from(
                category['childs'],
              );

              print(
                "   Child categories of Accueil: ${childCategories.length}",
              );

              // Print all child categories
              for (var j = 0; j < childCategories.length; j++) {
                final child = childCategories[j];
                print(
                  "   └─ ${j + 1}. ${child['name']} (ID: ${child['id']}, Code: ${child['code']})",
                );

                // Check if this is the target category
                if (child['name']?.toLowerCase() ==
                    categoryName.toLowerCase()) {
                  print(
                    " Found $categoryName category! Code: ${child['code']}",
                  );
                  return child['code']?.toString() ?? '';
                }
              }

              // If exact name match not found, try partial match
              for (var j = 0; j < childCategories.length; j++) {
                final child = childCategories[j];
                if (child['name']?.toLowerCase().contains(
                      categoryName.toLowerCase(),
                    ) ==
                    true) {
                  print(
                    " Found similar category: ${child['name']} with code: ${child['code']}",
                  );
                  return child['code']?.toString() ?? '';
                }
              }
            } else {
              print("Accueil category has no childs");
            }
          }
        }

        // Alternative approach: Search through all categories recursively
        print(" Searching through all categories recursively...");
        final foundCode = _findCategoryCodeRecursive(
          rootCategories,
          categoryName,
        );
        if (foundCode.isNotEmpty) {
          return foundCode;
        }
      } else {
        print("No response data found in API response");
      }

      return '';
    } catch (e) {
      print("Error getting category code for $categoryName: $e");
      return '';
    }
  }

  // Helper method to search for category code recursively
  static String _findCategoryCodeRecursive(
    List<Map<String, dynamic>> categories,
    String targetName,
  ) {
    for (var category in categories) {
      // Check if current category matches
      if (category['name']?.toLowerCase() == targetName.toLowerCase()) {
        print(" Found $targetName recursively! Code: ${category['code']}");
        return category['code']?.toString() ?? '';
      }

      // Check if current category contains target name
      if (category['name']?.toLowerCase().contains(targetName.toLowerCase()) ==
          true) {
        print(
          " Found similar category recursively: ${category['name']} with code: ${category['code']}",
        );
        return category['code']?.toString() ?? '';
      }

      // Recursively search child categories
      if (category['childs'] != null && category['childs'] is List) {
        final childCategories = List<Map<String, dynamic>>.from(
          category['childs'],
        );
        final foundCode = _findCategoryCodeRecursive(
          childCategories,
          targetName,
        );
        if (foundCode.isNotEmpty) {
          return foundCode;
        }
      }
    }

    return '';
  }

  // method with hardcoded category codes
  static Map<String, String> getHardcodedCategoryCodes() {
    return {
      'HighTech': '10',
      'Smart Home': '11',
      'Smart Office': '12',
      'Lifestyle': '13',
      'hightech': '10',
      'high tech': '10',
      'smart home': '11',
      'smart-home': '11',
      'smart office': '12',
      'smart-office': '12',
      'lifestyle': '13',
    };
  }

  static String getHardcodedCategoryCode(String categoryName) {
    final categoryMap = getHardcodedCategoryCodes();
    final lowerName = categoryName.toLowerCase();

    // Try exact match first
    if (categoryMap[lowerName] != null) {
      return categoryMap[lowerName]!;
    }

    // Try partial match
    for (var key in categoryMap.keys) {
      if (lowerName.contains(key) || key.contains(lowerName)) {
        return categoryMap[key]!;
      }
    }

    return '';
  }

  //getAuthHeadersForDebug
  static Future<Map<String, String>> getAuthHeadersForDebug() async {
    return await _getAuthHeaders();
  }

  //  debug method
  static Future<void> debugCategoryStructure() async {
    try {
      final categoryData = await getCategoryStructure();
      print("=== DEBUG CATEGORY STRUCTURE ===");

      if (categoryData['response'] != null &&
          categoryData['response'] is List) {
        final rootCategories = List<Map<String, dynamic>>.from(
          categoryData['response'],
        );

        for (var rootCategory in rootCategories) {
          print(
            "Root category: ${rootCategory['name']} (ID: ${rootCategory['id']})",
          );

          if (rootCategory['childs'] != null) {
            final childCategories = List<Map<String, dynamic>>.from(
              rootCategory['childs'],
            );

            for (var childCategory in childCategories) {
              print(
                "  └─ Child: ${childCategory['name']} (ID: ${childCategory['id']}, Code: ${childCategory['code']})",
              );

              if (childCategory['childs'] != null) {
                final grandChildCategories = List<Map<String, dynamic>>.from(
                  childCategory['childs'],
                );

                for (var grandChild in grandChildCategories) {
                  print(
                    "      └─ Grandchild: ${grandChild['name']} (ID: ${grandChild['id']}, Code: ${grandChild['code']})",
                  );
                }
              }
            }
          }
        }
      }
      print("=== END DEBUG ===");
    } catch (e) {
      print("Error debugging category structure: $e");
    }
  }

  //Categories
  static Future<List<Product>> getProductsByCategoryName(
    String categoryName,
  ) async {
    try {
      String categoryCode = await getCategoryCodeByName(categoryName);

      if (categoryCode.isEmpty) {
        categoryCode = getHardcodedCategoryCode(categoryName);
      }

      if (categoryCode.isEmpty) {
        print("Could not find category code for $categoryName");
        return [];
      }

      print(" Fetching products for $categoryName with code: $categoryCode");

      return await getCategoryProducts(categoryCode: categoryCode, shopId: '4');
    } catch (e) {
      print("Error fetching products for $categoryName: $e");
      return [];
    }
  }

  //CART METHODS
  static Future<Map<String, dynamic>> getCart(int shopId) async {
    try {
      final headers = await _getHeaders();

      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getCart?id-shop=$shopId'),
            headers: headers,
          )
          .timeout(Duration(seconds: 10));

      print('Cart API Response Status: ${response.statusCode}');
      print('Cart API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load cart. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart: $e');
      throw Exception('Error fetching cart: $e');
    }
  }

  //UPDATE CART
  static Future<Map<String, dynamic>> updateCart({
    required int shopId,
    required String cartId,
    required int customerId,
    required String customerEmail,
    required List<Map<String, dynamic>> cartDetails,
    int addressDeliveryId = 1,
    int addressInvoiceId = 1,
    int carrierId = 1,
  }) async {
    try {
      final headers = await _getHeaders();

      final requestBody = {
        'cart_summary': {
          'idShop': shopId,
          'idAddressDelivery': addressDeliveryId,
          'idAddressInvoice': addressInvoiceId,
          'idCustomer': customerId,
          'idCarrier': carrierId,
          'idCart': int.parse(cartId),
          'emailCustomer': customerEmail,
        },
        'cart_details': cartDetails,
      };

      print('Update Cart Request: ${json.encode(requestBody)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/public/updateCart'),
            headers: {...headers, 'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 10));

      print('Update Cart API Response Status: ${response.statusCode}');
      print('Update Cart API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception(
          'Failed to update cart. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating cart: $e');
      throw Exception('Error updating cart: $e');
    }
  }

  //ADD TO CART
  static Future<bool> addToCart(
    String productCode,
    int quantity, {
    String? color,
    int shopId = 4,
    required int customerId,
    required String customerEmail,
  }) async {
    try {
      print(
        'Adding to cart - Product: $productCode, Qty: $quantity, Color: $color',
      );

      // First get the current cart to get the cartId
      final cartResponse = await getCart(shopId);

      if (cartResponse['message'] == 'success' ||
          cartResponse['status'] == 'success') {
        // Extract cart ID from response - adjust based on your actual response structure
        String cartId = '0';
        if (cartResponse['response'] != null &&
            cartResponse['response']['cart_summary'] != null) {
          cartId =
              cartResponse['response']['cart_summary']['idCart']?.toString() ??
              '0';
        }

        final response = await updateCart(
          shopId: shopId,
          cartId: cartId,
          customerId: customerId,
          customerEmail: customerEmail,
          cartDetails: [
            {
              'code': productCode,
              'quantity': quantity,
              'operator':
                  'up', // Use 'up' for add/update as per Postman example
              if (color != null) 'color': color,
            },
          ],
        );

        // Check for success based on your API response structure
        final success =
            response['message'] == 'success' || response['status'] == 'success';
        print('Add to cart success: $success');
        return success;
      }

      return false;
    } catch (e) {
      print('Error in addToCart: $e');
      return false;
    }
  }

  // REMOVE FROM CART
  static Future<bool> removeFromCart(
    String productCode,
    int shopId,
    String cartId,
    int customerId,
    String customerEmail,
  ) async {
    try {
      final response = await updateCart(
        shopId: shopId,
        cartId: cartId,
        customerId: customerId,
        customerEmail: customerEmail,
        cartDetails: [
          {'code': productCode, 'operator': 'del', 'quantity': 0},
        ],
      );

      return response['message'] == 'success' ||
          response['status'] == 'success';
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // UPDATED CART QUANTITY
  static Future<bool> updateCartQuantity(
    String productCode,
    int newQuantity,
    int shopId,
    String cartId,
    int customerId,
    String customerEmail,
  ) async {
    try {
      final response = await updateCart(
        shopId: shopId,
        cartId: cartId,
        customerId: customerId,
        customerEmail: customerEmail,
        cartDetails: [
          {'code': productCode, 'operator': 'up', 'quantity': newQuantity},
        ],
      );

      return response['message'] == 'success' ||
          response['status'] == 'success';
    } catch (e) {
      print('Error updating cart quantity: $e');
      return false;
    }
  }

  //CLEAR CART
  static Future<bool> clearCart(
    int shopId,
    String cartId,
    int customerId,
    String customerEmail,
  ) async {
    try {
      // First get current cart items
      final cartResponse = await getCart(shopId);

      if (cartResponse['message'] == 'success' ||
          cartResponse['status'] == 'success') {
        final cartDetails = cartResponse['response']['cart_details'] ?? [];

        // Create delete operations for all items
        final List<Map<String, dynamic>> clearOperations = [];
        for (var item in cartDetails) {
          clearOperations.add({
            'code': item['code'],
            'operator': 'del',
            'quantity': 0,
          });
        }

        if (clearOperations.isNotEmpty) {
          final response = await updateCart(
            shopId: shopId,
            cartId: cartId,
            customerId: customerId,
            customerEmail: customerEmail,
            cartDetails: clearOperations,
          );

          return response['message'] == 'success' ||
              response['status'] == 'success';
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> createAddress(
    Map<String, dynamic> addressData,
  ) async {
    try {
      final headers = await _getHeaders();

      final response = await http
          .post(
            Uri.parse('$baseUrl/newAddress'),
            headers: headers,
            body: json.encode(addressData),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating address: $e');
    }
  }

  static Future<Map<String, dynamic>?> getCustomerDetails() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http
          .get(Uri.parse('$baseUrl/customerDetails'), headers: headers)
          .timeout(Duration(seconds: timeoutSeconds));

      print("Customer Details API Response: ${response.statusCode}");
      print("Customer Details API Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['message'] == 'success' && data['response'] != null) {
          return data['response'];
        } else {
          print("API returned error: ${data['message']}");
          return null;
        }
      } else {
        print("Failed to fetch customer details: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in getCustomerDetails: $e");
      return null;
    }
  }

  // Get addresses
  static Future<List<dynamic>> getAddresses() async {
    try {
      final token = await _getAuthToken();
      final res = await http.get(
        Uri.parse('$baseUrl/Address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['response'] ?? [];
      }
      return [];
    } catch (e) {
      print('getAddresses error: $e');
      return [];
    }
  }

  // Add address -> POST
  static Future<bool> addAddress(Map<String, dynamic> body) async {
    try {
      final token = await _getAuthToken();

      final requestBody = {
        'address1': body['address1'],
        'address2': body['address2'] ?? '',
        'lastName': body['lastName'],
        'firstName': body['firstName'],
        'city': body['city'],
        'postcode': body['postcode'] ?? '',
        'phone': body['phoneNumber'] ?? '',
      };

      print('Sending add address request: ${json.encode(requestBody)}');

      final res = await http.post(
        Uri.parse('$baseUrl/newAddress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('Add address response: ${res.statusCode} - ${res.body}');

      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        return responseData['message'] == 'success';
      }
      return false;
    } catch (e) {
      print('addAddress error: $e');
      return false;
    }
  }

  // Update address -> PUT
  static Future<bool> updateAddress(
    String code,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _getAuthToken();

      final requestBody = {
        'code': code,
        'address1': body['address1'],
        'address2': body['address2'] ?? '',
        'lastName': body['lastName'],
        'firstName': body['firstName'],
        'city': body['city'],
        'postcode': body['postcode'] ?? '',
        'phone': body['phoneNumber'] ?? '',
      };

      print('Sending update address request: ${json.encode(requestBody)}');

      final res = await http.post(
        Uri.parse('$baseUrl/updateAddress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('Update address response: ${res.statusCode} - ${res.body}');

      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        return responseData['message'] == 'success';
      }
      return false;
    } catch (e) {
      print('updateAddress error: $e');
      return false;
    }
  }

  // Delete address -> DELETE
  static Future<bool> deleteAddress(String code) async {
    try {
      final token = await _getAuthToken();

      print('Sending delete address request for code: $code');

      final res = await http.delete(
        Uri.parse('$baseUrl/deleteAddress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'code': code}),
      );

      print('Delete address response: ${res.statusCode} - ${res.body}');

      return res.statusCode == 200;
    } catch (e) {
      print('deleteAddress error: $e');
      return false;
    }
  }

  // Get shipping methods
  static Future<List<Carrier>> getShippingMethods({
    required int idCart,
    required String emailCustomer,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shipping'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idCart': idCart, 'emailCustomer': emailCustomer}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['message'] == 'success' && data['response'] is List) {
          return data['response']
              .map<Carrier>((item) => Carrier.fromJson(item))
              .toList();
        }
      }

      print('Shipping API error: ${response.statusCode}');
      return [];
    } catch (e) {
      print('getShippingMethods error: $e');
      return [];
    }
  }

  // Get stores for a relay group
  static Future<List<Shop>> getShippingStores({
    required int idCart,
    required String emailCustomer,
    required int idGroup,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shippingstore'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idCart': idCart,
          'emailCustomer': emailCustomer,
          'id_group': idGroup,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['message'] == 'success' && data['response'] is List) {
          return data['response']
              .map<Shop>((item) => Shop.fromShippingJson(item))
              .toList();
        }
      }

      print('ShippingStore API error: ${response.statusCode}');
      return [];
    } catch (e) {
      print('getShippingStores error: $e');
      return [];
    }
  }

  // Get store hours
  static Future<StoreDetails?> getStoreHours({
    required int idCart,
    required String emailCustomer,
    required int idRelay,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shippingstorehours'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idCart': idCart,
          'emailCustomer': emailCustomer,
          'id_relay': idRelay,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['message'] == 'success' && data['response'] is Map) {
          return StoreDetails.fromJson(data['response']);
        }
      }

      print('ShippingStoreHours API error: ${response.statusCode}');
      return null;
    } catch (e) {
      print('getStoreHours error: $e');
      return null;
    }
  }
}
