// import 'package:shared_preferences/shared_preferences.dart';

// class CartManager {
//   static const int _cartIdKey = "current_cart_id";

//   static Future<int?> getCurrentCartId() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final cartId = prefs.getString(_cartIdKey);

//       if (cartId != null &&
//           cartId.isNotEmpty &&
//           cartId != "0" &&
//           cartId != "null") {
//         print(" Valid cart ID found: $cartId");
//         return cartId;
//       } else {
//         print(" No valid cart ID found");
//         return null;
//       }
//     } catch (e) {
//       print(" Error getting cart ID: $e");
//       return null;
//     }
//   }

//   static Future<void> saveCartId(String cartId) async {
//     try {
//       if (cartId.isNotEmpty && cartId != "0" && cartId != "null") {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(_cartIdKey, cartId);
//         print(" Cart ID saved successfully: $cartId");
//       } else {
//         print(" Invalid cart ID, not saving: $cartId");
//       }
//     } catch (e) {
//       print(" Error saving cart ID: $e");
//     }
//   }

//   Future<int?> _getCartId() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final cartId = prefs.getInt('cart_id');
//     print('🧾 Found cart ID: $cartId');
//     return cartId;
//   } catch (e) {
//     print(' Error getting cart ID: $e');
//     return null;
//   }
// }


//   // Clear cart ID
//   static Future<void> clearCartId() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_cartIdKey);
//       print(" Cart ID cleared successfully");
//     } catch (e) {
//       print(" Error clearing cart ID: $e");
//     }
//   }

//   // Check if cart exists
//   static Future<bool> hasCart() async {
//     final cartId = await getCurrentCartId();
//     return cartId != null;
//   }
// }





import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static const String _cartIdKey = "current_cart_id"; // key must be String

  // 🔹 Get current cart ID (as int)
  static Future<int?> getCurrentCartId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartId = prefs.getInt(_cartIdKey); // stored as int
      if (cartId != null && cartId > 0) {
        print("✅ Valid cart ID found: $cartId");
        return cartId;
      } else {
        print("⚠️ No valid cart ID found");
        return null;
      }
    } catch (e) {
      print("❌ Error getting cart ID: $e");
      return null;
    }
  }

  // 🔹 Save cart ID (as int)
  static Future<void> saveCartId(int cartId) async {
    try {
      if (cartId > 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_cartIdKey, cartId);
        print("💾 Cart ID saved successfully: $cartId");
      } else {
        print("⚠️ Invalid cart ID, not saving: $cartId");
      }
    } catch (e) {
      print("❌ Error saving cart ID: $e");
    }
  }

  // 🔹 Clear saved cart ID
  static Future<void> clearCartId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartIdKey);
      print("🧹 Cart ID cleared successfully");
    } catch (e) {
      print("❌ Error clearing cart ID: $e");
    }
  }

  // 🔹 Check if a valid cart exists
  static Future<bool> hasCart() async {
    final cartId = await getCurrentCartId();
    return cartId != null && cartId > 0;
  }
}
