import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Chat/chat.dart';
import 'package:tawasul_application/view/Connexion/login.dart';
import 'package:tawasul_application/view/favorites.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/shopping_cart.dart';
import 'package:tawasul_application/model/product_model.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;
  final List<Product>? favoriteProducts;
  final Function(int)? toggleFavorite;
  final Function(int)? onTabTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.context,
    this.favoriteProducts,
    this.toggleFavorite,
    this.onTabTapped,
  });

  void _handleNavigation(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomePage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ShoppingCart(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => FavoritesPage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Chat(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0984E3),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0984E3).withOpacity(0.3),
            blurRadius: 12.r,
            spreadRadius: 2.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.shopping_cart, 1),
          _buildNavItem(Icons.favorite, 2),
          _buildNavItem(Icons.message, 3),
          _buildNavItem(Icons.person, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: Container(
        width: 45.w,
        height: 45.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Color(0xFF0984E3) : Colors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}
