// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/model/carrier_model.dart';
// import 'package:tawasul_application/model/slot_model.dart';
// import 'package:tawasul_application/view/Checkout/address_selection.dart';
// import 'package:tawasul_application/view/Checkout/payment_method.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class RelayPoint {
//   final int? idRelayPoint;
//   final String? relayPointName;
//   final String? image;
//   final int? groupId;
//   final int? relayGroupId;
//   final int? shippingGroupId;

//   RelayPoint({
//     this.idRelayPoint,
//     this.relayPointName,
//     this.image,
//     this.groupId,
//     this.relayGroupId,
//     this.shippingGroupId,
//   });

//   factory RelayPoint.fromJson(Map<String, dynamic> json) {
//     return RelayPoint(
//       idRelayPoint: json['id'],
//       relayPointName: json['name'],
//       image: json['image'],
//       groupId: json['id_group'],
//       relayGroupId: json['relay_group_id'],
//       shippingGroupId: json['shipping_group_id'],
//     );
//   }
// }

// class ShippingResponse {
//   final List<CarrierModel> carriers;

//   ShippingResponse({required this.carriers});

//   factory ShippingResponse.fromJson(Map<String, dynamic> json) {
//     final carriersData = json['carriers'];
//     List<CarrierModel> productList = [];

//     if (carriersData is List) {
//       productList = carriersData.map((e) => CarrierModel.fromJson(e)).toList();
//     }

//     return ShippingResponse(carriers: productList);
//   }
// }

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

//   List<String> cities = [];
//   List<String> shops = [];
//   List<String> timeSlots = [];

//   int? cartId;
//   Map<String, int> cityToGroupId = {}; // Map city names to group IDs
//   Map<String, int> shopToPointId = {}; // Map shop names to point IDs

//   @override
//   void initState() {
//     super.initState();
//     _loadCart();
//     _debugCartFlow();
//   }

//   Future<void> _loadCart() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cartIdString = prefs.getString('cart_id') ?? '';
//     final loadedCartId = int.tryParse(cartIdString) ?? 0;

//     print('Stored cart_id: $cartIdString');
//     print('Parsed cartId: $loadedCartId');

//     if (loadedCartId > 0) {
//       setState(() {
//         cartId = loadedCartId;
//       });

//       // Also verify the auth token
//       final token = prefs.getString('auth_token');
//       print('Auth token exists: ${token != null}');
//       if (token != null) {
//         print('Auth token length: ${token.length}');
//       }

//       // Load cities from shipping list
//       await _loadCities(loadedCartId);
//     } else {
//       print("No valid cart ID found");
//     }
//   }

//   Future<void> _loadCities(int cartId) async {
//     try {
//       final carriers = await getShippingList(cartId);
//       if (carriers.isNotEmpty) {
//         setState(() {
//           cities = [];
//           cityToGroupId = {};
//           for (final carrier in carriers) {
//             if (carrier.relayGroups != null) {
//               for (final group in carrier.relayGroups!) {
//                 cities.add(group.relayGroupName ?? 'Unknown City');
//                 cityToGroupId[group.relayGroupName ?? 'Unknown City'] =
//                     group.idRelayGroup;
//               }
//             }
//           }

//           if (cities.isNotEmpty) {
//             selectedCity = cities.first;
//             // Load shops for the first city
//             final firstGroupId = cityToGroupId[selectedCity!];
//             if (firstGroupId != null) {
//               _loadShopsForCity(cartId, firstGroupId);
//             }
//           }
//         });
//       }
//     } catch (e) {
//       print('Error loading cities: $e');
//     }
//   }

//   Future<void> _loadShopsForCity(int cartId, int groupId) async {
//     try {
//       final relayPoints = await getRelayPoints(cartId, groupId);
//       setState(() {
//         shops = [];
//         shopToPointId = {};

//         for (final point in relayPoints) {
//           shops.add(point.relayPointName ?? 'Unknown Store');
//           shopToPointId[point.relayPointName ?? 'Unknown Store'] =
//               point.idRelayPoint!;
//         }

//         if (shops.isNotEmpty) {
//           selectedShop = shops.first;
//           final firstPointId = shopToPointId[selectedShop!];
//           if (firstPointId != null) {
//             _loadTimeSlotsForShop(cartId, firstPointId);
//           }
//         }
//       });
//     } catch (e) {
//       print('Error loading shops: $e');
//     }
//   }

//   Future<void> _loadTimeSlotsForShop(int cartId, int pointId) async {
//     try {
//       final slots = await getAvailableSlots(cartId, pointId);
//       setState(() {
//         timeSlots =
//             slots.map((slot) {
//               return slot.time ??
//                   slot.slot ??
//                   '${slot.startTime ?? ''} - ${slot.endTime ?? ''}'.trim();
//             }).toList();

//         if (timeSlots.isNotEmpty) {
//           selectedTime = timeSlots.first;
//         } else {
//           selectedTime = null;
//         }
//       });
//     } catch (e) {
//       print('Error loading time slots: $e');
//     }
//   }

//   /*-------------------------- SHIPPING LIST ----------------------------------*/
//   static Future<List<CarrierModel>> getShippingList(int cartId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       if (token == null) {
//         throw Exception('No authentication token found');
//       }

//       print(' Making API request with cartId: $cartId');

//       final response = await http.get(
//         Uri.parse(
//           'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print(' API Response Status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           final carriersData = responseData['carriers'];

//           if (carriersData is List && carriersData.isNotEmpty) {
//             final List<CarrierModel> carriers =
//                 carriersData
//                     .map<CarrierModel>(
//                       (carrierJson) => CarrierModel.fromJson(carrierJson),
//                     )
//                     .toList();
//             print(' Successfully loaded ${carriers.length} carriers');
//             return carriers;
//           } else {
//             print(' No carriers data in response');
//             return [];
//           }
//         } else {
//           final errorMessage = responseData['error'] ?? 'Unknown error';
//           print(' API Error: $errorMessage');

//           // Specific handling for unauthorized access
//           if (errorMessage.contains('Unauthorized')) {
//             throw Exception('Cart does not belong to current user');
//           }

//           return [];
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print(' Exception in getShippingList: $e');
//       rethrow; // Re-throw to handle in calling method
//     }
//   }

//   // Add this method to debug your cart flow
//   Future<void> _debugCartFlow() async {
//     final prefs = await SharedPreferences.getInstance();

//     print('=== CART FLOW DEBUG ===');
//     print('User logged in: ${prefs.getString('auth_token') != null}');
//     print('Stored cart_id: ${prefs.getString('cart_id')}');
//     print('User ID: ${prefs.getString('user_id')}');

//     // If you have a user ID stored, verify the cart belongs to this user
//     final userId = prefs.getString('user_id');
//     final cartId = prefs.getString('cart_id');

