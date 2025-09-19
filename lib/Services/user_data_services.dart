import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  // Check if user data exists
  static Future<bool> hasUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_firstName') && 
           prefs.containsKey('user_lastName') && 
           prefs.containsKey('user_phone');
  }

  // Get user data
  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('user_firstName') ?? '',
      'lastName': prefs.getString('user_lastName') ?? '',
      'phone': prefs.getString('user_phone') ?? '',
      'email': prefs.getString('user_email') ?? '',
    };
  }

  // Store user data
  static Future<void> storeUserData({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_firstName', firstName);
    await prefs.setString('user_lastName', lastName);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_email', email);
  }

  // Clear user data (for logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    await prefs.remove('user_phone');
    await prefs.remove('user_email');
  }
}