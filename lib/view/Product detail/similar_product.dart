import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Provider/product_provider.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Product detail/product_detail.dart';

class SimilarProducts extends StatefulWidget {
  final Product currentProduct;
  final String shopId;

  const SimilarProducts({
    super.key,
    required this.currentProduct,
    required this.shopId,
  });

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  @override
  void initState() {
    super.initState();
    print("SimilarProducts initState called");
    print("Current product ID: ${widget.currentProduct.id}");
    print(
      "Current product categoryCode: ${widget.currentProduct.categoryCode}",
    );
    print("Shop ID: ${widget.shopId}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSimilarProducts();
    });
  }

  void _loadSimilarProducts() {
    print("Loading similar products...");
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    final categoryCode = widget.currentProduct.categoryCode ?? '10';
    print("Using category code: $categoryCode");

    productProvider.fetchSimilarProducts(
      categoryCode: categoryCode,
      shopId: widget.shopId,
      excludeProductId: widget.currentProduct.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building SimilarProducts widget");

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        print("ProductProvider state:");
        print("- isLoading: ${productProvider.isLoading}");
        print("- error: ${productProvider.error}");
        print(
          "- similarProducts count: ${productProvider.similarProducts.length}",
        );

        if (productProvider.isLoading) {
          print("Showing loading indicator");
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        if (productProvider.error.isNotEmpty) {
          print("Showing error: ${productProvider.error}");
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              productProvider.error,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (productProvider.similarProducts.isEmpty) {
          print("No similar products found");
          return const SizedBox.shrink();
        }

        print(
          "Displaying ${productProvider.similarProducts.length} similar products",
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Similar Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productProvider.similarProducts.length,
                itemBuilder: (context, index) {
                  final product = productProvider.similarProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetail(
                                toggleFavorite: () {},
                                isFavorite: false,
                                productReference: product.reference,
                                shopId: widget.shopId,
                                product: product,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150.w,
                      height: 30.h,
                      margin: EdgeInsets.only(right: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 120.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 16.h,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 30),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${product.price} LYD',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF008AD2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