//     if (userId != null && cartId != null) {
//       print('Verifying cart $cartId belongs to user $userId');
//     }
//   }

//   /*-------------------------- SHIPPING STORE ----------------------------------*/
//   Future<List<RelayPoint>> getRelayPoints(int cartId, int groupId) async {
//     try {
//       // Using id_group instead of id_relay
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippingstore?id_cart=$cartId&id_group=$groupId',
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('Stores API Response Status: ${response.statusCode}');
//       print('Stores API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           // FIXED: Using 'points' instead of 'data' or 'stores'
//           if (body['points'] != null) {
//             final List<dynamic> pointsList = body['points'];
//             return pointsList.map((e) => RelayPoint.fromJson(e)).toList();
//           }
//         }
//       }

//       return [];
//     } catch (e) {
//       print('Error in getRelayPoints: $e');
//       return [];
//     }
//   }

//   /*-------------------------- SHIPPING HOURS ----------------------------------*/
//   Future<List<SlotModel>> getAvailableSlots(int cartId, int pointId) async {
//     try {
//       // NOTE: You might need to adjust this endpoint based on your API
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippinghours?id_cart=$cartId&id_point=$pointId',
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('Slots API Response Status: ${response.statusCode}');
//       print('Slots API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           if (body['slots'] != null) {
//             final List<dynamic> slotsList = body['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           } else if (body['data'] != null && body['data']['slots'] != null) {
//             final List<dynamic> slotsList = body['data']['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           }
//         }
//       }

//       return [];
//     } catch (e) {
//       print('Error in getAvailableSlots: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AddressSelection()),
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
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
//               child: Text(
//                 t.deliveryMethod,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildDeliveryOption(t.homeDelivery, "home"),
//             const SizedBox(height: 20),
//             _buildDeliveryOption(t.storePickupDelivery, "pickup"),

//             if (selectedMethod == "pickup") ...[
//               const SizedBox(height: 20),
//               _buildDropdown(
//                 hint: t.selectCity,
//                 value: selectedCity,
//                 items: cities,
//                 onChanged: (val) {
//                   if (val != null && cartId != null) {
//                     setState(() {
//                       selectedCity = val;
//                       selectedShop = null;
//                       selectedTime = null;
//                       shops = [];
//                       timeSlots = [];
//                     });
//                     // Load shops for the selected city
//                     final groupId = cityToGroupId[val];
//                     if (groupId != null) {
//                       _loadShopsForCity(cartId!, groupId);
//                     }
//                   }
//                 },
//               ),
//               const SizedBox(height: 15),

//               if (shops.isNotEmpty)
//                 _buildDropdown(
//                   hint: t.selectShop,
//                   value: selectedShop,
//                   items: shops,
//                   onChanged: (val) {
//                     if (val != null && cartId != null) {
//                       setState(() {
//                         selectedShop = val;
//                         selectedTime = null;
//                         timeSlots = [];
//                       });
//                       // Load time slots for the selected shop
//                       final pointId = shopToPointId[val];
//                       if (pointId != null) {
//                         _loadTimeSlotsForShop(cartId!, pointId);
//                       }
//                     }
//                   },
//                 ),
//               const SizedBox(height: 20),

//               if (timeSlots.isNotEmpty)
//                 Card(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   borderOnForeground: true,
//                   shadowColor: const Color.fromARGB(255, 0, 0, 0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               t.pickingDateTime,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Spacer(),
//                             Icon(Icons.calendar_today, size: 20),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children:
//                               timeSlots.map((slot) {
//                                 final isSelected = slot == selectedTime;
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedTime = slot;
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color:
//                                           isSelected
//                                               ? Colors.orange
//                                               : const Color(0xFFE9EAEB),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Text(
//                                       slot,
//                                       style: TextStyle(
//                                         color:
//                                             isSelected
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF008AD2),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed:
//                     () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PaymentMethod()),
//                     ),
//                 child: Text(
//                   t.validateAndContinue,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(String label, String value) {
//     return InkWell(
//       onTap: () {
//         setState(() => selectedMethod = value);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selectedMethod == value ? Colors.orange : Colors.grey,
//           ),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selectedMethod == value
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: Colors.orange,
//             ),
//             const SizedBox(width: 10),
//             Text(label, style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/l10n/app_localizations.dart';
// import 'package:tawasul_application/model/carrier_model.dart';
// import 'package:tawasul_application/model/slot_model.dart';
// import 'package:tawasul_application/preferences/shared_preferences_services.dart';
// import 'package:tawasul_application/view/Checkout/payment_method.dart';

// class DeliveryMethod extends StatefulWidget {
//   const DeliveryMethod({super.key});

//   @override
//   State<DeliveryMethod> createState() => _DeliveryMethodState();
// }

// class RelayPoint {
//   final int? idRelayPoint;
//   final String? relayPointName;
//   final String? image;
//   final int? groupId;
//   final int? relayGroupId;
//   final int? shippingGroupId;

//   RelayPoint({
//     this.idRelayPoint,
//     this.relayPointName,
//     this.image,
//     this.groupId,
//     this.relayGroupId,
//     this.shippingGroupId,
//   });

//   factory RelayPoint.fromJson(Map<String, dynamic> json) {
//     return RelayPoint(
//       idRelayPoint: json['id'],
//       relayPointName: json['name'],
//       image: json['image'],
//       groupId: json['id_group'],
//       relayGroupId: json['relay_group_id'],
//       shippingGroupId: json['shipping_group_id'],
//     );
//   }
// }

// class _DeliveryMethodState extends State<DeliveryMethod> {
//   String selectedMethod = "home";
//   String? selectedCity;
//   String? selectedShop;
//   String? selectedTime;

//   List<String> cities = [];
//   List<String> shops = [];
//   List<String> timeSlots = [];

//   int? cartId;
//   Map<String, int> cityToGroupId = {};
//   Map<String, int> shopToPointId = {};

//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadCart();
//   }

//   Future<void> _loadCart() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       // Use your SharedPreferencesService
//       final token = await SharedPreferencesService.getAuthToken();
//       final loadedCartId = await SharedPreferencesService.getCartId();
//       final userId = await SharedPreferencesService.getUserId();

//       print('🛒 Cart ID from service: $loadedCartId');
//       print('🔑 Auth token exists: ${token != null}');
//       print('👤 User ID: $userId');

//       // Debug stored data
//       await SharedPreferencesService.debugStoredData();

//       if (token == null) {
//         print('❌ User not authenticated');
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Please login to continue checkout';
//         });
//         return;
//       }

//       if (loadedCartId == null || loadedCartId <= 0) {
//         print('❌ Invalid cart ID: $loadedCartId');
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Cart not found. Please add items to cart.';
//         });
//         return;
//       }

