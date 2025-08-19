import 'package:flutter/material.dart';

class ProductFilters {
  final RangeValues priceRange;
  final String? category;
  final String? color;
  final List<String> brands;

  ProductFilters({
    required this.priceRange,
    this.category,
    this.color,
    required this.brands,
  });

  ProductFilters copyWith({
    RangeValues? priceRange,
    String? category,
    String? color,
    List<String>? brands,
  }) {
    return ProductFilters(
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      color: color ?? this.color,
      brands: brands ?? this.brands,
    );
  }
}