import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';
import 'package:tawasul_application/view/Connexion/login.dart';
import 'package:tawasul_application/view/home_page.dart';

const String baseUrl = "https://tawasul-dev.app-staging.fr";

class CartResponse {
  final String idCart;
  final List<CartItem> products;

  CartResponse({required this.idCart, required this.products});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final productsData = json['products'];
    List<CartItem> productList = [];

    if (productsData is List) {
      productList = productsData.map((e) => CartItem.fromJson(e)).toList();
    }

    return CartResponse(
      idCart: json['id_cart'].toString(),
      products: productList,
    );
  }
}

class CartItem {
  final String name;
  final String image;
  final int quantity;
  final double price;

  CartItem({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'] ?? '',
      image: json['id_image'] ?? '',
      quantity: int.tryParse(json['cart_quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final String? cartId;

  const ShoppingCart({super.key, this.cartId});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late Future<List<CartResponse>> _futureCartItems;
  final ShoppingCartController _shoppingCartController =
      ShoppingCartController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartId = prefs.getString('cart_id');
    if (cartId != null && cartId.isNotEmpty) {
      setState(() {
        _futureCartItems = getCartById(cartId);
      });
    } else {
      print("No cart ID found");
    }
  }

  Future<List<CartResponse>> getCartById(String? cartId) async {
    if (cartId == null || cartId.isEmpty) {
      print(" Cart ID is missing, cannot fetch cart");
      return [];
    }

    try {
      final uri = Uri.parse(
        "$baseUrl/public/getproductcart",
      ).replace(queryParameters: {'id_cart': cartId});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(" API Response: $jsonData");

        if (jsonData is List) {
          return jsonData.map((e) => CartResponse.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          return [CartResponse.fromJson(jsonData)];
        } else {
          throw Exception("Unexpected JSON format");
        }
      } else {
        throw Exception("Failed to load cart: ${response.statusCode}");
      }
    } catch (e) {
      print(" Get cart by ID error: $e");
      throw Exception("Error loading cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12,
            right: Directionality.of(context) == TextDirection.rtl ? 12 : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        title: Center(
          child: Text(
            "Shopping Cart",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: Directionality.of(context) == TextDirection.rtl ? 12 : 0,
              right: Directionality.of(context) == TextDirection.rtl ? 0 : 12,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Image.asset(
                "assets/images/tawasul_logo.png",
                height: 40,
                width: 40,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.account_circle, size: 35),
              ),
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<CartResponse>>(
        future: _futureCartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text(" Your cart is empty."));
          }

          final cartItems = snapshot.data!.expand((c) => c.products).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Product Image with border
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    193,
                                    212,
                                    246,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Qty: ${item.quantity}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${(item.quantity * item.price).toStringAsFixed(2)} LYD",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF0984E3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              //  Checkout Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed:
                      _shoppingCartController.isLoading
                          ? null
                          : () async {
                            setState(
                              () => _shoppingCartController.isLoading = true,
                            );
                            try {
                              final isLoggedIn =
                                  await _shoppingCartController
                                      .loadCustomerData();

                              if (isLoggedIn) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Checkout(),
                                  ),
                                );
                              } else {
                                final loggedIn = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Login(),
                                  ),
                                );
                                if (loggedIn == true) {
                                  final recheck =
                                      await _shoppingCartController
                                          .loadCustomerData();
                                  if (recheck) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const Checkout(),
                                      ),
                                    );
                                  }
                                }
                              }
                            } catch (e) {
                              print("❌ Checkout Error: $e");
                            } finally {
                              setState(
                                () => _shoppingCartController.isLoading = false,
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF008AD2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _shoppingCartController.isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Checkout",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),

              //  Clear Cart Button
              Padding(
                padding: const EdgeInsets.all(8.0),

                child: OutlinedButton(
                  onPressed:
                      _shoppingCartController.isLoading
                          ? null
                          : () {
                            _showClearCartDialog(context);
                          },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Clear",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45),
            ],
          );
        },
      ),
    );
  }

  //  Confirmation dialog for clearing cart
  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Clear Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to remove all items from your cart?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _clearCartItems();
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  //  Clear the cart in the UI only
  void _clearCartItems() {
    setState(() {
      _shoppingCartController.cartItems.clear();
      _futureCartItems = Future.value([]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cart cleared successfully."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ShoppingCartController {
  int? customerId;
  List<dynamic> addresses = [];
  dynamic selectedAddress;
  bool isLoading = false;
  String errorMessage = '';
  String errorCode = '';
  bool isUsingStoredData = false;
  List<CartResponse> cartItems = [];

  ShoppingCartController({this.customerId});

  Future<bool> loadCustomerData() async {
    try {
      isLoading = true;
      print("🔍 Loading customer data from API...");

      final customerResponse = await ApiService.getCustomerDetails();

      if (customerResponse['success'] == true) {
        customerId = customerResponse['id'];
        print(" Customer ID set to $customerId");
        return true;
      } else {
        print(" API failed: ${customerResponse['message']}");
        errorMessage =
            customerResponse['message'] ?? 'Failed to load customer details';
        errorCode = customerResponse['code'] ?? 'UNKNOWN_ERROR';
        return false;
      }
    } catch (e) {
      errorMessage = 'Failed to load customer data: $e';
      errorCode = 'EXCEPTION';
      print("❌ Exception in loadCustomerData: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/l10n/app_localizations.dart';
// import 'package:tawasul_application/view/Checkout/checkout.dart';
// import 'package:tawasul_application/view/Connexion/login.dart';
// import 'package:tawasul_application/view/home_page.dart';

// const String baseUrl = "https://tawasul-dev.app-staging.fr";

// // ======================== MODEL CLASSES =========================
// class CartResponse {
//   final String idCart;
//   final List<CartItem> products;

//   CartResponse({required this.idCart, required this.products});

//   factory CartResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       final productsData = json['products'];
//       List<CartItem> productList = [];

//       if (productsData is List) {
//         productList =
//             productsData
//                 .where((item) => item is Map<String, dynamic>)
//                 .map((e) => CartItem.fromJson(e))
//                 .where((item) => item.quantity > 0) // Only include valid items
//                 .toList();
//       }

//       return CartResponse(
//         idCart: json['id_cart']?.toString() ?? 'unknown',
//         products: productList,
//       );
//     } catch (e) {
//       print("❌ Error parsing CartResponse: $e");
//       return CartResponse(idCart: 'error', products: []);
//     }
//   }
// }

// class CartItem {
//   final String name;
//   final String image;
//   final int quantity;
//   final double price;

//   CartItem({
//     required this.name,
//     required this.image,
//     required this.quantity,
//     required this.price,
//   });

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     try {
//       return CartItem(
//         name: json['name']?.toString() ?? 'Unknown Product',
//         image: json['image']?.toString() ?? '',
//         quantity: int.tryParse(json['cart_quantity']?.toString() ?? '0') ?? 0,
//         price: double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0,
//       );
//     } catch (e) {
//       print("❌ Error parsing CartItem: $e");
//       return CartItem(
//         name: 'Error parsing product',
//         image: '',
//         quantity: 0,
//         price: 0.0,
//       );
//     }
//   }
// }

// // ======================== MAIN SHOPPING CART PAGE =========================

// class ShoppingCart extends StatefulWidget {
//   final String? cartId;

//   const ShoppingCart({super.key, this.cartId});

//   @override
//   State<ShoppingCart> createState() => _ShoppingCartState();
// }

// class _ShoppingCartState extends State<ShoppingCart> {
//   Future<List<CartResponse>>? _futureCartItems;
//   late ShoppingCartController _shoppingCartController;

//   @override
//   void initState() {
//     super.initState();
    // _shoppingCartController = ShoppingCartController();
//     _loadCart();
//   }

//   //  Load cart data safely
//   Future<void> _loadCart() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cartId = prefs.getString('cart_id');

//     if (cartId != null && cartId.isNotEmpty) {
//       print(" Found cart ID: $cartId");
//       setState(() {
//         _futureCartItems = getCartById(cartId);
//       });
//     } else {
//       print(" No cart ID found in SharedPreferences");
//       setState(() {
//         _futureCartItems = Future.value([]); // Empty fallback
//       });
//     }
//   }

//   //  API to fetch cart by ID
//   Future<List<CartResponse>> getCartById(String cartId) async {
//     try {
//       final uri = Uri.parse(
//         "$baseUrl/public/getproductcart",
//       ).replace(queryParameters: {'id_cart': cartId});

//       final response = await http.get(uri);
//       print("🛒 API URL: $uri");
//       print("📦 Response Status: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         print("📦 Raw API Response: $jsonData");

//         // Handle empty response
//         if (jsonData == null) {
//           print("⚠️ API returned null");
//           return [];
//         }

//         // Handle different response formats safely
//         if (jsonData is List) {
//           if (jsonData.isEmpty) {
//             print("🛒 Empty cart list from API");
//             return [];
//           }
//           final results =
//               jsonData.map((e) => CartResponse.fromJson(e)).toList();
//           print("🛒 Parsed ${results.length} cart items");
//           return results;
//         } else if (jsonData is Map<String, dynamic>) {
//           final result = CartResponse.fromJson(jsonData);
//           print(
//             "🛒 Parsed single cart with ${result.products.length} products",
//           );
//           return [result];
//         } else {
//           print("❌ Unexpected JSON format: ${jsonData.runtimeType}");
//           return [];
//         }
//       } else if (response.statusCode == 404) {
//         print("❌ Cart not found (404)");
//         return [];
//       } else {
//         print("❌ API Error ${response.statusCode}: ${response.body}");
//         throw Exception("Failed to load cart: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error loading cart: $e");
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context);
//     if (t == null) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF008AD2)),
//           onPressed:
//               () => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const HomePage()),
//               ),
//         ),
//         title: Text(
//           t.shoppingCart,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//         ),
//         actions: [
//           Image.asset(
//             "assets/images/tawasul_logo.png",
//             height: 35,
//             width: 35,
//             errorBuilder:
//                 (context, error, stackTrace) =>
//                     const Icon(Icons.account_circle, size: 35),
//           ),
//         ],
//       ),

//       //  Ensure future is initialized
//       body:
//           _futureCartItems == null
//               ? const Center(child: CircularProgressIndicator())
//               : FutureBuilder<List<CartResponse>>(
//                 future: _futureCartItems,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         "❌ Error: ${snapshot.error}",
//                         style: const TextStyle(color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                     );
//                   }

//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         "🛍️ Your cart is empty.",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     );
//                   }

//                   final cartItems =
//                       snapshot.data!.expand((c) => c.products).toList();

//                   return Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: cartItems.length,
//                           itemBuilder: (context, index) {
//                             final item = cartItems[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 6,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 2,
//                               child: ListTile(
//                                 leading: Image.network(
//                                   item.image,
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                   errorBuilder:
//                                       (context, error, stackTrace) =>
//                                           const Icon(Icons.image_not_supported),
//                                 ),
//                                 title: Text(
//                                   item.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   "Qty: ${item.quantity} • ${item.price.toStringAsFixed(2)} LYD",
//                                 ),
//                                 trailing: Text(
//                                   "${(item.quantity * item.price).toStringAsFixed(2)} LYD",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),

                      // //  Checkout Button
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(
                      //     onPressed:
                      //         _shoppingCartController.isLoading
                      //             ? null
                      //             : () async {
                      //               setState(
                      //                 () =>
                      //                     _shoppingCartController.isLoading =
                      //                         true,
                      //               );
                      //               try {
                      //                 final isLoggedIn =
                      //                     await _shoppingCartController
                      //                         .loadCustomerData();

                      //                 if (isLoggedIn) {
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (_) => const Checkout(),
                      //                     ),
                      //                   );
                      //                 } else {
                      //                   final loggedIn = await Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (_) => const Login(),
                      //                     ),
                      //                   );
                      //                   if (loggedIn == true) {
                      //                     final recheck =
                      //                         await _shoppingCartController
                      //                             .loadCustomerData();
                      //                     if (recheck) {
                      //                       Navigator.push(
                      //                         context,
                      //                         MaterialPageRoute(
                      //                           builder:
                      //                               (_) => const Checkout(),
                      //                         ),
                      //                       );
                      //                     }
                      //                   }
                      //                 }
                      //               } catch (e) {
                      //                 print("❌ Checkout Error: $e");
                      //               } finally {
                      //                 setState(
                      //                   () =>
                      //                       _shoppingCartController.isLoading =
                      //                           false,
                      //                 );
                      //               }
                      //             },
                      //     style: ElevatedButton.styleFrom(
                      //       minimumSize: const Size(double.infinity, 50),
                      //       backgroundColor: const Color(0xFF008AD2),
                      //       foregroundColor: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //     ),
                      //     child:
                      //         _shoppingCartController.isLoading
                      //             ? const SizedBox(
                      //               width: 20,
                      //               height: 20,
                      //               child: CircularProgressIndicator(
                      //                 strokeWidth: 2,
                      //                 color: Colors.white,
                      //               ),
                      //             )
                      //             : Text(
                      //               t.checkout,
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //   ),
                      // ),

  //                     //  Clear Cart Button
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 8.0,
  //                         vertical: 8.0,
  //                       ),
  //                       child: OutlinedButton(
  //                         onPressed:
  //                             _shoppingCartController.isLoading
  //                                 ? null
  //                                 : () {
  //                                   _showClearCartDialog(context);
  //                                 },
  //                         style: OutlinedButton.styleFrom(
  //                           minimumSize: const Size(double.infinity, 50),
  //                           foregroundColor: Colors.red,
  //                           side: const BorderSide(color: Colors.red),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           t.clear,
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //   );
  // }

//   //  Confirmation dialog for clearing cart
//   void _showClearCartDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             "Clear Cart",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             "Are you sure you want to remove all items from your cart?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _clearCartItems();
//               },
//               child: const Text("Clear"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   //  Clear the cart in the UI only
//   void _clearCartItems() {
//     setState(() {
//       _shoppingCartController.cartItems.clear();
//       _futureCartItems = Future.value([]);
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Cart cleared successfully."),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }

// // ======================== CONTROLLER =========================

// class ShoppingCartController {
//   int? customerId;
//   List<dynamic> addresses = [];
//   dynamic selectedAddress;
//   bool isLoading = false;
//   String errorMessage = '';
//   String errorCode = '';
//   bool isUsingStoredData = false;
//   List<CartResponse> cartItems = [];

//   ShoppingCartController({this.customerId});

//   Future<bool> loadCustomerData() async {
//     try {
//       isLoading = true;
//       print("🔍 Loading customer data from API...");

//       final customerResponse = await ApiService.getCustomerDetails();

//       if (customerResponse['success'] == true) {
//         customerId = customerResponse['id'];
//         print(" Customer ID set to $customerId");
//         return true;
//       } else {
//         print(" API failed: ${customerResponse['message']}");
//         errorMessage =
//             customerResponse['message'] ?? 'Failed to load customer details';
//         errorCode = customerResponse['code'] ?? 'UNKNOWN_ERROR';
//         return false;
//       }
//     } catch (e) {
//       errorMessage = 'Failed to load customer data: $e';
//       errorCode = 'EXCEPTION';
//       print("❌ Exception in loadCustomerData: $e");
//       return false;
//     } finally {
//       isLoading = false;
//     }
//   }
// }
