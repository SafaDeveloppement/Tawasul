import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/address_model.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';
import 'package:tawasul_application/view/Checkout/delivery_methode.dart';
import 'address_form_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class AddressSelection extends StatefulWidget {
//   final int? selectedAddressId;
//   final Map<String, dynamic>? checkoutData;

//   const AddressSelection({Key? key, this.selectedAddressId, this.checkoutData})
//     : super(key: key);

//   @override
//   State<AddressSelection> createState() => _AddressSelectionState();
// }

// class _AddressSelectionState extends State<AddressSelection> {
//   Map<String, dynamic>? customer;
//   List<dynamic> addresses = [];
//   String? selectedDeliveryAddress;
//   String? selectedShippingAddress;
//   bool _isLoading = true;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     print("AddressSelection initState called");
//     print(" Initial selectedAddressId: ${widget.selectedAddressId}");
//     print(" Initial checkoutData: ${widget.checkoutData}");

//     _fetchCustomer();
//     _fetchAddresses();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([_fetchCustomer(), _fetchAddresses()]);
//     } catch (e) {
//       print(" INITIALIZATION ERROR: $e");
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//     }
//   }

// void _autoSelectAddresses() {
//   if (addresses.isEmpty) return;

//   String? addressToSelect;

//   // First priority: Use the address ID from checkout
//   if (widget.selectedAddressId != null) {
//     final matchingAddress = addresses.firstWhere(
//       (addr) =>
//           _getAddressIdentifier(addr) == widget.selectedAddressId.toString(),
//       orElse: () => null,
//     );

//     if (matchingAddress != null) {
//       addressToSelect = _getAddressIdentifier(matchingAddress);
//       print("🎯 SELECTED ADDRESS FROM CHECKOUT: $addressToSelect");
//     }
//   }

//   // Second priority: Use the first address
//   if (addressToSelect == null && addresses.isNotEmpty) {
//     addressToSelect = _getAddressIdentifier(addresses.first);
//     print("🎯 SELECTED FIRST ADDRESS: $addressToSelect");
//   }

//   if (addressToSelect != null) {
//     setState(() {
//       selectedDeliveryAddress = addressToSelect;
//       selectedShippingAddress = addressToSelect;
//     });
//   }
// }

// Future<void> _fetchCustomer() async {
//   try {
//     final data = await ApiService.getCustomerDetails();
//     setState(() {
//       customer = data;
//     });
//   } catch (e) {
//     print('Error fetching customer: $e');
//   }
// }

// Future<void> _fetchAddresses() async {
//   try {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     print("🔄 Fetching addresses using getAddresses()...");

//     final List<AddressModel> fetchedAddresses =
//         await ApiService.getAddresses();

//     setState(() {
//       addresses = fetchedAddresses;
//       _isLoading = false;
//     });

//     print(" Successfully loaded ${addresses.length} addresses");

//     // Auto-select first address if not already selected
//     if (addresses.isNotEmpty && selectedDeliveryAddress == null) {
//       final firstAddressId = addresses.first.id?.toString();
//       setState(() {
//         selectedDeliveryAddress = firstAddressId;
//         selectedShippingAddress = firstAddressId;
//       });
//     }
//   } catch (e) {
//     print(' Error fetching addresses: $e');
//     setState(() {
//       _hasError = true;
//       _isLoading = false;
//     });

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to load addresses: ${e.toString()}")),
//       );
//     }
//   }
// }

// String _getAddressIdentifier(Map<String, dynamic> address) {
//   return address['id_address']?.toString() ??
//       address['id']?.toString() ??
//       address['code']?.toString() ??
//       '${address['firstname']}-${address['lastname']}';
// }

//   String _getAddressDisplayName(Map<String, dynamic> address) {
//     return '${address['firstname'] ?? ''} ${address['lastname'] ?? ''}'.trim();
//   }

//   String _getFullAddress(Map<String, dynamic> address) {
//     final address1 = address['address1'] ?? '';
//     final address2 = address['address2'] ?? '';
//     final city = address['city'] ?? '';
//     final postcode = address['postcode'] ?? '';
//     final country = address['country'] ?? '';

