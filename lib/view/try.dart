// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// // Step 1: API Service
// class ApiService {
//   static const String _baseUrl = 'https://tawasul-dev.app-staging.fr/public';
//   static String? _token;

//   static void setToken(String token) {
//     _token = token;
//   }

//   static Future<Map<String, String>> _getHeaders() async {
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };

//     if (_token != null) {
//       headers['Authorization'] = 'Bearer $_token';
//     }

//     return headers;
//   }

//   static Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
//     try {
//       final headers = await _getHeaders();
      
//       final stringQueryParams = queryParams?.map<String, String>(
//         (key, value) => MapEntry(key, value.toString()),
//       );
      
//       final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: stringQueryParams);
      
//       print('API Call: ${uri.toString()}'); // For debugging
      
//       final response = await http.get(uri, headers: headers);
      
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('API call failed: $e');
//     }
//   }
// }

// // Step 2: Data Models
// class ShippingResponse {
//   final bool success;
//   final List<Carrier> carriers;

//   ShippingResponse({
//     required this.success,
//     required this.carriers,
//   });

//   factory ShippingResponse.fromJson(Map<String, dynamic> json) {
//     return ShippingResponse(
//       success: json['success'] ?? false,
//       carriers: (json['carriers'] as List? ?? [])
//           .map((carrierJson) => Carrier.fromJson(carrierJson))
//           .toList(),
//     );
//   }
// }

// class Carrier {
//   final int idCarrier;
//   final String name;
//   final String delay;
//   final String price;
//   final List<RelayGroup> relayGroups;
//   final String minDate;

//   Carrier({
//     required this.idCarrier,
//     required this.name,
//     required this.delay,
//     required this.price,
//     required this.relayGroups,
//     required this.minDate,
//   });

//   factory Carrier.fromJson(Map<String, dynamic> json) {
//     return Carrier(
//       idCarrier: json['id_carrier'] ?? 0,
//       name: json['name'] ?? '',
//       delay: json['delay'] ?? '',
//       price: json['price'] ?? '',
//       relayGroups: (json['relay_groups'] as List? ?? [])
//           .map((groupJson) => RelayGroup.fromJson(groupJson))
//           .toList(),
//       minDate: json['min_date'] ?? '',
//     );
//   }
// }

// class RelayGroup {
//   final int idRelayGroup;
//   final String relayGroupName;
//   final int cityId;
//   final int idLang;

//   RelayGroup({
//     required this.idRelayGroup,
//     required this.relayGroupName,
//     required this.cityId,
//     required this.idLang,
//   });

//   factory RelayGroup.fromJson(Map<String, dynamic> json) {
//     return RelayGroup(
//       idRelayGroup: json['id_relay_group'] ?? 0,
//       relayGroupName: json['relay_group_name'] ?? '',
//       cityId: json['city_id'] ?? 0,
//       idLang: json['id_lang'] ?? 0,
//     );
//   }
// }

// class ShippingStoreResponse {
//   final bool success;
//   final List<RelayPoint> points;

//   ShippingStoreResponse({
//     required this.success,
//     required this.points,
//   });

//   factory ShippingStoreResponse.fromJson(Map<String, dynamic> json) {
//     return ShippingStoreResponse(
//       success: json['success'] ?? false,
//       points: (json['points'] as List? ?? [])
//           .map((pointJson) => RelayPoint.fromJson(pointJson))
//           .toList(),
//     );
//   }
// }

// class RelayPoint {
//   final int idRelayPoint;
//   final String relayPointName;
//   final String image;

//   RelayPoint({
//     required this.idRelayPoint,
//     required this.relayPointName,
//     required this.image,
//   });

//   factory RelayPoint.fromJson(Map<String, dynamic> json) {
//     return RelayPoint(
//       idRelayPoint: json['id_relay_point'] ?? 0,
//       relayPointName: json['relay_point_name'] ?? '',
//       image: json['image'] ?? '',
//     );
//   }
// }

