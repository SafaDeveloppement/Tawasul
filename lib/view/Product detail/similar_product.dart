import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';
import 'package:tawasul_application/Services/api_service.dart';

class SimilarProducts extends StatefulWidget {
  final Product currentProduct;
  final String? shopId;

  const SimilarProducts({super.key, required this.currentProduct, this.shopId});

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  List<Product> _similarProducts = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    print("SimilarProducts initState called");
    print("Current product ID: ${widget.currentProduct.id}");
    print("Current product category ID: ${widget.currentProduct.categoryId}");
    print("Shop ID: ${widget.shopId}");

    _loadSimilarProducts();
  }

  // Future<void> _loadSimilarProducts() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //       _error = '';
  //     });

  //     final int? categoryId = widget.currentProduct.categoryId;

  //     if (categoryId == null) {
  //       print(" Product does not have a category ID, using fallback strategy");

  //       final randomProducts = await ApiService.getRandomProductsFromCategories(
  //         numberOfProducts: 8,
  //       );

  //       final filteredProducts =
  //           randomProducts
  //               .where((product) => product.id != widget.currentProduct.id)
  //               .toList();

  //       setState(() {
  //         _similarProducts = filteredProducts;
  //         _isLoading = false;
  //       });

  //       print(" Loaded ${filteredProducts.length} random products as fallback");
  //       return;
  //     }

  //     print("Loading similar products for category ID: $categoryId");

  //     final similarProducts = await ApiService.getSimilarProductsByCategory(
  //       categoryId: categoryId,
  //       excludeProductId: widget.currentProduct.id,
  //       limit: 8,
  //     );

  //     setState(() {
  //       _similarProducts = similarProducts;
  //       _isLoading = false;
  //     });

  //     print(" Loaded ${similarProducts.length} similar products");
  //   } catch (e) {
  //     setState(() {
  //       _error = 'Failed to load similar products: $e';
  //       _isLoading = false;
  //     });
  //     print("✗ Error loading similar products: $e");
  //   }
  // }
  Future<void> _loadSimilarProducts() async {
    // ADD: Check if widget is still mounted before starting
    if (!mounted) return;

    try {
      // ADD: Safe setState with mounted check
      if (mounted) {
        setState(() {
          _isLoading = true;
          _error = '';
        });
      }

      final int? categoryId = widget.currentProduct.categoryId;

      if (categoryId == null) {
        print(
          "ℹ️ Product does not have a category ID, using fallback strategy",
        );

        final randomProducts = await ApiService.getRandomProductsFromCategories(
          numberOfProducts: 8,
        ).timeout(
          Duration(seconds: 30),
          onTimeout: () {
            print("⏰ Timeout fetching random products");
            return [];
          },
        );

        // ADD: Check mounted before proceeding
        if (!mounted) return;

        final filteredProducts =
            randomProducts
                .where((product) => product.id != widget.currentProduct.id)
                .toList();

        // ADD: Safe setState
        if (mounted) {
          setState(() {
            _similarProducts = filteredProducts;
            _isLoading = false;
          });
        }

        print(
          "✅ Loaded ${filteredProducts.length} random products as fallback",
        );
        return;
      }

      print("🔄 Loading similar products for category ID: $categoryId");

      final similarProducts = await ApiService.getSimilarProductsByCategory(
        categoryId: categoryId,
        excludeProductId: widget.currentProduct.id,
        limit: 8,
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print("⏰ Timeout fetching similar products");
          return [];
        },
      );

      // ADD: Check mounted before updating state
      if (!mounted) return;

      // ADD: Safe setState
      if (mounted) {
        setState(() {
          _similarProducts = similarProducts;
          _isLoading = false;
        });
      }

      print("✅ Loaded ${similarProducts.length} similar products");
    } catch (e) {
      print("❌ Error loading similar products: $e");

      // ADD: Safe error handling with mounted check
      if (mounted) {
        setState(() {
          _error = 'Failed to load similar products: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _onProductTap(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductDetail(
              toggleFavorite: () {
                final productController = Provider.of<ProductController>(
                  context,
                  listen: false,
                );
                productController.toggleFavorite(product.id);
              },
              isFavorite: product.isFavorite,
              productReference: product.reference,
              product: product,
            ),
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () => _onProductTap(product),
      child: Container(
        width: 155.w,
        height: 200.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 110.h,
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              child: Stack(
                children: [
                  // Product Image
                  Center(
                    child:
                        product.image.isNotEmpty
                            ? Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40.w,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
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
                                  ),
                                );
                              },
                            )
                            : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40.w,
                                color: Colors.grey,
                              ),
                            ),
                  ),

                  // Discount badge
                  if (product.discount != null)
                    Positioned(
                      top: 4.w,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF39C12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          product.discount!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Text(
                      product.brand!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF96979A),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  SizedBox(height: 4.h),

                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF092A43),
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6.h),

                  // Price
                  Row(
                    children: [
                      Text(
                        "${product.price} LYD",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF0984E3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      if (product.oldPrice != null &&
                          product.oldPrice! > product.price)
                        Text(
                          "${product.oldPrice} LYD",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Stock status
                  Row(
                    children: [
                      Icon(
                        product.stock > 0 ? Icons.check_circle : Icons.cancel,
                        size: 12.sp,
                        color: product.stock > 0 ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        product.stock > 0 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: product.stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
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

    if (_isLoading) {
      return SizedBox(
        height: 220.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF008AD2)),
          ),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return SizedBox(
        height: 100.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 40.w, color: Colors.grey),
              SizedBox(height: 8.h),
              Text(
                _error,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: _loadSimilarProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008AD2),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_similarProducts.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 40.w, color: Colors.grey),
              SizedBox(height: 8.h),
              Text(
                'No similar products found',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.youMightAlsoLike,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _similarProducts.length,
            itemBuilder: (context, index) {
              final product = _similarProducts[index];
              return _buildProductItem(product);
            },
          ),
        ),
      ],
    );
  }
}
