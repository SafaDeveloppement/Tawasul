import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tawasul_application/Services/user_data_services.dart';
import 'package:tawasul_application/view/Connexion/account_validation.dart';
import 'package:tawasul_application/view/Connexion/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? selectedCity;
  String? selectedGender = 'male';
  bool _isFormatting = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  final FocusNode _phoneFocusNode = FocusNode();

  final List<String> countries = ['Libya'];
  final List<String> genders = ['male', 'female'];

  Map<String, String> getGenderLabels(AppLocalizations t) {
    return {'male': t.male, 'female': t.female};
  }

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
    _phoneFocusNode.addListener(_onPhoneFocusChange);
  }

  void _onPhoneFocusChange() {
    // Handle focus changes if needed
  }

  @override
  void dispose() {
    _phoneController.removeListener(_formatPhoneNumber);
    _phoneFocusNode.removeListener(_onPhoneFocusChange);
    _phoneFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _storeUserData() async {
    try {
      await UserDataService.storeUserData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _cleanPhoneNumber(_phoneController.text),
        email: _emailController.text.trim(),
      );
      print("User data stored successfully");
    } catch (e) {
      print("Error storing user data: $e");
    }
  }

  String _cleanPhoneNumber(String phone) {
    // Remove all non-digit characters and return only digits
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  void _formatPhoneNumber() {
    if (_isFormatting) return;
    _isFormatting = true;

    try {
      String text = _phoneController.text;
      int cursorPosition = _phoneController.selection.base.offset;

      String digits = text.replaceAll(RegExp(r'[^\d]'), '');

      if (digits.length > 8) {
        digits = digits.substring(0, 8);
      }

      if (text != digits) {
        _phoneController.text = digits;

        int newCursorPosition = cursorPosition;
        if (newCursorPosition > digits.length) {
          newCursorPosition = digits.length;
        }
        _phoneController.selection = TextSelection.collapsed(
          offset: newCursorPosition,
        );
      }
    } finally {
      _isFormatting = false;
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.phoneNumberIsRequired;
    }

    final digits = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length != 8) {
      return 'Phone number must be 8 digits';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailIsRequired;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordIsRequired;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain number';
    }
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
      final url = Uri.parse("http://tawasul-dev.app-staging.fr/public/register-check");

      String? formattedBirthday;
      if (_birthdateController.text.isNotEmpty) {
        try {
          final parsedDate = DateFormat(
            'dd/MM/yyyy',
          ).parse(_birthdateController.text);
          formattedBirthday = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid date format. Use DD/MM/YYYY';
          });
          return;
        }
      }

      // Convert gender from 'male'/'female' to '1'/'2'
      String genderValue = '1'; // default to male
      if (selectedGender == 'female') {
        genderValue = '2';
      }

      // Extract ONLY the digits
      String cleanPhone = _phoneController.text.replaceAll(
        RegExp(r'[^\d]'),
        '',
      );

      // Ensure we have exactly 8 digits
      if (cleanPhone.length != 8) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Phone number must be 8 digits';
        });
        return;
      }

      print("Phone entered: $cleanPhone");
      print("Phone length: ${cleanPhone.length}");

      // Create form data
      var request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['email'] = _emailController.text.trim();
      request.fields['lastname'] = _lastNameController.text.trim();
      request.fields['firstname'] = _firstNameController.text.trim();
      request.fields['password'] = _passwordController.text;
      request.fields['mobile'] =
          cleanPhone; // Use ONLY the 8-digit local number
      request.fields['gender'] = genderValue;

      // Only add birthday if it's not null
      if (formattedBirthday != null && formattedBirthday.isNotEmpty) {
        request.fields['birthday'] = formattedBirthday;
      }

      print("=== API REQUEST ===");
      print("URL: $url");
      print("Fields: ${request.fields}");

      // Send the request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      print("=== API RESPONSE ===");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final String verificationCode = data["code"]?.toString().trim() ?? "";

          if (verificationCode.isEmpty) {
            setState(() {
              _errorMessage = "No verification code received from server";
            });
            return;
          } 

          // Store user data and verification code
          await _storeUserData();
          await _storage.write(
            key: "verification_code",
            value: verificationCode,
          );
          await _storage.write(
            key: "user_email",
            value: _emailController.text.trim(),
          );
          await _storage.write(key: "user_phone", value: cleanPhone);

          print(" Verification code received: $verificationCode");
          print(" Stored email: ${_emailController.text.trim()}");
          print(" Stored phone: $cleanPhone");

          // Show debug dialog with code (for testing)
          _showDebugDialog(verificationCode);

          // Navigate to Account Validation screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AccountValidation(
                    email: _emailController.text.trim(),
                    phone: cleanPhone,
                    verificationCode: verificationCode,
                  ),
            ),
          );
        } else {
          setState(() {
            _errorMessage = data["message"] ?? "Registration failed";
          });
        }
      } else {
        // Try to parse error response
        try {
          final data = jsonDecode(response.body);
          setState(() {
            _errorMessage =
                data["message"] ?? "HTTP Error ${response.statusCode}";
          });
        } catch (e) {
          setState(() {
            _errorMessage =
                "HTTP Error ${response.statusCode} - Invalid response format";
          });
        }
      }
    } on SocketException {
      setState(() => _errorMessage = "No internet connection");
    } on TimeoutException {
      setState(() => _errorMessage = "Request timed out. Please try again.");
    } on FormatException {
      setState(() => _errorMessage = "Invalid server response format");
    } catch (e) {
      setState(() => _errorMessage = "Unexpected error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDebugDialog(String verificationCode) {
    // Show the code in a dialog for debugging purposes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text("Debug Information"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Verification Code: $verificationCode"),
                  SizedBox(height: 10),
                  Text("Phone: ${_phoneController.text}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    });
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
    final t = AppLocalizations.of(context)!;
    final genderLabels = getGenderLabels(t);
    final bool isRTL = Directionality.of(context) == TextDirection.RTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 12.w),
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
          t.createYourAccount,
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
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),

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
                        t.createYourAccount,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        t.pleaseEnterAllMandatoryInformationToCreateAnAccount,
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
                  t.firstName,
                  Icons.person,
                  controller: _firstNameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true ? t.firstNameIsRequired : null,
                ),
                SizedBox(height: 20.h),

                // Last Name
                _buildTextField(
                  t.lastName,
                  Icons.person,
                  controller: _lastNameController,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true ? t.lastNameIsRequired : null,
                ),
                SizedBox(height: 20.h),

                // Email
                _buildTextField(
                  t.email,
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
                    labelText: "${t.password} *",
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

                // Phone Number Field - Now accepts only 8 digits without prefix
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  decoration: _buildInputDecoration(
                    "${t.phoneNumber} *",
                    Icons.phone,
                  ),
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 20.h),

                _buildGenderDropdown(
                  label: "${t.gender} *",
                  value: selectedGender,
                  items: genders,
                  genderLabels: genderLabels,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),
                SizedBox(height: 20.h),

                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      "${t.birthday} ",
                      Icons.calendar_today,
                      controller: _birthdateController,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

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
                        t.iAcceptTheTerms,
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
                                t.createAccount,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Social signup section
                Column(
                  children: [
                    Text(
                      t.orSignupWith,
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
                            SnackBar(content: Text(t.googleSignupComingSoon)),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Color(0xFF7A1912),
                        ),
                        label: Text(
                          t.signupWithGoogle,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

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
                            SnackBar(content: Text(t.facebookSignupComingSoon)),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.white,
                        ),
                        label: Text(
                          t.signupWithFacebook,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        text: "${t.newClient} ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: t.login,
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

  Widget _buildGenderDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Map<String, String> genderLabels,
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
                items.map((String genderKey) {
                  return DropdownMenuItem<String>(
                    value: genderKey,
                    child: Text(genderLabels[genderKey] ?? genderKey),
                  );
                }).toList(),
            onChanged: _isLoading ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
