import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/model/product_model.dart';

class ApiService {
  static const String baseUrl = "http://t-api.dotit-corp.com/api";
  static const int timeoutSeconds = 30;
  //static String? authToken;

  // static Future<void> initialize() async {
  //   authToken = await SharedPreferencesService.getAuthToken();
  // }

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
        // print("Category Products API Response: $data");
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

  // static Future<List<Category>> getAllCategories() async {
  //   try {
  //     final url = '$baseUrl/public/getCategories';
  //     final response = await http
  //         .get(Uri.parse(url), headers: await _getAuthHeaders())
  //         .timeout(Duration(seconds: timeoutSeconds));

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data['response'] != null && data['response'] is List) {
  //         return (data['response'] as List)
  //             .map<Category>((categoryJson) => Category.fromJson(categoryJson))
  //             .toList();
  //       }
  //     }
  //     return [];
  //   } catch (e) {
  //     print("Error fetching categories: $e");
  //     return [];
  //   }
  // }

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
          .get(Uri.parse('$baseUrl/getCart?id-shop=$shopId'), headers: headers)
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

  // Update cart with proper authentication
  static Future<Map<String, dynamic>> updateCart({
    required int shopId,
    required String cartId,
    required List<Map<String, dynamic>> cartDetails,
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await http
          .post(
            Uri.parse('$baseUrl/public/updateCart'),
            headers: headers,
            body: json.encode({
              'cart_details': cartDetails,
              'cart_summary': {'idShop': shopId, 'id': cartId},
            }),
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

  // Improved addToCart method
  static Future<bool> addToCart(
    String productCode,
    int quantity, {
    String? color,
    int shopId = 4,
  }) async {
    try {
      print(
        'Adding to cart - Product: $productCode, Qty: $quantity, Color: $color',
      );

      //First try to get the current cart to get the cartId
      try {
        final cartResponse = await getCart(shopId);

        if (cartResponse['message'] == 'success') {
          final cartSummary = cartResponse['response']['cart_summary'];
          final String cartId = cartSummary['cartId'].toString();

          final response = await updateCart(
            shopId: shopId,
            cartId: cartId,
            cartDetails: [
              {
                'code': productCode,
                'operator': 'add',
                'quantity': quantity,
                if (color != null) 'color': color,
              },
            ],
          );

          final success = response['message'] == 'success';
          print('Add to cart success: $success');
          return success;
        }
      } catch (e) {
        print('Error getting cart ID, trying without cart ID: $e');

        //Fallback: try without cart ID (API might create one automatically)
        final response = await updateCart(
          shopId: shopId,
          cartId: '0', //Use 0 or empty string as fallback
          cartDetails: [
            {
              'code': productCode,
              'operator': 'add',
              'quantity': quantity,
              if (color != null) 'color': color,
            },
          ],
        );

        final success = response['message'] == 'success';
        print('Add to cart fallback success: $success');
        return success;
      }

      return false;
    } catch (e) {
      print('Error in addToCart: $e');
      return false;
    }
  }

  //Remove item from cart
  static Future<bool> removeFromCart(
    String productCode,
    int shopId,
    String cartId,
  ) async {
    try {
      final response = await updateCart(
        shopId: shopId,
        cartId: cartId,
        cartDetails: [
          {'code': productCode, 'operator': 'del', 'quantity': 0},
        ],
      );

      return response['message'] == 'success';
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Update item quantity in cart
  static Future<bool> updateCartQuantity(
    String productCode,
    int quantity,
    int shopId,
    String cartId,
  ) async {
    try {
      final response = await updateCart(
        shopId: shopId,
        cartId: cartId,
        cartDetails: [
          {
            'code': productCode,
            'operator': quantity > 0 ? 'up' : 'down',
            'quantity': quantity.abs(),
          },
        ],
      );

      return response['message'] == 'success';
    } catch (e) {
      print('Error updating cart quantity: $e');
      return false;
    }
  }

  //Clear entire cart
  static Future<bool> clearCart(int shopId, String cartId) async {
    try {
      // First get current cart items
      final cartResponse = await getCart(shopId);

      if (cartResponse['message'] == 'success') {
        final cartDetails = cartResponse['response']['cart_details'] ?? [];

        //Create delete operations for all items
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
            cartDetails: clearOperations,
          );

          return response['message'] == 'success';
        }

        return true; // Cart is already empty
      }

      return false;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/model/category_model.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/preferences/shared_preferences_services.dart';

// class ApiService {
//   static const String baseUrl = "http://t-api.dotit-corp.com/api";
//   static const int timeoutSeconds = 30;
//   static String? authToken;

//   static Future<void> initialize() async {
//     authToken = await SharedPreferencesService.getAuthToken();
//   }

//   static Future<String?> _getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   static Future<Map<String, String>> _getHeaders() async {
//     try {
//       final token = await _getAuthToken();
//       final prefs = await SharedPreferences.getInstance();
//       final language = prefs.getString('language') ?? 'en';

//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Accept-Language': language,
//       };

//       if (token != null && token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//       }

//       return headers;
//     } catch (e) {
//       return {'Content-Type': 'application/json'};
//     }
//   }

//   // LOGIN
//   static Future<Map<String, dynamic>> login(
//     String username,
//     String password,
//   ) async {
//     try {
//       print('Login attempt for: $username');

//       // Create the request body
//       final requestBody = jsonEncode({
//         'username': username,
//         'password': password,
//       });

//       print('Login request body: $requestBody');

//       final response = await http
//           .post(
//             Uri.parse('$baseUrl/public/login'),
//             headers: {'Content-Type': 'application/json'},
//             body: requestBody,
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print('Login response status: ${response.statusCode}');
//       print('Login response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         if (responseData['token'] != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('auth_token', responseData['token']);
//           authToken = responseData['token'];

//           print('Login successful, token saved');
//           return {'success': true, 'token': responseData['token']};
//         } else {
//           print('Login failed: No token in response');
//           return {
//             'success': false,
//             'message':
//                 responseData['message'] ?? 'No authentication token received',
//           };
//         }
//       } else {
//         final responseData = jsonDecode(response.body);
//         print(
//           'Login failed with status ${response.statusCode}: ${responseData['message']}',
//         );

//         return {
//           'success': false,
//           'message': responseData['message'] ?? 'Invalid login credentials',
//         };
//       }
//     } catch (e) {
//       print('Login exception: $e');
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   // LOGOUT
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     authToken = null;
//   }

//   // DEBUG METHOD TO CHECK LOGIN PARAMETERS
//   static Future<void> debugLoginParameters() async {
//     try {
//       // Test with the exact same parameters as Postman
//       final testUsername =
//           "test@example.com"; // Replace with actual test username
//       final testPassword = "testpassword"; // Replace with actual test password

//       print("=== DEBUG LOGIN PARAMETERS ===");
//       print("API URL: $baseUrl/public/login");
//       print("Username: $testUsername");
//       print("Password: $testPassword");

//       final requestBody = jsonEncode({
//         'username': testUsername,
//         'password': testPassword,
//       });

//       print("Request Body: $requestBody");
//       print("Content-Type: application/json");
//       print("=== END DEBUG ===");
//     } catch (e) {
//       print("Debug error: $e");
//     }
//   }

//   //Product detail
//   static Future<Product?> getProductDetail({
//     required String code,
//     required String shopId,
//   }) async {
//     try {
//       final url = '$baseUrl/public/getProduct?code=$code&id-shop=$shopId';
//       print(" Request URL: $url");

//       final response = await http
//           .get(Uri.parse(url), headers: await _getHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" Raw API Response: ${response.body}");
//       final data = jsonDecode(response.body);
//       print(" DEBUG - Full response structure:");
//       _printJsonStructure(data, 0);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['response'] != null) {
//           if (data['response'] is List && data['response'].isNotEmpty) {
//             return Product.fromJson(data['response'][0]);
//           } else if (data['response']['product'] != null) {
//             return Product.fromJson(data['response']['product']);
//           }
//         }

//         print(" No valid product found in response");
//         return null;
//       } else {
//         print(" API Error: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print(" Exception in getProductDetail: $e");
//       return null;
//     }
//   }

//   static void _printJsonStructure(dynamic json, int indent) {
//     if (json is Map) {
//       json.forEach((key, value) {
//         print('${'  ' * indent}$key: ${value.runtimeType}');
//         if (value is Map || value is List) {
//           _printJsonStructure(value, indent + 1);
//         }
//       });
//     } else if (json is List) {
//       if (json.isNotEmpty) {
//         print('${'  ' * indent}List[0]: ${json[0].runtimeType}');
//         if (json[0] is Map || json[0] is List) {
//           _printJsonStructure(json[0], indent + 1);
//         }
//       }
//     }
//   }

//   // GET FAVORITE PRODUCTS
//   static Future<List<Product>> getFavoriteProducts() async {
//     try {
//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/user/favorites'),
//             headers: await _getHeaders(),
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response'] != null && data['response'] is List) {
//           return data['response'].map<Product>((productJson) {
//             return Product(
//               id: int.tryParse(productJson['id']?.toString() ?? '0') ?? 0,
//               name: productJson['name'] ?? 'No Name',
//               brand: productJson['brand'] ?? 'No Brand',
//               price: productJson['price']?.toString() ?? '0',
//               image: productJson['image'] ?? '',
//               description: productJson['description'] ?? 'No Description',

//               oldPrice: productJson['oldPrice']?.toString(),
//               discount: productJson['discount']?.toString(),
//               isFavorite: true,
//               reference: productJson['reference'] ?? 'N/A',
//             );
//           }).toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching favorite products: $e");
//       return [];
//     }
//   }

//   // TOGGLE FAVORITE STATUS
//   static Future<bool> toggleFavorite(int productId, bool isFavorite) async {
//     try {
//       final endpoint =
//           isFavorite
//               ? '$baseUrl/user/favorites/add'
//               : '$baseUrl/user/favorites/remove';

//       final response = await http
//           .post(
//             Uri.parse(endpoint),
//             headers: await _getHeaders(),
//             body: jsonEncode({'product_id': productId}),
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       return response.statusCode == 200;
//     } catch (e) {
//       print("Error toggling favorite: $e");
//       return false;
//     }
//   }

//   // FORGOT PASSWORD
//   static Future<Map<String, dynamic>> forgotPassword(String email) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('$baseUrl/public/forgot-password'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({'email': email}),
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       final responseData = jsonDecode(response.body);
//       return {
//         'success': response.statusCode == 200,
//         'message': responseData['message'] ?? 'Password reset email sent',
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Failed to send password reset email',
//       };
//     }
//   }

//   // GET CATEGORY PRODUCTS
//   static Future<List<Product>> getCategoryProducts({
//     required String categoryCode,
//     required String shopId,
//   }) async {
//     try {
//       final url =
//           '$baseUrl/public/getCategoryProducts?code=$categoryCode&id-shop=$shopId';
//       print(" API URL: $url");

//       final response = await http
//           .get(Uri.parse(url), headers: await _getHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" Status Code: ${response.statusCode}");
//       print(" Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print(" Parsed Data: $data");

//         if (data['response'] != null && data['response']['products'] != null) {
//           final products = data['response']['products'];

//           print(" Products found: ${products.length}");

//           // Debug: Check dates of first few products
//           for (
//             var i = 0;
//             i < (products.length > 3 ? 3 : products.length);
//             i++
//           ) {
//             final product = products[i];
//             print(
//               "Product ${i + 1}: ${product['name']} - Added: ${product['date_add']}",
//             );
//           }

//           return (products as List).map<Product>((productJson) {
//             return Product(
//               id:
//                   int.tryParse(productJson['id_product']?.toString() ?? '0') ??
//                   0,
//               reference: productJson['reference'] ?? 'N/A',

//               name: productJson['name'] ?? 'No Name',
//               brand: productJson['manufacturer_name'] ?? 'No Brand',
//               price: productJson['price']?.toString() ?? '0',
//               image: productJson['image'] ?? '',
//               description: productJson['description_short'] ?? 'No Description',
//               oldPrice: productJson['price_without_reduction']?.toString(),
//               discount:
//                   productJson['reduction'] != null &&
//                           productJson['reduction'] > 0
//                       ? '${(productJson['reduction'] * 100).toStringAsFixed(0)}% OFF'
//                       : null,
//             );
//           }).toList();
//         }
//         print(" No products found in response structure");
//         return [];
//       } else {
//         print(" API Error: ${response.statusCode}");
//         return [];
//       }
//     } catch (e) {
//       print(" Exception in getCategoryProducts: $e");
//       return [];
//     }
//   }

//   static DateTime? parseDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return null;
//     try {
//       // Try parsing with space replacement
//       return DateTime.parse(dateString.replaceFirst(" ", "T"));
//     } catch (_) {
//       try {
//         // Fallback to simple parsing without T
//         return DateTime.parse(dateString);
//       } catch (e) {
//         print(" Error parsing date: $dateString, error: $e");
//         return null;
//       }
//     }
//   }

//   // RESET PASSWORD
//   static Future<Map<String, dynamic>> resetPassword({
//     required String token,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//   }) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('$baseUrl/public/reset-password'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'token': token,
//               'email': email,
//               'password': password,
//               'password_confirmation': passwordConfirmation,
//             }),
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       final responseData = jsonDecode(response.body);
//       return {
//         'success': response.statusCode == 200,
//         'message': responseData['message'] ?? 'Password reset successfully',
//       };
//     } catch (e) {
//       return {'success': false, 'message': 'Failed to reset password'};
//     }
//   }

//   // TEST API CONNECTION
//   static Future<void> testApiConnection() async {
//     try {
//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/public/getCategoryProducts?code=10&id-shop=4'),
//           )
//           .timeout(Duration(seconds: 10));

//       print(" API Connection Test:");
//       print(" Status Code: ${response.statusCode}");
//       print(" Response: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print(" API Connection Successful!");
//         print(" Response Structure: ${data.keys.toList()}");
//       } else {
//         print(" API Connection Failed!");
//       }
//     } catch (e) {
//       print(" API Connection Error: $e");
//     }
//   }

//   static String formatImagePath(dynamic imageId) {
//     if (imageId == null || imageId.toString().isEmpty) return '';

//     final String id = imageId.toString();

//     // Handle the format "1875-282588" by taking the part after dash
//     String imageIdPart = id;
//     if (id.contains('-')) {
//       imageIdPart = id.split('-')[1];
//     }

//     // For 282588, create path: 2/8/2/5/8/8/282588
//     if (imageIdPart.length >= 6) {
//       final digits = imageIdPart.split('');
//       return '${digits[0]}/${digits[1]}/${digits[2]}/${digits[3]}/${digits[4]}/${digits[5]}/$imageIdPart';
//     }

//     return imageIdPart;
//   }

//   // Update the getProductsFromCategory method to handle the actual API structure
//   static Future<List<Product>> getProductsFromCategory(
//     String categoryName,
//   ) async {
//     try {
//       print("Getting products for category: $categoryName");

//       // First get the category code
//       final categoryCode = await getCategoryCodeByName(categoryName);

//       if (categoryCode.isEmpty) {
//         print(" Could not find category code for $categoryName");
//         return [];
//       }

//       print(" Using category code: $categoryCode");

//       //Extract products from the category structure
//       final categoryData = await getCategoryStructure();

//       if (categoryData['response'] != null &&
//           categoryData['response'] is List) {
//         final rootCategories = List<Map<String, dynamic>>.from(
//           categoryData['response'],
//         );

//         // Recursively search for the category and extract products
//         final products = _extractProductsFromCategoryRecursive(
//           rootCategories,
//           categoryCode,
//         );

//         print(" Extracted ${products.length} products from category structure");
//         return products;
//       }

//       return [];
//     } catch (e) {
//       print("Error getting products for category $categoryName: $e");
//       return [];
//     }
//   }

//   // Helper method to extract products from category structure recursively
//   static List<Product> _extractProductsFromCategoryRecursive(
//     List<Map<String, dynamic>> categories,
//     String targetCode,
//   ) {
//     final List<Product> products = [];

//     for (var category in categories) {
//       // Check if this is the target category
//       if (category['code']?.toString() == targetCode) {
//         print(" Found target category: ${category['name']}");

//         // If this category has products directly, extract them
//         if (category['products'] != null && category['products'] is List) {
//           final categoryProducts = List<Map<String, dynamic>>.from(
//             category['products'],
//           );
//           for (var product in categoryProducts) {
//             products.add(Product.fromJson(product));
//           }
//         }

//         // Also check child categories for products
//         if (category['childs'] != null && category['childs'] is List) {
//           final childCategories = List<Map<String, dynamic>>.from(
//             category['childs'],
//           );
//           for (var child in childCategories) {
//             if (child['products'] != null && child['products'] is List) {
//               final childProducts = List<Map<String, dynamic>>.from(
//                 child['products'],
//               );
//               for (var product in childProducts) {
//                 products.add(Product.fromJson(product));
//               }
//             }
//           }
//         }

//         break;
//       }

//       // Recursively search child categories
//       if (category['childs'] != null && category['childs'] is List) {
//         final childCategories = List<Map<String, dynamic>>.from(
//           category['childs'],
//         );
//         products.addAll(
//           _extractProductsFromCategoryRecursive(childCategories, targetCode),
//         );
//       }
//     }

//     return products;
//   }

//   // Helper method to extract products from category structure
//   static List<Product> _extractProductsFromCategory(
//     Map<String, dynamic> category,
//   ) {
//     final List<Product> products = [];

//     // Recursively extract products from all subcategories
//     void extractFromSubcategories(Map<String, dynamic> currentCategory) {
//       // If this category has products directly (check based on your API structure)
//       if (currentCategory['products'] != null &&
//           currentCategory['products'] is List) {
//         final categoryProducts = List<Map<String, dynamic>>.from(
//           currentCategory['products'],
//         );
//         for (var product in categoryProducts) {
//           products.add(Product.fromJson(product));
//         }
//       }

//       // Recursively check child categories
//       if (currentCategory['childs'] != null &&
//           currentCategory['childs'] is List) {
//         final childCategories = List<Map<String, dynamic>>.from(
//           currentCategory['childs'],
//         );
//         for (var child in childCategories) {
//           extractFromSubcategories(child);
//         }
//       }
//     }

//     extractFromSubcategories(category);
//     print(" Extracted ${products.length} products from ${category['name']}");
//     return products;
//   }

//   static Future<List<Product>> getProductsUsingCategoryCode(
//     String categoryName,
//   ) async {
//     try {
//       final categoryCode = await getCategoryCodeByName(categoryName);
//       if (categoryCode.isEmpty) {
//         print(" Could not find category code for $categoryName");
//         return [];
//       }

//       print(" Using category code: $categoryCode for $categoryName");
//       return [];
//     } catch (e) {
//       print("Error getting products using category code: $e");
//       return [];
//     }
//   }

//   //Get Category Structure
//   static Future<Map<String, dynamic>> getCategoryStructure() async {
//     try {
//       final url = '$baseUrl/public/getCategories';
//       print(" Fetching category structure from: $url");

//       final response = await http
//           .get(Uri.parse(url), headers: await _getHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data;
//       } else {
//         print(" Failed to fetch category structure: ${response.statusCode}");
//         return {};
//       }
//     } catch (e) {
//       print(" Exception in getCategoryStructure: $e");
//       return {};
//     }
//   }
//   // Similar product part

//   static Future<String?> getProductCategoryCode(int productId) async {
//     try {
//       final url = '$baseUrl/public/getProductCategory?product_id=$productId';
//       final response = await http
//           .get(Uri.parse(url), headers: await _getHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['category_code']?.toString();
//       }

//       final productDetail = await getProductDetail(
//         code: productId.toString(),
//         shopId: '4',
//       );

//       return productDetail?.categoryCode;
//     } catch (e) {
//       print("Error fetching product category: $e");
//       return null;
//     }
//   }

//   static Future<List<Category>> getAllCategories() async {
//     try {
//       final url = '$baseUrl/public/getCategories';
//       final response = await http
//           .get(Uri.parse(url), headers: await _getHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response'] != null && data['response'] is List) {
//           return (data['response'] as List)
//               .map<Category>((categoryJson) => Category.fromJson(categoryJson))
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching categories: $e");
//       return [];
//     }
//   }

//   //debug api response
//   static Future<void> debugApiResponse() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getCategories'),
//         headers: await _getHeaders(),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("=== API RESPONSE DEBUG ===");
//         print("Full response: $data");

//         if (data['response'] != null && data['response'] is List) {
//           final categories = List<Map<String, dynamic>>.from(data['response']);
//           print("Root categories count: ${categories.length}");

//           for (var i = 0; i < categories.length; i++) {
//             final category = categories[i];
//             print(
//               "${i + 1}. ${category['name']} (ID: ${category['id']}, Code: ${category['code']})",
//             );

//             if (category['childs'] != null && category['childs'] is List) {
//               final childs = List<Map<String, dynamic>>.from(
//                 category['childs'],
//               );
//               print("   Childs: ${childs.length}");

//               for (var j = 0; j < childs.length; j++) {
//                 final child = childs[j];
//                 print(
//                   "   └─ ${j + 1}. ${child['name']} (ID: ${child['id']}, Code: ${child['code']})",
//                 );
//               }
//             }
//           }
//         }
//         print("=== END DEBUG ===");
//       } else {
//         print(" API request failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print(" Debug API error: $e");
//     }
//   }

//   // Get Category Code By Name method
//   static Future<String> getCategoryCodeByName(String categoryName) async {
//     try {
//       final categoryData = await getCategoryStructure();

//       print(" Parsing category structure for: $categoryName");
//       print("Full response: $categoryData");

//       if (categoryData['response'] != null &&
//           categoryData['response'] is List) {
//         final rootCategories = List<Map<String, dynamic>>.from(
//           categoryData['response'],
//         );

//         print(" Root categories found: ${rootCategories.length}");

//         // Print all root categories for debugging
//         for (var i = 0; i < rootCategories.length; i++) {
//           final category = rootCategories[i];
//           print("   ${i + 1}. ${category['name']} (ID: ${category['id']})");

//           // Check if this is the "Accueil" category
//           if (category['name'] == 'Accueil' || category['id'] == '2') {
//             print(" Found Accueil category!");

//             if (category['childs'] != null && category['childs'] is List) {
//               final childCategories = List<Map<String, dynamic>>.from(
//                 category['childs'],
//               );

//               print(
//                 "   Child categories of Accueil: ${childCategories.length}",
//               );

//               // Print all child categories
//               for (var j = 0; j < childCategories.length; j++) {
//                 final child = childCategories[j];
//                 print(
//                   "   └─ ${j + 1}. ${child['name']} (ID: ${child['id']}, Code: ${child['code']})",
//                 );

//                 // Check if this is the target category
//                 if (child['name']?.toLowerCase() ==
//                     categoryName.toLowerCase()) {
//                   print(
//                     " Found $categoryName category! Code: ${child['code']}",
//                   );
//                   return child['code']?.toString() ?? '';
//                 }
//               }

//               // If exact name match not found, try partial match
//               for (var j = 0; j < childCategories.length; j++) {
//                 final child = childCategories[j];
//                 if (child['name']?.toLowerCase().contains(
//                       categoryName.toLowerCase(),
//                     ) ==
//                     true) {
//                   print(
//                     " Found similar category: ${child['name']} with code: ${child['code']}",
//                   );
//                   return child['code']?.toString() ?? '';
//                 }
//               }
//             } else {
//               print("Accueil category has no childs");
//             }
//           }
//         }

//         // Alternative approach: Search through all categories recursively
//         print(" Searching through all categories recursively...");
//         final foundCode = _findCategoryCodeRecursive(
//           rootCategories,
//           categoryName,
//         );
//         if (foundCode.isNotEmpty) {
//           return foundCode;
//         }
//       } else {
//         print("No response data found in API response");
//       }

//       return '';
//     } catch (e) {
//       print("Error getting category code for $categoryName: $e");
//       return '';
//     }
//   }

//   // Helper method to search for category code recursively
//   static String _findCategoryCodeRecursive(
//     List<Map<String, dynamic>> categories,
//     String targetName,
//   ) {
//     for (var category in categories) {
//       // Check if current category matches
//       if (category['name']?.toLowerCase() == targetName.toLowerCase()) {
//         print(" Found $targetName recursively! Code: ${category['code']}");
//         return category['code']?.toString() ?? '';
//       }

//       // Check if current category contains target name
//       if (category['name']?.toLowerCase().contains(targetName.toLowerCase()) ==
//           true) {
//         print(
//           " Found similar category recursively: ${category['name']} with code: ${category['code']}",
//         );
//         return category['code']?.toString() ?? '';
//       }

//       // Recursively search child categories
//       if (category['childs'] != null && category['childs'] is List) {
//         final childCategories = List<Map<String, dynamic>>.from(
//           category['childs'],
//         );
//         final foundCode = _findCategoryCodeRecursive(
//           childCategories,
//           targetName,
//         );
//         if (foundCode.isNotEmpty) {
//           return foundCode;
//         }
//       }
//     }

//     return '';
//   }

//   // method with hardcoded category codes
//   static Map<String, String> getHardcodedCategoryCodes() {
//     return {
//       'HighTech': '10',
//       'Smart Home': '11',
//       'Smart Office': '12',
//       'Lifestyle': '13',
//       'hightech': '10',
//       'high tech': '10',
//       'smart home': '11',
//       'smart-home': '11',
//       'smart office': '12',
//       'smart-office': '12',
//       'lifestyle': '13',
//     };
//   }

//   static String getHardcodedCategoryCode(String categoryName) {
//     final categoryMap = getHardcodedCategoryCodes();
//     final lowerName = categoryName.toLowerCase();

//     // Try exact match first
//     if (categoryMap[lowerName] != null) {
//       return categoryMap[lowerName]!;
//     }

//     // Try partial match
//     for (var key in categoryMap.keys) {
//       if (lowerName.contains(key) || key.contains(lowerName)) {
//         return categoryMap[key]!;
//       }
//     }

//     return '';
//   }

//   //getAuthHeadersForDebug
//   static Future<Map<String, String>> getAuthHeadersForDebug() async {
//     return await _getHeaders();
//   }

//   //  debug method
//   static Future<void> debugCategoryStructure() async {
//     try {
//       final categoryData = await getCategoryStructure();
//       print("=== DEBUG CATEGORY STRUCTURE ===");

//       if (categoryData['response'] != null &&
//           categoryData['response'] is List) {
//         final rootCategories = List<Map<String, dynamic>>.from(
//           categoryData['response'],
//         );

//         for (var rootCategory in rootCategories) {
//           print(
//             "Root category: ${rootCategory['name']} (ID: ${rootCategory['id']})",
//           );

//           if (rootCategory['childs'] != null) {
//             final childCategories = List<Map<String, dynamic>>.from(
//               rootCategory['childs'],
//             );

//             for (var childCategory in childCategories) {
//               print(
//                 "  └─ Child: ${childCategory['name']} (ID: ${childCategory['id']}, Code: ${childCategory['code']})",
//               );

//               if (childCategory['childs'] != null) {
//                 final grandChildCategories = List<Map<String, dynamic>>.from(
//                   childCategory['childs'],
//                 );

//                 for (var grandChild in grandChildCategories) {
//                   print(
//                     "      └─ Grandchild: ${grandChild['name']} (ID: ${grandChild['id']}, Code: ${grandChild['code']})",
//                   );
//                 }
//               }
//             }
//           }
//         }
//       }
//       print("=== END DEBUG ===");
//     } catch (e) {
//       print("Error debugging category structure: $e");
//     }
//   }

//   //Categories
//   static Future<List<Product>> getProductsByCategoryName(
//     String categoryName,
//   ) async {
//     try {
//       String categoryCode = await getCategoryCodeByName(categoryName);

//       if (categoryCode.isEmpty) {
//         categoryCode = getHardcodedCategoryCode(categoryName);
//       }

//       if (categoryCode.isEmpty) {
//         print("Could not find category code for $categoryName");
//         return [];
//       }

//       print(" Fetching products for $categoryName with code: $categoryCode");

//       return await getCategoryProducts(categoryCode: categoryCode, shopId: '4');
//     } catch (e) {
//       print("Error fetching products for $categoryName: $e");
//       return [];
//     }
//   }

//   // CART METHODS
//   static Future<Map<String, dynamic>> getCart(int shopId) async {
//     try {
//       final headers = await _getHeaders();

//       final response = await http
//           .get(Uri.parse('$baseUrl/getCart?id-shop=$shopId'), headers: headers)
//           .timeout(Duration(seconds: 10));

//       print('Cart API Response Status: ${response.statusCode}');
//       print('Cart API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return responseData;
//       } else if (response.statusCode == 401) {
//         throw Exception('Unauthorized - Please login again');
//       } else {
//         throw Exception('Failed to load cart. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching cart: $e');
//       throw Exception('Error fetching cart: $e');
//     }
//   }

//   static Future<Map<String, dynamic>> updateCart({
//     required int shopId,
//     required String cartId,
//     required List<Map<String, dynamic>> cartDetails,
//   }) async {
//     try {
//       final headers = await _getHeaders();

//       final response = await http
//           .post(
//             Uri.parse('$baseUrl/public/updateCart'),
//             headers: headers,
//             body: json.encode({
//               'cart_details': cartDetails,
//               'cart_summary': {'idShop': shopId, 'id': cartId},
//             }),
//           )
//           .timeout(Duration(seconds: 10));

//       print('Update Cart API Response Status: ${response.statusCode}');
//       print('Update Cart API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return responseData;
//       } else if (response.statusCode == 401) {
//         throw Exception('Unauthorized - Please login again');
//       } else {
//         throw Exception(
//           'Failed to update cart. Status: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       print('Error updating cart: $e');
//       throw Exception('Error updating cart: $e');
//     }
//   }

//   // Improved addToCart method
//   static Future<bool> addToCart(
//     String productCode,
//     int quantity, {
//     String? color,
//     int shopId = 4,
//   }) async {
//     try {
//       print(
//         'Adding to cart - Product: $productCode, Qty: $quantity, Color: $color',
//       );

//       // First try to get the current cart to get the cartId
//       try {
//         final cartResponse = await getCart(shopId);

//         if (cartResponse['message'] == 'success') {
//           final cartSummary = cartResponse['response']['cart_summary'];
//           final String cartId = cartSummary['cartId'].toString();

//           final response = await updateCart(
//             shopId: shopId,
//             cartId: cartId,
//             cartDetails: [
//               {
//                 'code': productCode,
//                 'operator': 'add',
//                 'quantity': quantity,
//                 if (color != null) 'color': color,
//               },
//             ],
//           );

//           final success = response['message'] == 'success';
//           print('Add to cart success: $success');
//           return success;
//         }
//       } catch (e) {
//         print('Error getting cart ID, trying without cart ID: $e');

//         // Fallback: try without cart ID (API might create one automatically)
//         final response = await updateCart(
//           shopId: shopId,
//           cartId: '0', // Use 0 or empty string as fallback
//           cartDetails: [
//             {
//               'code': productCode,
//               'operator': 'add',
//               'quantity': quantity,
//               if (color != null) 'color': color,
//             },
//           ],
//         );

//         final success = response['message'] == 'success';
//         print('Add to cart fallback success: $success');
//         return success;
//       }

//       return false;
//     } catch (e) {
//       print('Error in addToCart: $e');
//       return false;
//     }
//   }

//   // Remove item from cart
//   static Future<bool> removeFromCart(
//     String productCode,
//     int shopId,
//     String cartId,
//   ) async {
//     try {
//       final response = await updateCart(
//         shopId: shopId,
//         cartId: cartId,
//         cartDetails: [
//           {'code': productCode, 'operator': 'del', 'quantity': 0},
//         ],
//       );

//       return response['message'] == 'success';
//     } catch (e) {
//       print('Error removing from cart: $e');
//       return false;
//     }
//   }

//   // Update item quantity in cart
//   static Future<bool> updateCartQuantity(
//     String productCode,
//     int quantity,
//     int shopId,
//     String cartId,
//   ) async {
//     try {
//       final response = await updateCart(
//         shopId: shopId,
//         cartId: cartId,
//         cartDetails: [
//           {
//             'code': productCode,
//             'operator': quantity > 0 ? 'up' : 'down',
//             'quantity': quantity.abs(),
//           },
//         ],
//       );

//       return response['message'] == 'success';
//     } catch (e) {
//       print('Error updating cart quantity: $e');
//       return false;
//     }
//   }

//   // Clear entire cart
//   static Future<bool> clearCart(int shopId, String cartId) async {
//     try {
//       // First get current cart items
//       final cartResponse = await getCart(shopId);

//       if (cartResponse['message'] == 'success') {
//         final cartDetails = cartResponse['response']['cart_details'] ?? [];

//         // Create delete operations for all items
//         final List<Map<String, dynamic>> clearOperations = [];
//         for (var item in cartDetails) {
//           clearOperations.add({
//             'code': item['code'],
//             'operator': 'del',
//             'quantity': 0,
//           });
//         }

//         if (clearOperations.isNotEmpty) {
//           final response = await updateCart(
//             shopId: shopId,
//             cartId: cartId,
//             cartDetails: clearOperations,
//           );

//           return response['message'] == 'success';
//         }

//         return true; // Cart is already empty
//       }

//       return false;
//     } catch (e) {
//       print('Error clearing cart: $e');
//       return false;
//     }
//   }
// }
