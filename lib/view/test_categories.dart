// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Category',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const CategoryScreen(),
//     );
//   }
// }

// // Data Models
// class Category {
//   final String id;
//   final String parentId;
//   final String name;
//   final String code;
//   final String productLimit;
//   final String isAlcohol;
//   final String image;
//   final List<Category> childs;

//   Category({
//     required this.id,
//     required this.parentId,
//     required this.name,
//     required this.code,
//     required this.productLimit,
//     required this.isAlcohol,
//     required this.image,
//     required this.childs,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     var childsList = json['childs'] as List?;
//     return Category(
//       id: json['id'] ?? '',
//       parentId: json['parent_id'] ?? '',
//       name: json['name'] ?? '',
//       code: json['code'] ?? '',
//       productLimit: json['productLimit'] ?? '',
//       isAlcohol: json['isAlcohol'] ?? '',
//       image: json['image'] ?? '',
//       childs: childsList != null
//           ? childsList.map((i) => Category.fromJson(i)).toList()
//           : [],
//     );
//   }
// }

// class ApiResponse {
//   final String message;
//   final List<Category> response;

//   ApiResponse({required this.message, required this.response});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     var responseList = json['response'] as List;
//     return ApiResponse(
//       message: json['message'] ?? '',
//       response: responseList.map((i) => Category.fromJson(i)).toList(),
//     );
//   }
// }

// // API Service
// class ApiService {
//   static const String baseUrl = 'http://t-api.dotit-corp.com/api/public';

//   static Future<ApiResponse> getCategories() async {
//     final response = await http.get(Uri.parse('$baseUrl/getCategories'));
    
//     if (response.statusCode == 200) {
//       return ApiResponse.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
// }

// // Main Screen
// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   late Future<ApiResponse> futureCategories;

//   @override
//   void initState() {
//     super.initState();
//     futureCategories = ApiService.getCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Categories'),
//       ),
//       body: FutureBuilder<ApiResponse>(
//         future: futureCategories,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // Find the "Accueil" category which contains our four main categories
//             final accueilCategory = snapshot.data!.response
//                 .firstWhere((category) => category.name == "Accueil");
            
//             // Extract the four main categories
//             final highTechCategory = accueilCategory.childs
//                 .firstWhere((category) => category.name == "HighTech");
//             final smartHomeCategory = accueilCategory.childs
//                 .firstWhere((category) => category.name == "Smart Home");
//             final smartOfficeCategory = accueilCategory.childs
//                 .firstWhere((category) => category.name == "Smart Office");
//             final lifestyleCategory = accueilCategory.childs
//                 .firstWhere((category) => category.name == "Lifestyle");
            
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // HighTech Widget
//                   CategoryWidget(
//                     category: highTechCategory,
//                     color: Colors.blue[100]!,
//                   ),
                  
//                   // Smart Home Widget
//                   CategoryWidget(
//                     category: smartHomeCategory,
//                     color: Colors.green[100]!,
//                   ),
                  
//                   // Smart Office Widget
//                   CategoryWidget(
//                     category: smartOfficeCategory,
//                     color: Colors.orange[100]!,
//                   ),
                  
//                   // Lifestyle Widget
//                   CategoryWidget(
//                     category: lifestyleCategory,
//                     color: Colors.purple[100]!,
//                   ),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("${snapshot.error}"),
//             );
//           }
          
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }

// // Individual Category Widget
// class CategoryWidget extends StatelessWidget {
//   final Category category;
//   final Color color;

//   const CategoryWidget({
//     super.key,
//     required this.category,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ExpansionTile(
//         leading: category.image.isNotEmpty
//             ? Image.network(
//                 category.image,
//                 width: 40,
//                 height: 40,
//                 errorBuilder: (context, error, stackTrace) => 
//                     const Icon(Icons.category),
//               )
//             : const Icon(Icons.category),
//         title: Text(
//           category.name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: category.childs.map((subCategory) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: ExpansionTile(
//               title: Text(subCategory.name),
//               children: subCategory.childs.map((item) {
//                 return Padding(
//                   padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
//                   child: ListTile(
//                     title: Text(item.name),
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }