import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Services/local_address_service.dart';
import 'package:tawasul_application/model/address_model.dart';
import 'package:tawasul_application/model/carrier_model.dart';
import 'package:tawasul_application/model/cart_model.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/model/state_model..dart';
import 'package:tawasul_application/model/category_model.dart';
import 'package:tawasul_application/tools/language_manager.dart';

class ApiService {
  static const String baseUrl = "https://tawasul-dev.app-staging.fr";
  static const int timeoutSeconds = 30;

  static List<StateModel> _statesList = [];
  static Map<int, String> _stateIdToName = {};
  static Map<String, int> _stateNameToId = {};
  static bool _statesLoaded = false;

  static Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print(" TOKEN RETRIEVAL DEBUG:");
      print("   - Token exists: ${token != null}");
      print("   - Token length: ${token?.length ?? 0}");

      if (token != null) {
        if (token.isEmpty) {
          print(" ERROR: Token is empty string");
          return null;
        }

        if (token.contains('"') || token.contains("'")) {
          print("  WARNING: Token may be wrapped in quotes");
          final cleanedToken =
              token.replaceAll('"', '').replaceAll("'", '').trim();
          if (cleanedToken.isNotEmpty) {
            // Update storage with cleaned token
            await prefs.setString('auth_token', cleanedToken);
            print(" Cleaned token stored");
            return cleanedToken;
          }
        }

        print(
          "   - Token preview: ${token.substring(0, min(20, token.length))}...",
        );
        return token;
      }

