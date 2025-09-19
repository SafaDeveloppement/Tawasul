// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/navbar.dart';
// import 'package:tawasul_application/view/Product%20detail/product_detail.dart';

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final productController = Provider.of<ProductController>(context);
//     final favoriteProducts = productController.favoriteProducts;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('My Favorites', style: TextStyle(fontSize: 18.sp)),
//         centerTitle: true,
//         leading: Padding(
//           padding: EdgeInsets.all(8.r),
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: 41.w,
//               height: 41.h,
//               padding: EdgeInsets.all(8.r),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFF008AD2),
//               ),
//               child: Icon(
//                 Icons.arrow_back_ios_new,
//                 color: Colors.white,
//                 size: 20.sp,
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           Opacity(
//             opacity: 0.0,
//             child: Padding(
//               padding: EdgeInsets.all(8.r),
//               child: Icon(Icons.menu, size: 20.sp),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           favoriteProducts.isEmpty
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.favorite_border,
//                       size: 55.sp,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(height: 12.h),
//                     Text(
//                       'No favorites yet',
//                       style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               )
//               : Padding(
//                 padding: EdgeInsets.only(bottom: 100.h),
//                 child: GridView.builder(
//                   padding: EdgeInsets.all(8.w),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.75,
//                     crossAxisSpacing: 10.w,
//                     mainAxisSpacing: 12.h,
//                   ),
//                   itemCount: favoriteProducts.length,
//                   itemBuilder: (context, index) {
//                     final product = favoriteProducts[index];
//                     return _buildProductCard(context, product);
//                   },
//                 ),
//               ),

//           Positioned(
//             bottom: 20.h,
//             left: 20.w,
//             right: 20.w,
//             child: CustomBottomNavBar(currentIndex: 2, context: context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductCard(BuildContext context, Product product) {
//     final productController = Provider.of<ProductController>(
//       context,
//       listen: false,
//     );

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => ProductDetail(
//                   productReference: product.reference,
//                   shopId: '4',
//                   toggleFavorite:
//                       () => productController.toggleFavorite(product.id),
//                   isFavorite: product.isFavorite,
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1.r,
//               blurRadius: 5.r,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(8.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       product.image,
//                       width: 90.w,
//                       height: 90.h,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     product.brand,
//                     style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     product.name,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 6.h),
//                   Row(
//                     children: [
//                       Text(
//                         product.price,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xff1264a3),
//                         ),
//                       ),
//                       if (product.oldPrice != null) ...[
//                         SizedBox(width: 4.w),
//                         Text(
//                           product.oldPrice!,
//                           style: TextStyle(
//                             decoration: TextDecoration.lineThrough,
//                             fontSize: 12.sp,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             if (product.discount != null)
//               Positioned(
//                 top: 6.h,
//                 left: 6.w,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Text(
//                     product.discount!,
//                     style: TextStyle(fontSize: 10.sp, color: Colors.white),
//                   ),
//                 ),
//               ),

//             Positioned(
//               top: 6.h,
//               right: 6.w,
//               child: GestureDetector(
//                 onTap: () => productController.toggleFavorite(product.id),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 16.r,
//                   child: Icon(
//                     Icons.favorite,
//                     color: const Color(0xFF008AD2),
//                     size: 18.sp,
//                   ),
//                 ),
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
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final productController = Provider.of<ProductController>(context);
    final favoriteProducts = productController.favoriteProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          t.myFavorites,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 41.w,
              height: 41.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF008AD2),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(Icons.menu, size: 20.sp),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          favoriteProducts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 55.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      t.noFavoritesYet,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: EdgeInsets.only(bottom: 100.h),
                child: GridView.builder(
                  padding: EdgeInsets.all(8.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    return _buildProductCard(context, product);
                  },
                ),
              ),
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: CustomBottomNavBar(currentIndex: 2, context: context),
          ),
        ],
      ),
    );
  }

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
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1.r,
              blurRadius: 5.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      product.image,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        product.price,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1264a3),
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          product.oldPrice!,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (product.discount != null)
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    product.discount!,
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              top: 6.h,
              right: 6.w,
              child: GestureDetector(
                onTap: () => productController.toggleFavorite(product.id),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16.r,
                  child: Icon(
                    Icons.favorite,
                    color: const Color(0xFF008AD2),
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
