// // import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// // import 'package:tawasul_application/Services/api_service.dart';
// // import 'package:tawasul_application/controller/product_controller.dart';
// // import 'package:tawasul_application/model/product_model.dart';
// // import 'package:tawasul_application/view/filter.dart';
// // import 'package:tawasul_application/view/navbar.dart';
// // import 'package:tawasul_application/view/product_detail.dart';

// // class Category {
// //   final int id;
// //   final String name;
// //   final String code;

// //   Category({required this.id, required this.name, required this.code});

// //   factory Category.fromJson(Map<String, dynamic> json) {
// //     return Category(
// //       id: json['id'] ?? 0,
// //       name: json['name'] ?? 'No Name',
// //       code: json['code'] ?? '',
// //     );
// //   }
// // }

// // class HighTech extends StatefulWidget {
// //   const HighTech({super.key});

// //   @override
// //   State<HighTech> createState() => _HighTechState();
// // }

// // class _HighTechState extends State<HighTech> with TickerProviderStateMixin {
// //   int _currentNavIndex = 0;
// //   late TabController _tabController;
// //   bool _showSearch = false;
// //   final TextEditingController _searchController = TextEditingController();
// //   List<Product> _searchResults = [];

// //   List<Category> _categories = [];
// //   bool _isLoadingCategories = true;
// //   String _selectedCategoryCode = '';
// //   bool _isLoadingProducts = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //     _fetchCategories();

// //     // Initialize products after a slight delay to ensure controller is ready
// //     SchedulerBinding.instance.addPostFrameCallback((_) {
// //       _initializeProducts();
// //     });
// //   }

// //   void _initializeProducts() {
// //     final productController = Provider.of<ProductController>(
// //       context,
// //       listen: false,
// //     );