      print(" No token found in SharedPreferences");
      return null;
    } catch (e) {
      print(" Error retrieving token: $e");
      return null;
    }
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final token = await _getAuthToken();
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': language,
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
        print(" Authorization header added with token");
      } else {
        print(" No token available for Authorization header");
      }

      return headers;
    } catch (e) {
      print(" Error creating auth headers: $e");
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    }
  }

  /* ------------------------- LOGIN  ------------------------- */
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      print(" STARTING LOGIN PROCESS");
      print("📧 Email: $email");

      var request = await http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/public/login'),
      );

      request.fields['email'] = email.trim();
      request.fields['password'] = password.trim();
      request.headers['Accept'] = 'application/json';

      print(" Making API call to: $baseUrl/public/login");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response Status Code: ${response.statusCode}");

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
        print(" Successfully parsed JSON response");
      } catch (e) {
        print(" Failed to parse JSON: $e");
        return {
          'success': false,
          'message': 'Invalid response format from server: $e',
        };
      }

      // In the login success section, after storing the token:
      if (responseData['success'] == true && responseData['token'] != null) {
        print("LOGIN SUCCESSFUL WITH TOKEN!");

        final token = responseData['token']!.trim();
        print("Raw token received: ${token.length} chars");

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        // Clear any existing tokens first
        await prefs.remove('auth_token');
        await prefs.setString('auth_token', token);

        // Store user ID
        if (responseData['id_customer'] != null) {
          await prefs.setInt('user_id', responseData['id_customer']);
        }

        // IMMEDIATE VERIFICATION
        await Future.delayed(Duration(milliseconds: 100)); // Let storage commit
        final storedToken = prefs.getString('auth_token');

        print(" STORAGE VERIFICATION:");
        print("   - Token stored successfully: ${storedToken != null}");
        print(
          "   - Token length matches: ${storedToken?.length == token.length}",
        );
        print("   - Token value matches: ${storedToken == token}");

        if (storedToken == null) {
          print(" CRITICAL: Token storage failed!");
          // Try alternative storage method
          await prefs.setString('auth_token', token);
          final retryToken = prefs.getString('auth_token');
          print("   - Retry result: ${retryToken != null}");
        }

        return {'success': true, 'token': token, 'message': 'Login successful'};
      } else {
        print(" HTTP Error: ${response.statusCode}");
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" Login exception: $e");
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

  /* ------------------------- CART OPERATIONS ------------------------- */

  static Future<Map<String, dynamic>> createOrGetCart() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/public/getproductcart'))
          .timeout(Duration(seconds: timeoutSeconds));

      print(" createOrGetCart response: ${response.statusCode}");
      print(" Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['id_cart'] != null) {
          return {
            'success': true,
            'id_cart': data['id_cart'].toString(),
            'message': 'Cart retrieved successfully',
          };
        } else {
          // Try to create a new cart by adding a product
          return await _createNewCart();
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" createOrGetCart error: $e");
      return {'success': false, 'message': 'Failed to create/get cart: $e'};
    }
  }

  static Future<Map<String, dynamic>> _createNewCart() async {
    try {
      final result = await addToCart(
        cartId: "1",
        productId: '1',
        quantity: 1,
        productAttributeId: '0',
      );

      if (result == true) {
        final cartResponse = await getCart();
        if (cartResponse['success'] == true &&
            cartResponse['id_cart'] != null) {
          return {
            'success': true,
            'id_cart': cartResponse['id_cart'].toString(),
            'message': 'New cart created successfully',
          };
        }
      }

      return {'success': false, 'message': 'Failed to create new cart'};
    } catch (e) {
      return {'success': false, 'message': 'Failed to create cart: $e'};
    }
  }

  static Future<Map<String, dynamic>> getCart({String? cartId}) async {
    try {
      // If no cartId provided, we can't call this endpoint
      if (cartId == null || cartId.isEmpty) {
        return {
          'success': false,
          'message': 'Cart ID is required for getcart endpoint',
        };
      }

      final uri = Uri.parse(
        '$baseUrl/public/getcart',
      ).replace(queryParameters: {'id_cart': cartId});

      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(Duration(seconds: timeoutSeconds));

      print(" getCart API response status: ${response.statusCode}");
      print(" Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          print(" Cart fetched successfully");
          print(" Cart ID: ${responseData['id_cart']}");
          print(" Products count: ${(responseData['products'] ?? []).length}");

          return {
            'success': true,
            'cart': responseData['cart'] ?? {},
            'products': responseData['products'] ?? [],
            'id_cart': responseData['id_cart']?.toString() ?? cartId,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to fetch cart',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" Error fetching cart: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  //CREATE CART
  static Future<bool> createCart({
    required String productId,
    required int quantity,
    String? productAttributeId,
  }) async {
    try {
      final headers = await _getAuthHeaders();

      print(" Create new cart");

      final params = {
        'id_product': productId,
        'id_product_attribute': productAttributeId ?? '0',
        'qty': quantity.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/public/updatecart',
      ).replace(queryParameters: params);

      print(" API URL: ${uri.toString()}");

      final response = await http.get(uri, headers: headers);

      print(" Add to cart response status: ${response.statusCode}");
      print(" Add to cart response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print(" Product added to cart successfully");
          return true;
        } else {
          throw Exception('API error: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception(
          'HTTP error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print(" Add to cart error: $e");
      rethrow;
    }
  }

  //ADD TO CART
  static Future<Map<String, dynamic>> addToCart({
    String? cartId = '',
    required String productId,
    required int quantity,
    String? productAttributeId,
  }) async {
    try {
      //  Initialize SharedPreferences to store/retrieve cart ID
      final prefs = await SharedPreferences.getInstance();

      // Try to reuse stored cart ID if available
      String? storedCartId = prefs.getString('cart_id');

      // Use the stored cartId if exists, otherwise use the one passed or empty
      final effectiveCartId = storedCartId ?? cartId ?? '';

      // Prepare headers and parameters
      final headers = {'Accept': 'application/json'};
      final params = {
        'id_cart': effectiveCartId,
        'id_product': productId,
        'id_product_attribute': productAttributeId ?? '0',
        'qty': quantity.toString(),
      };

      final uri = Uri.parse('$baseUrl/public/updatecart');
      print("🛒 Adding product to cart:");
      print("  → Cart ID: $effectiveCartId");
      print("  → Product ID: $productId");
      print("  → Attribute ID: ${productAttributeId ?? '0'}");
      print("  → Quantity: $quantity");
      print("  → Request URL: $uri");
      print("  → Params: $params");

      // Make the POST request
      final response = await http.post(uri, headers: headers, body: params);

      print("📦 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final newCartId = data['id_cart']?.toString() ?? '';

          //  Store cart ID for next requests
          if (newCartId.isNotEmpty) {
            await prefs.setString('cart_id', newCartId);
            print("* Saved cart ID locally: $newCartId");
          }

          return {
            'success': true,
            'id_cart': newCartId,
            'message': 'Product added to cart successfully',
          };
        } else {
          print(" API Error: ${data['message'] ?? 'Unknown error'}");
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to add product to cart',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" Add to cart error: $e");
      return {'success': false, 'message': 'Failed to add product to cart: $e'};
    }
  }

  //GET CART BY ID
  static Future<CartResponse> getCartById(String cartId) async {
    try {
      print(" Getting cart by ID: $cartId");

      // Create headers WITHOUT token
      final Map<String, String> headers = {'Accept': 'application/json'};

      final uri = Uri.parse(
        '$baseUrl/public/getproductcart',
      ).replace(queryParameters: {'id_cart': "$cartId"});

      print(" API URL: ${uri.toString()}");
      final response = await http.get(uri, headers: headers);

      print(" Get cart response status: ${response.statusCode}");
      print(" Get cart response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final cartResponse = CartResponse.fromJson(data);
          print(" Cart retrieved successfully:");
          // print("   - Cart ID: ${cartResponse.idCart}");
          //print("   - Products count: ${cartResponse.products.length}");
          return cartResponse;
        } else {
          throw Exception('API error: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception(
          'HTTP error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print(" Get cart by ID error: $e");
      rethrow;
    }
  }

  Future<List<CartResponse>> fetchMyData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/public/getproductcart'),
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);

      if (jsonData is List<dynamic>) {
        return jsonData.map((json) => CartResponse.fromJson(json)).toList();
      } else if (jsonData is Map<String, dynamic>) {
        return [CartResponse.fromJson(jsonData)];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // DELETE PRODUCT FROM CART
  static Future<Map<String, dynamic>> deleteProductCart({
    required int idCart,
    required int productId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/public/deleteproductcart').replace(
        queryParameters: {
          'id_cart': idCart.toString(),
          'id_product': productId.toString(),
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
        headers: await _getAuthHeaders(),
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
                map[product.idProduct] = product;
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
      //final int languageId = await LanguageManager.getCurrentLanguageId();
      final response = await http.get(
        Uri.parse('$baseUrl/public/getproducts?code=$categoryCode'),
        headers: await _getAuthHeaders(),
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
          .get(uri, headers: await _getAuthHeaders())
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

  static Future<List<Product>> getRandomProductsFromCategories({
    int numberOfProducts = 20,
    String shopId = '4',
  }) async {
    try {
      print(" Fetching random products from categories...");
      print(" Target: $numberOfProducts products");

      // First, get all categories
      final categories = await getCategories();
      print(" Found ${categories.length} total categories");

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

      print(" Available category IDs: ${allCategoryIds.length}");

      if (allCategoryIds.isEmpty) {
        print(" No categories found!");
        return [];
      }

      // Shuffle the category IDs to get random order
      allCategoryIds.shuffle();

      // ADDED: Track processed categories to avoid infinite loops
      final processedCategories = <int>{};
      List<Product> allProducts = [];
      int productsNeeded = numberOfProducts;
      int maxIterations = allCategoryIds.length * 2; // Safety limit
      int currentIteration = 0;

      // Fetch products from random categories until we have enough products
      for (int categoryId in allCategoryIds) {
        // ADDED: Multiple safety checks
        if (productsNeeded <= 0 ||
            currentIteration >= maxIterations ||
            processedCategories.contains(categoryId)) {
          break;
        }

        processedCategories.add(categoryId);
        currentIteration++;

        try {
          print(" Fetching products from category ID: $categoryId");
          final products = await getProductsByCategoryCode(categoryId);

          if (products.isNotEmpty) {
            // Shuffle products from this category and take what we need
            final shuffledProducts = List<Product>.from(products)..shuffle();
            final productsToTake =
                shuffledProducts.take(productsNeeded).toList();
            allProducts.addAll(productsToTake);
            productsNeeded -= productsToTake.length;

            print(
              "Added ${productsToTake.length} products from category $categoryId",
            );
            print(" Still need $productsNeeded more products");

            // ADDED: Break immediately if we have enough
            if (productsNeeded <= 0) {
              print(" Reached target product count!");
              break;
            }
          } else {
            print("No products found in category $categoryId");
          }
        } catch (e) {
          print(" Error fetching products from category $categoryId: $e");
          // Continue with next category
        }

        // Small delay to avoid overwhelming the API
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Final shuffle to mix products from different categories
      allProducts.shuffle();

      print("🎊 Final result: ${allProducts.length} random products");

      // ADDED: Safety check - if we have too many, trim the list
      if (allProducts.length > numberOfProducts) {
        allProducts = allProducts.take(numberOfProducts).toList();
        print("✂️ Trimmed to exact target: ${allProducts.length} products");
      }

      return allProducts;
    } catch (e) {
      print(' Error fetching random products from categories: $e');
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

  static Future<Map<String, dynamic>?> getProductDetail({
    required int productId,
  }) async {
    try {
      final int languageId = await LanguageManager.getCurrentLanguageId();
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/public/getproductdetail?id_product=$productId&id_lang_app=$languageId',
            ),
            headers: await _getAuthHeaders(),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print(" Product detail API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['product'] != null) {
          final productData = data['product'];

          // ENHANCED DEBUG: Print all combination data
          if (productData['combinations'] != null) {
            final combos = productData['combinations'] as List;
            print(" Raw combinations from API: ${combos.length}");

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
          final filteredProducts =
              products
                  .where((product) => product.idProduct != excludeProductId)
                  .toList();
          allSimilarProducts.addAll(filteredProducts);

          print("Found ${filteredProducts.length} products in category $catId");

          if (allSimilarProducts.length >= limit) {
            break;
          }
        } catch (e) {
          print("Error fetching products from category $catId: $e");
        }
      }
      final uniqueProducts =
          allSimilarProducts
              .fold<Map<int, Product>>({}, (map, product) {
                if (!map.containsKey(product.idProduct)) {
                  map[product.idProduct] = product;
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
        headers: await _getAuthHeaders(),
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

  /* ------------------------- DEBUG TOKEN STORAGE ------------------------- */
  static Future<void> debugTokenStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print("\n" + "=" * 50);
      print(" DEBUG TOKEN STORAGE");
      print("=" * 50);

      // Check ALL stored data
      print(" ALL STORED DATA:");
      final allKeys = prefs.getKeys().toList()..sort();
      for (var key in allKeys) {
        final value = prefs.get(key);
        print("   - $key: $value");
      }

      // Specifically check auth_token
      final authToken = prefs.getString('auth_token');
      print("\n AUTH TOKEN STATUS:");
      print("   - auth_token exists: ${authToken != null}");
      print("   - auth_token value: $authToken");
      print("   - auth_token length: ${authToken?.length ?? 0}");

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Debug token storage error: $e");
    }
  }

  /* ------------------------- CHECK TOKEN FORMAT ------------------------- */
  static Future<void> _checkTokenFormat(String token) async {
    try {
      print("\n" + "=" * 50);
      print(" TOKEN FORMAT ANALYSIS");
      print("=" * 50);

      print(" Token Analysis:");
      print("   - Total length: ${token.length}");
      print("   - Contains spaces: ${token.contains(' ')}");
      print("   - Contains newlines: ${token.contains('\n')}");
      print(
        "   - Contains quotes: ${token.contains('"') || token.contains("'")}",
      );
      print("   - Starts with: ${token.substring(0, min(10, token.length))}");
      print(
        "   - Ends with: ${token.substring(token.length - min(10, token.length))}",
      );

      // Check if it's a JWT token (should have 3 parts separated by dots)
      final parts = token.split('.');
      print("   - JWT parts: ${parts.length}");
      if (parts.length == 3) {
        print("   - JWT header: ${parts[0].length} chars");
        print("   - JWT payload: ${parts[1].length} chars");
        print("   - JWT signature: ${parts[2].length} chars");
      }

      // Check for common issues
      if (token.startsWith('"') && token.endsWith('"')) {
        print("  WARNING: Token is wrapped in quotes!");
      }
      if (token.contains('\n')) {
        print("  WARNING: Token contains newlines!");
      }
      if (token.contains(' ')) {
        print("  WARNING: Token contains spaces!");
      }

      print("=" * 50 + "\n");
    } catch (e) {
      print(" Token format analysis error: $e");
    }
  }

  /* ------------------------- GET CUSTOMER DETAILS ------------------------- */

  static Future<Map<String, dynamic>> getCustomerDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      print("\n" + "=" * 50);
      print(" GET CUSTOMER DETAILS - START");
      print("=" * 50);

      if (token == null || token.isEmpty) {
        print(" TOKEN ISSUE:");
        print("   - Token is null: ${token == null}");
        print("   - Token is empty: ${token != null && token.isEmpty}");

        print(" ALL STORED KEYS:");
        final allKeys = prefs.getKeys();
        allKeys.forEach((key) {
          final value = prefs.get(key);
          print("   - $key: $value");
        });

        return {
          'success': false,
          'message': 'Authentication token not found',
          'code': 'NO_TOKEN',
        };
      }

      print(" TOKEN FOUND:");
      print("   - Token length: ${token.length}");
      print(
        "   - Token preview: ${token.substring(0, min(30, token.length))}...",
      );
      print("   - Token ends with: ...${token.substring(token.length - 20)}");

      await _checkTokenFormat(token);

      final url = '$baseUrl/public/getcustomerdetails';
      print(" MAKING API CALL:");
      print("   - URL: $url");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      print("   - Headers: $headers");

      final stopwatch = Stopwatch()..start();

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeoutSeconds));

      stopwatch.stop();

      print(" API RESPONSE:");
      print("Responseeeee : $response");
      print("   - Status Code: ${response.statusCode}");
      print("   - Response Time: ${stopwatch.elapsedMilliseconds}ms");
      print("   - Content-Type: ${response.headers['content-type']}");
      print("   - Content-Length: ${response.headers['content-length']}");

      print("   - ALL HEADERS:");
      response.headers.forEach((key, value) {
        print("     $key: $value");
      });

      if (response.statusCode == 200) {
        print(" HTTP 200 OK");
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("   - JSON Success: ${responseData['success']}");
        print("   - Response keys: ${responseData.keys.toList()}");

        if (responseData['success'] == true &&
            responseData['customer'] != null) {
          final customer = responseData['customer'];
          print(" CUSTOMER DATA SUCCESS:");
          print("   - Customer ID: ${customer['id']}");
          print("   - Name: ${customer['firstname']} ${customer['lastname']}");
          print("   - Email: ${customer['email']}");

          await _storeCustomerData(customer);

          print(" GET CUSTOMER DETAILS - COMPLETED SUCCESSFULLY");
          print("=" * 50 + "\n");

          return {
            'success': true,
            'firstName': customer['firstname'] ?? '',
            'lastName': customer['lastname'] ?? '',
            'email': customer['email'] ?? '',
            'phone': customer['phone'] ?? '',
            'mobile': customer['phone_number'] ?? '',
            'id': customer['id'] ?? 0,
            'id_state': customer['geoloc_id_state'],
          };
        } else {
          print(" API RESPONSE ISSUE:");
          print("   - Success field: ${responseData['success']}");
          print(
            "   - Customer field exists: ${responseData['customer'] != null}",
          );
          print("   - Message: ${responseData['message']}");
          print("   - Full response: $responseData");

          print(" GET CUSTOMER DETAILS - FAILED (API response issue)");
          print("=" * 50 + "\n");

          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Invalid response from server',
            'code': 'INVALID_RESPONSE',
          };
        }
      } else if (response.statusCode == 401) {
        print(" AUTHENTICATION FAILED - 401 Unauthorized");
        print("   - Response body: ${response.body}");

        print(" GET CUSTOMER DETAILS - FAILED (401 Unauthorized)");
        print("=" * 50 + "\n");

        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
          'code': 'AUTH_FAILED',
        };
      } else {
        print(" SERVER ERROR:");
        print("   - Status: ${response.statusCode}");
        print("   - Body: ${response.body}");

        print(" GET CUSTOMER DETAILS - FAILED (Server error)");
        print("=" * 50 + "\n");

        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'code': 'SERVER_ERROR',
        };
      }
    } catch (e) {
      print(" EXCEPTION IN GET CUSTOMER DETAILS:");
      print("   - Error: $e");
      print("   - Error type: ${e.runtimeType}");

      print(" GET CUSTOMER DETAILS - FAILED (Exception)");
      print("=" * 50 + "\n");

      return {
        'success': false,
        'message': 'Failed to connect: $e',
        'code': 'NETWORK_ERROR',
      };
    }
  }

  /* ------------------------- STORE CUSTOMER DATA ------------------------- */
  static Future<void> _storeCustomerData(Map<String, dynamic> customer) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('user_id', customer['id'] ?? 0);
      await prefs.setString('user_email', customer['email'] ?? '');
      await prefs.setString('user_firstName', customer['firstname'] ?? '');
      await prefs.setString('user_lastName', customer['lastname'] ?? '');
      await prefs.setString('user_phone', customer['phone_number'] ?? '');

      print(" Customer data stored successfully");
    } catch (e) {
      print(" Error storing customer data: $e");
    }
  }

  /*-------------------------- GET ADDRESSES ----------------------------------*/
  static Future<List<AddressModel>> getAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print(' No auth token found');
        return [];
      }

      final response = await http.get(
        Uri.parse('https://tawasul-dev.app-staging.fr/public/getaddresses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(' Address API Response Status: ${response.statusCode}');
      print(' Address API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final addressesData = responseData['addresses'];

          // Handle null or empty addresses
          if (addressesData == null || addressesData is! List) {
            print(' No addresses found or invalid format');
            return [];
          }

          // Convert to AddressModel list
          final List<AddressModel> addresses =
              addressesData.map<AddressModel>((addressJson) {
                return AddressModel.fromJson(addressJson);
              }).toList();

          print(' Loaded ${addresses.length} addresses');
          return addresses;
        } else {
          print(' API returned success: false - ${responseData['message']}');
          return [];
        }
      } else {
        print(' HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(' Exception in getAddresses: $e');
      return []; // Return empty list instead of throwing
    }
  }

/*-------------------------- SHIPPING LIST ----------------------------------*/
static Future<List<CarrierModel>> getShippingList(int cartId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print(' No auth token found');
      return [];
    }

    if (cartId == 0) {
      print(' Invalid cart ID: $cartId');
      return [];
    }

    final response = await http.get(
      Uri.parse('$baseUrl/public/getshippinglist?id_cart=$cartId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print(' Shipping API Response Status: ${response.statusCode}');
    print(' Shipping API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final carriersData = responseData['carriers'];

        if (carriersData == null || carriersData is! List) {
          print(' No carriers found or invalid format');
          return [];
        }

        final List<CarrierModel> carriers = carriersData
            .map<CarrierModel>((carrierJson) => CarrierModel.fromJson(carrierJson))
            .toList();

        print(' Loaded ${carriers.length} carriers for cart $cartId');
        return carriers;
      } else {
        print(' API returned success: false - ${responseData['message']}');
        return [];
      }
    } else {
      print(' HTTP Error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print(' Exception in getShippingList: $e');
    return [];
  }
}
/*-------------------------- SHIPPING LIST ----------------------------------*/
// static Future<List<CarrierModel>> getShippingList(int cartId) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       print(' No auth token found');
//       return [];
//     }

//     final response = await http.get(
//       Uri.parse('$baseUrl/public/getshippinglist?id_cart=$cartId'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     print(' Shipping API Response Status: ${response.statusCode}');
//     print(' Shipping API Response Body: ${response.body}');

//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);

//       if (responseData['success'] == true) {
//         final carriersData = responseData['carriers'];

//         // Handle null or empty carriers
//         if (carriersData == null || carriersData is! List) {
//           print(' No carriers found or invalid format');
//           return [];
//         }

//         // Convert to CarrierModel list
//         final List<CarrierModel> carriers = carriersData
//             .map<CarrierModel>((carrierJson) => CarrierModel.fromJson(carrierJson))
//             .toList();

//         print(' Loaded ${carriers.length} carriers');
//         return carriers;
//       } else {
//         print(' API returned success: false - ${responseData['message']}');
//         return [];
//       }
//     } else {
//       print(' HTTP Error: ${response.statusCode}');
//       return [];
//     }
//   } catch (e) {
//     print(' Exception in getShippingList: $e');
//     return [];
//   }
// }


  /* ------------------------- GET CUSTOMER ADDRESSES ------------------------- */
  static Future<Map<String, dynamic>> getCustomerAddresses() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Authentication token not found',
          'code': 'NO_TOKEN',
        };
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getaddresses'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print(" Addresses API Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> addressListJson = responseData['address'];

        if (responseData['success'] == true) {
          if (responseData['addresses'] != null) {
            await LocalAddressService.storeAddresses(responseData['addresses']);
          }

          return responseData;
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to get addresses',
            'code': 'API_ERROR',
          };
        }
      } else if (response.statusCode == 401) {
        await prefs.remove('auth_token');
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
          'code': 'AUTH_FAILED',
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'code': 'SERVER_ERROR',
        };
      }
    } catch (e) {
      print(" Error fetching addresses: $e");

      try {
        final localAddresses = await LocalAddressService.getLocalAddresses();
        return {
          'success': true,
          'addresses': localAddresses,
          'fromLocalStorage': true,
        };
      } catch (localError) {
        return {
          'success': false,
          'message': 'Failed to connect to server: $e',
          'code': 'NETWORK_ERROR',
        };
      }
    }
  }

  /* ------------------------- CREATE ADDRESS ------------------------- */
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      final int? customerId = prefs.getInt('user_id');

      print("CREATE ADDRESS - AUTH CHECK:");
      print("   - Token: ${token != null ? 'EXISTS' : 'NULL'}");
      print("   - Customer ID: $customerId");

      if (token == null || customerId == null) {
        return {
          'success': false,
          'message': 'Authentication required. Please login again.',
        };
      }

      // Build query parameters for the API
      final Map<String, String> queryParams = {
        'firstname': firstname,
        'lastname': lastname,
        'address1': address1,
        'city': city,
        'postcode': postcode,
        'id_state': idState.toString(),
      };

      // Add optional parameters
      if (phone != null && phone.isNotEmpty) queryParams['phone'] = phone;
      if (address2 != null && address2.isNotEmpty)
        queryParams['address2'] = address2;

      final Uri uri = Uri.parse(
        '$baseUrl/public/createaddress',
      ).replace(queryParameters: queryParams);

      print(" CREATE ADDRESS API CALL:");
      print("   - URL: $uri");
      print("   - Headers with Authorization: Bearer token");

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("CREATE ADDRESS RESPONSE:");
      print("   - Status Code: ${response.statusCode}");
      print("   - Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(" RESPONSE ANALYSIS:");
        print("   - Success: ${responseData['success']}");
        print("   - Message: ${responseData['message']}");
        print("   - ID Address: ${responseData['id_address']}");

        if (responseData['success'] == true) {
          final newAddressId = responseData['id_address'];
          print(" ADDRESS CREATED SUCCESSFULLY: $newAddressId");

          final addressData = {
            'id_address': newAddressId,
            'firstname': firstname,
            'lastname': lastname,
            'address1': address1,
            'address2': address2 ?? '',
            'city': city,
            'postcode': postcode,
            'id_state': idState,
            'phone': phone ?? '',
            'phone_mobile': phone ?? '',
            'country': 'Libya',
            'state': getStateNameById(idState),
          };

          await LocalAddressService.saveLocalAddress(addressData);

          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Address created successfully',
            'id_address': newAddressId,
            'address': responseData['address'],
          };
        } else {
          // API returned success: false - analyze why
          final errorMessage =
              responseData['message'] ?? 'Failed to create address';
          print(" API CREATION FAILED: $errorMessage");

          return {'success': false, 'message': errorMessage, 'api_error': true};
        }
      } else if (response.statusCode == 401) {
        print(" AUTHENTICATION FAILED - 401");
        await prefs.remove('auth_token');
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
          'auth_error': true,
        };
      } else {
        print(" SERVER ERROR: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'server_error': true,
        };
      }
    } catch (e) {
      print(" CREATE ADDRESS EXCEPTION: $e");

      // Fallback to local storage
      try {
        final addressData = {
          'firstname': firstname,
          'lastname': lastname,
          'address1': address1,
          'address2': address2 ?? '',
          'city': city,
          'postcode': postcode,
          'id_state': idState,
          'phone': phone ?? '',
          'alias': alias,
          'state': getStateNameById(idState),
        };

        final localResult = await LocalAddressService.saveLocalAddress(
          addressData,
        );

        if (localResult['success'] == true) {
          return {
            'success': true,
            'message': 'Address saved locally (offline mode)',
            'id_address': localResult['addressId'],
            'address': localResult['address'],
            'fromLocalStorage': true,
          };
        } else {
          return {
            'success': false,
            'message': 'Failed to create address locally: $e',
          };
        }
      } catch (localError) {
        return {'success': false, 'message': 'Failed to connect to server: $e'};
      }
    }
  }

  /* ------------------------- UPDATE ADDRESS ------------------------- */
  static Future<Map<String, dynamic>> updateAddress({
    required int idAddress,
    required String firstname,
    required String lastname,
    required String address1,
    required String city,
    required String postcode,
    required int idState,
    String? phone,
    String? address2,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null) {
        return {'success': false, 'message': 'Authentication token not found'};
      }

      // Build query parameters
      final Map<String, String> queryParams = {
        'id_address': idAddress.toString(),
        'firstname': firstname,
        'lastname': lastname,
        'address1': address1,
        'city': city,
        'postcode': postcode,
        'id_state': idState.toString(),
      };

      // Add optional parameters
      if (phone != null && phone.isNotEmpty) {
        queryParams['phone'] = phone;
      }
      if (address2 != null && address2.isNotEmpty) {
        queryParams['address2'] = address2;
      }

      final Uri uri = Uri.parse(
        '$baseUrl/public/updateaddressbyid',
      ).replace(queryParameters: queryParams);

      final response = await http
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Address updated successfully',
            'id_address': responseData['id_address'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to update address',
          };
        }
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" Error updating address: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /* ------------------------- GET ADDRESS BY ID ------------------------- */
  static Future<Map<String, dynamic>> getAddressById(int addressId) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getadressebyid?id_address=$addressId'),
            headers: headers,
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("Get address by ID response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Error getting address by ID: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /* ------------------------- DELETE ADDRESS ------------------------- */
  static Future<Map<String, dynamic>> deleteAddress(
    String addressIdentifier,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final addressId = int.tryParse(addressIdentifier);

      if (addressId == null) {
        return {'success': false, 'message': 'Invalid address ID'};
      }

      final response = await http
          .delete(
            Uri.parse('$baseUrl/public/deleteaddress?id_address=$addressId'),
            headers: headers,
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print("Delete address response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Error deleting address: $e");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  /* ------------------------- ADD ADDRESS ------------------------- */
  static Future<bool> addAddress(Map<String, dynamic> addressData) async {
    try {
      print("🔄 ADD ADDRESS - PROCESSING DATA:");
      print("   - Full address data: $addressData");

      // Extract and validate required fields
      final String firstname =
          addressData['firstname']?.toString().trim() ?? '';
      final String lastname = addressData['lastname']?.toString().trim() ?? '';
      final String address1 = addressData['address1']?.toString().trim() ?? '';
      final String city = addressData['city']?.toString().trim() ?? '';
      final String postcode = addressData['postcode']?.toString().trim() ?? '';

      // Handle idState - it could be String or int
      int idState = 0;
      if (addressData['id_state'] != null) {
        idState =
            addressData['id_state'] is int
                ? addressData['id_state']
                : int.tryParse(addressData['id_state'].toString()) ?? 0;
      } else if (addressData['idState'] != null) {
        idState =
            addressData['idState'] is int
                ? addressData['idState']
                : int.tryParse(addressData['idState'].toString()) ?? 0;
      }

      final String? phone = addressData['phone']?.toString().trim();
      final String? address2 = addressData['address2']?.toString().trim();

      print("📝 EXTRACTED ADDRESS DATA:");
      print("   - Firstname: '$firstname'");
      print("   - Lastname: '$lastname'");
      print("   - Address1: '$address1'");
      print("   - City: '$city'");
      print("   - Postcode: '$postcode'");
      print("   - ID State: $idState");
      print("   - Phone: '$phone'");
      print("   - Address2: '$address2'");

      // Validate required fields
      if (firstname.isEmpty) {
        print(" VALIDATION FAILED: Firstname is empty");
        return false;
      }
      if (lastname.isEmpty) {
        print(" VALIDATION FAILED: Lastname is empty");
        return false;
      }
      if (address1.isEmpty) {
        print(" VALIDATION FAILED: Address1 is empty");
        return false;
      }
      if (city.isEmpty) {
        print(" VALIDATION FAILED: City is empty");
        return false;
      }
      if (postcode.isEmpty) {
        print(" VALIDATION FAILED: Postcode is empty");
        return false;
      }
      if (idState == 0) {
        print(" VALIDATION FAILED: ID State is invalid");
        return false;
      }

      final result = await createAddress(
        firstname: firstname,
        lastname: lastname,
        address1: address1,
        city: city,
        postcode: postcode,
        idState: idState,
        phone: phone?.isNotEmpty == true ? phone : null,
        address2: address2?.isNotEmpty == true ? address2 : null,
      );

      print("📨 ADD ADDRESS RESULT:");
      print("   - Success: ${result['success']}");
      print("   - Message: ${result['message']}");

      return result['success'] == true;
    } catch (e) {
      print(" ERROR IN ADD ADDRESS: $e");
      return false;
    }
  }

  /*                           GET PRODUCT ATTRIBUTES                           */
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
      return productId;
    }
  }

  /* ------------------------- GET STATES ------------------------- */
  static Future<Map<String, dynamic>> getStates() async {
    try {
      // Return cached states if already loaded
      if (_statesLoaded && _statesList.isNotEmpty) {
        return {'success': true, 'states': _statesList};
      }

      print(" Loading states from API...");

      final response = await http
          .get(
            Uri.parse('$baseUrl/public/getstates'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeoutSeconds));

      print(" States API Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['states'] != null) {
          _statesList =
              (responseData['states'] as List)
                  .map((stateJson) => StateModel.fromJson(stateJson))
                  .toList();

          // Update mappings
          _updateStateMappings();

          // Store states locally for offline use
          await _storeStatesLocally(_statesList);

          _statesLoaded = true;

          print(" ${_statesList.length} states loaded successfully");

          return {'success': true, 'states': _statesList};
        } else {
          return {
            'success': false,
            'message': 'Invalid response format from states API',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(" Error loading states: $e");

      // Try to load from local storage
      try {
        final localStates = await _getStatesFromLocalStorage();
        if (localStates.isNotEmpty) {
          _statesList = localStates;
          _updateStateMappings();
          _statesLoaded = true;

          return {
            'success': true,
            'states': _statesList,
            'fromLocalStorage': true,
          };
        }
      } catch (localError) {
        print(" Error loading local states: $localError");
      }

      return {'success': false, 'message': 'Failed to load states: $e'};
    }
  }

  /* ------------------------- UPDATE STATE MAPPINGS ------------------------- */
  static void _updateStateMappings() {
    _stateIdToName.clear();
    _stateNameToId.clear();

    for (var state in _statesList) {
      _stateIdToName[state.idState] = state.name;
      _stateNameToId[state.name] = state.idState;
    }

    print("🗺️ State mappings updated: ${_stateIdToName.length} states");
  }

  /* ------------------------- GET STATE NAME BY ID ------------------------- */
  static String getStateNameById(int stateId) {
    return _stateIdToName[stateId] ?? 'Unknown State';
  }

  /* ------------------------- GET STATE ID BY NAME ------------------------- */
  static int? getStateIdByName(String stateName) {
    return _stateNameToId[stateName];
  }

  /* ------------------------- GET ALL STATES ------------------------- */
  static List<StateModel> getAllStates() {
    return _statesList;
  }

  /* ------------------------- STORE STATES LOCALLY ------------------------- */
  static Future<void> _storeStatesLocally(List<StateModel> states) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statesJson = states.map((state) => state.toJson()).toList();
      await prefs.setString('app_states', json.encode(statesJson));
      print(" ${states.length} states stored locally");
    } catch (e) {
      print(" Error storing states locally: $e");
    }
  }

  /* ------------------------- GET STATES FROM LOCAL STORAGE ------------------------- */
  static Future<List<StateModel>> _getStatesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statesJsonString = prefs.getString('app_states');

      if (statesJsonString != null) {
        final List<dynamic> statesJson = json.decode(statesJsonString);
        final states =
            statesJson.map((json) => StateModel.fromJson(json)).toList();
        print("📂 ${states.length} states loaded from local storage");
        return states;
      }
    } catch (e) {
      print(" Error loading states from local storage: $e");
    }

    return [];
  }

  /* ------------------------- INITIALIZE STATES ------------------------- */
  static Future<void> initializeStates() async {
    if (!_statesLoaded) {
      await getStates();
    }
  }

  static testApiConnection() {}

  static getFavoriteProducts() {}

  static toggleFavorite(int productId, bool isFavorite) {}

  /*----------------------- CREATE ADDRESS USER -----------------------------*/

  static Future<http.Response> createAddressUser({
    required String firstName,
    required String lastName,
    required String address1,
    String? address2,
    required String city,
    required String postCode,
    required int idState,
    String? phone,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/public/createaddress');

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      // Fixed parameter names based on your API documentation
      final Map<String, dynamic> body = {
        'firstname': firstName, // Fixed: was 'irstname'
        'lastname': lastName,
        'address1': address1,
        'address2': address2 ?? '', // Handle optional field
        'city': city,
        'postcode': postCode,
        'id_state': idState,
        'phone': phone ?? '', // Fixed: was 'pone'
      };

      // Remove null values from body
      body.removeWhere((key, value) => value == null || value == '');

      print('📤 Creating address with data: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return response;
    } catch (e) {
      print(' Error creating address: $e');
      // Return a response with error details
      return http.Response(
        jsonEncode({'success': false, 'message': 'Network error: $e'}),
        500, // status code
      );
    }
  }
}
  





  // //GET CART
  // static Future<Map<String, dynamic>> getCart() async {
  //   try {
  //     final response = await http
  //         .get(
  //           Uri.parse('$baseUrl/public/getcart'),
  //           headers: await _getAuthHeaders(),
  //         )
  //         .timeout(Duration(seconds: timeoutSeconds));

  //     print("getCart API response status: ${response.statusCode}");
  //     print("Response body: ${response.body}");

  //     // Handle redirects
  //     if (response.statusCode == 301 || response.statusCode == 302) {
  //       final location = response.headers['location'];
  //       print("Redirect detected to: $location");
  //       return {
  //         'success': false,
  //         'message': 'getcart endpoint redirected. Please check API URL.',
  //       };
  //     }

  //     if (response.statusCode == 200) {
  //       if (response.body.trim().startsWith('{') ||
  //           response.body.trim().startsWith('[')) {
  //         final Map<String, dynamic> responseData = json.decode(response.body);

  //         if (responseData['success'] == true) {
  //           print(" Cart fetched successfully");
  //           return {
  //             'success': true,
  //             'cart': responseData['cart'] ?? {},
  //             'products': responseData['products'] ?? [],
  //             'id_cart': responseData['id_cart'],
  //           };
  //         } else {
  //           return {
  //             'success': false,
  //             'message': responseData['message'] ?? 'Failed to fetch cart',
  //           };
  //         }
  //       } else {
  //         // HTML response
  //         print("✗ getcart returned HTML instead of JSON");
  //         return {
  //           'success': false,
  //           'message':
  //               'getcart endpoint returned HTML. Endpoint may not exist.',
  //         };
  //       }
  //     } else {
  //       return {
  //         'success': false,
  //         'message': 'Server error: ${response.statusCode}',
  //       };
  //     }
  //   } catch (e) {
  //     print("✗ Error fetching cart: $e");
  //     return {'success': false, 'message': 'Failed to connect to server: $e'};
  //   }
  // }





