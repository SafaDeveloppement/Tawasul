// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/Services/user_data_services.dart';
// import 'package:tawasul_application/view/Checkout/address_selection.dart';
// import 'package:tawasul_application/view/map/map.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
//   int? selectedStateId;
//   Map<String, dynamic>? _selectedLocation;
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController additionalAddressController =
//       TextEditingController();
//   final TextEditingController zipCodeController = TextEditingController();
//   final TextEditingController stateDisplayController =
//       TextEditingController(); // For displaying selected state

//   bool _isLoading = false;
//   bool _userDataLoaded = false;
//   bool _statesLoaded = false;

//   String _customerEmail = "";
//   int _customerId = 0;

//   // States data from API
//   List<dynamic> _states = [];
//   Map<String, int> _stateNameToId = {};
//   Map<int, String> _stateIdToName = {};

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//     _loadCustomerIdAndEmail().then((_) {
//       _loadUserInfo().catchError(_handleApiError);
//     });
//     _loadStates().catchError(_handleApiError);
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

//   void _handleApiError(dynamic error) {
//     final t = AppLocalizations.of(context)!;
//     print("API Error: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(t.failedToLoadUserInfo),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _loadStates() async {
//     try {
//       print("Loading states from API...");
//       final response = await ApiService.getStates();

//       if (response['success'] == true && response['states'] != null) {
//         setState(() {
//           _states = response['states'];
//           _stateNameToId = {};
//           _stateIdToName = {};

//           for (var state in _states) {
//             final stateName = state.name; // Object access
//             final stateId = state.idState; // Object access
//             if (stateName.isNotEmpty) {
//               _stateNameToId[stateName] = stateId;
//               _stateIdToName[stateId] = stateName;
//             }
//           }

//           _statesLoaded = true;
//         });
//         print("${_states.length} states loaded successfully");
//       } else {
//         print("Failed to load states: ${response['message']}");
//         setState(() {
//           _statesLoaded = true;
//         });
//       }
//     } catch (e) {
//       print("Error loading states: $e");
//       setState(() {
//         _statesLoaded = true;
//       });
//     }
//   }

//   Future<void> _loadCustomerIdAndEmail() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
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

//       if (userData != null &&
//           userData.isNotEmpty &&
//           userData['success'] == true) {
//         setState(() {
//           firstNameController.text = userData['firstName'] ?? '';
//           lastNameController.text = userData['lastName'] ?? '';
//           phoneController.text = userData['mobile'] ?? userData['phone'] ?? '';
//           _customerEmail = userData['email'] ?? _customerEmail;
//           _userDataLoaded = true;
//         });

//         print("User data loaded from API: $userData");

//         await UserDataService.storeUserData(
//           firstName: userData['firstName'] ?? '',
//           lastName: userData['lastName'] ?? '',
//           phone: userData['mobile'] ?? userData['phone'] ?? '',
//           email: userData['email'] ?? _customerEmail,
//         );

//         // If user has a state ID from API, pre-select it
//         if (userData['id_state'] != null &&
//             _stateIdToName.containsKey(userData['id_state'])) {
//           setState(() {
//             selectedStateId = userData['id_state'];
//             _updateStateDisplay();
//           });
//         }
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
//     stateDisplayController.dispose();
//     super.dispose();
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
//       }

//       if (finalZipCode.isNotEmpty) {
//         zipCodeController.text = finalZipCode;
//       }

//       addressController.text = displayAddress;
//     });
//   }

//   // Method to update state display text in the additional address field
//   void _updateStateDisplay() {
//     if (selectedStateId != null &&
//         _stateIdToName.containsKey(selectedStateId)) {
//       final selectedStateName = _stateIdToName[selectedStateId]!;