// // Step 3: Repository
// class ShippingRepository {
//   static Future<ShippingResponse> getShippingList(int cartId) async {
//     final response = await ApiService.get(
//       'getshippinglist',
//       queryParams: {'id_cart': cartId},
//     );
    
//     return ShippingResponse.fromJson(response);
//   }

//   static Future<ShippingStoreResponse> getShippingStore(int cartId, int groupId) async {
//     final response = await ApiService.get(
//       'getshippingstore',
//       queryParams: {
//         'id_cart': cartId,
//         'id_group': groupId,
//       },
//     );
    
//     return ShippingStoreResponse.fromJson(response);
//   }
// }

// // Step 4: Provider for State Management
// class ShippingProvider with ChangeNotifier {
//   List<Carrier> _carriers = [];
//   List<RelayPoint> _relayPoints = [];
//   bool _isLoading = false;
//   String _error = '';

//   List<Carrier> get carriers => _carriers;
//   List<RelayPoint> get relayPoints => _relayPoints;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   void setAuthToken(String token) {
//     ApiService.setToken(token);
//   }

//   Future<void> fetchShippingList(int cartId) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response = await ShippingRepository.getShippingList(cartId);
      
//       if (response.success) {
//         _carriers = response.carriers;
//         _error = '';
//       } else {
//         _error = 'Failed to load shipping options';
//       }
//     } catch (e) {
//       _error = 'Error: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> fetchShippingStores(int cartId, int groupId) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final response = await ShippingRepository.getShippingStore(cartId, groupId);
      
//       if (response.success) {
//         _relayPoints = response.points;
//         _error = '';
//       } else {
//         _error = 'Failed to load stores';
//       }
//     } catch (e) {
//       _error = 'Error: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }

//   void clearData() {
//     _carriers = [];
//     _relayPoints = [];
//     _error = '';
//     notifyListeners();
//   }
// }

// // Step 5: Main App
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shipping API Test',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ChangeNotifierProvider(
//         create: (_) => ShippingProvider(),
//         child: HomeScreen(),
//       ),
//     );
//   }
// }

// // Step 6: Home Screen
// class HomeScreen extends StatelessWidget {
//   final int cartId = 11131;
//   final String authToken = 'your-token-here'; // Replace with your actual token

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shipping API Test'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Consumer<ShippingProvider>(
//           builder: (context, shippingProvider, child) {
//             // Set token when screen initializes
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               shippingProvider.setAuthToken(authToken);
//             });

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Control Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           shippingProvider.fetchShippingList(cartId);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text('Load Shipping List'),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           shippingProvider.clearData();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text('Clear Data'),
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 SizedBox(height: 16),
                
//                 // Status Indicators
//                 if (shippingProvider.isLoading)
//                   Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(height: 8),
//                       Text('Loading...', style: TextStyle(color: Colors.blue)),
//                     ],
//                   ),
                
//                 if (shippingProvider.error.isNotEmpty)
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.red[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.error, color: Colors.red),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             shippingProvider.error,
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, size: 20),
//                           onPressed: shippingProvider.clearError,
//                         ),
//                       ],
//                     ),
//                   ),
                
//                 SizedBox(height: 16),
                