//       setState(() {
//         cartId = loadedCartId;
//       });

//       await _loadCities(loadedCartId);
//     } catch (e) {
//       print('❌ Error in _loadCart: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading cart: $e';
//       });
//     }
//   }

//   Future<void> _loadCities(int cartId) async {
//     try {
//       print('🌆 Loading cities for cart: $cartId');
//       final carriers = await getShippingList(cartId);

//       if (carriers.isEmpty) {
//         print('❌ No carriers found - cart might be invalid');
//         _handleInvalidCart();
//         return;
//       }

//       setState(() {
//         cities = [];
//         cityToGroupId = {};

//         for (final carrier in carriers) {
//           if (carrier.relayGroups != null) {
//             for (final group in carrier.relayGroups!) {
//               final cityName = group.relayGroupName ?? 'Unknown City';
//               cities.add(cityName);
//               cityToGroupId[cityName] = group.idRelayGroup;
//             }
//           }
//         }

//         print('✅ Found ${cities.length} cities: $cities');

//         if (cities.isNotEmpty) {
//           selectedCity = cities.first;
//           final firstGroupId = cityToGroupId[selectedCity!];
//           if (firstGroupId != null) {
//             _loadShopsForCity(cartId, firstGroupId);
//           } else {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         } else {
//           print('⚠️ No cities available for this cart');
//           setState(() {
//             isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print('❌ Error loading cities: $e');
//       _handleInvalidCart();
//     }
//   }

//   Future<void> _loadShopsForCity(int cartId, int groupId) async {
//     try {
//       final relayPoints = await getRelayPoints(cartId, groupId);
//       setState(() {
//         shops = [];
//         shopToPointId = {};

//         for (final point in relayPoints) {
//           shops.add(point.relayPointName ?? 'Unknown Store');
//           shopToPointId[point.relayPointName ?? 'Unknown Store'] =
//               point.idRelayPoint!;
//         }

//         print('✅ Found ${shops.length} shops: $shops');

//         if (shops.isNotEmpty) {
//           selectedShop = shops.first;
//           final firstPointId = shopToPointId[selectedShop!];
//           if (firstPointId != null) {
//             _loadTimeSlotsForShop(cartId, firstPointId);
//           } else {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print('❌ Error loading shops: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading stores: $e';
//       });
//     }
//   }

//   Future<void> _loadTimeSlotsForShop(int cartId, int pointId) async {
//     try {
//       final slots = await getAvailableSlots(cartId, pointId);
//       setState(() {
//         timeSlots =
//             slots.map((slot) {
//               return slot.time ??
//                   slot.slot ??
//                   '${slot.startTime ?? ''} - ${slot.endTime ?? ''}'.trim();
//             }).toList();

//         print('✅ Found ${timeSlots.length} time slots: $timeSlots');

