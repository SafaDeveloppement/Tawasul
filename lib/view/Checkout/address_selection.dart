// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/view/Checkout/checkout.dart';
// import 'package:tawasul_application/view/Checkout/delivery_methode.dart';
// import 'address_form_dialog.dart';

// class AddressSelection extends StatefulWidget {
//   const AddressSelection({Key? key}) : super(key: key);

//   @override
//   State<AddressSelection> createState() => _AddressSelectionState();
// }

// class _AddressSelectionState extends State<AddressSelection> {
//   Map<String, dynamic>? customer;
//   List<dynamic> addresses = [];
//   String? selectedDeliveryAddress;
//   String? selectedShippingAddress;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCustomer();
//     _fetchAddresses();
//   }

//   Future<void> _fetchCustomer() async {
//     final data = await ApiService.getCustomerDetails();
//     setState(() {
//       customer = data;
//     });
//   }

//   Future<void> _fetchAddresses() async {
//     final data = await ApiService.getAddresses();
//     setState(() {
//       addresses = data;
//       if (addresses.isNotEmpty) {
//         selectedDeliveryAddress = addresses[0]['code'];
//         selectedShippingAddress = addresses[0]['code'];
//       }
//     });
//   }

//   Future<void> _showAddAddressDialog() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AddressFormDialog(),
//     );

//     if (result != null) {
//       print('Adding address with data: $result');
//       final success = await ApiService.addAddress(result);
//       if (success) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Address added successfully')));
//         _fetchAddresses();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to add address. Check console for details.'),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _showEditAddressDialog(Map<String, dynamic> address) async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AddressFormDialog(existingAddress: address),
//     );

//     if (result != null) {
//       print('Updating address with data: $result');
//       final success = await ApiService.updateAddress(address['code'], result);
//       if (success) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Address updated successfully')));
//         _fetchAddresses();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Failed to update address. Check console for details.',
//             ),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _deleteAddress(String code) async {
//     final success = await ApiService.deleteAddress(code);
//     if (success) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Address deleted successfully')));
//       _fetchAddresses();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to delete address')));
//     }
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
//         title: const Text("Checkout", style: TextStyle(color: Colors.black)),
//       ),
//       body:
//           customer == null
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "DELIVERY ADDRESS",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildAddressSection('delivery'),

//                     const SizedBox(height: 20),
//                     const Text(
//                       "SHIPPING ADDRESS",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildAddressSection('shipping'),

//                     const SizedBox(height: 40),
//                     _addNewAddressButton(),

