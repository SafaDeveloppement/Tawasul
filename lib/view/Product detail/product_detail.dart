import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/Provider/cart_provider.dart';
import 'package:tawasul_application/Provider/product_provider.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';
import 'package:tawasul_application/view/Product%20detail/similar_product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/Services/api_service.dart';

class ProductDetail extends StatefulWidget {
  final VoidCallback toggleFavorite;
  final bool isFavorite;
  final String productReference;
  final Product? product;

  const ProductDetail({
    super.key,
    required this.toggleFavorite,
    required this.isFavorite,
    required this.productReference,
    this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  late bool isFavorite;
  Product? product;
  bool isLoading = true;
  String errorMessage = '';
  int _currentImageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  bool _isAddingToCart = false;
  ProductCombination? _selectedColor;
  bool _isColorAvailable = true;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      if (widget.product != null) {
        product = widget.product;
        _initializeColorSelection();
        setState(() {
          isLoading = false;
        });
        return;
      }

      int? productId = int.tryParse(widget.productReference);
      if (productId == null && widget.product != null) {
        productId = widget.product!.id;
      }

      if (productId == null || productId == 0) {
        throw Exception('Invalid product ID');
      }

      print(" Fetching product detail for ID: $productId");

      final result = await ApiService.getProductDetail(
        productId: productId,
        languageId: 1,
      );

      print(" API Response: ${result != null ? 'Success' : 'Null'}");

      if (result != null && result['success'] == true) {
        final productData = result['product'] ?? result;

        // ENHANCED DEBUG: Print raw combination data
        if (productData['combinations'] != null) {
          final combos = productData['combinations'] as List;
          print(" RAW COMBINATIONS FROM API (${combos.length}):");
          for (var i = 0; i < combos.length; i++) {
            final combo = combos[i];
            print("   [$i] ID: ${combo['id_product_attribute']}");
            print("       Attributes: '${combo['attributes']}'");
            print("       Color Code: '${combo['color']}'");
            print("       Stock: ${combo['quantity'] ?? combo['stock']}");
            print("       Default: ${combo['default']}");
            print("       Images: ${combo['images']}");
          }
        }

        product = Product.fromDetailedJson(productData);

        // DEBUG: Check what was parsed
        print(" PARSED PRODUCT ANALYSIS:");
        print("   Total combinations: ${product!.combinations.length}");
        print("   Color combinations: ${product!.colorCombinations.length}");
        print("   Has color combinations: ${product!.hasColorCombinations}");

        if (product!.colorCombinations.isNotEmpty) {
          print(" COLOR COMBINATIONS FOUND:");
          for (var i = 0; i < product!.colorCombinations.length; i++) {
            final combo = product!.colorCombinations[i];
            print("   [$i] ${combo.colorName}");
            print("       Color Code: ${combo.codeColeur}");
            print("       Is Color: ${combo.isColorCombination}");
            print("       Available: ${combo.isAvailable}");
            print("       Quantity: ${combo.quantity}");
          }
        } else {
          print(" NO COLOR COMBINATIONS FOUND AFTER PARSING");
        }

        _initializeColorSelection();
        setState(() {
          isLoading = false;
        });
      } else {
        final errorMsg = result?['message'] ?? 'Failed to load product details';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print(" Error fetching product: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  void _initializeColorSelection() {
    if (product != null && product!.colorCombinations.isNotEmpty) {
      final colorCombos = product!.colorCombinations;

      print(" Initializing color selection with ${colorCombos.length} colors");

      // Debug print all colors
      for (var combo in colorCombos) {
        print(
          "   - ${combo.colorName}: ${combo.codeColeur} "
          "(Qty: ${combo.quantity}, Available: ${combo.isAvailable}, "
          "Default: ${combo.defaultOn == 1})",
        );
      }

      _selectedColor = product!.defaultColor;
      _isColorAvailable = _selectedColor?.isAvailable ?? false;

      print(
        " Selected: ${_selectedColor?.colorName} "
        "(Available: $_isColorAvailable)",
      );

      // Update images based on selected color
      _updateImagesForSelectedColor();
    } else {
      print(" No color combinations found");
      _selectedColor = null;
      _isColorAvailable = product?.inStock ?? false;
    }
  }

  void _updateImagesForSelectedColor() {
    if (product != null && _selectedColor != null) {
      final colorImages = product!.getImagesForColor(_selectedColor);
      print(" Images for ${_selectedColor!.colorName}: ${colorImages.length}");

      // You might want to update the carousel with these images
      // This would require storing the images in state and updating the carousel
    }
  }

  void _onColorSelected(ProductCombination color) {
    print(
      " Color selected: ${color.colorName} "
      "(Quantity: ${color.quantity}, Available: ${color.isAvailable})",
    );

    setState(() {
      _selectedColor = color;
      _isColorAvailable = color.isAvailable;
    });

    // Update images when color changes
    _updateImagesForSelectedColor();
  }

  void _addToCart() async {
    final t = AppLocalizations.of(context)!;

    if (product == null || !_isColorAvailable) return;

    try {
      setState(() {
        _isAddingToCart = true;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final attributeId = _selectedColor?.id;

      print(
        "🛒 Adding to cart - Product: ${product!.id}, "
        "Color: ${_selectedColor?.colorName}, "
        "Attribute ID: $attributeId, "
        "Quantity: $quantity",
      );

      // Use the corrected addToCart with default quantity handling
      await cartProvider.addToCart(
        product: product!,
        quantity: quantity, // This now defaults to 1 in the provider
        productAttributeId: attributeId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.productAddedToCart),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print(" Cart error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  void _buyNow() async {
    final t = AppLocalizations.of(context)!;

    if (product == null || !_isColorAvailable) return;

    try {
      setState(() {
        _isAddingToCart = true;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final attributeId = _selectedColor?.id;

      await cartProvider.addToCart(
        product: product!,
        quantity: quantity,
        productAttributeId: attributeId,
      );

      Navigator.push(context, MaterialPageRoute(builder: (_) => Checkout()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  Widget _buildStockStatus() {
    if (product == null) return SizedBox.shrink();

    // For products with colors, show status for selected color
    if (product!.hasColorCombinations && _selectedColor != null) {
      return Row(
        children: [
          Icon(
            _isColorAvailable ? Icons.check_circle : Icons.cancel,
            color: _isColorAvailable ? Colors.green : Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            _isColorAvailable ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              fontSize: 14.sp,
              color: _isColorAvailable ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          if (_isColorAvailable && _selectedColor!.quantity > 0)
            Text(
              '(${_selectedColor!.quantity} available)',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
        ],
      );
    } else {
      // For products without colors
      return Row(
        children: [
          Icon(
            product!.inStock ? Icons.check_circle : Icons.cancel,
            color: product!.inStock ? Colors.green : Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            product!.inStock ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              fontSize: 14.sp,
              color: product!.inStock ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildImageCarousel() {
    if (product == null) {
      return Container(
        height: 250.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image, size: 60, color: Colors.grey),
      );
    }

    // Get all images - use main image + additional images
    List<String> allImages = [];

    // Add main image if available
    if (product!.image.isNotEmpty) {
      allImages.add(product!.image);
    }

    // Add additional images
    allImages.addAll(product!.images);

    // Remove duplicates
    allImages = allImages.toSet().toList();

    print(" Total images to display: ${allImages.length}");
    print(" Main image: ${product!.image}");
    print(" Additional images: ${product!.images}");

    if (allImages.isEmpty) {
      return Container(
        height: 250.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
            SizedBox(height: 10.h),
            Text('No image available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Image Carousel ONLY
        Container(
          height: 300.h,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 300.h,
              autoPlay: allImages.length > 1,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            items:
                allImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(" Image load error: $imageUrl");
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
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
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        ),

        SizedBox(height: 15.h),

        // Image indicators
        if (allImages.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                allImages.asMap().entries.map((entry) {
                  return Container(
                    width: 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentImageIndex == entry.key
                              ? const Color(0xFF008AD2)
                              : Colors.grey[300],
                    ),
                  );
                }).toList(),
          ),

        SizedBox(height: 20.h),
      ],
    );
  }

  // Add this method to _ProductDetailState class in product_detail.dart
  Widget _buildDebugContainer(String message) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.orange[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDots() {
    if (product == null || !product!.hasColorCombinations) {
      return SizedBox.shrink();
    }

    final colorCombos = product!.colorCombinations;
    print(" Building UI for ${colorCombos.length} color dots");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, size: 20.sp, color: Color(0xFF008AD2)),
              SizedBox(width: 8.w),
              Text(
                'Available Colors',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Wrap(
            spacing: 15.w,
            runSpacing: 12.h,
            children:
                colorCombos.map((colorCombo) {
                  return _ColorDot(
                    color: colorCombo.colorValue,
                    isSelected: _selectedColor?.id == colorCombo.id,
                    isAvailable: colorCombo.isAvailable,
                    onTap: () => _onColorSelected(colorCombo),
                    tooltip:
                        '${colorCombo.colorName}${colorCombo.isAvailable ? '' : ' (Out of Stock)'}',
                  );
                }).toList(),
          ),

          SizedBox(height: 12.h),

          if (_selectedColor != null)
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _selectedColor!.isAvailable
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        _selectedColor!.isAvailable ? Colors.green : Colors.red,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Selected: ${_selectedColor!.colorName}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _selectedColor!.isAvailable
                        ? '(${_selectedColor!.quantity} available)'
                        : '(Out of Stock)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          _selectedColor!.isAvailable
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF008AD2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                t.loadingProduct,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (product == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF008AD2),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  errorMessage.isEmpty ? t.productNotFound : errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _fetchProductDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF008AD2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    t.retry,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF008AD2),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    t.productDetails,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleFavorite();
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Image Carousel Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: _buildImageCarousel(),
                      ),

                      // COLOR DOTS SECTION - PLACED RIGHT AFTER IMAGE CAROUSEL
                      if (product!.hasColorCombinations)
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 24.w,
                          ),
                          child: _buildColorDots(),
                        ),

                      // Product Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    product!.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${product!.price} ${t.lyd}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF008AD2),
                                      ),
                                    ),
                                    if (product!.oldPrice != null &&
                                        product!.oldPrice! > product!.price)
                                      Text(
                                        '${product!.oldPrice!} ${t.lyd}',
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // Stock information
                            _buildStockStatus(),

                            SizedBox(height: 20.h),

                            // Short Description
                            if (product!.shortDescription.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Key Features',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Html(
                                      data: product!.shortDescription,
                                      style: {
                                        "body": Style(
                                          fontSize: FontSize(14.0),
                                          color: Colors.black87,
                                          margin: Margins.zero,
                                        ),
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),

                            // Full Description
                            Text(
                              t.description,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Html(
                                data: product?.description ?? t.noDescription,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(14.0),
                                    color: Colors.black87,
                                    textAlign: TextAlign.justify,
                                    margin: Margins.zero,
                                  ),
                                },
                              ),
                            ),

                            SizedBox(height: 30.h),

                            // Quantity and Add to Cart
                            Row(
                              children: [
                                // Quantity Selector
                                Container(
                                  width: 140.w,
                                  height: 50.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (quantity > 1) quantity--;
                                          });
                                        },
                                        child: Container(
                                          width: 36.w,
                                          height: 36.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF008AD2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$quantity',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        child: Container(
                                          width: 36.w,
                                          height: 36.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF008AD2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Add to Cart Button
                                Expanded(
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      gradient:
                                          _isColorAvailable && !_isAddingToCart
                                              ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF008AD2),
                                                  Color(0xFF006DA9),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                              : null,
                                      color:
                                          !_isColorAvailable
                                              ? Colors.grey[400]
                                              : null,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow:
                                          _isColorAvailable && !_isAddingToCart
                                              ? [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF008AD2,
                                                  ).withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child: TextButton(
                                      onPressed:
                                          (_isColorAvailable &&
                                                  !_isAddingToCart)
                                              ? _addToCart
                                              : null,
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                      child:
                                          _isAddingToCart
                                              ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                              : Text(
                                                _isColorAvailable
                                                    ? t.addToCart
                                                    : 'Out of Stock',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            // Buy Now Button
                            if (_isColorAvailable)
                              Container(
                                width: double.infinity,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color:
                                      !_isAddingToCart
                                          ? Colors.black
                                          : Colors.grey[400],
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow:
                                      !_isAddingToCart
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                          : null,
                                ),
                                child: TextButton(
                                  onPressed: !_isAddingToCart ? _buyNow : null,
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child:
                                      _isAddingToCart
                                          ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : Text(
                                            t.buyNow,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                ),
                              ),

                            SizedBox(height: 30.h),

                            // Similar Products
                            Consumer<ProductProvider>(
                              builder: (context, productProvider, child) {
                                return SimilarProducts(
                                  currentProduct: product!,
                                );
                              },
                            ),

                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ],
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

// COLOR DOT WIDGET
class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;
  final String tooltip;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[400]!,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child:
              !isAvailable
                  ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.block, size: 20.w, color: Colors.white),
                  )
                  : isSelected
                  ? Icon(
                    Icons.check,
                    size: 20.w,
                    color:
                        color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                  )
                  : null,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tawasul_application/Provider/cart_provider.dart';
// import 'package:tawasul_application/Provider/product_provider.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:tawasul_application/view/Checkout/checkout.dart';
// import 'package:tawasul_application/view/Product%20detail/similar_product.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:tawasul_application/Services/api_service.dart';

// class ProductDetail extends StatefulWidget {
//   final VoidCallback toggleFavorite;
//   final bool isFavorite;
//   final String productReference;
//   final Product? product;

//   const ProductDetail({
//     super.key,
//     required this.toggleFavorite,
//     required this.isFavorite,
//     required this.productReference,
//     this.product,
//   });

//   @override
//   State<ProductDetail> createState() => _ProductDetailState();
// }

// class _ProductDetailState extends State<ProductDetail> {
//   int quantity = 1;
//   late bool isFavorite;
//   Product? product;
//   bool isLoading = true;
//   String errorMessage = '';
//   int _currentImageIndex = 0;
//   final CarouselController _carouselController = CarouselController();
//   bool _isAddingToCart = false;
//   ProductCombination? _selectedColor;
//   bool _isColorAvailable = true;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = widget.isFavorite;
//     _fetchProductDetail();
//   }

//   Future<void> _fetchProductDetail() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = '';
//       });

//       if (widget.product != null) {
//         product = widget.product;
//         _initializeColorSelection();
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       int? productId = int.tryParse(widget.productReference);
//       if (productId == null && widget.product != null) {
//         productId = widget.product!.id;
//       }

//       if (productId == null || productId == 0) {
//         throw Exception('Invalid product ID');
//       }

//       print(" Fetching product detail for ID: $productId");

//       final result = await ApiService.getProductDetail(
//         productId: productId,
//         languageId: 1,
//       );

//       print(" API Response: ${result != null ? 'Success' : 'Null'}");

//       if (result != null && result['success'] == true) {
//         final productData = result['product'] ?? result;

//         // ENHANCED DEBUG: Print raw combination data
//         if (productData['combinations'] != null) {
//           final combos = productData['combinations'] as List;
//           print(" RAW COMBINATIONS FROM API (${combos.length}):");
//           for (var i = 0; i < combos.length; i++) {
//             final combo = combos[i];
//             print("   [$i] ID: ${combo['id_product_attribute']}");
//             print("       Attributes: '${combo['attributes']}'");
//             print("       Color Code: '${combo['color']}'");
//             print("       Stock: ${combo['quantity'] ?? combo['stock']}");
//             print("       Default: ${combo['default']}");
//             print("       Images: ${combo['images']}");
//           }
//         }

//         product = Product.fromDetailedJson(productData);

//         // DEBUG: Check what was parsed
//         print(" PARSED PRODUCT ANALYSIS:");
//         print("   Total combinations: ${product!.combinations.length}");
//         print("   Color combinations: ${product!.colorCombinations.length}");
//         print("   Has color combinations: ${product!.hasColorCombinations}");

//         if (product!.colorCombinations.isNotEmpty) {
//           print(" COLOR COMBINATIONS FOUND:");
//           for (var i = 0; i < product!.colorCombinations.length; i++) {
//             final combo = product!.colorCombinations[i];
//             print("   [$i] ${combo.colorName}");
//             print("       Color Code: ${combo.codeColeur}");
//             print("       Is Color: ${combo.isColorCombination}");
//             print("       Available: ${combo.isAvailable}");
//             print("       Quantity: ${combo.quantity}");
//           }
//         } else {
//           print(" NO COLOR COMBINATIONS FOUND AFTER PARSING");
//         }

//         _initializeColorSelection();
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         final errorMsg = result?['message'] ?? 'Failed to load product details';
//         throw Exception(errorMsg);
//       }
//     } catch (e) {
//       print(" Error fetching product: $e");
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error: $e';
//       });
//     }
//   }

//   void _initializeColorSelection() {
//     if (product != null && product!.colorCombinations.isNotEmpty) {
//       final colorCombos = product!.colorCombinations;

//       print(" Initializing color selection with ${colorCombos.length} colors");

//       // Debug print all colors
//       for (var combo in colorCombos) {
//         print(
//           "   - ${combo.colorName}: ${combo.codeColeur} "
//           "(Qty: ${combo.quantity}, Available: ${combo.isAvailable}, "
//           "Default: ${combo.defaultOn == 1})",
//         );
//       }

//       _selectedColor = product!.defaultColor;
//       _isColorAvailable = _selectedColor?.isAvailable ?? false;

//       print(
//         " Selected: ${_selectedColor?.colorName} "
//         "(Available: $_isColorAvailable)",
//       );

//       // Update images based on selected color
//       _updateImagesForSelectedColor();
//     } else {
//       print(" No color combinations found");
//       _selectedColor = null;
//       _isColorAvailable = product?.inStock ?? false;
//     }
//   }

//   void _updateImagesForSelectedColor() {
//     if (product != null && _selectedColor != null) {
//       final colorImages = product!.getImagesForColor(_selectedColor);
//       print(" Images for ${_selectedColor!.colorName}: ${colorImages.length}");

//       // You might want to update the carousel with these images
//       // This would require storing the images in state and updating the carousel
//     }
//   }

//   void _onColorSelected(ProductCombination color) {
//     print(
//       " Color selected: ${color.colorName} "
//       "(Quantity: ${color.quantity}, Available: ${color.isAvailable})",
//     );

//     setState(() {
//       _selectedColor = color;
//       _isColorAvailable = color.isAvailable;
//     });

//     // Update images when color changes
//     _updateImagesForSelectedColor();
//   }

//   void _addToCart() async {
//     final t = AppLocalizations.of(context)!;

//     if (product == null || !_isColorAvailable) return;

//     try {
//       setState(() {
//         _isAddingToCart = true;
//       });

//       final cartProvider = Provider.of<CartProvider>(context, listen: false);
//       final attributeId = _selectedColor?.id;

//       print(
//         "🛒 Adding to cart - Product: ${product!.id}, "
//         "Color: ${_selectedColor?.colorName}, "
//         "Attribute ID: $attributeId, "
//         "Quantity: $quantity",
//       );

//       await cartProvider.addToCart(
//         product: product!,
//         quantity: quantity,
//         productAttributeId: attributeId,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(t.productAddedToCart),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       print(" Cart error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to add to cart: $e'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isAddingToCart = false;
//       });
//     }
//   }

//   void _buyNow() async {
//     final t = AppLocalizations.of(context)!;

//     if (product == null || !_isColorAvailable) return;

//     try {
//       setState(() {
//         _isAddingToCart = true;
//       });

//       final cartProvider = Provider.of<CartProvider>(context, listen: false);
//       final attributeId = _selectedColor?.id;

//       await cartProvider.addToCart(
//         product: product!,
//         quantity: quantity,
//         productAttributeId: attributeId,
//       );

//       Navigator.push(context, MaterialPageRoute(builder: (_) => Checkout()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to add to cart: $e'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isAddingToCart = false;
//       });
//     }
//   }

//   Widget _buildStockStatus() {
//     if (product == null) return SizedBox.shrink();

//     // For products with colors, show status for selected color
//     if (product!.hasColorCombinations && _selectedColor != null) {
//       return Row(
//         children: [
//           Icon(
//             _isColorAvailable ? Icons.check_circle : Icons.cancel,
//             color: _isColorAvailable ? Colors.green : Colors.red,
//             size: 16.sp,
//           ),
//           SizedBox(width: 5.w),
//           Text(
//             _isColorAvailable ? 'In Stock' : 'Out of Stock',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: _isColorAvailable ? Colors.green : Colors.red,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(width: 8.w),
//           if (_isColorAvailable && _selectedColor!.quantity > 0)
//             Text(
//               '(${_selectedColor!.quantity} available)',
//               style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//             ),
//         ],
//       );
//     } else {
//       // For products without colors
//       return Row(
//         children: [
//           Icon(
//             product!.inStock ? Icons.check_circle : Icons.cancel,
//             color: product!.inStock ? Colors.green : Colors.red,
//             size: 16.sp,
//           ),
//           SizedBox(width: 5.w),
//           Text(
//             product!.inStock ? 'In Stock' : 'Out of Stock',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: product!.inStock ? Colors.green : Colors.red,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     }
//   }

//   Widget _buildImageCarousel() {
//     if (product == null) {
//       return Container(
//         height: 250.h,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Icon(Icons.image, size: 60, color: Colors.grey),
//       );
//     }

//     // Get all images - use main image + additional images
//     List<String> allImages = [];

//     // Add main image if available
//     if (product!.image.isNotEmpty) {
//       allImages.add(product!.image);
//     }

//     // Add additional images
//     allImages.addAll(product!.images);

//     // Remove duplicates
//     allImages = allImages.toSet().toList();

//     print(" Total images to display: ${allImages.length}");
//     print(" Main image: ${product!.image}");
//     print(" Additional images: ${product!.images}");

//     if (allImages.isEmpty) {
//       return Container(
//         height: 250.h,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
//             SizedBox(height: 10.h),
//             Text('No image available', style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: [
//         // Image Carousel ONLY
//         Container(
//           height: 300.h,
//           child: CarouselSlider(
//             options: CarouselOptions(
//               height: 300.h,
//               autoPlay: allImages.length > 1,
//               autoPlayInterval: const Duration(seconds: 3),
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enlargeCenterPage: true,
//               viewportFraction: 0.9,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentImageIndex = index;
//                 });
//               },
//             ),
//             items:
//                 allImages.map((imageUrl) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 5.w),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.white,
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             imageUrl,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               print(" Image load error: $imageUrl");
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.broken_image,
//                                       size: 50,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(height: 8.h),
//                                     Text(
//                                       'Failed to load image',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     value:
//                                         loadingProgress.expectedTotalBytes !=
//                                                 null
//                                             ? loadingProgress
//                                                     .cumulativeBytesLoaded /
//                                                 loadingProgress
//                                                     .expectedTotalBytes!
//                                             : null,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//           ),
//         ),

//         SizedBox(height: 15.h),

//         // Image indicators
//         if (allImages.length > 1)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:
//                 allImages.asMap().entries.map((entry) {
//                   return Container(
//                     width: 8.w,
//                     height: 8.h,
//                     margin: EdgeInsets.symmetric(horizontal: 4.w),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           _currentImageIndex == entry.key
//                               ? const Color(0xFF008AD2)
//                               : Colors.grey[300],
//                     ),
//                   );
//                 }).toList(),
//           ),

//         SizedBox(height: 20.h),
//       ],
//     );
//   }

//   // Add this method to _ProductDetailState class in product_detail.dart
//   Widget _buildDebugContainer(String message) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.orange[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10.h),
//       padding: EdgeInsets.all(16.w),
//       child: Row(
//         children: [
//           Icon(Icons.warning, color: Colors.orange),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(message, style: TextStyle(color: Colors.orange[800])),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorDots() {
//     if (product == null || !product!.hasColorCombinations) {
//       return SizedBox.shrink();
//     }

//     final colorCombos = product!.colorCombinations;
//     print(" Building UI for ${colorCombos.length} color dots");

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10.h),
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.palette, size: 20.sp, color: Color(0xFF008AD2)),
//               SizedBox(width: 8.w),
//               Text(
//                 'Available Colors',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),

//           Wrap(
//             spacing: 15.w,
//             runSpacing: 12.h,
//             children:
//                 colorCombos.map((colorCombo) {
//                   return _ColorDot(
//                     color: colorCombo.colorValue,
//                     isSelected: _selectedColor?.id == colorCombo.id,
//                     isAvailable: colorCombo.isAvailable,
//                     onTap: () => _onColorSelected(colorCombo),
//                     tooltip:
//                         '${colorCombo.colorName}${colorCombo.isAvailable ? '' : ' (Out of Stock)'}',
//                   );
//                 }).toList(),
//           ),

//           SizedBox(height: 12.h),

//           if (_selectedColor != null)
//             Container(
//               padding: EdgeInsets.all(8.w),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey[300]!),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     _selectedColor!.isAvailable
//                         ? Icons.check_circle
//                         : Icons.cancel,
//                     color:
//                         _selectedColor!.isAvailable ? Colors.green : Colors.red,
//                     size: 16.sp,
//                   ),
//                   SizedBox(width: 6.w),
//                   Text(
//                     'Selected: ${_selectedColor!.colorName}',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Text(
//                     _selectedColor!.isAvailable
//                         ? '(${_selectedColor!.quantity} available)'
//                         : '(Out of Stock)',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color:
//                           _selectedColor!.isAvailable
//                               ? Colors.green
//                               : Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     if (isLoading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 3,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 t.loadingProduct,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (product == null) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF008AD2),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 64, color: Colors.white),
//                 const SizedBox(height: 20),
//                 Text(
//                   errorMessage.isEmpty ? t.productNotFound : errorMessage,
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _fetchProductDetail,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF008AD2),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Text(
//                     t.retry,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF008AD2),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     t.productDetails,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       widget.toggleFavorite();
//                       setState(() {
//                         isFavorite = !isFavorite;
//                       });
//                     },
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         size: 24,
//                         color: isFavorite ? Colors.red : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 10),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40),
//                     topRight: Radius.circular(40),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       // Image Carousel Section
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 20,
//                           horizontal: 10,
//                         ),
//                         child: _buildImageCarousel(),
//                       ),

//                       // COLOR DOTS SECTION - PLACED RIGHT AFTER IMAGE CAROUSEL
//                       if (product!.hasColorCombinations)
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 10.h,
//                             horizontal: 24.w,
//                           ),
//                           child: _buildColorDots(),
//                         ),

//                       // Product Details Section
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Product Name and Price
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     product!.name,
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                       height: 1.3,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       '${product!.price} ${t.lyd}',
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF008AD2),
//                                       ),
//                                     ),
//                                     if (product!.oldPrice != null &&
//                                         product!.oldPrice! > product!.price)
//                                       Text(
//                                         '${product!.oldPrice!} ${t.lyd}',
//                                         style: const TextStyle(
//                                           decoration:
//                                               TextDecoration.lineThrough,
//                                           fontSize: 16,
//                                           color: Colors.grey,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 10.h),

//                             // Stock information
//                             _buildStockStatus(),

//                             SizedBox(height: 20.h),

//                             // Short Description
//                             if (product!.shortDescription.isNotEmpty)
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Key Features',
//                                     style: TextStyle(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8.h),
//                                   Container(
//                                     padding: EdgeInsets.all(12.w),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[50],
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: Colors.grey[300]!,
//                                       ),
//                                     ),
//                                     child: Html(
//                                       data: product!.shortDescription,
//                                       style: {
//                                         "body": Style(
//                                           fontSize: FontSize(14.0),
//                                           color: Colors.black87,
//                                           margin: Margins.zero,
//                                         ),
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(height: 20.h),
//                                 ],
//                               ),

//                             // Full Description
//                             Text(
//                               t.description,
//                               style: TextStyle(
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             SizedBox(height: 8.h),
//                             Container(
//                               padding: EdgeInsets.all(12.w),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[50],
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey[300]!),
//                               ),
//                               child: Html(
//                                 data: product?.description ?? t.noDescription,
//                                 style: {
//                                   "body": Style(
//                                     fontSize: FontSize(14.0),
//                                     color: Colors.black87,
//                                     textAlign: TextAlign.justify,
//                                     margin: Margins.zero,
//                                   ),
//                                 },
//                               ),
//                             ),

//                             SizedBox(height: 30.h),

//                             // Quantity and Add to Cart
//                             Row(
//                               children: [
//                                 // Quantity Selector
//                                 Container(
//                                   width: 140.w,
//                                   height: 50.h,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 8.w,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[50],
//                                     border: Border.all(
//                                       color: Colors.grey[300]!,
//                                     ),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             if (quantity > 1) quantity--;
//                                           });
//                                         },
//                                         child: Container(
//                                           width: 36.w,
//                                           height: 36.h,
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFF008AD2),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             Icons.remove,
//                                             color: Colors.white,
//                                             size: 18.sp,
//                                           ),
//                                         ),
//                                       ),
//                                       Text(
//                                         '$quantity',
//                                         style: TextStyle(
//                                           fontSize: 18.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             quantity++;
//                                           });
//                                         },
//                                         child: Container(
//                                           width: 36.w,
//                                           height: 36.h,
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFF008AD2),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             Icons.add,
//                                             color: Colors.white,
//                                             size: 18.sp,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),

//                                 // Add to Cart Button
//                                 Expanded(
//                                   child: Container(
//                                     height: 50.h,
//                                     decoration: BoxDecoration(
//                                       gradient:
//                                           _isColorAvailable && !_isAddingToCart
//                                               ? const LinearGradient(
//                                                 colors: [
//                                                   Color(0xFF008AD2),
//                                                   Color(0xFF006DA9),
//                                                 ],
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                               )
//                                               : null,
//                                       color:
//                                           !_isColorAvailable
//                                               ? Colors.grey[400]
//                                               : null,
//                                       borderRadius: BorderRadius.circular(25),
//                                       boxShadow:
//                                           _isColorAvailable && !_isAddingToCart
//                                               ? [
//                                                 BoxShadow(
//                                                   color: const Color(
//                                                     0xFF008AD2,
//                                                   ).withOpacity(0.3),
//                                                   blurRadius: 10,
//                                                   offset: const Offset(0, 4),
//                                                 ),
//                                               ]
//                                               : null,
//                                     ),
//                                     child: TextButton(
//                                       onPressed:
//                                           (_isColorAvailable &&
//                                                   !_isAddingToCart)
//                                               ? _addToCart
//                                               : null,
//                                       style: TextButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             25,
//                                           ),
//                                         ),
//                                       ),
//                                       child:
//                                           _isAddingToCart
//                                               ? SizedBox(
//                                                 width: 20,
//                                                 height: 20,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                       strokeWidth: 2,
//                                                       color: Colors.white,
//                                                     ),
//                                               )
//                                               : Text(
//                                                 _isColorAvailable
//                                                     ? t.addToCart
//                                                     : 'Out of Stock',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 16.sp,
//                                                 ),
//                                               ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 20.h),

//                             // Buy Now Button
//                             if (_isColorAvailable)
//                               Container(
//                                 width: double.infinity,
//                                 height: 50.h,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       !_isAddingToCart
//                                           ? Colors.black
//                                           : Colors.grey[400],
//                                   borderRadius: BorderRadius.circular(25),
//                                   boxShadow:
//                                       !_isAddingToCart
//                                           ? [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(
//                                                 0.2,
//                                               ),
//                                               blurRadius: 10,
//                                               offset: const Offset(0, 4),
//                                             ),
//                                           ]
//                                           : null,
//                                 ),
//                                 child: TextButton(
//                                   onPressed: !_isAddingToCart ? _buyNow : null,
//                                   style: TextButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                     ),
//                                   ),
//                                   child:
//                                       _isAddingToCart
//                                           ? SizedBox(
//                                             width: 20,
//                                             height: 20,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                               color: Colors.white,
//                                             ),
//                                           )
//                                           : Text(
//                                             t.buyNow,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16.sp,
//                                             ),
//                                           ),
//                                 ),
//                               ),

//                             SizedBox(height: 30.h),

//                             // Similar Products
//                             Consumer<ProductProvider>(
//                               builder: (context, productProvider, child) {
//                                 return SimilarProducts(
//                                   currentProduct: product!,
//                                 );
//                               },
//                             ),

//                             SizedBox(height: 40.h),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // COLOR DOT WIDGET
// class _ColorDot extends StatelessWidget {
//   final Color color;
//   final bool isSelected;
//   final bool isAvailable;
//   final VoidCallback? onTap;
//   final String tooltip;

//   const _ColorDot({
//     required this.color,
//     required this.isSelected,
//     required this.isAvailable,
//     this.onTap,
//     required this.tooltip,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: tooltip,
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 200),
//           width: 40.w,
//           height: 40.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//             border: Border.all(
//               color: isSelected ? Colors.black : Colors.grey[400]!,
//               width: isSelected ? 3 : 2,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child:
//               !isAvailable
//                   ? Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.block, size: 20.w, color: Colors.white),
//                   )
//                   : isSelected
//                   ? Icon(
//                     Icons.check,
//                     size: 20.w,
//                     color:
//                         color.computeLuminance() > 0.5
//                             ? Colors.black
//                             : Colors.white,
//                   )
//                   : null,
//         ),
//       ),
//     );
//   }
// }