// //     // Only fetch if we don't have products yet
// //     if (productController.allProducts.isEmpty) {
// //       if (_categories.isNotEmpty) {
// //         _fetchProductsByCategory(_categories[0].code);
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   void _toggleSearch() {
// //     setState(() {
// //       _showSearch = !_showSearch;
// //       if (!_showSearch) {
// //         _searchController.clear();
// //         _searchResults.clear();
// //       }
// //     });
// //   }

// //   void _performSearch(BuildContext context) {
// //     final query = _searchController.text.toLowerCase();
// //     final productController = Provider.of<ProductController>(
// //       context,
// //       listen: false,
// //     );

// //     setState(() {
// //       _searchResults =
// //           productController.allProducts.where((product) {
// //             return product.name.toLowerCase().contains(query) ||
// //                 product.brand.toLowerCase().contains(query);
// //           }).toList();
// //     });
// //   }

// //   Future<void> _fetchCategories() async {
// //     setState(() => _isLoadingCategories = true);
// //     try {
// //       final fetchedCategories =
// //           (await ApiService.getCategories())
// //               .map((json) => Category.fromJson(json))
// //               .toList();

// //       setState(() {
// //         _categories = fetchedCategories;
// //         _isLoadingCategories = false;
// //         if (_categories.isNotEmpty) {
// //           _selectedCategoryCode = _categories[0].code;
// //         }
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _isLoadingCategories = false;
// //       });
// //       print("Error fetching categories: $e");
// //     }
// //   }

// //   Future<void> _fetchProductsByCategory(String categoryCode) async {
// //     if (_isLoadingProducts) return;

// //     setState(() => _isLoadingProducts = true);

// //     try {
// //       final productController = Provider.of<ProductController>(
// //         context,
// //         listen: false,
// //       );

// //       final products = await ApiService.getCategoryProducts(
// //         categoryCode: categoryCode,
// //         shopId: '4',
// //       );

// //       productController.setAllProducts(products);

// //       setState(() {
// //         _selectedCategoryCode = categoryCode;
// //         _isLoadingProducts = false;
// //       });
// //     } catch (e) {
// //       setState(() => _isLoadingProducts = false);
// //       print("Error fetching products: $e");
// //     }
// //   }

// //   Widget _buildCategoriesBar() {
// //     if (_isLoadingCategories) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     return SizedBox(
// //       height: 50.h,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         itemCount: _categories.length,
// //         itemBuilder: (context, index) {
// //           final category = _categories[index];
// //           final isSelected = category.code == _selectedCategoryCode;
// //           return Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 8.w),
// //             child: ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor:
// //                     isSelected ? const Color(0xFF008AD2) : Colors.grey[300],
// //               ),
// //               onPressed: () {
// //                 if (!isSelected) {
// //                   _fetchProductsByCategory(category.code);
// //                 }
// //               },
// //               child: Text(
// //                 category.name,
// //                 style: TextStyle(
// //                   color: isSelected ? Colors.white : Colors.black,
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildProductCard(BuildContext context, Product product) {
// //     final productController = Provider.of<ProductController>(
// //       context,
// //       listen: false,
// //     );

// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder:
// //                 (context) => ProductDetail(
// //                   product: product,
// //                   toggleFavorite:
// //                       () => productController.toggleFavorite(product.id),
// //                   isFavorite: product.isFavorite,
// //                 ),
// //           ),
// //         );
// //       },
// //       child: Container(
// //         width: 200.w,
// //         height: 235.h,
// //         margin: EdgeInsets.all(8.w),
// //         decoration: BoxDecoration(
// //           color: const Color.fromARGB(255, 254, 254, 254),
// //           borderRadius: BorderRadius.circular(16.r),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey,
// //               offset: const Offset(0, 2),
// //               blurRadius: 1,
// //               spreadRadius: 0,
// //             ),
// //           ],
// //         ),
// //         child: Stack(
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.all(10.w),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   SizedBox(height: 4.h),
// //                   Center(
// //                     child:
// //                         product.image.isNotEmpty
// //                             ? Flexible(
// //                               child: Image.network(
// //                                 product.image,
// //                                 width: 90.w,
// //                                 height: 90.h,
// //                                 fit: BoxFit.contain,
// //                                 errorBuilder:
// //                                     (context, error, stackTrace) => Icon(
// //                                       Icons.broken_image,
// //                                       size: 50.sp,
// //                                       color: Colors.grey,
// //                                     ),
// //                               ),
// //                             )
// //                             : Icon(
// //                               Icons.image_not_supported,
// //                               size: 50.sp,
// //                               color: Colors.grey,
// //                             ),
// //                   ),
// //                   SizedBox(height: 5.h),
// //                   Text(
// //                     product.brand,
// //                     style: TextStyle(fontSize: 10.sp, color: Colors.grey),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: 1.h),
// //                   Text(
// //                     product.name,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 14.sp,
// //                     ),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: 2.h),
// //                   Row(
// //                     children: [
// //                       Flexible(
// //                         child: Text(
// //                           product.price,
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: const Color(0xff1264a3),
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ),
// //                       if (product.oldPrice != null) ...[
// //                         SizedBox(width: 3.w),
// //                         Flexible(
// //                           child: Text(
// //                             product.oldPrice!,
// //                             style: TextStyle(
// //                               decoration: TextDecoration.lineThrough,
// //                               fontSize: 12.sp,
// //                               color: Colors.grey,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Positioned(
// //               top: 8.h,
// //               right: 8.w,
// //               child: GestureDetector(
// //                 onTap: () => productController.toggleFavorite(product.id),
// //                 child: CircleAvatar(
// //                   backgroundColor: Colors.white,
// //                   radius: 14.r,
// //                   child: Icon(
// //                     product.isFavorite ? Icons.favorite : Icons.favorite_border,
// //                     color:
// //                         product.isFavorite
// //                             ? const Color(0xFF008AD2)
// //                             : Colors.blue[700],
// //                     size: 20.sp,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSearchBar(BuildContext context) {
// //     return Container(
// //       color: Colors.white,
// //       padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: TextField(
// //                   controller: _searchController,
// //                   autofocus: true,
// //                   decoration: InputDecoration(
// //                     hintText: 'Search products...',
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12.r),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     filled: true,
// //                     fillColor: const Color(0xFFF5F6F8),
// //                     contentPadding: EdgeInsets.symmetric(
// //                       horizontal: 16.w,
// //                       vertical: 14.h,
// //                     ),
// //                     suffixIcon:
// //                         _searchController.text.isNotEmpty
// //                             ? IconButton(
// //                               icon: const Icon(Icons.clear),
// //                               onPressed: () {
// //                                 _searchController.clear();
// //                                 _performSearch(context);
// //                               },
// //                             )
// //                             : null,
// //                   ),
// //                   onChanged: (value) {
// //                     if (value.isEmpty) {
// //                       _performSearch(context);
// //                     }
// //                   },
// //                   onSubmitted: (_) => _performSearch(context),
// //                 ),
// //               ),
// //               SizedBox(width: 12.w),
// //               GestureDetector(
// //                 onTap: _toggleSearch,
// //                 child: Container(
// //                   width: 40.w,
// //                   height: 40.h,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF008AD2),
// //                     borderRadius: BorderRadius.circular(12.r),
// //                   ),
// //                   child: Icon(Icons.close, color: Colors.white),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildProductGrid(BuildContext context, List<Product> products) {
// //     if (_isLoadingProducts) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     if (products.isEmpty) {
// //       return Center(
// //         child: Text(
// //           'No products found',
// //           style: TextStyle(fontSize: 16.sp, color: Colors.grey),
// //         ),
// //       );
// //     }

