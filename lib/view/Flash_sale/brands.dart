import 'package:flutter/material.dart';

class Product {
  final String imagePath;
  Product({required this.imagePath});
}

class Brands extends StatefulWidget {
  const Brands({super.key});
  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  final List<Product> products = [
    Product(imagePath: 'assets/images/xiaomi_brand.png'),
    Product(imagePath: 'assets/images/samsung_brand.png'),
    Product(imagePath: 'assets/images/apple_brand.png'),
    Product(imagePath: 'assets/images/huawei_brand.png'),
    Product(imagePath: 'assets/images/energizer_brand.png'),
    Product(imagePath: 'assets/images/nokia_brand.png'),
    Product(imagePath: 'assets/images/tcl_brand.png'),
    Product(imagePath: 'assets/images/blackshark_brand.png'),
    Product(imagePath: 'assets/images/nothing_brand.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // First row
                _buildBrandRow([products[0], products[1]]),
                const SizedBox(height: 16),
                // Second row
                _buildBrandRow([products[2], products[3]]),
                const SizedBox(height: 16),
                // Third row
                _buildBrandRow([products[4], products[5]]),
                const SizedBox(height: 16),
                // Fourth row
                _buildBrandRow([products[6], products[7]]),
                const SizedBox(height: 16),
                // Last row (handles single item differently)
                if (products.length % 2 != 0)
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        products.last.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandRow(List<Product> rowProducts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          rowProducts.map((product) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.32,
              height: MediaQuery.of(context).size.width * 0.40,
              padding: const EdgeInsets.all(2),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                //color: Colors.grey[100], // Light background
                borderRadius: BorderRadius.circular(8),
                // boxShadow: [
                //   BoxShadow(
                //     color: const Color.fromARGB(255, 255, 255, 255),
                //     offset: Offset(0, 2),
                //     blurRadius: 1,
                //     spreadRadius: 0,
                //     blurStyle: BlurStyle.normal,
                //   ),
                // ],
              ),
              child: Image.asset(product.imagePath, height: 65),
            );
          }).toList(),
    );
  }
}
