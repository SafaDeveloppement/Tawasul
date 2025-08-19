// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Checkout/address.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';

// class ProductDetail extends StatefulWidget {
//   final Product product;
//   final VoidCallback toggleFavorite;
//   final bool isFavorite;

//   const ProductDetail({
//     super.key,
//     required this.product,
//     required this.toggleFavorite,
//     required this.isFavorite,
//   });

//   @override
//   State<ProductDetail> createState() => _ProductDetailState();
// }

// class _ProductDetailState extends State<ProductDetail> {
//   int quantity = 1;
//   late bool isFavorite;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = widget.isFavorite;
//   }

//   // final List<Product> allProducts = [
//   //   Product(
//   //     id: 1,
//   //     name: "Apple AirPods",
//   //     brand: "APPLE",
//   //     price: "120 DYL",
//   //     image: "assets/images/new_airpods.png",
//   //     description:
//   //         "Wireless Bluetooth earbuds with high-quality sound and noise cancellation.",
//   //   ),
//   //   Product(
//   //     id: 2,
//   //     name: "IPhone 14 Plus",
//   //     brand: "APPLE",
//   //     price: "3,199 DYL",
//   //     oldPrice: "3,690 DYL",
//   //     discount: "20%",
//   //     image: "assets/images/new_iphone.png",
//   //     description:
//   //         "Latest iPhone with A16 Bionic chip and advanced camera system.",
//   //   ),
//   // ];

//   final List<Product> allProducts = [
//     Product(
//       id: 1,
//       name: "Apple AirPods Pro",
//       brand: "APPLE",
//       price: "199 DYL",
//       image: "assets/images/new_airpods.png",
//       description: "Premium wireless earbuds with active noise cancellation.",
//     ),
//     Product(
//       id: 2,
//       name: "iPhone 14 Pro",
//       brand: "APPLE",
//       price: "3,599 DYL",
//       oldPrice: "3,999 DYL",
//       discount: "10%",
//       image: "assets/images/new_iphone.png",
//       description: "Pro camera system with 48MP Main camera.",
//     ),
//     Product(
//       id: 3,
//       name: "MateBook Air M2",
//       brand: "APPLE",
//       price: "4,199 DYL",
//       image: "assets/images/matebook.png",
//       description: "Thin and light laptop with M2 chip.",
//     ),
//     Product(
//       id: 4,
//       name: "Airpods Pro",
//       brand: "APPLE",
//       price: "1,299 DYL",
//       oldPrice: "1,499 DYL",
//       discount: "15%",
//       image: "assets/images/airpods.png",
//       description: "Advanced health monitoring and fitness tracking.",
//     ),
//     Product(
//       id: 5,
//       name: "iphone",
//       brand: "APPLE",
//       price: "3,299 DYL",
//       image: "assets/images/iphone.png",
//       description: "Liquid Retina XDR display with M2 chip.",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF008AD2),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 270.h,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(90),
//                     bottomRight: Radius.circular(90),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 10.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.w,
//                         vertical: 10.h,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () => Navigator.pop(context),
//                             child: Container(
//                               width: 41,
//                               height: 41,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF008AD2),
//                               ),
//                               child: Icon(
//                                 Icons.arrow_back_ios_new_sharp,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "Product details",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 20,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               widget.toggleFavorite();
//                               setState(() {
//                                 isFavorite = !isFavorite;
//                               });
//                             },
//                             child: Icon(
//                               isFavorite
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               size: 38,
//                               color: Color(0xFF008AD2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Hero(
//                       tag: 'product-image-${widget.product.name}',
//                       child: Image.asset(
//                         widget.product.image,
//                         height: 195,
//                         width: 220,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 30.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ColorDot(color: Color(0xFF0984E3)),
//                           ColorDot(color: Color(0xFFF39C12)),
//                           ColorDot(color: Color(0xFFF9307A)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 6),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           widget.product.name,
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               widget.product.price,
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             if (widget.product.oldPrice != null)
//                               Text(
//                                 widget.product.oldPrice!,
//                                 style: TextStyle(
//                                   decoration: TextDecoration.lineThrough,
//                                   fontSize: 16,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       widget.product.description ?? '',
//                       style: const TextStyle(fontSize: 19, color: Colors.white),
//                       textAlign: TextAlign.justify,
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Container(
//                           width: 160,
//                           height: 50,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white, width: 1.5),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Minus Button
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     if (quantity > 1) quantity--;
//                                   });
//                                 },
//                                 child: Container(
//                                   width: 36,
//                                   height: 36,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.black,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.remove,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 '$quantity',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               // Plus Button
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     quantity++;
//                                   });
//                                 },
//                                 child: Container(
//                                   width: 36,
//                                   height: 36,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.black,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(width: 10),
//                         // Add to Cart Button
//                         Expanded(
//                           child: Container(
//                             width: 203,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ShoppingCart(),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 "Add to Cart",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 25),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => Address()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size.fromHeight(45),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const Text("Buy now"),
//                     ),
//                     const SizedBox(height: 30),

//                     // ... (previous code remains the same until the similar products section)
//                     const SizedBox(height: 3),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Similar Products",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       height: 200,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: allProducts.length + 3, // Added 3 more items
//                         itemBuilder: (context, index) {
//                           final product =
//                               allProducts[index % allProducts.length];
//                           return Container(
//                             width: 160,
//                             margin: const EdgeInsets.only(right: 10),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Stack(
//                                   children: [
//                                     Center(
//                                       child: Image.asset(
//                                         product.image,
//                                         height: 90,
//                                         width: 70,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                     if (product.discount != null)
//                                       Positioned(
//                                         top: 0,
//                                         left: 0,
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 6,
//                                             vertical: 2,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.orange,
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             product.discount!,
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 10,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   product.brand,
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   product.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 7),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       product.price,
//                                       style: const TextStyle(
//                                         color: Color(0xFF0984E3),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     if (product.oldPrice != null)
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           left: 5.0,
//                                         ),
//                                         child: Text(
//                                           product.oldPrice!,
//                                           style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 10,
//                                             decoration:
//                                                 TextDecoration.lineThrough,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     // ... (rest of the code remains the same)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ColorDot extends StatelessWidget {
//   final Color color;
//   const ColorDot({super.key, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//     );
//   }
// }