// //     return GridView.count(
// //       crossAxisCount: 2,
// //       childAspectRatio: 0.75,
// //       padding: EdgeInsets.only(bottom: 90.h),
// //       children:
// //           products
// //               .map((product) => _buildProductCard(context, product))
// //               .toList(),
// //     );
// //   }

// //   Widget _buildTabContent(BuildContext context, int tabIndex) {
// //     final productController = Provider.of<ProductController>(context);
// //     List<Product> sortedProducts = List.from(productController.allProducts);

// //     if (tabIndex == 1) {
// //       sortedProducts.sort((a, b) {
// //         double priceA = double.parse(
// //           a.price.replaceAll(' DYL', '').replaceAll(',', ''),
// //         );
// //         double priceB = double.parse(
// //           b.price.replaceAll(' DYL', '').replaceAll(',', ''),
// //         );
// //         return priceA.compareTo(priceB);
// //       });
// //     } else if (tabIndex == 2) {
// //       sortedProducts.sort((a, b) {
// //         double priceA = double.parse(
// //           a.price.replaceAll(' DYL', '').replaceAll(',', ''),
// //         );
// //         double priceB = double.parse(
// //           b.price.replaceAll(' DYL', '').replaceAll(',', ''),
// //         );
// //         return priceB.compareTo(priceA);
// //       });
// //     }

// //     return _buildProductGrid(context, sortedProducts);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xfff5f6f8),
// //       appBar:
// //           _showSearch
// //               ? null
// //               : AppBar(
// //                 backgroundColor: Colors.white,
// //                 elevation: 0,
// //                 toolbarHeight: 56.h,
// //                 leadingWidth: 60.w,
// //                 leading: Padding(
// //                   padding: EdgeInsets.only(left: 18.w),
// //                   child: GestureDetector(
// //                     onTap: () => Navigator.pop(context),
// //                     child: Container(
// //                       width: 40.w,
// //                       height: 40.w,
// //                       decoration: const BoxDecoration(
// //                         color: Color(0xFF008AD2),
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Center(
// //                         child: Icon(
// //                           Icons.arrow_back_ios,
// //                           color: Colors.white,
// //                           size: 20.sp,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 title: Text(
// //                   'HighTech',
// //                   style: TextStyle(
// //                     color: Colors.black,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 20.sp,
// //                   ),
// //                 ),
// //                 centerTitle: true,
// //                 actions: [
// //                   Padding(
// //                     padding: EdgeInsets.only(right: 12.w),
// //                     child: GestureDetector(
// //                       onTap: _toggleSearch,
// //                       child: Container(
// //                         width: 40.w,
// //                         height: 40.w,
// //                         decoration: const BoxDecoration(
// //                           color: Color(0xFF008AD2),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Center(
// //                           child: Icon(
// //                             Icons.search,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: EdgeInsets.only(right: 18.w),
// //                     child: GestureDetector(
// //                       onTap:
// //                           () => Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const FilterPage(),
// //                             ),
// //                           ),
// //                       child: Container(
// //                         width: 40.w,
// //                         height: 40.w,
// //                         decoration: const BoxDecoration(
// //                           color: Color(0xFF008AD2),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Center(
// //                           child: Icon(
// //                             Icons.filter_list,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //                 bottom: PreferredSize(
// //                   preferredSize: Size.fromHeight(48.h),
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 5.w),
// //                     child: TabBar(
// //                       controller: _tabController,
// //                       labelColor: Colors.blue,
// //                       unselectedLabelColor: Colors.grey,
// //                       indicatorColor: Colors.blue,
// //                       labelStyle: TextStyle(fontSize: 12.sp),
// //                       tabs: const [
// //                         Tab(text: 'TOP RATED'),
// //                         Tab(text: 'PRICE LOW-HIGH'),
// //                         Tab(text: 'PRICE HIGH-LOW'),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //       body: Stack(
// //         children: [
// //           Column(
// //             children: [
// //               if (_showSearch) _buildSearchBar(context),
// //               _buildCategoriesBar(),
// //               Expanded(
// //                 child: Container(
// //                   padding: const EdgeInsets.all(15.0),
// //                   child:
// //                       _showSearch
// //                           ? _searchController.text.isEmpty
// //                               ? Center(
// //                                 child: Text(
// //                                   'Type to search products',
// //                                   style: TextStyle(
// //                                     fontSize: 16.sp,
// //                                     color: Colors.grey,
// //                                   ),
// //                                 ),
// //                               )
// //                               : _searchResults.isEmpty
// //                               ? Center(
// //                                 child: Text(
// //                                   'No products found for "${_searchController.text}"',
// //                                   style: TextStyle(
// //                                     fontSize: 16.sp,
// //                                     color: Colors.grey,
// //                                   ),
// //                                 ),
// //                               )
// //                               : _buildProductGrid(context, _searchResults)
// //                           : TabBarView(
// //                             controller: _tabController,
// //                             children: List.generate(
// //                               3,
// //                               (index) => _buildTabContent(context, index),
// //                             ),
// //                           ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Positioned(
// //             bottom: 35.h,
// //             left: 20.w,
// //             right: 20.w,
// //             child: CustomBottomNavBar(
// //               currentIndex: _currentNavIndex,
// //               context: context,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/category_model.dart';
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

