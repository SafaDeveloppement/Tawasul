import 'package:flutter/material.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/navbar.dart';
import 'package:tawasul_application/view/product_detail.dart';

class SearchingResult extends StatefulWidget {
  final String searchQuery;

  const SearchingResult({super.key, required this.searchQuery});

  @override
  State<SearchingResult> createState() => _SearchingResultState();
}

class _SearchingResultState extends State<SearchingResult> {
  int _currentNavIndex = 0;
  late List<Product> filteredProducts;

  final List<Product> allProducts = [
    Product(
      id: 1,
      name: 'Headset',
      brand: 'Xiaomi',
      price: '730 LYD',
      image: 'assets/images/xiaomi_casque.png',
      oldPrice: '850 LYD',
      discount: '14%',
      description: 'High-quality wireless headset with noise cancellation',
    ),
    Product(
      id: 2,
      name: 'Smart Watch',
      brand: 'Xiaomi',
      price: '1450 LYD',
      image: 'assets/images/smart_watch.png',
      oldPrice: '1600 LYD',
      discount: '9%',
      description: 'Feature-rich smartwatch with health monitoring',
    ),
    Product(
      id: 3,
      name: 'Smartphone',
      brand: 'Xiaomi',
      price: '1700 LYD',
      image: 'assets/images/xiaomi_iphone.png',
      oldPrice: '2000 LYD',
      discount: '15%',
      description: 'High-performance smartphone with advanced camera',
    ),
    Product(
      id: 4,
      name: 'Tablet',
      brand: 'Xiaomi',
      price: '1870 LYD',
      image: 'assets/images/xiaomi_tablette.png',
      oldPrice: '2100 LYD',
      discount: '11%',
      description: 'Powerful tablet with high-resolution display',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts() {
    setState(() {
      filteredProducts =
          allProducts.where((product) {
            return product.name.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                ) ||
                product.brand.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                );
          }).toList();
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      filteredProducts[index].isFavorite = !filteredProducts[index].isFavorite;
    });
  }

  Widget _buildPriceInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.oldPrice != null && product.discount != null)
          Row(
            children: [
              Text(
                product.oldPrice!,
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.discount!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        Text(
          product.price,
          style: TextStyle(
            color: Color(0xFF008AD2),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008AD2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Results for '${widget.searchQuery}'",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child:
            filteredProducts.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No products found for "${widget.searchQuery}"',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      toggleFavorite: () => _toggleFavorite(index),
                      isFavorite: product.isFavorite,
                      priceInfo: _buildPriceInfo(product),
                    );
                  },
                ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        context: context,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback toggleFavorite;
  final bool isFavorite;
  final Widget priceInfo;

  const ProductCard({
    super.key,
    required this.product,
    required this.toggleFavorite,
    required this.isFavorite,
    required this.priceInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetail(
                  product: product,
                  toggleFavorite: toggleFavorite,
                  isFavorite: isFavorite,
                ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,
                        height: 120,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  priceInfo,
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => toggleFavorite(),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  radius: 14,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Color(0xFF008AD2) : Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
