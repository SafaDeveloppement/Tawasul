class ProductFilter {
  String sortBy;
  double? minPrice;
  double? maxPrice;
  String? brand;
  List<String> selectedBrands;

  ProductFilter({
    this.sortBy = 'name',
    this.minPrice,
    this.maxPrice,
    this.brand,
    this.selectedBrands = const [],
  });

  ProductFilter copyWith({
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? brand,
    List<String>? selectedBrands,
  }) {
    return ProductFilter(
      sortBy: sortBy ?? this.sortBy,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      brand: brand ?? this.brand,
      selectedBrands: selectedBrands ?? this.selectedBrands,
    );
  }

  bool get hasFilters {
    return sortBy != 'name' || 
           minPrice != null || 
           maxPrice != null || 
           (selectedBrands.isNotEmpty);
  }

  void clear() {
    sortBy = 'name';
    minPrice = null;
    maxPrice = null;
    selectedBrands.clear();
  }
}