//     List<String> parts = [];
//     if (address1.isNotEmpty) parts.add(address1);
//     if (address2.isNotEmpty) parts.add(address2);
//     if (city.isNotEmpty) parts.add(city);
//     if (postcode.isNotEmpty) parts.add(postcode);
//     if (country.isNotEmpty) parts.add(country);

//     return parts.join(', ');
//   }

//   String _getPhoneNumber(Map<String, dynamic> address) {
//     return address['phone'] ??
//         address['phone_mobile'] ??
//         address['phoneNumber'] ??
//         '';
//   }

//   Future<void> _showAddAddressDialog() async {
//     final t = AppLocalizations.of(context)!;

//     print("🔄 OPENING ADD ADDRESS DIALOG...");

//     final result = await showDialog(
//       context: context,
//       builder: (context) => AddressFormDialog(),
//     );

//     if (result != null && result is Map<String, dynamic>) {
//       print("📝 DIALOG RETURNED DATA: $result");

//       // Validate the data before sending
//       final firstname = result['firstname']?.toString().trim() ?? '';
//       final lastname = result['lastname']?.toString().trim() ?? '';
//       final address1 = result['address1']?.toString().trim() ?? '';
//       final city = result['city']?.toString().trim() ?? '';
//       final postcode = result['postcode']?.toString().trim() ?? '';

//       if (firstname.isEmpty ||
//           lastname.isEmpty ||
//           address1.isEmpty ||
//           city.isEmpty ||
//           postcode.isEmpty) {
//         print(" DIALOG DATA VALIDATION FAILED");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
//         return;
//       }

//       print(" ADDING ADDRESS WITH VALIDATED DATA...");
//       final success = await ApiService.addAddress(result);

//       if (success) {
//         print(" ADDRESS ADDED SUCCESSFULLY");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(t.addressAddedSuccessfully)));
//         await _fetchAddresses();
//       } else {
//         print(" FAILED TO ADD ADDRESS");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(t.failedToAddAddress)));
//       }
//     } else {
//       print("ℹ️ DIALOG CANCELLED OR RETURNED NULL");
//     }
//   }

//   Future<void> _showEditAddressDialog(Map<String, dynamic> address) async {
//     final t = AppLocalizations.of(context)!;

//     final result = await showDialog(
//       context: context,
//       builder: (context) => AddressFormDialog(existingAddress: address),
//     );

//     if (result != null) {
//       print('Editing address with data: $result');

//       try {
//         final updateResult = await ApiService.updateAddress(
//           idAddress: address['id_address'] ?? address['id'],
//           firstname: result['firstname'] ?? '',
//           lastname: result['lastname'] ?? '',
//           address1: result['address1'] ?? '',
//           city: result['city'] ?? '',
//           postcode: result['postcode'] ?? '',
//           idState: result['id_state'] ?? result['idState'] ?? 0,
//           phone: result['phone'] ?? '',
//           address2: result['address2'] ?? '',
//         );

//         if (updateResult['success'] == true) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(t.addressUpdatedSuccessfully)));
//           await _fetchAddresses(); // Refresh the list
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(updateResult['message'] ?? t.failedToUpdateAddress),
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error updating address: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   Future<void> _deleteAddress(String addressIdentifier) async {
//     final t = AppLocalizations.of(context)!;

//     final success = await ApiService.deleteAddress(addressIdentifier);
//     if (success == true) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.addressDeletedSuccessfully)));
//       await _fetchAddresses();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(t.failedToDeleteAddress)));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(
//       " AddressSelection build - isLoading: $_isLoading, addresses: ${addresses.length}",
//     );

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
//                 MaterialPageRoute(builder: (context) => Checkout()),
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
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _hasError
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, size: 64, color: Colors.red),
//                     SizedBox(height: 16),
//                     Text("t.failedToLoadAddresses"),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _fetchAddresses,
//                       child: Text(t.retry),
//                     ),
//                   ],
//                 ),
//               )
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       t.deliveryAddress,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.sp,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildAddressSection(t.deliveryAddress, 'delivery'),

//                     const SizedBox(height: 24),
//                     Text(
//                       t.shippingAddress,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.sp,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildAddressSection(t.shippingAddress, 'shipping'),

