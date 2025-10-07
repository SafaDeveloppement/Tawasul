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
import 'package:tawasul_application/view/Flash_sale/newest.dart';
import 'package:tawasul_application/view/Profile/profile.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:tawasul_application/view/Quick_access/bundels.dart';
import 'package:tawasul_application/view/Quick_access/shops.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FlashSaleFilter { all, newest, brands }

class Category {
  final String icon;
  final String label;
  final Widget page;

  Category(this.icon, this.label, this.page);
}

class HomePage extends StatefulWidget {
  final List<dynamic> filteredProducts;
  final Map<String, dynamic> appliedFilters;
  const HomePage({
    Key? key,
    this.filteredProducts = const [],
    this.appliedFilters = const {},
  }) : super(key: key);

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
  bool _showingFilteredResults = false;
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeData();
    _loadCustomerDetails();
    _loadProducts();

    // Initialize newest products
    _initializeNewestProducts();

    // Check if we have filtered products from the filter page
    _handleIncomingFilters();
  }

  // ADD THIS METHOD TO INITIALIZE NEWEST PRODUCTS
  void _initializeNewestProducts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = Provider.of<ProductController>(
        context,
        listen: false,
      );
      // Fetch newest products when home page loads
      productController.fetchNewestProducts(limit: 10);
    });
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle when new filtered products are passed
    _handleIncomingFilters();
  }

  void _handleIncomingFilters() {
    if (widget.filteredProducts.isNotEmpty ||
        widget.appliedFilters.isNotEmpty) {
      setState(() {
        _showingFilteredResults = true;
        _currentFilters = widget.appliedFilters;

        // Convert dynamic list to Product list
        if (widget.filteredProducts.isNotEmpty) {
          _filteredProducts =
              widget.filteredProducts.map((dynamic item) {
                return _convertToProductModel(item);
              }).toList();
        }
      });
    }
  }

  product_model.Product _convertToProductModel(dynamic productData) {
    // Parse price as double
    double parsePrice(dynamic priceValue) {
      if (priceValue == null) return 0.0;
      if (priceValue is double) return priceValue;
      if (priceValue is int) return priceValue.toDouble();
      if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    // Parse oldPrice as double?
    double? parseOldPrice(dynamic oldPriceValue) {
      if (oldPriceValue == null) return null;
      if (oldPriceValue is double) return oldPriceValue;
      if (oldPriceValue is int) return oldPriceValue.toDouble();
      if (oldPriceValue is String) {
        return double.tryParse(oldPriceValue);
      }
      return null;
    }

    return product_model.Product(
      reference: productData['reference']?.toString() ?? '',
      name: productData['name']?.toString() ?? 'Unknown Product',
      price: parsePrice(productData['price']), 
      image: productData['image']?.toString() ?? '',
      description: productData['description']?.toString() ?? '', categoryName: '', idAttributeDefault: 0, idProduct: 0, combinations: [],
    );
  }

  Future<void> _loadProducts() async {
    setState(() {
      _searchLoading = true;
    });

    
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
        _showingFilteredResults = false;
        _currentFilters = {};
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredProducts =
          _allProducts.where((product_model.Product product) {
            return product.name.toLowerCase().contains(lowerCaseQuery) ||
                product.description.toLowerCase().contains(lowerCaseQuery);
          }).toList();
      _showSearchResults = true;
      _showingFilteredResults = false;
      _currentFilters = {};
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
          builder: (context) =>HomePage(),
        ),
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _showingFilteredResults = false;
      _currentFilters = {};
      _filteredProducts = _allProducts;
      _showSearchResults = false;
      _searchController.clear();
    });
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
          child: const FilterPage(),
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
        // REPLACE THIS WITH THE NEWEST WIDGET
        return Container(
          height: 250.h,
          child: Newest(), // Use the Newest widget here
        );
      case FlashSaleFilter.brands:
        return const brands.Brands();
      // case FlashSaleFilter.all:
      //   return Consumer<ProductController>(
      //     builder: (context, productController, child) {
      //       if (productController.allProducts.isEmpty) {
      //         return Center(child: Text("No products available"));
      //       }
      //       return Center(child: Text("No products available"));
      //     },
      //   );
      case FlashSaleFilter.all:
        return All(categoryName: 'All Products', shopId: '4');
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
                  toggleFavorite: () => {},
                  isFavorite: false,
                  productReference: product.idProduct.toString(),
                  product: product,
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
                   
                    Row(
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} ${t.lyd}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0984E3),
                          ),
                        ),
                        // if (product.oldPrice != null &&
                        //     product.oldPrice != product.price)
                        //   Padding(
                        //     padding: EdgeInsets.only(left: 8.w),
                        //     child: Text(
                        //       '${product.oldPrice!.toStringAsFixed(2)} ${t.lyd}',
                        //       style: TextStyle(
                        //         fontSize: 14.sp,
                        //         color: Colors.grey,
                        //         decoration: TextDecoration.lineThrough,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                    // if (product.discount != null)
                    //   Padding(
                    //     padding: EdgeInsets.only(top: 4.h),
                    //     child: Text(
                    //       product.discount!,
                    //       style: TextStyle(
                    //         fontSize: 12.sp,
                    //         color: Colors.red,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredProductsSection(AppLocalizations t) {
    if (_showingFilteredResults && _filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No products found',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'No products match your filter criteria',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0984E3),
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_showingFilteredResults && _filteredProducts.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filtered Results',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${_filteredProducts.length} products found',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      if (_currentFilters.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          _getFiltersSummary(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.blue.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _clearFilters,
                  icon: Icon(Icons.clear, color: Colors.blue.shade800),
                  tooltip: 'Clear Filters',
                ),
              ],
            ),
          ),

          // Filtered products list
          Column(
            children:
                _filteredProducts
                    .map((product) => _buildSearchProductItem(product, t))
                    .toList(),
          ),
        ],
      );
    }

    // Show search results
    if (_showSearchResults) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _filteredProducts.isEmpty
                ? 'No products found for "${_searchController.text}"'
                : '${_filteredProducts.length} results found for "${_searchController.text}"',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _filteredProducts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Try different keywords',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : Column(
                children:
                    _filteredProducts
                        .map((product) => _buildSearchProductItem(product, t))
                        .toList(),
              ),
        ],
      );
    }

    // Return original content when not showing filtered results or search results
    return _buildOriginalContent(t);
  }

  String _getFiltersSummary() {
    List<String> filters = [];

    if (_currentFilters.containsKey('price_max')) {
      filters.add('Max price: ${_currentFilters['price_max']} LYD');
    }

    if (_currentFilters.containsKey('name') &&
        _currentFilters['name'].isNotEmpty) {
      filters.add('Search: ${_currentFilters['name']}');
    }

    if (_currentFilters.containsKey('color') &&
        _currentFilters['color'] != '000') {
      filters.add('Color: ${_currentFilters['color']}');
    }

    return filters.join(' • ');
  }

  Widget _buildOriginalContent(AppLocalizations t) {
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
      //Category("assets/icons/sale.svg", t.promo, PromoPage()),
      Category("assets/icons/gift.svg", t.bundles, BundelsPage()),
      Category("assets/icons/shops.svg", t.shops, FindTawasul()),
    ];

    return Column(
      children: [
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
                        color: const Color(0xFFD9D9D9).withOpacity(0.70),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner['title'],
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      banner['subtitle'],
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: const Color(0xFF636161),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0984E3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
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

        SizedBox(height: 4.h),

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
        SizedBox(height: 10.h),
        Row(
          children:
              FlashSaleFilter.values
                  .map((f) => _buildFilterButton(f, t))
                  .toList(),
        ),
        SizedBox(height: 250.h, child: _buildFilterContent()),

        // Categories
        _buildSectionTitle(
          t.categories,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Categories()),
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
                const Lifestyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/icons/icon_user.svg",
              height: 24.h,
              width: 24.w,
              color: const Color(0xFF008bd2),
            ),
          ),
        ),
        title: Text(
          t.greeting(_firstName),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Container(
                width: 38.w,
                height: 34.h,
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
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 95.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear, size: 18.sp),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterProducts('');
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => _showFilterDialog(context),
                        child: Container(
                          width: 39.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0984E3),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.sliders,
                              color: Colors.white,
                              size: 21.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Show filtered results, search results, or original content
                  SizedBox(height: 16.h),
                  _searchLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildFilteredProductsSection(t),
                ],
              ),
            ),
          ),

          // Bottom Nav Bar
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
}
