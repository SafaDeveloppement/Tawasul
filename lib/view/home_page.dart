// import 'dart:async';
// import 'dart:io';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/view/Category/categories.dart';
// import 'package:tawasul_application/view/Category/high_tech.dart';
// import 'package:tawasul_application/view/Category/lifestyle.dart';
// import 'package:tawasul_application/view/Category/smart_home.dart';
// import 'package:tawasul_application/view/Category/smart_office.dart';
// import 'package:tawasul_application/view/Flash_sale/all.dart';
// import 'package:tawasul_application/view/Flash_sale/brands.dart';
// import 'package:tawasul_application/view/Profile/profile.dart';
// import 'package:tawasul_application/view/Quick_access/bundels.dart';
// import 'package:tawasul_application/view/Quick_access/promo.dart';
// import 'package:tawasul_application/view/Quick_access/shops.dart';
// import 'package:tawasul_application/view/filter.dart';
// import 'package:tawasul_application/view/navbar.dart';
// import 'package:tawasul_application/view/notification.dart';
// import 'package:tawasul_application/view/search/searching_result.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// enum FlashSaleFilter { all, newest, brands }

// class Category {
//   final String icon;
//   final String label;
//   final Widget page;

//   Category(this.icon, this.label, this.page);
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   FlashSaleFilter _currentFilter = FlashSaleFilter.all;
//   int _currentNavIndex = 0;
//   late TextEditingController _searchController;
//   final bool isIOS = Platform.isIOS;
//   int _currentBannerIndex = 0;
//   bool _isLoading = true;
//   String _firstName = "User";
//   bool _hasError = false;
//   Timer? _debounce; // Add debounce timer for real-time search
//   List<Product> _allProducts = []; // Add products list for filtering
//   List<Product> _filteredProducts = []; // Add filtered products list
//   bool _showSearchResults = false; // Track if we should show search results

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _initializeData();
//     _loadCustomerDetails();
//     _loadProducts(); // Load products for search
//   }

//   Future<void> _loadProducts() async {
//     try {
//       _allProducts =
//           (await ApiService.getCategoryProducts(
//             categoryCode: '10',
//             shopId: '4',
//           )).cast<Product>();
//       _filteredProducts = _allProducts;
//     } catch (e) {
//       print("Error loading products for search: $e");
//     }
//   }

//   Future<void> _initializeData() async {
//     final productController = Provider.of<ProductController>(
//       context,
//       listen: false,
//     );

//     if (productController.allProducts.isEmpty) {
//       try {
//         await Future.delayed(const Duration(seconds: 2));
//       } catch (e) {
//         debugPrint('Error loading products: $e');
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _loadCustomerDetails() async {
//     try {
//       final customerDetails = await ApiService.getCustomerDetails();

//       if (customerDetails != null && mounted) {
//         setState(() {
//           _firstName =
//               customerDetails['firstName'] ??
//               customerDetails['first_name'] ??
//               'User';
//         });
//       } else {
//         setState(() {
//           _hasError = true;
//           _firstName = "User";
//         });
//       }
//     } catch (e) {
//       print("Error loading customer details: $e");
//       setState(() {
//         _hasError = true;
//         _firstName = "User";
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _performSearch(String query) {
//     if (query.trim().isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchingResult(searchQuery: query),
//         ),
//       );
//     }
//   }

//   Widget buildCategoryItem(
//     BuildContext context,
//     String imagesPath,
//     String label,
//     Widget page,
//   ) {
//     return GestureDetector(
//       onTap:
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => page),
//           ),
//       child: Column(
//         children: [
//           Image.asset(
//             imagesPath,
//             height: 100.h,
//             width: 160.w,
//             errorBuilder:
//                 (context, error, stackTrace) => Icon(Icons.error, size: 100.w),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.normal,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQuickAccessButton(String iconPath, String label, Widget page) {
//     return GestureDetector(
//       onTap:
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => page),
//           ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             iconPath,
//             height: 65.h,
//             width: 65.w,
//             errorBuilder:
//                 (context, error, stackTrace) => Icon(Icons.error, size: 50.w),
//           ),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w400,
//               color: Colors.black,
//               height: 1.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showFilterDialog(BuildContext context) async {
//     final result = await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           margin: EdgeInsets.only(top: 50.h),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: FilterPage(),
//         );
//       },
//     );

