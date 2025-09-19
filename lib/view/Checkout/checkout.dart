// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/Provider/cart_provider.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/Services/user_data_services.dart';
// import 'package:tawasul_application/view/Checkout/address_selection.dart';
// import 'package:tawasul_application/view/map/map.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';

// extension StringExtensions on String {
//   bool isNumeric() {
//     return double.tryParse(this) != null;
//   }
// }

// class Checkout extends StatefulWidget {
//   const Checkout({Key? key}) : super(key: key);

//   @override
//   State<Checkout> createState() => _CheckoutState();
// }

// class _CheckoutState extends State<Checkout> {
//   bool isBillingSame = true;
//   String? selectedCity;
//   Map<String, dynamic>? _selectedLocation;
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController additionalAddressController =
//       TextEditingController();
//   final TextEditingController zipCodeController = TextEditingController();
//   bool _isLoading = false;
//   bool _userDataLoaded = false;

//   String _customerEmail = "";
//   int _customerId = 0;
//   final int _shopId = 4;
//   final int _carrierId = 1;
//   String _cartId = '0';

//   final Map<String, String> _cityZipCodes = {
//     // Libyan Cities
//     'Tripoli': '11011',
//     'Benghazi': '21011',
//     'Misrata': '22011',
//     'Bayda': '21012',
//     'Zawiya': '11012',
//     'Zliten': '22012',
//     'Ajdabiya': '21013',
//     'Gharyan': '11013',
//     'Sabha': '31011',
//     'Derna': '21014',
//     'Tobruk': '21015',
//     'Sirte': '22013',
//     'Bani Walid': '22014',
//     'Tarhuna': '11014',
//     'Al Khums': '22015',
//     'Zuwara': '11015',
//     'Yafran': '11016',
//     'Nalut': '11017',
//     'Ghat': '31012',
//     'Jadu': '11018',
//     'Murzuk': '31013',
//     'Kufra': '32011',

//     // Tunisian Cities
//     'Sousse': '4000',
//     'Tunis': '1000',
//     'Sfax': '3000',
//     'Djerba': '4100',
//     'Monastir': '5000',
//     'Mahdia': '5100',
//     'Kairouan': '3100',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//     _loadCustomerIdAndEmail().then((_) {
//       _loadUserInfo().catchError(_handleApiError);
//     });
//     _loadCartId();
//   }

//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final userId = prefs.getInt('user_id');

//     print("=== LOGIN STATUS CHECK ===");
//     print("Auth Token: $token");
//     print("User ID: $userId");
//     print("==========================");
//   }

//   Future<Map<String, dynamic>?> _getUserDataFromApi() async {
//     try {
//       return await ApiService.getCustomerDetails();
//     } catch (e) {
//       print("Error fetching user data from API: $e");
//       return null;
//     }
//   }

//   void _handleApiError(dynamic error) {
//     print("API Error: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Failed to load user information. Please try again."),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _refreshUserData() async {
//     setState(() {
//       _userDataLoaded = false;
//     });
//     await _loadUserInfo();
//   }

//   Future<void> _loadCustomerIdAndEmail() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Get user data from SharedPreferences
//       int? userId = prefs.getInt('user_id');
//       String? userEmail = prefs.getString('user_email');

//       setState(() {
//         _customerId = userId ?? 0;
//         _customerEmail = userEmail ?? "";
//       });

//       print("Customer ID and email loaded: $_customerId, $_customerEmail");
//     } catch (e) {
//       print('Error loading customer ID and email: $e');
//       setState(() {
//         _customerId = 0;
//         _customerEmail = "";
//       });
//     }
//   }

//   Future<void> _loadUserInfo() async {
//     try {
//       print("Loading user info...");

//       // First try to get user data from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final firstName = prefs.getString('user_firstName') ?? '';
//       final lastName = prefs.getString('user_lastName') ?? '';
//       final phone = prefs.getString('user_phone') ?? '';
//       final email = prefs.getString('user_email') ?? '';

