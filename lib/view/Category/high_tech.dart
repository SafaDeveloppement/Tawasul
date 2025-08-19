import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/product_detail.dart';

class HighTech extends StatefulWidget {
  const HighTech({super.key});

  @override
  State<HighTech> createState() => _HighTechState();
}

class _HighTechState extends State<HighTech> with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late TabController _tabController;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
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
        width: 184.w,
        height: 200.h,
        margin: EdgeInsets.all(8.w),
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
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7.h),
                  Center(
                    child: Image.asset(
                      product.image,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
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
                    hintText: 'Search products...',
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
                    color: Color(0xFF008AD2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      padding: EdgeInsets.only(bottom: 90.h),
      children:
          products
              .map((product) => _buildProductCard(context, product))
              .toList(),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    final productController = Provider.of<ProductController>(context);
    List<Product> sortedProducts = List.from(productController.allProducts);

    if (tabIndex == 1) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(' DYL', '').replaceAll(',', ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(' DYL', '').replaceAll(',', ''),
        );
        return priceA.compareTo(priceB);
      });
    } else if (tabIndex == 2) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(' DYL', '').replaceAll(',', ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(' DYL', '').replaceAll(',', ''),
        );
        return priceB.compareTo(priceA);
      });
    }

    return _buildProductGrid(context, sortedProducts);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductController>(context);

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
                  'HighTech',
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
                      tabs: const [
                        Tab(text: 'TOP RATED'),
                        Tab(text: 'PRICE LOW-HIGH'),
                        Tab(text: 'PRICE HIGH-LOW'),
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        _showSearch
                            ? _searchController.text.isEmpty
                                ? Center(
                                  child: Text(
                                    'Type to search products',
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/filter.dart';
// import 'package:tawasul_application/view/navbar.dart';
// import 'package:tawasul_application/view/product_detail.dart';

// class HighTech extends StatefulWidget {
//   const HighTech({super.key});

//   @override
//   State<HighTech> createState() => _HighTechState();
// }

// class _HighTechState extends State<HighTech> with TickerProviderStateMixin {
//   int _currentNavIndex = 0;
//   late TabController _tabController;
//   bool _showSearch = false;
//   final TextEditingController _searchController = TextEditingController();
//   List<Product> _searchResults = [];

//   final List<Product> allProducts = [
//     Product(
//       id: 1,
//       name: "Apple AirPods",
//       brand: "APPLE",
//       price: "120 DYL",
//       image: "assets/images/new_airpods.png",
//       description: "Wireless Bluetooth earbuds with high-quality sound.",
//     ),
//     Product(
//       id: 2,
//       name: "iPhone 14 Plus",
//       brand: "APPLE",
//       price: "3,199 DYL",
//       oldPrice: "3,690 DYL",
//       discount: "20%",
//       image: "assets/images/new_iphone.png",
//       description: "Latest iPhone with A16 Bionic chip.",
//     ),
//     Product(
//       id: 3,
//       name: "MacBook Pro",
//       brand: "APPLE",
//       price: "4,299 DYL",
//       image: "assets/images/macbook.png",
//       description: "Professional laptop with M2 Pro chip.",
//     ),
//     Product(
//       id: 4,
//       name: "Apple Watch Series 8",
//       brand: "APPLE",
//       price: "1,299 DYL",
//       oldPrice: "1,499 DYL",
//       discount: "15%",
//       image: "assets/images/watch.png",
//       description: "Advanced health monitoring smartwatch.",
//     ),
//     Product(
//       id: 5,
//       name: "iPad Pro",
//       brand: "APPLE",
//       price: "2,199 DYL",
//       image: "assets/images/ipad.png",
//       description: "Powerful tablet with M2 chip.",
//     ),
//     Product(
//       id: 6,
//       name: "Samsung Galaxy S23",
//       brand: "SAMSUNG",
//       price: "2,999 DYL",
//       image: "assets/images/galaxy.png",
//       description: "Android flagship smartphone.",
//     ),
//     Product(
//       id: 7,
//       name: "Sony WH-1000XM5",
//       brand: "SONY",
//       price: "1,099 DYL",
//       oldPrice: "1,299 DYL",
//       discount: "10%",
//       image: "assets/images/sony_headphones.png",
//       description: "Premium noise-canceling headphones.",
//     ),
//     Product(
//       id: 8,
//       name: "Dell XPS 15",
//       brand: "DELL",
//       price: "3,899 DYL",
//       image: "assets/images/dell_laptop.png",
//       description: "Professional creator laptop.",
//     ),
//   ];

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<Product> get favoriteProducts =>
//       allProducts.where((p) => p.isFavorite).toList();

//   void _toggleFavorite(int productId) {
//     setState(() {
//       final productIndex = allProducts.indexWhere((p) => p.id == productId);
//       if (productIndex != -1) {
//         allProducts[productIndex].isFavorite = !allProducts[productIndex].isFavorite;
//       }
//     });
//   }

//   void _toggleSearch() {
//     setState(() {
//       _showSearch = !_showSearch;
//       if (!_showSearch) {
//         _searchController.clear();
//         _searchResults.clear();
//       }
//     });
//   }

//   void _performSearch() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _searchResults = allProducts.where((product) {
//         return product.name.toLowerCase().contains(query) ||
//                product.brand.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   Widget _buildProductCard(Product product) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetail(
//               product: product,
//               toggleFavorite: () => _toggleFavorite(product.id),
//               isFavorite: product.isFavorite,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 184.w,
//         height: 200.h,
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 254, 254, 254),
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               offset: const Offset(0, 2),
//               blurRadius: 4,
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(10.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 7.h),
//                   Center(
//                     child: Image.asset(
//                       product.image,
//                       width: 90.w,
//                       height: 90.h,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: 7.h),
//                   Text(
//                     product.brand,
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     product.name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
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
//                         SizedBox(width: 3.w),
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
//             Positioned(
//               top: 8.h,
//               right: 8.w,
//               child: GestureDetector(
//                 onTap: () => _toggleFavorite(product.id),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 14.r,
//                   child: Icon(
//                     product.isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: product.isFavorite
//                         ? const Color(0xFF008AD2)
//                         : Colors.blue[700],
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _searchController,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Search products...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: const Color(0xFFF5F6F8),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 14.h,
//                     ),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.clear),
//                             onPressed: () {
//                               _searchController.clear();
//                               _performSearch();
//                             },
//                           )
//                         : null,
//                   ),
//                   onChanged: (value) => _performSearch(),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               GestureDetector(
//                 onTap: _toggleSearch,
//                 child: Container(
//                   width: 40.w,
//                   height: 40.h,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF008AD2),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductGrid(List<Product> products) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.75,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//       ),
//       padding: EdgeInsets.only(bottom: 90.h),
//       itemCount: products.length,
//       itemBuilder: (context, index) => _buildProductCard(products[index]),
//     );
//   }

//   Widget _buildTabContent(int tabIndex) {
//     List<Product> sortedProducts = List.from(allProducts);

//     if (tabIndex == 1) {
//       sortedProducts.sort((a, b) {
//         double priceA = double.parse(
//             a.price.replaceAll(' DYL', '').replaceAll(',', ''));
//         double priceB = double.parse(
//             b.price.replaceAll(' DYL', '').replaceAll(',', ''));
//         return priceA.compareTo(priceB);
//       });
//     } else if (tabIndex == 2) {
//       sortedProducts.sort((a, b) {
//         double priceA = double.parse(
//             a.price.replaceAll(' DYL', '').replaceAll(',', ''));
//         double priceB = double.parse(
//             b.price.replaceAll(' DYL', '').replaceAll(',', ''));
//         return priceB.compareTo(priceA);
//       });
//     }

//     return _buildProductGrid(sortedProducts);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6f8),
//       appBar: _showSearch
//           ? null
//           : AppBar(
//               backgroundColor: Colors.white,
//               elevation: 0,
//               toolbarHeight: 56.h,
//               leadingWidth: 60.w,
//               leading: Padding(
//                 padding: EdgeInsets.only(left: 18.w),
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     width: 40.w,
//                     height: 40.w,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF008AD2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 'HighTech',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.sp,
//                 ),
//               ),
//               centerTitle: true,
//               actions: [
//                 Padding(
//                   padding: EdgeInsets.only(right: 12.w),
//                   child: GestureDetector(
//                     onTap: _toggleSearch,
//                     child: Container(
//                       width: 40.w,
//                       height: 40.w,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF008AD2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.search,
//                           color: Colors.white,
//                           size: 20.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 18.w),
//                   child: GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const FilterPage(),
//                       ),
//                     ),
//                     child: Container(
//                       width: 40.w,
//                       height: 40.w,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF008AD2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.filter_list,
//                           color: Colors.white,
//                           size: 20.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               bottom: PreferredSize(
//                 preferredSize: Size.fromHeight(48.h),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 5.w),
//                   child: TabBar(
//                     controller: _tabController,
//                     labelColor: Colors.blue,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.blue,
//                     labelStyle: TextStyle(fontSize: 12.sp),
//                     tabs: const [
//                       Tab(text: 'TOP RATED'),
//                       Tab(text: 'PRICE LOW-HIGH'),
//                       Tab(text: 'PRICE HIGH-LOW'),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               if (_showSearch) _buildSearchBar(),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   child: _showSearch
//                       ? _searchController.text.isEmpty
//                           ? Center(
//                               child: Text(
//                                 'Type to search products',
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             )
//                           : _searchResults.isEmpty
//                               ? Center(
//                                   child: Text(
//                                     'No products found for "${_searchController.text}"',
//                                     style: TextStyle(
//                                       fontSize: 16.sp,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 )
//                               : _buildProductGrid(_searchResults)
//                       : TabBarView(
//                           controller: _tabController,
//                           children: List.generate(
//                             3,
//                             (index) => _buildTabContent(index),
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 35.h,
//             left: 20.w,
//             right: 20.w,
//             child: CustomBottomNavBar(
//               currentIndex: _currentNavIndex,
//               favoriteProducts: favoriteProducts,
//               toggleFavorite: _toggleFavorite,
//               context: context,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