//     if (result != null) {
//       debugPrint('Applied Filters: $result');
//     }
//   }

//   Widget _buildFilterContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     switch (_currentFilter) {
//       case FlashSaleFilter.newest:
//         return Consumer<ProductController>(
//           builder: (context, productController, child) {
//             if (productController.allProducts.isEmpty) {
//               return Center(child: Text("No products available"));
//             }
//             return const All(categoryName: 'Lifestyle', shopId: '4');
//           },
//         );
//       case FlashSaleFilter.brands:
//         return const Brands();
//       case FlashSaleFilter.all:
//         return Consumer<ProductController>(
//           builder: (context, productController, child) {
//             if (productController.allProducts.isEmpty) {
//               return Center(child: Text("No products available"));
//             }
//             return All(categoryName: 'Lifestyle', shopId: '4');
//           },
//         );
//     }
//   }

//   Widget _buildFilterButton(FlashSaleFilter filter, AppLocalizations t) {
//     final isActive = _currentFilter == filter;
//     final Map<FlashSaleFilter, String> filterLabels = {
//       FlashSaleFilter.all: t.all,
//       FlashSaleFilter.newest: t.newest,
//       FlashSaleFilter.brands: t.brands,
//     };

//     return GestureDetector(
//       onTap: () => setState(() => _currentFilter = filter),
//       child: Container(
//         width: filter == FlashSaleFilter.all ? 60.w : 112.w,
//         height: 30.h,
//         margin: EdgeInsets.only(right: 6.w),
//         decoration: BoxDecoration(
//           color:
//               isActive
//                   ? const Color(0xFF0984E3)
//                   : const Color(0xFFD9D9D9).withOpacity(0.55),
//           shape:
//               filter == FlashSaleFilter.all
//                   ? BoxShape.circle
//                   : BoxShape.rectangle,
//           borderRadius:
//               filter == FlashSaleFilter.all
//                   ? null
//                   : BorderRadius.circular(20.r),
//         ),
//         child: Center(
//           child: Text(
//             filterLabels[filter]!,
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               color: isActive ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(
//     String title, {
//     VoidCallback? onTap,
//     String? seeAllText,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         if (onTap != null)
//           GestureDetector(
//             onTap: onTap,
//             child: Text(
//               seeAllText ?? '',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.sp,
//                 color: const Color(0xFF0984E3),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     final List<Map<String, dynamic>> banners = [
//       {
//         'title': t.newCollection,
//         'subtitle': t.discount30,
//         'image': "assets/images/banner_pc.png",
//         'action':
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Categories()),
//             ),
//       },
//       {
//         'title': t.summerSale,
//         'subtitle': t.upTo50Off,
//         'image': "assets/images/airpods.png",
//         'action':
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Categories()),
//             ),
//       },
//       {
//         'title': t.techWeek,
//         'subtitle': t.latestGadgets,
//         'image': "assets/images/macbook.png",
//         'action':
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Categories()),
//             ),
//       },
//     ];