//       print(
//         "SharedPreferences values: firstName=$firstName, lastName=$lastName, phone=$phone, email=$email",
//       );

//       // If we have data in SharedPreferences, use it
//       if (firstName.isNotEmpty || lastName.isNotEmpty || phone.isNotEmpty) {
//         setState(() {
//           firstNameController.text = firstName;
//           lastNameController.text = lastName;
//           phoneController.text = phone;
//           _customerEmail = email.isNotEmpty ? email : _customerEmail;
//           _userDataLoaded = true;
//         });
//         print("User data loaded from SharedPreferences");
//         return;
//       }

//       // If no data in SharedPreferences, try to get from API
//       print("No user data in SharedPreferences, trying API...");
//       final userData = await ApiService.getCustomerDetails();
//       print("API response: $userData");

//       if (userData != null && userData.isNotEmpty) {
//         setState(() {
//           firstNameController.text = userData['firstName'] ?? '';
//           lastNameController.text = userData['lastName'] ?? '';
//           phoneController.text = userData['mobile'] ?? '';
//           _customerEmail = userData['email'] ?? _customerEmail;
//           _userDataLoaded = true;
//         });

//         print("User data loaded from API: $userData");

//         await UserDataService.storeUserData(
//           firstName: userData['firstName'] ?? '',
//           lastName: userData['lastName'] ?? '',
//           phone: userData['mobile'] ?? '',
//           email: userData['email'] ?? _customerEmail,
//         );
//       } else {
//         print("No user data found anywhere");
//         setState(() {
//           _userDataLoaded = true;
//         });
//       }
//     } catch (e) {
//       print("Error loading user data: $e");
//       setState(() {
//         _userDataLoaded = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     additionalAddressController.dispose();
//     zipCodeController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadCartId() async {
//     try {
//       final cartResponse = await ApiService.getCart(_shopId);
//       if (cartResponse['message'] == 'success' &&
//           cartResponse['response'] != null) {
//         setState(() {
//           _cartId =
//               cartResponse['response']['cart_summary']['idCart']?.toString() ??
//               '0';
//         });
//       }
//     } catch (e) {
//       print('Error loading cart ID: $e');
//     }
//   }

//   void _updateAddressFromLocation(Map<String, dynamic> location) {
//     setState(() {
//       _selectedLocation = location;
//       final String displayAddress = _getDisplayAddress(location);
//       _selectedLocation = {...location, 'displayAddress': displayAddress};

//       String? cityFromLocation = location['city'];
//       String? zipCodeFromLocation = location['zipCode'];

//       if (cityFromLocation != null && cityFromLocation.isNotEmpty) {
//         selectedCity = cityFromLocation;
//       }

//       String finalZipCode = '';
//       if (zipCodeFromLocation != null && zipCodeFromLocation.isNotEmpty) {
//         finalZipCode = zipCodeFromLocation;
//       } else if (selectedCity != null && selectedCity!.isNotEmpty) {
//         finalZipCode = _getZipCodeForCity(selectedCity!);
//       }

//       if (finalZipCode.isNotEmpty) {
//         zipCodeController.text = finalZipCode;
//       }

//       // Set the Address field
//       addressController.text = displayAddress;
//     });
//   }

//   String _getDisplayAddress(Map<String, dynamic> location) {
//     final String? fullAddress = location['address'];
//     final String? city = location['city'];
//     if (fullAddress == null) return "Selected Location";
//     if (city == null) return fullAddress;

//     if (fullAddress.contains(city)) {
//       final parts = fullAddress.split(',');
//       for (int i = 0; i < parts.length; i++) {
//         final part = parts[i].trim();
//         if (part.contains(city) && i > 0) {
//           return '${parts[i - 1].trim()}, $city';
//         }
//       }
//     }

//     return city;
//   }