//       // Update the additional address field with the state name
//       if (additionalAddressController.text.isEmpty) {
//         additionalAddressController.text = "State: $selectedStateName";
//       } else {
//         // If there's already text, append the state
//         final currentText = additionalAddressController.text;
//         if (!currentText.contains("State:")) {
//           additionalAddressController.text =
//               "$currentText | State: $selectedStateName";
//         }
//       }
//     }
//   }

//   String _getDisplayAddress(Map<String, dynamic> location) {
//     final t = AppLocalizations.of(context)!;

//     final String? fullAddress = location['address'];
//     final String? city = location['city'];
//     if (fullAddress == null) return t.selectedLocation;
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
//     final t = AppLocalizations.of(context)!;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black45),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedLocation?['displayAddress'] ?? t.chooseYourLocation,
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
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(
//             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
//             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
//           ),
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
//         title: Text(t.checkout, style: TextStyle(color: Colors.black)),
//       ),
//       body:
//           _userDataLoaded && _statesLoaded
//               ? _buildContent()
//               : Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildContent() {
//     final t = AppLocalizations.of(context)!;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(t.addYourDetails, style: TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           Text(t.deliveryAddress),
//           const SizedBox(height: 10),
//           _buildTextField(t.firstName, controller: firstNameController),
//           _buildTextField(t.lastName, controller: lastNameController),
//           _buildTextField(
//             t.phoneNumber,
//             controller: phoneController,
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 20),
//           Text(t.setYourLocalization),
//           const SizedBox(height: 10),
//           _buildLocationPicker(),
//           const SizedBox(height: 20),
//           Text(t.orSetAllYourInformationBelow),
//           const SizedBox(height: 10),
//           _buildTextField(t.address, controller: addressController),

//           // Additional Address field - will display state automatically
//           _buildTextField(
//             t.additionalAddress,
//             controller: additionalAddressController,
//             hint: t.optional,
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
//                   t.zipCode,
//                   controller: zipCodeController,
//                   hint: t.zipCode,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildStateDropdown(),
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
//           labelText: label,
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
//     final t = AppLocalizations.of(context)!;

//     // Get unique cities from states
//     final List<String> cities =
//         _states
//             .map<String>((state) => state.name) // Explicitly map to String
//             .where((city) => city.isNotEmpty)
//             .toSet()
//             .toList()
//           ..sort();

//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         isDense: true,
//         hintText: t.city,
//       ),
//       value: selectedCity,
//       onChanged: (String? value) {
//         // Add String? type
//         setState(() {
//           selectedCity = value;
//           if (value != null) {
//             // Auto-select the corresponding state
//             selectedStateId = _stateNameToId[value];
//             _updateStateDisplay();
//           }
//         });
//       },
//       items:
//           cities.map<DropdownMenuItem<String>>((String city) {
//             // Explicit type
//             return DropdownMenuItem<String>(value: city, child: Text(city));
//           }).toList(),
//     );
//   }

//   Widget _buildStateDropdown() {
//     final t = AppLocalizations.of(context)!;

//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         isDense: true,
//         hintText: t.state,
//       ),
//       value: selectedStateId,
//       onChanged: (int? value) {
//         // Add int? type
//         setState(() {
//           selectedStateId = value;
//           if (value != null) {
//             // Auto-select the corresponding city
//             selectedCity = _stateIdToName[value];
//             _updateStateDisplay();
//           }
//         });
//       },
//       items:
//           _states.map<DropdownMenuItem<int>>((state) {
//             // Explicit type
//             final stateId = state.idState;
//             final stateName = state.name;
//             return DropdownMenuItem<int>(
//               value: stateId,
//               child: Text(stateName),
//             );
//           }).toList(),
//     );
//   }

