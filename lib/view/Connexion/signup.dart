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
import 'package:tawasul_application/view/Connexion/creation_account_success.dart';
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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  List<String> getCities(AppLocalizations t) {
    return [
      t.tripoli,
      t.benghazi,
      t.misrata,
      t.bayda,
      t.zawiya,
      t.gharyan,
      t.tobruk,
      t.ajdabiya,
      t.zleiten,
      t.derna,
      t.sirte,
      t.sabha,
      t.khoms,
      t.bani_walid,
      t.sabratha,
      t.zuwara,
      t.kufra,
      t.marj,
      t.tocra,
      t.tarhuna,
      t.msallata,
      t.jumayl,
      t.sorman,
      t.al_gseibat,
      t.shahat,
      t.ubari,
      t.asbia,
      t.jadid,
      t.waddan,
      t.el_agheila,
      t.abyar,
      t.nofaliya,
      t.regdalin,
      t.gasr_akhyar,
      t.al_qubah,
      t.tawergha,
      t.al_maya,
      t.murzuk,
      t.brega,
      t.teghsat,
      t.hun,
      t.jalu,
      t.ajaylat,
      t.nalut,
      t.suluq,
      t.shuhada_al_buerat,
      t.zaltan,
      t.mizda,
      t.ras_lanuf,
      t.al_urban,
      t.yafran,
      t.ar_rayaniya,
      t.umm_al_rizam,
      t.taucheira,
      t.brak,
      t.abu_ghlasha,
      t.ad_dawoon,
      t.teji,
      t.qaminis,
      t.qatrun,
      t.benina,
      t.kikla,
      t.al_rheibat,
      t.sokna,
      t.massa,
      t.bin_jawad,
      t.umm_al_aranib,
      t.jadu,
      t.gadames,
      t.ar_rabta,
      t.ghat,
      t.al_abraq,
      t.sidi_as_said,
      t.ar_rajban,
      t.awjila,
      t.ras_al_hamam,
      t.tolmeita,
      t.zella,
      t.wadi_utba,
      t.al_barkat,
      t.martuba,
      t.traghan,
      t.al_hashan,
      t.el_bayyada,
      t.qayqab,
      t.mashashita,
      t.bu_fakhra,
      t.musaid,
      t.tacnis,
      t.susa,
      t.wadi_zem_zem,
      t.batta,
      t.tazirbu,
      t.farzougha,
      t.qaryat_umar_al_mukhtar,
      t.bir_al_ashhab,
    ];
  }

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
    // Set initial phone value with +216
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_phoneController.text.isEmpty) {
        _phoneController.text = '+216 ';
        _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length),
        );
      }
    });
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

  Future<void> _storeUserData() async {
    try {
      await UserDataService.storeUserData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.replaceAll(' ', ''),
        email: _emailController.text.trim(),
      );

      print("User data stored successfully");
    } catch (e) {
      print("Error storing user data: $e");
    }
  }

  void _formatPhoneNumber() {
    final text = _phoneController.text;

    if (text.isEmpty || text == '+216') return;

    if (text.length < 5 && text.startsWith('+216')) {
      _phoneController.text = '+216 ';
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
      return;
    }

    if (!text.startsWith('+216')) {
      _phoneController.text = '+216 ' + text.replaceAll(RegExp(r'[^0-9]'), '');
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
      return;
    }

    final prefix = '+216';
    String numberPart = text.substring(4).replaceAll(RegExp(r'[^0-9]'), '');

    if (numberPart.length > 8) {
      numberPart = numberPart.substring(0, 8);
    }

    String formatted = prefix;
    if (numberPart.isNotEmpty) {
      formatted += ' ' + numberPart;

      if (numberPart.length > 2) {
        formatted = formatted.substring(0, 7) + ' ' + formatted.substring(7);
      }

      if (numberPart.length > 5) {
        formatted = formatted.substring(0, 10) + ' ' + formatted.substring(10);
      }
    }

    if (text != formatted) {
      _phoneController.value = _phoneController.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.phoneNumberIsRequired;
    }

    final cleanNumber = value.replaceAll(' ', '');
    if (!cleanNumber.startsWith('+216')) {
      return 'Libyan number must start with +216';
    }

    // Check if we have exactly 8 digits after +216
    final digitsAfterPrefix = cleanNumber
        .substring(4)
        .replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsAfterPrefix.length != 8) {
      return 'Phone number must have 8 digits after +216';
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

  // Future<void> _registerUser() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (!_isChecked) {
  //     setState(() => _errorMessage = 'Please accept terms and conditions');
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     final url = Uri.parse("http://t-api.dotit-corp.com/api/public/register");

  //     String? formattedBirthday;
  //     if (_birthdateController.text.isNotEmpty) {
  //       try {
  //         final parsedDate = DateFormat(
  //           'dd/MM/yyyy',
  //         ).parse(_birthdateController.text);
  //         formattedBirthday = DateFormat('yyyy-MM-dd').format(parsedDate);
  //       } catch (e) {
  //         setState(() {
  //           _isLoading = false;
  //           _errorMessage = 'Invalid date format. Use DD/MM/YYYY';
  //         });
  //         return;
  //       }
  //     }

  //     final body = {
  //       "firstName": _firstNameController.text.trim(),
  //       "lastName": _lastNameController.text.trim(),
  //       "email": _emailController.text.trim(),
  //       "password": _passwordController.text,
  //       "mobile": _phoneController.text.replaceAll(' ', ''),
  //       "city": selectedCity ?? "",
  //       "gender": selectedGender ?? "male",
  //       "birthday": formattedBirthday,
  //     };

  //     body.removeWhere(
  //       (key, value) => value == null || value.toString().isEmpty,
  //     );

  //     print("Request Body: ${jsonEncode(body)}");

  //     final response = await http
  //         .post(
  //           url,
  //           headers: {"Content-Type": "application/json"},
  //           body: jsonEncode(body),
  //         )
  //         .timeout(const Duration(seconds: 30));

  //     final data = jsonDecode(response.body);

  //     print("Response Status: ${response.statusCode}");
  //     print("Response Body: $data");

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       if (data["token"] != null) {
  //         await _storage.write(key: "auth_token", value: data["token"]);
  //         await _storeUserData();

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => AccountCreatedSuccess()),
  //         );
  //       } else if (data["success"] == true || data["status"] == "success") {
  //         await _loginAfterSignup(
  //           _emailController.text.trim(),
  //           _passwordController.text,
  //         );
  //       } else {
  //         setState(() {
  //           _errorMessage =
  //               data["message"] ??
  //               data["ResponseMsg"] ??
  //               "Registration successful but no token received";
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _errorMessage =
  //             data["message"] ??
  //             data["error"] ??
  //             data["ResponseMsg"] ??
  //             "Registration failed with status ${response.statusCode}";
  //       });
  //     }
  //   } on SocketException {
  //     setState(() => _errorMessage = "No internet connection");
  //   } on HttpException {
  //     setState(() => _errorMessage = "Couldn't reach the server");
  //   } on TimeoutException {
  //     setState(() => _errorMessage = "Request timed out");
  //   } catch (e) {
  //     setState(() => _errorMessage = "Unexpected error: $e");
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

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

      final body = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "mobile": _phoneController.text.replaceAll(' ', ''),
        "city": selectedCity ?? "",
        "gender": selectedGender ?? "male",
        "birthday": formattedBirthday,
      };

      body.removeWhere(
        (key, value) => value == null || value.toString().isEmpty,
      );

      print("Request Body: ${jsonEncode(body)}");

      ///how to print the response

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      print("Response Status: ${response.statusCode}");
      print("Response Body: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to AccountCreatedSuccess on successful registration
        await _storeUserData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountCreatedSuccess()),
        );
      } else {
        setState(() {
          _errorMessage =
              data["message"] ??
              data["error"] ??
              data["ResponseMsg"] ??
              "Registration failed with status ${response.statusCode}";
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
    try {
      final loginResponse = await http
          .post(
            loginUrl,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 30));

      final loginData = jsonDecode(loginResponse.body);

      if (loginResponse.statusCode == 200 && loginData["token"] != null) {
        await _storage.write(key: "auth_token", value: loginData["token"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountValidation()),
        );
      } else {
        setState(() {
          _errorMessage =
              loginData["message"] ??
              loginData["ResponseMsg"] ??
              "Registration successful but automatic login failed";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Registration successful but login failed: $e";
      });
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
    final t = AppLocalizations.of(context)!;
    final cities = getCities(t);
    final genderLabels = getGenderLabels(t);

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
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    "${t.phoneNumber} *",
                    Icons.phone,
                  ),
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 20.h),
                _buildDropdown(
                  label: "${t.city} *",
                  value: selectedCity,
                  items: cities,
                  onChanged: (value) => setState(() => selectedCity = value),
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
                      "${t.birthday} (${t.optional})",
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
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: _isLoading ? null : onChanged,
          ),
        ),
      ],
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
