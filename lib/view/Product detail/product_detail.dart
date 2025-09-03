// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/Provider/cart_provider.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Checkout/checkout_.dart';
// import 'package:tawasul_application/view/Product%20detail/similar_product.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';

// class ProductDetail extends StatefulWidget {
//   final VoidCallback toggleFavorite;
//   final bool isFavorite;
//   final String productReference;
//   final String shopId;
//   final Product? product;

//   const ProductDetail({
//     super.key,
//     required this.toggleFavorite,
//     required this.isFavorite,
//     required this.productReference,
//     required this.shopId,
//     this.product,
//   });

//   @override
//   State<ProductDetail> createState() => _ProductDetailState();
// }

// class _ProductDetailState extends State<ProductDetail> {
//   int quantity = 1;
//   late bool isFavorite;
//   Product? product;
//   bool isLoading = true;
//   String errorMessage = '';
//   String? selectedColor;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = widget.isFavorite;
//     _fetchProductData();
//   }

//   Future<void> _fetchProductData() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       if (widget.product != null) {
//         product = widget.product;
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       // Your existing API call logic here (if needed)
//       // For now, we'll just use the passed product
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       errorMessage = 'Error fetching product: $e';
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _addToCart() {
//     if (product == null) return;

//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     cartProvider.addToCart(product!, quantity: quantity, color: selectedColor);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Product added to cart successfully!")),
//     );

//     // Navigate to shopping cart after successful addition
//     Navigator.push(context, MaterialPageRoute(builder: (_) => ShoppingCart()));
//   }

//   void _buyNow() {
//     if (product == null) return;

//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     cartProvider.addToCart(product!, quantity: quantity, color: selectedColor);

//     Navigator.push(context, MaterialPageRoute(builder: (_) => Checkout()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(color: Colors.white),
//               const SizedBox(height: 20),
//               const Text(
//                 'Loading product...',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (product == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, size: 64, color: Colors.white),
//               const SizedBox(height: 20),
//               Text(
//                 errorMessage.isEmpty ? 'Product not found' : errorMessage,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _fetchProductData,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

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
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF008AD2),
//                               ),
//                               child: const Icon(
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
//                               color: const Color(0xFF008AD2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Hero(
//                       tag: 'product-image-${product!.name}',
//                       child:
//                           product!.image.isNotEmpty
//                               ? Image.network(
//                                 product!.image,
//                                 height: 175,
//                                 width: 200,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Icon(Icons.error, size: 100);
//                                 },
//                               )
//                               : const Icon(Icons.image, size: 100),
//                     ),
//                     if (product!.colors != null && product!.colors!.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(right: 30.0, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children:
//                               product!.colors!.map((color) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 4,
//                                   ),
//                                   child: ColorDot(
//                                     color: color,
//                                     isSelected:
//                                         selectedColor == color.value.toString(),
//                                     onTap: () {
//                                       setState(() {
//                                         selectedColor = color.value.toString();
//                                       });
//                                     },
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       )
//                     else
//                       const Padding(
//                         padding: EdgeInsets.only(right: 30.0, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [ColorDot(color: Colors.grey)],
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             product!.name,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               '${product!.price} LYD',
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             if (product!.oldPrice != null)
//                               Text(
//                                 '${product!.oldPrice!} LYD',
//                                 style: const TextStyle(
//                                   decoration: TextDecoration.lineThrough,
//                                   fontSize: 16,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Html(
//                       data: product?.description ?? 'No Description',
//                       style: {
//                         "body": Style(
//                           fontSize: FontSize(15.0),
//                           color: Colors.white,
//                           textAlign: TextAlign.justify,
//                         ),
//                         "p": Style(
//                           margin: Margins.only(bottom: 10),
//                           color: Colors.white,
//                         ),
//                         "ul": Style(
//                           color: Colors.white,
//                           margin: Margins.only(bottom: 10),
//                         ),
//                         "li": Style(color: Colors.white),
//                       },
//                     ),
//                     const SizedBox(height: 20),
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
//                         Expanded(
//                           child: Container(
//                             width: 203,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: TextButton(
//                               onPressed: _addToCart,
//                               child: Text(
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
//                       onPressed: _buyNow,
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
//                     SimilarProducts(
//                       currentProduct: product!,
//                       shopId: widget.shopId,
//                       allProducts: [],
//                     ),
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
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const ColorDot({
//     super.key,
//     required this.color,
//     this.isSelected = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         width: 28,
//         height: 28,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color,
//           border: Border.all(
//             color: isSelected ? Colors.black : Colors.white,
//             width: isSelected ? 3 : 2,
//           ),
//         ),
//         child:
//             isSelected
//                 ? Icon(
//                   Icons.check,
//                   size: 14,
//                   color:
//                       color.computeLuminance() > 0.5
//                           ? Colors.black
//                           : Colors.white,
//                 )
//                 : null,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Provider/cart_provider.dart';
import 'package:tawasul_application/Provider/product_provider.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Checkout/checkout_.dart';
import 'package:tawasul_application/view/Product%20detail/similar_product.dart';
import 'package:tawasul_application/view/shopping_cart.dart';

class ProductDetail extends StatefulWidget {
  final VoidCallback toggleFavorite;
  final bool isFavorite;
  final String productReference;
  final String shopId;
  final Product? product;

  const ProductDetail({
    super.key,
    required this.toggleFavorite,
    required this.isFavorite,
    required this.productReference,
    required this.shopId,
    this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  late bool isFavorite;
  Product? product;
  bool isLoading = true;
  String errorMessage = '';
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (widget.product != null) {
        product = widget.product;
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'http://t-api.dotit-corp.com/api/public/getProduct?code=${widget.productReference}&id-shop=${widget.shopId}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['message'] == 'success' &&
            jsonResponse['response'] != null &&
            jsonResponse['response'].isNotEmpty) {
          final apiProductData = jsonResponse['response'][0];

          product = Product.fromJson(apiProductData);
          setState(() {
            isLoading = false;
          });
        } else {
          errorMessage = 'Product not found in API response';
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      errorMessage = 'Error fetching product: $e';
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add to cart:
  void _addToCart() {
    if (product == null) return;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(product!, quantity: quantity, color: selectedColor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product added to cart successfully!")),
    );

    // Navigate to shopping cart after successful addition
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShoppingCart()));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF008AD2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Loading product...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (product == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF008AD2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                errorMessage.isEmpty ? 'Product not found' : errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchProductData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF008AD2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 270.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 41,
                              height: 41,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF008AD2),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_sharp,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Product details",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleFavorite();
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 38,
                              color: const Color(0xFF008AD2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'product-image-${product!.name}',
                      child:
                          product!.image.isNotEmpty
                              ? Image.network(
                                product!.image,
                                height: 175,
                                width: 200,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 100);
                                },
                              )
                              : const Icon(Icons.image, size: 100),
                    ),
                    if (product!.colors != null && product!.colors!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:
                              product!.colors!.map((color) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ColorDot(
                                    color: color,
                                    isSelected:
                                        selectedColor == color.value.toString(),
                                    onTap: () {
                                      setState(() {
                                        selectedColor = color.value.toString();
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [ColorDot(color: Colors.grey)],
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product!.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${product!.price} LYD',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (product!.oldPrice != null)
                              Text(
                                '${product!.oldPrice!} LYD',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Html(
                      data: product?.description ?? 'No Description',
                      style: {
                        "body": Style(
                          fontSize: FontSize(15.0),
                          color: Colors.white,
                          textAlign: TextAlign.justify,
                        ),
                        "p": Style(
                          margin: Margins.only(bottom: 10),
                          color: Colors.white,
                        ),
                        "ul": Style(
                          color: Colors.white,
                          margin: Margins.only(bottom: 10),
                        ),
                        "li": Style(color: Colors.white),
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            width: 203,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: _addToCart,
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );
                        cartProvider.addToCart(
                          product!,
                          quantity: quantity,
                          color: selectedColor,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Checkout()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Buy now"),
                    ),
                    const SizedBox(height: 30),
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        return SimilarProducts(
                          currentProduct: product!,
                          shopId: widget.shopId,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const ColorDot({
    super.key,
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.white,
            width: isSelected ? 3 : 2,
          ),
        ),
        child:
            isSelected
                ? Icon(
                  Icons.check,
                  size: 14,
                  color:
                      color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                )
                : null,
      ),
    );
  }
}


// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_html/flutter_html.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:tawasul_application/model/product_model.dart';
// // import 'package:tawasul_application/view/Checkout/checkout_.dart';
// // import 'package:tawasul_application/view/shopping_cart.dart';
// // import 'package:tawasul_application/view/similar_product.dart';

// // class ProductDetail extends StatefulWidget {
// //   final VoidCallback toggleFavorite;
// //   final bool isFavorite;
// //   final String productReference;
// //   final String shopId;
// //   final Product? product;

// //   const ProductDetail({
// //     super.key,
// //     required this.toggleFavorite,
// //     required this.isFavorite,
// //     required this.productReference,
// //     required this.shopId,
// //     this.product,
// //   });

// //   @override
// //   State<ProductDetail> createState() => _ProductDetailState();
// // }

// // class _ProductDetailState extends State<ProductDetail> {
// //   int quantity = 1;
// //   late bool isFavorite;
// //   Product? product;
// //   bool isLoading = true;
// //   String errorMessage = '';
// //   String? selectedColor;
// //   Map<String, dynamic>? apiProductData; // Store the full API response

// //   @override
// //   void initState() {
// //     super.initState();
// //     isFavorite = widget.isFavorite;
// //     _fetchProductData();
// //   }

// //   Future<void> _fetchProductData() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //       });

// //       // If product is provided directly, use it
// //       if (widget.product != null) {
// //         product = widget.product;
// //         setState(() {
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       // Fetch product data from API
// //       final response = await http.get(
// //         Uri.parse(
// //           'http://t-api.dotit-corp.com/api/public/getProduct?code=${widget.productReference}&id-shop=${widget.shopId}',
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         final jsonResponse = json.decode(response.body);
// //         if (jsonResponse['message'] == 'success' &&
// //             jsonResponse['response'] != null &&
// //             jsonResponse['response'].isNotEmpty) {
// //           apiProductData = jsonResponse['response'][0];

// //           // Create product object from API data using the fromJson constructor
// //           product = Product.fromJson(apiProductData!);
// //         } else {
// //           errorMessage = 'Product not found in API response';
// //         }
// //       } else {
// //         errorMessage = 'Failed to load product: ${response.statusCode}';
// //       }
// //     } catch (e) {
// //       errorMessage = 'Error fetching product: $e';
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading) {
// //       return Scaffold(
// //         backgroundColor: const Color(0xFF008AD2),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const CircularProgressIndicator(color: Colors.white),
// //               const SizedBox(height: 20),
// //               const Text(
// //                 'Loading product...',
// //                 style: TextStyle(color: Colors.white),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }

// //     if (product == null) {
// //       return Scaffold(
// //         backgroundColor: const Color(0xFF008AD2),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.error_outline, size: 64, color: Colors.white),
// //               const SizedBox(height: 20),
// //               Text(
// //                 errorMessage.isEmpty ? 'Product not found' : errorMessage,
// //                 style: const TextStyle(color: Colors.white),
// //                 textAlign: TextAlign.center,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _fetchProductData,
// //                 child: const Text('Retry'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }

// //     return Scaffold(
// //       backgroundColor: const Color(0xFF008AD2),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Container(
// //                 width: double.infinity,
// //                 height: 270.h,
// //                 decoration: const BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.only(
// //                     bottomLeft: Radius.circular(90),
// //                     bottomRight: Radius.circular(90),
// //                   ),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: 10.h),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(
// //                         horizontal: 20.w,
// //                         vertical: 10.h,
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           GestureDetector(
// //                             onTap: () => Navigator.pop(context),
// //                             child: Container(
// //                               width: 41,
// //                               height: 41,
// //                               decoration: BoxDecoration(
// //                                 shape: BoxShape.circle,
// //                                 color: Color(0xFF008AD2),
// //                               ),
// //                               child: Icon(
// //                                 Icons.arrow_back_ios_new_sharp,
// //                                 size: 20,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                           Text(
// //                             "Product details",
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 20,
// //                             ),
// //                           ),
// //                           GestureDetector(
// //                             onTap: () {
// //                               widget.toggleFavorite();
// //                               setState(() {
// //                                 isFavorite = !isFavorite;
// //                               });
// //                             },
// //                             child: Icon(
// //                               isFavorite
// //                                   ? Icons.favorite
// //                                   : Icons.favorite_border,
// //                               size: 38,
// //                               color: Color(0xFF008AD2),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     Hero(
// //                       tag: 'product-image-${product!.name}',
// //                       child:
// //                           product!.image.isNotEmpty
// //                               ? Image.network(
// //                                 product!.image,
// //                                 height: 175,
// //                                 width: 200,
// //                                 fit: BoxFit.contain,
// //                                 errorBuilder: (context, error, stackTrace) {
// //                                   return const Icon(Icons.error, size: 100);
// //                                 },
// //                               )
// //                               : const Icon(Icons.image, size: 100),
// //                     ),
// //                     // Dynamic color dots from API
// //                     if (product!.colors != null && product!.colors!.isNotEmpty)
// //                       Padding(
// //                         padding: EdgeInsets.only(right: 30.0, top: 10),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children:
// //                               product!.colors!.map((color) {
// //                                 return Padding(
// //                                   padding: EdgeInsets.symmetric(horizontal: 4),
// //                                   child: ColorDot(
// //                                     color: color,
// //                                     isSelected:
// //                                         selectedColor == color.value.toString(),
// //                                     onTap: () {
// //                                       setState(() {
// //                                         selectedColor = color.value.toString();
// //                                       });
// //                                     },
// //                                   ),
// //                                 );
// //                               }).toList(),
// //                         ),
// //                       )
// //                     else
// //                       Padding(
// //                         padding: EdgeInsets.only(right: 30.0, top: 10),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [ColorDot(color: Colors.grey)],
// //                         ),
// //                       ),
// //                     SizedBox(height: 16),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 6),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 15.0),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           product!.name,
// //                           style: TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.end,
// //                           children: [
// //                             Text(
// //                               product!.price,
// //                               style: TextStyle(
// //                                 fontSize: 22,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                             if (product!.oldPrice != null)
// //                               Text(
// //                                 product!.oldPrice!,
// //                                 style: TextStyle(
// //                                   decoration: TextDecoration.lineThrough,
// //                                   fontSize: 16,
// //                                   color: Colors.white70,
// //                                 ),
// //                               ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 5),
// //                     Html(
// //                       data: product?.description ?? 'No Description',
// //                       style: {
// //                         "body": Style(
// //                           fontSize: FontSize(15.0),
// //                           color: Colors.white,
// //                           textAlign: TextAlign.justify,
// //                         ),
// //                         "p": Style(
// //                           margin: Margins.only(bottom: 10),
// //                           color: Colors.white,
// //                         ),
// //                         "ul": Style(
// //                           color: Colors.white,
// //                           margin: Margins.only(bottom: 10),
// //                         ),
// //                         "li": Style(color: Colors.white),
// //                       },
// //                     ),
// //                     SizedBox(height: 20),
// //                     Row(
// //                       children: [
// //                         Container(
// //                           width: 160,
// //                           height: 50,
// //                           padding: const EdgeInsets.symmetric(horizontal: 8),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.white, width: 1.5),
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     if (quantity > 1) quantity--;
// //                                   });
// //                                 },
// //                                 child: Container(
// //                                   width: 36,
// //                                   height: 36,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.black,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Icon(
// //                                     Icons.remove,
// //                                     color: Colors.white,
// //                                     size: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Text(
// //                                 '$quantity',
// //                                 style: const TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.white,
// //                                 ),
// //                               ),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     quantity++;
// //                                   });
// //                                 },
// //                                 child: Container(
// //                                   width: 36,
// //                                   height: 36,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.black,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Icon(
// //                                     Icons.add,
// //                                     color: Colors.white,
// //                                     size: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         Expanded(
// //                           child: Container(
// //                             width: 203,
// //                             height: 50,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(30),
// //                             ),
// //                             child: TextButton(
// //                               onPressed: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (_) => ShoppingCart(),
// //                                   ),
// //                                 );
// //                               },
// //                               child: const Text(
// //                                 "Add to Cart",
// //                                 style: TextStyle(
// //                                   color: Colors.black,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 25),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (_) => Checkout()),
// //                         );
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.black,
// //                         foregroundColor: Colors.white,
// //                         minimumSize: const Size.fromHeight(45),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(30),
// //                         ),
// //                       ),
// //                       child: const Text("Buy now"),
// //                     ),
// //                     const SizedBox(height: 30),
// //                     // In product_details.dart, replace the SimilarProducts widget call with:
// //                     const SizedBox(height: 30),
// //                     Container(
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF008AD2),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: SimilarProducts(
// //                         currentProduct: product!,
// //                         shopId: widget.shopId,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ColorDot extends StatelessWidget {
// //   final Color color;
// //   final bool isSelected;
// //   final VoidCallback? onTap;

// //   const ColorDot({
// //     super.key,
// //     required this.color,
// //     this.isSelected = false,
// //     this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 5),
// //         width: 28,
// //         height: 28,
// //         decoration: BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: color,
// //           border: Border.all(
// //             color: isSelected ? Colors.black : Colors.white,
// //             width: isSelected ? 3 : 2,
// //           ),
// //         ),
// //         child:
// //             isSelected
// //                 ? Icon(
// //                   Icons.check,
// //                   size: 14,
// //                   color:
// //                       color.computeLuminance() > 0.5
// //                           ? Colors.black
// //                           : Colors.white,
// //                 )
// //                 : null,
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Checkout/checkout_.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';
// import 'package:tawasul_application/view/similar_product.dart';

// class ProductDetail extends StatefulWidget {
//   final VoidCallback toggleFavorite;
//   final bool isFavorite;
//   final String productReference;
//   final String shopId;
//   final Product? product;

//   const ProductDetail({
//     super.key,
//     required this.toggleFavorite,
//     required this.isFavorite,
//     required this.productReference,
//     required this.shopId,
//     this.product,
//   });

//   @override
//   State<ProductDetail> createState() => _ProductDetailState();
// }

// class _ProductDetailState extends State<ProductDetail> {
//   int quantity = 1;
//   late bool isFavorite;
//   Product? product;
//   bool isLoading = true;
//   String errorMessage = '';
//   String? selectedColor;
//   Map<String, dynamic>? apiProductData;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = widget.isFavorite;
//     _fetchProductData();
//   }

//   Future<void> _fetchProductData() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       if (widget.product != null) {
//         product = widget.product;
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       final response = await http.get(
//         Uri.parse(
//           'http://t-api.dotit-corp.com/api/public/getProduct?code=${widget.productReference}&id-shop=${widget.shopId}',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['message'] == 'success' &&
//             jsonResponse['response'] != null &&
//             jsonResponse['response'].isNotEmpty) {
//           apiProductData = jsonResponse['response'][0];

//           product = Product.fromJson(apiProductData!);
//           setState(() {
//             isLoading = false;
//           });
//         } else {
//           errorMessage = 'Product not found in API response';
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       errorMessage = 'Error fetching product: $e';
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(color: Colors.white),
//               const SizedBox(height: 20),
//               const Text(
//                 'Loading product...',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (product == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, size: 64, color: Colors.white),
//               const SizedBox(height: 20),
//               Text(
//                 errorMessage.isEmpty ? 'Product not found' : errorMessage,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _fetchProductData,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

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
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF008AD2),
//                               ),
//                               child: const Icon(
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
//                               color: const Color(0xFF008AD2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Hero(
//                       tag: 'product-image-${product!.name}',
//                       child:
//                           product!.image.isNotEmpty
//                               ? Image.network(
//                                 product!.image,
//                                 height: 175,
//                                 width: 200,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Icon(Icons.error, size: 100);
//                                 },
//                               )
//                               : const Icon(Icons.image, size: 100),
//                     ),
//                     // Dynamic color dots from API
//                     if (product!.colors != null && product!.colors!.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(right: 30.0, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children:
//                               product!.colors!.map((color) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 4,
//                                   ),
//                                   child: ColorDot(
//                                     color: color,
//                                     isSelected:
//                                         selectedColor == color.value.toString(),
//                                     onTap: () {
//                                       setState(() {
//                                         selectedColor = color.value.toString();
//                                       });
//                                     },
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       )
//                     else
//                       const Padding(
//                         padding: EdgeInsets.only(right: 30.0, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [ColorDot(color: Colors.grey)],
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             product!.name,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               '${product!.price} LYD',
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             if (product!.oldPrice != null)
//                               Text(
//                                 '${product!.oldPrice!} LYD',
//                                 style: const TextStyle(
//                                   decoration: TextDecoration.lineThrough,
//                                   fontSize: 16,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Html(
//                       data: product?.description ?? 'No Description',
//                       style: {
//                         "body": Style(
//                           fontSize: FontSize(15.0),
//                           color: Colors.white,
//                           textAlign: TextAlign.justify,
//                         ),
//                         "p": Style(
//                           margin: Margins.only(bottom: 10),
//                           color: Colors.white,
//                         ),
//                         "ul": Style(
//                           color: Colors.white,
//                           margin: Margins.only(bottom: 10),
//                         ),
//                         "li": Style(color: Colors.white),
//                       },
//                     ),
//                     const SizedBox(height: 20),
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
//                           MaterialPageRoute(builder: (_) => Checkout()),
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

//                     // Similar Products Section - UPDATED
//                     Consumer<ProductController>(
//                       builder: (context, productController, child) {
//                         return SimilarProducts(
//                           currentProduct: product!,
//                           shopId: widget.shopId,
//                           allProducts: [],
//                         );
//                       },
//                     ),
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
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const ColorDot({
//     super.key,
//     required this.color,
//     this.isSelected = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         width: 28,
//         height: 28,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color,
//           border: Border.all(
//             color: isSelected ? Colors.black : Colors.white,
//             width: isSelected ? 3 : 2,
//           ),
//         ),
//         child:
//             isSelected
//                 ? Icon(
//                   Icons.check,
//                   size: 14,
//                   color:
//                       color.computeLuminance() > 0.5
//                           ? Colors.black
//                           : Colors.white,
//                 )
//                 : null,
//       ),
//     );
//   }
// }



// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_html/flutter_html.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:tawasul_application/model/product_model.dart';
// // import 'package:tawasul_application/view/Checkout/checkout_.dart';
// // import 'package:tawasul_application/view/shopping_cart.dart';
// // import 'package:provider/provider.dart';
// // import 'package:tawasul_application/controller/product_controller.dart';

// // class ProductDetail extends StatefulWidget {
// //   final VoidCallback toggleFavorite;
// //   final bool isFavorite;
// //   final String productReference;
// //   final String shopId;
// //   final Product? product;

// //   const ProductDetail({
// //     super.key,
// //     required this.toggleFavorite,
// //     required this.isFavorite,
// //     required this.productReference,
// //     required this.shopId,
// //     this.product,
// //   });

// //   @override
// //   State<ProductDetail> createState() => _ProductDetailState();
// // }

// // class _ProductDetailState extends State<ProductDetail> {
// //   int quantity = 1;
// //   late bool isFavorite;
// //   Product? product;
// //   bool isLoading = true;
// //   String errorMessage = '';
// //   String? selectedColor;
// //   Map<String, dynamic>? apiProductData;
// //   List<Product> allProducts = []; 
// //   List<Product> similarProducts = [];
// //   bool isLoadingSimilar = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     isFavorite = widget.isFavorite;
// //     _fetchProductData();
// //   }

// //   Future<void> _fetchProductData() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //       });

// //       // If product is provided directly, use it
// //       if (widget.product != null) {
// //         product = widget.product;
// //         _fetchAllProducts();
// //         return;
// //       }

// //       // Fetch product data from API
// //       final response = await http.get(
// //         Uri.parse(
// //           'http://t-api.dotit-corp.com/api/public/getProduct?code=${widget.productReference}&id-shop=${widget.shopId}',
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         final jsonResponse = json.decode(response.body);
// //         if (jsonResponse['message'] == 'success' &&
// //             jsonResponse['response'] != null &&
// //             jsonResponse['response'].isNotEmpty) {
// //           apiProductData = jsonResponse['response'][0];

// //           // Create product object from API data using the fromJson constructor
// //           product = Product.fromJson(apiProductData!);
// //           _fetchAllProducts();
// //         } else {
// //           errorMessage = 'Product not found in API response';
// //           setState(() {
// //             isLoading = false;
// //           });
// //         }
// //       } else {
// //         errorMessage = 'Failed to load product: ${response.statusCode}';
// //         setState(() {
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       errorMessage = 'Error fetching product: $e';
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   Future<void> _fetchAllProducts() async {
// //     try {
// //       // Fetch all products to find similar ones
// //       final response = await http.get(
// //         Uri.parse(
// //           'http://t-api.dotit-corp.com/api/public/getProducts?id-shop=${widget.shopId}',
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         final jsonResponse = json.decode(response.body);
// //         if (jsonResponse['message'] == 'success' &&
// //             jsonResponse['response'] != null &&
// //             jsonResponse['response'].isNotEmpty) {
// //           List<Product> fetchedProducts = [];
// //           for (var item in jsonResponse['response']) {
// //             fetchedProducts.add(Product.fromJson(item));
// //           }

// //           setState(() {
// //             allProducts = fetchedProducts;
// //             _findSimilarProducts();
// //             isLoading = false;
// //           });
// //         } else {
// //           setState(() {
// //             isLoading = false;
// //           });
// //         }
// //       } else {
// //         setState(() {
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching all products: $e');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   void _findSimilarProducts() {
// //     if (product == null) return;

// //     // Filter similar products based on brand and name
// //     similarProducts =
// //         allProducts
// //             .where(
// //               (p) =>
// //                   p.id != product!.id &&
// //                   (p.brand == product!.brand ||
// //                       _isNameSimilar(p.name, product!.name)),
// //             )
// //             .take(4)
// //             .toList();
// //   }

// //   // Helper function to check if product names are similar
// //   bool _isNameSimilar(String name1, String name2) {
// //     final words1 = name1.toLowerCase().split(' ');
// //     final words2 = name2.toLowerCase().split(' ');

// //     // Check if they share at least 2 common words
// //     int commonWords = 0;
// //     for (var word in words1) {
// //       if (words2.contains(word) && word.length > 2) {
// //         commonWords++;
// //         if (commonWords >= 2) return true;
// //       }
// //     }

// //     return false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading) {
// //       return Scaffold(
// //         backgroundColor: const Color(0xFF008AD2),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const CircularProgressIndicator(color: Colors.white),
// //               const SizedBox(height: 20),
// //               const Text(
// //                 'Loading product...',
// //                 style: TextStyle(color: Colors.white),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }

// //     if (product == null) {
// //       return Scaffold(
// //         backgroundColor: const Color(0xFF008AD2),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.error_outline, size: 64, color: Colors.white),
// //               const SizedBox(height: 20),
// //               Text(
// //                 errorMessage.isEmpty ? 'Product not found' : errorMessage,
// //                 style: const TextStyle(color: Colors.white),
// //                 textAlign: TextAlign.center,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _fetchProductData,
// //                 child: const Text('Retry'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //     final productController = Provider.of<ProductController>(
// //       context,
// //       listen: false,
// //     );
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF008AD2),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Container(
// //                 width: double.infinity,
// //                 height: 270.h,
// //                 decoration: const BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.only(
// //                     bottomLeft: Radius.circular(90),
// //                     bottomRight: Radius.circular(90),
// //                   ),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: 10.h),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(
// //                         horizontal: 20.w,
// //                         vertical: 10.h,
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           GestureDetector(
// //                             onTap: () => Navigator.pop(context),
// //                             child: Container(
// //                               width: 41,
// //                               height: 41,
// //                               decoration: BoxDecoration(
// //                                 shape: BoxShape.circle,
// //                                 color: Color(0xFF008AD2),
// //                               ),
// //                               child: Icon(
// //                                 Icons.arrow_back_ios_new_sharp,
// //                                 size: 20,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                           Text(
// //                             "Product details",
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 20,
// //                             ),
// //                           ),
// //                           GestureDetector(
// //                             onTap: () {
// //                               widget.toggleFavorite();
// //                               setState(() {
// //                                 isFavorite = !isFavorite;
// //                               });
// //                             },
// //                             child: Icon(
// //                               isFavorite
// //                                   ? Icons.favorite
// //                                   : Icons.favorite_border,
// //                               size: 38,
// //                               color: Color(0xFF008AD2),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     Hero(
// //                       tag: 'product-image-${product!.name}',
// //                       child:
// //                           product!.image.isNotEmpty
// //                               ? Image.network(
// //                                 product!.image,
// //                                 height: 175,
// //                                 width: 200,
// //                                 fit: BoxFit.contain,
// //                                 errorBuilder: (context, error, stackTrace) {
// //                                   return const Icon(Icons.error, size: 100);
// //                                 },
// //                               )
// //                               : const Icon(Icons.image, size: 100),
// //                     ),
// //                     // Dynamic color dots from API
// //                     if (product!.colors != null && product!.colors!.isNotEmpty)
// //                       Padding(
// //                         padding: EdgeInsets.only(right: 30.0, top: 10),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children:
// //                               product!.colors!.map((color) {
// //                                 return Padding(
// //                                   padding: EdgeInsets.symmetric(horizontal: 4),
// //                                   child: ColorDot(
// //                                     color: color,
// //                                     isSelected:
// //                                         selectedColor == color.value.toString(),
// //                                     onTap: () {
// //                                       setState(() {
// //                                         selectedColor = color.value.toString();
// //                                       });
// //                                     },
// //                                   ),
// //                                 );
// //                               }).toList(),
// //                         ),
// //                       )
// //                     else
// //                       Padding(
// //                         padding: EdgeInsets.only(right: 30.0, top: 10),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [ColorDot(color: Colors.grey)],
// //                         ),
// //                       ),
// //                     SizedBox(height: 16),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 6),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 15.0),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           product!.name,
// //                           style: TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.end,
// //                           children: [
// //                             Text(
// //                               product!.price,
// //                               style: TextStyle(
// //                                 fontSize: 22,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                             if (product!.oldPrice != null)
// //                               Text(
// //                                 product!.oldPrice!,
// //                                 style: TextStyle(
// //                                   decoration: TextDecoration.lineThrough,
// //                                   fontSize: 16,
// //                                   color: Colors.white70,
// //                                 ),
// //                               ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 5),
// //                     Html(
// //                       data: product?.description ?? 'No Description',
// //                       style: {
// //                         "body": Style(
// //                           fontSize: FontSize(15.0),
// //                           color: Colors.white,
// //                           textAlign: TextAlign.justify,
// //                         ),
// //                         "p": Style(
// //                           margin: Margins.only(bottom: 10),
// //                           color: Colors.white,
// //                         ),
// //                         "ul": Style(
// //                           color: Colors.white,
// //                           margin: Margins.only(bottom: 10),
// //                         ),
// //                         "li": Style(color: Colors.white),
// //                       },
// //                     ),
// //                     SizedBox(height: 20),
// //                     Row(
// //                       children: [
// //                         Container(
// //                           width: 160,
// //                           height: 50,
// //                           padding: const EdgeInsets.symmetric(horizontal: 8),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.white, width: 1.5),
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     if (quantity > 1) quantity--;
// //                                   });
// //                                 },
// //                                 child: Container(
// //                                   width: 36,
// //                                   height: 36,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.black,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Icon(
// //                                     Icons.remove,
// //                                     color: Colors.white,
// //                                     size: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Text(
// //                                 '$quantity',
// //                                 style: const TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.white,
// //                                 ),
// //                               ),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     quantity++;
// //                                   });
// //                                 },
// //                                 child: Container(
// //                                   width: 36,
// //                                   height: 36,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.black,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Icon(
// //                                     Icons.add,
// //                                     color: Colors.white,
// //                                     size: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         Expanded(
// //                           child: Container(
// //                             width: 203,
// //                             height: 50,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(30),
// //                             ),
// //                             child: TextButton(
// //                               onPressed: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (_) => ShoppingCart(),
// //                                   ),
// //                                 );
// //                               },
// //                               child: const Text(
// //                                 "Add to Cart",
// //                                 style: TextStyle(
// //                                   color: Colors.black,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 25),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (_) => Checkout()),
// //                         );
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.black,
// //                         foregroundColor: Colors.white,
// //                         minimumSize: const Size.fromHeight(45),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(30),
// //                         ),
// //                       ),
// //                       child: const Text("Buy now"),
// //                     ),
// //                     const SizedBox(height: 30),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ColorDot extends StatelessWidget {
// //   final Color color;
// //   final bool isSelected;
// //   final VoidCallback? onTap;

// //   const ColorDot({
// //     super.key,
// //     required this.color,
// //     this.isSelected = false,
// //     this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 5),
// //         width: 28,
// //         height: 28,
// //         decoration: BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: color,
// //           border: Border.all(
// //             color: isSelected ? Colors.black : Colors.white,
// //             width: isSelected ? 3 : 2,
// //           ),
// //         ),
// //         child:
// //             isSelected
// //                 ? Icon(
// //                   Icons.check,
// //                   size: 14,
// //                   color:
// //                       color.computeLuminance() > 0.5
// //                           ? Colors.black
// //                           : Colors.white,
// //                 )
// //                 : null,
// //       ),
// //     );
// //   }
// // }
