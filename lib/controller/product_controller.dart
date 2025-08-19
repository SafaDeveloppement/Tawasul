// import 'package:flutter/material.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/model/product_model.dart';

// class ProductController with ChangeNotifier {
//   // Products lists
//   List<Product> _allProducts = [];
//   List<Product> _favoriteProducts = [];
//   List<Product> _bestSellingProducts = [];
  
//   // Loading states
//   bool _isLoadingAll = false;
//   bool _isLoadingFavorites = false;
//   bool _isLoadingBestSellers = false;
  
//   // Error states
//   String? _allProductsError;
//   String? _favoritesError;
//   String? _bestSellersError;

//   // Getters
//   List<Product> get allProducts => _allProducts;
//   List<Product> get favoriteProducts => _favoriteProducts.where((p) => p.isFavorite).toList();
//   List<Product> get bestSellingProducts => _bestSellingProducts;
  
//   bool get isLoadingAll => _isLoadingAll;
//   bool get isLoadingFavorites => _isLoadingFavorites;
//   bool get isLoadingBestSellers => _isLoadingBestSellers;
  
//   String? get allProductsError => _allProductsError;
//   String? get favoritesError => _favoritesError;
//   String? get bestSellersError => _bestSellersError;

//   // Initialize controller
//   ProductController() {
//     // Load initial data
//     fetchAllProducts();
//     fetchBestSellingProducts();
//   }


//   // Fetch all products
//   // In fetchAllProducts method, add error handling:
// Future<void> fetchAllProducts() async {
//   _isLoadingAll = true;
//   _allProductsError = null;
//   notifyListeners();
  
//   try {
//     final products = await ApiService.getAllProducts();
//     if (products.isEmpty) {
//       _allProductsError = 'No products found';
//     }
//     _allProducts = products;
//   } catch (e) {
//     _allProductsError = 'Failed to load products: ${e.toString()}';
//     print("Error fetching products: $e");
//   } finally {
//     _isLoadingAll = false;
//     notifyListeners();
//   }
// }

//   // Fetch favorite products
//   Future<void> fetchFavoriteProducts() async {
//     _isLoadingFavorites = true;
//     _favoritesError = null;
//     notifyListeners();
    
//     try {
//       final favorites = await ApiService.getFavoriteProducts();
//       _favoriteProducts = favorites;
      
//       // Update favorite status in all products list
//       for (var product in _allProducts) {
//         product.isFavorite = _favoriteProducts.any((fp) => fp.id == product.id);
//       }
//     } catch (e) {
//       _favoritesError = 'Failed to load favorites';
//       print("Error fetching favorites: $e");
//     } finally {
//       _isLoadingFavorites = false;
//       notifyListeners();
//     }
//   }

//   // Fetch best selling products
//   Future<void> fetchBestSellingProducts() async {
//     _isLoadingBestSellers = true;
//     _bestSellersError = null;
//     notifyListeners();
    
//     try {
//       final bestSellers = await ApiService.getBestSellingProducts();
//       _bestSellingProducts = bestSellers;
//     } catch (e) {
//       _bestSellersError = 'Failed to load best sellers';
//       print("Error fetching best sellers: $e");
//     } finally {
//       _isLoadingBestSellers = false;
//       notifyListeners();
//     }
//   }

//   // Toggle favorite status
//   Future<void> toggleFavorite(int productId) async {
//     try {
//       final productIndex = _allProducts.indexWhere((p) => p.id == productId);
//       if (productIndex != -1) {
//         final product = _allProducts[productIndex];
//         final newFavoriteStatus = !product.isFavorite;
//         product.isFavorite = newFavoriteStatus;
        
//         // Optimistic UI update
//         if (newFavoriteStatus) {
//           _favoriteProducts.add(product);
//         } else {
//           _favoriteProducts.removeWhere((p) => p.id == productId);
//         }
//         notifyListeners();
        
//         // API call
//         final success = await ApiService.toggleFavorite(productId, newFavoriteStatus);
        
//         if (!success) {
//           // Revert if API call fails
//           product.isFavorite = !newFavoriteStatus;
//           if (newFavoriteStatus) {
//             _favoriteProducts.remove(product);
//           } else {
//             _favoriteProducts.add(product);
//           }
//           notifyListeners();
//         }
//       }
//     } catch (e) {
//       print("Error toggling favorite: $e");
//     }
//   }

//   // Get product by ID
//   Product? getProductById(int id) {
//     try {
//       return _allProducts.firstWhere((p) => p.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Sync favorites status between all products and favorites list
//   void _syncFavoritesStatus() {
//     for (var product in _allProducts) {
//       product.isFavorite = _favoriteProducts.any((fp) => fp.id == product.id);
//     }
//   }

//   // Clear all data (for logout)
//   void clear() {
//     _allProducts.clear();
//     _favoriteProducts.clear();
//     _bestSellingProducts.clear();
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:tawasul_application/model/product_model.dart';

class ProductController with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _favoriteProducts = [];

  List<Product> get allProducts => _allProducts;
  List<Product> get favoriteProducts => _favoriteProducts;

  Future<void> initializeProducts() async {
    // Replace with your actual product data
    _allProducts = [
      Product(
        id: 1,
        name: "Smart TV",
        brand: "Samsung",
        price: "999 DYL",
        image: "assets/images/tv1.jpg",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: false,
      ),
      Product(
        id: 2,
        name: "LED 50\"",
        brand: "LG",
        price: "899 DYL",
        image: "assets/images/tv3.jpg",
        description: "50-inch LED TV with webOS",
        isBestSeller: false,
      ),
      Product(
        id: 3,
        name: "Smart TV",
        brand: "Samsung",
        price: "999 DYL",
        image: "assets/images/airpods.png",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: true,
      ),
      Product(
        id: 4,
        name: "LED 50\"",
        brand: "LG",
        price: "899 DYL",
        image: "assets/images/airpods1.webp",
        description: "50-inch LED TV with webOS",
        isBestSeller: true,
      ),
      Product(
        id: 5,
        name: "Smart TV",
        brand: "Samsung",
        price: "999 DYL",
        image: "assets/images/tv2.jpg",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: true,
      ),
      Product(
        id: 6,
        name: "LED 50\"",
        brand: "LG",
        price: "899 DYL",
        image: "assets/images/iphone1.jpg",
        description: "50-inch LED TV with webOS",
        isBestSeller: true,
      ),
      Product(
        id: 7,
        name: "Smart TV",
        brand: "Samsung",
        price: "999 DYL",
        image: "assets/images/iphone2.jpg",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: false,
      ),
      Product(
        id: 8,
        name: "LED 50\"",
        brand: "LG",
        price: "899 DYL",
        image: "assets/images/iphone3.jpg",
        description: "50-inch LED TV with webOS",
        isBestSeller: true,
      ),
      Product(
        id: 9,
        name: "Smart TV",
        brand: "Samsung",
        price: "999 DYL",
        image: "assets/images/iphone4.jpg",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: true,
      ),
    ];

    // Initialize favorites
    _favoriteProducts = _allProducts.where((p) => p.isFavorite).toList();
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final index = _allProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _allProducts[index].isFavorite = !_allProducts[index].isFavorite;

      if (_allProducts[index].isFavorite) {
        _favoriteProducts.add(_allProducts[index]);
      } else {
        _favoriteProducts.removeWhere((p) => p.id == productId);
      }

      notifyListeners();
    }
  }
}
