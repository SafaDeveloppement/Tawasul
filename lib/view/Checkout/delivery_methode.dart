// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:tawasul_application/Services/api_service.dart';
// // import 'package:tawasul_application/controller/cart_controller.dart';
// // import 'package:tawasul_application/view/Checkout/payment_method.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // import 'package:tawasul_application/model/carrier_model.dart';

// // class DeliveryMethod extends StatefulWidget {
// //   const DeliveryMethod({super.key});

// //   @override
// //   State<DeliveryMethod> createState() => _DeliveryMethodState();
// // }

// // class _DeliveryMethodState extends State<DeliveryMethod> {
// //   String selectedMethod = "home";
// //   String? selectedCity;
// //   String? selectedShop;
// //   String? selectedTime;
// //   DateTime? selectedDate;

// //   List<CarrierModel> carriers = [];
// //   bool isLoading = true;
// //   String errorMessage = '';
// //   int? cartId;

// //   List<String> timeSlots = [
// //     "11:15 - 12:15",
// //     "12:15 - 13:15",
// //     "13:15 - 14:15",
// //     "14:15 - 15:15",
// //     "15:15 - 16:15",
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadCartAndShipping();
// //   }

// //   Future<void> _loadCartAndShipping() async {
// //     try {
// //       // Get cart ID from storage
// //       cartId = await CartManager.getCurrentCartId();

// //       if (cartId == null) {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage = 'No active cart found. Please add items to cart first.';
// //         });
// //         return;
// //       }

// //       print(' Loading shipping for cart ID: $cartId');

// //       final shippingList = await ApiService.getShippingList(cartId!);

// //       setState(() {
// //         carriers = shippingList;
// //         isLoading = false;

// //         // Set default selected method based on available carriers
// //         if (carriers.isNotEmpty) {
// //           final hasHomeDelivery = carriers.any((carrier) => !carrier.isStorePickup);
// //           final hasStorePickup = carriers.any((carrier) => carrier.isStorePickup);

// //           if (hasHomeDelivery) {
// //             selectedMethod = "home";
// //           } else if (hasStorePickup) {
// //             selectedMethod = "pickup";
// //           }
// //         }
// //       });
// //     } catch (e) {
// //       print(' Error loading shipping list: $e');
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = 'Failed to load delivery options. Please try again.';
// //       });
// //     }
// //   }

// //   // Extract unique cities from carriers
// //   List<String> get cities {
// //     final citySet = <String>{};
// //     for (var carrier in carriers) {
// //       for (var group in carrier.relayGroups) {
// //         citySet.add(group.relayGroupName);
// //       }
// //     }
// //     return citySet.toList();
// //   }

// //   // Get shops for selected city
// //   List<String> get shops {
// //     if (selectedCity == null) return [];

// //     for (var carrier in carriers) {
// //       for (var group in carrier.relayGroups) {
// //         if (group.relayGroupName == selectedCity) {
// //           // If relay points are available, use them as shops
// //           if (group.relayPoints != null && group.relayPoints!.isNotEmpty) {
// //             return group.relayPoints!.map((point) => point.name).toList();
// //           }
// //           // Otherwise return default shops
// //           return ["${group.relayGroupName} Main Branch", "${group.relayGroupName} Center"];
// //         }
// //       }
// //     }
// //     return [];
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate ?? DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(DateTime.now().year + 1),
// //       builder: (BuildContext context, Widget? child) {
// //         return Theme(
// //           data: ThemeData.light().copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: Color(0xFF008AD2),
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //             dialogBackgroundColor: Colors.white,
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //     if (picked != null && picked != selectedDate) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //     }
// //   }

// //   String _formatDate(DateTime? date) {
// //     if (date == null) return '';

// //     final months = [
// //       'January', 'February', 'March', 'April', 'May', 'June',
// //       'July', 'August', 'September', 'October', 'November', 'December',
// //     ];

// //     return '${months[date.month - 1]} ${date.day} ${date.year}';
// //   }

// //   // Get selected carrier
// //   CarrierModel? get selectedCarrier {
// //     if (selectedMethod == "home") {
// //       return carriers.firstWhere((carrier) => !carrier.isStorePickup, orElse: () => carriers.first);
// //     } else {
// //       return carriers.firstWhere((carrier) => carrier.isStorePickup, orElse: () => carriers.first);
// //     }
// //   }

// //   // Validate form before proceeding
// //   bool get isFormValid {
// //     if (selectedMethod == "pickup") {
// //       return selectedCity != null && selectedShop != null && selectedDate != null && selectedTime != null;
// //     }
// //     return true; // Home delivery doesn't require additional selections
// //   }

// //   void _proceedToPayment() {
// //     if (!isFormValid) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please complete all required fields'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     // Save delivery method selection
// //     _saveDeliverySelection();

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => PaymentMethod()),
// //     );
// //   }

// //   void _saveDeliverySelection() {
// //     // Save the delivery selection to shared preferences or state management
// //     final deliveryData = {
// //       'method': selectedMethod,
// //       'carrierId': selectedCarrier?.idCarrier,
// //       'carrierName': selectedCarrier?.name,
// //       'price': selectedCarrier?.price,
// //       'city': selectedCity,
// //       'shop': selectedShop,
// //       'date': selectedDate?.toIso8601String(),
// //       'time': selectedTime,
// //     };

// //     print('💾 Saving delivery data: $deliveryData');
// //     // You can save this to SharedPreferences or your state management
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(),
// //           SizedBox(height: 20),
// //           Text('Loading delivery options...'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.error_outline, size: 64, color: Colors.red),
// //           SizedBox(height: 20),
// //           Text(
// //             errorMessage,
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16, color: Colors.red),
// //           ),
// //           SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: _loadCartAndShipping,
// //             child: Text('Retry'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// // Widget _buildEmptyState() {
// //   return Center(
// //     child: Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Icon(Icons.local_shipping, size: 64, color: Colors.grey),
// //         SizedBox(height: 20),
// //         Text(
// //           'No delivery options available',
// //           textAlign: TextAlign.center,
// //           style: TextStyle(fontSize: 16, color: Colors.grey),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     final t = AppLocalizations.of(context)!;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         leading: Padding(
// //           padding: EdgeInsets.only(
// //             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
// //             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
// //           ),
// //           child: GestureDetector(
// //             onTap: () => Navigator.pop(context),
// //             child: Container(
// //               width: 40.w,
// //               height: 40.w,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFF008AD2),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Center(
// //                 child: Icon(
// //                   Icons.arrow_back_ios_new,
// //                   color: Colors.white,
// //                   size: 20.sp,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         title: Text(t.checkout, style: TextStyle(color: Colors.black)),
// //       ),
// //       body: isLoading
// //           ? _buildLoadingState()
// //           : errorMessage.isNotEmpty
// //               ? _buildErrorState()
// //               : carriers.isEmpty
// //                   ? _buildEmptyState()
// //                   : _buildContent(context, t),
// //     );
// //   }

