// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/controller/product_controller.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/filter.dart';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:tawasul_application/view/product_detail.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawasul_application/view/shopping_cart.dart';

// class BundelsPage extends StatefulWidget {
//   const BundelsPage({super.key});

//   @override
//   State<BundelsPage> createState() => _BundelsPageState();
// }

// class _BundelsPageState extends State<BundelsPage>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   bool _showSearch = false;
//   List<Product> _bundelsProducts = [];
//   bool _isLoading = true;
//   String _errorMessage = '';

//   // API Configuration
//   final String _apiBaseUrl = "http://t-api.dotit-corp.com/api";
//   final String _bundelsEndpoint = "/public/getCategoryProducts";

//   final _storage = const FlutterSecureStorage();
//   String? _token;

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     _loadTokenAndFetch();
//     super.initState();
//   }

//   Future<void> _loadTokenAndFetch() async {
//     String? storedToken = await _storage.read(key: 'auth_token');
//     setState(() {
//       _token = storedToken;
//     });

//     if (_token != null && _token!.isNotEmpty) {
//       _fetchbundelsProducts();
//     } else {
//       setState(() {
//         _errorMessage = 'No token found. Please log in.';
//         _isLoading = false;
//       });
//     }
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

//   Future<void> _fetchbundelsProducts({int retryCount = 0}) async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final response = await http
//           .get(
//             Uri.parse('$_apiBaseUrl$_bundelsEndpoint?code=10&id-shop=4'),
//             headers: {
//               'Authorization': 'Bearer $_token',
//               'Content-Type': 'application/json',
//             },
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['message'] == 'success') {
//           // Correctly access the products array
//           final products = responseData['response']['products'] as List;

//           setState(() {
//             _bundelsProducts =
//                 products.map((productJson) {
//                   return Product(
//                     id: productJson['id'] ?? 0,
//                     name: productJson['name'] ?? '',
//                     brand: productJson['manufacturer_name'] ?? '',
//                     price: productJson['price']?.toString() ?? '0',
//                     image: productJson['image'] ?? '',
//                     description: productJson['description'] ?? '',
//                     oldPrice: productJson['price_after_reduction']?.toString(),
//                     discount: productJson['discount']?.toString(),
//                   );
//                 }).toList();

//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = 'API Error: ${responseData['message']}';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to load: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } on http.ClientException {
//       if (retryCount < 3) {
//         await Future.delayed(const Duration(seconds: 2));
//         return _fetchbundelsProducts(retryCount: retryCount + 1);
//       } else {
//         setState(() {
//           _errorMessage =
//               'Network error: Please check your internet connection and try again.';
//           _isLoading = false;
//         });
//       }
//     } on TimeoutException {
//       if (retryCount < 3) {
//         await Future.delayed(const Duration(seconds: 2));
//         return _fetchbundelsProducts(retryCount: retryCount + 1);
//       } else {
//         setState(() {
//           _errorMessage =
//               'Request timeout: Please check your internet connection.';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }

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
//         width: 184.w,
//         height: 200.h,
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 254, 254, 254),
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
//                   SizedBox(height: 7.h),
//                   Center(
//                     child: Container(
//                       width: 90.w,
//                       height: 90.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.r),
//                         color: Colors.grey[100],
//                       ),
//                       child:
//                           product.image.isNotEmpty
//                               ? Image.network(
//                                 product.image.startsWith('http')
//                                     ? product.image
//                                     : 'https://tawasul-shop.com/img/p/${product.image}.jpg',
//                                 fit: BoxFit.contain,
//                                 loadingBuilder: (
//                                   context,
//                                   child,
//                                   loadingProgress,
//                                 ) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       value:
//                                           loadingProgress.expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes!
//                                               : null,
//                                     ),
//                                   );
//                                 },
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Icon(
//                                     Icons.image_not_supported,
//                                     size: 40.w,
//                                     color: Colors.grey[400],
//                                   );
//                                 },
//                               )
//                               : Icon(
//                                 Icons.image_not_supported,
//                                 size: 40.w,
//                                 color: Colors.grey[400],
//                               ),
//                     ),
//                   ),
//                   SizedBox(height: 7.h),
//                   Text(
//                     product.brand,
//                     style: TextStyle(fontSize: 10.sp, color: Colors.grey),
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
//                   Text(
//                     '${product.price} DYL',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xff1264a3),
//                     ),
//                   ),
//                   if (product.discount != null &&
//                       product.discount!.isNotEmpty &&
//                       product.discount != '0')
//                     Container(
//                       margin: EdgeInsets.only(top: 4.h),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 8.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(4.r),
//                       ),
//                       child: Text(
//                         '${product.discount}% OFF',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductGrid(BuildContext context, List<Product> products) {
//     return GridView.count(
//       crossAxisCount: 2,
//       childAspectRatio: 0.80,
//       padding: EdgeInsets.only(bottom: 90.h),
//       children:
//           products
//               .map((product) => _buildProductCard(context, product))
//               .toList(),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _errorMessage,
//             style: TextStyle(fontSize: 16.sp, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20.h),
//           ElevatedButton(
//             onPressed: () => _fetchbundelsProducts(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF008AD2),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
//             ),
//             child: Text(
//               'Retry',
//               style: TextStyle(color: Colors.white, fontSize: 16.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabContent(BuildContext context, int tabIndex) {
//     List<Product> sortedProducts = List.from(_bundelsProducts);

//     if (tabIndex == 1) {
//       sortedProducts.sort(
//         (a, b) => double.parse(a.price).compareTo(double.parse(b.price)),
//       );
//     } else if (tabIndex == 2) {
//       sortedProducts.sort(
//         (a, b) => double.parse(b.price).compareTo(double.parse(a.price)),
//       );
//     }

//     return _buildProductGrid(context, sortedProducts);
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(
//         kToolbarHeight + 48.h,
//       ), // AppBar + TabBar height
//       child: Container(
//         padding: EdgeInsets.only(top: 15.h),
//         color: Colors.white,
//         child: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leadingWidth: 50.w,
//           leading: Padding(
//             padding: EdgeInsets.only(left: 12.w),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//               child: Container(
//                 width: 35.w,
//                 height: 35.w,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF008AD2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 18.sp,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           title: Text(
//             'Best offer',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//               fontSize: 18.sp,
//             ),
//           ),
//           actions: [
//             GestureDetector(
//               onTap: () => _showFilterDialog(context),
//               child: Container(
//                 width: 36.w,
//                 height: 34.h,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0984E3),
//                   borderRadius: BorderRadius.circular(50.r),
//                 ),
//                 child: Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.sliders,
//                     color: Colors.white,
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 10.w),
//             GestureDetector(
//               onTap:
//                   () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ShoppingCart()),
//                   ),
//               child: Container(
//                 width: 36.w,
//                 height: 34.h,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0984E3),
//                   borderRadius: BorderRadius.circular(24.r),
//                 ),
//                 child: Icon(
//                   Icons.shopping_cart,
//                   color: Colors.white,
//                   size: 22.sp,
//                 ),
//               ),
//             ),
//             SizedBox(width: 10.w),
//           ],
//           centerTitle: true,
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(48.h),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.w),
//               child: TabBar(
//                 controller: _tabController,
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.blue,
//                 labelStyle: TextStyle(fontSize: 12.sp),
//                 tabs: const [
//                   Tab(text: 'TOP RATED'),
//                   Tab(text: 'PRICE LOW-HIGH'),
//                   Tab(text: 'PRICE HIGH-LOW'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6f8),
//       appBar: _showSearch ? null : _buildAppBar(),
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : _errorMessage.isNotEmpty
//               ? _buildErrorWidget()
//               : TabBarView(
//                 controller: _tabController,
//                 children: List.generate(
//                   3,
//                   (index) => _buildTabContent(context, index),
//                 ),
//               ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/filter.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:tawasul_application/view/shopping_cart.dart';
// Add localization import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BundelsPage extends StatefulWidget {
  const BundelsPage({super.key});

  @override
  State<BundelsPage> createState() => _BundelsPageState();
}

