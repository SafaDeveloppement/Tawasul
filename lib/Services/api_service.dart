// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/model/product_model.dart';

// class ApiService {
//   static const String baseUrl = "http://t-api.dotit-corp.com/api";

//   // LOGIN
//   static Future<Map<String, dynamic>> login(
//     String username,
//     String password,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/public/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'password': password}),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200 && responseData['token'] != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', responseData['token']);
//         return {'success': true, 'token': responseData['token']};
//       } else {
//         return {
//           'success': false,
//           'message': responseData['message'] ?? 'Invalid login credentials',
//         };
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Failed to connect to server: $e'};
//     }
//   }

//   // GET PRODUCT DETAILS
//   static Future<Product?> getProductDetails(int productId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getProduct?id=$productId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response'] != null && data['response']['product'] != null) {
//           return Product.fromJson(data['response']['product']);
//         }
//       }
//       return null; // return null if not found
//     } catch (e) {
//       print("Error fetching product details: $e");
//       return null;
//     }
//   }

//   static Future<Product?> getProductDetail({
//     required String code,
//     required String shopId,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/public/getProduct?code=$code&id-shop=$shopId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response'] != null && data['response'].isNotEmpty) {
//           // Assuming the API returns a list of products
//           // You might need to adjust this based on actual API response
//           return Product(
//             id: int.tryParse(data['response'][0]['id']?.toString() ?? '0') ?? 0,
//             name: data['response'][0]['name'] ?? 'No Name',
//             brand: data['response'][0]['brand'] ?? 'No Brand',
//             price: data['response'][0]['price']?.toString() ?? '0',
//             image: data['response'][0]['image'] ?? '',
//             description: data['response'][0]['description'] ?? 'No Description',
//             oldPrice: data['response'][0]['oldPrice']?.toString(),
//             discount: data['response'][0]['discount']?.toString(),
//           );
//         }
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching product: $e");
//       return null;
//     }
//   }

//   static Future<List<Product>> getAllProducts() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$baseUrl/public/getAllProducts',
//         ), // Adjust endpoint as needed
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response'] != null && data['response'] is List) {
//           return data['response']
//               .map<Product>(
//                 (productJson) => Product(
//                   id: int.tryParse(productJson['id']?.toString() ?? '0') ?? 0,
//                   name: productJson['name'] ?? 'No Name',
//                   brand: productJson['brand'] ?? 'No Brand',
//                   price: productJson['price']?.toString() ?? '0',
//                   image: productJson['image'] ?? '',
//                   description: productJson['description'] ?? 'No Description',
//                   oldPrice: productJson['oldPrice']?.toString(),
//                   discount: productJson['discount']?.toString(),
//                 ),
//               )
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching all products: $e");
//       return [];
//     }
//   }

//   // Other functions (forgotPassword, resetPassword, getToken, logout) ...
// }

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
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
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
      print("🌐 Request URL: $url"); // Log the request URL

      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: timeoutSeconds));

      // Log the raw response
      print("📥 Raw API Response: ${response.body}");
      print("🛡️ Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Parsed Response Data: $data"); // Log parsed data

        if (data['response'] != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final productData = data['response'][0];
          print("🛍️ Product Data: $productData"); // Log specific product data

          // Rest of your processing code...
          return Product(
            id: int.tryParse(productData['id']?.toString() ?? '0') ?? 0,
            name: '',
            brand: '',
            price: '',
            image: '',
            description: '',
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

  // GET ALL PRODUCTS
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/products'),
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
              isFavorite: productJson['is_favorite'] ?? false,
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching all products: $e");
      return [];
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
              isFavorite: true, // All products here are favorites
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

  // GET BEST SELLING PRODUCTS
  static Future<List<Product>> getBestSellingProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/public/products/best-selling'),
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
              isBestSeller: true,
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching best selling products: $e");
      return [];
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
}