//   Widget _buildLocationPicker() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black45),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedLocation?['displayAddress'] ?? "Choose your location",
//           style: TextStyle(
//             color: _selectedLocation != null ? Colors.black : Colors.black54,
//           ),
//         ),
//         trailing: const Icon(Icons.my_location),
//         onTap: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const InternationalMapScreen(),
//             ),
//           );

//           if (result != null && mounted) {
//             _updateAddressFromLocation(result);
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ShoppingCart()),
//               );
//             },
//             child: Container(
//               width: 40.w,
//               height: 40.w,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF008AD2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 20.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text("Checkout", style: TextStyle(color: Colors.black)),
//       ),
//       body:
//           _userDataLoaded
//               ? _buildContent()
//               : Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "ADD YOUR DETAILS",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           const Text("Delivery address:"),
//           const SizedBox(height: 10),
//           _buildTextField("First name", controller: firstNameController),
//           _buildTextField("Last name", controller: lastNameController),
//           _buildTextField(
//             "Phone number",
//             controller: phoneController,
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 20),
//           const Text("Set your localisation"),
//           const SizedBox(height: 10),
//           _buildLocationPicker(),
//           const SizedBox(height: 20),
//           const Text("Or set all your information below"),
//           const SizedBox(height: 10),
//           _buildTextField("Address", controller: addressController),
//           _buildTextField(
//             "Additional address",
//             controller: additionalAddressController,
//             hint: "Additional address (optional)",
//           ),
//           Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: SizedBox(height: 65, child: _buildDropdownCity()),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 flex: 2,
//                 child: _buildTextField(
//                   "Zip code",
//                   controller: zipCodeController,
//                   hint: "Zip code",
//                   readOnly: true,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildBillingCheckbox(),
//           const SizedBox(height: 30),
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : _buildValidateButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label, {
//     String? hint,
//     TextInputType? keyboardType,
//     bool readOnly = false,
//     required TextEditingController controller,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: readOnly,
//         decoration: InputDecoration(
//           hintText: hint ?? label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownCity() {
//     List<String> cities = _cityZipCodes.keys.toList()..sort();

//     if (selectedCity != null &&
//         selectedCity!.isNotEmpty &&
//         !cities.contains(selectedCity)) {
//       cities.add(selectedCity!);
//       cities.sort();
//     }

//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         isDense: true,
//       ),
//       hint: const Text("City"),
//       value: selectedCity,
//       onChanged: (value) {
//         setState(() {
//           selectedCity = value;
//           if (value != null) {
//             final zipCode = _getZipCodeForCity(value);
//             zipCodeController.text = zipCode;
//           } else {
//             zipCodeController.clear();
//           }
//         });
//       },
//       items:
//           cities.map((city) {
//             return DropdownMenuItem(value: city, child: Text(city));
//           }).toList(),
//     );
//   }

//   String _getZipCodeForCity(String city) {
//     final normalizedCity = city.trim();
//     return _cityZipCodes[normalizedCity] ?? '';
//   }

//   Widget _buildBillingCheckbox() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black26),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Checkbox(
//             value: isBillingSame,
//             onChanged: (val) {
//               setState(() {
//                 isBillingSame = val ?? true;
//               });
//             },
//             activeColor: Colors.orange,
//           ),
//           const Expanded(
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "MY BILLING ADDRESS\n",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: "is the same as my delivery address"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildValidateButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF008AD2),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddressSelection()),
//             ),
//         child: Text(
//           "Validate and continue",
//           style: TextStyle(fontSize: 16, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Future<void> _validateAndContinue() async {
//     if (_customerId == 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please login first")));
//       return;
//     }

//     final address =
//         _selectedLocation != null
//             ? _selectedLocation!['address']
//             : addressController.text;

//     if (phoneController.text.isEmpty || !phoneController.text.isNumeric()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid phone number")),
//       );
//       return;
//     }

//     final hasLocation = _selectedLocation != null;
//     final hasManualAddress = addressController.text.isNotEmpty;

