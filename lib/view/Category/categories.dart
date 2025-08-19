import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/view/Category/high_tech.dart';
import 'package:tawasul_application/view/Category/lifestyle.dart';
import 'package:tawasul_application/view/Category/smart_home.dart';
import 'package:tawasul_application/view/Category/smart_office.dart';
import 'package:tawasul_application/view/navbar.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _currentNavIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'HighTech',
      'image': 'assets/images/high_tech.png',
      'page': HighTech(),
    },
    {
      'title': 'Smart Home',
      'image': 'assets/images/smart_home.png',
      'page': SmartHome(),
    },
    {
      'title': 'Smart Office',
      'image': 'assets/images/smart_office.png',
      'page': SmartOffice(),
    },
    {
      'title': 'Lifestyle',
      'image': 'assets/images/lifestyle.png',
      'page': LifeStyle(),
    },
  ];

  void _navigateToCategory(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 41,
                          height: 41,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF008AD2),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0984E3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.search,
                            size: 28,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  category['image']!,
                                  width: 100.w,
                                  height: 90.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category['title']!,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 9.w),
                                    SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed:
                                            () => _navigateToCategory(
                                              category['page']!,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color(
                                            0xFFF1F1F1,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'See all',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            left: 20,
            right: 20,
            child: Consumer<ProductController>(
              builder: (context, productController, child) {
                return CustomBottomNavBar(
                  currentIndex: _currentNavIndex,
                  context: context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
