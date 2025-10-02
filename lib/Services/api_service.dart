import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/model/carrier_model.dart';
import 'package:tawasul_application/model/cart_model.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/model/shop_model.dart';
import 'package:tawasul_application/model/store_details_model.dart';
import 'package:tawasul_application/model/category_model.dart';

class ApiService {
  static const String baseUrl = "https://tawasul-dev.app-staging.fr";
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

  /*                           LOGIN                                             */
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      print(" STARTING LOGIN PROCESS");

      final Map<String, String> requestBody = {
        'email': email.trim(),
        'password': password.trim(),
      };

      print("Making API call to: $baseUrl/public/login");
      print("Request body: $requestBody");

      final response = await http
          .post(
            Uri.parse('$baseUrl/public/login'),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json',
            },
            body: requestBody,
          )
          .timeout(Duration(seconds: timeoutSeconds));

      developer.log(response.body);
      print("Response status code: ${response.statusCode}");

      if (response.body.isEmpty) {
        print("EMPTY RESPONSE FROM SERVER");
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        print("LOGIN SUCCESSFUL!");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseData['token']);
        return {'success': true, 'token': responseData['token']};
      } else {
        print("LOGIN FAILED: ${responseData['message']}");
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid login credentials',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      print("Error type: ${e.runtimeType}");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           VERIFY PASSWORD                                            */
  static Future<Map<String, dynamic>> verifyPassword(String email) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/public/verifypassword'),
      );
      request.fields['email'] = email;

      print('Sending request to: $baseUrl/verifypassword');
      print('With email: $email');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseData');

      // Check if response is JSON or HTML
      if (responseData.trim().startsWith('{') ||
          responseData.trim().startsWith('[')) {
        // It's JSON
        var jsonResponse = json.decode(responseData);
        return jsonResponse;
      } else {
        // It's HTML or other content
        return {
          'success': false,
          'message':
              'Server returned HTML error. Please check the API endpoint.',
          'statusCode': response.statusCode,
          'error':
              'HTML Response: ${responseData.length > 100 ? responseData.substring(0, 100) + '...' : responseData}',
        };
      }
    } catch (e) {
      print('Error in verifyPassword: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /*                                           RESET PASSWORD                                                   */
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String code,
    required String confirmPassword,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/public/resetpassword'),
      );
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['code'] = code;
      request.fields['confirm password'] = confirmPassword;

      print('Sending request to: $baseUrl/public/resetpassword');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseData');

      // Check if response is JSON or HTML
      if (responseData.trim().startsWith('{') ||
          responseData.trim().startsWith('[')) {
        // It's JSON
        var jsonResponse = json.decode(responseData);
        return jsonResponse;
      } else {
        return {
          'success': false,
          'message':
              'Server returned HTML error. Please check the API endpoint.',
          'statusCode': response.statusCode,
          'error': 'HTML Response',
        };
      }
    } catch (e) {
      print('Error in resetPassword: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /*                           GET ALL CATEGORIES (UPDATED)                                          */
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/public/categories'))
          .timeout(Duration(seconds: timeoutSeconds));

      print("Categories API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> categoriesJson = data['categories'];
          print("Found ${categoriesJson.length} root categories");

          // Parse each category
          final List<Category> categories = [];
          for (var categoryJson in categoriesJson) {
            if (categoryJson is Map<String, dynamic>) {
              try {
                final category = Category.fromJson(categoryJson);
                categories.add(category);
              } catch (e) {
                print("Error parsing category: $e");
                print("Problematic category JSON: $categoryJson");
              }
            }
          }

          // Debug: Print category tree
          print("=== CATEGORY TREE ===");
          for (var category in categories) {
            category.printTree();
          }
          print("=====================");

          return categories;
        } else {
          print("API returned success: false for categories");
        }
      } else {
        print(
          "Categories API error: ${response.statusCode} - ${response.body}",
        );
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /*                            GET PRODUCTS BY CATEGORY CODE                                       */
  static Future<List<Product>> getProductsByCategoryCode(
    int categoryCode,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/getproducts?code=$categoryCode'),
        headers: await _getHeaders(),
      );

      print(
        "Products API Response for category $categoryCode: ${response.statusCode}",
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final products = jsonResponse['products'] as List;
          print("Found ${products.length} products for category $categoryCode");

          for (var product in products) {
            print(
              "Product: ${product['name']}, Brand: ${product['manufacturer']}, Price: ${product['price']}, Image: ${product['image']}",
            );
          }

          return products
              .map((productJson) => Product.fromJson(productJson))
              .toList();
        } else {
          print("API returned success: false for category $categoryCode");
        }
      } else {
        print("Products API error: ${response.statusCode} - ${response.body}");
      }
      return [];
    } catch (e) {
      print("Error fetching products for category $categoryCode: $e");
      return [];
    }
  }

  /*                     GET CATEGORY ID BY  NAME                                   */
  static Future<int?> getCategoryIdByName(String categoryName) async {
    try {
      final categories = await getCategories();
      print("Searching for category: $categoryName");

      // Recursive function to search through all categories and subcategories
      int? findCategoryId(List<Category> categories, String name) {
        for (var category in categories) {
          print("Checking category: ${category.name} (ID: ${category.id})");

          // Check if this category matches
          if (category.name.toLowerCase() == name.toLowerCase()) {
            print(" Found category: ${category.name} with ID: ${category.id}");
            return category.id;
          }

          // Recursively search in children
          if (category.children.isNotEmpty) {
            final childId = findCategoryId(category.children, name);
            if (childId != null) return childId;
          }
        }
        return null;
      }

      final categoryId = findCategoryId(categories, categoryName);

      if (categoryId == null) {
        print(" Category '$categoryName' not found!");
        // Debug: print all available categories
        print("=== AVAILABLE CATEGORIES ===");
        void printCategories(List<Category> cats, [String indent = ""]) {
          for (var cat in cats) {
            print("$indent${cat.name} (ID: ${cat.id})");
            if (cat.children.isNotEmpty) {
              printCategories(cat.children, "$indent  ");
            }
          }
        }

        printCategories(categories);
        print("============================");
      }

      return categoryId;
    } catch (e) {
      print("Error finding category ID for '$categoryName': $e");
      return null;
    }
  }

  /*                             GET PRODUCTS BY CATEGORY NAME                           */
  static Future<List<Product>> getProductsByCategoryName(
    String categoryName,
  ) async {
    try {
      // First, get all categories to find the ID
      final categories = await getCategories();

      // Find the category by name (case-insensitive)
      final category = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => Category(id: 0, name: '', children: []),
      );

      if (category.id == 0) {
        print("Category '$categoryName' not found");
        return [];
      }

      // Get all subcategory IDs including the main category
      final categoryIds = category.getAllCategoryIds();

      // Fetch products for all these category IDs
      List<Product> allProducts = [];

      for (int categoryId in categoryIds) {
        try {
          final products = await getProductsByCategory(categoryId.toString());
          allProducts.addAll(products);
        } catch (e) {
          print("Error fetching products for category $categoryId: $e");
        }
      }

      final uniqueProducts =
          allProducts
              .fold<Map<int, Product>>({}, (map, product) {
                map[product.id] = product;
                return map;
              })
              .values
              .toList();

      return uniqueProducts;
    } catch (e) {
      print("Error in getProductsByCategoryName: $e");
      throw e;
    }
  }

  //  get products by category ID
  static Future<List<Product>> getProductsByCategory(
    String categoryCode,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/getproducts?code=$categoryCode'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final products = jsonResponse['products'] as List;
          return products
              .map((productJson) => Product.fromJson(productJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching products for category $categoryCode: $e");
      return [];
    }
  }

  /*                           GET PRODUCTS BY CATEGORY ID                                            */
  static Future<List<Product>> getProductsByCategoryIdTest(
    int categoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/getproducts?code=$categoryId'),
      );

      print("Test API Response: ${response.statusCode}");
      print("Test API Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final products = jsonResponse['products'] as List;
          return products
              .map((productJson) => Product.fromJson(productJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Test Error: $e");
      return [];
    }
  }

  /*                           GET CATEGORY BY NAME                                          */
  static Future<Category?> getCategoryByName(String categoryName) async {
    final categories = await getCategories();
    return categories.firstWhere(
      (Category) => Category.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => Category(id: 0, name: '', children: []),
    );
  }

  /*                          DEBUG CATEGORIES                                                */
  static Future<void> debugCategories() async {
    try {
      final categories = await getCategories();
      print("=== AVAILABLE CATEGORIES ===");
      for (var category in categories) {
        print("${category.name} (ID: ${category.id})");
        if (category.children.isNotEmpty) {
          for (var child in category.children) {
            print("  └─ ${child.name} (ID: ${child.id})");
          }
        }
      }
      print("============================");
    } catch (e) {
      print("Error debugging categories: $e");
    }
  }

  /*                           GET NEWEST PRODUCTS (Sorted by date_add)                                          */
  static Future<List<Product>> getNewestProducts({
    int numberOfProducts = 10,
    String orderBy = 'date_add',
    String orderSens = 'desc',
  }) async {
    try {
      final Map<String, String> queryParams = {
        'order_by': orderBy,
        'order_sens': orderSens,
        'nombre_products': numberOfProducts.toString(),
      };

      // Remove empty parameters
      queryParams.removeWhere((key, value) => value.isEmpty);

      final Uri uri = Uri.parse(
        '$baseUrl/public/getproducts',
      ).replace(queryParameters: queryParams);

      print("Fetching newest products from: $uri");

      final response = await http
          .get(uri, headers: await _getHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print("Newest products API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> productsJson = data['products'];
          print("Found ${productsJson.length} newest products");

          // Debug: Print first product to verify date sorting
          if (productsJson.isNotEmpty) {
            print("First product: ${productsJson.first['name']}");
            if (productsJson.first.containsKey('date_add')) {
              print("Date added: ${productsJson.first['date_add']}");
            }
          }

          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          print("API returned success: false for newest products");
          print("Error message: ${data['error']}");
        }
      } else {
        print(
          "Newest products API error: ${response.statusCode} - ${response.body}",
        );
      }
      return [];
    } catch (e) {
      print('Error fetching newest products: $e');
      return [];
    }
  }

  /*                           GET CATEGORY CODE BY NAME                          */
  static Future<String> getCategoryCodeByName(String categoryName) async {
    try {
      final categories = await getCategories();

      // Recursive function to search through all categories and subcategories
      String? findCategoryCode(List<Category> categories, String name) {
        for (var category in categories) {
          // Check if this category matches
          if (category.name.toLowerCase() == name.toLowerCase()) {
            return category.id.toString();
          }

          // Recursively search in children
          if (category.children.isNotEmpty) {
            final childCode = findCategoryCode(category.children, name);
            if (childCode != null) return childCode;
          }
        }
        return null;
      }

      final categoryCode = findCategoryCode(categories, categoryName);

      if (categoryCode == null) {
        print("Category '$categoryName' not found!");
        return '';
      }

      return categoryCode;
    } catch (e) {
      print("Error finding category code for '$categoryName': $e");
      return '';
    }
  }

  /*                           GET RANDOM PRODUCTS FROM CATEGORIES                          */
  static Future<List<Product>> getRandomProductsFromCategories({
    int numberOfProducts = 20,
    String shopId = '4',
  }) async {
    try {
      print("Fetching random products from categories...");

      // First, get all categories
      final categories = await getCategories();
      print("Found ${categories.length} total categories");

      // Get all category IDs (including subcategories)
      final allCategoryIds = <int>[];
      void collectCategoryIds(List<Category> categoryList) {
        for (var category in categoryList) {
          allCategoryIds.add(category.id);
          if (category.children.isNotEmpty) {
            collectCategoryIds(category.children);
          }
        }
      }

      collectCategoryIds(categories);

      print("Available category IDs: $allCategoryIds");

      if (allCategoryIds.isEmpty) {
        print("No categories found!");
        return [];
      }

      // Shuffle the category IDs to get random order
      allCategoryIds.shuffle();

      List<Product> allProducts = [];
      int productsNeeded = numberOfProducts;

      // Fetch products from random categories until we have enough products
      for (int categoryId in allCategoryIds) {
        if (productsNeeded <= 0) break;

        try {
          print("Fetching products from category ID: $categoryId");
          final products = await getProductsByCategoryCode(categoryId);

          if (products.isNotEmpty) {
            // Shuffle products from this category and take what we need
            products.shuffle();
            final productsToTake = products.take(productsNeeded).toList();
            allProducts.addAll(productsToTake);
            productsNeeded -= productsToTake.length;

            print(
              "Added ${productsToTake.length} products from category $categoryId",
            );
            print("Still need $productsNeeded more products");
          }
        } catch (e) {
          print("Error fetching products from category $categoryId: $e");
          // Continue with next category
        }

        // Small delay to avoid overwhelming the API
        await Future.delayed(Duration(milliseconds: 100));
      }

      // If we still don't have enough products, shuffle and duplicate (or return what we have)
      if (allProducts.length < numberOfProducts) {
        print(
          "Only found ${allProducts.length} products, needed $numberOfProducts",
        );
        // You can choose to return what we have, or duplicate to fill
        // For now, let's return what we have
      }

      // Final shuffle to mix products from different categories
      allProducts.shuffle();

      print(" Final result: ${allProducts.length} random products");
      return allProducts;
    } catch (e) {
      print('Error fetching random products from categories: $e');
      return [];
    }
  }

  /*                           GET PRODUCTS FROM MULTIPLE CATEGORIES                       */
  static Future<List<Product>> getProductsFromMultipleCategories(
    List<int> categoryIds,
  ) async {
    try {
      List<Product> allProducts = [];

      for (int categoryId in categoryIds) {
        try {
          final products = await getProductsByCategoryCode(categoryId);
          allProducts.addAll(products);
          print("Added ${products.length} products from category $categoryId");
        } catch (e) {
          print("Error fetching from category $categoryId: $e");
        }
      }

      // Shuffle the final list
      allProducts.shuffle();

      return allProducts;
    } catch (e) {
      print('Error fetching products from multiple categories: $e');
      return [];
    }
  }

  /*                           GET PRODUCT DETAIL BY ID                                            */
  // static Future<Map<String, dynamic>?> getProductDetail({
  //   required int productId,
  //   int languageId = 1,
  // }) async {
  //   try {
  //     final response = await http
  //         .get(
  //           Uri.parse(
  //             '$baseUrl/public/getproductdetail?id_product=$productId&id_lang_app=$languageId',
  //           ),
  //           headers: await _getHeaders(),
  //         )
  //         .timeout(Duration(seconds: timeoutSeconds));

  //     print("Product detail API response status: ${response.statusCode}");
  //     print(
  //       "Product detail API URL: $baseUrl/public/getproductdetail?id_product=$productId&id_lang_app=$languageId",
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);

  //       if (data['success'] == true) {
  //         print(" Product detail fetched successfully for ID: $productId");
  //         return data;
  //       } else {
  //         print(" API returned success: false for product detail");
  //         print("Error message: ${data['error']}");
  //       }
  //     } else {
  //       print(
  //         "Product detail API error: ${response.statusCode} - ${response.body}",
  //       );
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching product detail: $e');
  //     return null;
  //   }
  // }

  static Future<Map<String, dynamic>?> getProductDetail({
    required int productId,
    int languageId = 1,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/public/getproductdetail?id_product=$productId&id_lang_app=$languageId',
            ),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("🔍 Product detail API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['product'] != null) {
          final productData = data['product'];

          // ENHANCED DEBUG: Print all combination data
          if (productData['combinations'] != null) {
            final combos = productData['combinations'] as List;
            print("🔄 Raw combinations from API: ${combos.length}");

            for (var i = 0; i < combos.length; i++) {
              final combo = combos[i];
              final attributes = combo['attributes']?.toString() ?? '';
              final colorCode = combo['color']?.toString() ?? '';
              final stock = combo['quantity'] ?? combo['stock'] ?? 0;

              print(
                "   [$i] ID: ${combo['id_product_attribute']}, "
                "Attributes: '$attributes', "
                "Color: '$colorCode', "
                "Stock: $stock, "
                "Default: ${combo['default']}",
              );
            }
          }

          return data;
        } else {
          print(" API returned success: false for product detail");
        }
      } else {
        print(" Product detail API error: ${response.statusCode}");
      }
      return null;
    } catch (e) {
      print(' Error fetching product detail: $e');
      return null;
    }
  }

  /*                           GET SIMILAR PRODUCTS BY CATEGORY ID                          */
  static Future<List<Product>> getSimilarProductsByCategory({
    required int categoryId,
    required int excludeProductId,
    int limit = 10,
  }) async {
    try {
      print(
        "Fetching similar products for category ID: $categoryId, excluding product: $excludeProductId",
      );

      // First, get all categories to find the category hierarchy
      final categories = await getCategories();

      // Find all related category IDs (including parent and children)
      final relatedCategoryIds = _getRelatedCategoryIds(categories, categoryId);

      if (relatedCategoryIds.isEmpty) {
        print("No related categories found for ID: $categoryId");

        // Fallback: try to get products from any category (random products)
        print("Using fallback: fetching random products");
        return await getRandomProductsFromCategories(numberOfProducts: limit);
      }

      print("Related category IDs: $relatedCategoryIds");

      List<Product> allSimilarProducts = [];

      // Fetch products from all related categories
      for (int catId in relatedCategoryIds) {
        try {
          final products = await getProductsByCategoryCode(catId);

          // Filter out the current product and add to list
          final filteredProducts =
              products
                  .where((product) => product.id != excludeProductId)
                  .toList();
          allSimilarProducts.addAll(filteredProducts);

          print("Found ${filteredProducts.length} products in category $catId");

          // If we have enough products, break early
          if (allSimilarProducts.length >= limit) {
            break;
          }
        } catch (e) {
          print("Error fetching products from category $catId: $e");
        }
      }

      // Remove duplicates and limit the results
      final uniqueProducts =
          allSimilarProducts
              .fold<Map<int, Product>>({}, (map, product) {
                if (!map.containsKey(product.id)) {
                  map[product.id] = product;
                }
                return map;
              })
              .values
              .toList();

      final result = uniqueProducts.take(limit).toList();
      print(" Found ${result.length} similar products");

      return result;
    } catch (e) {
      print('Error fetching similar products: $e');
      return [];
    }
  }

  /*                           GET RELATED CATEGORY IDs (including parent and children)     */
  static List<int> _getRelatedCategoryIds(
    List<Category> categories,
    int targetCategoryId,
  ) {
    final List<int> relatedIds = [];

    // First, declare the helper functions
    void _addAllChildrenIds(Category category, List<int> idList) {
      for (var child in category.children) {
        idList.add(child.id);
        if (child.children.isNotEmpty) {
          _addAllChildrenIds(child, idList);
        }
      }
    }

    void findAndCollectCategories(List<Category> categoryList, int targetId) {
      for (var category in categoryList) {
        // If this is the target category, add it and its children
        if (category.id == targetId) {
          relatedIds.add(category.id);
          // Add all children categories
          _addAllChildrenIds(category, relatedIds);
          return;
        }

        // If this category has children, search recursively
        if (category.children.isNotEmpty) {
          findAndCollectCategories(category.children, targetId);
        }
      }
    }

    // Search for the target category
    findAndCollectCategories(categories, targetCategoryId);

    // If we found the target category, also try to find its parent
    if (relatedIds.isNotEmpty) {
      _findParentCategoryId(categories, targetCategoryId, relatedIds);
    }

    return relatedIds;
  }

  /*                           FIND PARENT CATEGORY ID                                      */
  static void _findParentCategoryId(
    List<Category> categories,
    int targetCategoryId,
    List<int> idList,
  ) {
    for (var category in categories) {
      // Check if this category has the target as a child
      if (_hasChildWithId(category, targetCategoryId)) {
        idList.add(category.id);
        return;
      }

      // Recursively search in children
      if (category.children.isNotEmpty) {
        _findParentCategoryId(category.children, targetCategoryId, idList);
      }
    }
  }

  /*                           CHECK IF CATEGORY HAS CHILD WITH SPECIFIC ID                */
  static bool _hasChildWithId(Category category, int targetId) {
    for (var child in category.children) {
      if (child.id == targetId) {
        return true;
      }
      if (child.children.isNotEmpty && _hasChildWithId(child, targetId)) {
        return true;
      }
    }
    return false;
  }

  /*                           GET PRODUCTS BY CATEGORY ID (ENHANCED)                      */
  static Future<List<Product>> getProductsByCategoryId(
    int categoryId, {
    String shopId = '4',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/getproducts?code=$categoryId'),
        headers: await _getHeaders(),
      );

      print(
        "Products API Response for category $categoryId: ${response.statusCode}",
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final products = jsonResponse['products'] as List;
          print("Found ${products.length} products for category $categoryId");
          return products
              .map((productJson) => Product.fromJson(productJson))
              .toList();
        } else {
          print("API returned success: false for category $categoryId");
        }
      } else {
        print("Products API error: ${response.statusCode} - ${response.body}");
      }
      return [];
    } catch (e) {
      print("Error fetching products for category $categoryId: $e");
      return [];
    }
  }

  /*                           GET CART ITEMS API (FIXED)                          */
  static Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getcart'),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("getCart API response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle redirects
      if (response.statusCode == 301 || response.statusCode == 302) {
        final location = response.headers['location'];
        print("Redirect detected to: $location");
        return {
          'success': false,
          'message': 'getcart endpoint redirected. Please check API URL.',
        };
      }

      if (response.statusCode == 200) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') ||
            response.body.trim().startsWith('[')) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData['success'] == true) {
            print("✓ Cart fetched successfully");
            return {
              'success': true,
              'cart': responseData['cart'] ?? {},
              'products': responseData['products'] ?? [],
              'id_cart': responseData['id_cart'],
            };
          } else {
            return {
              'success': false,
              'message': responseData['message'] ?? 'Failed to fetch cart',
            };
          }
        } else {
          // HTML response
          print("✗ getcart returned HTML instead of JSON");
          return {
            'success': false,
            'message':
                'getcart endpoint returned HTML. Endpoint may not exist.',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("✗ Error fetching cart: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           CREATE ADDRESS API                                       */
  static Future<Map<String, dynamic>> createAddress({
    required String firstname,
    required String lastname,
    required String address1,
    required String city,
    required String postcode,
    required int idState,
    String? phone,
    String? address2,
    String? alias = 'Home Address',
  }) async {
    try {
      final Map<String, String> queryParams = {
        'firstname': firstname,
        'lastname': lastname,
        'address1': address1,
        'city': city,
        'postcode': postcode,
        'id_state': idState.toString(),
      };

      // Add optional parameters if provided
      if (phone != null && phone.isNotEmpty) {
        queryParams['phone'] = phone;
      }
      if (address2 != null && address2.isNotEmpty) {
        queryParams['address2'] = address2;
      }
      if (alias != null && alias.isNotEmpty) {
        queryParams['alias'] = alias;
      }

      final Uri uri = Uri.parse(
        '$baseUrl/public/createaddress',
      ).replace(queryParameters: queryParams);

      print("Making createAddress API call to: $uri");
      print("Parameters: $queryParams");

      final response = await http
          .post(uri, headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print("createAddress API response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true ||
            responseData['message'] == 'success') {
          print("✓ Address created successfully");
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Address created successfully',
            'addressId':
                responseData['id_address'] ?? responseData['address_id'],
            'addressData': responseData['address'] ?? responseData,
          };
        } else {
          print("✗ Address creation failed: ${responseData['message']}");
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to create address',
          };
        }
      } else {
        print("✗ Address creation API error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("✗ Error creating address: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           GET CUSTOMER DETAILS API                               */
  static Future<Map<String, dynamic>> getCustomerDetails() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getcustomer'),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("getCustomerDetails API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          print("✓ Customer details fetched successfully");
          return responseData;
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to fetch customer details',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("✗ Error fetching customer details: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           GET ADDRESS BY ID API                                */
  static Future<Map<String, dynamic>> getAddressById(int addressId) async {
    try {
      final Uri uri = Uri.parse(
        '$baseUrl/public/getadressebyid?id_address=$addressId',
      );

      print("Making getAddressById API call to: $uri");

      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print("getAddressById API response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true ||
            responseData['message'] == 'success') {
          print("✓ Address fetched successfully");
          return {
            'success': true,
            'address': responseData['address'] ?? responseData,
            'message':
                responseData['message'] ?? 'Address fetched successfully',
          };
        } else {
          print("✗ Address fetch failed: ${responseData['message']}");
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to fetch address',
          };
        }
      } else {
        print("✗ Address fetch API error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("✗ Error fetching address: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           GET CUSTOMER ADDRESSES API                          */
  static Future<Map<String, dynamic>> getCustomerAddresses() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getaddresses'),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("getCustomerAddresses API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          print("✓ Customer addresses fetched successfully");
          return {
            'success': true,
            'addresses': responseData['addresses'] ?? [],
            'message':
                responseData['message'] ?? 'Addresses fetched successfully',
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to fetch addresses',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("✗ Error fetching customer addresses: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /*                           GET PRODUCT ATTRIBUTES (ENHANCED)                          */
  static Future<Map<String, dynamic>> getProductAttributes(
    int productId,
  ) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/public/getproductattributes?id_product=$productId',
            ),
            headers: headers,
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("Get product attributes response: ${response.statusCode}");
      print("Product attributes body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print(
            "✓ Product attributes fetched successfully for product $productId",
          );
          return responseData;
        } else {
          print("✗ Product attributes API returned success: false");
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to get product attributes',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to get product attributes: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Error getting product attributes: $e");
      return {
        'success': false,
        'message': 'Failed to get product attributes: $e',
      };
    }
  }

  /*                           GET DEFAULT PRODUCT ATTRIBUTE ID                          */
  static Future<int?> getDefaultProductAttributeId(int productId) async {
    try {
      final attributesResponse = await getProductAttributes(productId);

      if (attributesResponse['success'] == true) {
        if (attributesResponse['combinations'] != null &&
            attributesResponse['combinations'] is List &&
            attributesResponse['combinations'].isNotEmpty) {
          final firstCombination = attributesResponse['combinations'][0];
          final attributeId =
              firstCombination['id_product_attribute'] ??
              firstCombination['id'];

          print("✓ Default attribute ID for product $productId: $attributeId");
          return attributeId is String
              ? int.tryParse(attributeId)
              : attributeId as int?;
        }

        // check if the response directly contains product_attribute_id
        if (attributesResponse['id_product_attribute'] != null) {
          final attributeId = attributesResponse['id_product_attribute'];
          print("✓ Default attribute ID for product $productId: $attributeId");
          return attributeId is String
              ? int.tryParse(attributeId)
              : attributeId as int?;
        }

        // If no combinations found, return the product ID as fallback (not ideal)
        print(
          "⚠ No combinations found for product $productId, using product ID as fallback",
        );
        return productId;
      } else {
        print(
          "✗ Failed to get attributes for product $productId: ${attributesResponse['message']}",
        );
        return productId; // Fallback
      }
    } catch (e) {
      print("Error getting default product attribute: $e");
      return productId; // Fallback
    }
  }

  /* ------------------------- CART OPERATIONS ------------------------- */

  static Future<Map<String, dynamic>> updateCart(
    Map<String, dynamic> params,
  ) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/updatecart',
      ).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Update cart API error: $e');
      rethrow;
    }
  }

  // DELETE PRODUCT FROM CART
  static Future<Map<String, dynamic>> deleteProductCart({
    required int idCart,
    required int productId,
    required int productAttributeId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/deleteproductcart').replace(
        queryParameters: {
          'id_cart': idCart.toString(),
          'id_product': productId.toString(),
          'id_product_attribute': productAttributeId.toString(),
        },
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete product cart API error: $e');
      rethrow;
    }
  }

  // GET CART PRODUCTS (for shopping cart page)
  static Future<Map<String, dynamic>> getProductCart(int idCart) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/getproductcart',
      ).replace(queryParameters: {'id_cart': idCart.toString()});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Get product cart API error: $e');
      rethrow;
    }
  }

  /*                           TEST ENDPOINT FOR RESET PASSWORD                                             */
  // static Future<void> testApiEndpoint() async {
  //   try {
  //     print('Testing API endpoint: $baseUrl/public/verifypassword');

  //     // Test with a simple GET request first
  //     var testResponse = await http.get(Uri.parse(baseUrl));
  //     print('Base URL test - Status: ${testResponse.statusCode}');
  //     print('Base URL test - Body: ${testResponse.body}');

  //     // Test the actual endpoint
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('$baseUrl/public/verifypassword'),
  //     );
  //     request.fields['email'] = 'test@example.com';

  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     print('API Test - Status Code: ${response.statusCode}');
  //     print('API Test - Response Type: ${response.headers['content-type']}');
  //     print('API Test - Response Length: ${responseData.length}');
  //     print(
  //       'API Test - First 200 chars: ${responseData.length > 200 ? responseData.substring(0, 200) : responseData}',
  //     );
  //   } catch (e) {
  //     print('API Test Error: $e');
  //   }
  // }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // authToken = null;
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
          // Helper function to parse price as double
          double parsePrice(dynamic priceValue) {
            if (priceValue == null) return 0.0;
            if (priceValue is double) return priceValue;
            if (priceValue is int) return priceValue.toDouble();
            if (priceValue is String) {
              return double.tryParse(priceValue) ?? 0.0;
            }
            return 0.0;
          }

          // Helper function to parse old price as double?
          double? parseOldPrice(dynamic oldPriceValue) {
            if (oldPriceValue == null) return null;
            if (oldPriceValue is double) return oldPriceValue;
            if (oldPriceValue is int) return oldPriceValue.toDouble();
            if (oldPriceValue is String) {
              return double.tryParse(oldPriceValue);
            }
            return null;
          }

          return data['response'].map<Product>((productJson) {
            return Product(
              id: int.tryParse(productJson['id']?.toString() ?? '0') ?? 0,
              name: productJson['name'] ?? 'No Name',
              brand: productJson['brand'] ?? 'No Brand',
              price: parsePrice(productJson['price']), // Now double
              image: productJson['image'] ?? '',
              description: productJson['description'] ?? 'No Description',
              oldPrice: parseOldPrice(productJson['oldPrice']), // Now double?
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

          // Helper function to parse price as double
          double parsePrice(dynamic priceValue) {
            if (priceValue == null) return 0.0;
            if (priceValue is double) return priceValue;
            if (priceValue is int) return priceValue.toDouble();
            if (priceValue is String) {
              return double.tryParse(priceValue) ?? 0.0;
            }
            return 0.0;
          }

          // Helper function to parse old price as double?
          double? parseOldPrice(dynamic oldPriceValue) {
            if (oldPriceValue == null) return null;
            if (oldPriceValue is double) return oldPriceValue;
            if (oldPriceValue is int) return oldPriceValue.toDouble();
            if (oldPriceValue is String) {
              return double.tryParse(oldPriceValue);
            }
            return null;
          }

          return (products as List).map<Product>((productJson) {
            return Product(
              id:
                  int.tryParse(productJson['id_product']?.toString() ?? '0') ??
                  0,
              reference: productJson['reference'] ?? 'N/A',
              name: productJson['name'] ?? 'No Name',
              brand: productJson['manufacturer_name'] ?? 'No Brand',
              price: parsePrice(productJson['price']), // Now double
              image: productJson['image'] ?? '',
              description: productJson['description_short'] ?? 'No Description',
              oldPrice: parseOldPrice(
                productJson['price_without_reduction'],
              ), // Now double?
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

  /*                           FIND CATEGORY BY NAME                                           */
  static Future<Category?> findCategoryByName(String categoryName) async {
    try {
      final categories = await getCategories();

      // First try exact match
      var category = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => Category(id: 0, name: '', children: []),
      );

      // If not found, try partial match
      if (category.id == 0) {
        category = categories.firstWhere(
          (cat) => cat.name.toLowerCase().contains(categoryName.toLowerCase()),
          orElse: () => Category(id: 0, name: '', children: []),
        );
      }

      return category.id != 0 ? category : null;
    } catch (e) {
      print('Error finding category by name: $e');
      return null;
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

  static syncCartWithServer({
    required List<CartItem> localCartItems,
    required int idCart,
  }) {}
}
