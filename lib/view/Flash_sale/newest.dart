import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Product%20detail/product_detail.dart';

class Newest extends StatefulWidget {
  final String shopId;
  final String categoryCode;

  const Newest({super.key, required this.categoryCode, required this.shopId});

  @override
  State<Newest> createState() => _NewestState();
}

class _NewestState extends State<Newest> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = Provider.of<ProductController>(
        context,
        listen: false,
      );
      productController.fetchNewestProducts(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    // Show loading indicator while data is being fetched
    if (productController.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              "Loading newest arrivals...",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Show error if there is one
    if (productController.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                productController.errorMessage,
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  productController.clearError();
                  productController.fetchNewestProducts(widget.shopId);
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Use newestProducts instead of filtering allProducts
    final newestProducts = productController.newestProducts;

    print("🆕 Newest products count: ${newestProducts.length}");

    // Show newest products or empty state
    if (newestProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.new_releases, size: 40.h, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              "No new products available at the moment",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "Check back later for new arrivals!",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await productController.fetchNewestProducts(widget.shopId);
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            for (int i = 0; i < newestProducts.length; i += 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProductCard(context, newestProducts[i]),
                  if (i + 1 < newestProducts.length) SizedBox(width: 10.w),
                  if (i + 1 < newestProducts.length)
                    _buildProductCard(context, newestProducts[i + 1]),
                ],
              ),
          ],
        ),
      ),
    );
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
        margin: EdgeInsets.all(7.w),
        width: 150.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            if (product.discount != null)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
            Padding(
              padding: EdgeInsets.only(top: 19.h, left: 8.w, right: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        product.image.isNotEmpty
                            ? Image.network(
                              product.image,
                              height: 90.h,
                              width: 90.w,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.error, size: 40.h),
                            )
                            : Icon(Icons.image_not_supported, size: 40.h),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    product.brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF96979A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF092A43),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Text(
                        "${product.price} DYL",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF0984E3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      if (product.oldPrice != null)
                        Text(
                          "${product.oldPrice} DYL",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
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
}
