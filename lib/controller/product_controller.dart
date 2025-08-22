// import 'package:flutter/material.dart';
// import 'package:tawasul_application/Services/api_service.dart';
// import 'package:tawasul_application/model/product_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductController with ChangeNotifier {
//   List<Product> _allProducts = [];
//   List<Product> _newestProducts = []; // ADD THIS LINE
//   List<Product> _favoriteProducts = [];
//   bool _isLoading = false;
//   String _errorMessage = '';
//   bool _isInitialized = false;

//   List<Product> get allProducts => _allProducts;
//   List<Product> get newestProducts => _newestProducts; // ADD THIS GETTER
//   List<Product> get favoriteProducts => _favoriteProducts;
//   bool get isLoading => _isLoading;
//   String get errorMessage => _errorMessage;
//   bool get isInitialized => _isInitialized;
//     List<Product> get currentCategoryProducts => _currentCategoryProducts;

//   // Initialize the controller - called from main.dart
//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     try {
//       _isLoading = true;
//       notifyListeners();
//       await ApiService.testApiConnection();

//       // Check if user is logged in (has token)
//       final prefs = await SharedPreferences.getInstance();
//       final hasToken = prefs.containsKey('auth_token');

//       if (hasToken) {
//         await fetchFavoriteProducts();
//       } else {
//         _initializeWithDummyData();
//       }

//       _isInitialized = true;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _errorMessage = 'Initialization failed: $e';
//       _initializeWithDummyData(); // Fallback to dummy data
//       _isInitialized = true;
//       notifyListeners();
//       print("Error initializing ProductController: $e");
//     }
//   }

//   // Fallback to dummy data if API fails or user not logged in
//   void _initializeWithDummyData() {
//     _allProducts = [
//       Product(
//         id: 1,
//         name: "Smart TV",
//         brand: "Samsung",
//         price: "999",
//         image: "assets/images/tv1.jpg",
//         description: "55-inch 4K Smart TV with HDR",
//         isBestSeller: false,
//       ),
//       Product(
//         id: 2,
//         name: "LED 50\"",
//         brand: "LG",
//         price: "899",
//         image: "assets/images/tv3.jpg",
//         description: "50-inch LED TV with webOS",
//         isBestSeller: false,
//       ),
//     ];

//     _favoriteProducts = _allProducts.where((p) => p.isFavorite).toList();
//   }

//   Future<void> fetchCategoryProducts(String categoryCode, String shopId) async {
//     try {
//       _isLoading = true;
//       _errorMessage = '';
//       notifyListeners();

//       final products = await ApiService.getCategoryProducts(
//         categoryCode: categoryCode,
//         shopId: shopId,
//       );

//       _allProducts = products;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _errorMessage = 'Failed to load products: $e';
//       notifyListeners();
//       print("Error fetching category products: $e");
//     }
//   }

//   // Fetch favorite products from API
//   Future<void> fetchFavoriteProducts() async {
//     try {
//       _isLoading = true;
//       _errorMessage = '';
//       notifyListeners();

//       final products = await ApiService.getFavoriteProducts();

//       _favoriteProducts = products;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _errorMessage = 'Failed to load favorites: $e';
//       notifyListeners();
//       print("Error fetching favorite products: $e");
//     }
//   }
//     void setCategoryProducts(List<Product> products) {
//     _currentCategoryProducts = products;
//     notifyListeners();
//   }

//   void setAllProducts(List<Product> products) {
//     _allProducts = products;
//     notifyListeners();
//   }

//   Future<void> fetchNewestProducts(String shopId) async {
//     try {
//       _isLoading = true;
//       _errorMessage = '';
//       notifyListeners();

//       final products = await ApiService.getCategoryProducts(
//         categoryCode: 'all',
//         shopId: shopId,
//       );

//       _newestProducts = products;
//       _allProducts = products;

//       print("🆕 Fetched products for Newest page: ${_newestProducts.length}");

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _errorMessage = 'Failed to load newest products: $e';
//       notifyListeners();
//       print("Error fetching newest products: $e");
//     }
//   }

//   // Toggle favorite status with API call
//   Future<void> toggleFavorite(int productId) async {
//     try {
//       // Find the product in all products
//       final productIndex = _allProducts.indexWhere((p) => p.id == productId);
//       if (productIndex == -1) return;

//       final currentStatus = _allProducts[productIndex].isFavorite;

//       // Optimistically update UI
//       _allProducts[productIndex].isFavorite = !currentStatus;

//       // Also update in newest products if it exists there
//       final newestIndex = _newestProducts.indexWhere((p) => p.id == productId);
//       if (newestIndex != -1) {
//         _newestProducts[newestIndex].isFavorite = !currentStatus;
//       }

//       if (_allProducts[productIndex].isFavorite) {
//         _favoriteProducts.add(_allProducts[productIndex]);
//       } else {
//         _favoriteProducts.removeWhere((p) => p.id == productId);
//       }

//       notifyListeners();

//       // Call API to update server
//       final success = await ApiService.toggleFavorite(
//         productId,
//         !currentStatus,
//       );

//       // If API call failed, revert the change
//       if (!success) {
//         _allProducts[productIndex].isFavorite = currentStatus;

//         if (newestIndex != -1) {
//           _newestProducts[newestIndex].isFavorite = currentStatus;
//         }