// // Widget _buildContent(BuildContext context, AppLocalizations t) {
// //   return SingleChildScrollView(
// //     padding: const EdgeInsets.all(16),
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
// //           child: Text(
// //             t.deliveryMethod,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ),
// //         SizedBox(height: 20),

// //         ...carriers.map((carrier) => _buildCarrierOption(carrier, t)),

// //         const SizedBox(height: 20),

// //         if (selectedMethod == "pickup")
// //           _buildPickupDetails(t),

// //         const SizedBox(height: 30),
// //         SizedBox(
// //           width: double.infinity,
// //           child: ElevatedButton(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Color(0xFF008AD2),
// //               padding: const EdgeInsets.symmetric(vertical: 14),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //             onPressed: _proceedToPayment,
// //             child: Text(
// //               t.validateAndContinue,
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// // Widget _buildCarrierOption(CarrierModel carrier, AppLocalizations t) {
// //   final isStorePickup = carrier.isStorePickup;
// //   final isSelected = selectedMethod == (isStorePickup ? "pickup" : "home");

// //   return InkWell(
// //     onTap: () {
// //       setState(() {
// //         selectedMethod = isStorePickup ? "pickup" : "home";
// //         // Reset pickup selections when switching methods
// //         if (!isStorePickup) {
// //           selectedCity = null;
// //           selectedShop = null;
// //           selectedTime = null;
// //         }
// //       });
// //     },
// //     child: Container(
// //       padding: const EdgeInsets.all(14),
// //       margin: const EdgeInsets.only(bottom: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(
// //           color: isSelected ? Colors.orange : Colors.grey,
// //           width: isSelected ? 2 : 1,
// //         ),
// //         color: Colors.white,
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
// //             color: Colors.orange,
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   carrier.name,
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: isSelected ? Colors.orange : Colors.black,
// //                   ),
// //                 ),
// //                 SizedBox(height: 4),
// //                 Text(
// //                   carrier.delay,
// //                   style: TextStyle(fontSize: 14, color: Colors.grey),
// //                 ),
// //                 SizedBox(height: 4),
// //                 Text(
// //                   "Price: ${carrier.price}",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w500,
// //                     color: isSelected ? Colors.orange : Colors.black,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }

// //   Widget _buildPickupDetails(AppLocalizations t) {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 20),
// //         _buildDropdown(
// //           hint: t.selectCity,
// //           value: selectedCity,
// //           items: cities,
// //           onChanged: (val) {
// //             setState(() {
// //               selectedCity = val;
// //               selectedShop = null;
// //               selectedTime = null;
// //             });
// //           },
// //         ),
// //         const SizedBox(height: 15),

// //         if (selectedCity != null)
// //           _buildDropdown(
// //             hint: t.selectShop,
// //             value: selectedShop,
// //             items: shops,
// //             onChanged: (val) {
// //               setState(() {
// //                 selectedShop = val;
// //               });
// //             },
// //           ),
// //         const SizedBox(height: 20),