//     if (!hasLocation && !hasManualAddress) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select location or enter address"),
//         ),
//       );
//       return;
//     }

//     if (firstNameController.text.isEmpty ||
//         lastNameController.text.isEmpty ||
//         selectedCity == null ||
//         zipCodeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all required fields")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final addressId = await _createAddressAndGetId();

//       if (addressId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to create address")),
//         );
//         return;
//       }

//       final cartUpdated = await _updateCartWithAddress(addressId);

//       if (cartUpdated) {
//         final checkoutData = {
//           'firstName': firstNameController.text,
//           'lastName': lastNameController.text,
//           'phone': phoneController.text,
//           'address': address,
//           'additionalAddress': additionalAddressController.text,
//           'city': selectedCity,
//           'zipCode': zipCodeController.text,
//           'location': _selectedLocation,
//           'isBillingSame': isBillingSame,
//           'addressId': addressId,
//         };

//         print("Checkout data: $checkoutData");

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => AddressSelection()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to update cart with address")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<int?> _createAddressAndGetId() async {
//     try {
//       final addressData = {
//         'firstname': firstNameController.text,
//         'lastname': lastNameController.text,
//         'phone': phoneController.text,
//         'address1':
//             _selectedLocation != null
//                 ? _selectedLocation!['address']
//                 : addressController.text,
//         'address2': additionalAddressController.text,
//         'city': selectedCity,
//         'postcode': zipCodeController.text,
//         'id_country':
//             _selectedLocation?['country'] != null
//                 ? await _getCountryId(_selectedLocation!['country'])
//                 : 1,
//         'id_customer': _customerId,
//         'alias': 'Home Address',
//       };

//       final response = await ApiService.createAddress(addressData);

//       if (response['status'] == 'success' || response['message'] == 'success') {
//         return response['response']['id_address'] as int?;
//       }

//       return null;
//     } catch (e) {
//       print('Error creating address: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Address creation failed: $e")));
//       return null;
//     }
//   }

//   Future<int> _getCountryId(String countryName) async {
//     return 1;
//   }

//   Future<bool> _updateCartWithAddress(int addressId) async {
//     try {
//       final cartProvider = Provider.of<CartProvider>(context, listen: false);

//       final cartDetails =
//           cartProvider.cartItems.map((item) {
//             return {
//               "code": item.product.reference,
//               "quantity": item.quantity,
//               "operator": "up",
//             };
//           }).toList();

//       final response = await ApiService.updateCart(
//         shopId: _shopId,
//         cartId: _cartId,
//         customerId: _customerId,
//         customerEmail: _customerEmail,
//         cartDetails: cartDetails,
//         addressDeliveryId: addressId,
//         addressInvoiceId:
//             isBillingSame ? addressId : await _getBillingAddressId(addressId),
//         carrierId: _carrierId,
//       );

//       return response['message'] == 'success' ||
//           response['status'] == 'success';
//     } catch (e) {
//       print('Error updating cart with address: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Cart update failed: $e")));
//       return false;
//     }
//   }

//   Future<int> _getBillingAddressId(int deliveryAddressId) async {
//     if (isBillingSame) {
//       return deliveryAddressId;
//     }
//     return deliveryAddressId;
//   }

//   Future<String?> _getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       print("No auth token found in SharedPreferences");
//       return null;
//     }