//   import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/Services/local_address_service.dart';
// import 'package:tawasul_application/model/cart_model.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/model/state_model..dart';
// import 'package:tawasul_application/model/category_model.dart';
// import 'package:tawasul_application/tools/language_manager.dart';

// class ApiService {
//   static const String baseUrl = "https://tawasul-dev.app-staging.fr";
//   static const int timeoutSeconds = 30;

//   static List<StateModel> _statesList = [];
//   static Map<int, String> _stateIdToName = {};
//   static Map<String, int> _stateNameToId = {};
//   static bool _statesLoaded = false;

//   static Future<String?> _getAuthToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       print(" TOKEN RETRIEVAL DEBUG:");
//       print("   - Token exists: ${token != null}");
//       print("   - Token length: ${token?.length ?? 0}");

//       if (token != null) {
//         if (token.isEmpty) {
//           print(" ERROR: Token is empty string");
//           return null;
//         }

//         if (token.contains('"') || token.contains("'")) {
//           print("  WARNING: Token may be wrapped in quotes");
//           final cleanedToken =
//               token.replaceAll('"', '').replaceAll("'", '').trim();
//           if (cleanedToken.isNotEmpty) {
//             // Update storage with cleaned token
//             await prefs.setString('auth_token', cleanedToken);
//             print(" Cleaned token stored");
//             return cleanedToken;
//           }
//         }

