// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:tawasul_application/view/navbar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   int _currentNavIndex = 0;
//   int selectedTab = 0;

//   final List<String> tabs = ['All', 'Promotions', 'Orders', 'Alerts'];

//   final Map<String, List<Map<String, dynamic>>> categorizedNotifications = {
//     'Promotions': [
//       {
//         "iconCode": Icons.local_offer.codePoint,
//         "title": "Big Sale Alert!",
//         "subtitle": "Enjoy 50% off your favorite items today!",
//         "time": "2 hours ago",
//         "color": Color(0xFFFF6B6B),
//         "isRead": false,
//       },
//       {
//         "iconCode": Icons.card_giftcard.codePoint,
//         "title": "Exclusive Offer for You!",
//         "subtitle": "Get a free gift on your next order",
//         "time": "1 day ago",
//         "color": Color(0xFF4ECDC4),
//         "isRead": true,
//       },
//       {
//         "iconCode": Icons.flash_on.codePoint,
//         "title": "Flash Deal: Limited Time Only!",
//         "subtitle": "Save 30% on electronics. Ends at midnight!",
//         "time": "3 hours ago",
//         "color": Color(0xFFFFD166),
//         "isRead": false,
//       },
//     ],
//     'Orders': [
//       {
//         "iconCode": Icons.local_shipping.codePoint,
//         "title": "Order Shipped!",
//         "subtitle": "Your order #12345 is on its way",
//         "time": "4 hours ago",
//         "color": Color(0xFF118AB2),
//         "isRead": true,
//       },
//       {
//         "iconCode": Icons.check_circle.codePoint,
//         "title": "Order Delivered!",
//         "subtitle": "Your order has been delivered successfully.",
//         "time": "2 days ago",
//         "color": Color(0xFF06D6A0),
//         "isRead": true,
//       },
//       {
//         "iconCode": Icons.payment.codePoint,
//         "title": "Payment Confirmed!",
//         "subtitle": "Your payment for order has been successfully processed.",
//         "time": "6 hours ago",
//         "color": Color(0xFF073B4C),
//         "isRead": false,
//       },
//     ],
//     'Alerts': [
//       {
//         "iconCode": Icons.security.codePoint,
//         "title": "Security Alert!",
//         "subtitle": "New login detected on your account.",
//         "time": "5 minutes ago",
//         "color": Color(0xFFFF6B6B),
//         "isRead": false,
//       },
//       {
//         "iconCode": Icons.notifications_active.codePoint,
//         "title": "New Feature Available",
//         "subtitle": "Check out our latest updates",
//         "time": "1 hour ago",
//         "color": Color(0xFF7209B7),
//         "isRead": false,
//       },
//     ],
//   };

//   IconData _getIconData(int? codePoint) {
//     if (codePoint == null) {
//       return Icons.notifications;
//     }
//     return IconData(codePoint, fontFamily: 'MaterialIcons');
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     List<Map<String, dynamic>> currentList = [];
//     if (selectedTab == 0) {
//       currentList.addAll(categorizedNotifications['Promotions'] ?? []);
//       currentList.addAll(categorizedNotifications['Orders'] ?? []);
//       currentList.addAll(categorizedNotifications['Alerts'] ?? []);
//     } else {
//       final categoryKey = tabs[selectedTab];
//       currentList = categorizedNotifications[categoryKey] ?? [];
//     }

//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         toolbarHeight: 56.h,
//         leadingWidth: 48.w,
//         leading: Padding(
//           padding: EdgeInsets.only(
//             left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
//             right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
//           ),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomePage()),
//               );
//             },
//             child: Container(
//               width: 36.w,
//               height: 36.w,
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
//         title: Text(
//           t.notifications,
//           style: TextStyle(
//             fontFamily: "Inter",
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildEnhancedTabs(t),
//                 SizedBox(height: 16.h),

//                 // Notification Counter
//                 _buildNotificationCounter(currentList.length),
//                 SizedBox(height: 16.h),

