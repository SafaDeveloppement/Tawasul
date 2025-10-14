// // import 'package:shared_preferences/shared_preferences.dart';

// // class SharedPreferencesService {
// //   static const String _authTokenKey = 'auth_token';

// //   static Future<void> saveAuthToken(String token) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString(_authTokenKey, token);
// //   }

// //   static Future<String?> getAuthToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString(_authTokenKey);
// //   }

// //   static Future<void> removeAuthToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove(_authTokenKey);
// //   }
// // }

// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesService {
//   static const String _authTokenKey = 'auth_token';
//   static const String _userIdKey = 'user_id';
//   static const String _cartIdKey = 'cart_id';
//   static const String _userEmailKey = 'user_email';

//   // Auth Token
//   static Future<void> saveAuthToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_authTokenKey, token);
//   }

//   static Future<String?> getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_authTokenKey);
//   }

//   static Future<void> removeAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_authTokenKey);
//   }

//   // User ID
//   static Future<void> saveUserId(int userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_userIdKey, userId);
//   }

//   static Future<int?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(_userIdKey);
//   }

//   static Future<void> removeUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userIdKey);
//   }

//   // Cart ID - FIXED: Always store as String to avoid type issues
//   static Future<void> saveCartId(int cartId) async {
//     final prefs = await SharedPreferences.getInstance();
//     // Always store as String to avoid type casting issues
//     await prefs.setString(_cartIdKey, cartId.toString());
//     print(
//       '💾 Saved cart ID: $cartId (as String) for user: ${await getUserId()}',
//     );
//   }

//   static Future<int?> getCartId() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // First try to get as String (our preferred method)
//       final cartIdString = prefs.getString(_cartIdKey);
//       if (cartIdString != null && cartIdString.isNotEmpty) {
//         final cartId = int.tryParse(cartIdString);
//         if (cartId != null && cartId > 0) {
//           return cartId;
//         }
//       }

//       // Fallback: try to get as int (for backward compatibility)
//       final cartIdInt = prefs.getInt(_cartIdKey);
//       if (cartIdInt != null && cartIdInt > 0) {
//         // Migrate to string storage for consistency
//         await prefs.setString(_cartIdKey, cartIdInt.toString());
//         return cartIdInt;
//       }

//       return null;
//     } catch (e) {
//       print('❌ Error getting cart ID: $e');
//       return null;
//     }
//   }

//   static Future<void> removeCartId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_cartIdKey);
//     print('🗑️ Removed cart ID');
//   }

//   // User Email (for verification)
//   static Future<void> saveUserEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userEmailKey, email);
//   }

//   static Future<String?> getUserEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userEmailKey);
//   }

//   // Clear all user data (on logout)
//   static Future<void> clearUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_authTokenKey);
//     await prefs.remove(_userIdKey);
//     await prefs.remove(_cartIdKey);
//     await prefs.remove(_userEmailKey);
//     print('🧹 Cleared all user data');
//   }

//   // Debug method to check stored data
//   static Future<void> debugStoredData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       print('=== STORED DATA DEBUG ===');
//       print(
//         'Auth Token: ${prefs.getString(_authTokenKey) != null ? "Exists" : "Missing"}',
//       );

//       final userId = prefs.getInt(_userIdKey);
//       print('User ID: $userId');

//       final cartIdString = prefs.getString(_cartIdKey);
//       final cartIdInt = prefs.getInt(_cartIdKey);
//       print('Cart ID (String): $cartIdString');
//       print('Cart ID (Int): $cartIdInt');
//       print('Cart ID (via getCartId): ${await getCartId()}');

//       print('User Email: ${prefs.getString(_userEmailKey)}');
//     } catch (e) {
//       print('❌ Error in debugStoredData: $e');
//     }
//   }

//   // Method to fix any existing cart ID type issues
//   static Future<void> fixCartIdType() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Check if cart ID is stored as int but should be string
//       final cartIdInt = prefs.getInt(_cartIdKey);
//       if (cartIdInt != null) {
//         // Convert to string for consistency
//         await prefs.setString(_cartIdKey, cartIdInt.toString());
//         await prefs.remove(_cartIdKey); // Remove the int version
//         print('🔄 Fixed cart ID type: $cartIdInt (int → string)');
//       }
//     } catch (e) {
//       print('❌ Error fixing cart ID type: $e');
//     }
//   }
// }




import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _authTokenKey = 'auth_token';
  static const String _cartIdKey = 'cart_id';

  // Auth Token
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  } 

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  // Cart ID - Simple storage as string
  static Future<void> saveCartId(int cartId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartIdKey, cartId.toString());
    print('💾 Saved cart ID: $cartId');
  }

  static Future<int?> getCartId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartIdString = prefs.getString(_cartIdKey);
      
      if (cartIdString != null && cartIdString.isNotEmpty) {
        return int.tryParse(cartIdString);
      }
      return null;
    } catch (e) {
      print('❌ Error getting cart ID: $e');
      return null;
    }
  }

  static Future<void> removeCartId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartIdKey);
    print('🗑️ Removed cart ID');
  }

  // Clear all user data (on logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_cartIdKey);
    print('🧹 Cleared all user data');
  }

  // Debug method to check stored data
  static Future<void> debugStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('=== STORED DATA DEBUG ===');
      print('Auth Token: ${prefs.getString(_authTokenKey) != null ? "Exists" : "Missing"}');
      print('Cart ID: ${prefs.getString(_cartIdKey)}');
    } catch (e) {
      print('❌ Error in debugStoredData: $e');
    }
  }
}