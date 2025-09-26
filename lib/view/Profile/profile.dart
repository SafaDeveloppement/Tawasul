import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/controller/product_controller.dart';
import 'package:tawasul_application/main.dart';
import 'package:tawasul_application/view/Connexion/change_password.dart';
import 'package:tawasul_application/view/Profile/edit_profile.dart';
import 'package:tawasul_application/view/Profile/order_history.dart';
import 'package:tawasul_application/view/favorites.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:tawasul_application/view/navbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentNavIndex = 4;
  String _firstName = "Loading...";
  String _lastName = "";
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _customerData;

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
  }

  Future<void> _loadCustomerDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final customerDetails = await ApiService.getCustomerDetails();

      if (customerDetails != null && mounted) {
        setState(() {
          _customerData = customerDetails;
          // Extract first name and last name from the API response
          // Based on signup.dart, the API uses "firstName" and "lastName" (lowercase with capital F and L)
          _firstName =
              customerDetails['firstName'] ??
              customerDetails['first_name'] ??
              'Customer';
          _lastName =
              customerDetails['lastName'] ?? customerDetails['last_name'] ?? '';
        });
      } else {
        setState(() {
          _hasError = true;
          _firstName = "Unknown";
          _lastName = "User";
        });
      }
    } catch (e) {
      print("Error loading customer details: $e");
      setState(() {
        _hasError = true;
        _firstName = "Error";
        _lastName = "Loading";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.rtl ? 0 : 12.w,
            right: Directionality.of(context) == TextDirection.rtl ? 12.w : 0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Color(0xFF008AD2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          loc.profile,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 180,
                  ),
                  child: Column(
                    children: [
                      // Text(
                      //   '$_firstName $_lastName',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: "Montserrat",
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(height: 24),

                      // Navigation Menu Items
                      _buildMenuItem(
                        Icons.person,
                        loc.editProfile,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.favorite_border,
                        loc.favorites,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.shopping_bag_outlined,
                        loc.orderHistory,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderHistory(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.lock_outline,
                        loc.changePassword,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(),
                            ),
                          );
                        },
                      ),

                      _buildMenuItem(
                        Icons.language,
                        loc.language,
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                      ),

                      _buildMenuItem(
                        Icons.logout,
                        loc.logout,
                        isLogout: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text(loc.logout),
                                  content: Text(loc.logoutConfirmation),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(loc.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.popUntil(
                                          context,
                                          (route) => route.isFirst,
                                        );
                                      },
                                      child: Text(
                                        loc.logout,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 2.h,
            left: 20.w,
            right: 20.w,
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

  /// Language Switcher Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.chooseLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("English"),
                  onTap: () {
                    _setLocale(const Locale("en"));
                  },
                ),
                ListTile(
                  title: const Text("العربية"),
                  onTap: () {
                    _setLocale(const Locale("ar"));
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _setLocale(Locale locale) {
    Navigator.pop(context); // close dialog
    setState(() {
      // update locale globally
      MyApp.setLocale(context, locale);
    });
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.red : Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