//                     const SizedBox(height: 32),
//                     _addNewAddressButton(),

//                     const SizedBox(height: 24),
//                     _saveAndContinueButton(),
//                   ],
//                 ),
//               ),
//     );
//   }

// Widget _buildAddressSection(String title, String type) {
//   final t = AppLocalizations.of(context)!;
//   final selectedCode =
//       type == 'delivery' ? selectedDeliveryAddress : selectedShippingAddress;

//   if (addresses.isEmpty) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: Text(
//           t.noAddressesFound,
//           style: TextStyle(color: Colors.grey.shade600),
//         ),
//       ),
//     );
//   }

//   return Column(
//     children:
//         addresses.map((address) {
//           final addressId = address.id?.toString();
//           return _addressCard(
//             address: address,
//             isSelected: addressId == selectedCode,
//             onSelect: () {
//               setState(() {
//                 if (type == 'delivery') {
//                   selectedDeliveryAddress = addressId;
//                 } else {
//                   selectedShippingAddress = addressId;
//                 }
//               });
//             },
//             onEdit: () => _showEditAddressDialog(address.toJson()),
//             onDelete: () => _deleteAddress(addressId ?? ''),
//           );
//         }).toList(),
//   );
// }

//   Widget _addressCard({
//     required AddressModel address,
//     required bool isSelected,
//     required VoidCallback onSelect,
//     required VoidCallback onEdit,
//     required VoidCallback onDelete,
//   }) {
//     final t = AppLocalizations.of(context)!;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade300,
//           width: isSelected ? 2 : 1,
//         ),
//       ),
//       elevation: isSelected ? 2 : 0,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             IconButton(
//               icon: Icon(
//                 isSelected
//                     ? Icons.radio_button_checked
//                     : Icons.radio_button_unchecked,
//                 color: const Color(0xFFFF9800),
//               ),
//               onPressed: onSelect,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${address.firstname} ${address.lastname}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     address.displayAddress,
//                     style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//                   ),
//                   if (address.phone != null && address.phone!.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text(
//                         address.phone!,
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: onEdit,
//                         child: Text(
//                           t.change,
//                           style: const TextStyle(
//                             color: Color(0xFF008AD2),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       InkWell(
//                         onTap: onDelete,
//                         child: Text(
//                           t.delete,
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _addNewAddressButton() {
//     final t = AppLocalizations.of(context)!;

//     return OutlinedButton.icon(
//       onPressed: _showAddAddressDialog,
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Color(0xFF008AD2)),
//       ),
//       icon: Icon(Icons.add, color: Color(0xFF008AD2)),
//       label: Text(
//         t.addNewAddress,
//         style: TextStyle(
//           color: Color(0xFF008AD2),
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _saveAndContinueButton() {
//     final t = AppLocalizations.of(context)!;

//     return ElevatedButton(
//       onPressed: () {
//         if (selectedDeliveryAddress != null &&
//             selectedShippingAddress != null) {
//           // Prepare address data to pass to next screen
//           final deliveryAddress = addresses.firstWhere(
//             (addr) => _getAddressIdentifier(addr) == selectedDeliveryAddress,
//           );
//           final shippingAddress = addresses.firstWhere(
//             (addr) => _getAddressIdentifier(addr) == selectedShippingAddress,
//           );

//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (context) => DeliveryMethod(
//                     // deliveryAddress: deliveryAddress,
//                     // shippingAddress: shippingAddress,
//                     // checkoutData: widget.checkoutData,
//                   ),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(t.pleaseSelectBothAddresses)));
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: Color(0xFF008AD2),
//       ),
//       child: Text(
//         t.validateAndContinue,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

class AddressSelection extends StatefulWidget {
  final int? selectedAddressId;
  final Map<String, dynamic>? checkoutData;

  const AddressSelection({Key? key, this.selectedAddressId, this.checkoutData})
    : super(key: key);

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  Map<String, dynamic>? customer;
  List<dynamic> addresses = [];
  String? selectedDeliveryAddress;
  String? selectedShippingAddress;
  bool _isLoading = true;
  bool _hasError = false;

  // Add these controllers for new address form
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController additionalAddressController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  bool _showNewAddressForm = false;
  bool _isCreatingAddress = false;

  @override
  void initState() {
    super.initState();
    print("AddressSelection initState called");
    print(" Initial selectedAddressId: ${widget.selectedAddressId}");
    print(" Initial checkoutData: ${widget.checkoutData}");

    _initializeData();

    // Pre-fill form if checkout data is available
    _prefillFormFromCheckoutData();
  }

  void _prefillFormFromCheckoutData() {
    if (widget.checkoutData != null) {
      setState(() {
        firstNameController.text = widget.checkoutData!['firstName'] ?? '';
        lastNameController.text = widget.checkoutData!['lastName'] ?? '';
        phoneController.text = widget.checkoutData!['phone'] ?? '';
        addressController.text = widget.checkoutData!['address'] ?? '';
        additionalAddressController.text =
            widget.checkoutData!['additionalAddress'] ?? '';
        cityController.text = widget.checkoutData!['city'] ?? '';
        zipCodeController.text = widget.checkoutData!['zipCode'] ?? '';
      });
    }
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([_fetchCustomer(), _fetchAddresses()]);
    } catch (e) {
      print(" INITIALIZATION ERROR: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _autoSelectAddresses() {
    if (addresses.isEmpty) return;

    String? addressToSelect;

    // First priority: Use the address ID from checkout
    if (widget.selectedAddressId != null) {
      final matchingAddress = addresses.firstWhere(
        (addr) =>
            _getAddressIdentifier(addr) == widget.selectedAddressId.toString(),
        orElse: () => null,
      );

      if (matchingAddress != null) {
        addressToSelect = _getAddressIdentifier(matchingAddress);
        print("🎯 SELECTED ADDRESS FROM CHECKOUT: $addressToSelect");
      }
    }

    // Second priority: Use the first address
    if (addressToSelect == null && addresses.isNotEmpty) {
      addressToSelect = _getAddressIdentifier(addresses.first);
      print("🎯 SELECTED FIRST ADDRESS: $addressToSelect");
    }

    if (addressToSelect != null) {
      setState(() {
        selectedDeliveryAddress = addressToSelect;
        selectedShippingAddress = addressToSelect;
      });
    }
  }

  Future<void> _fetchCustomer() async {
    try {
      final data = await ApiService.getCustomerDetails();
      setState(() {
        customer = data;
      });
    } catch (e) {
      print('Error fetching customer: $e');
    }
  }

  // Future<void> _fetchAddresses() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //       _hasError = false;
  //     });

  //     print("🔄 Fetching addresses using getAddresses()...");

  //     final List<AddressModel> fetchedAddresses =
  //         await ApiService.getAddresses();

  //     setState(() {
  //       addresses = fetchedAddresses;
  //       _isLoading = false;
  //     });

  //     print(" Successfully loaded ${addresses.length} addresses");

  //     // Auto-select addresses after loading
  //     _autoSelectAddresses();
  //   } catch (e) {
  //     print(' Error fetching addresses: $e');
  //     setState(() {
  //       _hasError = true;
  //       _isLoading = false;
  //     });

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to load addresses: ${e.toString()}")),
  //       );
  //     }
  //   }
  // }
  Future<void> _fetchAddresses() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print("🔄 Fetching addresses using getAddresses()...");

      final List<AddressModel> fetchedAddresses =
          await ApiService.getAddresses();

      setState(() {
        // Handle null case by providing empty list
        addresses = fetchedAddresses ?? [];
        _isLoading = false;
      });

      print(" Successfully loaded ${addresses.length} addresses");

      // Auto-select first address if available
      if (addresses.isNotEmpty && selectedDeliveryAddress == null) {
        final firstAddressId = _getAddressIdentifier(addresses.first);
        setState(() {
          selectedDeliveryAddress = firstAddressId;
          selectedShippingAddress = firstAddressId;
        });
      }
    } catch (e) {
      print('❌ Error fetching addresses: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
        addresses = []; // Ensure addresses is never null
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load addresses: ${e.toString()}")),
        );
      }
    }
  }

  String _getAddressIdentifier(dynamic address) {
    if (address is AddressModel) {
      return address.id?.toString() ??
          '${address.firstname}-${address.lastname}';
    } else if (address is Map<String, dynamic>) {
      return address['id_address']?.toString() ??
          address['id']?.toString() ??
          address['code']?.toString() ??
          '${address['firstname']}-${address['lastname']}';
    }
    return address.toString();
  }

  Widget _buildAddressSection(String title, String type) {
    final t = AppLocalizations.of(context)!;
    final selectedCode =
        type == 'delivery' ? selectedDeliveryAddress : selectedShippingAddress;

    if (addresses.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            t.noAddressesFound,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Column(
      children:
          addresses.map((address) {
            final addressId = _getAddressIdentifier(address);
            return _addressCard(
              address: address,
              isSelected: addressId == selectedCode,
              onSelect: () {
                setState(() {
                  if (type == 'delivery') {
                    selectedDeliveryAddress = addressId;
                  } else {
                    selectedShippingAddress = addressId;
                  }
                });
              },
              onEdit: () => _showEditAddressDialog(address),
              onDelete: () => _deleteAddress(addressId),
            );
          }).toList(),
    );
  }

  Widget _addressCard({
    required dynamic address,
    required bool isSelected,
    required VoidCallback onSelect,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final t = AppLocalizations.of(context)!;

    // Extract address data based on type
    String firstName, lastName, displayAddress, phone;

    if (address is AddressModel) {
      firstName = address.firstname;
      lastName = address.lastname;
      displayAddress = address.displayAddress;
      phone = address.phone ?? '';
    } else if (address is Map<String, dynamic>) {
      firstName = address['firstname'] ?? '';
      lastName = address['lastname'] ?? '';
      displayAddress = _getFullAddress(address);
      phone = address['phone'] ?? address['phone_mobile'] ?? '';
    } else {
      firstName = '';
      lastName = '';
      displayAddress = '';
      phone = '';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Color(0xFFFF9800) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      elevation: isSelected ? 2 : 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Color(0xFFFF9800),
              ),
              onPressed: onSelect,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$firstName $lastName",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    displayAddress,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  if (phone.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        phone,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      InkWell(
                        onTap: onEdit,
                        child: Text(
                          t.change,
                          style: TextStyle(
                            color: Color(0xFF008AD2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: onDelete,
                        child: Text(
                          t.delete,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFullAddress(Map<String, dynamic> address) {
    final address1 = address['address1'] ?? '';
    final address2 = address['address2'] ?? '';
    final city = address['city'] ?? '';
    final postcode = address['postcode'] ?? '';
    final country = address['country'] ?? '';

    List<String> parts = [];
    if (address1.isNotEmpty) parts.add(address1);
    if (address2.isNotEmpty) parts.add(address2);
    if (city.isNotEmpty) parts.add(city);
    if (postcode.isNotEmpty) parts.add(postcode);
    if (country.isNotEmpty) parts.add(country);

    return parts.join(', ');
  }

  Future<void> _showEditAddressDialog(dynamic address) async {
    final t = AppLocalizations.of(context)!;
    // Implementation for edit dialog
    print('Edit address: $address');
    // Add your edit dialog implementation here
  }

  Future<void> _deleteAddress(String addressIdentifier) async {
    final t = AppLocalizations.of(context)!;
    // Implementation for delete address
    print('Delete address: $addressIdentifier');
    // Add your delete implementation here
  }

  Widget _buildNewAddressForm() {
    final t = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.addNewAddress,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            _buildFormTextField(t.firstName, controller: firstNameController),
            _buildFormTextField(t.lastName, controller: lastNameController),
            _buildFormTextField(
              t.phoneNumber,
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildFormTextField(t.address, controller: addressController),
            _buildFormTextField(
              t.additionalAddress,
              controller: additionalAddressController,
              hint: t.optional,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildFormTextField(
                    t.city,
                    controller: cityController,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _buildFormTextField(
                    t.zipCode,
                    controller: zipCodeController,
                    hint: t.zipCode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showNewAddressForm = false;
                      });
                    },
                    child: Text(t.cancel),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isCreatingAddress ? null : _createNewAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008AD2),
                    ),
                    child:
                        _isCreatingAddress
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(t.saveAddress),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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

  Future<void> _createNewAddress() async {
    final t = AppLocalizations.of(context)!;

    // Basic validation
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
      return;
    }

    setState(() {
      _isCreatingAddress = true;
    });

    try {
      final addressData = {
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'address1': addressController.text.trim(),
        'address2': additionalAddressController.text.trim(),
        'city': cityController.text.trim(),
        'postcode': zipCodeController.text.trim(),
        'phone': phoneController.text.trim(),
        'alias': 'Home',
      };

      final success = await ApiService.addAddress(addressData);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.addressAddedSuccessfully)));

        // Refresh addresses list
        await _fetchAddresses();

        // Hide the form
        setState(() {
          _showNewAddressForm = false;
          _isCreatingAddress = false;
        });

        // Clear form
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        addressController.clear();
        additionalAddressController.clear();
        cityController.clear();
        zipCodeController.clear();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failedToAddAddress)));
        setState(() {
          _isCreatingAddress = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating address: ${e.toString()}")),
      );
      setState(() {
        _isCreatingAddress = false;
      });
    }
  }

  Widget _addNewAddressButton() {
    final t = AppLocalizations.of(context)!;

    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _showNewAddressForm = true;
        });
      },
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Color(0xFF008AD2)),
      ),
      icon: Icon(Icons.add, color: Color(0xFF008AD2)),
      label: Text(
        t.addNewAddress,
        style: TextStyle(
          color: Color(0xFF008AD2),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _saveAndContinueButton() {
    final t = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () {
        if (selectedDeliveryAddress != null &&
            selectedShippingAddress != null) {
          // Find the selected addresses
          final deliveryAddress = addresses.firstWhere(
            (addr) => _getAddressIdentifier(addr) == selectedDeliveryAddress,
          );
          final shippingAddress = addresses.firstWhere(
            (addr) => _getAddressIdentifier(addr) == selectedShippingAddress,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DeliveryMethod(
                    // deliveryAddress: deliveryAddress,
                    // shippingAddress: shippingAddress,
                    // checkoutData: widget.checkoutData,
                  ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.pleaseSelectBothAddresses)));
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Color(0xFF008AD2),
      ),
      child: Text(
        t.validateAndContinue,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
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
                MaterialPageRoute(builder: (context) => Checkout()),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
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
        title: Text(t.selectAddress, style: TextStyle(color: Colors.black)),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(t.failedToLoadAddresses),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchAddresses,
                      child: Text(t.retry),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New Address Form (when toggled)
                    if (_showNewAddressForm) _buildNewAddressForm(),

                    // Existing Addresses Section
                    Text(
                      t.selectDeliveryAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildAddressSection(t.deliveryAddress, 'delivery'),

                    SizedBox(height: 24),
                    Text(
                      t.selectShippingAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildAddressSection(t.shippingAddress, 'shipping'),

                    SizedBox(height: 32),

                    // Add New Address Button (only show when form is hidden)
                    if (!_showNewAddressForm) _addNewAddressButton(),

                    SizedBox(height: 24),
                    _saveAndContinueButton(),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    additionalAddressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}

// class AddressSelection extends StatefulWidget {
//   final int? selectedAddressId;
//   final Map<String, dynamic>? checkoutData;

//   const AddressSelection({Key? key, this.selectedAddressId, this.checkoutData})
//     : super(key: key);

//   @override
//   State<AddressSelection> createState() => _AddressSelectionState();
// }

// class _AddressSelectionState extends State<AddressSelection> {
//   Map<String, dynamic>? customer;
//   List<dynamic> addresses = [];
//   String? selectedDeliveryAddress;
//   String? selectedShippingAddress;
//   bool _isLoading = true;
//   bool _hasError = false;
  
//   // Add these controllers for new address form
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController additionalAddressController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController zipCodeController = TextEditingController();
  
//   bool _showNewAddressForm = false;
//   bool _isCreatingAddress = false;

//   @override
//   void initState() {
//     super.initState();
//     print("AddressSelection initState called");
//     print(" Initial selectedAddressId: ${widget.selectedAddressId}");
//     print(" Initial checkoutData: ${widget.checkoutData}");

//     _initializeData();
    
//     // Pre-fill form if checkout data is available
//     _prefillFormFromCheckoutData();
//   }

//   void _prefillFormFromCheckoutData() {
//     if (widget.checkoutData != null) {
//       setState(() {
//         firstNameController.text = widget.checkoutData!['firstName'] ?? '';
//         lastNameController.text = widget.checkoutData!['lastName'] ?? '';
//         phoneController.text = widget.checkoutData!['phone'] ?? '';
//         addressController.text = widget.checkoutData!['address'] ?? '';
//         additionalAddressController.text = widget.checkoutData!['additionalAddress'] ?? '';
//         cityController.text = widget.checkoutData!['city'] ?? '';
//         zipCodeController.text = widget.checkoutData!['zipCode'] ?? '';
//       });
//     }
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([_fetchCustomer(), _fetchAddresses()]);
//     } catch (e) {
//       print(" INITIALIZATION ERROR: $e");
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//     }
//   }
//    void _autoSelectAddresses() {
//     if (addresses.isEmpty) return;

//     String? addressToSelect;

//     // First priority: Use the address ID from checkout
//     if (widget.selectedAddressId != null) {
//       final matchingAddress = addresses.firstWhere(
//         (addr) =>
//             _getAddressIdentifier(addr) == widget.selectedAddressId.toString(),
//         orElse: () => null,
//       );

//       if (matchingAddress != null) {
//         addressToSelect = _getAddressIdentifier(matchingAddress);
//         print("🎯 SELECTED ADDRESS FROM CHECKOUT: $addressToSelect");
//       }
//     }

//     // Second priority: Use the first address
//     if (addressToSelect == null && addresses.isNotEmpty) {
//       addressToSelect = _getAddressIdentifier(addresses.first);
//       print("🎯 SELECTED FIRST ADDRESS: $addressToSelect");
//     }

//     if (addressToSelect != null) {
//       setState(() {
//         selectedDeliveryAddress = addressToSelect;
//         selectedShippingAddress = addressToSelect;
//       });
//     }
//   }

//   Future<void> _fetchCustomer() async {
//     try {
//       final data = await ApiService.getCustomerDetails();
//       setState(() {
//         customer = data;
//       });
//     } catch (e) {
//       print('Error fetching customer: $e');
//     }
//   }

//   Future<void> _fetchAddresses() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _hasError = false;
//       });

//       print("🔄 Fetching addresses using getAddresses()...");

//       final List<AddressModel> fetchedAddresses =
//           await ApiService.getAddresses();

//       setState(() {
//         addresses = fetchedAddresses;
//         _isLoading = false;
//       });

//       print(" Successfully loaded ${addresses.length} addresses");

//       // Auto-select first address if not already selected
//       if (addresses.isNotEmpty && selectedDeliveryAddress == null) {
//         final firstAddressId = addresses.first.id?.toString();
//         setState(() {
//           selectedDeliveryAddress = firstAddressId;
//           selectedShippingAddress = firstAddressId;
//         });
//       }
//     } catch (e) {
//       print(' Error fetching addresses: $e');
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to load addresses: ${e.toString()}")),
//         );
//       }
//     }
//   }
//    String _getAddressIdentifier(Map<String, dynamic> address) {
//     return address['id_address']?.toString() ??
//         address['id']?.toString() ??
//         address['code']?.toString() ??
//         '${address['firstname']}-${address['lastname']}';
//   }
  

//   // ... keep existing methods like _fetchCustomer, _fetchAddresses, etc.

//   Widget _buildNewAddressForm() {
//     final t = AppLocalizations.of(context)!;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               t.addNewAddress,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             _buildFormTextField(t.firstName, controller: firstNameController),
//             _buildFormTextField(t.lastName, controller: lastNameController),
//             _buildFormTextField(
//               t.phoneNumber,
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//             ),
//             _buildFormTextField(t.address, controller: addressController),
//             _buildFormTextField(
//               t.additionalAddress,
//               controller: additionalAddressController,
//               hint: t.optional,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: _buildFormTextField(t.city, controller: cityController),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: _buildFormTextField(
//                     t.zipCode,
//                     controller: zipCodeController,
//                     hint: t.zipCode,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       setState(() {
//                         _showNewAddressForm = false;
//                       });
//                     },
//                     child: Text(t.cancel),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isCreatingAddress ? null : _createNewAddress,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF008AD2),
//                     ),
//                     child: _isCreatingAddress
//                         ? SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : Text(t.saveAddress),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFormTextField(
//     String label, {
//     String? hint,
//     TextInputType? keyboardType,
//     required TextEditingController controller,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint ?? label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//       ),
//     );
//   }

//   Future<void> _createNewAddress() async {
//     final t = AppLocalizations.of(context)!;

//     // Basic validation
//     if (firstNameController.text.isEmpty ||
//         lastNameController.text.isEmpty ||
//         addressController.text.isEmpty ||
//         cityController.text.isEmpty ||
//         zipCodeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(t.pleaseFillAllRequiredFields)),
//       );
//       return;
//     }

//     setState(() {
//       _isCreatingAddress = true;
//     });

//     try {
//       final addressData = {
//         'firstname': firstNameController.text.trim(),
//         'lastname': lastNameController.text.trim(),
//         'address1': addressController.text.trim(),
//         'address2': additionalAddressController.text.trim(),
//         'city': cityController.text.trim(),
//         'postcode': zipCodeController.text.trim(),
//         'phone': phoneController.text.trim(),
//         'alias': 'Home',
//       };

//       final success = await ApiService.addAddress(addressData);

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(t.addressAddedSuccessfully)),
//         );
        
//         // Refresh addresses list
//         await _fetchAddresses();
        
//         // Hide the form
//         setState(() {
//           _showNewAddressForm = false;
//           _isCreatingAddress = false;
//         });
        
//         // Clear form
//         firstNameController.clear();
//         lastNameController.clear();
//         phoneController.clear();
//         addressController.clear();
//         additionalAddressController.clear();
//         cityController.clear();
//         zipCodeController.clear();
        
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(t.failedToAddAddress)),
//         );
//         setState(() {
//           _isCreatingAddress = false;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error creating address: ${e.toString()}")),
//       );
//       setState(() {
//         _isCreatingAddress = false;
//       });
//     }
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
//                 MaterialPageRoute(builder: (context) => Checkout()),
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
//         title: Text(t.selectAddress, style: TextStyle(color: Colors.black)),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _hasError
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 64, color: Colors.red),
//                       SizedBox(height: 16),
//                       Text(t.failedToLoadAddresses),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _fetchAddresses,
//                         child: Text(t.retry),
//                       ),
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // New Address Form (when toggled)
//                       if (_showNewAddressForm) _buildNewAddressForm(),

//                       // Existing Addresses Section
//                       Text(
//                         t.selectDeliveryAddress,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildAddressSection(t.deliveryAddress, 'delivery'),

//                       const SizedBox(height: 24),
//                       Text(
//                         t.selectShippingAddress,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildAddressSection(t.shippingAddress, 'shipping'),

//                       const SizedBox(height: 32),
                      
//                       // Add New Address Button (only show when form is hidden)
//                       if (!_showNewAddressForm) _addNewAddressButton(),

//                       const SizedBox(height: 24),
//                       _saveAndContinueButton(),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   // Update the add new address button
//   Widget _addNewAddressButton() {
//     final t = AppLocalizations.of(context)!;

//     return OutlinedButton.icon(
//       onPressed: () {
//         setState(() {
//           _showNewAddressForm = true;
//         });
//       },
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Color(0xFF008AD2)),
//       ),
//       icon: Icon(Icons.add, color: Color(0xFF008AD2)),
//       label: Text(
//         t.addNewAddress,
//         style: TextStyle(
//           color: Color(0xFF008AD2),
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     firstNameController.dispose();
//     lastNameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     additionalAddressController.dispose();
//     cityController.dispose();
//     zipCodeController.dispose();
//     super.dispose();
//   }
// }