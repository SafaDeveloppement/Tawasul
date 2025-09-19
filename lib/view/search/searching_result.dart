

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class SearchingResult extends StatefulWidget {
//   final String searchQuery;

//   const SearchingResult({Key? key, required this.searchQuery})
//     : super(key: key);

//   @override
//   State<SearchingResult> createState() => _SearchingResultState();
// }

// class _SearchingResultState extends State<SearchingResult> {
//   late TextEditingController _searchController;
//   List<Product> _allProducts = [];
//   List<Product> _filteredProducts = [];
//   bool _isLoading = true;
//   bool _hasSearched = false;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController(text: widget.searchQuery);
//     _loadProductsAndSearch();
//   }

//   Future<void> _loadProductsAndSearch() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Load all products from the main category (using code '10' as in your home page)
//       _allProducts = await ApiService.getCategoryProducts(
//         categoryCode: '10',
//         shopId: '4',
//       );

//       // Filter products based on search query
//       _filterProducts(widget.searchQuery);

//       setState(() {
//         _isLoading = false;
//         _hasSearched = true;
//       });
//     } catch (e) {
//       print("Error loading products: $e");
//       setState(() {
//         _isLoading = false;
//         _hasSearched = true;
//       });
//     }
//   }

//   void _filterProducts(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         _filteredProducts = _allProducts;
//       });
//       return;
//     }

//     final lowerCaseQuery = query.toLowerCase();
//     setState(() {
//       _filteredProducts =
//           _allProducts.where((product) {
//             return product.name.toLowerCase().contains(lowerCaseQuery) ||
//                 product.brand.toLowerCase().contains(lowerCaseQuery) ||
//                 product.description.toLowerCase().contains(lowerCaseQuery);
//           }).toList();
//     });
//   }

//   void _performSearch(String query) {
//     _filterProducts(query);
//     setState(() {
//       _hasSearched = true;
//     });
//   }

//   Widget _buildProductItem(Product product) {
//     final t = AppLocalizations.of(context)!;
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => ProductDetail(
//                   productReference: product.reference,
//                   shopId: '4',
//                   toggleFavorite: () => {},
//                   isFavorite: false,
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Container(
//               width: 100.w,
//               height: 100.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12.r),
//                   bottomLeft: Radius.circular(12.r),
//                 ),
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     product.image.isNotEmpty
//                         ? product.image
//                         : 'https://via.placeholder.com/100',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.w),
//             // Product Details
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.name,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       product.brand,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Row(
//                       children: [
//                         Text(
//                           '${product.price} ${t.lyd}',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF0984E3),
//                           ),
//                         ),
//                         if (product.oldPrice != null &&
//                             product.oldPrice != product.price)
//                           Padding(
//                             padding: EdgeInsets.only(left: 8.w),
//                             child: Text(
//                               '${product.oldPrice} ${t.lyd}',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.grey,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     if (product.discount != null)
//                       Padding(
//                         padding: EdgeInsets.only(top: 4.h),
//                         child: Text(
//                           product.discount!,
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Container(
//           height: 40.h,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: const Color(0xFFC2C2C2)),
//           ),
//           child: Row(
//             children: [
//               SizedBox(width: 18.w),
//               Expanded(
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: t.searchProducts,
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(fontSize: 14.sp),
//                   ),
//                   onSubmitted: _performSearch,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () => _performSearch(_searchController.text),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (_hasSearched)
//                       Text(
//                         _filteredProducts.isEmpty
//                             ? '${t.noProductsFoundFor} "${_searchController.text}"'
//                             : '${_filteredProducts.length} ${t.resultsFoundFor} "${_searchController.text}"',
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     SizedBox(height: 16.h),
//                     Expanded(
//                       child:
//                           _filteredProducts.isEmpty && _hasSearched
//                               ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.search_off,
//                                       size: 64.sp,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(height: 16.h),
//                                     Text(
//                                       t.noProductsFound,
//                                       style: TextStyle(
//                                         fontSize: 18.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8.h),
//                                     Text(
//                                       t.tryDifferentKeywords,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 14.sp,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                               : ListView.builder(
//                                 itemCount: _filteredProducts.length,
//                                 itemBuilder: (context, index) {
//                                   return _buildProductItem(
//                                     _filteredProducts[index],
//                                   );
//                                 },
//                               ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchingResult extends StatefulWidget {
  final String searchQuery;

  const SearchingResult({Key? key, required this.searchQuery})
    : super(key: key);

  @override
  State<SearchingResult> createState() => _SearchingResultState();
}

class _SearchingResultState extends State<SearchingResult> {
  late TextEditingController _searchController;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _hasSearched = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _loadProductsAndSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProductsAndSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all products from the main category (using code '10' as in your home page)
      _allProducts = await ApiService.getCategoryProducts(
        categoryCode: '10',
        shopId: '4',
      );

      // Filter products based on search query
      _filterProducts(widget.searchQuery);

      setState(() {
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (e) {
      print("Error loading products: $e");
      setState(() {
        _isLoading = false;
        _hasSearched = true;
      });
    }
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _allProducts;
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            return product.name.toLowerCase().contains(lowerCaseQuery) ||
                product.brand.toLowerCase().contains(lowerCaseQuery) ||
                product.description.toLowerCase().contains(lowerCaseQuery);
          }).toList();
    });
  }

  void _performSearch(String query) {
    // Cancel any previous debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // Set a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterProducts(query);
      setState(() {
        _hasSearched = true;
      });
    });
  }

  void _onSearchChanged(String query) {
    _performSearch(query);
  }

  Widget _buildProductItem(Product product) {
    final t = AppLocalizations.of(context)!;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFC2C2C2)),
          ),
          child: Row(
            children: [
              SizedBox(width: 18.w),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.searchProducts,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14.sp),
                  ),
                  onChanged: _onSearchChanged, // Add this line
                  onSubmitted: _performSearch,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _performSearch(_searchController.text),
              ),
            ],
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasSearched)
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
                    Expanded(
                      child:
                          _filteredProducts.isEmpty && _hasSearched
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
                              : ListView.builder(
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return _buildProductItem(
                                    _filteredProducts[index],
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}