//         print(
//           "   - Token preview: ${token.substring(0, min(20, token.length))}...",
//         );
//         return token;
//       }

//       print(" No token found in SharedPreferences");
//       return null;
//     } catch (e) {
//       print(" Error retrieving token: $e");
//       return null;
//     }
//   }

//   static Future<Map<String, String>> _getAuthHeaders() async {
//     try {
//       final token = await _getAuthToken();
//       final prefs = await SharedPreferences.getInstance();
//       final language = prefs.getString('language') ?? 'en';

//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Accept-Language': language,
//       };

//       if (token != null && token.isNotEmpty) {
//         headers['Authorization'] =
//             token.startsWith('Bearer ') ? token : 'Bearer $token';
//         print(" Authorization header added with token");
//       } else {
//         print(" No token available for Authorization header");
//       }

//       return headers;
//     } catch (e) {
//       print(" Error creating auth headers: $e");
//       return {'Content-Type': 'application/json', 'Accept': 'application/json'};
//     }
//   }

//   /* ------------------------- LOGIN  ------------------------- */
//   static Future<Map<String, dynamic>> login(
//     String email,
//     String password,
//   ) async {
//     try {
//       print(" STARTING LOGIN PROCESS");
//       print("📧 Email: $email");

//       var request = await http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/public/login'),
//       );

//       request.fields['email'] = email.trim();
//       request.fields['password'] = password.trim();
//       request.headers['Accept'] = 'application/json';

//       print(" Making API call to: $baseUrl/public/login");

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print("Response Status Code: ${response.statusCode}");

//       if (response.body.isEmpty) {
//         return {'success': false, 'message': 'Empty response from server'};
//       }

//       Map<String, dynamic> responseData;
//       try {
//         responseData = jsonDecode(response.body);
//         print(" Successfully parsed JSON response");
//       } catch (e) {
//         print(" Failed to parse JSON: $e");
//         return {
//           'success': false,
//           'message': 'Invalid response format from server: $e',
//         };
//       }

//       // In the login success section, after storing the token:
//       if (responseData['success'] == true && responseData['token'] != null) {
//         print("LOGIN SUCCESSFUL WITH TOKEN!");

//         final token = responseData['token']!.trim();
//         print("Raw token received: ${token.length} chars");

//         // Store in SharedPreferences
//         final prefs = await SharedPreferences.getInstance();

//         // Clear any existing tokens first
//         await prefs.remove('auth_token');
//         await prefs.setString('auth_token', token);

//         // Store user ID
//         if (responseData['id_customer'] != null) {
//           await prefs.setInt('user_id', responseData['id_customer']);
//         }

//         // IMMEDIATE VERIFICATION
//         await Future.delayed(Duration(milliseconds: 100)); // Let storage commit
//         final storedToken = prefs.getString('auth_token');

//         print(" STORAGE VERIFICATION:");
//         print("   - Token stored successfully: ${storedToken != null}");
//         print(
//           "   - Token length matches: ${storedToken?.length == token.length}",
//         );
//         print("   - Token value matches: ${storedToken == token}");

//         if (storedToken == null) {
//           print(" CRITICAL: Token storage failed!");
//           // Try alternative storage method
//           await prefs.setString('auth_token', token);
//           final retryToken = prefs.getString('auth_token');
//           print("   - Retry result: ${retryToken != null}");
//         }

//         return {'success': true, 'token': token, 'message': 'Login successful'};
//       } else {
//         print(" HTTP Error: ${response.statusCode}");
//         return {
//           'success': false,
//           'message':
//               responseData['message'] ?? 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" Login exception: $e");
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   /*                           VERIFY PASSWORD                                            */
//   static Future<Map<String, dynamic>> verifyPassword(String email) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/public/verifypassword'),
//       );
//       request.fields['email'] = email;

//       print('Sending request to: $baseUrl/verifypassword');
//       print('With email: $email');

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseData');

//       // Check if response is JSON or HTML
//       if (responseData.trim().startsWith('{') ||
//           responseData.trim().startsWith('[')) {
//         // It's JSON
//         var jsonResponse = json.decode(responseData);
//         return jsonResponse;
//       } else {
//         // It's HTML or other content
//         return {
//           'success': false,
//           'message':
//               'Server returned HTML error. Please check the API endpoint.',
//           'statusCode': response.statusCode,
//           'error':
//               'HTML Response: ${responseData.length > 100 ? responseData.substring(0, 100) + '...' : responseData}',
//         };
//       }
//     } catch (e) {
//       print('Error in verifyPassword: $e');
//       return {'success': false, 'message': 'Network error: $e'};
//     }
//   }

//   /*                                           RESET PASSWORD                                                   */
//   static Future<Map<String, dynamic>> resetPassword({
//     required String email,
//     required String password,
//     required String code,
//     required String confirmPassword,
//   }) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/public/resetpassword'),
//       );
//       request.fields['email'] = email;
//       request.fields['password'] = password;
//       request.fields['code'] = code;
//       request.fields['confirm password'] = confirmPassword;

//       print('Sending request to: $baseUrl/public/resetpassword');

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseData');

//       // Check if response is JSON or HTML
//       if (responseData.trim().startsWith('{') ||
//           responseData.trim().startsWith('[')) {
//         // It's JSON
//         var jsonResponse = json.decode(responseData);
//         return jsonResponse;
//       } else {
//         return {
//           'success': false,
//           'message':
//               'Server returned HTML error. Please check the API endpoint.',
//           'statusCode': response.statusCode,
//           'error': 'HTML Response',
//         };
//       }
//     } catch (e) {
//       print('Error in resetPassword: $e');
//       return {'success': false, 'message': 'Network error: $e'};
//     }
//   }

//   /* ------------------------- CART OPERATIONS ------------------------- */

//   static Future<Map<String, dynamic>> createOrGetCart() async {
//     try {
//       final response = await http
//           .get(Uri.parse('$baseUrl/public/getproductcart'))
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" createOrGetCart response: ${response.statusCode}");
//       print(" Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['success'] == true && data['id_cart'] != null) {
//           return {
//             'success': true,
//             'id_cart': data['id_cart'].toString(),
//             'message': 'Cart retrieved successfully',
//           };
//         } else {
//           // Try to create a new cart by adding a product
//           return await _createNewCart();
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'HTTP error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" createOrGetCart error: $e");
//       return {'success': false, 'message': 'Failed to create/get cart: $e'};
//     }
//   }

//   static Future<Map<String, dynamic>> _createNewCart() async {
//     try {
//       final result = await addToCart(
//         cartId: null,
//         productId: '1',
//         quantity: 1,
//         productAttributeId: '0',
//       );

//       if (result == true) {
//         final cartResponse = await getCart();
//         if (cartResponse['success'] == true &&
//             cartResponse['id_cart'] != null) {
//           return {
//             'success': true,
//             'id_cart': cartResponse['id_cart'].toString(),
//             'message': 'New cart created successfully',
//           };
//         }
//       }

//       return {'success': false, 'message': 'Failed to create new cart'};
//     } catch (e) {
//       return {'success': false, 'message': 'Failed to create cart: $e'};
//     }
//   }

//   // static Future<Map<String, dynamic>> getCart() async {
//   //   try {
//   //     final response = await http
//   //         .get(
//   //           Uri.parse('$baseUrl/public/getproductcart'),
//   //           headers: await _getAuthHeaders(),
//   //         )
//   //         .timeout(Duration(seconds: timeoutSeconds));

//   //     print(" getCart API response status: ${response.statusCode}");
//   //     print(" Response body: ${response.body}");

//   //     if (response.statusCode == 200) {
//   //       if (response.body.trim().startsWith('{') ||
//   //           response.body.trim().startsWith('[')) {
//   //         final Map<String, dynamic> responseData = json.decode(response.body);

//   //         if (responseData['success'] == true) {
//   //           print(" Cart fetched successfully");
//   //           print(" Cart ID from response: ${responseData['id_cart']}");
//   //           print(
//   //             " Products count: ${(responseData['products'] ?? []).length}",
//   //           );

//   //           return {
//   //             'success': true,
//   //             'cart': responseData['cart'] ?? {},
//   //             'products': responseData['products'] ?? [],
//   //             'id_cart': responseData['id_cart']?.toString() ?? '',
//   //           };
//   //         } else {
//   //           return {
//   //             'success': false,
//   //             'message': responseData['message'] ?? 'Failed to fetch cart',
//   //           };
//   //         }
//   //       } else {
//   //         return {
//   //           'success': false,
//   //           'message': 'getcart endpoint returned HTML.',
//   //         };
//   //       }
//   //     } else {
//   //       return {
//   //         'success': false,
//   //         'message': 'Server error: ${response.statusCode}',
//   //       };
//   //     }
//   //   } catch (e) {
//   //     print(" Error fetching cart: $e");
//   //     return {'success': false, 'message': 'Failed to connect to server: $e'};
//   //   }
//   // }
//   static Future<Map<String, dynamic>> getCart({String? cartId}) async {
//     try {
//       // If no cartId provided, we can't call this endpoint
//       if (cartId == null || cartId.isEmpty) {
//         return {
//           'success': false,
//           'message': 'Cart ID is required for getcart endpoint',
//         };
//       }

//       final uri = Uri.parse(
//         '$baseUrl/public/getcart',
//       ).replace(queryParameters: {'id_cart': cartId});

//       final response = await http
//           .get(uri, headers: await _getAuthHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" getCart API response status: ${response.statusCode}");
//       print(" Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           print(" Cart fetched successfully");
//           print(" Cart ID: ${responseData['id_cart']}");
//           print(" Products count: ${(responseData['products'] ?? []).length}");

//           return {
//             'success': true,
//             'cart': responseData['cart'] ?? {},
//             'products': responseData['products'] ?? [],
//             'id_cart': responseData['id_cart']?.toString() ?? cartId,
//           };
//         } else {
//           return {
//             'success': false,
//             'message': responseData['message'] ?? 'Failed to fetch cart',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" Error fetching cart: $e");
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   //CREATE CART
//   static Future<bool> createCart({
//     required String productId,
//     required int quantity,
//     String? productAttributeId,
//   }) async {
//     try {
//       final headers = await _getAuthHeaders();

//       print(" Create new cart");

//       final params = {
//         'id_product': productId,
//         'id_product_attribute': productAttributeId ?? '0',
//         'qty': quantity.toString(),
//       };

//       final uri = Uri.parse(
//         '$baseUrl/public/updatecart',
//       ).replace(queryParameters: params);

//       print(" API URL: ${uri.toString()}");

//       final response = await http.get(uri, headers: headers);

//       print(" Add to cart response status: ${response.statusCode}");
//       print(" Add to cart response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           print(" Product added to cart successfully");
//           return true;
//         } else {
//           throw Exception('API error: ${data['message'] ?? 'Unknown error'}');
//         }
//       } else {
//         throw Exception(
//           'HTTP error: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } catch (e) {
//       print(" Add to cart error: $e");
//       rethrow;
//     }
//   }

