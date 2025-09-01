import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/product_detail.dart';

class SimilarProducts extends StatelessWidget {
  final Product currentProduct;
  final String shopId;
  final List<Product> allProducts;

  const SimilarProducts({
    Key? key,
    required this.currentProduct,
    required this.shopId,
    required this.allProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(
      context,
      listen: false,
    );

    final similarProducts =
        productController.allProducts
            .where(
              (p) =>
                  p.id != currentProduct.id &&
                  (p.brand == currentProduct.brand ||
                      (currentProduct.category != null &&
                          p.category == currentProduct.category)),
            )
            .take(5)
            .toList();

    if (similarProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Similar Products",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similarProducts.length,
            itemBuilder: (context, index) {
              final product = similarProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetail(
                            productReference: product.reference,
                            shopId: shopId,
                            product: product,
                            toggleFavorite:
                                () => productController.toggleFavorite(
                                  product.id,
                                ),
                            isFavorite: product.isFavorite,
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Image.network(
                              product.image,
                              height: 90,
                              width: 70,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50);
                              },
                            ),
                          ),
                          if (product.discount != null)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product.discount!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.brand,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Text(
                            product.price,
                            style: const TextStyle(
                              color: Color(0xFF0984E3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.oldPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                product.oldPrice!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                        ],
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
  }
}


