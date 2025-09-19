// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/product_model.dart';

// class All extends StatefulWidget {
//   final String categoryCode;
//   final String shopId;

//   const All({super.key, required this.categoryCode, required this.shopId});

//   @override
//   State<All> createState() => _AllState();
// }

// class _AllState extends State<All> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProductController>(
//         context,
//         listen: false,
//       ).fetchCategoryProducts(widget.categoryCode, widget.shopId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "All Products",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<ProductController>(
//         builder: (context, controller, child) {
//           if (controller.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (controller.errorMessage.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.red, size: 50),
//                   const SizedBox(height: 12),
//                   Text(controller.errorMessage),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     onPressed: () {
//                       controller.fetchCategoryProducts(
//                         widget.categoryCode,
//                         widget.shopId,
//                       );
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (controller.allProducts.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No products found in this category",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           return GridView.builder(
//             padding: const EdgeInsets.all(12),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 12,
//               crossAxisSpacing: 12,
//               childAspectRatio: 0.65,
//             ),
//             itemCount: controller.allProducts.length,
//             itemBuilder: (context, index) {
//               final Product product = controller.allProducts[index];
//               return _buildProductCard(product);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductCard(Product product) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 4,
//       child: InkWell(
//         onTap: () {
//           // TODO: Navigate to ProductDetail
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(15),
//                 ),
//                 child: Image.network(
//                   product.image ?? "",
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image, size: 50),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name ?? "Unnamed",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "\$${product.price ?? "0"}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                       fontSize: 16,
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
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:tawasul_application/Services/api_service.dart'; 

class All extends StatefulWidget {
  final String categoryName;
  final String shopId;

  const All({super.key, required this.categoryName, required this.shopId});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  String? _categoryCode; 
  bool _isResolvingCategory = false;
  String _resolutionError = '';

  @override
  void initState() {
    super.initState();
    print(
      "Initializing All page with category name: ${widget.categoryName}, shop: ${widget.shopId}",
    );

    _resolveCategoryCode(); 
  }

