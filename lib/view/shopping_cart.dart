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
import 'package:provider/provider.dart';
import 'package:tawasul_application/Provider/cart_provider.dart';
import 'package:tawasul_application/view/Checkout/checkout_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cartProvider = Provider.of<CartProvider>(context);

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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF008AD2),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Center(
                    child: Text(
                      t.shoppingCart,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${cartProvider.totalItems}x Items",
                  style: const TextStyle(color: Color(0xFF515C6F)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: cartProvider.cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.separated(
                        itemCount: cartProvider.cartItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 30),
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              item.product.image.isNotEmpty
                                  ? Image.network(
                                      item.product.image,
                                      width: 117,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 117,
                                          height: 96,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 117,
                                      height: 96,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (item.selectedColor != null)
                                      Text(
                                        "Color: ${item.selectedColor}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (item.quantity > 1) {
                                              cartProvider.updateQuantity(
                                                item.product.id,
                                                item.selectedColor,
                                                item.quantity - 1,
                                              );
                                            } else {
                                              cartProvider.removeFromCart(
                                                item.product.id,
                                                item.selectedColor,
                                              );
                                            }
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18),
                                          child: Text('${item.quantity}'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            cartProvider.updateQuantity(
                                              item.product.id,
                                              item.selectedColor,
                                              item.quantity + 1,
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                            padding: const EdgeInsets.all(4),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => cartProvider.removeFromCart(
                                      item.product.id,
                                      item.selectedColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${item.totalPrice.toStringAsFixed(2)} ${t.lyd}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0984E3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.subTotal,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${cartProvider.totalAmount.toStringAsFixed(2)} ${t.lyd}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cartProvider.cartItems.isEmpty
                    ? null
                    : () {
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
                child: Text(t.checkout, style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: cartProvider.cartItems.isEmpty ? null : () => cartProvider.clearCart(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(t.clear, style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}