//   Widget _buildBillingCheckbox() {
//     final t = AppLocalizations.of(context)!;

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
//           Expanded(
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "${t.myBillingAddress}\n",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: t.isTheSameAsMyDeliveryAddress),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildValidateButton() {
//     final t = AppLocalizations.of(context)!;

//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF008AD2),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed: _isLoading ? null : _validateAndContinue,
//         child:
//             _isLoading
//                 ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                 : Text(
//                   t.validateAndContinue,
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//       ),
//     );
//   }

//   Future<void> _validateAndContinue() async {
//     final t = AppLocalizations.of(context)!;

//     if (_customerId == 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.pleaseLoginFirst)));
//       return;
//     }

//     // Validate required fields
//     if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
//       return;
//     }

//     if (phoneController.text.isEmpty || !phoneController.text.isNumeric()) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.pleaseEnterValidPhoneNumber)));
//       return;
//     }

//     final hasLocation = _selectedLocation != null;
//     final hasManualAddress = addressController.text.isNotEmpty;

//     if (!hasLocation && !hasManualAddress) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(t.pleaseSelectLocationOrEnterAddress)),
//       );
//       return;
//     }

//     if (selectedCity == null || selectedStateId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.pleaseSelectCityAndState)));
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // CREATE ADDRESS using the form data
//       final addressId = await _createAddressAndGetId();

//       if (addressId == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(t.failedToCreateAddress)));
//         return;
//       }

//       // Prepare checkout data for next screen
//       final checkoutData = {
//         'firstName': firstNameController.text,
//         'lastName': lastNameController.text,
//         'phone': phoneController.text,
//         'address': _getPrimaryAddress(),
//         'additionalAddress': additionalAddressController.text,
//         'city': selectedCity,
//         'stateId': selectedStateId,
//         'stateName': _stateIdToName[selectedStateId],
//         'zipCode': zipCodeController.text,
//         'location': _selectedLocation,
//         'isBillingSame': isBillingSame,
//         'addressId': addressId,
//       };

//       print("✅ Address created successfully with ID: $addressId");
//       print("📦 Checkout data prepared: $checkoutData");

//       // Navigate to next screen (address selection or payment)
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => AddressSelection(
//                 selectedAddressId: addressId,
//                 checkoutData: checkoutData,
//               ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("${t.anErrorOccurred}: ${e.toString()}")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<int?> _createAddressAndGetId() async {
//     final t = AppLocalizations.of(context)!;
//     try {
//       print("📍 Creating address for customer: $_customerId");
//       print("🏙️ City: $selectedCity");
//       print("🗺️ State ID: $selectedStateId");

//       // Create address using the form data
//       final response = await ApiService.createAddress(
//         firstname: firstNameController.text.trim(),
//         lastname: lastNameController.text.trim(),
//         address1: _getPrimaryAddress(),
//         city: selectedCity!,
//         postcode: zipCodeController.text.trim(),
//         idState: selectedStateId!,
//         phone:
//             phoneController.text.trim().isNotEmpty
//                 ? phoneController.text.trim()
//                 : null,
//         address2:
//             additionalAddressController.text.trim().isNotEmpty
//                 ? additionalAddressController.text.trim()
//                 : null,
//       );

//       if (response['success'] == true) {
//         final addressId = response['addressId'] ?? response['id_address'];
//         print("✅ Address created successfully with ID: $addressId");

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(t.addressCreatedSuccessfully),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );

//         return addressId is int
//             ? addressId
//             : int.tryParse(addressId.toString());
//       } else {
//         print("❌ Address creation failed: ${response['message']}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("${t.addressCreationFailed}: ${response['message']}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return null;
//       }
//     } catch (e) {
//       print('💥 Error creating address: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("${t.addressCreationFailed}: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return null;
//     }
//   }

//   String _getPrimaryAddress() {
//     if (_selectedLocation != null && _selectedLocation!['address'] != null) {
//       return _selectedLocation!['address']!;
//     } else if (addressController.text.isNotEmpty) {
//       return addressController.text;
//     } else {
//       return 'Unknown Address';
//     }
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Services/api_debug_service.dart';
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

class CheckoutController {
  final int customerId;
  List<dynamic> addresses = [];
  dynamic selectedAddress;
  bool isLoading = false;
  String errorMessage = '';
  String errorCode = '';
  bool isUsingStoredData = false;

  CheckoutController(this.customerId);

  Future<bool> loadCustomerData() async {
    try {
      isLoading = true;
      errorMessage = '';
      errorCode = '';
      isUsingStoredData = false;

      print("🔄 Loading customer data...");

      // Load customer details
      final customerResponse = await ApiService.getCustomerDetails();
      print("📋 Customer details response: ${customerResponse['success']}");

      if (!customerResponse['success']) {
        errorMessage =
            customerResponse['message'] ?? 'Failed to load customer details';
        errorCode = customerResponse['code'] ?? 'UNKNOWN_ERROR';

        // If authentication failed, clear the token
        if (errorCode == 'AUTH_FAILED' || errorCode == 'NO_TOKEN') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          await prefs.remove('user_id');
        }

        return false;
      }

      // Load customer addresses
      final addressesResponse = await ApiService.getCustomerAddresses();
      print("🏠 Addresses response: ${addressesResponse['success']}");

      if (addressesResponse['success']) {
        addresses = addressesResponse['addresses'] ?? [];
        print("📍 Loaded ${addresses.length} addresses");

        // Auto-select the first address if available
        if (addresses.isNotEmpty) {
          selectedAddress = addresses.first;
        }
      } else {
        // Don't fail completely if addresses fail but customer details worked
        print("⚠️ Failed to load addresses: ${addressesResponse['message']}");
        addresses = [];
      }

      return true;
    } catch (e) {
      errorMessage = 'Failed to load customer data: $e';
      errorCode = 'EXCEPTION';
      print("💥 Exception in loadCustomerData: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }

  // ... rest of your methods remain the same
  Future<bool> createOrUpdateAddress(Map<String, dynamic> addressData) async {
    try {
      isLoading = true;
      errorMessage = '';
      errorCode = '';

      Map<String, dynamic> response;

      if (addressData['id'] != null) {
        // Update existing address
        response = await ApiService.updateAddress(
          idAddress: addressData['id'],
          firstname: addressData['firstname'],
          lastname: addressData['lastname'],
          address1: addressData['address1'],
          city: addressData['city'],
          postcode: addressData['postcode'],
          idState: addressData['idState'],
          phone: addressData['phone'],
          address2: addressData['address2'],
        );
      } else {
        // Create new address
        response = await ApiService.createAddress(
          firstname: addressData['firstname'],
          lastname: addressData['lastname'],
          address1: addressData['address1'],
          city: addressData['city'],
          postcode: addressData['postcode'],
          idState: addressData['idState'],
          phone: addressData['phone'],
          address2: addressData['address2'],
        );
      }

      if (response['success']) {
        // Reload addresses to get the updated list
        await loadCustomerData();
        return true;
      } else {
        errorMessage = response['message'] ?? 'Failed to save address';
        errorCode = response['code'] ?? 'SAVE_ERROR';
        return false;
      }
    } catch (e) {
      errorMessage = 'Failed to save address: $e';
      errorCode = 'EXCEPTION';
      return false;
    } finally {
      isLoading = false;
    }
  }

  void selectAddress(dynamic address) {
    selectedAddress = address;
  }

  bool get hasExistingAddresses => addresses.isNotEmpty;
}

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late CheckoutController _checkoutController;
  bool isBillingSame = true;
  String? selectedCity;
  int? selectedStateId;
  Map<String, dynamic>? _selectedLocation;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController additionalAddressController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController stateDisplayController = TextEditingController();

  bool _isLoading = false;
  bool _userDataLoaded = false;
  bool _statesLoaded = false;
  bool _hasError = false;
  String _errorMessage = '';

  String _customerEmail = "";
  int _customerId = 0;

  // States data from API
  List<dynamic> _states = [];
  Map<String, int> _stateNameToId = {};
  Map<int, String> _stateIdToName = {};

  @override
  void initState() {
    super.initState();
    _debugAuthStatus();
    _testTokenManually();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('user_id') ?? 0;
      final token = prefs.getString('auth_token');

      print("Initializing checkout with customer ID: $customerId");
      print("Auth token available: ${token != null && token.isNotEmpty}");

      if (customerId == 0 || token == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Please login first';
          _userDataLoaded = true;
          _statesLoaded = true;
        });
        return;
      }

      // Test all authentication methods to find which one works
      print("🔄 Testing authentication methods...");
      await ApiDebugService.testAllAuthMethods();

      // For now, proceed with the app using stored data as fallback
      print("🔄 Proceeding with fallback approach...");
      _checkoutController = CheckoutController(customerId);
      await _loadInitialData();
    } catch (e) {
      print("Error initializing controller: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Initialization failed: $e';
        _userDataLoaded = true;
        _statesLoaded = true;
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      // Load states and customer data in parallel
      await Future.wait([_loadStates(), _loadCustomerData()]);
    } catch (e) {
      print("Error loading initial data: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _loadCustomerData() async {
    try {
      await _loadCustomerIdAndEmail();

      final success = await _checkoutController.loadCustomerData();

      if (success && mounted) {
        _populateFormFromExistingData();
      } else if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = _checkoutController.errorMessage;
          _userDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error loading customer data: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load customer data';
        _userDataLoaded = true;
      });
    }
  }

  Future<void> _testTokenManually() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print("❌ No token found");
      return;
    }

    print("🧪 Testing token manually...");
    print("Token: $token");

    try {
      final response = await http.get(
        Uri.parse(
          'https://tawasul-dev.app-staging.fr/public/getcustomerdetails',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("🧪 Manual test response:");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");

      if (response.statusCode == 401) {
        print("❌ Token is rejected by server");
        // The token format might be wrong or the server expects different authentication
      }
    } catch (e) {
      print("🧪 Manual test error: $e");
    }
  }

  void _populateFormFromExistingData() {
    try {
      if (_checkoutController.selectedAddress != null) {
        final address = _checkoutController.selectedAddress;

        setState(() {
          firstNameController.text = address['firstname'] ?? '';
          lastNameController.text = address['lastname'] ?? '';
          phoneController.text =
              address['phone'] ?? address['phone_mobile'] ?? '';
          addressController.text = address['address1'] ?? '';
          cityController.text = address['city'] ?? '';
          zipCodeController.text = address['postcode'] ?? '';
          selectedStateId = address['id_state'];
          selectedCity = address['city'];

          // Update state display
          if (_stateIdToName.containsKey(address['id_state'])) {
            stateDisplayController.text = _stateIdToName[address['id_state']]!;
          }

          _userDataLoaded = true;
        });
      } else {
        // Load basic customer info if no addresses exist
        _loadBasicCustomerInfo();
      }
    } catch (e) {
      print("Error populating form: $e");
      setState(() {
        _userDataLoaded = true;
      });
    }
  }

  Future<void> _loadBasicCustomerInfo() async {
    try {
      final customerData = await ApiService.getCustomerDetails();
      if (customerData['success'] == true && mounted) {
        setState(() {
          firstNameController.text = customerData['firstName'] ?? '';
          lastNameController.text = customerData['lastName'] ?? '';
          phoneController.text =
              customerData['mobile'] ?? customerData['phone'] ?? '';
          _customerEmail = customerData['email'] ?? _customerEmail;
          _userDataLoaded = true;
        });

        // Store user data for future use
        await UserDataService.storeUserData(
          firstName: customerData['firstName'] ?? '',
          lastName: customerData['LastName'] ?? '',
          phone: customerData['mobile'] ?? customerData['phone'] ?? '',
          email: customerData['email'] ?? _customerEmail,
        );
      } else {
        setState(() {
          _userDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error loading basic customer info: $e");
      setState(() {
        _userDataLoaded = true;
      });
    }
  }

  Future<void> _loadStates() async {
    try {
      print("Loading states from API...");
      final response = await ApiService.getStates();

      if (response['success'] == true && response['states'] != null) {
        setState(() {
          _states = response['states'];
          _stateNameToId = {};
          _stateIdToName = {};

          for (var state in _states) {
            final stateName = state.name;
            final stateId = state.idState;
            if (stateName.isNotEmpty) {
              _stateNameToId[stateName] = stateId;
              _stateIdToName[stateId] = stateName;
            }
          }

          _statesLoaded = true;
        });
        print("${_states.length} states loaded successfully");
      } else {
        print("Failed to load states: ${response['message']}");
        setState(() {
          _statesLoaded = true;
          _hasError = true;
          _errorMessage = response['message'] ?? 'Failed to load states';
        });
      }
    } catch (e) {
      print("Error loading states: $e");
      setState(() {
        _statesLoaded = true;
        _hasError = true;
        _errorMessage = 'Failed to load states: $e';
      });
    }
  }

  Future<void> _loadCustomerIdAndEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    additionalAddressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    stateDisplayController.dispose();
    super.dispose();
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
        cityController.text = cityFromLocation;
      }

      String finalZipCode = '';
      if (zipCodeFromLocation != null && zipCodeFromLocation.isNotEmpty) {
        finalZipCode = zipCodeFromLocation;
        zipCodeController.text = finalZipCode;
      }

      addressController.text = displayAddress;
    });
  }

  void _updateStateDisplay() {
    if (selectedStateId != null &&
        _stateIdToName.containsKey(selectedStateId)) {
      final selectedStateName = _stateIdToName[selectedStateId]!;
      stateDisplayController.text = selectedStateName;
    }
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

  Widget _buildAddressSelection() {
    final t = AppLocalizations.of(context)!;

    if (_checkoutController.addresses.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.selectExistingAddress,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
        ..._checkoutController.addresses
            .map(
              (address) => Card(
                child: ListTile(
                  title: Text(_getAddressDisplayText(address)),
                  subtitle: Text(
                    '${address['firstname']} ${address['lastname']}',
                  ),
                  trailing: Radio<dynamic>(
                    value: address,
                    groupValue: _checkoutController.selectedAddress,
                    onChanged: (dynamic value) {
                      if (value != null) {
                        setState(() {
                          _checkoutController.selectAddress(value);
                          _populateFormFromExistingData();
                        });
                      }
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _checkoutController.selectAddress(address);
                      _populateFormFromExistingData();
                    });
                  },
                ),
              ),
            )
            .toList(),
        SizedBox(height: 20),
        Divider(),
        SizedBox(height: 10),
        Text(
          t.orAddNewAddress,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  String _getAddressDisplayText(Map<String, dynamic> address) {
    return '${address['address1'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['postcode'] ?? ''}';
  }

  Widget _buildErrorWidget() {
    final t = AppLocalizations.of(context)!;

    // Check if it's an authentication error
    final isAuthError =
        _errorMessage.toLowerCase().contains('login') ||
        _errorMessage.toLowerCase().contains('authentication') ||
        _errorMessage.toLowerCase().contains('token');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAuthError ? Icons.login : Icons.error_outline,
              size: 64,
              color: isAuthError ? Colors.orange : Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: isAuthError ? Colors.orange : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (isAuthError)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _navigateToLogin,
                    child: Text(t.loginAgain),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ElevatedButton(onPressed: _retryLoading, child: Text(t.retry)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingCart()),
                );
              },
              child: Text(t.backToCart),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() async {
    // Clear all stored auth data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    await prefs.remove('user_phone');

    // Navigate to login screen - replace with your actual login route
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _retryLoading() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _userDataLoaded = false;
      _statesLoaded = false;
      _isLoading = false;
    });
    _initializeController();
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
              Navigator.pushReplacement(
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
          _hasError
              ? _buildErrorWidget()
              : _userDataLoaded && _statesLoaded
              ? _buildContent()
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(t.loading),
                  ],
                ),
              ),
    );
  }

  Widget _buildContent() {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_checkoutController.isUsingStoredData)
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Using stored information. Some data may not be up to date.",
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
          // Show address selection for existing customers
          if (_checkoutController.hasExistingAddresses)
            _buildAddressSelection(),

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
                child: _buildTextField(t.city, controller: cityController),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  t.zipCode,
                  controller: zipCodeController,
                  hint: t.zipCode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildStateDropdown(),
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
          labelText: label,
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

  Widget _buildStateDropdown() {
    final t = AppLocalizations.of(context)!;

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        isDense: true,
        hintText: t.state,
      ),
      value: selectedStateId,
      onChanged: (int? value) {
        setState(() {
          selectedStateId = value;
          if (value != null) {
            _updateStateDisplay();
          }
        });
      },
      items:
          _states.map<DropdownMenuItem<int>>((state) {
            final stateId = state.idState;
            final stateName = state.name;
            return DropdownMenuItem<int>(
              value: stateId,
              child: Text(stateName),
            );
          }).toList(),
    );
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
        onPressed: _isLoading ? null : _validateAndContinue,
        child:
            _isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
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

    // Validate required fields
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
      return;
    }

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

    if (cityController.text.isEmpty || selectedStateId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseSelectCityAndState)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save or update address
      final success = await _saveOrUpdateAddress();

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_checkoutController.errorMessage)),
        );
        return;
      }

      // Prepare checkout data for next screen
      final checkoutData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneController.text,
        'address': _getPrimaryAddress(),
        'additionalAddress': additionalAddressController.text,
        'city': cityController.text,
        'stateId': selectedStateId,
        'stateName': _stateIdToName[selectedStateId],
        'zipCode': zipCodeController.text,
        'location': _selectedLocation,
        'isBillingSame': isBillingSame,
        'addressId':
            _checkoutController.selectedAddress?['id_address'] ??
            _checkoutController.selectedAddress?['id'],
      };

      print("✅ Address saved successfully");
      print("📦 Checkout data prepared: $checkoutData");

      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AddressSelection(
                selectedAddressId:
                    _checkoutController.selectedAddress?['id_address'] ??
                    _checkoutController.selectedAddress?['id'],
                checkoutData: checkoutData,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${t.anErrorOccurred}: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _saveOrUpdateAddress() async {
    final addressData = {
      'id':
          _checkoutController.selectedAddress?['id_address'] ??
          _checkoutController.selectedAddress?['id'],
      'firstname': firstNameController.text.trim(),
      'lastname': lastNameController.text.trim(),
      'address1': _getPrimaryAddress(),
      'city': cityController.text.trim(),
      'postcode': zipCodeController.text.trim(),
      'idState': selectedStateId!,
      'phone':
          phoneController.text.trim().isNotEmpty
              ? phoneController.text.trim()
              : null,
      'address2':
          additionalAddressController.text.trim().isNotEmpty
              ? additionalAddressController.text.trim()
              : null,
    };

    return await _checkoutController.createOrUpdateAddress(addressData);
  }

  String _getPrimaryAddress() {
    if (_selectedLocation != null && _selectedLocation!['address'] != null) {
      return _selectedLocation!['address']!;
    } else if (addressController.text.isNotEmpty) {
      return addressController.text;
    } else {
      return 'Unknown Address';
    }
  }

  Future<void> _debugAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    print("=== AUTH DEBUG INFO ===");
    print("User ID: $userId");
    print("Token exists: ${token != null}");
    print("Token length: ${token?.length ?? 0}");
    print(
      "Token preview: ${token != null ? '${token.substring(0, min(20, token.length))}...' : 'null'}",
    );
    print("======================");
  }
}