class _BundelsPageState extends State<BundelsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showSearch = false;
  List<Product> _bundelsProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // API Configuration
  final String _apiBaseUrl = "http://t-api.dotit-corp.com/api";
  final String _bundelsEndpoint = "/public/getCategoryProducts";

  final _storage = const FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _loadTokenAndFetch();
    super.initState();
  }

  Future<void> _loadTokenAndFetch() async {
    String? storedToken = await _storage.read(key: 'auth_token');
    setState(() {
      _token = storedToken;
    });

    if (_token != null && _token!.isNotEmpty) {
      _fetchbundelsProducts();
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.noTokenFound;
        _isLoading = false;
      });
    }
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
      debugPrint('${AppLocalizations.of(context)!.appliedFilters}: $result');
    }
  }

  Future<void> _fetchbundelsProducts({int retryCount = 0}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http
          .get(
            Uri.parse('$_apiBaseUrl$_bundelsEndpoint?code=10&id-shop=4'),
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['message'] == 'success') {
          // Correctly access the products array
          final products = responseData['response']['products'] as List;

          setState(() {
            _bundelsProducts =
                products.map((productJson) {
                  return Product(
                    id: productJson['id'] ?? 0,
                    name: productJson['name'] ?? '',
                    brand: productJson['manufacturer_name'] ?? '',
                    price: productJson['price']?.toString() ?? '0',
                    image: productJson['image'] ?? '',
                    description: productJson['description'] ?? '',
                    oldPrice: productJson['price_after_reduction']?.toString(),
                    discount: productJson['discount']?.toString(),
                  );
                }).toList();

            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                '${AppLocalizations.of(context)!.apiError}: ${responseData['message']}';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              '${AppLocalizations.of(context)!.failedToLoad}: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } on http.ClientException {
      if (retryCount < 3) {
        await Future.delayed(const Duration(seconds: 2));
        return _fetchbundelsProducts(retryCount: retryCount + 1);
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.networkError;
          _isLoading = false;
        });
      }
    } on TimeoutException {
      if (retryCount < 3) {
        await Future.delayed(const Duration(seconds: 2));
        return _fetchbundelsProducts(retryCount: retryCount + 1);
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.requestTimeout;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            '${AppLocalizations.of(context)!.anErrorOccurred}: ${e.toString()}';
        _isLoading = false;
      });
    }
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
                  productReference: product.reference,
                  shopId: '4',
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
                    child: Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey[100],
                      ),
                      child:
                          product.image.isNotEmpty
                              ? Image.network(
                                product.image.startsWith('http')
                                    ? product.image
                                    : 'https://tawasul-shop.com/img/p/${product.image}.jpg',
                                fit: BoxFit.contain,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 40.w,
                                    color: Colors.grey[400],
                                  );
                                },
                              )
                              : Icon(
                                Icons.image_not_supported,
                                size: 40.w,
                                color: Colors.grey[400],
                              ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${product.price} ${AppLocalizations.of(context)!.lyd}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1264a3),
                    ),
                  ),
                  if (product.discount != null &&
                      product.discount!.isNotEmpty &&
                      product.discount != '0')
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${product.discount}% ${AppLocalizations.of(context)!.off}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.80,
      padding: EdgeInsets.only(bottom: 90.h),
      children:
          products
              .map((product) => _buildProductCard(context, product))
              .toList(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage,
            style: TextStyle(fontSize: 16.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => _fetchbundelsProducts(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008AD2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    List<Product> sortedProducts = List.from(_bundelsProducts);

    if (tabIndex == 1) {
      sortedProducts.sort(
        (a, b) => double.parse(a.price).compareTo(double.parse(b.price)),
      );
    } else if (tabIndex == 2) {
      sortedProducts.sort(
        (a, b) => double.parse(b.price).compareTo(double.parse(a.price)),
      );
    }

    return _buildProductGrid(context, sortedProducts);
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        kToolbarHeight + 48.h,
      ), // AppBar + TabBar height
      child: Container(
        padding: EdgeInsets.only(top: 15.h),
        color: Colors.white,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 50.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Container(
                width: 35.w,
                height: 35.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF008AD2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.bestOffer,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => _showFilterDialog(context),
              child: Container(
                width: 36.w,
                height: 34.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF0984E3),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.sliders,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCart()),
                  ),
              child: Container(
                width: 36.w,
                height: 34.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF0984E3),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
          centerTitle: true,
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
                  Tab(text: AppLocalizations.of(context)!.topRated),
                  Tab(text: AppLocalizations.of(context)!.priceLowHigh),
                  Tab(text: AppLocalizations.of(context)!.priceHighLow),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: _showSearch ? null : _buildAppBar(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : TabBarView(
                controller: _tabController,
                children: List.generate(
                  3,
                  (index) => _buildTabContent(context, index),
                ),
              ),
    );
  }
}