//         if (currentStatus) {
//           _favoriteProducts.add(_allProducts[productIndex]);
//         } else {
//           _favoriteProducts.removeWhere((p) => p.id == productId);
//         }

//         _errorMessage = 'Failed to update favorite status';
//         notifyListeners();
//       }
//     } catch (e) {
//       _errorMessage = 'Error toggling favorite: $e';
//       notifyListeners();
//       print("Error toggling favorite: $e");
//     }
//   }

//   // Clear error message
//   void clearError() {
//     _errorMessage = '';
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _newestProducts = [];
  List<Product> _favoriteProducts = [];
  List<Product> _currentCategoryProducts = []; // ADD THIS LINE
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isInitialized = false;

  List<Product> get allProducts => _allProducts;
  List<Product> get newestProducts => _newestProducts;
  List<Product> get favoriteProducts => _favoriteProducts;
  List<Product> get currentCategoryProducts =>
      _currentCategoryProducts; // ADD THIS GETTER
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Initialize the controller - called from main.dart
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();
      await ApiService.testApiConnection();

      // Check if user is logged in (has token)
      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.containsKey('auth_token');

      if (hasToken) {
        await fetchFavoriteProducts();
      } else {
        _initializeWithDummyData();
      }

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Initialization failed: $e';
      _initializeWithDummyData(); // Fallback to dummy data
      _isInitialized = true;
      notifyListeners();
      print("Error initializing ProductController: $e");
    }
  }

  // Fallback to dummy data if API fails or user not logged in
  void _initializeWithDummyData() {
    _allProducts = [
      Product(
        id: 1,
        name: "Smart TV",
        brand: "Samsung",
        price: "999",
        image: "assets/images/tv1.jpg",
        description: "55-inch 4K Smart TV with HDR",
        isBestSeller: false,
      ),
      Product(
        id: 2,
        name: "LED 50\"",
        brand: "LG",
        price: "899",
        image: "assets/images/tv3.jpg",
        description: "50-inch LED TV with webOS",
        isBestSeller: false,
      ),
    ];

    _favoriteProducts = _allProducts.where((p) => p.isFavorite).toList();
  }

  Future<void> fetchCategoryProducts(String categoryCode, String shopId) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final products = await ApiService.getCategoryProducts(
        categoryCode: categoryCode,
        shopId: shopId,
      );

      _allProducts = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load products: $e';
      notifyListeners();
      print("Error fetching category products: $e");
    }
  }

  // Fetch favorite products from API
  Future<void> fetchFavoriteProducts() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final products = await ApiService.getFavoriteProducts();

      _favoriteProducts = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load favorites: $e';
      notifyListeners();
      print("Error fetching favorite products: $e");
    }
  }

  void setCategoryProducts(List<Product> products) {
    _currentCategoryProducts = products;
    notifyListeners();
  }

  void setAllProducts(List<Product> products) {
    _allProducts = products;
    notifyListeners();
  }

  Future<void> fetchNewestProducts(String shopId) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final products = await ApiService.getCategoryProducts(
        categoryCode: 'all',
        shopId: shopId,
      );

      _newestProducts = products;
      _allProducts = products;

      print("🆕 Fetched products for Newest page: ${_newestProducts.length}");

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load newest products: $e';
      notifyListeners();
      print("Error fetching newest products: $e");
    }
  }

  // Toggle favorite status with API call
  Future<void> toggleFavorite(int productId) async {
    try {
      // Find the product in all products
      final productIndex = _allProducts.indexWhere((p) => p.id == productId);
      if (productIndex == -1) return;

      final currentStatus = _allProducts[productIndex].isFavorite;

      // Optimistically update UI
      _allProducts[productIndex].isFavorite = !currentStatus;

      // Also update in newest products if it exists there
      final newestIndex = _newestProducts.indexWhere((p) => p.id == productId);
      if (newestIndex != -1) {
        _newestProducts[newestIndex].isFavorite = !currentStatus;
      }

      // Also update in current category products if it exists there
      final categoryIndex = _currentCategoryProducts.indexWhere(
        (p) => p.id == productId,
      );
      if (categoryIndex != -1) {
        _currentCategoryProducts[categoryIndex].isFavorite = !currentStatus;
      }

      if (_allProducts[productIndex].isFavorite) {
        _favoriteProducts.add(_allProducts[productIndex]);
      } else {
        _favoriteProducts.removeWhere((p) => p.id == productId);
      }

      notifyListeners();

      // Call API to update server
      final success = await ApiService.toggleFavorite(
        productId,
        !currentStatus,
      );

      // If API call failed, revert the change
      if (!success) {
        _allProducts[productIndex].isFavorite = currentStatus;

        if (newestIndex != -1) {
          _newestProducts[newestIndex].isFavorite = currentStatus;
        }

        if (categoryIndex != -1) {
          _currentCategoryProducts[categoryIndex].isFavorite = currentStatus;
        }

        if (currentStatus) {
          _favoriteProducts.add(_allProducts[productIndex]);
        } else {
          _favoriteProducts.removeWhere((p) => p.id == productId);
        }

        _errorMessage = 'Failed to update favorite status';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error toggling favorite: $e';
      notifyListeners();
      print("Error toggling favorite: $e");
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Clear current category products
  void clearCategoryProducts() {
    _currentCategoryProducts = [];
    notifyListeners();
  }
}
