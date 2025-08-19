// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Chat/chat.dart';
// import 'package:tawasul_application/view/Connexion/signup.dart';
// import 'package:tawasul_application/view/favorites_page.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:tawasul_application/view/shopping_cart.dart';

// class BaseLayout extends StatelessWidget {
//   final Widget child;
//   final int currentNavIndex;
//   final List<Product>? favoriteProducts;
//   final Function(int)? toggleFavorite;
//   final Color? backgroundColor;
//   final AppBar? appBar;
//   final Widget? floatingActionButton;
//   final FloatingActionButtonLocation? floatingActionButtonLocation;

//   const BaseLayout({
//     super.key,
//     required this.child,
//     required this.currentNavIndex,
//     this.favoriteProducts,
//     this.toggleFavorite,
//     this.backgroundColor,
//     this.appBar,
//     this.floatingActionButton,
//     this.floatingActionButtonLocation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor ?? Colors.white,
//       appBar: appBar,
//       floatingActionButton: floatingActionButton,
//       floatingActionButtonLocation: floatingActionButtonLocation,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.only(bottom: 80.h),
//             child: child,
//           ),
//           Positioned(
//             left: 18.w,
//             right: 18.w,
//             bottom: 20.h,
//             child: _buildCustomNavBar(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomNavBar(BuildContext context) {
//     return Container(
//       height: 56.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFF0984E3),
//         borderRadius: BorderRadius.circular(50.r),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF0984E3).withOpacity(0.2),
//             blurRadius: 10.r,
//             spreadRadius: 2.r,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 5.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(Icons.home, 0, context),
//             _buildNavItem(Icons.shopping_cart, 1, context),
//             _buildNavItem(Icons.favorite, 2, context),
//             _buildNavItem(Icons.message, 3, context),
//             _buildNavItem(Icons.person, 4, context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, int index, BuildContext context) {
//     bool isSelected = currentNavIndex == index;

//     return GestureDetector(
//       onTap: () => _handleNavigation(index, context),
//       child: Container(
//         width: 50.w,
//         height: 50.h,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isSelected ? Colors.white : Colors.transparent,
//         ),
//         child: Icon(
//           icon,
//           color: isSelected ? const Color(0xFF0984E3) : Colors.white,
//           size: 27.sp,
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index, BuildContext context) {
//     if (index == currentNavIndex) return;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => const HomePage(),
//             transitionDuration: Duration.zero,
//           ),
//         );
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => const ShoppingCart(),
//             transitionDuration: Duration.zero,
//           ),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => FavoritesPage(
//                   favoriteProducts: favoriteProducts ?? [],
//                   toggleFavorite: toggleFavorite ?? (int index) {},
//                   allProducts: [],
//                 ),
//           ),
//         );
//         break;
//       case 3:
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => const Chat(),
//             transitionDuration: Duration.zero,
//           ),
//         );
//         break;
//       case 4:
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => Signup(),
//             transitionDuration: Duration.zero,
//           ),
//         );
//         break;
//     }
//   }
// }