//                 // Results
//                 Expanded(
//                   child: _buildResults(shippingProvider, context),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildResults(ShippingProvider shippingProvider, BuildContext context) {
//     if (shippingProvider.carriers.isEmpty && !shippingProvider.isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.local_shipping, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'No shipping data loaded',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             Text(
//               'Click "Load Shipping List" to fetch data',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView(
//       children: [
//         // Shipping Carriers
//         if (shippingProvider.carriers.isNotEmpty) ...[
//           Text(
//             'Shipping Carriers (${shippingProvider.carriers.length})',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           ...shippingProvider.carriers.map((carrier) => Card(
//             elevation: 2,
//             margin: EdgeInsets.symmetric(vertical: 4),
//             child: ListTile(
//               leading: Icon(Icons.local_shipping, color: Colors.blue),
//               title: Text(carrier.name, style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Price: ${carrier.price}'),
//                   Text('Delivery: ${carrier.delay}'),
//                   Text('Available from: ${carrier.minDate}'),
//                   if (carrier.relayGroups.isNotEmpty)
//                     Text('Stores: ${carrier.relayGroups.length} available'),
//                 ],
//               ),
//               trailing: Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 if (carrier.relayGroups.isNotEmpty) {
//                   final groupId = carrier.relayGroups.first.idRelayGroup;
//                   shippingProvider.fetchShippingStores(cartId, groupId);
//                   _showStoresDialog(context, shippingProvider, carrier.name);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('No stores available for ${carrier.name}')),
//                   );
//                 }
//               },
//             ),
//           )).toList(),
//         ],
        
//         // Relay Points
//         if (shippingProvider.relayPoints.isNotEmpty) ...[
//           SizedBox(height: 16),
//           Divider(),
//           SizedBox(height: 8),
//           Text(
//             'Available Stores (${shippingProvider.relayPoints.length})',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//           ),
//           SizedBox(height: 8),
//           ...shippingProvider.relayPoints.map((point) => Card(
//             elevation: 2,
//             margin: EdgeInsets.symmetric(vertical: 4),
//             color: Colors.green[50],
//             child: ListTile(
//               leading: Icon(Icons.store, color: Colors.green),
//               title: Text(point.relayPointName, style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: point.image.isNotEmpty ? Text('Image: ${point.image}') : null,
//               trailing: Icon(Icons.check_circle, color: Colors.green),
//             ),
//           )).toList(),
//         ],
//       ],
//     );
//   }

//   void _showStoresDialog(BuildContext context, ShippingProvider provider, String carrierName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Stores for $carrierName'),
//         content: provider.isLoading
//             ? Center(child: CircularProgressIndicator())
//             : provider.relayPoints.isEmpty
//                 ? Text('No stores available')
//                 : Container(
//                     width: double.maxFinite,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: provider.relayPoints.length,
//                       itemBuilder: (context, index) {
//                         final point = provider.relayPoints[index];
//                         return ListTile(
//                           leading: Icon(Icons.store),
//                           title: Text(point.relayPointName),
//                           onTap: () {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Selected: ${point.relayPointName}'),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Simple ChangeNotifierProvider since we can't import package
// class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
//   final Widget child;
//   final Create<T> create;

//   ChangeNotifierProvider({required this.create, required this.child});

//   @override
//   _ChangeNotifierProviderState<T> createState() => _ChangeNotifierProviderState<T>();
// }

// class _ChangeNotifierProviderState<T extends ChangeNotifier> extends State<ChangeNotifierProvider<T>> {
//   late T _value;

//   @override
//   void initState() {
//     super.initState();
//     _value = widget.create();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InheritedProvider<T>(
//       value: _value,
//       child: widget.child,
//     );
//   }
// }

// class InheritedProvider<T> extends InheritedWidget {
//   final T value;

//   InheritedProvider({required this.value, required Widget child}) : super(child: child);

//   @override
//   bool updateShouldNotify(InheritedProvider<T> oldWidget) {
//     return true;
//   }

//   static T of<T>(BuildContext context) {
//     final inheritedProvider = context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
//     if (inheritedProvider == null) {
//       throw Exception('InheritedProvider not found');
//     }
//     return inheritedProvider.value;
//   }
// }

// class Consumer<T> extends StatelessWidget {
//   final Widget Function(BuildContext context, T value, Widget? child) builder;

//   Consumer({required this.builder});

//   @override
//   Widget build(BuildContext context) {
//     return builder(context, InheritedProvider.of<T>(context), null);
//   }
// }