//   List<Category> _categories = [];
//   bool _isLoadingCategories = true;
//   String _selectedCategoryCode = '';
//   bool _isLoadingProducts = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _fetchCategories(); // fetch categories directly
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _tabController.dispose();
//     super.dispose();
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

//   void _performSearch(BuildContext context) {
//     final query = _searchController.text.toLowerCase();
//     final productController = Provider.of<ProductController>(
//       context,
//       listen: false,
//     );

//     setState(() {
//       _searchResults =
//           productController.allProducts.where((product) {
//             return product.name.toLowerCase().contains(query) ||
//                 product.brand.toLowerCase().contains(query);
//           }).toList();
//     });
//   }

//   // In HighTech.dart - Replace the _fetchCategories method
//   Future<void> _fetchCategories() async {
//     setState(() => _isLoadingCategories = true);
//     try {
//       // Get the HighTech category code directly from API
//       final highTechCode = await ApiService.getCategoryCodeByName('HighTech');

//       if (highTechCode.isNotEmpty) {
//         setState(() {
//           _selectedCategoryCode = highTechCode;
//           _isLoadingCategories = false;
//           _fetchProductsByCategory(highTechCode);
//         });
//       } else {
//         setState(() {
//           _isLoadingCategories = false;
//           print("HighTech category not found");
//         });
//       }
//     } catch (e) {
//       setState(() => _isLoadingCategories = false);
//       print("Error fetching HighTech category: $e");
//     }
//   }

//   Future<void> _fetchProductsByCategory(String categoryCode) async {
//     if (_isLoadingProducts) return;

//     setState(() => _isLoadingProducts = true);
//     try {
//       final productController = Provider.of<ProductController>(
//         context,
//         listen: false,
//       );

//       final products = await ApiService.getCategoryProducts(
//         categoryCode: categoryCode,
//         shopId: '4',
//       );

//       productController.setAllProducts(products);

//       setState(() {
//         _selectedCategoryCode = categoryCode;
//         _isLoadingProducts = false;
//       });
//     } catch (e) {
//       setState(() => _isLoadingProducts = false);
//       print("Error fetching products: $e");
//     }
//   }

//   // Widget _buildCategoriesBar() {
//   //   if (_isLoadingCategories) {
//   //     return const Center(child: CircularProgressIndicator());
//   //   }

