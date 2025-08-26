import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/category_model.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/product_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LifeStyle extends StatefulWidget {
  const LifeStyle({super.key});

  @override
  State<LifeStyle> createState() => _LifeStyleState();
}

class _LifeStyleState extends State<LifeStyle> with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late TabController _tabController;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  List<Category> _categories = [];
  bool _isLoadingCategories = true;
  String _selectedCategoryCode = '';
  bool _isLoadingProducts = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      final lifestyleCode = await ApiService.getCategoryCodeByName('Lifestyle');

      if (lifestyleCode.isNotEmpty) {
        setState(() {
          _selectedCategoryCode = lifestyleCode;
          _isLoadingCategories = false;
          _fetchProductsByCategory(lifestyleCode);
        });
      } else {
        setState(() {
          _isLoadingCategories = false;
          print("Lifestyle category not found");
        });
      }
    } catch (e) {
      setState(() => _isLoadingCategories = false);
      print("Error fetching Lifestyle category: $e");
    }
  }

  Future<void> _fetchProductsByCategory(String categoryCode) async {
    if (_isLoadingProducts) return;

    setState(() => _isLoadingProducts = true);

    try {
      final productController = Provider.of<ProductController>(
        context,
        listen: false,
      );

      final products = await ApiService.getCategoryProducts(
        categoryCode: categoryCode,
        shopId: '4',
      );

      productController.setAllProducts(products);

      setState(() {
        _selectedCategoryCode = categoryCode;
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() => _isLoadingProducts = false);
      print("Error fetching products: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _searchResults.clear();
      }
    });
  }

  void _performSearch(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );

    setState(() {
      _searchResults =
          productController.allProducts.where((product) {
            return product.name.toLowerCase().contains(query) ||
                product.brand.toLowerCase().contains(query);
          }).toList();
    });
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
                  product: product,
                  toggleFavorite:
                      () => productController.toggleFavorite(product.id),
                  isFavorite: product.isFavorite,
                ),
          ),
        );
      },
      child: Container(
        width: 200.w,
        height: 220.h,
        margin: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 254, 254, 254),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 0,
              blurStyle: BlurStyle.normal,
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
                  SizedBox(height: 4.h),
                  Center(
                    child:
                        product.image.isNotEmpty
                            ? Image.network(
                              product.image,
                              width: 90.w,
                              height: 90.h,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size: 50.sp,
                                    color: Colors.grey,
                                  ),
                            )
                            : Icon(
                              Icons.image_not_supported,
                              size: 50.sp,
                              color: Colors.grey,
                            ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        product.price,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1264a3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.oldPrice != null) ...[
                        SizedBox(width: 3.w),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: t.searchProducts,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F6F8),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch(context);
                              },
                            )
                            : null,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _performSearch(context);
                    }
                  },
                  onSubmitted: (_) => _performSearch(context),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008AD2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    final t = AppLocalizations.of(context)!;
    if (_isLoading || _isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              t.noProductsFound,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
      ),
      padding: EdgeInsets.only(bottom: 90.h, left: 8.w, right: 8.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(context, products[index]);
      },
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    final t = AppLocalizations.of(context)!;

    final productController = Provider.of<ProductController>(context);
    List<Product> sortedProducts = List.from(productController.allProducts);

    if (tabIndex == 1) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(t.lyd, '').replaceAll(',', ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(t.lyd, '').replaceAll(',', ''),
        );
        return priceA.compareTo(priceB);
      });
    } else if (tabIndex == 2) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(t.lyd, '').replaceAll(',', ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(t.lyd, '').replaceAll(',', ''),
        );
        return priceB.compareTo(priceA);
      });
    }

    return _buildProductGrid(context, sortedProducts);
  }

  // In all category files, update the build method to remove the categories bar
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar:
          _showSearch
              ? null
              : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 56.h,
                leadingWidth: 60.w,
                leading: Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF008AD2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  t.lifestyle,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: _toggleSearch,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF008AD2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterPage(),
                            ),
                          ),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF008AD2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      labelStyle: TextStyle(fontSize: 12.sp),
                      tabs: [
                        Tab(text: t.topRated),
                        Tab(text: t.priceLowHigh),
                        Tab(text: t.priceHighLow),
                      ],
                    ),
                  ),
                ),
              ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_showSearch) _buildSearchBar(context),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child:
                      _showSearch
                          ? _searchController.text.isEmpty
                              ? Center(
                                child: Text(
                                  t.typeToSearch,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                              : _searchResults.isEmpty
                              ? Center(
                                child: Text(
                                  'No products found for "${_searchController.text}"',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                              : _buildProductGrid(context, _searchResults)
                          : TabBarView(
                            controller: _tabController,
                            children: List.generate(
                              3,
                              (index) => _buildTabContent(context, index),
                            ),
                          ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 35.h,
            left: 20.w,
            right: 20.w,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}