//                     const SizedBox(height: 20),
//                     _saveAndContinueButton(),
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget _buildAddressSection(String type) {
//     final selectedCode =
//         type == 'delivery' ? selectedDeliveryAddress : selectedShippingAddress;

//     if (addresses.isEmpty) {
//       return const Text('No addresses found. Please add an address.');
//     }

//     return Column(
//       children:
//           addresses
//               .map(
//                 (address) => _addressCard(
//                   address: address,
//                   isSelected: address['code'] == selectedCode,
//                   onSelect: () {
//                     setState(() {
//                       if (type == 'delivery') {
//                         selectedDeliveryAddress = address['code'];
//                       } else {
//                         selectedShippingAddress = address['code'];
//                       }
//                     });
//                   },
//                   onEdit: () => _showEditAddressDialog(address),
//                   onDelete: () => _deleteAddress(address['code']),
//                 ),
//               )
//               .toList(),
//     );
//   }

//   Widget _addressCard({
//     required Map<String, dynamic> address,
//     required bool isSelected,
//     required VoidCallback onSelect,
//     required VoidCallback onEdit,
//     required VoidCallback onDelete,
//   }) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: isSelected ? Color(0xFFFF9800) : Color(0xFFFF9800),
//         ),
//       ),
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
//                 color: Colors.orange,
//               ),
//               onPressed: onSelect,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${address['firstName']} ${address['lastName']}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text("${address['address1']}"),
//                   if (address['address2'] != null &&
//                       address['address2'].isNotEmpty)
//                     Text("${address['address2']}"),
//                   Text("${address['city']}"),
//                   const SizedBox(height: 4),
//                   Text("${address['phoneNumber']}"),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: onEdit,
//                         child: const Text(
//                           "Change",
//                           style: TextStyle(color: Colors.blue),
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
//     return OutlinedButton(
//       onPressed: _showAddAddressDialog,
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Text(
//         "+ ADD NEW ADDRESS",
//         style: TextStyle(color: Colors.black, fontSize: 14),
//       ),
//     );
//   }

//   Widget _saveAndContinueButton() {
//     return ElevatedButton(
//       onPressed: () {
//         if (selectedDeliveryAddress != null &&
//             selectedShippingAddress != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => DeliveryMethod()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Please select both delivery and shipping addresses',
//               ),
//             ),
//           );
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: Color(0xFF008AD2),
//       ),
//       child: Text(
//         "Validate and continue",
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';
import 'package:tawasul_application/view/Checkout/delivery_methode.dart';
import 'address_form_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({Key? key}) : super(key: key);

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  Map<String, dynamic>? customer;
  List<dynamic> addresses = [];
  String? selectedDeliveryAddress;
  String? selectedShippingAddress;

  @override
  void initState() {
    super.initState();
    _fetchCustomer();
    _fetchAddresses();
  }

  Future<void> _fetchCustomer() async {
    final data = await ApiService.getCustomerDetails();
    setState(() {
      customer = data;
    });
  }

  Future<void> _fetchAddresses() async {
    final data = await ApiService.getAddresses();
    setState(() {
      addresses = data;
      if (addresses.isNotEmpty) {
        selectedDeliveryAddress = addresses[0]['code'];
        selectedShippingAddress = addresses[0]['code'];
      }
    });
  }

  Future<void> _showAddAddressDialog() async {
    final t = AppLocalizations.of(context)!;

    final result = await showDialog(
      context: context,
      builder: (context) => AddressFormDialog(),
    );

    if (result != null) {
      print('Adding address with data: $result');
      final success = await ApiService.addAddress(result);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.addressAddedSuccessfully)));
        _fetchAddresses();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failedToAddAddress)));
      }
    }
  }

  Future<void> _showEditAddressDialog(Map<String, dynamic> address) async {
    final t = AppLocalizations.of(context)!;

    final result = await showDialog(
      context: context,
      builder: (context) => AddressFormDialog(existingAddress: address),
    );

    if (result != null) {
      print('Updating address with data: $result');
      final success = await ApiService.updateAddress(address['code'], result);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.addressUpdatedSuccessfully)));
        _fetchAddresses();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failedToUpdateAddress)));
      }
    }
  }

  Future<void> _deleteAddress(String code) async {
    final t = AppLocalizations.of(context)!;

    final success = await ApiService.deleteAddress(code);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.addressDeletedSuccessfully)));
      _fetchAddresses();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.failedToDeleteAddress)));
    }
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
          customer == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.deliveryAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAddressSection('delivery'),

                    const SizedBox(height: 20),
                    Text(
                      t.shippingAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAddressSection('shipping'),

                    const SizedBox(height: 40),
                    _addNewAddressButton(),

                    const SizedBox(height: 20),
                    _saveAndContinueButton(),
                  ],
                ),
              ),
    );
  }

  Widget _buildAddressSection(String type) {
    final t = AppLocalizations.of(context)!;
    final selectedCode =
        type == 'delivery' ? selectedDeliveryAddress : selectedShippingAddress;

    if (addresses.isEmpty) {
      return Text(t.noAddressesFound);
    }

    return Column(
      children:
          addresses
              .map(
                (address) => _addressCard(
                  address: address,
                  isSelected: address['code'] == selectedCode,
                  onSelect: () {
                    setState(() {
                      if (type == 'delivery') {
                        selectedDeliveryAddress = address['code'];
                      } else {
                        selectedShippingAddress = address['code'];
                      }
                    });
                  },
                  onEdit: () => _showEditAddressDialog(address),
                  onDelete: () => _deleteAddress(address['code']),
                ),
              )
              .toList(),
    );
  }

  Widget _addressCard({
    required Map<String, dynamic> address,
    required bool isSelected,
    required VoidCallback onSelect,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final t = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Color(0xFFFF9800) : Color(0xFFFF9800),
        ),
      ),
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
                color: Colors.orange,
              ),
              onPressed: onSelect,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address['firstName']} ${address['lastName']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("${address['address1']}"),
                  if (address['address2'] != null &&
                      address['address2'].isNotEmpty)
                    Text("${address['address2']}"),
                  Text("${address['city']}"),
                  const SizedBox(height: 4),
                  Text("${address['phoneNumber']}"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: onEdit,
                        child: Text(
                          t.change,
                          style: TextStyle(color: Colors.blue),
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

  Widget _addNewAddressButton() {
    final t = AppLocalizations.of(context)!;

    return OutlinedButton(
      onPressed: _showAddAddressDialog,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        t.addNewAddress,
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Widget _saveAndContinueButton() {
    final t = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () {
        if (selectedDeliveryAddress != null &&
            selectedShippingAddress != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliveryMethod()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.pleaseSelectBothAddresses)));
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Color(0xFF008AD2),
      ),
      child: Text(
        t.validateAndContinue,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