//   //   return SizedBox(
//   //     height: 50.h,
//   //     child: ListView.builder(
//   //       scrollDirection: Axis.horizontal,
//   //       itemCount: _categories.length,
//   //       itemBuilder: (context, index) {
//   //         final category = _categories[index];
//   //         final isSelected = category.code == _selectedCategoryCode;
//   //         return Padding(
//   //           padding: EdgeInsets.symmetric(horizontal: 8.w),
//   //           child: ElevatedButton(
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor:
//   //                   isSelected ? const Color(0xFF008AD2) : Colors.grey[300],
//   //             ),
//   //             onPressed: () {
//   //               if (!isSelected) {
//   //                 _fetchProductsByCategory(category.code);
//   //               }
//   //             },
//   //             child: Text(
//   //               category.name,
//   //               style: TextStyle(
//   //                 color: isSelected ? Colors.white : Colors.black,
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

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
//                   product: product,
//                   toggleFavorite:
//                       () => productController.toggleFavorite(product.id),
//                   isFavorite: product.isFavorite,
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         width: 200.w,
//         height: 235.h,
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: const [
//             BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 1),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(10.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child:
//                         product.image.isNotEmpty
//                             ? Image.network(
//                               product.image,
//                               width: 90.w,
//                               height: 90.h,
//                               fit: BoxFit.contain,
//                               errorBuilder:
//                                   (context, error, stackTrace) => Icon(
//                                     Icons.broken_image,
//                                     size: 50.sp,
//                                     color: Colors.grey,
//                                   ),
//                             )
//                             : Icon(
//                               Icons.image_not_supported,
//                               size: 50.sp,
//                               color: Colors.grey,
//                             ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Text(
//                     product.brand,
//                     style: TextStyle(fontSize: 10.sp, color: Colors.grey),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     product.name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           product.price,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xff1264a3),
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       if (product.oldPrice != null) ...[
//                         SizedBox(width: 3.w),
//                         Flexible(
//                           child: Text(
//                             product.oldPrice!,
//                             style: TextStyle(
//                               decoration: TextDecoration.lineThrough,
//                               fontSize: 12.sp,
//                               color: Colors.grey,
//                             ),
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
//                 onTap: () => productController.toggleFavorite(product.id),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 14.r,
//                   child: Icon(
//                     product.isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color:
//                         product.isFavorite
//                             ? const Color(0xFF008AD2)
//                             : Colors.blue[700],
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

//   Widget _buildSearchBar(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               autofocus: true,
//               decoration: InputDecoration(
//                 hintText: 'Search products...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xFFF5F6F8),
//                 suffixIcon:
//                     _searchController.text.isNotEmpty
//                         ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             _searchController.clear();
//                             _performSearch(context);
//                           },
//                         )
//                         : null,
//               ),
//               onChanged: (_) => _performSearch(context),
//             ),
//           ),
//           SizedBox(width: 12.w),
//           GestureDetector(
//             onTap: _toggleSearch,
//             child: Container(
//               width: 40.w,
//               height: 40.h,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF008AD2),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: const Icon(Icons.close, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductGrid(BuildContext context, List<Product> products) {
//     if (_isLoadingProducts) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (products.isEmpty) {
//       return Center(
//         child: Text(
//           'No products found',
//           style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//         ),
//       );
//     }

//     return GridView.count(
//       crossAxisCount: 2,
//       childAspectRatio: 0.75,
//       padding: EdgeInsets.only(bottom: 90.h),
//       children: products.map((p) => _buildProductCard(context, p)).toList(),
//     );
//   }

//   Widget _buildTabContent(BuildContext context, int tabIndex) {
//     final productController = Provider.of<ProductController>(context);
//     List<Product> sortedProducts = List.from(productController.allProducts);

//     if (tabIndex == 1) {
//       sortedProducts.sort(
//         (a, b) => double.parse(
//           a.price.replaceAll(RegExp(r'[^0-9.]'), ''),
//         ).compareTo(double.parse(b.price.replaceAll(RegExp(r'[^0-9.]'), ''))),
//       );
//     } else if (tabIndex == 2) {
//       sortedProducts.sort(
//         (a, b) => double.parse(
//           b.price.replaceAll(RegExp(r'[^0-9.]'), ''),
//         ).compareTo(double.parse(a.price.replaceAll(RegExp(r'[^0-9.]'), ''))),
//       );
//     }

//     return _buildProductGrid(context, sortedProducts);
//   }

//   // In all category files, update the build method to remove the categories bar
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6f8),
//       appBar:
//           _showSearch
//               ? null
//               : AppBar(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 toolbarHeight: 56.h,
//                 leadingWidth: 60.w,
//                 leading: Padding(
//                   padding: EdgeInsets.only(left: 18.w),
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       width: 40.w,
//                       height: 40.w,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF008AD2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                           size: 20.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   'HighTech', // Change this for each page
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.sp,
//                   ),
//                 ),
//                 centerTitle: true,
//                 actions: [
//                   Padding(
//                     padding: EdgeInsets.only(right: 12.w),
//                     child: GestureDetector(
//                       onTap: _toggleSearch,
//                       child: Container(
//                         width: 40.w,
//                         height: 40.w,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF008AD2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.search,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 18.w),
//                     child: GestureDetector(
//                       onTap:
//                           () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const FilterPage(),
//                             ),
//                           ),
//                       child: Container(
//                         width: 40.w,
//                         height: 40.w,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF008AD2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.filter_list,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 bottom: PreferredSize(
//                   preferredSize: Size.fromHeight(48.h),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 5.w),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelColor: Colors.blue,
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: Colors.blue,
//                       labelStyle: TextStyle(fontSize: 12.sp),
//                       tabs: const [
//                         Tab(text: 'TOP RATED'),
//                         Tab(text: 'PRICE LOW-HIGH'),
//                         Tab(text: 'PRICE HIGH-LOW'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               if (_showSearch) _buildSearchBar(context),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(15.0),
//                   child:
//                       _showSearch
//                           ? _searchController.text.isEmpty
//                               ? Center(
//                                 child: Text(
//                                   'Type to search products',
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               )
//                               : _searchResults.isEmpty
//                               ? Center(
//                                 child: Text(
//                                   'No products found for "${_searchController.text}"',
//                                   style: TextStyle(
//                                     fontSize: 16.sp,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               )
//                               : _buildProductGrid(context, _searchResults)
//                           : TabBarView(
//                             controller: _tabController,
//                             children: List.generate(
//                               3,
//                               (index) => _buildTabContent(context, index),
//                             ),
//                           ),
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
//               context: context,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// In HighTech.dart - Replace the entire file
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Services/api_service.dart';
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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ApiService.debugApiResponse().then((_) {
      _loadHighTechProducts();
    });
  }

  // In HighTech.dart - Update the _loadHighTechProducts method
  Future<void> _loadHighTechProducts() async {
    setState(() => _isLoading = true);

    try {
      print("🔄 Loading HighTech products...");

      // First try to get the code from API
      final highTechCode = await ApiService.getCategoryCodeByName('HighTech');

      // If API fails, use hardcoded code
      String finalCode = highTechCode;
      if (finalCode.isEmpty) {
        finalCode = ApiService.getHardcodedCategoryCode('HighTech');
        print("⚠️ Using hardcoded category code: $finalCode");
      }

      print("✅ Using category code: '$finalCode'");

      if (finalCode.isNotEmpty) {
        // Try to get products from category structure
        final products = await ApiService.getProductsFromCategory('HighTech');

        if (products.isEmpty) {
          print(
            "⚠️ No products found in category structure, trying alternative...",
          );

          // If no products in category structure, try getCategoryProducts as fallback
          final fallbackProducts = await ApiService.getCategoryProducts(
            categoryCode: finalCode,
            shopId: '4',
          );

          _updateProducts(fallbackProducts);
        } else {
          _updateProducts(products);
        }
      } else {
        print("❌ Could not find HighTech category code");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("❌ Error loading HighTech products: $e");
      setState(() => _isLoading = false);
    }
  }

  void _updateProducts(List<Product> products) {
    // Update the product controller
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );
    productController.setCategoryProducts(products);

    print("✅ Loaded ${products.length} HighTech products");

    // Debug: Print first few product names
    for (var i = 0; i < (products.length > 3 ? 3 : products.length); i++) {
      print("Product ${i + 1}: ${products[i].name}");
    }

    setState(() => _isLoading = false);
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
          productController.currentCategoryProducts.where((product) {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 1),
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
                  SizedBox(height: 7.h),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
    if (_isLoading) {
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
              'No HighTech products found',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadHighTechProducts,
              child: Text('Retry'),
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
    final productController = Provider.of<ProductController>(context);
    List<Product> sortedProducts = List.from(
      productController.currentCategoryProducts,
    );

    if (tabIndex == 1) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        return priceA.compareTo(priceB);
      });
    } else if (tabIndex == 2) {
      sortedProducts.sort((a, b) {
        double priceA = double.parse(
          a.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        double priceB = double.parse(
          b.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        return priceB.compareTo(priceA);
      });
    }

    return _buildProductGrid(context, sortedProducts);
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

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
                  padding: const EdgeInsets.all(15.0),
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
