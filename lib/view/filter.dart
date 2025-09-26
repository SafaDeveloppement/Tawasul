// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:tawasul_application/view/home_page.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({super.key});

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   RangeValues _priceRange = const RangeValues(0, 10000);
//   List<String> selectedCategories = [];
//   List<String> selectedColors = [];
//   List<String> selectedBrands = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   final List<String> categories = [
//     'HighTech',
//     'Smart Phone',
//     'Smart Office',
//     'Lifestyle',
//   ];

//   final Map<String, String> colorMap = {
//     'Blue': '0000FF',
//     'Orange': 'FFA500',
//     'Pink': 'FFC0CB',
//     'Red': 'FF0000',
//     'Green': '00FF00',
//     'Black': '000000',
//     'White': 'FFFFFF',
//     'Yellow': 'FFFF00',
//     'Purple': '800080',
//   };

//   final List<String> brands = [
//     'Apple',
//     'Xiaomi',
//     'Samsung',
//     'Nokia',
//     'Huawei',
//     'Nothing',
//     'Energizer',
//     'Black Shark',
//     'TCL',
//   ];

//   void _resetFilters() {
//     setState(() {
//       _priceRange = const RangeValues(0, 10000);
//       selectedCategories.clear();
//       selectedColors.clear();
//       selectedBrands.clear();
//       _errorMessage = null;
//     });
//   }

//   Future<Map<String, dynamic>> _fetchFilteredProducts() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Build query parameters
//       final Map<String, String> queryParams = {};

//       // Add name parameter (using first selected category or brand as search term)
//       if (selectedCategories.isNotEmpty) {
//         queryParams['name'] = selectedCategories.first;
//       } else if (selectedBrands.isNotEmpty) {
//         queryParams['name'] = selectedBrands.first;
//       } else {
//         queryParams['name'] = ''; // Empty search term returns all products
//       }

//       // Add price_max parameter
//       queryParams['price_max'] = _priceRange.end.toInt().toString();

//       // Add color parameter (convert color names to hex codes)
//       if (selectedColors.isNotEmpty) {
//         final colorHex = colorMap[selectedColors.first] ?? '000';
//         queryParams['color'] = colorHex;
//       } else {
//         queryParams['color'] = '000'; // Default color code
//       }

//       // Add code parameter (using brand or category as code)
//       if (selectedBrands.isNotEmpty) {
//         queryParams['code'] = '100'; // You can modify this logic as needed
//       } else if (selectedCategories.isNotEmpty) {
//         queryParams['code'] = '200'; // Different code for categories
//       } else {
//         queryParams['code'] = '100'; // Default code
//       }

//       // Build URL with query parameters
//       final Uri url = Uri.parse('http://197.13.18.8/public/getproducts').replace(
//         queryParameters: queryParams,
//       );

//       print('API URL: $url');
//       print('Query Parameters: $queryParams');

//       final response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 30));

//       print('API Response Status: ${response.statusCode}');
//       print('API Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['success'] == true) {
//           return {
//             'success': true,
//             'products': data['products'] ?? [],
//             'filtersApplied': queryParams,
//           };
//         } else {
//           throw Exception(data['message'] ?? 'Failed to fetch products');
//         }
//       } else {
//         throw Exception('HTTP Error ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       throw Exception('Failed to load products: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _applyFilters() async {
//     try {
//       final result = await _fetchFilteredProducts();

//       if (result['success'] == true) {
//         final List<dynamic> products = result['products'] ?? [];
//         final Map<String, dynamic> filtersApplied = result['filtersApplied'] ?? {};

//         // Navigate to HomePage with filtered results
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(
//               filteredProducts: products,
//               appliedFilters: filtersApplied,
//             ),
//           ),
//         );

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Found ${products.length} products'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   String _getSelectedFiltersSummary() {
//     List<String> filters = [];

//     if (_priceRange.end < 10000) {
//       filters.add('Price up to ${_priceRange.end.toInt()} LYD');
//     }

//     if (selectedCategories.isNotEmpty) {
//       filters.add('Categories: ${selectedCategories.join(', ')}');
//     }

//     if (selectedColors.isNotEmpty) {
//       filters.add('Colors: ${selectedColors.join(', ')}');
//     }

//     if (selectedBrands.isNotEmpty) {
//       filters.add('Brands: ${selectedBrands.join(', ')}');
//     }

//     return filters.isEmpty ? 'No filters applied' : filters.join(' • ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: ClipRRect(
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox(width: 40),
//                     Text(
//                       t.filter,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Error Message
//                 if (_errorMessage != null)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red.shade200),
//                     ),
//                     child: Text(
//                       _errorMessage!,
//                       style: TextStyle(
//                         color: Colors.red.shade800,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),

//                 // Filters Summary
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.shade200),
//                   ),
//                   child: Text(
//                     _getSelectedFiltersSummary(),
//                     style: TextStyle(
//                       color: Colors.blue.shade800,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),