//                 Expanded(
//                   child:
//                       currentList.isEmpty
//                           ? _buildEmptyState(t)
//                           : ListView.separated(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20.w,
//                               vertical: 8.h,
//                             ),
//                             itemCount: currentList.length,
//                             separatorBuilder:
//                                 (context, index) => SizedBox(height: 12.h),
//                             itemBuilder: (context, index) {
//                               final item = currentList[index];
//                               return _buildEnhancedNotificationCard(
//                                 iconCode:
//                                     item['iconCode'] as int?, // Allow null
//                                 title: item['title'] as String? ?? 'No Title',
//                                 subtitle:
//                                     item['subtitle'] as String? ??
//                                     'No Description',
//                                 time: item['time'] as String? ?? 'Just now',
//                                 color:
//                                     item['color'] as Color? ??
//                                     Color(0xFF008AD2),
//                                 isRead: item['isRead'] as bool? ?? false,
//                                 onTap: () {
//                                   setState(() {
//                                     item['isRead'] = true;
//                                   });
//                                 },
//                               );
//                             },
//                           ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 45.h,
//             left: 20.w,
//             right: 20.w,
//             child: Consumer<ProductController>(
//               builder: (context, productController, child) {
//                 return CustomBottomNavBar(
//                   currentIndex: _currentNavIndex,
//                   context: context,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedTabs(AppLocalizations t) {
//     final localizedTabs = [t.all, t.promo, t.orders, t.alerts];

//     return Container(
//       height: 40.h,
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: List.generate(localizedTabs.length, (index) {
//           final isSelected = selectedTab == index;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => selectedTab = index),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Color(0xFF008AD2) : Colors.transparent,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Center(
//                   child: Text(
//                     localizedTabs[index],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                       color: isSelected ? Colors.white : Color(0xFF666666),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildNotificationCounter(int count) {
//     final t = AppLocalizations.of(context)!;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Row(
//         children: [
//           Text(
//             t.notifications,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(width: 8.w),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//             decoration: BoxDecoration(
//               color: Color(0xFF008AD2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               count.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedNotificationCard({
//     required int? iconCode,
//     required String title,
//     required String subtitle,
//     required String time,
//     required Color color,
//     required bool isRead,
//     required VoidCallback onTap,
//   }) {
//     final iconData = _getIconData(iconCode);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 12,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Unread Indicator
//             if (!isRead)
//               Positioned(
//                 left: 0,
//                 top: 0,
//                 bottom: 0,
//                 child: Container(
//                   width: 4.w,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF008AD2),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       bottomLeft: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),

//             Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Icon Container
//                   Container(
//                     width: 44.w,
//                     height: 44.w,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(iconData, color: color, size: 20.w),
//                   ),
//                   SizedBox(width: 12.w),

//                   // Content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 title,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight:
//                                       isRead
//                                           ? FontWeight.w500
//                                           : FontWeight.w700,
//                                   color: Colors.black87,
//                                   height: 1.3,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Text(
//                               time,
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Color(0xFF999999),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           subtitle,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Color(0xFF666666),
//                             fontWeight: FontWeight.w400,
//                             height: 1.4,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
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

//   Widget _buildEmptyState(AppLocalizations t) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120.w,
//             height: 120.w,
//             decoration: BoxDecoration(
//               color: Color(0xFFF0F8FF),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.notifications_off_outlined,
//               size: 50.w,
//               color: Color(0xFF008AD2),
//             ),
//           ),
//           SizedBox(height: 24.h),
//           Text(
//             'No Notifications',
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'You\'re all caught up!',
//             style: TextStyle(fontSize: 14.sp, color: Color(0xFF666666)),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentNavIndex = 0;
  int selectedTab = 0;

  final List<String> tabs = ['All', 'Promotions', 'Orders', 'Alerts'];

  final Map<String, List<Map<String, dynamic>>> categorizedNotifications = {
    'Promotions': [
      {
        "icon": Icons.local_offer,
        "title": "Big Sale Alert!",
        "subtitle": "Enjoy 50% off your favorite items today!",
        "time": "2 hours ago",
        "color": Color(0xFFFF6B6B),
        "isRead": false,
      },
      {
        "icon": Icons.card_giftcard,
        "title": "Exclusive Offer for You!",
        "subtitle": "Get a free gift on your next order",
        "time": "1 day ago",
        "color": Color(0xFF4ECDC4),
        "isRead": true,
      },
      {
        "icon": Icons.flash_on,
        "title": "Flash Deal: Limited Time Only!",
        "subtitle": "Save 30% on electronics. Ends at midnight!",
        "time": "3 hours ago",
        "color": Color(0xFFFFD166),
        "isRead": false,
      },
    ],
    'Orders': [
      {
        "icon": Icons.local_shipping,
        "title": "Order Shipped!",
        "subtitle": "Your order #12345 is on its way",
        "time": "4 hours ago",
        "color": Color(0xFF118AB2),
        "isRead": true,
      },
      {
        "icon": Icons.check_circle,
        "title": "Order Delivered!",
        "subtitle": "Your order has been delivered successfully.",
        "time": "2 days ago",
        "color": Color(0xFF06D6A0),
        "isRead": true,
      },
      {
        "icon": Icons.payment,
        "title": "Payment Confirmed!",
        "subtitle": "Your payment for order has been successfully processed.",
        "time": "6 hours ago",
        "color": Color(0xFF073B4C),
        "isRead": false,
      },
    ],
    'Alerts': [
      {
        "icon": Icons.security,
        "title": "Security Alert!",
        "subtitle": "New login detected on your account.",
        "time": "5 minutes ago",
        "color": Color(0xFFFF6B6B),
        "isRead": false,
      },
      {
        "icon": Icons.notifications_active,
        "title": "New Feature Available",
        "subtitle": "Check out our latest updates",
        "time": "1 hour ago",
        "color": Color(0xFF7209B7),
        "isRead": false,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> currentList = [];
    if (selectedTab == 0) {
      currentList.addAll(categorizedNotifications['Promotions'] ?? []);
      currentList.addAll(categorizedNotifications['Orders'] ?? []);
      currentList.addAll(categorizedNotifications['Alerts'] ?? []);
    } else {
      final categoryKey = tabs[selectedTab];
      currentList = categorizedNotifications[categoryKey] ?? [];
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                MaterialPageRoute(builder: (context) => HomePage()),
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
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          t.notifications,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildEnhancedTabs(t),
                SizedBox(height: 16.h),

                // Notification Counter
                _buildNotificationCounter(currentList.length),
                SizedBox(height: 16.h),

                Expanded(
                  child: currentList.isEmpty
                      ? _buildEmptyState(t)
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: currentList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = currentList[index];
                            return _buildEnhancedNotificationCard(
                              icon: item['icon'] as IconData,
                              title: item['title'] as String? ?? 'No Title',
                              subtitle: item['subtitle'] as String? ??
                                  'No Description',
                              time: item['time'] as String? ?? 'Just now',
                              color:
                                  item['color'] as Color? ?? Color(0xFF008AD2),
                              isRead: item['isRead'] as bool? ?? false,
                              onTap: () {
                                setState(() {
                                  item['isRead'] = true;
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
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

  Widget _buildEnhancedTabs(AppLocalizations t) {
    final localizedTabs = [t.all, t.promo, t.orders, t.alerts];

    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(localizedTabs.length, (index) {
          final isSelected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF008AD2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    localizedTabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isSelected ? Colors.white : Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCounter(int count) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(
            t.notifications,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color(0xFF008AD2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Unread Indicator
            if (!isRead)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF008AD2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20.w),
                  ),
                  SizedBox(width: 12.w),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight:
                                      isRead ? FontWeight.w500 : FontWeight.w700,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Color(0xFFF0F8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 50.w,
              color: Color(0xFF008AD2),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}