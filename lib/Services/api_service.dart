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
            name: '',
            brand: '',
            price: '',
            image: '',
            description: '',
            isNew: false,
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
              isNew: productJson['new'] == "1" || productJson['new'] == 1,
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

  // GET CATEGORY PRODUCTS  "All"
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

        if (data['response'] != null) {
          // ADD DEBUG CODE RIGHT HERE:
          if (data['response']['products'] != null) {
            print("🆕 Debug - New field values:");
            for (var product in data['response']['products']) {
              print(
                "ID: ${product['id_product']}, New: ${product['new']}, Name: ${product['name']}",
              );
            }

            print("🛍️ Products found: ${data['response']['products'].length}");
            return (data['response']['products'] as List).map<Product>((
              productJson,
            ) {
              print("📋 Product: $productJson");
              return Product(
                id:
                    int.tryParse(
                      productJson['id_product']?.toString() ?? '0',
                    ) ??
                    0,
                name: productJson['name'] ?? 'No Name',
                brand: productJson['manufacturer_name'] ?? 'No Brand',
                price: productJson['price']?.toString() ?? '0',
                image: productJson['image'] ?? '',
                description:
                    productJson['description_short'] ?? 'No Description',
                oldPrice: productJson['price_without_reduction']?.toString(),
                discount:
                    productJson['reduction'] != null &&
                            productJson['reduction'] > 0
                        ? '${(productJson['reduction'] * 100).toStringAsFixed(0)}% OFF'
                        : null,
                isNew:
                    productJson['new'] == "1" ||
                    productJson['new'] == 1, // ADD THIS
              );
            }).toList();
          } else if (data['response'] is List) {
            // Also add debug for the second case if needed
            print(
              "🛍️ Products found (direct list): ${data['response'].length}",
            );
            return (data['response'] as List).map<Product>((productJson) {
              print("📋 Product: $productJson");
              return Product(
                id:
                    int.tryParse(
                      productJson['id_product']?.toString() ?? '0',
                    ) ??
                    0,
                name: productJson['name'] ?? 'No Name',
                brand: productJson['manufacturer_name'] ?? 'No Brand',
                price: productJson['price']?.toString() ?? '0',
                image: productJson['image'] ?? '',
                description:
                    productJson['description_short'] ?? 'No Description',
                oldPrice: productJson['price_without_reduction']?.toString(),
                discount:
                    productJson['reduction'] != null &&
                            productJson['reduction'] > 0
                        ? '${(productJson['reduction'] * 100).toStringAsFixed(0)}% OFF'
                        : null,
                dateAdded: parseDate(productJson['date_add']),
                dateUpdated: parseDate(productJson['date_upd']),
                isNew:
                    productJson['new'] == "1" ||
                    productJson['new'] == 1, // ADD THIS
              );
            }).toList();
          }
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

  //HELPER METHOD
  static DateTime? parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print("Error parsing date: $dateString");
      return null;
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

  // static Future<void> testImageUrls() async {
  //   // Test a few product IDs to see if images exist
  //   final testUrls = [
  //     'https://tawasul-shop.com/img/p/1-large_default.jpg',
  //     'https://tawasul-shop.com/img/p/2-large_default.jpg',
  //     'https://tawasul-shop.com/img/p/100-large_default.jpg',
  //   ];

  //   for (var url in testUrls) {
  //     try {
  //       final response = await http.head(Uri.parse(url));
  //       print("🖼️ $url → Status: ${response.statusCode}");
  //     } catch (e) {
  //       print("❌ $url → Error: $e");
  //     }
  //   }
  // }

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
}
