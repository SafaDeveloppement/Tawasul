import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_number.dart';
import 'package:tawasul_application/view/Connexion/signup.dart';
import 'package:tawasul_application/view/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> countries = ['Libya'];

  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final t = AppLocalizations.of(context)!;

    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showError(t.pleaseEnterUsernameAndPassword);
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result['success'] == true) {
        await _storage.write(key: "auth_token", value: result['token']);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt(
          'user_id',
          result['user']?['id'] ?? 1,
        ); // Adjust based on your API
        await prefs.setString(
          'user_email',
          result['user']?['email'] ?? _usernameController.text.trim(),
        );
        await _storeUserDataFromLogin();

        // Show success message with response body
        _showSuccess("Login successful! Token: ${result['token']}");

        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        _showError(result['message'] ?? "Login failed");
      }
    } catch (e) {
      _showError("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _storeUserDataFromLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // You might need to adjust this based on what your login API returns
      // If the API returns user data, store it here
      // For now, we'll just store the email
      await prefs.setString('user_email', _usernameController.text.trim());

      print("User email stored from login");
    } catch (e) {
      print("Error storing user data from login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
          t.login,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/tawasul_logo.png",
                  height: 84.5,
                  width: 84,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.account_circle, size: 80),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      t.connexion,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      t.pleaseEnterYourInformationsToConnectToYourAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3E3E3E),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                t.username,
                Icons.person,
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),
              _buildTextField(
                t.password,
                Icons.lock,
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 320.w,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008AD2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: isLoading ? null : _login,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              t.login,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordNumber(),
                    ),
                  );
                },
                child: Text(
                  t.forgotPassword,
                  style: TextStyle(
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationThickness: 0.7,
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Social signup section
              Column(
                children: [
                  Text(
                    t.orLoginWith,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 15.h),

                  // Google Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.googleLoginComingSoon)),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Color(0xFF7A1912),
                      ),
                      label: Text(
                        t.loginWithGoogle,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Facebook Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.facebookLoginComingSoon)),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      label: Text(
                        t.loginWithFacebook,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),
              Divider(color: const Color(0xFFE2E3E8)),
              SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: t.newClient,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: t.createYourAccount,
                          style: TextStyle(
                            color: Color(0xFFF39C12),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: Icon(icon, color: const Color(0xFF515C6F), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
    );
  }
}