//   //ADD TO CART
//   static Future<Map<String, dynamic>> addToCart({
//     String? cartId = '',
//     required String productId,
//     required int quantity,
//     String? productAttributeId,
//   }) async {
//     try {
//       // Create headers WITHOUT token
//       final Map<String, String> headers = {'Accept': 'application/json'};

//       print(" Adding product to cart:");
//       print("   - Cart ID: $cartId");
//       print("   - Product ID: $productId");
//       print("   - Attribute ID: ${productAttributeId ?? '0'}");
//       print("   - Quantity: $quantity");

//       final params = {
//         'id_cart': cartId ?? '',
//         'id_product': '1921',
//         'id_product_attribute': '30047',
//         'qty': quantity.toString(),
//       };

//       final uri = Uri.parse('$baseUrl/public/updatecart');

//       print(" Making POST request to: $uri");
//       print(" Parameters: $params");

//       final response = await http.post(uri, headers: headers, body: params);

//       print(" Response status: ${response.statusCode}");
//       print(" Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           print(" Product added to cart successfully");
//           print(" Cart ID from response: ${data['id_cart']}");

//           return {
//             'success': true,
//             'id_cart': data['id_cart']?.toString(),
//             'message': 'Product added to cart successfully',
//           };
//         } else {
//           print(" API error: ${data['message'] ?? 'Unknown error'}");
//           return {
//             'success': false,
//             'message': data['message'] ?? 'Failed to add product to cart',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'HTTP error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" Add to cart error: $e");
//       return {'success': false, 'message': 'Failed to add product to cart: $e'};
//     }
//   }

//   //GET CART BY ID
//   static Future<CartResponse> getCartById(String cartId) async {
//     try {
//       // print(" Getting cart by ID: $cartId");

//       // Create headers WITHOUT token
//       final Map<String, String> headers = {'Accept': 'application/json'};

//       final uri = Uri.parse('$baseUrl/public/getproductcart');
//       // .replace(queryParameters: {'id_cart': 11347});

//       print(" API URL: ${uri.toString()}");
//       final response = await http.get(uri, headers: headers);

//       print(" Get cart response status: ${response.statusCode}");
//       print(" Get cart response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           final cartResponse = CartResponse.fromJson(data);
//           print(" Cart retrieved successfully:");
//           // print("   - Cart ID: ${cartResponse.idCart}");
//           print("   - Products count: ${cartResponse.products.length}");
//           return cartResponse;
//         } else {
//           throw Exception('API error: ${data['message'] ?? 'Unknown error'}');
//         }
//       } else {
//         throw Exception(
//           'HTTP error: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } catch (e) {
//       print(" Get cart by ID error: $e");
//       rethrow;
//     }
//   }

//  Future<List<CartResponse>> fetchMyData() async {
//   final response = await http.get(Uri.parse('$baseUrl/public/getproductcart')); 

//   if (response.statusCode == 200) {
//     final dynamic jsonData = jsonDecode(response.body);
    
//     if (jsonData is List<dynamic>) {
//       return jsonData.map((json) => CartResponse.fromJson(json)).toList();
//     } else if (jsonData is Map<String, dynamic>) {
//       return [CartResponse.fromJson(jsonData)];
//     } else {
//       throw Exception('Unexpected response format');
//     }
//   } else {
//     throw Exception('Failed to load data: ${response.statusCode}');
//   }
// }

//   // static Future<bool> addToCart({
//   //   String? cartId = '',
//   //   required String productId,
//   //   required int quantity,
//   //   String? productAttributeId,
//   // }) async {
//   //   try {
//   //     // Create headers WITHOUT token
//   //     final Map<String, String> headers = {'Accept': 'application/json'};

//   //     print(" Adding product to cart:");
//   //     print("   - Cart ID: $cartId");
//   //     print("   - Product ID: $productId");
//   //     print("   - Attribute ID: ${productAttributeId ?? '0'}");
//   //     print("   - Quantity: $quantity");

//   //     final params = {
//   //       'id_cart': cartId ?? '',
//   //       'id_product': productId,
//   //       'id_product_attribute': productAttributeId ?? '0',
//   //       'qty': quantity.toString(),
//   //     };

//   //     final uri = Uri.parse('$baseUrl/public/updatecart');

//   //     print(" Making POST request to: $uri");
//   //     print(" Parameters: $params");

//   //     final response = await http.post(uri, headers: headers, body: params);

//   //     print(" Response status: ${response.statusCode}");
//   //     print(" Response body: ${response.body}");

//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       if (data['success'] == true) {
//   //         print(" Product added to cart successfully");
//   //         return true;
//   //       } else {
//   //         print(" API error: ${data['message'] ?? 'Unknown error'}");
//   //         throw Exception(data['message'] ?? 'Failed to add product to cart');
//   //       }
//   //     } else {
//   //       throw Exception(
//   //         'HTTP error: ${response.statusCode} - ${response.body}',
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print(" Add to cart error: $e");
//   //     rethrow;
//   //   }
//   // }

