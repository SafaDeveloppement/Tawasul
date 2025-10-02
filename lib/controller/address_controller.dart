import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/model/address_model.dart';
import 'package:tawasul_application/model/state_model..dart';

class AddressController {
  static const String baseUrl = 'https://tawasul-dev.app-staging.fr';
  static const int timeoutSeconds = 30;

  // Helper method to get auth headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

 /* ------------------------- CREATE ADDRESS ------------------------- */
static Future<Map<String, dynamic>> createAddress(AddressModel address) async {
  try {
    // Build query parameters
    final Map<String, String> queryParams = {
      'firstname': address.firstname,
      'lastname': address.lastname,
      'address1': address.address1,
      'city': address.city,
      'postcode': address.postcode,
      'id_state': address.idState.toString(),
    };

    // Add optional parameters
    if (address.phone != null && address.phone!.isNotEmpty) {
      queryParams['phone'] = address.phone!;
    }
    if (address.address2 != null && address.address2!.isNotEmpty) {
      queryParams['address2'] = address.address2!;
    }
    if (address.alias != null && address.alias!.isNotEmpty) {
      queryParams['alias'] = address.alias!;
    }

    final Uri uri = Uri.parse('$baseUrl/public/createaddress')
        .replace(queryParameters: queryParams);

    print(" Address Controller - Creating address: $uri");

    final response = await http.post(
      uri,
      headers: await _getAuthHeaders(),
    ).timeout(Duration(seconds: timeoutSeconds));

    print(" Create Address Response Status: ${response.statusCode}");
    print(" Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final createdAddress = AddressModel.fromApiResponse(responseData);
        print(" Address created successfully: ${createdAddress.id}");
        
        return {
          'success': true,
          'message': responseData['message'] ?? 'Address created successfully',
          'address': createdAddress,
          'addressId': responseData['id_address'] ?? createdAddress.id,
        };
      } else {
        print("❌ Address creation failed: ${responseData['error'] ?? responseData['message']}");
        
        // Handle token errors specifically
        if (responseData['error']?.toString().contains('Token') == true ||
            responseData['error']?.toString().contains('token') == true) {
          return {
            'success': false,
            'message': 'Authentication failed. Please login again.',
            'code': 'AUTH_FAILED'
          };
        }
        
        return {
          'success': false,
          'message': responseData['error'] ?? responseData['message'] ?? 'Failed to create address',
        };
      }
    } else {
      print("❌ HTTP Error: ${response.statusCode}");
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    print("💥 Error in AddressController.createAddress: $e");
    return {
      'success': false,
      'message': 'Failed to connect to server: $e',
    };
  }
}

  /* ------------------------- GET STATES ------------------------- */
  static Future<Map<String, dynamic>> getStates() async {
    try {
      final Uri uri = Uri.parse('$baseUrl/public/getstates');
      
      print(" Address Controller - Fetching states from: $uri");

      final response = await http.get(
        uri,
        headers: await _getAuthHeaders(),
      ).timeout(Duration(seconds: timeoutSeconds));

      print(" Get States Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['states'] != null) {
          final List<StateModel> states = (responseData['states'] as List)
              .map((stateJson) => StateModel.fromJson(stateJson))
              .toList();
          
          print(" ${states.length} states loaded successfully");
          
          return {
            'success': true,
            'states': states,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to fetch states',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("💥 Error in AddressController.getStates: $e");
      return {
        'success': false,
        'message': 'Failed to connect to server: $e',
      };
    }
  }

  /* ------------------------- GET CUSTOMER ADDRESSES ------------------------- */
  static Future<Map<String, dynamic>> getCustomerAddresses(int customerId) async {
    try {
      // Note: You might need to implement this endpoint
      final Uri uri = Uri.parse('$baseUrl/public/getcustomeraddresses')
          .replace(queryParameters: {'id_customer': customerId.toString()});

      final response = await http.get(
        uri,
        headers: await _getAuthHeaders(),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['addresses'] != null) {
          final List<AddressModel> addresses = (responseData['addresses'] as List)
              .map((addressJson) => AddressModel.fromJson(addressJson))
              .toList();
          
          return {
            'success': true,
            'addresses': addresses,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'No addresses found',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("💥 Error in AddressController.getCustomerAddresses: $e");
      return {
        'success': false,
        'message': 'Failed to fetch addresses: $e',
      };
    }
  }

  /* ------------------------- VALIDATE ADDRESS DATA ------------------------- */
  static Map<String, dynamic> validateAddressData({
    required String firstname,
    required String lastname,
    required String address1,
    required String city,
    required String postcode,
    required int idState,
    String? phone,
  }) {
    final errors = <String>[];

    if (firstname.isEmpty) errors.add('First name is required');
    if (lastname.isEmpty) errors.add('Last name is required');
    if (address1.isEmpty) errors.add('Address is required');
    if (city.isEmpty) errors.add('City is required');
    if (postcode.isEmpty) errors.add('Postcode is required');
    if (idState == 0) errors.add('State is required');
    
    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      errors.add('Please enter a valid phone number');
    }

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'message': errors.isEmpty ? 'Valid' : errors.join(', '),
    };
  }

  static bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return phoneRegex.hasMatch(phone);
  }
}