//                 // Scrollable content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               t.refineYourSearch,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: _resetFilters,
//                               icon: const Icon(Icons.refresh),
//                               tooltip: 'Reset Filters',
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),

//                         // Price Range
//                         Text(t.priceRange, style: const TextStyle(fontSize: 16)),
//                         RangeSlider(
//                           values: _priceRange,
//                           min: 0,
//                           max: 10000,
//                           divisions: 100,
//                           labels: RangeLabels(
//                             '${_priceRange.start.toInt()}${t.lyd}',
//                             '${_priceRange.end.toInt()}${t.lyd}',
//                           ),
//                           activeColor: Colors.blue,
//                           inactiveColor: Colors.grey[300],
//                           onChanged: (values) {
//                             setState(() {
//                               _priceRange = values;
//                             });
//                           },
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('${_priceRange.start.toInt()}${t.lyd}'),
//                             Text('${_priceRange.end.toInt()}${t.lyd}'),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         // Categories
//                         _buildSection(
//                           t.categories,
//                           categories,
//                           selectedCategories,
//                         ),
//                         const SizedBox(height: 24),

//                         // Colors
//                         _buildColorSection(t),
//                         const SizedBox(height: 24),

//                         // Brands
//                         _buildSection(t.brands, brands, selectedBrands),
//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Apply button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _applyFilters,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : Text(
//                             t.applyFilters,
//                             style: const TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(
//     String title,
//     List<String> options,
//     List<String> selectedList,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(title),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((item) {
//             final isSelected = selectedList.contains(item);
//             return FilterChip(
//               label: Text(item),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     selectedList.add(item);
//                   } else {
//                     selectedList.remove(item);
//                   }
//                 });
//               },
//               selectedColor: Colors.blue.shade100,
//               checkmarkColor: Colors.blue,
//               labelStyle: TextStyle(
//                 color: isSelected ? Colors.blue : Colors.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildColorSection(AppLocalizations t) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(t.color),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 16,
//           children: colorMap.keys.map((colorName) {
//             final isSelected = selectedColors.contains(colorName);
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isSelected) {
//                     selectedColors.remove(colorName);
//                   } else {
//                     selectedColors.add(colorName);
//                   }
//                 });
//               },
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: _getColorFromName(colorName),
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected ? Colors.black : Colors.grey,
//                     width: isSelected ? 3 : 1,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, color: Colors.white, size: 16)
//                     : null,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Color _getColorFromName(String colorName) {
//     switch (colorName) {
//       case 'Blue': return Colors.blue;
//       case 'Orange': return Colors.orange;
//       case 'Pink': return Colors.pink;
//       case 'Red': return Colors.red;
//       case 'Green': return Colors.green;
//       case 'Black': return Colors.black;
//       case 'White': return Colors.white;
//       case 'Yellow': return Colors.yellow;
//       case 'Purple': return Colors.purple;
//       default: return Colors.grey;
//     }
//   }

//   Widget _buildSectionHeader(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         Text(
//           'Select',
//           style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tawasul_application/view/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _priceRange = const RangeValues(0, 10000);
  List<String> selectedCategories = [];
  List<String> selectedColors = [];
  List<String> selectedBrands = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> categories = [
    'HighTech',
    'Smart Phone',
    'Smart Office',
    'Lifestyle',
  ];

  final Map<String, String> colorMap = {
    'Blue': '0000FF',
    'Orange': 'FFA500',
    'Pink': 'FFC0CB',
    'Red': 'FF0000',
    'Green': '00FF00',
    'Black': '000000',
    'White': 'FFFFFF',
    'Yellow': 'FFFF00',
    'Purple': '800080',
  };

  final List<String> brands = [
    'Apple',
    'Xiaomi',
    'Samsung',
    'Nokia',
    'Huawei',
    'Nothing',
    'Energizer',
    'Black Shark',
    'TCL',
  ];

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 10000);
      selectedCategories.clear();
      selectedColors.clear();
      selectedBrands.clear();
      _errorMessage = null;
    });
  }

  Future<Map<String, dynamic>> _fetchFilteredProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Build query parameters
      final Map<String, String> queryParams = {};

      // Add name parameter (using first selected category or brand as search term)
      if (selectedCategories.isNotEmpty) {
        queryParams['name'] = selectedCategories.first;
      } else if (selectedBrands.isNotEmpty) {
        queryParams['name'] = selectedBrands.first;
      } else {
        queryParams['name'] = 'tv'; // Default search term
      }

      // Add price_max parameter
      queryParams['price_max'] = _priceRange.end.toInt().toString();

      // Add color parameter (convert color names to hex codes)
      if (selectedColors.isNotEmpty) {
        final colorHex = colorMap[selectedColors.first] ?? '000';
        queryParams['color'] = colorHex;
      } else {
        queryParams['color'] = '000'; // Default color code
      }

      // Add code parameter
      queryParams['code'] = '100'; // Default code as per your Postman test

      // Build URL with query parameters
      final Uri url = Uri.parse(
        'http://197.13.18.8/public/getproducts',
      ).replace(queryParameters: queryParams);

      print('API URL: $url');
      print('Query Parameters: $queryParams');

      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'success': true,
            'products': data['products'] ?? [],
            'filtersApplied': queryParams,
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch products');
        }
      } else {
        throw Exception('HTTP Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() async {
    try {
      final result = await _fetchFilteredProducts();

      if (result['success'] == true) {
        final List<dynamic> products = result['products'] ?? [];
        final Map<String, dynamic> filtersApplied =
            result['filtersApplied'] ?? {};

        // Navigate to HomePage with filtered results
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomePage(
                  filteredProducts: products,
                  appliedFilters: filtersApplied,
                ),
          ),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found ${products.length} products'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getSelectedFiltersSummary() {
    List<String> filters = [];

    if (_priceRange.end < 10000) {
      filters.add('Price up to ${_priceRange.end.toInt()} LYD');
    }

    if (selectedCategories.isNotEmpty) {
      filters.add('Categories: ${selectedCategories.join(', ')}');
    }

    if (selectedColors.isNotEmpty) {
      filters.add('Colors: ${selectedColors.join(', ')}');
    }

    if (selectedBrands.isNotEmpty) {
      filters.add('Brands: ${selectedBrands.join(', ')}');
    }

    return filters.isEmpty ? 'No filters applied' : filters.join(' • ');
  }

  Widget _buildSection(
    String title,
    List<String> options,
    List<String> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              options.map((item) {
                final isSelected = selectedList.contains(item);
                return FilterChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedList.add(item);
                      } else {
                        selectedList.remove(item);
                      }
                    });
                  },
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSection(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(t.color),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          children:
              colorMap.keys.map((colorName) {
                final isSelected = selectedColors.contains(colorName);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedColors.remove(colorName);
                      } else {
                        selectedColors.add(colorName);
                      }
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getColorFromName(colorName),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                            : null,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'Blue':
        return Colors.blue;
      case 'Orange':
        return Colors.orange;
      case 'Pink':
        return Colors.pink;
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Yellow':
        return Colors.yellow;
      case 'Purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          'Select',
          style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Text(
                      t.filter,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Filters Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    _getSelectedFiltersSummary(),
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.refineYourSearch,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Reset Filters',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Price Range
                        Text(
                          t.priceRange,
                          style: const TextStyle(fontSize: 16),
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 10000,
                          divisions: 100,
                          labels: RangeLabels(
                            '${_priceRange.start.toInt()}${t.lyd}',
                            '${_priceRange.end.toInt()}${t.lyd}',
                          ),
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey[300],
                          onChanged: (values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_priceRange.start.toInt()}${t.lyd}'),
                            Text('${_priceRange.end.toInt()}${t.lyd}'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Categories
                        _buildSection(
                          t.categories,
                          categories,
                          selectedCategories,
                        ),
                        const SizedBox(height: 24),

                        // Colors
                        _buildColorSection(t),
                        const SizedBox(height: 24),

                        // Brands
                        _buildSection(t.brands, brands, selectedBrands),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              t.applyFilters,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
}