//     return token;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Provider/cart_provider.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/Services/user_data_services.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/map/map.dart';
import 'package:tawasul_application/view/shopping_cart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StringExtensions on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isBillingSame = true;
  String? selectedCity;
  Map<String, dynamic>? _selectedLocation;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController additionalAddressController =
      TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  bool _isLoading = false;
  bool _userDataLoaded = false;

  String _customerEmail = "";
  int _customerId = 0;
  final int _shopId = 4;
  final int _carrierId = 1;
  String _cartId = '0';

  final Map<String, String> _cityZipCodes = {
    // Libyan Cities
    'Tripoli': '11011',
    'Benghazi': '21011',
    'Misrata': '22011',
    'Bayda': '21012',
    'Zawiya': '11012',
    'Zliten': '22012',
    'Ajdabiya': '21013',
    'Gharyan': '11013',
    'Sabha': '31011',
    'Derna': '21014',
    'Tobruk': '21015',
    'Sirte': '22013',
    'Bani Walid': '22014',
    'Tarhuna': '11014',
    'Al Khums': '22015',
    'Zuwara': '11015',
    'Yafran': '11016',
    'Nalut': '11017',
    'Ghat': '31012',
    'Jadu': '11018',
    'Murzuk': '31013',
    'Kufra': '32011',

    // Tunisian Cities
    'Sousse': '4000',
    'Tunis': '1000',
    'Sfax': '3000',
    'Djerba': '4100',
    'Monastir': '5000',
    'Mahdia': '5100',
    'Kairouan': '3100',
  };

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadCustomerIdAndEmail().then((_) {
      _loadUserInfo().catchError(_handleApiError);
    });
    _loadCartId();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    print("=== LOGIN STATUS CHECK ===");
    print("Auth Token: $token");
    print("User ID: $userId");
    print("==========================");
  }

  Future<Map<String, dynamic>?> _getUserDataFromApi() async {
    try {
      return await ApiService.getCustomerDetails();
    } catch (e) {
      print("Error fetching user data from API: $e");
      return null;
    }
  }

  void _handleApiError(dynamic error) {
    final t = AppLocalizations.of(context)!;
    print("API Error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.failedToLoadUserInfo),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _userDataLoaded = false;
    });
    await _loadUserInfo();
  }

  Future<void> _loadCustomerIdAndEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get user data from SharedPreferences
      int? userId = prefs.getInt('user_id');
      String? userEmail = prefs.getString('user_email');

      setState(() {
        _customerId = userId ?? 0;
        _customerEmail = userEmail ?? "";
      });

      print("Customer ID and email loaded: $_customerId, $_customerEmail");
    } catch (e) {
      print('Error loading customer ID and email: $e');
      setState(() {
        _customerId = 0;
        _customerEmail = "";
      });
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      print("Loading user info...");

      // First try to get user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final firstName = prefs.getString('user_firstName') ?? '';
      final lastName = prefs.getString('user_lastName') ?? '';
      final phone = prefs.getString('user_phone') ?? '';
      final email = prefs.getString('user_email') ?? '';

      print(
        "SharedPreferences values: firstName=$firstName, lastName=$lastName, phone=$phone, email=$email",
      );

      // If we have data in SharedPreferences, use it
      if (firstName.isNotEmpty || lastName.isNotEmpty || phone.isNotEmpty) {
        setState(() {
          firstNameController.text = firstName;
          lastNameController.text = lastName;
          phoneController.text = phone;
          _customerEmail = email.isNotEmpty ? email : _customerEmail;
          _userDataLoaded = true;
        });
        print("User data loaded from SharedPreferences");
        return;
      }

      // If no data in SharedPreferences, try to get from API
      print("No user data in SharedPreferences, trying API...");
      final userData = await ApiService.getCustomerDetails();
      print("API response: $userData");

      if (userData != null && userData.isNotEmpty) {
        setState(() {
          firstNameController.text = userData['firstName'] ?? '';
          lastNameController.text = userData['lastName'] ?? '';
          phoneController.text = userData['mobile'] ?? '';
          _customerEmail = userData['email'] ?? _customerEmail;
          _userDataLoaded = true;
        });

        print("User data loaded from API: $userData");

        await UserDataService.storeUserData(
          firstName: userData['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          phone: userData['mobile'] ?? '',
          email: userData['email'] ?? _customerEmail,
        );
      } else {
        print("No user data found anywhere");
        setState(() {
          _userDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        _userDataLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    additionalAddressController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadCartId() async {
    try {
      final cartResponse = await ApiService.getCart(_shopId);
      if (cartResponse['message'] == 'success' &&
          cartResponse['response'] != null) {
        setState(() {
          _cartId =
              cartResponse['response']['cart_summary']['idCart']?.toString() ??
              '0';
        });
      }
    } catch (e) {
      print('Error loading cart ID: $e');
    }
  }

  void _updateAddressFromLocation(Map<String, dynamic> location) {
    setState(() {
      _selectedLocation = location;
      final String displayAddress = _getDisplayAddress(location);
      _selectedLocation = {...location, 'displayAddress': displayAddress};

      String? cityFromLocation = location['city'];
      String? zipCodeFromLocation = location['zipCode'];

      if (cityFromLocation != null && cityFromLocation.isNotEmpty) {
        selectedCity = cityFromLocation;
      }

      String finalZipCode = '';
      if (zipCodeFromLocation != null && zipCodeFromLocation.isNotEmpty) {
        finalZipCode = zipCodeFromLocation;
      } else if (selectedCity != null && selectedCity!.isNotEmpty) {
        finalZipCode = _getZipCodeForCity(selectedCity!);
      }

      if (finalZipCode.isNotEmpty) {
        zipCodeController.text = finalZipCode;
      }

      // Set the Address field
      addressController.text = displayAddress;
    });
  }

  String _getDisplayAddress(Map<String, dynamic> location) {
    final t = AppLocalizations.of(context)!;

    final String? fullAddress = location['address'];
    final String? city = location['city'];
    if (fullAddress == null) return t.selectedLocation;
    if (city == null) return fullAddress;

    if (fullAddress.contains(city)) {
      final parts = fullAddress.split(',');
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i].trim();
        if (part.contains(city) && i > 0) {
          return '${parts[i - 1].trim()}, $city';
        }
      }
    }

    return city;
  }

  Widget _buildLocationPicker() {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          _selectedLocation?['displayAddress'] ?? t.chooseYourLocation,
          style: TextStyle(
            color: _selectedLocation != null ? Colors.black : Colors.black54,
          ),
        ),
        trailing: const Icon(Icons.my_location),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InternationalMapScreen(),
            ),
          );

          if (result != null && mounted) {
            _updateAddressFromLocation(result);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
            right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(t.checkout, style: TextStyle(color: Colors.black)),
      ),
      body:
          _userDataLoaded
              ? _buildContent()
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildContent() {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addYourDetails, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(t.deliveryAddress),
          const SizedBox(height: 10),
          _buildTextField(t.firstName, controller: firstNameController),
          _buildTextField(t.lastName, controller: lastNameController),
          _buildTextField(
            t.phoneNumber,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Text(t.setYourLocalization),
          const SizedBox(height: 10),
          _buildLocationPicker(),
          const SizedBox(height: 20),
          Text(t.orSetAllYourInformationBelow),
          const SizedBox(height: 10),
          _buildTextField(t.address, controller: addressController),
          _buildTextField(
            t.additionalAddress,
            controller: additionalAddressController,
            hint: t.optional,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(height: 65, child: _buildDropdownCity()),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  t.zipCode,
                  controller: zipCodeController,
                  hint: t.zipCode,
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBillingCheckbox(),
          const SizedBox(height: 30),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildValidateButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint ?? label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownCity() {
    final t = AppLocalizations.of(context)!;

    List<String> cities = _cityZipCodes.keys.toList()..sort();

    if (selectedCity != null &&
        selectedCity!.isNotEmpty &&
        !cities.contains(selectedCity)) {
      cities.add(selectedCity!);
      cities.sort();
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        isDense: true,
      ),
      hint: Text(t.city),
      value: selectedCity,
      onChanged: (value) {
        setState(() {
          selectedCity = value;
          if (value != null) {
            final zipCode = _getZipCodeForCity(value);
            zipCodeController.text = zipCode;
          } else {
            zipCodeController.clear();
          }
        });
      },
      items:
          cities.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
    );
  }

  String _getZipCodeForCity(String city) {
    final normalizedCity = city.trim();
    return _cityZipCodes[normalizedCity] ?? '';
  }

  Widget _buildBillingCheckbox() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isBillingSame,
            onChanged: (val) {
              setState(() {
                isBillingSame = val ?? true;
              });
            },
            activeColor: Colors.orange,
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${t.myBillingAddress}\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: t.isTheSameAsMyDeliveryAddress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    final t = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF008AD2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressSelection()),
            ), // _validateAndContinue
        child: Text(
          t.validateAndContinue,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _validateAndContinue() async {
    final t = AppLocalizations.of(context)!;

    if (_customerId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseLoginFirst)));
      return;
    }

    final address =
        _selectedLocation != null
            ? _selectedLocation!['address']
            : addressController.text;

    if (phoneController.text.isEmpty || !phoneController.text.isNumeric()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseEnterValidPhoneNumber)));
      return;
    }

    final hasLocation = _selectedLocation != null;
    final hasManualAddress = addressController.text.isNotEmpty;

    if (!hasLocation && !hasManualAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pleaseSelectLocationOrEnterAddress)),
      );
      return;
    }

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        selectedCity == null ||
        zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final addressId = await _createAddressAndGetId();

      if (addressId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failedToCreateAddress)));
        return;
      }

      final cartUpdated = await _updateCartWithAddress(addressId);

      if (cartUpdated) {
        final checkoutData = {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phone': phoneController.text,
          'address': address,
          'additionalAddress': additionalAddressController.text,
          'city': selectedCity,
          'zipCode': zipCodeController.text,
          'location': _selectedLocation,
          'isBillingSame': isBillingSame,
          'addressId': addressId,
        };

        print("Checkout data: $checkoutData");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressSelection()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.failedToUpdateCartWithAddress)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${t.anErrorOccurred}: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<int?> _createAddressAndGetId() async {
    final t = AppLocalizations.of(context)!;

    try {
      final addressData = {
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'phone': phoneController.text,
        'address1':
            _selectedLocation != null
                ? _selectedLocation!['address']
                : addressController.text,
        'address2': additionalAddressController.text,
        'city': selectedCity,
        'postcode': zipCodeController.text,
        'id_country':
            _selectedLocation?['country'] != null
                ? await _getCountryId(_selectedLocation!['country'])
                : 1,
        'id_customer': _customerId,
        'alias': t.homeAddress,
      };

      final response = await ApiService.createAddress(addressData);

      if (response['status'] == 'success' || response['message'] == 'success') {
        return response['response']['id_address'] as int?;
      }

      return null;
    } catch (e) {
      print('Error creating address: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${t.addressCreationFailed}: $e")));
      return null;
    }
  }

  Future<int> _getCountryId(String countryName) async {
    return 1;
  }

  Future<bool> _updateCartWithAddress(int addressId) async {
    final t = AppLocalizations.of(context)!;

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      final cartDetails =
          cartProvider.cartItems.map((item) {
            return {
              "code": item.product.reference,
              "quantity": item.quantity,
              "operator": "up",
            };
          }).toList();

      final response = await ApiService.updateCart(
        shopId: _shopId,
        cartId: _cartId,
        customerId: _customerId,
        customerEmail: _customerEmail,
        cartDetails: cartDetails,
        addressDeliveryId: addressId,
        addressInvoiceId:
            isBillingSame ? addressId : await _getBillingAddressId(addressId),
        carrierId: _carrierId,
      );

      return response['message'] == 'success' ||
          response['status'] == 'success';
    } catch (e) {
      print('Error updating cart with address: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${t.cartUpdateFailed}: $e")));
      return false;
    }
  }

  Future<int> _getBillingAddressId(int deliveryAddressId) async {
    if (isBillingSame) {
      return deliveryAddressId;
    }
    return deliveryAddressId;
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print("No auth token found in SharedPreferences");
      return null;
    }

    return token;
  }
}
