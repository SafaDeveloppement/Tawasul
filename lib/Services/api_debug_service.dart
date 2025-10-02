import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiDebugService {
  static const String baseUrl = 'https://tawasul-dev.app-staging.fr';
  
  static Future<void> testAllAuthMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null) {
      print("❌ No token available");
      return;
    }
    
    print("🧪 TESTING ALL AUTHENTICATION METHODS");
    print("=====================================");
    
    // Test 1: Bearer Token in Header (Current approach)
    await _testAuthMethod("Bearer Token in Header", 
      Uri.parse('$baseUrl/public/getcustomerdetails'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );
    
    // Test 2: Raw Token in Header (without Bearer)
    await _testAuthMethod("Raw Token in Header", 
      Uri.parse('$baseUrl/public/getcustomerdetails'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
        'Accept': 'application/json',
      }
    );
    
    // Test 3: Token in Query Parameter
    await _testAuthMethod("Token in Query Parameter", 
      Uri.parse('$baseUrl/public/getcustomerdetails?token=$token'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
    );
    
    // Test 4: X-Auth-Token Header
    await _testAuthMethod("X-Auth-Token Header", 
      Uri.parse('$baseUrl/public/getcustomerdetails'),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,
        'Accept': 'application/json',
      }
    );
    
    // Test 5: Basic Auth with token as password
    await _testAuthMethod("Basic Auth", 
      Uri.parse('$baseUrl/public/getcustomerdetails'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $token',
        'Accept': 'application/json',
      }
    );
    
    // Test 6: Cookie-based auth (using the cookie from response)
    final cookieResponse = await http.get(
      Uri.parse('$baseUrl/public/getcustomerdetails'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (cookieResponse.headers['set-cookie'] != null) {
      final cookie = cookieResponse.headers['set-cookie']!;
      await _testAuthMethod("Cookie Authentication", 
        Uri.parse('$baseUrl/public/getcustomerdetails'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookie,
          'Accept': 'application/json',
        }
      );
    }
  }
  
  static Future<void> _testAuthMethod(String methodName, Uri url, {Map<String, String>? headers}) async {
    try {
      print("\n🔍 Testing: $methodName");
      print("URL: $url");
      print("Headers: $headers");
      
      final response = await http.get(url, headers: headers).timeout(Duration(seconds: 10));
      
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print("✅ SUCCESS: $methodName WORKS!");
        } else {
          print("❌ API Error: ${data['error'] ?? data['message']}");
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }
}