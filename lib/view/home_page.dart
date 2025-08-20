import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/view/Category/categories.dart';
import 'package:tawasul_application/view/Category/high_tech.dart';
import 'package:tawasul_application/view/Category/lifestyle.dart';
import 'package:tawasul_application/view/Category/smart_home.dart';
import 'package:tawasul_application/view/Category/smart_office.dart';
import 'package:tawasul_application/view/Profile/profile.dart';
import 'package:tawasul_application/view/Quick_access/bundels.dart';
import 'package:tawasul_application/view/Quick_access/promo.dart';
import 'package:tawasul_application/view/Quick_access/shops.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/Flash_sale/all.dart';
import 'package:tawasul_application/view/Flash_sale/brands.dart';
import 'package:tawasul_application/view/Flash_sale/newest.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/notification.dart';
import 'package:tawasul_application/view/searching_result.dart';

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

  late final List<Map<String, dynamic>> banners = [
    {
      'title': "New Collection",
      'subtitle': "Discount 30% for\nthe first transaction",
      'image': "assets/images/banner_pc.png",
      'action':
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Categories()),
          ),
    },
    {
      'title': "Summer Sale",
      'subtitle': "Up to 50% off on  \nselected items",
      'image': "assets/images/airpods.png",
      'action':
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Categories()),
          ),
    },
    {
      'title': "Tech Week",
      'subtitle': "Latest gadgets at  \nspecial prices",
      'image': "assets/images/macbook.png",
      'action':
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Categories()),
          ),
    },
  ];

  final List<Category> quickAccessCategories = [
    Category("assets/icons/warranty.svg", "Warranty", HomePage()),
    Category("assets/icons/sale.svg", "Promo", PromoPage()),
    Category("assets/icons/gift.svg", "Bundles", BundelsPage()),
    Category("assets/icons/shops.svg", "Shops", FindTawasul()),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );
    if (productController.allProducts.isEmpty) {
      await productController;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Widget _buildFilterButton(FlashSaleFilter filter) {
    final isActive = _currentFilter == filter;
    final Map<FlashSaleFilter, String> filterLabels = {
      FlashSaleFilter.all: 'All',
      FlashSaleFilter.newest: 'Newest',
      FlashSaleFilter.brands: 'Brands',
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
        return const Newest(shopId: '4');
      case FlashSaleFilter.brands:
        return const Brands();
      case FlashSaleFilter.all:
        return const All(categoryCode: '10', shopId: '4');
    }
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

  Widget _buildSectionTitle(String title, {VoidCallback? onTap}) {
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
        if (onTap != null && title != "Quick access")
          GestureDetector(
            onTap: onTap,
            child: Text(
              "See All",
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

  @override
  Widget build(BuildContext context) {
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
                            "Hi User",
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
                                  onSubmitted: _performSearch,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
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
                  SizedBox(height: 20.h),

                  // Banner Carousel
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 138.h,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 138.h,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.w),
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
                                            Text(
                                              banner['subtitle'],
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF636161),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
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
                                                'Shop Now',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Image.asset(
                                          banner['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 12.h),
                      DotsIndicator(
                        dotsCount: banners.length,
                        position: _currentBannerIndex.toDouble(),
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          activeColor: const Color(0xFF0984E3),
                          size: Size(6.w, 6.w),
                          activeSize: Size(8.w, 8.w),
                          spacing: EdgeInsets.all(4.w),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Quick Access
                      _buildSectionTitle("Quick access"),
                      SizedBox(
                        height: isIOS ? 97.h : 100.h,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
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
                      _buildSectionTitle("Flash Sale"),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Row(
                            children:
                                FlashSaleFilter.values
                                    .map(_buildFilterButton)
                                    .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.3.sh, child: _buildFilterContent()),

                      // Categories
                      _buildSectionTitle(
                        "Categories",
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
                        height: 150.h,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.extent(
                          maxCrossAxisExtent: 180.w,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            buildCategoryItem(
                              context,
                              "assets/images/high_tech.png",
                              "HighTech",
                              const HighTech(),
                            ),
                            buildCategoryItem(
                              context,
                              "assets/images/smart_home.png",
                              "Smart home",
                              const SmartHome(),
                            ),
                            buildCategoryItem(
                              context,
                              "assets/images/smart_office.png",
                              "Smart office",
                              const SmartOffice(),
                            ),
                            buildCategoryItem(
                              context,
                              "assets/images/lifestyle.png",
                              "Lifestyle",
                              const LifeStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