//     final List<Category> quickAccessCategories = [
//       Category("assets/icons/warranty.svg", t.warranty, HomePage()),
//       Category("assets/icons/sale.svg", t.promo, PromoPage()),
//       Category("assets/icons/gift.svg", t.bundles, BundelsPage()),
//       Category("assets/icons/shops.svg", t.shops, FindTawasul()),
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBody: true,
//       body: Stack(
//         children: [
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               padding: EdgeInsets.only(
//                 left: 18.w,
//                 right: 18.w,
//                 top: 18.h,
//                 bottom: 120.h,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Top Bar
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap:
//                                 () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Profile(),
//                                   ),
//                                 ),
//                             child: SvgPicture.asset(
//                               "assets/icons/icon_user.svg",
//                               height: 24.h,
//                               width: 24.w,
//                               color: const Color(0xFF0984E3),
//                             ),
//                           ),
//                           SizedBox(width: 10.w),
//                           Text(
//                             t.greeting(_firstName), // Use the actual first name
//                             style: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap:
//                             () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const NotificationPage(),
//                               ),
//                             ),
//                         child: Container(
//                           width: 39.w,
//                           height: 35.h,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF0984E3),
//                             borderRadius: BorderRadius.circular(24.r),
//                           ),
//                           child: Icon(
//                             Icons.notifications,
//                             color: Colors.white,
//                             size: 24.sp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 20.h),

//                   // Search Bar
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 38.h,
//                           padding: EdgeInsets.symmetric(horizontal: 12.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12.r),
//                             border: Border.all(
//                               color: const Color(0xFFC2C2C2),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.search,
//                                 color: Colors.grey,
//                                 size: 20.sp,
//                               ),
//                               SizedBox(width: 8.w),

//                               Expanded(
//                                 child: TextField(
//                                   controller: _searchController,
//                                   //onChanged: _performRealTimeSearch,
//                                   onSubmitted: _performSearch,
//                                   decoration: InputDecoration(
//                                     hintText: t.searchProducts,
//                                     border: InputBorder.none,
//                                     isDense: true,
//                                     hintStyle: TextStyle(fontSize: 14.sp),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       GestureDetector(
//                         onTap: () => _showFilterDialog(context),
//                         child: Container(
//                           width: 44.w,
//                           height: 39.h,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF0984E3),
//                             borderRadius: BorderRadius.circular(50.r),
//                           ),
//                           child: Center(
//                             child: FaIcon(
//                               FontAwesomeIcons.sliders,
//                               color: Colors.white,
//                               size: 24.sp,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 20.h),

//                   // Banner Carousel
//                   Column(
//                     children: [
//                       CarouselSlider(
//                         options: CarouselOptions(
//                           height: 145.h,
//                           autoPlay: true,
//                           enlargeCenterPage: true,
//                           viewportFraction: 1.0,
//                           onPageChanged: (index, reason) {
//                             setState(() => _currentBannerIndex = index);
//                           },
//                         ),
//                         items:
//                             banners.map((banner) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFFD9D9D9,
//                                   ).withOpacity(0.70),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(6.w),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               banner['title'],
//                                               style: TextStyle(
//                                                 fontSize: 18.sp,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             SizedBox(height: 8.h),
//                                             Container(
//                                               width: 200,
//                                               child: Text(
//                                                 banner['subtitle'],
//                                                 style: TextStyle(
//                                                   fontSize: 15.sp,
//                                                   color: const Color(
//                                                     0xFF636161,
//                                                   ),
//                                                 ),
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             SizedBox(height: 6.h),
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: const Color(
//                                                   0xFF0984E3,
//                                                 ),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                         10.r,
//                                                       ),
//                                                 ),
//                                               ),
//                                               onPressed: banner['action'],
//                                               child: Text(
//                                                 t.shop,
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   color: Colors.white,
//                                                 ),
//                                                 maxLines: 3,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Image.asset(
//                                         banner['image'],
//                                         width: 100.w,
//                                         height: 110.h,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                       ),
//                       SizedBox(height: 12.h),
//                       DotsIndicator(
//                         dotsCount: banners.length,
//                         position: _currentBannerIndex.toDouble(),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 12.h),

//                   // Quick Access
//                   _buildSectionTitle(t.quickAccess),
//                   SizedBox(
//                     height: isIOS ? 97.h : 100.h,
//                     width: MediaQuery.of(context).size.width,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: quickAccessCategories.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.only(right: isIOS ? 4.w : 7.w),
//                           child: buildQuickAccessButton(
//                             quickAccessCategories[index].icon,
//                             quickAccessCategories[index].label,
//                             quickAccessCategories[index].page,
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   SizedBox(height: 10.h),

//                   // Flash Sale
//                   _buildSectionTitle(t.flashSale),
//                   Row(
//                     children:
//                         FlashSaleFilter.values
//                             .map((f) => _buildFilterButton(f, t))
//                             .toList(),
//                   ),
//                   SizedBox(height: 20.h),
//                   SizedBox(height: 300.h, child: _buildFilterContent()),

//                   // Categories
//                   _buildSectionTitle(
//                     t.categories,
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const Categories(),
//                           ),
//                         ),
//                     // seeAllText: t.seeAll,
//                   ),

//                   SizedBox(height: 15.h),
//                   SizedBox(
//                     height: 130.h,
//                     child: GridView.extent(
//                       shrinkWrap: true,
//                       physics: const ScrollPhysics(),
//                       maxCrossAxisExtent: 180.w,
//                       scrollDirection: Axis.horizontal,
//                       childAspectRatio: 0.8,
//                       crossAxisSpacing: 5.w,
//                       mainAxisSpacing: 2.h,
//                       children: [
//                         buildCategoryItem(
//                           context,
//                           "assets/images/high_tech.png",
//                           t.highTech,
//                           const HighTech(),
//                         ),
//                         buildCategoryItem(
//                           context,
//                           "assets/images/smart_home.png",
//                           t.smartHome,
//                           const SmartHome(),
//                         ),
//                         buildCategoryItem(
//                           context,
//                           "assets/images/smart_office.png",
//                           t.smartOffice,
//                           const SmartOffice(),
//                         ),
//                         buildCategoryItem(
//                           context,
//                           "assets/images/lifestyle.png",
//                           t.lifestyle,
//                           const LifeStyle(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Bottom Nav Bar
//           Positioned(
//             bottom: 50.h,
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
// }

import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart' as product_model;
import 'package:tawasul_application/view/Category/categories.dart';
import 'package:tawasul_application/view/Category/high_tech.dart';
import 'package:tawasul_application/view/Category/lifestyle.dart';
import 'package:tawasul_application/view/Category/smart_home.dart';
import 'package:tawasul_application/view/Category/smart_office.dart';
import 'package:tawasul_application/view/Flash_sale/all.dart';
import 'package:tawasul_application/view/Flash_sale/brands.dart' as brands;
import 'package:tawasul_application/view/Profile/profile.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:tawasul_application/view/Quick_access/bundels.dart';
import 'package:tawasul_application/view/Quick_access/promo.dart';
import 'package:tawasul_application/view/Quick_access/shops.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/notification.dart';
import 'package:tawasul_application/view/search/searching_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FlashSaleFilter { all, newest, brands }

class Category {
  final String icon;
  final String label;
  final Widget page;

  Category(this.icon, this.label, this.page);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlashSaleFilter _currentFilter = FlashSaleFilter.all;
  int _currentNavIndex = 0;
  late TextEditingController _searchController;
  final bool isIOS = Platform.isIOS;
  int _currentBannerIndex = 0;
  bool _isLoading = true;
  String _firstName = "User";
  bool _hasError = false;
  Timer? _debounce;
  List<product_model.Product> _allProducts = [];
  List<product_model.Product> _filteredProducts = [];
  bool _showSearchResults = false;
  bool _searchLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeData();
    _loadCustomerDetails();
    _loadProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _searchLoading = true;
    });

    try {
      _allProducts = await ApiService.getCategoryProducts(
        categoryCode: '10',
        shopId: '4',
      );
      _filteredProducts = _allProducts;
    } catch (e) {
      print("Error loading products for search: $e");
    }

    setState(() {
      _searchLoading = false;
    });
  }

  Future<void> _initializeData() async {
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );

    if (productController.allProducts.isEmpty) {
      try {
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        debugPrint('Error loading products: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadCustomerDetails() async {
    try {
      final customerDetails = await ApiService.getCustomerDetails();

      if (customerDetails != null && mounted) {
        setState(() {
          _firstName =
              customerDetails['firstName'] ??
              customerDetails['first_name'] ??
              'User';
        });
      } else {
        setState(() {
          _hasError = true;
          _firstName = "User";
        });
      }
    } catch (e) {
      print("Error loading customer details: $e");
      setState(() {
        _hasError = true;
        _firstName = "User";
      });
    }
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _allProducts;
        _showSearchResults = false;
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredProducts =
          _allProducts.where((product_model.Product product) {
            return product.name.toLowerCase().contains(lowerCaseQuery) ||
                product.brand.toLowerCase().contains(lowerCaseQuery) ||
                product.description.toLowerCase().contains(lowerCaseQuery);
          }).toList();
      _showSearchResults = true;
    });
  }

  void _performRealTimeSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterProducts(query);
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchingResult(searchQuery: query),
        ),
      );
    }
  }

  Widget buildCategoryItem(
    BuildContext context,
    String imagesPath,
    String label,
    Widget page,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          ),
      child: Column(
        children: [
          Image.asset(
            imagesPath,
            height: 100.h,
            width: 160.w,
            errorBuilder:
                (context, error, stackTrace) => Icon(Icons.error, size: 100.w),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickAccessButton(String iconPath, String label, Widget page) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 65.h,
            width: 65.w,
            errorBuilder:
                (context, error, stackTrace) => Icon(Icons.error, size: 50.w),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 50.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FilterPage(),
        );
      },
    );

    if (result != null) {
      debugPrint('Applied Filters: $result');
    }
  }

  Widget _buildFilterContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_currentFilter) {
      case FlashSaleFilter.newest:
        return Consumer<ProductController>(
          builder: (context, productController, child) {
            if (productController.allProducts.isEmpty) {
              return Center(child: Text("No products available"));
            }
            return const All(categoryName: 'Lifestyle', shopId: '4');
          },
        );
      case FlashSaleFilter.brands:
        return const brands.Brands();
      case FlashSaleFilter.all:
        return Consumer<ProductController>(
          builder: (context, productController, child) {
            if (productController.allProducts.isEmpty) {
              return Center(child: Text("No products available"));
            }
            return All(categoryName: 'Lifestyle', shopId: '4');
          },
        );
    }
  }

  Widget _buildFilterButton(FlashSaleFilter filter, AppLocalizations t) {
    final isActive = _currentFilter == filter;
    final Map<FlashSaleFilter, String> filterLabels = {
      FlashSaleFilter.all: t.all,
      FlashSaleFilter.newest: t.newest,
      FlashSaleFilter.brands: t.brands,
    };

    return GestureDetector(
      onTap: () => setState(() => _currentFilter = filter),
      child: Container(
        width: filter == FlashSaleFilter.all ? 60.w : 112.w,
        height: 30.h,
        margin: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFF0984E3)
                  : const Color(0xFFD9D9D9).withOpacity(0.55),
          shape:
              filter == FlashSaleFilter.all
                  ? BoxShape.circle
                  : BoxShape.rectangle,
          borderRadius:
              filter == FlashSaleFilter.all
                  ? null
                  : BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            filterLabels[filter]!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    VoidCallback? onTap,
    String? seeAllText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              seeAllText ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: const Color(0xFF0984E3),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchProductItem(
    product_model.Product product,
    AppLocalizations t,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetail(
                  productReference: product.reference,
                  shopId: '4',
                  toggleFavorite: () => {},
                  isFavorite: false,
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    product.image.isNotEmpty
                        ? product.image
                        : 'https://via.placeholder.com/100',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '${product.price} ${t.lyd}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0984E3),
                          ),
                        ),
                        if (product.oldPrice != null &&
                            product.oldPrice != product.price)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Text(
                              '${product.oldPrice} ${t.lyd}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (product.discount != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          product.discount!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> banners = [
      {
        'title': t.newCollection,
        'subtitle': t.discount30,
        'image': "assets/images/banner_pc.png",
        'action':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Categories()),
            ),
      },
      {
        'title': t.summerSale,
        'subtitle': t.upTo50Off,
        'image': "assets/images/airpods.png",
        'action':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Categories()),
            ),
      },
      {
        'title': t.techWeek,
        'subtitle': t.latestGadgets,
        'image': "assets/images/macbook.png",
        'action':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Categories()),
            ),
      },
    ];

    final List<Category> quickAccessCategories = [
      Category("assets/icons/warranty.svg", t.warranty, HomePage()),
      Category("assets/icons/sale.svg", t.promo, PromoPage()),
      Category("assets/icons/gift.svg", t.bundles, BundelsPage()),
      Category("assets/icons/shops.svg", t.shops, FindTawasul()),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 18.w,
                right: 18.w,
                top: 18.h,
                bottom: 120.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(),
                                  ),
                                ),
                            child: SvgPicture.asset(
                              "assets/icons/icon_user.svg",
                              height: 24.h,
                              width: 24.w,
                              color: const Color(0xFF0984E3),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            t.greeting(_firstName),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationPage(),
                              ),
                            ),
                        child: Container(
                          width: 39.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0984E3),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFC2C2C2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _performRealTimeSearch,
                                  onSubmitted: _performSearch,
                                  decoration: InputDecoration(
                                    hintText: t.searchProducts,
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => _showFilterDialog(context),
                        child: Container(
                          width: 44.w,
                          height: 39.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0984E3),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.sliders,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Show search results if searching
                  if (_showSearchResults) ...[
                    SizedBox(height: 16.h),
                    _searchLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filteredProducts.isEmpty
                                  ? '${t.noProductsFoundFor} "${_searchController.text}"'
                                  : '${_filteredProducts.length} ${t.resultsFoundFor} "${_searchController.text}"',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _filteredProducts.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64.sp,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        t.noProductsFound,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        t.tryDifferentKeywords,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : Column(
                                  children:
                                      _filteredProducts
                                          .map(
                                            (product) =>
                                                _buildSearchProductItem(
                                                  product,
                                                  t,
                                                ),
                                          )
                                          .toList(),
                                ),
                          ],
                        ),
                    SizedBox(height: 16.h),
                  ] else ...[
                    // Original content when not searching
                    SizedBox(height: 20.h),

                    // Banner Carousel
                    Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 145.h,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() => _currentBannerIndex = index);
                            },
                          ),
                          items:
                              banners.map((banner) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFD9D9D9,
                                    ).withOpacity(0.70),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(6.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                banner['title'],
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  banner['subtitle'],
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: const Color(
                                                      0xFF636161,
                                                    ),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF0984E3,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: banner['action'],
                                                child: Text(
                                                  t.shop,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Image.asset(
                                          banner['image'],
                                          width: 100.w,
                                          height: 110.h,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                        SizedBox(height: 12.h),
                        DotsIndicator(
                          dotsCount: banners.length,
                          position: _currentBannerIndex.toDouble(),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Quick Access
                    _buildSectionTitle(t.quickAccess),
                    SizedBox(
                      height: isIOS ? 97.h : 100.h,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: quickAccessCategories.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: isIOS ? 4.w : 7.w),
                            child: buildQuickAccessButton(
                              quickAccessCategories[index].icon,
                              quickAccessCategories[index].label,
                              quickAccessCategories[index].page,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Flash Sale
                    _buildSectionTitle(t.flashSale),
                    Row(
                      children:
                          FlashSaleFilter.values
                              .map((f) => _buildFilterButton(f, t))
                              .toList(),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(height: 300.h, child: _buildFilterContent()),

                    // Categories
                    _buildSectionTitle(
                      t.categories,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Categories(),
                            ),
                          ),
                    ),

                    SizedBox(height: 15.h),
                    SizedBox(
                      height: 130.h,
                      child: GridView.extent(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        maxCrossAxisExtent: 180.w,
                        scrollDirection: Axis.horizontal,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 5.w,
                        mainAxisSpacing: 2.h,
                        children: [
                          buildCategoryItem(
                            context,
                            "assets/images/high_tech.png",
                            t.highTech,
                            const HighTech(),
                          ),
                          buildCategoryItem(
                            context,
                            "assets/images/smart_home.png",
                            t.smartHome,
                            const SmartHome(),
                          ),
                          buildCategoryItem(
                            context,
                            "assets/images/smart_office.png",
                            t.smartOffice,
                            const SmartOffice(),
                          ),
                          buildCategoryItem(
                            context,
                            "assets/images/lifestyle.png",
                            t.lifestyle,
                            const LifeStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Nav Bar
          Positioned(
            bottom: 50.h,
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
}