  Future<void> _resolveCategoryCode() async {
    setState(() {
      _isResolvingCategory = true;
      _resolutionError = '';
    });

    try {
      final categoryCode = await ApiService.getCategoryCodeByName(
        widget.categoryName,
      );

      if (categoryCode.isEmpty) {
        setState(() {
          _resolutionError = 'Category "${widget.categoryName}" not found';
          _isResolvingCategory = false;
        });
        return;
      }

      setState(() {
        _categoryCode = categoryCode;
        _isResolvingCategory = false;
      });

      final productController = Provider.of<ProductController>(
        context,
        listen: false,
      );

      print(
        "Resolved category code: $categoryCode for name: ${widget.categoryName}",
      );
      print("Fetching category products...");

      productController.fetchCategoryProducts(categoryCode, widget.shopId);
    } catch (e) {
      setState(() {
        _resolutionError = 'Failed to resolve category: $e';
        _isResolvingCategory = false;
      });
      print("Error resolving category code: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    if (_isResolvingCategory) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text("Resolving category...", style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 8.h),
              Text(
                "Category: ${widget.categoryName}",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (_resolutionError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 40.h, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                "Category Error",
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
              SizedBox(height: 8.h),
              Text(
                _resolutionError,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _resolveCategoryCode,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // SHOW LOADING WHILE FETCHING PRODUCTS
    if (productController.isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text("Loading products...", style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 8.h),
              Text(
                "Category: ${widget.categoryName} (Code: $_categoryCode)",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              Text(
                "Shop: ${widget.shopId}",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // SHOW ERROR IF PRODUCT FETCH FAILED
    if (productController.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 40.h, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                "Error loading products",
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
              SizedBox(height: 8.h),
              Text(
                productController.errorMessage,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  productController.clearError();
                  if (_categoryCode != null) {
                    productController.fetchCategoryProducts(
                      _categoryCode!,
                      widget.shopId,
                    );
                  }
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final products = productController.allProducts;

    // SHOW NO PRODUCTS MESSAGE
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 40.h, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              "No products found",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              "Category: ${widget.categoryName} (Code: $_categoryCode)",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Text(
              "Shop: ${widget.shopId}",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                if (_categoryCode != null) {
                  productController.fetchCategoryProducts(
                    _categoryCode!,
                    widget.shopId,
                  );
                }
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // SHOW PRODUCTS GRID
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          for (int i = 0; i < products.length; i += 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProductCard(context, products[i]),
                if (i + 1 < products.length) SizedBox(width: 10.w),
                if (i + 1 < products.length)
                  _buildProductCard(context, products[i + 1]),
              ],
            ),
        ],
      ),
    );
  }
}

// KEEP THE _buildProductCard METHOD EXACTLY AS IT WAS
Widget _buildProductCard(BuildContext context, Product product) {
  final productController = Provider.of<ProductController>(
    context,
    listen: false,
  );

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProductDetail(
                productReference: product.reference,
                shopId: '4',
                toggleFavorite:
                    () => productController.toggleFavorite(product.id),
                isFavorite: product.isFavorite,
              ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.all(7.w),
      width: 150.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (product.discount != null)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF39C12),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  product.discount!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => productController.toggleFavorite(product.id),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14.r,
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color:
                      product.isFavorite
                          ? const Color(0xFF008AD2)
                          : Colors.blue[700],
                  size: 20.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 8.w, right: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                      product.image.isNotEmpty
                          ? Image.network(
                            product.image,
                            height: 90.h,
                            width: 90.w,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.error, size: 40.h),
                          )
                          : Icon(Icons.image_not_supported, size: 40.h),
                ),
                SizedBox(height: 5.h),
                Text(
                  product.brand.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF96979A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF092A43),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      "${product.price} DYL",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF0984E3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    if (product.oldPrice != null)
                      Text(
                        "${product.oldPrice} DYL",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Product%20detail/product_detail.dart';

// class All extends StatefulWidget {
//   final String categoryCode;
//   final String shopId;

//   const All({super.key, required this.categoryCode, required this.shopId});

//   @override
//   State<All> createState() => _AllState();
// }

// class _AllState extends State<All> {
//   @override
//   void initState() {
//     super.initState();
//     print(
//       " Initializing All page with category: ${widget.categoryCode}, shop: ${widget.shopId}",
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final productController = Provider.of<ProductController>(
//         context,
//         listen: false,
//       );
//       print(" Fetching category products...");
//       productController.fetchCategoryProducts(
//         widget.categoryCode,
//         widget.shopId,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productController = Provider.of<ProductController>(context);

//     // Debug output
//     print(
//       "Controller state - Loading: ${productController.isLoading}, Error: ${productController.errorMessage}, Product count: ${productController.allProducts.length}",
//     );

//     if (productController.isLoading) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.h),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16.h),
//               Text("Loading products...", style: TextStyle(fontSize: 16.sp)),
//               SizedBox(height: 8.h),
//               Text(
//                 "Category: ${widget.categoryCode}, Shop: ${widget.shopId}",
//                 style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (productController.errorMessage.isNotEmpty) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.h),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error, size: 40.h, color: Colors.red),
//               SizedBox(height: 16.h),
//               Text(
//                 "Error loading products",
//                 style: TextStyle(fontSize: 16.sp, color: Colors.red),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 productController.errorMessage,
//                 style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 16.h),
//               ElevatedButton(
//                 onPressed: () {
//                   productController.clearError();
//                   productController.fetchCategoryProducts(
//                     widget.categoryCode,
//                     widget.shopId,
//                   );
//                 },
//                 child: Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final products = productController.allProducts;

//     if (products.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search_off, size: 40.h, color: Colors.grey),
//             SizedBox(height: 16.h),
//             Text(
//               "No products found",
//               style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               "Category: ${widget.categoryCode}, Shop: ${widget.shopId}",
//               style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//             ),
//             SizedBox(height: 16.h),
//             ElevatedButton(
//               onPressed: () {
//                 productController.fetchCategoryProducts(
//                   widget.categoryCode,
//                   widget.shopId,
//                 );
//               },
//               child: Text('Refresh'),
//             ),
//           ],
//         ),
//       );
//     }

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           for (int i = 0; i < products.length; i += 2)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildProductCard(context, products[i]),
//                 if (i + 1 < products.length) SizedBox(width: 10.w),
//                 if (i + 1 < products.length)
//                   _buildProductCard(context, products[i + 1]),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

// Widget _buildProductCard(BuildContext context, Product product) {
//   final productController = Provider.of<ProductController>(
//     context,
//     listen: false,
//   );

//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => ProductDetail(
//                 productReference: product.reference,
//                 shopId: '4',
//                 toggleFavorite:
//                     () => productController.toggleFavorite(product.id),
//                 isFavorite: product.isFavorite,
//               ),
//         ),
//       );
//     },
//     child: Container(
//       margin: EdgeInsets.all(7.w),
//       width: 150.w,
//       height: 200.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             offset: Offset(0, 2),
//             blurRadius: 1,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           if (product.discount != null)
//             Positioned(
//               top: 8.h,
//               left: 8.w,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF39C12),
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Text(
//                   product.discount!,
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 8.h,
//             right: 8.w,
//             child: GestureDetector(
//               onTap: () => productController.toggleFavorite(product.id),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 14.r,
//                 child: Icon(
//                   product.isFavorite ? Icons.favorite : Icons.favorite_border,
//                   color:
//                       product.isFavorite
//                           ? const Color(0xFF008AD2)
//                           : Colors.blue[700],
//                   size: 20.sp,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 10.h, left: 8.w, right: 8.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child:
//                       product.image.isNotEmpty
//                           ? Image.network(
//                             product.image,
//                             height: 90.h,
//                             width: 90.w,
//                             fit: BoxFit.contain,
//                             errorBuilder:
//                                 (context, error, stackTrace) =>
//                                     Icon(Icons.error, size: 40.h),
//                           )
//                           : Icon(Icons.image_not_supported, size: 40.h),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   product.brand.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     color: const Color(0xFF96979A),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 3.h),
//                 Text(
//                   product.name,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     color: const Color(0xFF092A43),
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 3.h),
//                 Row(
//                   children: [
//                     Text(
//                       "${product.price} DYL",
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: const Color(0xFF0984E3),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 4.w),
//                     if (product.oldPrice != null)
//                       Text(
//                         "${product.oldPrice} DYL",
//                         style: TextStyle(
//                           fontSize: 11.sp,
//                           color: Colors.grey,
//                           decoration: TextDecoration.lineThrough,
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
