import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tawasul_application/preferences/shared_preferences_services.dart';

class CartService {
  // Create a new cart for a user
  static Future<int?> createNewCartForUser(int userId) async {
    try {
      final token = await SharedPreferencesService.getAuthToken();
      
      final response = await http.post(
        Uri.parse('https://tawasul-dev.app-staging.fr/public/cart/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_customer': userId,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final newCartId = data['cart_id'] ?? data['id_cart'];
          print('🛒 Created new cart: $newCartId for user: $userId');
          return newCartId;
        }
      }
      
      return null;
    } catch (e) {
      print('❌ Error creating cart: $e');
      return null;
    }
  }
  
  // Get or create cart for current user
  static Future<int?> getOrCreateCart() async {
    try {
      final currentCartId = await SharedPreferencesService.getCartId();
     // final currentUserId = await SharedPreferencesService.getUserId();
      
      if (currentCartId != null && currentCartId > 0) {
        print('🛒 Using existing cart: $currentCartId');
        return currentCartId;
      }
      
      // if (currentUserId == null) {
      //   print('❌ No user ID found');
      //   return null;
      // }
      
      // Create new cart
      // return await createNewCartForUser(currentUserId);
    } catch (e) {
      print('❌ Error in getOrCreateCart: $e');
      return null;
    }
  }
  
  // Clear cart when user logs out
  static Future<void> clearUserCart() async {
    await SharedPreferencesService.removeCartId();
    print('🗑️ Cleared user cart data');
  }
}