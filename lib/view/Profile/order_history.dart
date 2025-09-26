// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class OrderHistory extends StatelessWidget {
//   const OrderHistory({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final orders = [
//       {
//         "id": "#1001",
//         "product": "Apple iPhone 14 Plus",
//         "price": "3190 LYD",
//         "date": "12 Sept 2025",
//         "status": "Delivered",
//         "image": "https://tawasul-shop.com/storage/iphone14.png",
//       },
//       {
//         "id": "#1002",
//         "product": "Smart Watch",
//         "price": "1450 LYD",
//         "date": "9 Sept 2025",
//         "status": "Delivered",
//         "image": "https://tawasul-shop.com/storage/watch.png",
//       },
//       {
//         "id": "#1003",
//         "product": "Apple AirPods",
//         "price": "120 LYD",
//         "date": "5 Sept 2025",
//         "status": "Cancelled",
//         "image": "https://tawasul-shop.com/storage/airpods.png",
//       },
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "My Orders",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(12.w),
//         child: ListView.separated(
//           itemCount: orders.length,
//           separatorBuilder: (_, __) => SizedBox(height: 12.h),
//           itemBuilder: (context, index) {
//             final order = orders[index];
//             return Container(
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12.r),
//                     child: Image.network(
//                       order["image"]!,
//                       width: 70.w,
//                       height: 70.w,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(width: 12.w),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           order["product"]!,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14.sp,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           "Order ID: ${order["id"]}",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           "Date: ${order["date"]}",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           order["price"]!,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13.sp,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Order status badge
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 10.w,
//                       vertical: 6.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(order["status"]!),
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Text(
//                       order["status"]!,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),

//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: "Cart",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: "Wishlist",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Delivered":
//         return Colors.green;
//       case "Delivered":
//         return Colors.orange;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/l10n/app_localizations_ar.dart';
import 'package:tawasul_application/view/Profile/profile.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final orders = [
      {
        "id": "#1001",
        "product": "Apple iPhone 14 Plus",
        "price": "3190 LYD",
        "date": "12 Sept 2025",
        "status": t.delivered,
        "image": "assets/images/iphone.png",
      },
      {
        "id": "#1002",
        "product": "Smart Watch",
        "price": "1450 LYD",
        "date": "9 Sept 2025",
        "status": t.delivered,
        "image": "assets/images/smart_watch.png",
      },
      {
        "id": "#1003",
        "product": "Apple AirPods",
        "price": "120 LYD",
        "date": "5 Sept 2025",
        "status": t.cancelled,
        "image": "assets/images/airpods.png",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
            right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          t.myOrders,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            order["image"]!,
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order["product"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Order ID: ${order["id"]}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Date: ${order["date"]}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                order["price"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order["status"]!),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            order["status"]!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 45.h,
            left: 20.w,
            right: 20.w,
            child: Consumer<ProductController>(
              builder: (context, productController, child) {
                return CustomBottomNavBar(
                  currentIndex: _currentNavIndex,
                  context: context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final t = AppLocalizations.of(context)!;
    switch (status) {
      case "Delivered": 
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
