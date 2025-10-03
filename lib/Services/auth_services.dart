

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'https://tawasul-dev.app-staging.fr';
  
  static Future<bool> validateToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // Test the token by making a simple API call
      final response = await http.get(
        Uri.parse('$baseUrl/public/getcustomerdetails'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      print("🔐 Token validation response: ${response.statusCode}");
      
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Token validation error: $e");
      return false;
    }
  }
  
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    await prefs.remove('user_phone');
  }
  
  static Future<Map<String, dynamic>> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getInt('user_id'),
      'token': prefs.getString('auth_token'),
      'email': prefs.getString('user_email'),
      'firstName': prefs.getString('user_firstName'),
      'lastName': prefs.getString('user_lastName'),
      'phone': prefs.getString('user_phone'),
    };
  }
}