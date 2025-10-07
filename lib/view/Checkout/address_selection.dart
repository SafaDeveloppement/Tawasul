import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';
import 'package:tawasul_application/view/Checkout/delivery_methode.dart';
import 'address_form_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    print("AddressSelection initState called");
    print(" Initial selectedAddressId: ${widget.selectedAddressId}");
    print(" Initial checkoutData: ${widget.checkoutData}");

    _fetchCustomer();
    _fetchAddresses();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([_fetchCustomer(), _fetchAddresses()]);
    } catch (e) {
      print("💥 INITIALIZATION ERROR: $e");
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

  Future<void> _fetchAddresses() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print("🔄 Fetching addresses from API...");

      final response = await ApiService.getCustomerAddresses();

      if (response['success'] == true) {
        setState(() {
          addresses = response['addresses'] ?? [];
          _isLoading = false;
        });

        print("✅ Successfully loaded ${addresses.length} addresses");

        // Auto-select the first address if available and no selection exists
        if (addresses.isNotEmpty && selectedDeliveryAddress == null) {
          final firstAddressId = _getAddressIdentifier(addresses.first);
          setState(() {
            selectedDeliveryAddress = firstAddressId;
            selectedShippingAddress = firstAddressId;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });

        print("❌ Failed to fetch addresses: ${response['message']}");

        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load addresses: ${response['message']}"),
            ),
          );
        }
      }
    } catch (e) {
      print(' Error fetching addresses: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading addresses: ${e.toString()}")),
        );
      }
    }
  }

  String _getAddressIdentifier(Map<String, dynamic> address) {
    return address['id_address']?.toString() ??
        address['id']?.toString() ??
        address['code']?.toString() ??
        '${address['firstname']}-${address['lastname']}';
  }

  String _getAddressDisplayName(Map<String, dynamic> address) {
    return '${address['firstname'] ?? ''} ${address['lastname'] ?? ''}'.trim();
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

  String _getPhoneNumber(Map<String, dynamic> address) {
    return address['phone'] ??
        address['phone_mobile'] ??
        address['phoneNumber'] ??
        '';
  }

  // Future<void> _showAddAddressDialog() async {
  //   final t = AppLocalizations.of(context)!;

  //   final result = await showDialog(
  //     context: context,
  //     builder: (context) => AddressFormDialog(),
  //   );

  //   if (result != null) {
  //     print('Adding address with data: $result');
  //     final success = await ApiService.addAddress(result);
  //     if (success) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(t.addressAddedSuccessfully)));
  //       await _fetchAddresses();
  //     } else {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(t.failedToAddAddress)));
  //     }
  //   }
  // }

  Future<void> _showAddAddressDialog() async {
    final t = AppLocalizations.of(context)!;

    print("🔄 OPENING ADD ADDRESS DIALOG...");

    final result = await showDialog(
      context: context,
      builder: (context) => AddressFormDialog(),
    );

    if (result != null && result is Map<String, dynamic>) {
      print("📝 DIALOG RETURNED DATA: $result");

      // Validate the data before sending
      final firstname = result['firstname']?.toString().trim() ?? '';
      final lastname = result['lastname']?.toString().trim() ?? '';
      final address1 = result['address1']?.toString().trim() ?? '';
      final city = result['city']?.toString().trim() ?? '';
      final postcode = result['postcode']?.toString().trim() ?? '';

      if (firstname.isEmpty ||
          lastname.isEmpty ||
          address1.isEmpty ||
          city.isEmpty ||
          postcode.isEmpty) {
        print("❌ DIALOG DATA VALIDATION FAILED");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.pleaseFillAllRequiredFields)));
        return;
      }

      print("🔄 ADDING ADDRESS WITH VALIDATED DATA...");
      final success = await ApiService.addAddress(result);

      if (success) {
        print("✅ ADDRESS ADDED SUCCESSFULLY");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.addressAddedSuccessfully)));
        await _fetchAddresses();
      } else {
        print("❌ FAILED TO ADD ADDRESS");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.failedToAddAddress)));
      }
    } else {
      print("ℹ️ DIALOG CANCELLED OR RETURNED NULL");
    }
  }

  Future<void> _showEditAddressDialog(Map<String, dynamic> address) async {
    final t = AppLocalizations.of(context)!;

    final result = await showDialog(
      context: context,
      builder: (context) => AddressFormDialog(existingAddress: address),
    );

    if (result != null) {
      print('Editing address with data: $result');

      try {
        final updateResult = await ApiService.updateAddress(
          idAddress: address['id_address'] ?? address['id'],
          firstname: result['firstname'] ?? '',
          lastname: result['lastname'] ?? '',
          address1: result['address1'] ?? '',
          city: result['city'] ?? '',
          postcode: result['postcode'] ?? '',
          idState: result['id_state'] ?? result['idState'] ?? 0,
          phone: result['phone'] ?? '',
          address2: result['address2'] ?? '',
        );

        if (updateResult['success'] == true) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.addressUpdatedSuccessfully)));
          await _fetchAddresses(); // Refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(updateResult['message'] ?? t.failedToUpdateAddress),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating address: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _deleteAddress(String addressIdentifier) async {
    final t = AppLocalizations.of(context)!;

    final success = await ApiService.deleteAddress(addressIdentifier);
    if (success == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.addressDeletedSuccessfully)));
      await _fetchAddresses();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.failedToDeleteAddress)));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      " AddressSelection build - isLoading: $_isLoading, addresses: ${addresses.length}",
    );

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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text("t.failedToLoadAddresses"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchAddresses,
                      child: Text(t.retry),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.deliveryAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAddressSection(t.deliveryAddress, 'delivery'),

                    const SizedBox(height: 24),
                    Text(
                      t.shippingAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAddressSection(t.shippingAddress, 'shipping'),

                    const SizedBox(height: 32),
                    _addNewAddressButton(),

                    const SizedBox(height: 24),
                    _saveAndContinueButton(),
                  ],
                ),
              ),
    );
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
            final addressIdentifier = _getAddressIdentifier(address);
            return _addressCard(
              address: address,
              isSelected: addressIdentifier == selectedCode,
              onSelect: () {
                setState(() {
                  if (type == 'delivery') {
                    selectedDeliveryAddress = addressIdentifier;
                  } else {
                    selectedShippingAddress = addressIdentifier;
                  }
                });
              },
              onEdit: () => _showEditAddressDialog(address),
              onDelete: () => _deleteAddress(addressIdentifier),
            );
          }).toList(),
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
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
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
                size: 24,
              ),
              onPressed: onSelect,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getAddressDisplayName(address),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getFullAddress(address),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  if (_getPhoneNumber(address).isNotEmpty)
                    Text(
                      _getPhoneNumber(address),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 12),
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

  Widget _addNewAddressButton() {
    final t = AppLocalizations.of(context)!;

    return OutlinedButton.icon(
      onPressed: _showAddAddressDialog,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
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
          // Prepare address data to pass to next screen
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
        minimumSize: const Size(double.infinity, 50),
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
}
