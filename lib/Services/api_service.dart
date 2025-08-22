import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/model/product_model.dart';

class ApiService {
  static const String baseUrl = "http://t-api.dotit-corp.com/api";
  static const int timeoutSeconds = 30;

  // Helper method to get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Helper method for authorized requests
  static Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final token = await _getAuthToken();
      if (token != null && token.isNotEmpty) {
        return {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
      } else {
        print("⚠️ No auth token found, making public request");
        return {'Content-Type': 'application/json'};
      }
    } catch (e) {
      print("❌ Error getting auth headers: $e");
      return {'Content-Type': 'application/json'};
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/public/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseData['token']);
        return {'success': true, 'token': responseData['token']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid login credentials',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // GET PRODUCT DETAILS BY ID
  static Future<Product?> getProductDetails(int productId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getProduct?id=$productId'),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response'] != null && data['response']['product'] != null) {
          return Product.fromJson(data['response']['product']);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching product details: $e");
      return null;
    }
  }

  // GET PRODUCT DETAILS BY CODE AND SHOP ID
  static Future<Product?> getProductDetail({
    required String code,
    required String shopId,
  }) async {
    try {
      final url = '$baseUrl/public/getProduct?code=$code&shopId=$shopId';
      print("🌐 Request URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: timeoutSeconds));

      // Log the raw response
      print("📥 Raw API Response: ${response.body}");
      print("🛡️ Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Parsed Response Data: $data");

        if (data['response'] != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final productData = data['response'][0];
          print("🛍️ Product Data: $productData");

          return Product(
            id: int.tryParse(productData['id']?.toString() ?? '0') ?? 0,
            name: productData['name'] ?? '',
            brand: productData['manufacturer_name'] ?? '',
            price: productData['price']?.toString() ?? '0',
            image: productData['image'] ?? '',
            description: productData['description_short'] ?? '',
          );
        } else {
          print("⚠️ Empty or invalid response structure");
        }
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
      return null;
    } catch (e) {
      print("‼️ Exception in getProductDetail: $e");
      return null;
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
      print("🌐 API URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print("📊 Status Code: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Parsed Data: $data");

        if (data['response'] != null && data['response']['products'] != null) {
          final products = data['response']['products'];

          print("🛍️ Products found: ${products.length}");

          // Debug: Check dates of first few products
          for (
            var i = 0;
            i < (products.length > 3 ? 3 : products.length);
            i++
          ) {
            final product = products[i];
            print(
              "📅 Product ${i + 1}: ${product['name']} - Added: ${product['date_add']}",
            );
          }

          return (products as List).map<Product>((productJson) {
            return Product(
              id:
                  int.tryParse(productJson['id_product']?.toString() ?? '0') ??
                  0,
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
        print("⚠️ No products found in response structure");
        return [];
      } else {
        print("❌ API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("‼️ Exception in getCategoryProducts: $e");
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
        print("❌ Error parsing date: $dateString, error: $e");
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

      print("🔗 API Connection Test:");
      print("📊 Status Code: ${response.statusCode}");
      print("📦 Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ API Connection Successful!");
        print("📋 Response Structure: ${data.keys.toList()}");
      } else {
        print("❌ API Connection Failed!");
      }
    } catch (e) {
      print("‼️ API Connection Error: $e");
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

  // //Get Categories
  // static Future<List<Map<String, dynamic>>> getCategories() async {
  //   try {
  //     final url = '$baseUrl/public/getCategories';
  //     print("🌐 Fetching categories from: $url");

  //     final response = await http
  //         .get(Uri.parse(url), headers: await _getAuthHeaders())
  //         .timeout(Duration(seconds: timeoutSeconds));

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print("✅ Categories response received");

  //       if (data['response'] != null && data['response'] is List) {
  //         // Find the "Accueil" category which contains our target categories
  //         final rootCategories = List<Map<String, dynamic>>.from(
  //           data['response'],
  //         );

  //         // Find "Accueil" category (ID: 2)
  //         final accueilCategory = rootCategories.firstWhere(
  //           (category) => category['id'] == '2',
  //           orElse: () => {},
  //         );

  //         if (accueilCategory.isNotEmpty && accueilCategory['childs'] != null) {
  //           // Return the child categories of "Accueil" (HighTech, Smart Home, Smart Office, Lifestyle)
  //           return List<Map<String, dynamic>>.from(accueilCategory['childs']);
  //         }
  //       }
  //       return [];
  //     } else {
  //       print("❌ Failed to fetch categories: ${response.statusCode}");
  //       return [];
  //     }
  //   } catch (e) {
  //     print("‼️ Exception in getCategories: $e");
  //     return [];
  //   }
  // }

  // //category code
  // static Future<String> getCategoryCode(String categoryName) async {
  //   try {
  //     final categories = await getCategories();

  //     // Map category names to their expected API values
  //     final categoryMap = {
  //       'HighTech': 'HighTech',
  //       'Smart Home': 'Smart Home',
  //       'Smart Office': 'Smart Office',
  //       'Lifestyle': 'Lifestyle',
  //     };

  //     // Find the exact category name match
  //     final targetName = categoryMap[categoryName];
  //     if (targetName == null) return '';

  //     final category = categories.firstWhere(
  //       (cat) => cat['name'] == targetName,
  //       orElse: () => {},
  //     );

  //     return category['code']?.toString() ?? '';
  //   } catch (e) {
  //     print("Error getting category code for $categoryName: $e");
  //     return '';
  //   }
  // }

  // // Add a new method to get category by name
  // static Future<String> getCategoryCodeByName(String categoryName) async {
  //   try {
  //     final categories = await getCategories();

  //     // Find the category by name
  //     final category = categories.firstWhere(
  //       (cat) => cat['name']?.toLowerCase() == categoryName.toLowerCase(),
  //       orElse: () => {},
  //     );

  //     if (category.isNotEmpty) {
  //       return category['code'] ?? '';
  //     }

  //     return '';
  //   } catch (e) {
  //     print("Error getting category code: $e");
  //     return '';
  //   }
  // }

  // Update the getProductsFromCategory method to handle the actual API structure
  static Future<List<Product>> getProductsFromCategory(
    String categoryName,
  ) async {
    try {
      print("🔄 Getting products for category: $categoryName");

      // First get the category code
      final categoryCode = await getCategoryCodeByName(categoryName);

      if (categoryCode.isEmpty) {
        print("❌ Could not find category code for $categoryName");
        return [];
      }

      print("✅ Using category code: $categoryCode");

      // Based on the API structure from Postman, we need to understand how to get products
      // Since getCategories returns the category structure, we might need to:
      // 1. Extract products from the category structure itself, or
      // 2. Use the category code with a different API endpoint

      // For now, let's try to extract products from the category structure
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

        print(
          "📦 Extracted ${products.length} products from category structure",
        );
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
        print("🎯 Found target category: ${category['name']}");

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
    print("📦 Extracted ${products.length} products from ${category['name']}");
    return products;
  }

  // Alternative: If the API doesn't have products in the category structure,
  // we might need to use the category code with a different approach
  static Future<List<Product>> getProductsUsingCategoryCode(
    String categoryName,
  ) async {
    try {
      // First get the category code
      final categoryCode = await getCategoryCodeByName(categoryName);

      if (categoryCode.isEmpty) {
        print("❌ Could not find category code for $categoryName");
        return [];
      }

      print("✅ Using category code: $categoryCode for $categoryName");

      // Based on your API structure, we might need to use a different endpoint
      // or parse the category structure differently
      // For now, let's return an empty list as we need to understand the API better
      return [];
    } catch (e) {
      print("Error getting products using category code: $e");
      return [];
    }
  }

  // In ApiService.dart - Add these methods
  static Future<Map<String, dynamic>> getCategoryStructure() async {
    try {
      final url = '$baseUrl/public/getCategories';
      print("🌐 Fetching category structure from: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("❌ Failed to fetch category structure: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("‼️ Exception in getCategoryStructure: $e");
      return {};
    }
  }
  // In ApiService.dart - Add a method to debug the API response
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
          print("${i + 1}. ${category['name']} (ID: ${category['id']}, Code: ${category['code']})");
          
          if (category['childs'] != null && category['childs'] is List) {
            final childs = List<Map<String, dynamic>>.from(category['childs']);
            print("   Childs: ${childs.length}");
            
            for (var j = 0; j < childs.length; j++) {
              final child = childs[j];
              print("   └─ ${j + 1}. ${child['name']} (ID: ${child['id']}, Code: ${child['code']})");
            }
          }
        }
      }
      print("=== END DEBUG ===");
    } else {
      print("❌ API request failed: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Debug API error: $e");
  }
}



  // In ApiService.dart - Update the getCategoryCodeByName method
  static Future<String> getCategoryCodeByName(String categoryName) async {
    try {
      final categoryData = await getCategoryStructure();

      print("🔍 Parsing category structure for: $categoryName");
      print("📦 Full response: $categoryData");

      if (categoryData['response'] != null &&
          categoryData['response'] is List) {
        final rootCategories = List<Map<String, dynamic>>.from(
          categoryData['response'],
        );

        print("🌳 Root categories found: ${rootCategories.length}");

        // Print all root categories for debugging
        for (var i = 0; i < rootCategories.length; i++) {
          final category = rootCategories[i];
          print("   ${i + 1}. ${category['name']} (ID: ${category['id']})");

          // Check if this is the "Accueil" category
          if (category['name'] == 'Accueil' || category['id'] == '2') {
            print("✅ Found Accueil category!");

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
                    "🎯 Found $categoryName category! Code: ${child['code']}",
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
                    "🎯 Found similar category: ${child['name']} with code: ${child['code']}",
                  );
                  return child['code']?.toString() ?? '';
                }
              }
            } else {
              print("❌ Accueil category has no childs");
            }
          }
        }

        // Alternative approach: Search through all categories recursively
        print("🔍 Searching through all categories recursively...");
        final foundCode = _findCategoryCodeRecursive(
          rootCategories,
          categoryName,
        );
        if (foundCode.isNotEmpty) {
          return foundCode;
        }
      } else {
        print("❌ No response data found in API response");
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
        print("🎯 Found $targetName recursively! Code: ${category['code']}");
        return category['code']?.toString() ?? '';
      }

      // Check if current category contains target name
      if (category['name']?.toLowerCase().contains(targetName.toLowerCase()) ==
          true) {
        print(
          "🎯 Found similar category recursively: ${category['name']} with code: ${category['code']}",
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

  // In ApiService.dart - Add a method with hardcoded category codes
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
      'smart home': '11',
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

  // In ApiService.dart - Add a debug method
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
}