//         if (timeSlots.isNotEmpty) {
//           selectedTime = timeSlots.first;
//         } else {
//           selectedTime = null;
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print('❌ Error loading time slots: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading time slots: $e';
//       });
//     }
//   }

//   void _handleInvalidCart() async {
//     print('🔄 Handling invalid cart...');

//     // Clear the invalid cart from storage
//     await SharedPreferencesService.removeCartId();

//     setState(() {
//       isLoading = false;
//       errorMessage =
//           'Your cart session has expired. Please add items to cart again.';
//     });
//   }

//   /*-------------------------- SHIPPING LIST ----------------------------------*/
//   static Future<List<CarrierModel>> getShippingList(int cartId) async {
//     try {
//       final token = await SharedPreferencesService.getAuthToken();

//       if (token == null) {
//         throw Exception('No authentication token found');
//       }

//       print('🚀 Making API request with cartId: $cartId');

//       final response = await http.get(
//         Uri.parse(
//           'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('📦 API Response Status: ${response.statusCode}');
//       print('📦 API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           final carriersData = responseData['carriers'];

//           if (carriersData is List && carriersData.isNotEmpty) {
//             final List<CarrierModel> carriers =
//                 carriersData
//                     .map<CarrierModel>(
//                       (carrierJson) => CarrierModel.fromJson(carrierJson),
//                     )
//                     .toList();
//             print('✅ Successfully loaded ${carriers.length} carriers');
//             return carriers;
//           } else {
//             print('⚠️ No carriers data in response');
//             return [];
//           }
//         } else {
//           final errorMessage = responseData['error'] ?? 'Unknown error';
//           print('❌ API Error: $errorMessage');

//           // Specific handling for unauthorized access
//           if (errorMessage.contains('Unauthorized')) {
//             throw Exception('Cart does not belong to current user');
//           }

//           return [];
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Exception in getShippingList: $e');
//       rethrow;
//     }
//   }

//   /*-------------------------- SHIPPING STORE ----------------------------------*/
//   Future<List<RelayPoint>> getRelayPoints(int cartId, int groupId) async {
//     try {
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippingstore?id_cart=$cartId&id_group=$groupId',
//       );

//       final token = await SharedPreferencesService.getAuthToken();

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('🏪 Stores API Response Status: ${response.statusCode}');
//       print('🏪 Stores API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           if (body['points'] != null) {
//             final List<dynamic> pointsList = body['points'];
//             return pointsList.map((e) => RelayPoint.fromJson(e)).toList();
//           }
//         } else {
//           print('❌ Stores API Error: ${body['error']}');
//         }
//       }

//       return [];
//     } catch (e) {
//       print('❌ Error in getRelayPoints: $e');
//       rethrow;
//     }
//   }

//   /*-------------------------- SHIPPING HOURS ----------------------------------*/
//   Future<List<SlotModel>> getAvailableSlots(int cartId, int pointId) async {
//     try {
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippinghours?id_cart=$cartId&id_point=$pointId',
//       );

//       final token = await SharedPreferencesService.getAuthToken();

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('⏰ Slots API Response Status: ${response.statusCode}');
//       print('⏰ Slots API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           if (body['slots'] != null) {
//             final List<dynamic> slotsList = body['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           } else if (body['data'] != null && body['data']['slots'] != null) {
//             final List<dynamic> slotsList = body['data']['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           }
//         }
//       }

//       return [];
//     } catch (e) {
//       print('❌ Error in getAvailableSlots: $e');
//       rethrow;
//     }
//   }

//   void _retryLoading() {
//     setState(() {
//       errorMessage = null;
//     });
//     _loadCart();
//   }

//   void _goBackToCart() {
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
//           child: GestureDetector(
//             onTap: _goBackToCart,
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
//           isLoading
//               ? _buildLoadingState()
//               : errorMessage != null
//               ? _buildErrorState()
//               : _buildContent(t),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 20),
//           Text('Loading delivery options...'),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 50),
//             SizedBox(height: 20),
//             Text(
//               errorMessage!,
//               style: TextStyle(fontSize: 16, color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _retryLoading,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF008AD2),
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text(
//                 'Retry',
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: _goBackToCart,
//               child: Text(
//                 'Go Back',
//                 style: TextStyle(color: Color(0xFF008AD2), fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(AppLocalizations t) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 12, bottom: 18),
//             child: Text(
//               t.deliveryMethod,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           _buildDeliveryOption(t.homeDelivery, "home"),
//           const SizedBox(height: 20),
//           _buildDeliveryOption(t.storePickupDelivery, "pickup"),

//           if (selectedMethod == "pickup") ..._buildPickupContent(t),

//           const SizedBox(height: 30),
//           _buildContinueButton(t),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildPickupContent(AppLocalizations t) {
//     return [
//       const SizedBox(height: 20),
//       _buildDropdown(
//         hint: t.selectCity,
//         value: selectedCity,
//         items: cities,
//         onChanged: (val) {
//           if (val != null && cartId != null) {
//             setState(() {
//               selectedCity = val;
//               selectedShop = null;
//               selectedTime = null;
//               shops = [];
//               timeSlots = [];
//             });
//             final groupId = cityToGroupId[val];
//             if (groupId != null) {
//               _loadShopsForCity(cartId!, groupId);
//             }
//           }
//         },
//       ),
//       const SizedBox(height: 15),

//       if (shops.isNotEmpty)
//         _buildDropdown(
//           hint: t.selectShop,
//           value: selectedShop,
//           items: shops,
//           onChanged: (val) {
//             if (val != null && cartId != null) {
//               setState(() {
//                 selectedShop = val;
//                 selectedTime = null;
//                 timeSlots = [];
//               });
//               final pointId = shopToPointId[val];
//               if (pointId != null) {
//                 _loadTimeSlotsForShop(cartId!, pointId);
//               }
//             }
//           },
//         ),
//       const SizedBox(height: 20),

//       if (timeSlots.isNotEmpty) _buildTimeSlotsCard(t),
//     ];
//   }

//   Widget _buildTimeSlotsCard(AppLocalizations t) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       borderOnForeground: true,
//       shadowColor: const Color.fromARGB(255, 0, 0, 0),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   t.pickingDateTime,
//                   style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
//                 ),
//                 Spacer(),
//                 Icon(Icons.calendar_today, size: 20),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children:
//                   timeSlots.map((slot) {
//                     final isSelected = slot == selectedTime;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedTime = slot;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color:
//                               isSelected
//                                   ? Colors.orange
//                                   : const Color(0xFFE9EAEB),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           slot,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: const Color(0xFFFFFFFF),
//                 border: Border.all(color: Colors.black),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         t.dateTime,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(t.september142025),
//                     ],
//                   ),
//                   Text(
//                     selectedTime ?? t.selectTime,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContinueButton(AppLocalizations t) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF008AD2),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => PaymentMethod()),
//             ),
//         child: Text(
//           t.validateAndContinue,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryOption(String label, String value) {
//     return InkWell(
//       onTap: () {
//         setState(() => selectedMethod = value);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selectedMethod == value ? Colors.orange : Colors.grey,
//           ),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selectedMethod == value
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: Colors.orange,
//             ),
//             const SizedBox(width: 10),
//             Text(label, style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
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

// // Cart Validator Utility Class
// class CartValidator {
//   static Future<bool> validateCart(BuildContext context) async {
//     try {
//       final token = await SharedPreferencesService.getAuthToken();
//       final cartId = await SharedPreferencesService.getCartId();

//       if (token == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Please login to continue')));
//         return false;
//       }

//       if (cartId == null || cartId <= 0) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Cart not found')));
//         return false;
//       }

//       // Test the cart with a simple API call
//       final response = await http.get(
//         Uri.parse(
//           'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
//         ),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['success'] == true;
//       }

//       return false;
//     } catch (e) {
//       print('Cart validation error: $e');
//       return false;
//     }
//   }

//   static void proceedToDelivery(BuildContext context) async {
//     bool isValid = await validateCart(context);
//     if (isValid) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => DeliveryMethod()),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Please add items to cart first')));
//     }
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/l10n/app_localizations.dart';
import 'package:tawasul_application/model/carrier_model.dart';
import 'package:tawasul_application/model/slot_model.dart';
import 'package:tawasul_application/preferences/shared_preferences_services.dart';
import 'package:tawasul_application/view/Checkout/payment_method.dart';

class RelayPoint {
  final int? idRelayPoint;
  final String? relayPointName;
  final String? image;
  final int? groupId;
  final int? relayGroupId;
  final int? shippingGroupId;

  RelayPoint({
    this.idRelayPoint,
    this.relayPointName,
    this.image,
    this.groupId,
    this.relayGroupId,
    this.shippingGroupId,
  });

  factory RelayPoint.fromJson(Map<String, dynamic> json) {
    return RelayPoint(
      idRelayPoint: json['id_relay_point'],
      relayPointName: json['relay_point_name'],
      image: json['image'],
      groupId: null,
      relayGroupId: null,
      shippingGroupId: null,
    );
  }
}

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

  List<String> cities = [];
  List<String> shops = [];
  List<String> timeSlots = [];

  int? cartId;
  Map<String, int> cityToGroupId = {};
  Map<String, int> shopToPointId = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
      _debugCartOwnership();

    _loadCart();
  }
  Future<void> _debugCartOwnership() async {
  final token = await SharedPreferencesService.getAuthToken();
  final cartId = await SharedPreferencesService.getCartId();
  
  print('\n🔍 CART OWNERSHIP DEBUG:');
  print('👤 User Token (first 30 chars): ${token?.substring(0, min(30, token?.length ?? 0))}...');
  print('🛒 Stored Cart ID: $cartId');
  print('🔗 API Base: https://tawasul-dev.app-staging.fr');
  print('📞 Endpoint: /public/getshippinglist?id_cart=$cartId');
  print('--- END DEBUG ---\n');
}

  Future<void> _initializeAndLoadCart() async {
    try {
      // First, fix any cart ID type issues
      //await SharedPreferencesService.fixCartIdType();

      // Then load the cart
      await _loadCart();
    } catch (e) {
      print('❌ Error in initialization: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Initialization error: $e';
      });
    }
  }

  Future<void> _loadCart() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final token = await SharedPreferencesService.getAuthToken();
      final loadedCartId = await SharedPreferencesService.getCartId();

      print('🔑 Auth token exists: ${token != null}');
      print('🛒 Cart ID: $loadedCartId');

      if (token == null) {
        print('❌ User not authenticated');
        setState(() {
          isLoading = false;
          errorMessage = 'Please login to continue checkout';
        });
        return;
      }

      if (loadedCartId == null) {
        print('❌ No cart ID found');
        setState(() {
          isLoading = false;
          errorMessage = 'No active cart found. Please add items to your cart.';
        });
        return;
      }

      setState(() {
        cartId = loadedCartId;
      });

      await _loadCities(loadedCartId);
    } catch (e) {
      print('❌ Error in _loadCart: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading cart: ${e.toString()}';
      });
    }
  }

  Future<void> _loadCities(int cartId) async {
    try {
      print('🌆 Loading cities for cart: $cartId');
      print('📋 Checking cart validity...');

      final carriers = await getShippingList(cartId);

      if (carriers.isEmpty) {
        print(
          '⚠️  No carriers found - cart might be empty or location not supported',
        );
        setState(() {
          isLoading = false;
          errorMessage =
              'No delivery options available for your location or cart is empty.';
        });
        return;
      }

      setState(() {
        cities = [];
        cityToGroupId = {};

        for (final carrier in carriers) {
          final relayGroups = carrier.relayGroups;
          if (relayGroups != null && relayGroups.isNotEmpty) {
            for (final group in relayGroups) {
              final cityName = group.relayGroupName ?? 'Unknown City';
              final groupId = group.idRelayGroup;
              if (groupId != null) {
                cities.add(cityName);
                cityToGroupId[cityName] = groupId;
              }
            }
          }
        }

        print('✅ Found ${cities.length} cities: $cities');
        print('✅ City to Group ID mapping: $cityToGroupId');

        if (cities.isNotEmpty) {
          selectedCity = cities.first;
          final firstGroupId = cityToGroupId[selectedCity];
          if (firstGroupId != null) {
            print(
              '🔄 Loading shops for first city: $selectedCity (Group ID: $firstGroupId)',
            );
            _loadShopsForCity(cartId, firstGroupId);
          } else {
            print('❌ No group ID found for selected city: $selectedCity');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('⚠️  No cities available in carriers');
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print('❌ ERROR in _loadCities:');
      print('❌ Error Type: ${e.runtimeType}');
      print('❌ Error Message: $e');

      // Detailed error analysis
      final errorMsg = e.toString();

      if (errorMsg.contains('Unauthorized') ||
          errorMsg.contains('does not belong')) {
        print('🔐 AUTH ISSUE: Cart ownership problem');
        await SharedPreferencesService.removeCartId();
        setState(() {
          isLoading = false;
          errorMessage =
              'Cart session expired. Please add items to cart again.';
        });
      } else if (errorMsg.contains('Cart not found')) {
        print('🛒 CART ISSUE: Cart does not exist');
        await SharedPreferencesService.removeCartId();
        setState(() {
          isLoading = false;
          errorMessage = 'Cart not found. Please add items to cart.';
        });
      } else if (errorMsg.contains('Authentication failed')) {
        print('🔑 TOKEN ISSUE: Login required');
        setState(() {
          isLoading = false;
          errorMessage = 'Please login again to continue.';
        });
      } else if (errorMsg.contains('Network is unreachable') ||
          errorMsg.contains('SocketException')) {
        print('🌐 NETWORK ISSUE: No internet connection');
        setState(() {
          isLoading = false;
          errorMessage = 'No internet connection. Please check your network.';
        });
      } else {
        print('🚨 UNKNOWN ERROR: Need further investigation');
        setState(() {
          isLoading = false;
          errorMessage = 'Error loading delivery options: ${e.toString()}';
        });
      }
    }
  }

  void _debugCurrentState() {
    print('\n=== DEBUG CURRENT STATE ===');
    print('📱 Screen: DeliveryMethod');
    print('🔄 Loading: $isLoading');
    print('❌ Error: $errorMessage');
    print('🛒 Cart ID: $cartId');
    print('🏙️ Cities: $cities');
    print('🏪 Shops: $shops');
    print('⏰ Time Slots: $timeSlots');
    print('📍 Selected City: $selectedCity');
    print('🏬 Selected Shop: $selectedShop');
    print('⏱️ Selected Time: $selectedTime');
    print('=== END DEBUG ===\n');
  }

  Future<void> _loadShopsForCity(int cartId, int groupId) async {
    try {
      final relayPoints = await getRelayPoints(cartId, groupId);
      setState(() {
        shops = [];
        shopToPointId = {};

        for (final point in relayPoints) {
          final shopName = point.relayPointName ?? 'Unknown Store';
          final pointId = point.idRelayPoint;
          if (pointId != null) {
            shops.add(shopName);
            shopToPointId[shopName] = pointId;
          }
        }

        print(' Found ${shops.length} shops: $shops');

        if (shops.isNotEmpty) {
          selectedShop = shops.first;
          final firstPointId = shopToPointId[selectedShop];
          if (firstPointId != null) {
            _loadTimeSlotsForShop(cartId, firstPointId);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print(' Error loading shops: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadTimeSlotsForShop(int cartId, int pointId) async {
    try {
      final slots = await getAvailableSlots(cartId, pointId);
      setState(() {
        timeSlots =
            slots.map((slot) {
              return slot.time ??
                  slot.slot ??
                  '${slot.startTime ?? ''} - ${slot.endTime ?? ''}'.trim();
            }).toList();

        print(' Found ${timeSlots.length} time slots');
        selectedTime = timeSlots.isNotEmpty ? timeSlots.first : null;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading time slots: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleInvalidCart() async {
    print('🔄 Handling invalid cart...');

    // Clear the invalid cart from storage
    await SharedPreferencesService.removeCartId();

    setState(() {
      isLoading = false;
      errorMessage =
          'Your cart session has expired. Please add items to cart again.';
    });
  }

  /*-------------------------- SHIPPING LIST ----------------------------------*/
  static Future<List<CarrierModel>> getShippingList(int cartId) async {
    try {
      final token = await SharedPreferencesService.getAuthToken();

      if (token == null) {
        print('❌ AUTH ERROR: No authentication token found');
        throw Exception('No authentication token found');
      }

      print('🚀 Making API request with cartId: $cartId');
      print(
        '🔑 Using token: ${token.substring(0, 20)}...',
      ); // Log first 20 chars for debugging

      final response = await http.get(
        Uri.parse(
          'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📦 API Response Status: ${response.statusCode}');
      print('📦 API Response Headers: ${response.headers}');
      print('📦 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final carriersData = responseData['carriers'];

          if (carriersData is List) {
            print('✅ SUCCESS: Found ${carriersData.length} carriers');
            final List<CarrierModel> carriers =
                carriersData
                    .map<CarrierModel>(
                      (carrierJson) => CarrierModel.fromJson(carrierJson),
                    )
                    .toList();
            return carriers;
          } else {
            print(
              '❌ DATA FORMAT ERROR: carriers is not a List, it\'s: ${carriersData.runtimeType}',
            );
            return [];
          }
        } else {
          final errorMessage = responseData['error'] ?? 'Unknown error';
          final errorCode = responseData['error_code'] ?? 'No error code';

          print('❌ API BUSINESS ERROR: $errorMessage');
          print('❌ API ERROR CODE: $errorCode');
          print('❌ FULL ERROR RESPONSE: $responseData');

          throw Exception('$errorMessage (Code: $errorCode)');
        }
      } else if (response.statusCode == 401) {
        print('❌ HTTP 401: Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed - Please login again');
      } else if (response.statusCode == 404) {
        print('❌ HTTP 404: Cart not found - Cart ID $cartId does not exist');
        throw Exception('Cart not found - Please add items to cart');
      } else if (response.statusCode == 403) {
        print('❌ HTTP 403: Forbidden - User does not have access to this cart');
        throw Exception('You do not have access to this cart');
      } else {
        print(
          '❌ HTTP ERROR: ${response.statusCode} - ${response.reasonPhrase}',
        );
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NETWORK/EXCEPTION in getShippingList:');
      print('❌ Exception Type: ${e.runtimeType}');
      print('❌ Exception Message: $e');
      print(
        '❌ Stack Trace: ${e is Exception ? e.toString() : "No stack trace"}',
      );
      rethrow;
    }
  }

  /*-------------------------- SHIPPING STORE ----------------------------------*/
  Future<List<RelayPoint>> getRelayPoints(int cartId, int groupId) async {
    try {
      final url = Uri.parse(
        'https://tawasul-dev.app-staging.fr/public/getshippingstore?id_cart=$cartId&id_relay_group=$groupId',
      );

      final token = await SharedPreferencesService.getAuthToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🏪 Stores API Response Status: ${response.statusCode}');
      print('🏪 Stores API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['success'] == true) {
          if (body['points'] != null) {
            final List<dynamic> pointsList = body['points'];
            return pointsList.map((e) => RelayPoint.fromJson(e)).toList();
          }
        } else {
          print('❌ Stores API Error: ${body['error']}');
        }
      }

      return [];
    } catch (e) {
      print(' Error in getRelayPoints: $e');
      rethrow;
    }
  }

  /*-------------------------- SHIPPING HOURS ----------------------------------*/
  Future<List<SlotModel>> getAvailableSlots(int cartId, int pointId) async {
    try {
      final url = Uri.parse(
        'https://tawasul-dev.app-staging.fr/public/getshippinghours?id_cart=$cartId&id_relay_point=$pointId',
      );

      final token = await SharedPreferencesService.getAuthToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('⏰ Slots API Response Status: ${response.statusCode}');
      print('⏰ Slots API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['success'] == true) {
          if (body['slots'] != null) {
            final List<dynamic> slotsList = body['slots'];
            return slotsList.map((e) => SlotModel.fromJson(e)).toList();
          } else if (body['data'] != null && body['data']['slots'] != null) {
            final List<dynamic> slotsList = body['data']['slots'];
            return slotsList.map((e) => SlotModel.fromJson(e)).toList();
          }
        }
      }

      return [];
    } catch (e) {
      print('❌ Error in getAvailableSlots: $e');
      rethrow;
    }
  }

  void _retryLoading() {
    setState(() {
      errorMessage = null;
    });
    _loadCart();
  }

  void _goBackToCart() {
    Navigator.pop(context);
  }

  void _clearCartAndRetry() async {
    await SharedPreferencesService.removeCartId();
    _retryLoading();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: GestureDetector(
            onTap: _goBackToCart,
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
          isLoading
              ? _buildLoadingState()
              : errorMessage != null
              ? _buildErrorState()
              : _buildContent(t),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading delivery options...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 20),
            Text(
              errorMessage ?? 'An error occurred',
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _retryLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008AD2),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'Retry',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearCartAndRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'Clear Cart & Retry',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _goBackToCart,
              child: Text(
                'Go Back',
                style: TextStyle(color: Color(0xFF008AD2), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations t) {
    return SingleChildScrollView(
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

          if (selectedMethod == "pickup") ..._buildPickupContent(t),

          const SizedBox(height: 30),
          _buildContinueButton(t),
        ],
      ),
    );
  }

  List<Widget> _buildPickupContent(AppLocalizations t) {
    return [
      const SizedBox(height: 20),
      _buildDropdown(
        hint: t.selectCity,
        value: selectedCity,
        items: cities,
        onChanged: (val) {
          if (val != null && cartId != null) {
            setState(() {
              selectedCity = val;
              selectedShop = null;
              selectedTime = null;
              shops = [];
              timeSlots = [];
            });
            final groupId = cityToGroupId[val];
            if (groupId != null) {
              _loadShopsForCity(cartId!, groupId);
            }
          }
        },
      ),
      const SizedBox(height: 15),

      if (shops.isNotEmpty)
        _buildDropdown(
          hint: t.selectShop,
          value: selectedShop,
          items: shops,
          onChanged: (val) {
            if (val != null && cartId != null) {
              setState(() {
                selectedShop = val;
                selectedTime = null;
                timeSlots = [];
              });
              final pointId = shopToPointId[val];
              if (pointId != null) {
                _loadTimeSlotsForShop(cartId!, pointId);
              }
            }
          },
        ),
      const SizedBox(height: 20),

      if (timeSlots.isNotEmpty) _buildTimeSlotsCard(t),
    ];
  }

  Widget _buildTimeSlotsCard(AppLocalizations t) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
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
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF008AD2),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/l10n/app_localizations.dart';
// import 'package:tawasul_application/model/carrier_model.dart';
// import 'package:tawasul_application/model/slot_model.dart';
// import 'package:tawasul_application/preferences/shared_preferences_services.dart';
// import 'package:tawasul_application/view/Checkout/payment_method.dart';

// class RelayPoint {
//   final int? idRelayPoint;
//   final String? relayPointName;
//   final String? image;
//   final int? groupId;
//   final int? relayGroupId;
//   final int? shippingGroupId;

//   RelayPoint({
//     this.idRelayPoint,
//     this.relayPointName,
//     this.image,
//     this.groupId,
//     this.relayGroupId,
//     this.shippingGroupId,
//   });

//   factory RelayPoint.fromJson(Map<String, dynamic> json) {
//     return RelayPoint(
//       idRelayPoint: json['id'],
//       relayPointName: json['name'],
//       image: json['image'],
//       groupId: json['id_group'],
//       relayGroupId: json['relay_group_id'],
//       shippingGroupId: json['shipping_group_id'],
//     );
//   }
// }

// class CartValidationResult {
//   final bool isValid;
//   final String? errorMessage;
//   final int? cartId;
//   final int? userId;

//   CartValidationResult({
//     required this.isValid,
//     this.errorMessage,
//     this.cartId,
//     this.userId,
//   });
// }

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

//   List<String> cities = [];
//   List<String> shops = [];
//   List<String> timeSlots = [];

//   int? cartId;
//   Map<String, int> cityToGroupId = {};
//   Map<String, int> shopToPointId = {};

//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadCart();
//   }

//   Future<void> _loadCart() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       // Debug stored data
//       await SharedPreferencesService.debugStoredData();

//       // Validate user and cart ownership
//       final validationResult = await _validateUserAndCart();
//       if (!validationResult.isValid) {
//         setState(() {
//           isLoading = false;
//           errorMessage = validationResult.errorMessage;
//         });
//         return;
//       }

//       final currentCartId = validationResult.cartId!;

//       setState(() {
//         cartId = currentCartId;
//       });

//       await _loadCities(currentCartId);
//     } catch (e) {
//       print(' Error in _loadCart: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading cart: $e';
//       });
//     }
//   }

//   Future<CartValidationResult> _validateUserAndCart() async {
//     try {
//       final currentUserId = await SharedPreferencesService.getUserId();
//       final currentCartId = await SharedPreferencesService.getCartId();
//       final token = await SharedPreferencesService.getAuthToken();

//       print('🔍 Validating user and cart:');
//       print('   User ID: $currentUserId');
//       print('   Cart ID: $currentCartId');
//       print('   Token: ${token != null ? "Exists" : "Missing"}');

//       // Check if user is logged in
//       if (token == null || currentUserId == null) {
//         return CartValidationResult(
//           isValid: false,
//           errorMessage: 'Please login to continue checkout',
//         );
//       }

//       // Check if cart exists
//       if (currentCartId == null || currentCartId <= 0) {
//         return CartValidationResult(
//           isValid: false,
//           errorMessage: 'Cart not found. Please add items to cart.',
//         );
//       }

//       // Now we have both user ID and cart ID
//       // The backend API should validate that this cart belongs to this user

//       return CartValidationResult(
//         isValid: true,
//         cartId: currentCartId,
//         userId: currentUserId,
//       );
//     } catch (e) {
//       return CartValidationResult(
//         isValid: false,
//         errorMessage: 'Validation error: $e',
//       );
//     }
//   }

//   Future<void> _loadCities(int cartId) async {
//     try {
//       print('🌆 Loading cities for cart: $cartId');
//       final carriers = await getShippingList(cartId);

//       if (carriers.isEmpty) {
//         print('❌ No carriers found - cart might be invalid');
//         _handleInvalidCart();
//         return;
//       }

//       setState(() {
//         cities = [];
//         cityToGroupId = {};

//         for (final carrier in carriers) {
//           if (carrier.relayGroups != null) {
//             for (final group in carrier.relayGroups!) {
//               final cityName = group.relayGroupName ?? 'Unknown City';
//               cities.add(cityName);
//               cityToGroupId[cityName] = group.idRelayGroup;
//             }
//           }
//         }

//         print('✅ Found ${cities.length} cities: $cities');

//         if (cities.isNotEmpty) {
//           selectedCity = cities.first;
//           final firstGroupId = cityToGroupId[selectedCity!];
//           if (firstGroupId != null) {
//             _loadShopsForCity(cartId, firstGroupId);
//           }
//         } else {
//           print('⚠️ No cities available for this cart');
//           setState(() {
//             isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print('❌ Error loading cities: $e');
//       _handleInvalidCart();
//     }
//   }

//   Future<void> _loadShopsForCity(int cartId, int groupId) async {
//     try {
//       final relayPoints = await getRelayPoints(cartId, groupId);
//       setState(() {
//         shops = [];
//         shopToPointId = {};

//         for (final point in relayPoints) {
//           shops.add(point.relayPointName ?? 'Unknown Store');
//           shopToPointId[point.relayPointName ?? 'Unknown Store'] =
//               point.idRelayPoint!;
//         }

//         print('✅ Found ${shops.length} shops: $shops');

//         if (shops.isNotEmpty) {
//           selectedShop = shops.first;
//           // Load time slots for the first shop
//           final firstPointId = shopToPointId[selectedShop!];
//           if (firstPointId != null) {
//             _loadTimeSlotsForShop(cartId, firstPointId);
//           } else {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print('❌ Error loading shops: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading stores: $e';
//       });
//     }
//   }

//   Future<void> _loadTimeSlotsForShop(int cartId, int pointId) async {
//     try {
//       final slots = await getAvailableSlots(cartId, pointId);
//       setState(() {
//         timeSlots =
//             slots.map((slot) {
//               return slot.time ??
//                   slot.slot ??
//                   '${slot.startTime ?? ''} - ${slot.endTime ?? ''}'.trim();
//             }).toList();

//         print('✅ Found ${timeSlots.length} time slots: $timeSlots');

//         if (timeSlots.isNotEmpty) {
//           selectedTime = timeSlots.first;
//         } else {
//           selectedTime = null;
//         }
//         isLoading = false;
//       });
//     } catch (e) {
//       print('❌ Error loading time slots: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error loading time slots: $e';
//       });
//     }
//   }

//   void _handleInvalidCart() async {
//     print('🔄 Handling invalid cart...');

//     // Clear the invalid cart from storage
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('cart_id');

//     setState(() {
//       isLoading = false;
//       errorMessage =
//           'Your cart session has expired. Please add items to cart again.';
//     });
//   }

//   void _showError(String message, {SnackBarAction? action}) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           action: action,
//           duration: Duration(seconds: 5),
//         ),
//       );
//     }
//   }

//   /*-------------------------- SHIPPING LIST ----------------------------------*/
//   static Future<List<CarrierModel>> getShippingList(int cartId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       if (token == null) {
//         throw Exception('No authentication token found');
//       }

//       print('🚀 Making API request with cartId: $cartId');

//       final response = await http.get(
//         Uri.parse(
//           'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('📦 API Response Status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           final carriersData = responseData['carriers'];

//           if (carriersData is List && carriersData.isNotEmpty) {
//             final List<CarrierModel> carriers =
//                 carriersData
//                     .map<CarrierModel>(
//                       (carrierJson) => CarrierModel.fromJson(carrierJson),
//                     )
//                     .toList();
//             print('✅ Successfully loaded ${carriers.length} carriers');
//             return carriers;
//           } else {
//             print('⚠️ No carriers data in response');
//             return [];
//           }
//         } else {
//           final errorMessage = responseData['error'] ?? 'Unknown error';
//           print('❌ API Error: $errorMessage');

//           // Specific handling for unauthorized access
//           if (errorMessage.contains('Unauthorized')) {
//             throw Exception('Cart does not belong to current user');
//           }

//           return [];
//         }
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Exception in getShippingList: $e');
//       rethrow;
//     }
//   }

//   /*-------------------------- SHIPPING STORE ----------------------------------*/
//   Future<List<RelayPoint>> getRelayPoints(int cartId, int groupId) async {
//     try {
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippingstore?id_cart=$cartId&id_group=$groupId',
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('🏪 Stores API Response Status: ${response.statusCode}');
//       print('🏪 Stores API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           if (body['points'] != null) {
//             final List<dynamic> pointsList = body['points'];
//             return pointsList.map((e) => RelayPoint.fromJson(e)).toList();
//           }
//         } else {
//           print('❌ Stores API Error: ${body['error']}');
//         }
//       }

//       return [];
//     } catch (e) {
//       print('❌ Error in getRelayPoints: $e');
//       rethrow;
//     }
//   }

//   /*-------------------------- SHIPPING HOURS ----------------------------------*/
//   Future<List<SlotModel>> getAvailableSlots(int cartId, int pointId) async {
//     try {
//       final url = Uri.parse(
//         'https://tawasul-dev.app-staging.fr/public/getshippinghours?id_cart=$cartId&id_point=$pointId',
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       print('⏰ Slots API Response Status: ${response.statusCode}');
//       print('⏰ Slots API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         if (body['success'] == true) {
//           if (body['slots'] != null) {
//             final List<dynamic> slotsList = body['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           } else if (body['data'] != null && body['data']['slots'] != null) {
//             final List<dynamic> slotsList = body['data']['slots'];
//             return slotsList.map((e) => SlotModel.fromJson(e)).toList();
//           }
//         }
//       }

//       return [];
//     } catch (e) {
//       print('❌ Error in getAvailableSlots: $e');
//       rethrow;
//     }
//   }

//   void _retryLoading() {
//     setState(() {
//       errorMessage = null;
//     });
//     _loadCart();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: 18.w),
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
//         title: Text(t.checkout, style: TextStyle(color: Colors.black)),
//       ),
//       body:
//           isLoading
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 20),
//                     Text('Loading delivery options...'),
//                   ],
//                 ),
//               )
//               : errorMessage != null
//               ? Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red, size: 50),
//                       SizedBox(height: 20),
//                       Text(
//                         errorMessage!,
//                         style: TextStyle(fontSize: 16, color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _retryLoading,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF008AD2),
//                         ),
//                         child: Text('Retry'),
//                       ),
//                       SizedBox(height: 10),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text('Go Back'),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 12,
//                         top: 12,
//                         bottom: 18,
//                       ),
//                       child: Text(
//                         t.deliveryMethod,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     _buildDeliveryOption(t.homeDelivery, "home"),
//                     const SizedBox(height: 20),
//                     _buildDeliveryOption(t.storePickupDelivery, "pickup"),

//                     if (selectedMethod == "pickup") ...[
//                       const SizedBox(height: 20),
//                       _buildDropdown(
//                         hint: t.selectCity,
//                         value: selectedCity,
//                         items: cities,
//                         onChanged: (val) {
//                           if (val != null && cartId != null) {
//                             setState(() {
//                               selectedCity = val;
//                               selectedShop = null;
//                               selectedTime = null;
//                               shops = [];
//                               timeSlots = [];
//                             });
//                             final groupId = cityToGroupId[val];
//                             if (groupId != null) {
//                               _loadShopsForCity(cartId!, groupId);
//                             }
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 15),

//                       if (shops.isNotEmpty)
//                         _buildDropdown(
//                           hint: t.selectShop,
//                           value: selectedShop,
//                           items: shops,
//                           onChanged: (val) {
//                             if (val != null && cartId != null) {
//                               setState(() {
//                                 selectedShop = val;
//                                 selectedTime = null;
//                                 timeSlots = [];
//                               });
//                               final pointId = shopToPointId[val];
//                               if (pointId != null) {
//                                 _loadTimeSlotsForShop(cartId!, pointId);
//                               }
//                             }
//                           },
//                         ),
//                       const SizedBox(height: 20),

//                       if (timeSlots.isNotEmpty)
//                         Card(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           borderOnForeground: true,
//                           shadowColor: const Color.fromARGB(255, 0, 0, 0),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       t.pickingDateTime,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Icon(Icons.calendar_today, size: 20),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Wrap(
//                                   spacing: 8,
//                                   runSpacing: 8,
//                                   children:
//                                       timeSlots.map((slot) {
//                                         final isSelected = slot == selectedTime;
//                                         return GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               selectedTime = slot;
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                               vertical: 10,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color:
//                                                   isSelected
//                                                       ? Colors.orange
//                                                       : const Color(0xFFE9EAEB),
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             child: Text(
//                                               slot,
//                                               style: TextStyle(
//                                                 color:
//                                                     isSelected
//                                                         ? Colors.white
//                                                         : Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: const Color(0xFFFFFFFF),
//                                     border: Border.all(color: Colors.black),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             t.dateTime,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w300,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           Text(t.september142025),
//                                         ],
//                                       ),
//                                       Text(
//                                         selectedTime ?? t.selectTime,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],

//                     const SizedBox(height: 30),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF008AD2),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         onPressed:
//                             () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PaymentMethod(),
//                               ),
//                             ),
//                         child: Text(
//                           t.validateAndContinue,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget _buildDeliveryOption(String label, String value) {
//     return InkWell(
//       onTap: () {
//         setState(() => selectedMethod = value);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selectedMethod == value ? Colors.orange : Colors.grey,
//           ),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selectedMethod == value
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: Colors.orange,
//             ),
//             const SizedBox(width: 10),
//             Text(label, style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
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

// class CartValidator {
//   static Future<bool> validateCart(BuildContext context) async {
//     try {
//       final token = await SharedPreferencesService.getAuthToken();
//       final cartId = await SharedPreferencesService.getCartId();

//       if (token == null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Please login to continue')));
//         return false;
//       }

//       if (cartId == null || cartId <= 0) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Cart not found')));
//         return false;
//       }

//       // Test the cart with a simple API call
//       final response = await http.get(
//         Uri.parse(
//           'https://tawasul-dev.app-staging.fr/public/getshippinglist?id_cart=$cartId',
//         ),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['success'] == true;
//       }

//       return false;
//     } catch (e) {
//       print('Cart validation error: $e');
//       return false;
//     }
//   }

//   static void proceedToDelivery(BuildContext context) async {
//     bool isValid = await validateCart(context);
//     if (isValid) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => DeliveryMethod()),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Please add items to cart first')));
//     }
//   }
// }