// //         Card(
// //           color: Colors.white,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           borderOnForeground: true,
// //           shadowColor: const Color.fromARGB(255, 0, 0, 0),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Text(
// //                       t.pickingDateTime,
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w300,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     Spacer(),
// //                     GestureDetector(
// //                       onTap: () => _selectDate(context),
// //                       child: Icon(Icons.calendar_today, size: 20),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: timeSlots.map((slot) {
// //                     final isSelected = slot == selectedTime;
// //                     return GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedTime = slot;
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 16,
// //                           vertical: 10,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: isSelected
// //                               ? Colors.orange
// //                               : const Color(0xFFE9EAEB),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Text(
// //                           slot,
// //                           style: TextStyle(
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () => _selectDate(context),
// //                   child: Container(
// //                     width: double.infinity,
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(10),
// //                       color: const Color(0xFFFFFFFF),
// //                       border: Border.all(color: Colors.black),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               t.dateTime,
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w300,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                             Text(
// //                               selectedDate != null
// //                                   ? _formatDate(selectedDate)
// //                                   : t.selectDate,
// //                             ),
// //                           ],
// //                         ),
// //                         Text(
// //                           selectedTime ?? t.selectTime,
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDropdown({
// //     required String hint,
// //     required String? value,
// //     required List<String> items,
// //     required ValueChanged<String?> onChanged,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey.shade300),
// //       ),
// //       child: DropdownButton<String>(
// //         value: value,
// //         isExpanded: true,
// //         hint: Text(hint),
// //         underline: const SizedBox(),
// //         items: items.map((e) {
// //           return DropdownMenuItem<String>(value: e, child: Text(e));
// //         }).toList(),
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:tawasul_application/Services/api_service.dart';
// // import 'package:tawasul_application/controller/cart_controller.dart';
// // import 'package:tawasul_application/l10n/app_localizations.dart';
// // import 'package:tawasul_application/model/carrier_model.dart';
// // import 'package:tawasul_application/view/Checkout/payment_method.dart';

// // class DeliveryMethod extends StatefulWidget {
// //   const DeliveryMethod({super.key});

// //   @override
// //   State<DeliveryMethod> createState() => _DeliveryMethodState();
// // }

// // class _DeliveryMethodState extends State<DeliveryMethod> {
// //   String selectedMethod = "home";
// //   String? selectedCity;
// //   String? selectedShop;
// //   String? selectedTime;
// //   DateTime? selectedDate;

// //   List<CarrierModel> carriers = [];
// //   bool isLoading = true;
// //   String errorMessage = '';

// //   List<String> timeSlots = [
// //     "11:15 - 12:15",
// //     "12:15 - 13:15",
// //     "13:15 - 14:15",
// //     "14:15 - 15:15",
// //     "15:15 - 16:15",
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadShippingList();
// //   }

// //   // Simplified method to fetch shipping list
// //   Future<void> _loadShippingList() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //         errorMessage = '';
// //       });

// //       // Get cart ID from SharedPreferences
// //       final cartId = await _getCurrentCartId();

// //       if (cartId == null || cartId == 0) {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage = 'No active cart found. Please add items to cart first.';
// //         });
// //         return;
// //       }

// //       print('🛒 Loading shipping for cart ID: $cartId');

// //       // Call API with the cart ID
// //       final shippingList = await ApiService.getShippingList(cartId);

// //       setState(() {
// //         carriers = shippingList;
// //         isLoading = false;

// //         // Set default selection based on available carriers
// //         if (carriers.isNotEmpty) {
// //           final hasHomeDelivery = carriers.any((carrier) => !carrier.isStorePickup);
// //           final hasStorePickup = carriers.any((carrier) => carrier.isStorePickup);

// //           if (hasHomeDelivery) {
// //             selectedMethod = "home";
// //           } else if (hasStorePickup) {
// //             selectedMethod = "pickup";
// //           }
// //         }
// //       });

// //     } catch (e) {
// //       print('❌ Error loading shipping list: $e');
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = 'Failed to load delivery options. Please try again.';
// //       });
// //     }
// //   }

// //   // Get cart ID from SharedPreferences
// //   Future<int?> _getCurrentCartId() async {
// //     try {
// //       // Method 1: Using getCurrentCartId() that returns int?
// //       final cartId = await CartManager.getCurrentCartId();
// //       if (cartId != null && cartId > 0) {
// //         print('✅ Found cart ID: $cartId');
// //         return cartId;
// //       }

// //       // Method 2: Using getCurrentCartId() and parsing to int
// //       final cartIdString = await CartManager.getCurrentCartId();
// //       if (cartIdString != null && cartIdString.isNotEmpty) {
// //         final parsedId = int.tryParse(cartIdString);
// //         if (parsedId != null && parsedId > 0) {
// //           print('✅ Found cart ID from string: $parsedId');
// //           return parsedId;
// //         }
// //       }

// //       print('❌ No valid cart ID found');
// //       return null;
// //     } catch (e) {
// //       print('❌ Error getting cart ID: $e');
// //       return null;
// //     }
// //   }

// //   // Extract unique cities from carriers - FIXED NULL SAFETY
// //   List<String> get cities {
// //     final citySet = <String>{};
// //     for (var carrier in carriers) {
// //       // Check if relayGroups exists and is not null
// //       if (carrier.relayGroups != null) {
// //         for (var group in carrier.relayGroups!) {
// //           // Check if relayGroupName exists and is not null
// //           if (group.relayGroupName != null && group.relayGroupName!.isNotEmpty) {
// //             citySet.add(group.relayGroupName!);
// //           }
// //         }
// //       }
// //     }
// //     return citySet.toList();
// //   }

// //   // Get shops for selected city - FIXED NULL SAFETY
// //   List<String> get shops {
// //     if (selectedCity == null) return [];

// //     for (var carrier in carriers) {
// //       // Check if relayGroups exists and is not null
// //       if (carrier.relayGroups != null) {
// //         for (var group in carrier.relayGroups!) {
// //           // Check if relayGroupName exists and matches selectedCity
// //           if (group.relayGroupName != null && group.relayGroupName == selectedCity) {
// //             // If relay points are available and not null, use them as shops
// //             if (group.relayPoints != null && group.relayPoints!.isNotEmpty) {
// //               return group.relayPoints!
// //                   .where((point) => point.name != null) // Filter out null names
// //                   .map((point) => point.name!) // Use null assertion only after checking
// //                   .toList();
// //             }
// //             // Otherwise return default shops
// //             return ["${selectedCity} Main Branch", "${selectedCity} Center"];
// //           }
// //         }
// //       }
// //     }
// //     return [];
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate ?? DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(DateTime.now().year + 1),
// //       builder: (BuildContext context, Widget? child) {
// //         return Theme(
// //           data: ThemeData.light().copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: Color(0xFF008AD2),
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //             dialogBackgroundColor: Colors.white,
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //     if (picked != null && picked != selectedDate) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //     }
// //   }

// //   String _formatDate(DateTime? date) {
// //     if (date == null) return 'Select Date';

// //     final months = [
// //       'January', 'February', 'March', 'April', 'May', 'June',
// //       'July', 'August', 'September', 'October', 'November', 'December',
// //     ];

// //     return '${months[date.month - 1]} ${date.day} ${date.year}';
// //   }

// //   // Get selected carrier - FIXED NULL SAFETY
// //   // CarrierModel? get selectedCarrier {
// //   //   try {
// //   //     if (selectedMethod == "home") {
// //   //       return carriers.firstWhere(
// //   //         (carrier) => carrier.isStorePickup == false,
// //   //         orElse: () => carriers.isNotEmpty ? carriers.first : CarrierModel(idCarrier: 1, name: '', delay: '', price: '', minDate: '', relayGroups: []),
// //   //       );
// //   //     } else {
// //   //       return carriers.firstWhere(
// //   //         (carrier) => carrier.isStorePickup == true,
// //   //         orElse: () => carriers.isNotEmpty ? carriers.first : CarrierModel(idCarrier: 2, name: '', delay: '', price: '', minDate: '', relayGroups: [],),
// //   //       );
// //   //     }
// //   //   } catch (e) {
// //   //     print('❌ Error getting selected carrier: $e');
// //   //     return carriers.isNotEmpty ? carriers.first : null;
// //   //   }
// //   // }
// //   CarrierModel? get selectedCarrier {
// //   try {
// //     if (carriers.isEmpty) return null;

// //     if (selectedMethod == "home") {
// //       for (var carrier in carriers) {
// //         if (carrier.isStorePickup == false) {
// //           return carrier;
// //         }
// //       }
// //     } else {
// //       for (var carrier in carriers) {
// //         if (carrier.isStorePickup == true) {
// //           return carrier;
// //         }
// //       }
// //     }

// //     // If we reach here, no carrier found for the selected method
// //     return null;
// //   } catch (e) {
// //     print('❌ Error getting selected carrier: $e');
// //     return null;
// //   }
// // }

// //   // Validate form before proceeding
// //   bool get isFormValid {
// //     if (selectedMethod == "pickup") {
// //       return selectedCity != null &&
// //              selectedCity!.isNotEmpty &&
// //              selectedShop != null &&
// //              selectedShop!.isNotEmpty &&
// //              selectedDate != null &&
// //              selectedTime != null &&
// //              selectedTime!.isNotEmpty;
// //     }
// //     return true;
// //   }

// //   void _proceedToPayment() {
// //     if (!isFormValid) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Please complete all required fields'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     // Save delivery method selection
// //     _saveDeliverySelection();

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => const PaymentMethod()),
// //     );
// //   }

// //   void _saveDeliverySelection() {
// //     // Save the delivery selection to shared preferences or state management
// //     final deliveryData = {
// //       'method': selectedMethod,
// //       'carrierId': selectedCarrier?.idCarrier,
// //       'carrierName': selectedCarrier?.name,
// //       'price': selectedCarrier?.price,
// //       'city': selectedCity,
// //       'shop': selectedShop,
// //       'date': selectedDate?.toIso8601String(),
// //       'time': selectedTime,
// //     };

// //     print('💾 Saving delivery data: $deliveryData');
// //     // You can save this to SharedPreferences or your state management
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const CircularProgressIndicator(),
// //           const SizedBox(height: 20),
// //           Text('Loading delivery options...'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.error_outline, size: 64, color: Colors.red),
// //           const SizedBox(height: 20),
// //           Text(
// //             errorMessage.isNotEmpty ? errorMessage : 'An error occurred',
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(fontSize: 16, color: Colors.red),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: _loadShippingList,
// //             child: const Text('Retry'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.local_shipping, size: 64, color: Colors.grey),
// //           const SizedBox(height: 20),
// //           const Text(
// //             'No delivery options available',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16, color: Colors.grey),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: _loadShippingList,
// //             child: const Text('Refresh'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final t = AppLocalizations.of(context);

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         leading: Padding(
// //           padding: EdgeInsets.only(
// //             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
// //             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
// //           ),
// //           child: GestureDetector(
// //             onTap: () => Navigator.pop(context),
// //             child: Container(
// //               width: 40.w,
// //               height: 40.w,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFF008AD2),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Center(
// //                 child: Icon(
// //                   Icons.arrow_back_ios_new,
// //                   color: Colors.white,
// //                   size: 20.sp,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         title: Text(
// //           'Checkout',
// //           style: const TextStyle(color: Colors.black)
// //         ),
// //       ),
// //       body: isLoading
// //           ? _buildLoadingState()
// //           : errorMessage.isNotEmpty
// //               ? _buildErrorState()
// //               : carriers.isEmpty
// //                   ? _buildEmptyState()
// //                   : _buildContent(context, t),
// //     );
// //   }

// //   Widget _buildContent(BuildContext context, AppLocalizations? t) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
// //             child: Text(
// //                'Delivery Method',
// //               style: const TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 20),

// //           ...carriers.map((carrier) => _buildCarrierOption(carrier, t)),

// //           const SizedBox(height: 20),

// //           if (selectedMethod == "pickup")
// //             _buildPickupDetails(t),

// //           const SizedBox(height: 30),
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF008AD2),
// //                 padding: const EdgeInsets.symmetric(vertical: 14),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               onPressed: _proceedToPayment,
// //               child: Text(
// //                  'Validate and Continue',
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCarrierOption(CarrierModel carrier, AppLocalizations? t) {
// //     final isStorePickup = carrier.isStorePickup == true;
// //     final isSelected = selectedMethod == (isStorePickup ? "pickup" : "home");

// //     return InkWell(
// //       onTap: () {
// //         setState(() {
// //           selectedMethod = isStorePickup ? "pickup" : "home";
// //           // Reset pickup selections when switching methods
// //           if (!isStorePickup) {
// //             selectedCity = null;
// //             selectedShop = null;
// //             selectedTime = null;
// //           }
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.all(14),
// //         margin: const EdgeInsets.only(bottom: 10),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(
// //             color: isSelected ? Colors.orange : Colors.grey,
// //             width: isSelected ? 2 : 1,
// //           ),
// //           color: Colors.white,
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
// //               color: Colors.orange,
// //             ),
// //             const SizedBox(width: 10),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     carrier.name ?? 'Unknown Carrier',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: isSelected ? Colors.orange : Colors.black,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     carrier.delay ?? 'Delivery time not specified',
// //                     style: const TextStyle(fontSize: 14, color: Colors.grey),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     "Price: ${carrier.price ?? 'N/A'}",
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w500,
// //                       color: isSelected ? Colors.orange : Colors.black,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPickupDetails(AppLocalizations? t) {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 20),
// //         _buildDropdown(
// //           hint:  'Select City',
// //           value: selectedCity,
// //           items: cities,
// //           onChanged: (val) {
// //             setState(() {
// //               selectedCity = val;
// //               selectedShop = null;
// //               selectedTime = null;
// //             });
// //           },
// //         ),
// //         const SizedBox(height: 15),

// //         if (selectedCity != null && selectedCity!.isNotEmpty)
// //           _buildDropdown(
// //             hint:  'Select Shop',
// //             value: selectedShop,
// //             items: shops,
// //             onChanged: (val) {
// //               setState(() {
// //                 selectedShop = val;
// //               });
// //             },
// //           ),
// //         const SizedBox(height: 20),

// //         Card(
// //           color: Colors.white,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           borderOnForeground: true,
// //           shadowColor: const Color.fromARGB(255, 0, 0, 0),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Text(
// //                       'Picking Date & Time',
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.w300,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     const Spacer(),
// //                     GestureDetector(
// //                       onTap: () => _selectDate(context),
// //                       child: const Icon(Icons.calendar_today, size: 20),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: timeSlots.map((slot) {
// //                     final isSelected = slot == selectedTime;
// //                     return GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedTime = slot;
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 16,
// //                           vertical: 10,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: isSelected
// //                               ? Colors.orange
// //                               : const Color(0xFFE9EAEB),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Text(
// //                           slot,
// //                           style: TextStyle(
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () => _selectDate(context),
// //                   child: Container(
// //                     width: double.infinity,
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(10),
// //                       color: const Color(0xFFFFFFFF),
// //                       border: Border.all(color: Colors.black),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                                'Date & Time',
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.w300,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                             Text(
// //                               selectedDate != null
// //                                   ? _formatDate(selectedDate)
// //                                   :  'Select Date',
// //                             ),
// //                           ],
// //                         ),
// //                         Text(
// //                           selectedTime ??  'Select Time',
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDropdown({
// //     required String hint,
// //     required String? value,
// //     required List<String> items,
// //     required ValueChanged<String?> onChanged,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey.shade300),
// //       ),
// //       child: DropdownButton<String>(
// //         value: value,
// //         isExpanded: true,
// //         hint: Text(hint),
// //         underline: const SizedBox(),
// //         items: items.map((e) {
// //           return DropdownMenuItem<String>(
// //             value: e,
// //             child: Text(e),
// //           );
// //         }).toList(),
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tawasul_application/Services/api_service.dart';
// // import 'package:tawasul_application/controller/cart_controller.dart';
// // import 'package:tawasul_application/l10n/app_localizations.dart';
// // import 'dart:convert';

// // import 'package:tawasul_application/model/carrier_model.dart';
// // import 'package:tawasul_application/view/Checkout/payment_method.dart';

// // class DeliveryMethod extends StatefulWidget {
// //   const DeliveryMethod({super.key});

// //   @override
// //   State<DeliveryMethod> createState() => _DeliveryMethodState();
// // }

// // class _DeliveryMethodState extends State<DeliveryMethod> {
// //   String selectedMethod = "home";
// //   String? selectedCity;
// //   String? selectedShop;
// //   String? selectedTime;
// //   DateTime? selectedDate;

// //   List<CarrierModel> carriers = [];
// //   bool isLoading = true;
// //   String errorMessage = '';

// //   List<String> timeSlots = [
// //     "11:15 - 12:15",
// //     "12:15 - 13:15",
// //     "13:15 - 14:15",
// //     "14:15 - 15:15",
// //     "15:15 - 16:15",
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadShippingList();
// //   }

// //   // Simplified method to fetch shipping list
// //   Future<void> _loadShippingList() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //         errorMessage = '';
// //       });

// //       // Get cart ID from SharedPreferences
// //       final cartId = await _getCurrentCartId();

// //       if (cartId == null || cartId == 0) {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage =
// //               'No active cart found. Please add items to cart first.';
// //         });
// //         return;
// //       }

// //       print('🛒 Loading shipping for cart ID: $cartId');

// //       // Call API with the cart ID
// //       final shippingList = await ApiService.getShippingList(cartId);

// //       setState(() {
// //         carriers = shippingList;
// //         isLoading = false;

// //         // Set default selection based on available carriers
// //         if (carriers.isNotEmpty) {
// //           final hasHomeDelivery = carriers.any(
// //             (carrier) => !carrier.isStorePickup,
// //           );
// //           final hasStorePickup = carriers.any(
// //             (carrier) => carrier.isStorePickup,
// //           );

// //           if (hasHomeDelivery) {
// //             selectedMethod = "home";
// //           } else if (hasStorePickup) {
// //             selectedMethod = "pickup";
// //           }
// //         }
// //       });
// //     } catch (e) {
// //       print('❌ Error loading shipping list: $e');
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = 'Failed to load delivery options. Please try again.';
// //       });
// //     }
// //   }

// //   // Get cart ID from SharedPreferences
// //   Future<int?> _getCurrentCartId() async {
// //     try {
// //       // Method 1: Using getCurrentCartId() that returns int?
// //       final cartId = await CartManager.getCurrentCartId();
// //       if (cartId != null && cartId > 0) {
// //         print('✅ Found cart ID: $cartId');
// //         return cartId;
// //       }

// //       // Method 2: Using getCurrentCartId() and parsing to int
// //       final cartIdString = await CartManager.getCurrentCartId();
// //       if (cartIdString != null && cartIdString.isNotEmpty) {
// //         final parsedId = int.tryParse(cartIdString);
// //         if (parsedId != null && parsedId > 0) {
// //           print('✅ Found cart ID from string: $parsedId');
// //           return parsedId;
// //         }
// //       }

// //       print('❌ No valid cart ID found');
// //       return null;
// //     } catch (e) {
// //       print('❌ Error getting cart ID: $e');
// //       return null;
// //     }
// //   }

// //   // Extract unique cities from carriers
// //   List<String> get cities {
// //     final citySet = <String>{};
// //     for (var carrier in carriers) {
// //       for (var group in carrier.relayGroups) {
// //         citySet.add(group.relayGroupName);
// //       }
// //     }
// //     return citySet.toList();
// //   }

// //   // Get shops for selected city
// //   List<String> get shops {
// //     if (selectedCity == null) return [];

// //     for (var carrier in carriers) {
// //       for (var group in carrier.relayGroups) {
// //         if (group.relayGroupName == selectedCity) {
// //           // If relay points are available, use them as shops
// //           if (group.relayPoints != null && group.relayPoints!.isNotEmpty) {
// //             return group.relayPoints!.map((point) => point.name).toList();
// //           }
// //           // Otherwise return default shops
// //           return [
// //             "${group.relayGroupName} Main Branch",
// //             "${group.relayGroupName} Center",
// //           ];
// //         }
// //       }
// //     }
// //     return [];
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate ?? DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(DateTime.now().year + 1),
// //       builder: (BuildContext context, Widget? child) {
// //         return Theme(
// //           data: ThemeData.light().copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: Color(0xFF008AD2),
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //             dialogBackgroundColor: Colors.white,
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //     if (picked != null && picked != selectedDate) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //     }
// //   }

// //   String _formatDate(DateTime? date) {
// //     if (date == null) return '';

// //     final months = [
// //       'January',
// //       'February',
// //       'March',
// //       'April',
// //       'May',
// //       'June',
// //       'July',
// //       'August',
// //       'September',
// //       'October',
// //       'November',
// //       'December',
// //     ];

// //     return '${months[date.month - 1]} ${date.day} ${date.year}';
// //   }

// //   // Get selected carrier
// //   CarrierModel? get selectedCarrier {
// //     if (selectedMethod == "home") {
// //       return carriers.firstWhere(
// //         (carrier) => !carrier.isStorePickup,
// //         orElse: () => carriers.first,
// //       );
// //     } else {
// //       return carriers.firstWhere(
// //         (carrier) => carrier.isStorePickup,
// //         orElse: () => carriers.first,
// //       );
// //     }
// //   }

// //   // Validate form before proceeding
// //   bool get isFormValid {
// //     if (selectedMethod == "pickup") {
// //       return selectedCity != null &&
// //           selectedShop != null &&
// //           selectedDate != null &&
// //           selectedTime != null;
// //     }
// //     return true; // Home delivery doesn't require additional selections
// //   }

// //   void _proceedToPayment() {
// //     if (!isFormValid) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please complete all required fields'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     // Save delivery method selection
// //     _saveDeliverySelection();

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => PaymentMethod()),
// //     );
// //   }

// //   void _saveDeliverySelection() {
// //     // Save the delivery selection to shared preferences or state management
// //     final deliveryData = {
// //       'method': selectedMethod,
// //       'carrierId': selectedCarrier?.idCarrier,
// //       'carrierName': selectedCarrier?.name,
// //       'price': selectedCarrier?.price,
// //       'city': selectedCity,
// //       'shop': selectedShop,
// //       'date': selectedDate?.toIso8601String(),
// //       'time': selectedTime,
// //     };

// //     print('💾 Saving delivery data: $deliveryData');
// //     // You can save this to SharedPreferences or your state management
// //   }

// //   Widget _buildLoadingState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(),
// //           SizedBox(height: 20),
// //           Text('Loading delivery options...'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.error_outline, size: 64, color: Colors.red),
// //           SizedBox(height: 20),
// //           Text(
// //             errorMessage,
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16, color: Colors.red),
// //           ),
// //           SizedBox(height: 20),
// //           ElevatedButton(onPressed: _loadShippingList, child: Text('Retry')),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.local_shipping, size: 64, color: Colors.grey),
// //           SizedBox(height: 20),
// //           Text(
// //             'No delivery options available',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16, color: Colors.grey),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final t = AppLocalizations.of(context)!;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         leading: Padding(
// //           padding: EdgeInsets.only(
// //             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
// //             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
// //           ),
// //           child: GestureDetector(
// //             onTap: () => Navigator.pop(context),
// //             child: Container(
// //               width: 40.w,
// //               height: 40.w,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFF008AD2),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Center(
// //                 child: Icon(
// //                   Icons.arrow_back_ios_new,
// //                   color: Colors.white,
// //                   size: 20.sp,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         title: Text(t.checkout, style: TextStyle(color: Colors.black)),
// //       ),
// //       body:
// //           isLoading
// //               ? _buildLoadingState()
// //               : errorMessage.isNotEmpty
// //               ? _buildErrorState()
// //               : carriers.isEmpty
// //               ? _buildEmptyState()
// //               : _buildContent(context, t),
// //     );
// //   }

// //   Widget _buildContent(BuildContext context, AppLocalizations t) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
// //             child: Text(
// //               t.deliveryMethod,
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black,
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 20),

// //           ...carriers.map((carrier) => _buildCarrierOption(carrier, t)),

// //           const SizedBox(height: 20),

// //           if (selectedMethod == "pickup") _buildPickupDetails(t),

// //           const SizedBox(height: 30),
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Color(0xFF008AD2),
// //                 padding: const EdgeInsets.symmetric(vertical: 14),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               onPressed: _proceedToPayment,
// //               child: Text(
// //                 t.validateAndContinue,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCarrierOption(CarrierModel carrier, AppLocalizations t) {
// //     final isStorePickup = carrier.isStorePickup;
// //     final isSelected = selectedMethod == (isStorePickup ? "pickup" : "home");

// //     return InkWell(
// //       onTap: () {
// //         setState(() {
// //           selectedMethod = isStorePickup ? "pickup" : "home";
// //           // Reset pickup selections when switching methods
// //           if (!isStorePickup) {
// //             selectedCity = null;
// //             selectedShop = null;
// //             selectedTime = null;
// //           }
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.all(14),
// //         margin: const EdgeInsets.only(bottom: 10),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(
// //             color: isSelected ? Colors.orange : Colors.grey,
// //             width: isSelected ? 2 : 1,
// //           ),
// //           color: Colors.white,
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
// //               color: Colors.orange,
// //             ),
// //             const SizedBox(width: 10),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     carrier.name,
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: isSelected ? Colors.orange : Colors.black,
// //                     ),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     carrier.delay,
// //                     style: TextStyle(fontSize: 14, color: Colors.grey),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     "Price: ${carrier.price}",
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w500,
// //                       color: isSelected ? Colors.orange : Colors.black,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPickupDetails(AppLocalizations t) {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 20),
// //         _buildDropdown(
// //           hint: t.selectCity,
// //           value: selectedCity,
// //           items: cities,
// //           onChanged: (val) {
// //             setState(() {
// //               selectedCity = val;
// //               selectedShop = null;
// //               selectedTime = null;
// //             });
// //           },
// //         ),
// //         const SizedBox(height: 15),

// //         if (selectedCity != null)
// //           _buildDropdown(
// //             hint: t.selectShop,
// //             value: selectedShop,
// //             items: shops,
// //             onChanged: (val) {
// //               setState(() {
// //                 selectedShop = val;
// //               });
// //             },
// //           ),
// //         const SizedBox(height: 20),

// //         Card(
// //           color: Colors.white,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           borderOnForeground: true,
// //           shadowColor: const Color.fromARGB(255, 0, 0, 0),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Text(
// //                       t.pickingDateTime,
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w300,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     Spacer(),
// //                     GestureDetector(
// //                       onTap: () => _selectDate(context),
// //                       child: Icon(Icons.calendar_today, size: 20),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children:
// //                       timeSlots.map((slot) {
// //                         final isSelected = slot == selectedTime;
// //                         return GestureDetector(
// //                           onTap: () {
// //                             setState(() {
// //                               selectedTime = slot;
// //                             });
// //                           },
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 16,
// //                               vertical: 10,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color:
// //                                   isSelected
// //                                       ? Colors.orange
// //                                       : const Color(0xFFE9EAEB),
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                             child: Text(
// //                               slot,
// //                               style: TextStyle(
// //                                 color: isSelected ? Colors.white : Colors.black,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () => _selectDate(context),
// //                   child: Container(
// //                     width: double.infinity,
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(10),
// //                       color: const Color(0xFFFFFFFF),
// //                       border: Border.all(color: Colors.black),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               t.dateTime,
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w300,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                             Text(
// //                               selectedDate != null
// //                                   ? _formatDate(selectedDate)
// //                                   : t.selectDate,
// //                             ),
// //                           ],
// //                         ),
// //                         Text(
// //                           selectedTime ?? t.selectTime,
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDropdown({
// //     required String hint,
// //     required String? value,
// //     required List<String> items,
// //     required ValueChanged<String?> onChanged,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey.shade300),
// //       ),
// //       child: DropdownButton<String>(
// //         value: value,
// //         isExpanded: true,
// //         hint: Text(hint),
// //         underline: const SizedBox(),
// //         items:
// //             items.map((e) {
// //               return DropdownMenuItem<String>(value: e, child: Text(e));
// //             }).toList(),
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/controller/cart_controller.dart';
// import 'package:tawasul_application/model/carrier_model.dart';
// import 'package:tawasul_application/view/Checkout/payment_method.dart';

// class DeliveryMethod extends StatefulWidget {
//   const DeliveryMethod({super.key});

//   @override
//   State<DeliveryMethod> createState() => _DeliveryMethodState();
// }

// class _DeliveryMethodState extends State<DeliveryMethod> {
//   String selectedMethod = "home";
//   String? selectedCity;
//   String? selectedShop;
//   String? selectedTime;
//   DateTime? selectedDate;

//   List<CarrierModel> carriers = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   List<String> timeSlots = [
//     "11:15 - 12:15",
//     "12:15 - 13:15",
//     "13:15 - 14:15",
//     "14:15 - 15:15",
//     "15:15 - 16:15",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadShippingList();
//   }

//   // Simplified method to fetch shipping list
//   Future<void> _loadShippingList() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = '';
//       });

//       // Get cart ID from SharedPreferences
//       final cartId = await _getCurrentCartId();

//       if (cartId == null || cartId == 0) {
//         setState(() {
//           isLoading = false;
//           errorMessage =
//               'No active cart found. Please add items to cart first.';
//         });
//         return;
//       }

//       print('🛒 Loading shipping for cart ID: $cartId');

//       // ✅ Correctly call API
//       final shippingList = await ApiService.getShippingList(cartId);

//       setState(() {
//         carriers = shippingList;
//         isLoading = false;

//         // Set default selection
//         if (carriers.isNotEmpty) {
//           final hasHomeDelivery = carriers.any(
//             (carrier) => carrier.isStorePickup == false,
//           );
//           final hasStorePickup = carriers.any(
//             (carrier) => carrier.isStorePickup == true,
//           );

//           if (hasHomeDelivery) {
//             selectedMethod = "home";
//           } else if (hasStorePickup) {
//             selectedMethod = "pickup";
//           }
//         }
//       });
//     } catch (e) {
//       print('❌ Error loading shipping list: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load delivery options. Please try again.';
//       });
//     }
//   }

//   // Get cart ID from SharedPreferences
//   Future<int?> _getCurrentCartId() async {
//     try {
//       // Only Method 1 is needed now
//       final cartId = await CartManager.getCurrentCartId();
//       if (cartId != null && cartId > 0) {
//         print('🧾 Found cart ID: $cartId');
//         return cartId;
//       }

//       print('⚠️ No valid cart ID found');
//       return null;
//     } catch (e) {
//       print('❌ Error getting cart ID: $e');
//       return null;
//     }
//   }

//   // Extract unique cities from carriers - FIXED NULL SAFETY
//   List<String> get cities {
//     final citySet = <String>{};
//     for (var carrier in carriers) {
//       // Check if relayGroups exists and is not null
//       final relayGroups = carrier.relayGroups;
//       if (relayGroups != null) {
//         for (var group in relayGroups) {
//           // Check if relayGroupName exists and is not null
//           final groupName = group.relayGroupName;
//           if (groupName != null && groupName.isNotEmpty) {
//             citySet.add(groupName);
//           }
//         }
//       }
//     }
//     return citySet.toList();
//   }

//   // Get shops for selected city
//   List<String> get shops {
//     if (selectedCity == null) return [];

//     for (var carrier in carriers) {
//       // Check if relayGroups exists and is not null
//       final relayGroups = carrier.relayGroups;
//       if (relayGroups != null) {
//         for (var group in relayGroups) {
//           // Check if relayGroupName exists and matches selectedCity
//           final groupName = group.relayGroupName;
//           if (groupName != null && groupName == selectedCity) {
//             // If relay points are available and not null, use them as shops
//             final relayPoints = group.relayPoints;
//             if (relayPoints != null && relayPoints.isNotEmpty) {
//               return relayPoints
//                   .where((point) => point.name != null) // Filter out null names
//                   .map(
//                     (point) => point.name!,
//                   ) // Use null assertion only after checking
//                   .toList();
//             }
//             // Otherwise return default shops
//             return ["${selectedCity} Main Branch", "${selectedCity} Center"];
//           }
//         }
//       }
//     }
//     return [];
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year + 1),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF008AD2),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child ?? const SizedBox(), // FIX: Handle null child
//         );
//       },
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Select Date';

//     final months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];

//     return '${months[date.month - 1]} ${date.day} ${date.year}';
//   }

//   // Get selected carrier - Option 1 with proper null safety
//   CarrierModel? get selectedCarrier {
//     try {
//       if (carriers.isEmpty) return null;

//       if (selectedMethod == "home") {
//         // Find home delivery carriers (isStorePickup == false)
//         final homeCarriers =
//             carriers
//                 .where((carrier) => carrier.isStorePickup == false)
//                 .toList();
//         return homeCarriers.isNotEmpty ? homeCarriers.first : null;
//       } else {
//         // Find pickup carriers (isStorePickup == true)
//         final pickupCarriers =
//             carriers.where((carrier) => carrier.isStorePickup == true).toList();
//         return pickupCarriers.isNotEmpty ? pickupCarriers.first : null;
//       }
//     } catch (e) {
//       print('❌ Error getting selected carrier: $e');
//       return carriers.isNotEmpty ? carriers.first : null;
//     }
//   }

//   // Validate form before proceeding
//   bool get isFormValid {
//     if (selectedMethod == "pickup") {
//       return selectedCity != null &&
//           selectedCity!.isNotEmpty &&
//           selectedShop != null &&
//           selectedShop!.isNotEmpty &&
//           selectedDate != null &&
//           selectedTime != null &&
//           selectedTime!.isNotEmpty;
//     }
//     return selectedCarrier != null; // Both methods require a valid carrier
//   }

//   void _proceedToPayment() {
//     // First check if we have a valid carrier
//     if (selectedCarrier == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a valid delivery method'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Then check form validation
//     if (!isFormValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please complete all required fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Save delivery method selection
//     _saveDeliverySelection();

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const PaymentMethod()),
//     );
//   }

//   void _saveDeliverySelection() {
//     if (selectedCarrier == null) {
//       print('⚠️ No carrier selected, cannot save delivery data');
//       return;
//     }

//     // Save the delivery selection to shared preferences or state management
//     final deliveryData = {
//       'method': selectedMethod,
//       'carrierId': selectedCarrier!.idCarrier, // Safe because we checked above
//       'carrierName': selectedCarrier!.name ?? 'Unknown Carrier',
//       'price': selectedCarrier!.price ?? '0',
//       'city': selectedCity,
//       'shop': selectedShop,
//       'date': selectedDate?.toIso8601String(),
//       'time': selectedTime,
//     };

//     print('💾 Saving delivery data: $deliveryData');
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(),
//           const SizedBox(height: 20),
//           const Text('Loading delivery options...'),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 20),
//           Text(
//             errorMessage.isNotEmpty ? errorMessage : 'An error occurred',
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 16, color: Colors.red),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _loadShippingList,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.local_shipping, size: 64, color: Colors.grey),
//           const SizedBox(height: 20),
//           const Text(
//             'No delivery options available',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _loadShippingList,
//             child: const Text('Refresh'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(
//             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
//             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
//           ),
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
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
//         title: Text('Checkout', style: const TextStyle(color: Colors.black)),
//       ),
//       body:
//           isLoading
//               ? _buildLoadingState()
//               : errorMessage.isNotEmpty
//               ? _buildErrorState()
//               : carriers.isEmpty
//               ? _buildEmptyState()
//               : _buildContent(context),
//     );
//   }

//   Widget _buildContent(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
//             child: Text(
//               'Delivery Method',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

//           ...carriers.map((carrier) => _buildCarrierOption(carrier)),

//           const SizedBox(height: 20),

//           if (selectedMethod == "pickup")
//             // _buildPickupDetails(t),
//             const SizedBox(height: 30),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF008AD2),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: _proceedToPayment,
//               child: Text(
//                 'Validate and Continue',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCarrierOption(CarrierModel carrier) {
//     final isStorePickup = carrier.isStorePickup == true;
//     final isSelected = selectedMethod == (isStorePickup ? "pickup" : "home");

//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedMethod = isStorePickup ? "pickup" : "home";
//           // Reset pickup selections when switching methods
//           if (!isStorePickup) {
//             selectedCity = null;
//             selectedShop = null;
//             selectedTime = null;
//           }
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.orange : Colors.grey,
//             width: isSelected ? 2 : 1,
//           ),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: Colors.orange,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     carrier.name ?? 'Unknown Carrier',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? Colors.orange : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     carrier.delay ?? 'Delivery time not specified',
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Price: ${carrier.price ?? 'N/A'}",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: isSelected ? Colors.orange : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPickupDetails() {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         _buildDropdown(
//           hint: 'Select City',
//           value: selectedCity,
//           items: cities,
//           onChanged: (val) {
//             setState(() {
//               selectedCity = val;
//               selectedShop = null;
//               selectedTime = null;
//             });
//           },
//         ),
//         const SizedBox(height: 15),

//         if (selectedCity != null && selectedCity!.isNotEmpty)
//           _buildDropdown(
//             hint: 'Select Shop',
//             value: selectedShop,
//             items: shops,
//             onChanged: (val) {
//               setState(() {
//                 selectedShop = val;
//               });
//             },
//           ),
//         const SizedBox(height: 20),

//         Card(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           borderOnForeground: true,
//           shadowColor: const Color.fromARGB(255, 0, 0, 0),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Picking Date & Time',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () => _selectDate(context),
//                       child: const Icon(Icons.calendar_today, size: 20),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children:
//                       timeSlots.map((slot) {
//                         final isSelected = slot == selectedTime;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedTime = slot;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   isSelected
//                                       ? Colors.orange
//                                       : const Color(0xFFE9EAEB),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               slot,
//                               style: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: const Color(0xFFFFFFFF),
//                       border: Border.all(color: Colors.black),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Date & Time',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Text(
//                               selectedDate != null
//                                   ? _formatDate(selectedDate)
//                                   : 'Select Date',
//                             ),
//                           ],
//                         ),
//                         Text(
//                           selectedTime ?? 'Select Time',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: DropdownButton<String>(
//         value: value,
//         isExpanded: true,
//         hint: Text(hint),
//         underline: const SizedBox(),
//         items:
//             items.map((e) {
//               return DropdownMenuItem<String>(value: e, child: Text(e));
//             }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Checkout/address_selection.dart';
import 'package:tawasul_application/view/Checkout/payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryMethod extends StatefulWidget {
  const DeliveryMethod({super.key});

  @override
  State<DeliveryMethod> createState() => _DeliveryMethodState();
}

class _DeliveryMethodState extends State<DeliveryMethod> {
  String selectedMethod = "home";
  String? selectedCity;
  String? selectedShop;
  String? selectedTime;

  List<String> cities = ["Tripoli", "Benghazi"];
  List<String> shops = ["Ras Hasan Hall", "Main Street Branch"];
  List<String> timeSlots = [
    "11:15 - 12:15",
    "12:15 - 13:15",
    "13:15 - 14:15",
    "14:15 - 15:15",
    "15:15 - 16:15",
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressSelection()),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
              child: Text(
                t.deliveryMethod,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDeliveryOption(t.homeDelivery, "home"),
            const SizedBox(height: 20),
            _buildDeliveryOption(t.storePickupDelivery, "pickup"),

            if (selectedMethod == "pickup") ...[
              const SizedBox(height: 20),
              _buildDropdown(
                hint: t.selectCity,
                value: selectedCity,
                items: cities,
                onChanged: (val) {
                  setState(() {
                    selectedCity = val;
                    selectedShop = null;
                  });
                },
              ),
              const SizedBox(height: 15),

              _buildDropdown(
                hint: t.selectShop,
                value: selectedShop,
                items: shops,
                onChanged: (val) {
                  setState(() {
                    selectedShop = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                borderOnForeground: true,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            t.pickingDateTime,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            timeSlots.map((slot) {
                              final isSelected = slot == selectedTime;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = slot;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.orange
                                            : const Color(0xFFE9EAEB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.dateTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(t.september142025),
                              ],
                            ),
                            Text(
                              selectedTime ?? t.selectTime,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008AD2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentMethod()),
                    ),
                child: Text(
                  t.validateAndContinue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String label, String value) {
    return InkWell(
      onTap: () {
        setState(() => selectedMethod = value);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedMethod == value ? Colors.orange : Colors.grey,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selectedMethod == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text(hint),
        underline: const SizedBox(),
        items:
            items.map((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
