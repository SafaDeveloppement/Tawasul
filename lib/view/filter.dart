// import 'package:flutter/material.dart';
// import 'package:tawasul_application/view/home_page.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({super.key});

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   RangeValues _priceRange = const RangeValues(0, 10000);
//   List<String> selectedCategories = ['Mobile'];
//   List<String> selectedColors = [];
//   List<String> selectedBrands = [];

//   final List<String> categories = [
//     'HighTech',
//     'Smart Phone',
//     'Smart Office',
//     'Lifestyle',
//   ];
//   final Map<String, Color> colorMap = {
//     'Blue': Colors.blue,
//     'Orange': Colors.orange,
//     'Pink': Colors.pink,
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
//       _priceRange = const RangeValues(462, 9246);
//       selectedCategories.clear();
//       selectedColors.clear();
//       selectedBrands.clear();
//     });
//   }

//   // void _applyFilters() {
//   //   print("Price: ${_priceRange.start} - ${_priceRange.end}");
//   //   print("Categories: $selectedCategories");
//   //   print("Colors: $selectedColors");
//   //   print("Brands: $selectedBrands");

//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: ClipRRect(
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(20),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Filtres',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Refine Your Search',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: _resetFilters,
//                         icon: const Icon(Icons.refresh),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Price Range', style: TextStyle(fontSize: 16)),
//                   RangeSlider(
//                     values: _priceRange,
//                     min: 0,
//                     max: 10000,
//                     activeColor: Colors.blue,
//                     inactiveColor: Colors.grey[300],
//                     onChanged: (values) {
//                       setState(() {
//                         _priceRange = values;
//                       });
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('${_priceRange.start.toInt()}LYD'),
//                       Text('${_priceRange.end.toInt()}LYD'),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   _buildSection('Category', categories, selectedCategories),
//                   const SizedBox(height: 24),
//                   _buildColorSection(),
//                   const SizedBox(height: 24),
//                   _buildSection('Brand', brands, selectedBrands),
//                   const SizedBox(height: 30),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomePage()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Apply filters',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
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
//           children:
//               options.map((item) {
//                 final isSelected = selectedList.contains(item);
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isSelected
//                           ? selectedList.remove(item)
//                           : selectedList.add(item);
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color:
//                           isSelected
//                               ? Colors.blue.shade50
//                               : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: isSelected ? Colors.blue : Colors.transparent,
//                         width: 1.5,
//                       ),
//                     ),
//                     child: Text(
//                       item,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isSelected ? Colors.blue : Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildColorSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader('Color'),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 16,
//           children:
//               colorMap.keys.map((colorName) {
//                 final isSelected = selectedColors.contains(colorName);
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isSelected
//                           ? selectedColors.remove(colorName)
//                           : selectedColors.add(colorName);
//                     });
//                   },
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: colorMap[colorName],
//                       shape: BoxShape.circle,
//                       border:
//                           isSelected
//                               ? Border.all(color: Colors.black, width: 2)
//                               : null,
//                     ),
//                   ),
//                 );
//               }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const Text(
//           'Select',
//           style: TextStyle(fontSize: 14, color: Colors.blue),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tawasul_application/view/home_page.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _priceRange = const RangeValues(0, 10000);
  List<String> selectedCategories = ['Mobile'];
  List<String> selectedColors = [];
  List<String> selectedBrands = [];

  final List<String> categories = [
    'HighTech',
    'Smart Phone',
    'Smart Office',
    'Lifestyle',
  ];
  final Map<String, Color> colorMap = {
    'Blue': Colors.blue,
    'Orange': Colors.orange,
    'Pink': Colors.pink,
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
      _priceRange = const RangeValues(462, 9246);
      selectedCategories.clear();
      selectedColors.clear();
      selectedBrands.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // For balance
                    Text(
                      'Filtres',
                      style: TextStyle(
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
                              'Refine Your Search',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Price Range',
                          style: TextStyle(fontSize: 16),
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 0,
                          max: 10000,
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
                            Text('${_priceRange.start.toInt()}LYD'),
                            Text('${_priceRange.end.toInt()}LYD'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildSection(
                          'Category',
                          categories,
                          selectedCategories,
                        ),
                        const SizedBox(height: 24),
                        _buildColorSection(),
                        const SizedBox(height: 24),
                        _buildSection('Brand', brands, selectedBrands),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply filters',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? selectedList.remove(item)
                          : selectedList.add(item);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.blue.shade50
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Color'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          children:
              colorMap.keys.map((colorName) {
                final isSelected = selectedColors.contains(colorName);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? selectedColors.remove(colorName)
                          : selectedColors.add(colorName);
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorMap[colorName],
                      shape: BoxShape.circle,
                      border:
                          isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Text(
          'Select',
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ],
    );
  }
}
