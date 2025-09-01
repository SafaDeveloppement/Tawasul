// import 'package:flutter/material.dart';
// import 'package:tawasul_application/view/Checkout/checkout_.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ShoppingCart extends StatefulWidget {
//   const ShoppingCart({super.key});

//   @override
//   State<ShoppingCart> createState() => _ShoppingCartState();
// }

// class _ShoppingCartState extends State<ShoppingCart> {
//   List<Map<String, dynamic>> cartItems = [
//     {
//       'title': 'MacBook Air I3 pouces Puce Apple MI SSD 256 Go',
//       'qty': 1,
//       'price': 4499,
//       'image': 'assets/images/laptop.jpg',
//     },
//     {
//       'title': 'iPhone 11 64 Go',
//       'qty': 2,
//       'price': 2099,
//       'image': 'assets/images/iphone4.jpg',
//     },
//     {
//       'title': 'Téléviseur Xiaomi Q2 65',
//       'qty': 1,
//       'price': 3155,
//       'image': 'assets/images/tv1.jpg',
//     },
//     {
//       'title': 'MateBook D I4 I4 pouces CML-U i7',
//       'qty': 1,
//       'price': 4699,
//       'image': 'assets/images/laptop1.jpg',
//     },
//   ];

//   void removeItem(int index) {
//     setState(() {
//       cartItems.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     // final LYD = AppLocalizations.of(context)!.lyd;
//     final total = cartItems
//         .map((item) => (item['qty'] as int) * (item['price'] as int))
//         .fold(0, (a, b) => a + b);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF008AD2),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 80),
//                   Center(
//                     child: Text(
//                       t.shoppingCart,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "${cartItems.length}x Items",
//                   style: const TextStyle(color: Color(0xFF515C6F)),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: cartItems.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 30),
//                   itemBuilder: (context, index) {
//                     final item = cartItems[index];
//                     return Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       spacing: 10,
//                       children: [
//                         Image.asset(
//                           item['image'],
//                           width: 117,
//                           height: 96,
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item['title'],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 "White",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         if (item['qty'] > 1) item['qty']--;
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.black,
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: Icon(
//                                         Icons.remove,
//                                         size: 16,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 18,
//                                     ),
//                                     child: Text('${item['qty']}'),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         item['qty']++;
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.black,
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: const Icon(
//                                         Icons.add,
//                                         size: 16,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 Icons.delete,
//                                 color: Color.fromARGB(135, 0, 0, 0),
//                               ),
//                               onPressed: () => removeItem(index),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "${item['price']} ${t.lyd}",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF0984E3),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Divider(thickness: 1),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     t.subTotal,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "$total ${t.lyd}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const Checkout()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: const Color(0xFF008AD2),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(t.checkout, style: TextStyle(fontSize: 18)),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     cartItems.clear();
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(t.clear, style: TextStyle(fontSize: 18)),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Checkout/checkout_.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  bool isRemoving = false;
  Map<int, bool> updatingItems = {};

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final response = await ApiService.getCart();
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Erreur chargement panier: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load cart: ${e.toString()}")),
      );
    }
  }

  Future<void> removeItem(int index) async {
    if (isRemoving) return;

    setState(() => isRemoving = true);

    try {
      final productId = cartItems[index]["id"];
      await ApiService.removeFromCart(productId);
      setState(() {
        cartItems.removeAt(index);
        isRemoving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item removed from cart")));
    } catch (e) {
      setState(() => isRemoving = false);
      debugPrint("Erreur suppression produit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove item: ${e.toString()}")),
      );
    }
  }

  Future<void> updateQty(int index, int qty) async {
    if (updatingItems[index] == true) return;

    setState(() => updatingItems[index] = true);

    try {
      final productId = cartItems[index]["id"];
      await ApiService.updateCartQty(productId, qty);

      setState(() {
        cartItems[index]["qty"] = qty;
        updatingItems[index] = false;
      });
    } catch (e) {
      setState(() => updatingItems[index] = false);
      debugPrint("Erreur mise à jour quantité: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update quantity: ${e.toString()}")),
      );

      // Refresh cart to get correct quantities
      fetchCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = cartItems
        .map((item) => (item['qty'] as int) * (item['price'] as int))
        .fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF008AD2),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Center(
                    child: Text(
                      t.shoppingCart,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Empty cart state
              if (cartItems.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          t.yourCartIsEmpty,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          t.addItemsToGetStarted,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008AD2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(t.continueShopping),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${cartItems.length}x ${t.items}",
                          style: const TextStyle(
                            color: Color(0xFF515C6F),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: fetchCart,
                          child: ListView.separated(
                            itemCount: cartItems.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              final isUpdating = updatingItems[index] == true;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['image'] ?? '',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.grey),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] ?? t.noTitle,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          if (isUpdating)
                                            const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                          else
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (item['qty'] > 1) {
                                                      updateQty(
                                                        index,
                                                        item['qty'] - 1,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          item['qty'] > 1
                                                              ? Colors.black
                                                              : Colors.grey,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    child: const Icon(
                                                      Icons.remove,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Text(
                                                    '${item['qty']}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    updateQty(
                                                      index,
                                                      item['qty'] + 1,
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    child: const Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon:
                                              isRemoving
                                                  ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                  : const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ),
                                          onPressed: () => removeItem(index),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${item['price']} ${t.lyd}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0984E3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (cartItems.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.subTotal,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$total ${t.lyd}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Checkout()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF008AD2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(t.checkout, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ApiService.clearCart();
                      setState(() => cartItems.clear());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Cart cleared successfully"),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to clear cart: ${e.toString()}",
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(t.clear, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


    // Container(
              //   height: 70,
              //   padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           decoration: InputDecoration(
              //             hintText: t.enterDiscountCode,
              //             hintStyle: TextStyle(color: Color(0xFFA7A6A6)),
              //             contentPadding: EdgeInsets.symmetric(
              //               vertical: 10,
              //               horizontal: 12,
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(12),
              //               borderSide: BorderSide(
              //                 color: const Color.fromARGB(255, 220, 219, 219),
              //                 width: 1.0,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 6),
              //       Container(
              //         height: 50,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: ElevatedButton(
              //           onPressed: () {},
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: const Color(0xFFFFA500),
              //             foregroundColor: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //           ),
              //           child: Text(t.enter),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),





      // final productId = cartItems[index]["id"]; // ou "sku" selon ton API
