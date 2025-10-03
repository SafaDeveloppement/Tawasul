import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalAddressService {
  static const String _addressesKey = 'local_addresses';
  
  static Future<List<Map<String, dynamic>>> getLocalAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = prefs.getString(_addressesKey);
      
      if (addressesJson != null) {
        final List<dynamic> addressesList = json.decode(addressesJson);
        return addressesList.cast<Map<String, dynamic>>();
      }
      
      return [];
    } catch (e) {
      print('Error reading local addresses: $e');
      return [];
    }
  }
  
  static Future<Map<String, dynamic>> saveLocalAddress(Map<String, dynamic> addressData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> existingAddresses = await getLocalAddresses();
      
      // Generate a local ID (negative to distinguish from API IDs)
      final localId = -DateTime.now().millisecondsSinceEpoch;
      
      final newAddress = {
        ...addressData,
        'id': localId,
        'id_address': localId,
        'id_customer': addressData['id_customer'] ?? 1, // Use provided customer ID or default
        'is_local': true,
        'created_at': DateTime.now().toIso8601String(),
        'country': 'Libya', // Default country
        'state': _getStateName(addressData['idState']), // You might need to map this
      };
      
      existingAddresses.add(newAddress);
      
      await prefs.setString(_addressesKey, json.encode(existingAddresses));
      
      print('✅ Local address saved with ID: $localId');
      print('📝 Address data: $newAddress');
      
      return {
        'success': true,
        'message': 'Address saved locally',
        'address': newAddress,
        'addressId': localId,
      };
    } catch (e) {
      print('💥 Error saving local address: $e');
      return {
        'success': false,
        'message': 'Failed to save address locally: $e',
      };
    }
  }
  
  static String _getStateName(int? stateId) {
    // You can map state IDs to names here if needed
    return 'State $stateId';
  }
  
  static Future<void> clearLocalAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_addressesKey);
    } catch (e) {
      print('Error clearing local addresses: $e');
    }
  }
  static Future<void> storeAddresses(List<dynamic> addresses) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = json.encode(addresses);
    await prefs.setString('customer_addresses', addressesJson);
    print("💾 ${addresses.length} addresses stored locally");
  } catch (e) {
    print("❌ Error storing addresses: $e");
  }
}
}