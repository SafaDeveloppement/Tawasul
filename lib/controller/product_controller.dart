import 'package:flutter/material.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _newestProducts = [];
  List<Product> _favoriteProducts = [];
  List<Product> _currentCategoryProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isInitialized = false;

  // Favorite states tracking
  final Map<int, bool> _favoriteStates = {};

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get newestProducts => _newestProducts;
  List<Product> get favoriteProducts => _favoriteProducts;
  List<Product> get currentCategoryProducts => _currentCategoryProducts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  // Initialize the controller
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      await ApiService.testApiConnection();

      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.containsKey('auth_token');

      if (hasToken) {
        await fetchFavoriteProducts();
      }

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Initialization failed: $e';
      _isInitialized = true;
      notifyListeners();
      print(" Error initializing ProductController: $e");
    }
  }

  // Fetch products by category name
  Future<void> fetchProductsByCategoryName(String categoryName) async {
    try {
      // Find category ID dynamically
      final categoryId = await ApiService.getCategoryIdByName(categoryName);

      if (categoryId == null) {
        throw Exception('Category "$categoryName" not found');
      }

      // Fetch products using the dynamic category ID
      final products = await ApiService.getProductsByCategoryCode(categoryId);
      _currentCategoryProducts = products;
      notifyListeners();

      print(
        "✓ Loaded ${products.length} products for '$categoryName' (ID: $categoryId)",
      );
    } catch (e) {
      print("✗ Error fetching products for '$categoryName': $e");
      throw e;
    }
  }

  // Fetch favorite products from API
  Future<void> fetchFavoriteProducts() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final products = await ApiService.getFavoriteProducts();

      // Update favorite states
      for (var product in products) {
        _favoriteStates[product.id] = true;
      }

      _favoriteProducts = products;
      _isLoading = false;
      notifyListeners();
      print(" Loaded ${products.length} favorite products");
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load favorites: $e';
      notifyListeners();
      print(" Error fetching favorite products: $e");
    }
  }

  // Set category products
  void setCategoryProducts(List<Product> products) {
    _currentCategoryProducts = _syncProductsWithFavorites(products);
    notifyListeners();
  }

  // Set all products
  void setAllProducts(List<Product> products) {
    _allProducts = _syncProductsWithFavorites(products);
    notifyListeners();
  }

  // Fetch newest products sorted by date_add
  Future<void> fetchNewestProducts({int limit = 10}) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      print(" Fetching newest products (limit: $limit)...");

      // Use the new API method that sorts by date_add
      final products = await ApiService.getNewestProducts(
        numberOfProducts: limit,
        orderBy: 'date_add',
        orderSens: 'desc',
      );

      if (products.isEmpty) {
        print(" No newest products returned from API");
      } else {
        print(" Loaded ${products.length} newest products");

        // Debug: Check if products have date information
        for (var product in products.take(3)) {
          print(" ${product.name} (ID: ${product.id})");
        }
      }

      _newestProducts = _syncProductsWithFavorites(products);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load newest products: $e';
      notifyListeners();
      print(" Error fetching newest products: $e");
    }
  }

  // Toggle favorite with proper state management
  Future<void> toggleFavorite(int productId) async {
    print(" toggleFavorite called for productId: $productId");

    try {
      final currentStatus = _favoriteStates[productId] ?? false;
      final newStatus = !currentStatus;

      print(" Current status: $currentStatus, New status: $newStatus");

      // Update tracking map immediately
      _favoriteStates[productId] = newStatus;

      // Update all product lists
      _updateProductInList(_allProducts, productId, newStatus);
      _updateProductInList(_newestProducts, productId, newStatus);
      _updateProductInList(_currentCategoryProducts, productId, newStatus);

      // Update favorite products list
      if (newStatus) {
        final product = _findProductById(productId);
        if (product != null &&
            !_favoriteProducts.any((p) => p.id == productId)) {
          _favoriteProducts.add(product..isFavorite = true);
        }
      } else {
        _favoriteProducts.removeWhere((p) => p.id == productId);
      }

      print(" Updated favorite status to: $newStatus");
      print(" Favorite products count: ${_favoriteProducts.length}");

      notifyListeners();

      // Update server in background
      _updateFavoriteOnServer(productId, newStatus);
    } catch (e) {
      print(" Error in toggleFavorite: $e");
      _errorMessage = 'Error toggling favorite: $e';
      notifyListeners();
    }
  }

  // Helper method to update product in list
  void _updateProductInList(
    List<Product> products,
    int productId,
    bool isFavorite,
  ) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index] = products[index].copyWith(isFavorite: isFavorite);
    }
  }

  // Sync products with favorite states
  List<Product> _syncProductsWithFavorites(List<Product> products) {
    return products.map((product) {
      if (_favoriteStates.containsKey(product.id)) {
        return product.copyWith(isFavorite: _favoriteStates[product.id]!);
      } else {
        _favoriteStates[product.id] = product.isFavorite;
        return product;
      }
    }).toList();
  }

  // Update favorite on server
  Future<void> _updateFavoriteOnServer(int productId, bool isFavorite) async {
    try {
      final success = await ApiService.toggleFavorite(productId, isFavorite);
      if (!success) {
        print(" API call failed for productId: $productId");
        // Revert on failure
        _revertFavoriteChange(productId, isFavorite);
        _errorMessage = 'Failed to update favorite status on server';
        notifyListeners();
      } else {
        print(" API call successful for productId: $productId");
      }
    } catch (e) {
      print(" Error in server update for productId: $productId: $e");
      _revertFavoriteChange(productId, isFavorite);
      notifyListeners();
    }
  }

  // Revert favorite change
  void _revertFavoriteChange(int productId, bool attemptedStatus) {
    final originalStatus = !attemptedStatus;
    _favoriteStates[productId] = originalStatus;

    _updateProductInList(_allProducts, productId, originalStatus);
    _updateProductInList(_newestProducts, productId, originalStatus);
    _updateProductInList(_currentCategoryProducts, productId, originalStatus);

    if (originalStatus) {
      final product = _findProductById(productId);
      if (product != null) {
        _favoriteProducts.add(product..isFavorite = true);
      }
    } else {
      _favoriteProducts.removeWhere((p) => p.id == productId);
    }
  }

  // Find product by ID
  Product? _findProductById(int productId) {
    // Check current category products first
    final currentCategoryProduct = _currentCategoryProducts.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => Product(
            id: 0,
            name: '',
            brand: '',
            price: 0,
            image: '',
            description: '',
            reference: '',
          ),
    );

    if (currentCategoryProduct.id != 0) return currentCategoryProduct;

    // Check all products
    final allProductsItem = _allProducts.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => Product(
            id: 0,
            name: '',
            brand: '',
            price: 0,
            image: '',
            description: '',
            reference: '',
          ),
    );

    if (allProductsItem.id != 0) return allProductsItem;

    // Check newest products
    return _newestProducts.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => Product(
            id: 0,
            name: '',
            brand: '',
            price: 0,
            image: '',
            description: '',
            reference: '',
          ),
    );
  }

  // Check if product is favorite
  bool isProductFavorite(int productId) {
    return _favoriteStates[productId] ?? false;
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

  // Get products for search
  List<Product> getProductsForSearch() {
    if (_currentCategoryProducts.isNotEmpty) {
      return _currentCategoryProducts;
    }
    return _allProducts;
  }
}