//   // static Future<CartResponse> getCartById(String cartId) async {
//   //   try {
//   //     print(" Getting cart by ID: $cartId");
//   //     final headers = await _getAuthHeaders();
//   //     final uri = Uri.parse(
//   //       '$baseUrl/public/getproductcart',
//   //     ).replace(queryParameters: {'id_cart': cartId});
//   //     print(" API URL: ${uri.toString()}");
//   //     final response = await http.get(uri, headers: headers);
//   //     print(" Get cart response status: ${response.statusCode}");
//   //     print(" Get cart response body: ${response.body}");
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       if (data['success'] == true) {
//   //         final cartResponse = CartResponse.fromJson(data);
//   //         print(" Cart retrieved successfully:");
//   //         print("   - Cart ID: ${cartResponse.idCart}");
//   //         print("   - Products count: ${cartResponse.products.length}");
//   //         print("   - Total items: ${cartResponse.totalItems}");
//   //         print("   - Total price: ${cartResponse.totalPrice}");
//   //         return cartResponse;
//   //       } else {
//   //         throw Exception('API error: ${data['message'] ?? 'Unknown error'}');
//   //       }
//   //     } else {
//   //       throw Exception(
//   //         'HTTP error: ${response.statusCode} - ${response.body}',
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print(" Get cart by ID error: $e");
//   //     rethrow;
//   //   }
//   // }

//   // DELETE PRODUCT FROM CART
//   static Future<Map<String, dynamic>> deleteProductCart({
//     required int idCart,
//     required int productId,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/public/deleteproductcart').replace(
//         queryParameters: {
//           'id_cart': idCart.toString(),
//           'id_product': productId.toString(),
//         },
//       );
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to delete product: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Delete product cart API error: $e');
//       rethrow;
//     }
//   }

//   /*                           GET ALL CATEGORIES (UPDATED)                                          */
//   static Future<List<Category>> getCategories() async {
//     try {
//       final response = await http
//           .get(Uri.parse('$baseUrl/public/categories'))
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("Categories API response status: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['success'] == true) {
//           final List<dynamic> categoriesJson = data['categories'];
//           print("Found ${categoriesJson.length} root categories");

//           // Parse each category
//           final List<Category> categories = [];
//           for (var categoryJson in categoriesJson) {
//             if (categoryJson is Map<String, dynamic>) {
//               try {
//                 final category = Category.fromJson(categoryJson);
//                 categories.add(category);
//               } catch (e) {
//                 print("Error parsing category: $e");
//                 print("Problematic category JSON: $categoryJson");
//               }
//             }
//           }

//           // Debug: Print category tree
//           print("=== CATEGORY TREE ===");
//           for (var category in categories) {
//             category.printTree();
//           }
//           print("=====================");

//           return categories;
//         } else {
//           print("API returned success: false for categories");
//         }
//       } else {
//         print(
//           "Categories API error: ${response.statusCode} - ${response.body}",
//         );
//       }
//       return [];
//     } catch (e) {
//       print('Error fetching categories: $e');
//       return [];
//     }
//   }

//   /*                            GET PRODUCTS BY CATEGORY CODE                                       */
//   static Future<List<Product>> getProductsByCategoryCode(
//     int categoryCode,
//   ) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getproducts?code=$categoryCode'),
//         headers: await _getAuthHeaders(),
//       );

//       print(
//         "Products API Response for category $categoryCode: ${response.statusCode}",
//       );
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['success'] == true) {
//           final products = jsonResponse['products'] as List;
//           print("Found ${products.length} products for category $categoryCode");

//           for (var product in products) {
//             print(
//               "Product: ${product['name']}, Brand: ${product['manufacturer']}, Price: ${product['price']}, Image: ${product['image']}",
//             );
//           }

//           return products
//               .map((productJson) => Product.fromJson(productJson))
//               .toList();
//         } else {
//           print("API returned success: false for category $categoryCode");
//         }
//       } else {
//         print("Products API error: ${response.statusCode} - ${response.body}");
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching products for category $categoryCode: $e");
//       return [];
//     }
//   }

//   /*                     GET CATEGORY ID BY  NAME                                   */
//   static Future<int?> getCategoryIdByName(String categoryName) async {
//     try {
//       final categories = await getCategories();
//       print("Searching for category: $categoryName");

//       // Recursive function to search through all categories and subcategories
//       int? findCategoryId(List<Category> categories, String name) {
//         for (var category in categories) {
//           print("Checking category: ${category.name} (ID: ${category.id})");

//           // Check if this category matches
//           if (category.name.toLowerCase() == name.toLowerCase()) {
//             print(" Found category: ${category.name} with ID: ${category.id}");
//             return category.id;
//           }

//           // Recursively search in children
//           if (category.children.isNotEmpty) {
//             final childId = findCategoryId(category.children, name);
//             if (childId != null) return childId;
//           }
//         }
//         return null;
//       }

//       final categoryId = findCategoryId(categories, categoryName);

//       if (categoryId == null) {
//         print(" Category '$categoryName' not found!");
//         // Debug: print all available categories
//         print("=== AVAILABLE CATEGORIES ===");
//         void printCategories(List<Category> cats, [String indent = ""]) {
//           for (var cat in cats) {
//             print("$indent${cat.name} (ID: ${cat.id})");
//             if (cat.children.isNotEmpty) {
//               printCategories(cat.children, "$indent  ");
//             }
//           }
//         }

//         printCategories(categories);
//         print("============================");
//       }

//       return categoryId;
//     } catch (e) {
//       print("Error finding category ID for '$categoryName': $e");
//       return null;
//     }
//   }

//   /*                             GET PRODUCTS BY CATEGORY NAME                           */
//   static Future<List<Product>> getProductsByCategoryName(
//     String categoryName,
//   ) async {
//     try {
//       // First, get all categories to find the ID
//       final categories = await getCategories();

//       // Find the category by name (case-insensitive)
//       final category = categories.firstWhere(
//         (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
//         orElse: () => Category(id: 0, name: '', children: []),
//       );

//       if (category.id == 0) {
//         print("Category '$categoryName' not found");
//         return [];
//       }

//       // Get all subcategory IDs including the main category
//       final categoryIds = category.getAllCategoryIds();

//       // Fetch products for all these category IDs
//       List<Product> allProducts = [];

//       for (int categoryId in categoryIds) {
//         try {
//           final products = await getProductsByCategory(categoryId.toString());
//           allProducts.addAll(products);
//         } catch (e) {
//           print("Error fetching products for category $categoryId: $e");
//         }
//       }

//       final uniqueProducts =
//           allProducts
//               .fold<Map<int, Product>>({}, (map, product) {
//                 map[product.idProduct] = product;
//                 return map;
//               })
//               .values
//               .toList();

//       return uniqueProducts;
//     } catch (e) {
//       print("Error in getProductsByCategoryName: $e");
//       throw e;
//     }
//   }

//   //  get products by category ID
//   static Future<List<Product>> getProductsByCategory(
//     String categoryCode,
//   ) async {
//     try {
//       //final int languageId = await LanguageManager.getCurrentLanguageId();
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getproducts?code=$categoryCode'),
//         headers: await _getAuthHeaders(),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['success'] == true) {
//           final products = jsonResponse['products'] as List;
//           return products
//               .map((productJson) => Product.fromJson(productJson))
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching products for category $categoryCode: $e");
//       return [];
//     }
//   }

//   /*                           GET PRODUCTS BY CATEGORY ID                                            */
//   static Future<List<Product>> getProductsByCategoryIdTest(
//     int categoryId,
//   ) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getproducts?code=$categoryId'),
//       );

//       print("Test API Response: ${response.statusCode}");
//       print("Test API Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['success'] == true) {
//           final products = jsonResponse['products'] as List;
//           return products
//               .map((productJson) => Product.fromJson(productJson))
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       print("Test Error: $e");
//       return [];
//     }
//   }

//   /*                           GET CATEGORY BY NAME                                          */
//   static Future<Category?> getCategoryByName(String categoryName) async {
//     final categories = await getCategories();
//     return categories.firstWhere(
//       (Category) => Category.name.toLowerCase() == categoryName.toLowerCase(),
//       orElse: () => Category(id: 0, name: '', children: []),
//     );
//   }

//   /*                          DEBUG CATEGORIES                                                */
//   static Future<void> debugCategories() async {
//     try {
//       final categories = await getCategories();
//       print("=== AVAILABLE CATEGORIES ===");
//       for (var category in categories) {
//         print("${category.name} (ID: ${category.id})");
//         if (category.children.isNotEmpty) {
//           for (var child in category.children) {
//             print("  └─ ${child.name} (ID: ${child.id})");
//           }
//         }
//       }
//       print("============================");
//     } catch (e) {
//       print("Error debugging categories: $e");
//     }
//   }

//   /*                           GET NEWEST PRODUCTS (Sorted by date_add)                                          */
//   static Future<List<Product>> getNewestProducts({
//     int numberOfProducts = 10,
//     String orderBy = 'date_add',
//     String orderSens = 'desc',
//   }) async {
//     try {
//       final Map<String, String> queryParams = {
//         'order_by': orderBy,
//         'order_sens': orderSens,
//         'nombre_products': numberOfProducts.toString(),
//       };

//       // Remove empty parameters
//       queryParams.removeWhere((key, value) => value.isEmpty);

//       final Uri uri = Uri.parse(
//         '$baseUrl/public/getproducts',
//       ).replace(queryParameters: queryParams);

//       print("Fetching newest products from: $uri");

//       final response = await http
//           .get(uri, headers: await _getAuthHeaders())
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("Newest products API response status: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['success'] == true) {
//           final List<dynamic> productsJson = data['products'];
//           print("Found ${productsJson.length} newest products");

//           // Debug: Print first product to verify date sorting
//           if (productsJson.isNotEmpty) {
//             print("First product: ${productsJson.first['name']}");
//             if (productsJson.first.containsKey('date_add')) {
//               print("Date added: ${productsJson.first['date_add']}");
//             }
//           }

//           return productsJson.map((json) => Product.fromJson(json)).toList();
//         } else {
//           print("API returned success: false for newest products");
//           print("Error message: ${data['error']}");
//         }
//       } else {
//         print(
//           "Newest products API error: ${response.statusCode} - ${response.body}",
//         );
//       }
//       return [];
//     } catch (e) {
//       print('Error fetching newest products: $e');
//       return [];
//     }
//   }

//   /*                           GET CATEGORY CODE BY NAME                          */
//   static Future<String> getCategoryCodeByName(String categoryName) async {
//     try {
//       final categories = await getCategories();

//       // Recursive function to search through all categories and subcategories
//       String? findCategoryCode(List<Category> categories, String name) {
//         for (var category in categories) {
//           // Check if this category matches
//           if (category.name.toLowerCase() == name.toLowerCase()) {
//             return category.id.toString();
//           }

//           // Recursively search in children
//           if (category.children.isNotEmpty) {
//             final childCode = findCategoryCode(category.children, name);
//             if (childCode != null) return childCode;
//           }
//         }
//         return null;
//       }

//       final categoryCode = findCategoryCode(categories, categoryName);

//       if (categoryCode == null) {
//         print("Category '$categoryName' not found!");
//         return '';
//       }

//       return categoryCode;
//     } catch (e) {
//       print("Error finding category code for '$categoryName': $e");
//       return '';
//     }
//   }

//   static Future<List<Product>> getRandomProductsFromCategories({
//     int numberOfProducts = 20,
//     String shopId = '4',
//   }) async {
//     try {
//       print(" Fetching random products from categories...");
//       print(" Target: $numberOfProducts products");

//       // First, get all categories
//       final categories = await getCategories();
//       print(" Found ${categories.length} total categories");

//       // Get all category IDs (including subcategories)
//       final allCategoryIds = <int>[];
//       void collectCategoryIds(List<Category> categoryList) {
//         for (var category in categoryList) {
//           allCategoryIds.add(category.id);
//           if (category.children.isNotEmpty) {
//             collectCategoryIds(category.children);
//           }
//         }
//       }

//       collectCategoryIds(categories);

//       print(" Available category IDs: ${allCategoryIds.length}");

//       if (allCategoryIds.isEmpty) {
//         print(" No categories found!");
//         return [];
//       }

//       // Shuffle the category IDs to get random order
//       allCategoryIds.shuffle();

//       // ADDED: Track processed categories to avoid infinite loops
//       final processedCategories = <int>{};
//       List<Product> allProducts = [];
//       int productsNeeded = numberOfProducts;
//       int maxIterations = allCategoryIds.length * 2; // Safety limit
//       int currentIteration = 0;

//       // Fetch products from random categories until we have enough products
//       for (int categoryId in allCategoryIds) {
//         // ADDED: Multiple safety checks
//         if (productsNeeded <= 0 ||
//             currentIteration >= maxIterations ||
//             processedCategories.contains(categoryId)) {
//           break;
//         }

//         processedCategories.add(categoryId);
//         currentIteration++;

//         try {
//           print(" Fetching products from category ID: $categoryId");
//           final products = await getProductsByCategoryCode(categoryId);

//           if (products.isNotEmpty) {
//             // Shuffle products from this category and take what we need
//             final shuffledProducts = List<Product>.from(products)..shuffle();
//             final productsToTake =
//                 shuffledProducts.take(productsNeeded).toList();
//             allProducts.addAll(productsToTake);
//             productsNeeded -= productsToTake.length;

//             print(
//               "Added ${productsToTake.length} products from category $categoryId",
//             );
//             print(" Still need $productsNeeded more products");

//             // ADDED: Break immediately if we have enough
//             if (productsNeeded <= 0) {
//               print(" Reached target product count!");
//               break;
//             }
//           } else {
//             print("No products found in category $categoryId");
//           }
//         } catch (e) {
//           print(" Error fetching products from category $categoryId: $e");
//           // Continue with next category
//         }

//         // Small delay to avoid overwhelming the API
//         await Future.delayed(Duration(milliseconds: 100));
//       }

//       // Final shuffle to mix products from different categories
//       allProducts.shuffle();

//       print("🎊 Final result: ${allProducts.length} random products");

//       // ADDED: Safety check - if we have too many, trim the list
//       if (allProducts.length > numberOfProducts) {
//         allProducts = allProducts.take(numberOfProducts).toList();
//         print("✂️ Trimmed to exact target: ${allProducts.length} products");
//       }

//       return allProducts;
//     } catch (e) {
//       print(' Error fetching random products from categories: $e');
//       return [];
//     }
//   }

//   /*                           GET PRODUCTS FROM MULTIPLE CATEGORIES                       */
//   static Future<List<Product>> getProductsFromMultipleCategories(
//     List<int> categoryIds,
//   ) async {
//     try {
//       List<Product> allProducts = [];

//       for (int categoryId in categoryIds) {
//         try {
//           final products = await getProductsByCategoryCode(categoryId);
//           allProducts.addAll(products);
//           print("Added ${products.length} products from category $categoryId");
//         } catch (e) {
//           print("Error fetching from category $categoryId: $e");
//         }
//       }

//       // Shuffle the final list
//       allProducts.shuffle();

//       return allProducts;
//     } catch (e) {
//       print('Error fetching products from multiple categories: $e');
//       return [];
//     }
//   }

//   static Future<Map<String, dynamic>?> getProductDetail({
//     required int productId,
//   }) async {
//     try {
//       final int languageId = await LanguageManager.getCurrentLanguageId();
//       final response = await http
//           .get(
//             Uri.parse(
//               '$baseUrl/public/getproductdetail?id_product=$productId&id_lang_app=$languageId',
//             ),
//             headers: await _getAuthHeaders(),
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" Product detail API response status: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['success'] == true && data['product'] != null) {
//           final productData = data['product'];

//           // ENHANCED DEBUG: Print all combination data
//           if (productData['combinations'] != null) {
//             final combos = productData['combinations'] as List;
//             print(" Raw combinations from API: ${combos.length}");

//             for (var i = 0; i < combos.length; i++) {
//               final combo = combos[i];
//               final attributes = combo['attributes']?.toString() ?? '';
//               final colorCode = combo['color']?.toString() ?? '';
//               final stock = combo['quantity'] ?? combo['stock'] ?? 0;

//               print(
//                 "   [$i] ID: ${combo['id_product_attribute']}, "
//                 "Attributes: '$attributes', "
//                 "Color: '$colorCode', "
//                 "Stock: $stock, "
//                 "Default: ${combo['default']}",
//               );
//             }
//           }

//           return data;
//         } else {
//           print(" API returned success: false for product detail");
//         }
//       } else {
//         print(" Product detail API error: ${response.statusCode}");
//       }
//       return null;
//     } catch (e) {
//       print(' Error fetching product detail: $e');
//       return null;
//     }
//   }

//   /*                           GET SIMILAR PRODUCTS BY CATEGORY ID                          */
//   static Future<List<Product>> getSimilarProductsByCategory({
//     required int categoryId,
//     required int excludeProductId,
//     int limit = 10,
//   }) async {
//     try {
//       print(
//         "Fetching similar products for category ID: $categoryId, excluding product: $excludeProductId",
//       );

//       // First, get all categories to find the category hierarchy
//       final categories = await getCategories();

//       // Find all related category IDs (including parent and children)
//       final relatedCategoryIds = _getRelatedCategoryIds(categories, categoryId);

//       if (relatedCategoryIds.isEmpty) {
//         print("No related categories found for ID: $categoryId");

//         // Fallback: try to get products from any category (random products)
//         print("Using fallback: fetching random products");
//         return await getRandomProductsFromCategories(numberOfProducts: limit);
//       }

//       print("Related category IDs: $relatedCategoryIds");

//       List<Product> allSimilarProducts = [];

//       // Fetch products from all related categories
//       for (int catId in relatedCategoryIds) {
//         try {
//           final products = await getProductsByCategoryCode(catId);
//           final filteredProducts =
//               products
//                   .where((product) => product.idProduct != excludeProductId)
//                   .toList();
//           allSimilarProducts.addAll(filteredProducts);

//           print("Found ${filteredProducts.length} products in category $catId");

//           if (allSimilarProducts.length >= limit) {
//             break;
//           }
//         } catch (e) {
//           print("Error fetching products from category $catId: $e");
//         }
//       }
//       final uniqueProducts =
//           allSimilarProducts
//               .fold<Map<int, Product>>({}, (map, product) {
//                 if (!map.containsKey(product.idProduct)) {
//                   map[product.idProduct] = product;
//                 }
//                 return map;
//               })
//               .values
//               .toList();

//       final result = uniqueProducts.take(limit).toList();
//       print(" Found ${result.length} similar products");

//       return result;
//     } catch (e) {
//       print('Error fetching similar products: $e');
//       return [];
//     }
//   }

//   /*                           GET RELATED CATEGORY IDs (including parent and children)     */
//   static List<int> _getRelatedCategoryIds(
//     List<Category> categories,
//     int targetCategoryId,
//   ) {
//     final List<int> relatedIds = [];

//     // First, declare the helper functions
//     void _addAllChildrenIds(Category category, List<int> idList) {
//       for (var child in category.children) {
//         idList.add(child.id);
//         if (child.children.isNotEmpty) {
//           _addAllChildrenIds(child, idList);
//         }
//       }
//     }

//     void findAndCollectCategories(List<Category> categoryList, int targetId) {
//       for (var category in categoryList) {
//         // If this is the target category, add it and its children
//         if (category.id == targetId) {
//           relatedIds.add(category.id);
//           // Add all children categories
//           _addAllChildrenIds(category, relatedIds);
//           return;
//         }

//         // If this category has children, search recursively
//         if (category.children.isNotEmpty) {
//           findAndCollectCategories(category.children, targetId);
//         }
//       }
//     }

//     // Search for the target category
//     findAndCollectCategories(categories, targetCategoryId);

//     // If we found the target category, also try to find its parent
//     if (relatedIds.isNotEmpty) {
//       _findParentCategoryId(categories, targetCategoryId, relatedIds);
//     }

//     return relatedIds;
//   }

//   /*                           FIND PARENT CATEGORY ID                                      */
//   static void _findParentCategoryId(
//     List<Category> categories,
//     int targetCategoryId,
//     List<int> idList,
//   ) {
//     for (var category in categories) {
//       // Check if this category has the target as a child
//       if (_hasChildWithId(category, targetCategoryId)) {
//         idList.add(category.id);
//         return;
//       }

//       // Recursively search in children
//       if (category.children.isNotEmpty) {
//         _findParentCategoryId(category.children, targetCategoryId, idList);
//       }
//     }
//   }

//   /*                           CHECK IF CATEGORY HAS CHILD WITH SPECIFIC ID                */
//   static bool _hasChildWithId(Category category, int targetId) {
//     for (var child in category.children) {
//       if (child.id == targetId) {
//         return true;
//       }
//       if (child.children.isNotEmpty && _hasChildWithId(child, targetId)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   /*                           GET PRODUCTS BY CATEGORY ID (ENHANCED)                      */
//   static Future<List<Product>> getProductsByCategoryId(
//     int categoryId, {
//     String shopId = '4',
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getproducts?code=$categoryId'),
//         headers: await _getAuthHeaders(),
//       );

//       print(
//         "Products API Response for category $categoryId: ${response.statusCode}",
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['success'] == true) {
//           final products = jsonResponse['products'] as List;
//           print("Found ${products.length} products for category $categoryId");
//           return products
//               .map((productJson) => Product.fromJson(productJson))
//               .toList();
//         } else {
//           print("API returned success: false for category $categoryId");
//         }
//       } else {
//         print("Products API error: ${response.statusCode} - ${response.body}");
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching products for category $categoryId: $e");
//       return [];
//     }
//   }

//   /* ------------------------- DEBUG TOKEN STORAGE ------------------------- */
//   static Future<void> debugTokenStorage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       print("\n" + "=" * 50);
//       print(" DEBUG TOKEN STORAGE");
//       print("=" * 50);

//       // Check ALL stored data
//       print(" ALL STORED DATA:");
//       final allKeys = prefs.getKeys().toList()..sort();
//       for (var key in allKeys) {
//         final value = prefs.get(key);
//         print("   - $key: $value");
//       }

//       // Specifically check auth_token
//       final authToken = prefs.getString('auth_token');
//       print("\n AUTH TOKEN STATUS:");
//       print("   - auth_token exists: ${authToken != null}");
//       print("   - auth_token value: $authToken");
//       print("   - auth_token length: ${authToken?.length ?? 0}");

//       print("=" * 50 + "\n");
//     } catch (e) {
//       print(" Debug token storage error: $e");
//     }
//   }

//   /* ------------------------- CHECK TOKEN FORMAT ------------------------- */
//   static Future<void> _checkTokenFormat(String token) async {
//     try {
//       print("\n" + "=" * 50);
//       print(" TOKEN FORMAT ANALYSIS");
//       print("=" * 50);

//       print(" Token Analysis:");
//       print("   - Total length: ${token.length}");
//       print("   - Contains spaces: ${token.contains(' ')}");
//       print("   - Contains newlines: ${token.contains('\n')}");
//       print(
//         "   - Contains quotes: ${token.contains('"') || token.contains("'")}",
//       );
//       print("   - Starts with: ${token.substring(0, min(10, token.length))}");
//       print(
//         "   - Ends with: ${token.substring(token.length - min(10, token.length))}",
//       );

//       // Check if it's a JWT token (should have 3 parts separated by dots)
//       final parts = token.split('.');
//       print("   - JWT parts: ${parts.length}");
//       if (parts.length == 3) {
//         print("   - JWT header: ${parts[0].length} chars");
//         print("   - JWT payload: ${parts[1].length} chars");
//         print("   - JWT signature: ${parts[2].length} chars");
//       }

//       // Check for common issues
//       if (token.startsWith('"') && token.endsWith('"')) {
//         print("  WARNING: Token is wrapped in quotes!");
//       }
//       if (token.contains('\n')) {
//         print("  WARNING: Token contains newlines!");
//       }
//       if (token.contains(' ')) {
//         print("  WARNING: Token contains spaces!");
//       }

//       print("=" * 50 + "\n");
//     } catch (e) {
//       print(" Token format analysis error: $e");
//     }
//   }

//   /* ------------------------- GET CUSTOMER DETAILS ------------------------- */

//   static Future<Map<String, dynamic>> getCustomerDetails() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');

//       print("\n" + "=" * 50);
//       print(" GET CUSTOMER DETAILS - START");
//       print("=" * 50);

//       if (token == null || token.isEmpty) {
//         print(" TOKEN ISSUE:");
//         print("   - Token is null: ${token == null}");
//         print("   - Token is empty: ${token != null && token.isEmpty}");

//         print(" ALL STORED KEYS:");
//         final allKeys = prefs.getKeys();
//         allKeys.forEach((key) {
//           final value = prefs.get(key);
//           print("   - $key: $value");
//         });

//         return {
//           'success': false,
//           'message': 'Authentication token not found',
//           'code': 'NO_TOKEN',
//         };
//       }

//       print(" TOKEN FOUND:");
//       print("   - Token length: ${token.length}");
//       print(
//         "   - Token preview: ${token.substring(0, min(30, token.length))}...",
//       );
//       print("   - Token ends with: ...${token.substring(token.length - 20)}");

//       await _checkTokenFormat(token);

//       final url = '$baseUrl/public/getcustomerdetails';
//       print(" MAKING API CALL:");
//       print("   - URL: $url");

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       };
//       print("   - Headers: $headers");

//       final stopwatch = Stopwatch()..start();

//       final response = await http
//           .get(Uri.parse(url), headers: headers)
//           .timeout(Duration(seconds: timeoutSeconds));

//       stopwatch.stop();

//       print(" API RESPONSE:");
//       print("Responseeeee : $response");
//       print("   - Status Code: ${response.statusCode}");
//       print("   - Response Time: ${stopwatch.elapsedMilliseconds}ms");
//       print("   - Content-Type: ${response.headers['content-type']}");
//       print("   - Content-Length: ${response.headers['content-length']}");

//       print("   - ALL HEADERS:");
//       response.headers.forEach((key, value) {
//         print("     $key: $value");
//       });

//       if (response.statusCode == 200) {
//         print(" HTTP 200 OK");
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         print("   - JSON Success: ${responseData['success']}");
//         print("   - Response keys: ${responseData.keys.toList()}");

//         if (responseData['success'] == true &&
//             responseData['customer'] != null) {
//           final customer = responseData['customer'];
//           print(" CUSTOMER DATA SUCCESS:");
//           print("   - Customer ID: ${customer['id']}");
//           print("   - Name: ${customer['firstname']} ${customer['lastname']}");
//           print("   - Email: ${customer['email']}");

//           await _storeCustomerData(customer);

//           print(" GET CUSTOMER DETAILS - COMPLETED SUCCESSFULLY");
//           print("=" * 50 + "\n");

//           return {
//             'success': true,
//             'firstName': customer['firstname'] ?? '',
//             'lastName': customer['lastname'] ?? '',
//             'email': customer['email'] ?? '',
//             'phone': customer['phone'] ?? '',
//             'mobile': customer['phone_number'] ?? '',
//             'id': customer['id'] ?? 0,
//             'id_state': customer['geoloc_id_state'],
//           };
//         } else {
//           print(" API RESPONSE ISSUE:");
//           print("   - Success field: ${responseData['success']}");
//           print(
//             "   - Customer field exists: ${responseData['customer'] != null}",
//           );
//           print("   - Message: ${responseData['message']}");
//           print("   - Full response: $responseData");

//           print(" GET CUSTOMER DETAILS - FAILED (API response issue)");
//           print("=" * 50 + "\n");

//           return {
//             'success': false,
//             'message':
//                 responseData['message'] ?? 'Invalid response from server',
//             'code': 'INVALID_RESPONSE',
//           };
//         }
//       } else if (response.statusCode == 401) {
//         print(" AUTHENTICATION FAILED - 401 Unauthorized");
//         print("   - Response body: ${response.body}");

//         print(" GET CUSTOMER DETAILS - FAILED (401 Unauthorized)");
//         print("=" * 50 + "\n");

//         return {
//           'success': false,
//           'message': 'Authentication failed. Please login again.',
//           'code': 'AUTH_FAILED',
//         };
//       } else {
//         print(" SERVER ERROR:");
//         print("   - Status: ${response.statusCode}");
//         print("   - Body: ${response.body}");

//         print(" GET CUSTOMER DETAILS - FAILED (Server error)");
//         print("=" * 50 + "\n");

//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//           'code': 'SERVER_ERROR',
//         };
//       }
//     } catch (e) {
//       print(" EXCEPTION IN GET CUSTOMER DETAILS:");
//       print("   - Error: $e");
//       print("   - Error type: ${e.runtimeType}");

//       print(" GET CUSTOMER DETAILS - FAILED (Exception)");
//       print("=" * 50 + "\n");

//       return {
//         'success': false,
//         'message': 'Failed to connect: $e',
//         'code': 'NETWORK_ERROR',
//       };
//     }
//   }

//   /* ------------------------- STORE CUSTOMER DATA ------------------------- */
//   static Future<void> _storeCustomerData(Map<String, dynamic> customer) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       await prefs.setInt('user_id', customer['id'] ?? 0);
//       await prefs.setString('user_email', customer['email'] ?? '');
//       await prefs.setString('user_firstName', customer['firstname'] ?? '');
//       await prefs.setString('user_lastName', customer['lastname'] ?? '');
//       await prefs.setString('user_phone', customer['phone_number'] ?? '');

//       print(" Customer data stored successfully");
//     } catch (e) {
//       print(" Error storing customer data: $e");
//     }
//   }

//   /* ------------------------- GET CUSTOMER ADDRESSES ------------------------- */
//   static Future<Map<String, dynamic>> getCustomerAddresses() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');

//       if (token == null || token.isEmpty) {
//         return {
//           'success': false,
//           'message': 'Authentication token not found',
//           'code': 'NO_TOKEN',
//         };
//       }

//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/public/getaddresses'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//               'Accept': 'application/json',
//             },
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" Addresses API Response: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           // Store addresses locally as backup
//           if (responseData['addresses'] != null) {
//             await LocalAddressService.storeAddresses(responseData['addresses']);
//           }

//           return responseData;
//         } else {
//           return {
//             'success': false,
//             'message': responseData['message'] ?? 'Failed to get addresses',
//             'code': 'API_ERROR',
//           };
//         }
//       } else if (response.statusCode == 401) {
//         await prefs.remove('auth_token');
//         return {
//           'success': false,
//           'message': 'Authentication failed. Please login again.',
//           'code': 'AUTH_FAILED',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//           'code': 'SERVER_ERROR',
//         };
//       }
//     } catch (e) {
//       print(" Error fetching addresses: $e");

//       // Try to get addresses from local storage as fallback
//       try {
//         final localAddresses = await LocalAddressService.getLocalAddresses();
//         return {
//           'success': true,
//           'addresses': localAddresses,
//           'fromLocalStorage': true,
//         };
//       } catch (localError) {
//         return {
//           'success': false,
//           'message': 'Failed to connect to server: $e',
//           'code': 'NETWORK_ERROR',
//         };
//       }
//     }
//   }

//   /* ------------------------- CREATE ADDRESS ------------------------- */
//   static Future<Map<String, dynamic>> createAddress({
//     required String firstname,
//     required String lastname,
//     required String address1,
//     required String city,
//     required String postcode,
//     required int idState,
//     String? phone,
//     String? address2,
//     String? alias = 'Home Address',
//   }) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');
//       final int? customerId = prefs.getInt('user_id');

//       print("CREATE ADDRESS - AUTH CHECK:");
//       print("   - Token: ${token != null ? 'EXISTS' : 'NULL'}");
//       print("   - Customer ID: $customerId");

//       if (token == null || customerId == null) {
//         return {
//           'success': false,
//           'message': 'Authentication required. Please login again.',
//         };
//       }

//       // Build query parameters for the API
//       final Map<String, String> queryParams = {
//         'firstname': firstname,
//         'lastname': lastname,
//         'address1': address1,
//         'city': city,
//         'postcode': postcode,
//         'id_state': idState.toString(),
//       };

//       // Add optional parameters
//       if (phone != null && phone.isNotEmpty) queryParams['phone'] = phone;
//       if (address2 != null && address2.isNotEmpty)
//         queryParams['address2'] = address2;

//       final Uri uri = Uri.parse(
//         '$baseUrl/public/createaddress',
//       ).replace(queryParameters: queryParams);

//       print(" CREATE ADDRESS API CALL:");
//       print("   - URL: $uri");
//       print("   - Headers with Authorization: Bearer token");

//       final response = await http
//           .post(
//             uri,
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//               'Accept': 'application/json',
//             },
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("CREATE ADDRESS RESPONSE:");
//       print("   - Status Code: ${response.statusCode}");
//       print("   - Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         print(" RESPONSE ANALYSIS:");
//         print("   - Success: ${responseData['success']}");
//         print("   - Message: ${responseData['message']}");
//         print("   - ID Address: ${responseData['id_address']}");

//         if (responseData['success'] == true) {
//           final newAddressId = responseData['id_address'];
//           print(" ADDRESS CREATED SUCCESSFULLY: $newAddressId");

//           final addressData = {
//             'id_address': newAddressId,
//             'firstname': firstname,
//             'lastname': lastname,
//             'address1': address1,
//             'address2': address2 ?? '',
//             'city': city,
//             'postcode': postcode,
//             'id_state': idState,
//             'phone': phone ?? '',
//             'phone_mobile': phone ?? '',
//             'country': 'Libya',
//             'state': getStateNameById(idState),
//           };

//           await LocalAddressService.saveLocalAddress(addressData);

//           return {
//             'success': true,
//             'message':
//                 responseData['message'] ?? 'Address created successfully',
//             'id_address': newAddressId,
//             'address': responseData['address'],
//           };
//         } else {
//           // API returned success: false - analyze why
//           final errorMessage =
//               responseData['message'] ?? 'Failed to create address';
//           print(" API CREATION FAILED: $errorMessage");

//           return {'success': false, 'message': errorMessage, 'api_error': true};
//         }
//       } else if (response.statusCode == 401) {
//         print(" AUTHENTICATION FAILED - 401");
//         await prefs.remove('auth_token');
//         return {
//           'success': false,
//           'message': 'Authentication failed. Please login again.',
//           'auth_error': true,
//         };
//       } else {
//         print(" SERVER ERROR: ${response.statusCode}");
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//           'server_error': true,
//         };
//       }
//     } catch (e) {
//       print(" CREATE ADDRESS EXCEPTION: $e");

//       // Fallback to local storage
//       try {
//         final addressData = {
//           'firstname': firstname,
//           'lastname': lastname,
//           'address1': address1,
//           'address2': address2 ?? '',
//           'city': city,
//           'postcode': postcode,
//           'id_state': idState,
//           'phone': phone ?? '',
//           'alias': alias,
//           'state': getStateNameById(idState),
//         };

//         final localResult = await LocalAddressService.saveLocalAddress(
//           addressData,
//         );

//         if (localResult['success'] == true) {
//           return {
//             'success': true,
//             'message': 'Address saved locally (offline mode)',
//             'id_address': localResult['addressId'],
//             'address': localResult['address'],
//             'fromLocalStorage': true,
//           };
//         } else {
//           return {
//             'success': false,
//             'message': 'Failed to create address locally: $e',
//           };
//         }
//       } catch (localError) {
//         return {'success': false, 'message': 'Failed to connect to server: $e'};
//       }
//     }
//   }

//   /* ------------------------- UPDATE ADDRESS ------------------------- */
//   static Future<Map<String, dynamic>> updateAddress({
//     required int idAddress,
//     required String firstname,
//     required String lastname,
//     required String address1,
//     required String city,
//     required String postcode,
//     required int idState,
//     String? phone,
//     String? address2,
//   }) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');

//       if (token == null) {
//         return {'success': false, 'message': 'Authentication token not found'};
//       }

//       // Build query parameters
//       final Map<String, String> queryParams = {
//         'id_address': idAddress.toString(),
//         'firstname': firstname,
//         'lastname': lastname,
//         'address1': address1,
//         'city': city,
//         'postcode': postcode,
//         'id_state': idState.toString(),
//       };

//       // Add optional parameters
//       if (phone != null && phone.isNotEmpty) {
//         queryParams['phone'] = phone;
//       }
//       if (address2 != null && address2.isNotEmpty) {
//         queryParams['address2'] = address2;
//       }

//       final Uri uri = Uri.parse(
//         '$baseUrl/public/updateaddressbyid',
//       ).replace(queryParameters: queryParams);

//       final response = await http
//           .put(
//             uri,
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//               'Accept': 'application/json',
//             },
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           return {
//             'success': true,
//             'message':
//                 responseData['message'] ?? 'Address updated successfully',
//             'id_address': responseData['id_address'],
//           };
//         } else {
//           return {
//             'success': false,
//             'message': responseData['message'] ?? 'Failed to update address',
//           };
//         }
//       } else if (response.statusCode == 401) {
//         return {
//           'success': false,
//           'message': 'Authentication failed. Please login again.',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" Error updating address: $e");
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   /* ------------------------- GET ADDRESS BY ID ------------------------- */
//   static Future<Map<String, dynamic>> getAddressById(int addressId) async {
//     try {
//       final headers = await _getAuthHeaders();

//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/public/getadressebyid?id_address=$addressId'),
//             headers: headers,
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("Get address by ID response: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return responseData;
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print("Error getting address by ID: $e");
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   /* ------------------------- DELETE ADDRESS ------------------------- */
//   static Future<Map<String, dynamic>> deleteAddress(
//     String addressIdentifier,
//   ) async {
//     try {
//       final headers = await _getAuthHeaders();
//       final addressId = int.tryParse(addressIdentifier);

//       if (addressId == null) {
//         return {'success': false, 'message': 'Invalid address ID'};
//       }

//       final response = await http
//           .delete(
//             Uri.parse('$baseUrl/public/deleteaddress?id_address=$addressId'),
//             headers: headers,
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("Delete address response: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return responseData;
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print("Error deleting address: $e");
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   /* ------------------------- ADD ADDRESS ------------------------- */
//   static Future<bool> addAddress(Map<String, dynamic> addressData) async {
//     try {
//       print("🔄 ADD ADDRESS - PROCESSING DATA:");
//       print("   - Full address data: $addressData");

//       // Extract and validate required fields
//       final String firstname =
//           addressData['firstname']?.toString().trim() ?? '';
//       final String lastname = addressData['lastname']?.toString().trim() ?? '';
//       final String address1 = addressData['address1']?.toString().trim() ?? '';
//       final String city = addressData['city']?.toString().trim() ?? '';
//       final String postcode = addressData['postcode']?.toString().trim() ?? '';

//       // Handle idState - it could be String or int
//       int idState = 0;
//       if (addressData['id_state'] != null) {
//         idState =
//             addressData['id_state'] is int
//                 ? addressData['id_state']
//                 : int.tryParse(addressData['id_state'].toString()) ?? 0;
//       } else if (addressData['idState'] != null) {
//         idState =
//             addressData['idState'] is int
//                 ? addressData['idState']
//                 : int.tryParse(addressData['idState'].toString()) ?? 0;
//       }

//       final String? phone = addressData['phone']?.toString().trim();
//       final String? address2 = addressData['address2']?.toString().trim();

//       print("📝 EXTRACTED ADDRESS DATA:");
//       print("   - Firstname: '$firstname'");
//       print("   - Lastname: '$lastname'");
//       print("   - Address1: '$address1'");
//       print("   - City: '$city'");
//       print("   - Postcode: '$postcode'");
//       print("   - ID State: $idState");
//       print("   - Phone: '$phone'");
//       print("   - Address2: '$address2'");

//       // Validate required fields
//       if (firstname.isEmpty) {
//         print(" VALIDATION FAILED: Firstname is empty");
//         return false;
//       }
//       if (lastname.isEmpty) {
//         print(" VALIDATION FAILED: Lastname is empty");
//         return false;
//       }
//       if (address1.isEmpty) {
//         print(" VALIDATION FAILED: Address1 is empty");
//         return false;
//       }
//       if (city.isEmpty) {
//         print(" VALIDATION FAILED: City is empty");
//         return false;
//       }
//       if (postcode.isEmpty) {
//         print(" VALIDATION FAILED: Postcode is empty");
//         return false;
//       }
//       if (idState == 0) {
//         print(" VALIDATION FAILED: ID State is invalid");
//         return false;
//       }

//       final result = await createAddress(
//         firstname: firstname,
//         lastname: lastname,
//         address1: address1,
//         city: city,
//         postcode: postcode,
//         idState: idState,
//         phone: phone?.isNotEmpty == true ? phone : null,
//         address2: address2?.isNotEmpty == true ? address2 : null,
//       );

//       print("📨 ADD ADDRESS RESULT:");
//       print("   - Success: ${result['success']}");
//       print("   - Message: ${result['message']}");

//       return result['success'] == true;
//     } catch (e) {
//       print(" ERROR IN ADD ADDRESS: $e");
//       return false;
//     }
//   }

//   /*                           GET PRODUCT ATTRIBUTES                           */
//   static Future<Map<String, dynamic>> getProductAttributes(
//     int productId,
//   ) async {
//     try {
//       final headers = await _getAuthHeaders();

//       final response = await http
//           .get(
//             Uri.parse(
//               '$baseUrl/public/getproductattributes?id_product=$productId',
//             ),
//             headers: headers,
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print("Get product attributes response: ${response.statusCode}");
//       print("Product attributes body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         if (responseData['success'] == true) {
//           print(
//             "✓ Product attributes fetched successfully for product $productId",
//           );
//           return responseData;
//         } else {
//           print("✗ Product attributes API returned success: false");
//           return {
//             'success': false,
//             'message':
//                 responseData['message'] ?? 'Failed to get product attributes',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to get product attributes: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print("Error getting product attributes: $e");
//       return {
//         'success': false,
//         'message': 'Failed to get product attributes: $e',
//       };
//     }
//   }

//   /*                           GET DEFAULT PRODUCT ATTRIBUTE ID                          */
//   static Future<int?> getDefaultProductAttributeId(int productId) async {
//     try {
//       final attributesResponse = await getProductAttributes(productId);

//       if (attributesResponse['success'] == true) {
//         if (attributesResponse['combinations'] != null &&
//             attributesResponse['combinations'] is List &&
//             attributesResponse['combinations'].isNotEmpty) {
//           final firstCombination = attributesResponse['combinations'][0];
//           final attributeId =
//               firstCombination['id_product_attribute'] ??
//               firstCombination['id'];

//           print("✓ Default attribute ID for product $productId: $attributeId");
//           return attributeId is String
//               ? int.tryParse(attributeId)
//               : attributeId as int?;
//         }

//         // check if the response directly contains product_attribute_id
//         if (attributesResponse['id_product_attribute'] != null) {
//           final attributeId = attributesResponse['id_product_attribute'];
//           print("✓ Default attribute ID for product $productId: $attributeId");
//           return attributeId is String
//               ? int.tryParse(attributeId)
//               : attributeId as int?;
//         }

//         // If no combinations found, return the product ID as fallback (not ideal)
//         print(
//           "⚠ No combinations found for product $productId, using product ID as fallback",
//         );
//         return productId;
//       } else {
//         print(
//           "✗ Failed to get attributes for product $productId: ${attributesResponse['message']}",
//         );
//         return productId; // Fallback
//       }
//     } catch (e) {
//       print("Error getting default product attribute: $e");
//       return productId;
//     }
//   }

//   /* ------------------------- GET STATES ------------------------- */
//   static Future<Map<String, dynamic>> getStates() async {
//     try {
//       // Return cached states if already loaded
//       if (_statesLoaded && _statesList.isNotEmpty) {
//         return {'success': true, 'states': _statesList};
//       }

//       print(" Loading states from API...");

//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/public/getstates'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//           )
//           .timeout(Duration(seconds: timeoutSeconds));

//       print(" States API Response: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true && responseData['states'] != null) {
//           _statesList =
//               (responseData['states'] as List)
//                   .map((stateJson) => StateModel.fromJson(stateJson))
//                   .toList();

//           // Update mappings
//           _updateStateMappings();

//           // Store states locally for offline use
//           await _storeStatesLocally(_statesList);

//           _statesLoaded = true;

//           print(" ${_statesList.length} states loaded successfully");

//           return {'success': true, 'states': _statesList};
//         } else {
//           return {
//             'success': false,
//             'message': 'Invalid response format from states API',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print(" Error loading states: $e");

//       // Try to load from local storage
//       try {
//         final localStates = await _getStatesFromLocalStorage();
//         if (localStates.isNotEmpty) {
//           _statesList = localStates;
//           _updateStateMappings();
//           _statesLoaded = true;

//           return {
//             'success': true,
//             'states': _statesList,
//             'fromLocalStorage': true,
//           };
//         }
//       } catch (localError) {
//         print(" Error loading local states: $localError");
//       }

//       return {'success': false, 'message': 'Failed to load states: $e'};
//     }
//   }

//   /* ------------------------- UPDATE STATE MAPPINGS ------------------------- */
//   static void _updateStateMappings() {
//     _stateIdToName.clear();
//     _stateNameToId.clear();

//     for (var state in _statesList) {
//       _stateIdToName[state.idState] = state.name;
//       _stateNameToId[state.name] = state.idState;
//     }

//     print("🗺️ State mappings updated: ${_stateIdToName.length} states");
//   }

//   /* ------------------------- GET STATE NAME BY ID ------------------------- */
//   static String getStateNameById(int stateId) {
//     return _stateIdToName[stateId] ?? 'Unknown State';
//   }

//   /* ------------------------- GET STATE ID BY NAME ------------------------- */
//   static int? getStateIdByName(String stateName) {
//     return _stateNameToId[stateName];
//   }

//   /* ------------------------- GET ALL STATES ------------------------- */
//   static List<StateModel> getAllStates() {
//     return _statesList;
//   }

//   /* ------------------------- STORE STATES LOCALLY ------------------------- */
//   static Future<void> _storeStatesLocally(List<StateModel> states) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final statesJson = states.map((state) => state.toJson()).toList();
//       await prefs.setString('app_states', json.encode(statesJson));
//       print(" ${states.length} states stored locally");
//     } catch (e) {
//       print(" Error storing states locally: $e");
//     }
//   }

//   /* ------------------------- GET STATES FROM LOCAL STORAGE ------------------------- */
//   static Future<List<StateModel>> _getStatesFromLocalStorage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final statesJsonString = prefs.getString('app_states');

//       if (statesJsonString != null) {
//         final List<dynamic> statesJson = json.decode(statesJsonString);
//         final states =
//             statesJson.map((json) => StateModel.fromJson(json)).toList();
//         print("📂 ${states.length} states loaded from local storage");
//         return states;
//       }
//     } catch (e) {
//       print(" Error loading states from local storage: $e");
//     }

//     return [];
//   }

//   /* ------------------------- INITIALIZE STATES ------------------------- */
//   static Future<void> initializeStates() async {
//     if (!_statesLoaded) {
//       await getStates();
//     }
//   }

//   static testApiConnection() {}

//   static getFavoriteProducts() {}

//   static toggleFavorite(int productId, bool isFavorite) {}
// }