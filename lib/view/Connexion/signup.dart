import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tawasul_application/view/Connexion/account_validation.dart';
import 'package:tawasul_application/view/Connexion/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isChecked = false;
  bool _showPassword = false;
  String? _errorMessage;
  String? selectedCity = 'Tripoli';
  String? selectedCountry = 'Libya';
  String? selectedGender = 'male';

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(
    text: '+216 ',
  );
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  final List<String> cities = [
    'Tripoli',
    'Benghazi',
    'Ajdābiyā',
    'Misratah',
    'Al Bayḑā',
    'Al Khums',
    'Az Zāwīyah',
    'Gharyān',
    'Al Marj',
    'Tobruk',
    'Sabratah',
    'Al Jumayl',
    'Darnah',
    'Janzur',
    'Zuwarah',
    'Masallatah',
    'Surt',
    'Yafran',
    'Nalut',
    'Banī Walīd',
    'Tajura',
    'Birak',
    'Shahhat',
    'Murzuq',
    'Al Qubbah',
    'Al Azīzīyah',
    'Mizdah',
  ];

  final List<String> countries = ['Libya'];
  final List<String> genders = ['male', 'female'];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_formatPhoneNumber);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    final text = _phoneController.text;
    if (!text.startsWith('+216')) {
      _phoneController.value = _phoneController.value.copyWith(
        text: '+216 ${text.replaceAll(RegExp(r'[^0-9]'), '')}',
        selection: TextSelection.collapsed(offset: '+216 '.length),
      );
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final cleanNumber = value.replaceAll(' ', '');
    if (!cleanNumber.startsWith('+216')) {
      return 'Libyan number must start with +216';
    }
    if (cleanNumber.length < 11) {
      return 'Phone number must be at least 9 digits after +216';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain number';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain special character';
    }
    return null;
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isChecked) {
      setState(() => _errorMessage = 'Please accept terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse("http://t-api.dotit-corp.com/api/public/register");

      String? formattedBirthday;
      if (_birthdateController.text.isNotEmpty) {
        final parsedDate = DateFormat(
          'dd/MM/yyyy',
        ).parse(_birthdateController.text);
        formattedBirthday = DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      final body = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "phone": _phoneController.text.replaceAll(' ', ''),
        "mobile": _phoneController.text.replaceAll(' ', ''),
        "city": selectedCity ?? "",
        "country": selectedCountry ?? "Libya",
        "gender": selectedGender ?? "male",
        "birthday": formattedBirthday ?? "1990-01-01",
      };

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["result"] == "success") {
        // ✅ Check if token is returned
        if (data["token"] != null) {
          await _storage.write(key: "auth_token", value: data["token"]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AccountValidation()),
          );
        } else {
          // 🔄 No token from signup → call login to get it
          await _loginAfterSignup(
            _emailController.text.trim(),
            _passwordController.text,
          );
        }
      } else {
        setState(() {
          _errorMessage = data["ResponseMsg"] ?? "Registration failed";
        });
      }
    } on SocketException {
      setState(() => _errorMessage = "No internet connection");
    } on HttpException {
      setState(() => _errorMessage = "Couldn't reach the server");
    } on TimeoutException {
      setState(() => _errorMessage = "Request timed out");
    } catch (e) {
      setState(() => _errorMessage = "Unexpected error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginAfterSignup(String email, String password) async {
    final loginUrl = Uri.parse("http://t-api.dotit-corp.com/api/public/login");
    final loginResponse = await http.post(
      loginUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": email, // API expects "username" not "email"
        "password": password,
      }),
    );

    final loginData = jsonDecode(loginResponse.body);

    if (loginResponse.statusCode == 200 && loginData["token"] != null) {
      await _storage.write(key: "auth_token", value: loginData["token"]);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccountValidation()),
      );
    } else {
      setState(() {
        _errorMessage = loginData["ResponseMsg"] ?? "Login after signup failed";
      });
    }
  }

  String _handleErrorResponse(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return "Invalid registration data";
      case 401:
        return "Unauthorized request";
      case 409:
        return "User already exists";
      case 500:
        try {
          final data = jsonDecode(response.body);
          return data["message"] ?? "Server error. Please try again later.";
        } catch (_) {
          return "Server error. Please try again later.";
        }
      default:
        return "Error: ${response.statusCode}";
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select birthdate',
      fieldLabelText: 'Birthdate',
      fieldHintText: 'Month/Day/Year',
    );

    if (picked != null) {
      setState(() {
        _birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
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
          "Create your account",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),

                // Logo
                Center(
                  child: Image.asset(
                    "assets/images/tawasul_logo.png",
                    height: 84.5.h,
                    width: 84.w,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.account_circle, size: 80.sp),
                  ),
                ),

                // Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Please enter all mandatory information to\ncreate an account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF3E3E3E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                SizedBox(height: 8.h),

                // First Name
                _buildTextField(
                  "First name *",
                  Icons.person,
                  controller: _firstNameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'First name is required'
                              : null,
                ),
                SizedBox(height: 20.h),

                // Last Name
                _buildTextField(
                  "Last name *",
                  Icons.person,
                  controller: _lastNameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Last name is required'
                              : null,
                ),
                SizedBox(height: 20.h),

                // Email
                _buildTextField(
                  "Email *",
                  Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: 20.h),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: "Password *",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF515C6F),
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    "Phone number *",
                    Icons.phone,
                  ),
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 20.h),

                // City
                _buildDropdown(
                  label: "City *",
                  value: selectedCity,
                  items: cities,
                  onChanged: (value) => setState(() => selectedCity = value),
                ),
                SizedBox(height: 20.h),

                // Country Dropdown
                _buildDropdown(
                  label: "Country *",
                  value: selectedCountry,
                  items: countries,
                  onChanged: (value) => setState(() => selectedCountry = value),
                ),
                SizedBox(height: 20.h),

                // Gender Dropdown
                _buildDropdown(
                  label: "Gender *",
                  value: selectedGender,
                  items: genders,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),
                SizedBox(height: 20.h),

                // Birthdate
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      "Birthdate (Optional)",
                      Icons.calendar_today,
                      controller: _birthdateController,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      activeColor: Color(0xFFF39C12),
                      onChanged:
                          (value) =>
                              setState(() => _isChecked = value ?? false),
                    ),
                    Expanded(
                      child: Text(
                        "I accept the terms and conditions and privacy policy",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Create Account Button
                Center(
                  child: SizedBox(
                    width: 320.w,
                    height: 45.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF008AD2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: _isLoading ? null : _registerUser,
                      child:
                          _isLoading
                              ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.w,
                                ),
                              )
                              : Text(
                                "Create account",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Login Link
                Center(
                  child: GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        ),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      suffixIcon: Icon(icon, color: Color(0xFF515C6F), size: 20.sp),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _buildInputDecoration(label, icon),
      enabled: !_isLoading,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            value: value,
            items:
                items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: _isLoading ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
