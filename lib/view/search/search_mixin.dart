import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/product_model.dart';

mixin SearchMixin {
  Timer? _debounce;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _showSearchResults = false;

  TextEditingController get searchController;

  void initSearch() async {
    try {
      _allProducts = await ApiService.getCategoryProducts(
        categoryCode: '10',
        shopId: '4',
      );
      _filteredProducts = _allProducts;
    } catch (e) {
      print("Error loading products for search: $e");
    }
  }

  void disposeSearch() {
    _debounce?.cancel();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _allProducts;
      _showSearchResults = false;
      updateState();
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    _filteredProducts =
        _allProducts.where((product) {
          return product.name.toLowerCase().contains(lowerCaseQuery) ||
              product.brand.toLowerCase().contains(lowerCaseQuery) ||
              product.description.toLowerCase().contains(lowerCaseQuery);
        }).toList();
    _showSearchResults = true;
    updateState();
  }

  void performRealTimeSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterProducts(query);
    });
  }

  void updateState();

  List<Product> get filteredProducts => _filteredProducts;
  bool get showSearchResults => _showSearchResults;
}
