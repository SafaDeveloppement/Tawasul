// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';
// // import 'package:tawasul_application/view/home_page.dart';

// // class ChangePassword extends StatefulWidget {
// //   const ChangePassword({Key? key}) : super(key: key);

// //   @override
// //   State<ChangePassword> createState() => _ChangePasswordState();
// // }

// // class _ChangePasswordState extends State<ChangePassword> {
// //   bool isChecked = false;
// //   String? selectedCountry;
// //   final TextEditingController _oldpasswordController = TextEditingController();

// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _confirmpasswordController =
// //       TextEditingController();

// //   final List<String> countries = ['Libya'];

// //   @override
// //   void dispose() {
// //     _passwordController.dispose();
// //     _confirmpasswordController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
// //         elevation: 0,
// //         toolbarHeight: 56.h,
// //         leadingWidth: 48.w,
// //         leading: Padding(
// //           padding: EdgeInsets.only(left: 12.w),
// //           child: GestureDetector(
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => ForgotPasswordEmail()),
// //               );
// //             },
// //             child: Container(
// //               width: 36.w,
// //               height: 36.w,
// //               decoration: const BoxDecoration(
// //                 color: Color(0xFF008AD2),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Center(
// //                 child: Icon(
// //                   Icons.arrow_back_ios_new,
// //                   color: Colors.white,
// //                   size: 18.sp,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         title: Text(
// //           "Change password",
// //           style: TextStyle(
// //             fontSize: 18.sp,
// //             fontWeight: FontWeight.w500,
// //             color: const Color.fromARGB(255, 0, 0, 0),
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               /// LOGO
// //               Center(
// //                 child: Image.asset(
// //                   "assets/images/tawasul_logo.png",
// //                   height: 84.5,
// //                   width: 84,
// //                   errorBuilder:
// //                       (context, error, stackTrace) =>
// //                           Icon(Icons.account_circle, size: 80),
// //                 ),
// //               ),
// //               SizedBox(height: 15),

// //               /// TITLE + SUBTITLE
// //               const Center(
// //                 child: Column(
// //                   children: [
// //                     Text(
// //                       "Reset your password",
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.normal,
// //                       ),
// //                     ),
// //                     SizedBox(height: 9),
// //                     Text(
// //                       "Please set your new password",
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Color(0xFF3E3E3E),
// //                         fontWeight: FontWeight.normal,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 40),

// //               /// old PASSWORD
// //               _buildTextField(
// //                 "Old Password *",
// //                 Icons.lock,
// //                 controller: _passwordController,
// //                 isPassword: true,
// //               ),
// //               const SizedBox(height: 20),

// //               /// PASSWORD
// //               _buildTextField(
// //                 "New password *",
// //                 Icons.lock,
// //                 controller: _passwordController,
// //                 isPassword: true,
// //               ),
// //               const SizedBox(height: 20),

// //               /// PASSWORD
// //               _buildTextField(
// //                 "Confirm password *",
// //                 Icons.lock,
// //                 controller: _confirmpasswordController,
// //                 isPassword: true,
// //               ),
// //               SizedBox(height: 20),

// //               /// CREATE ACCOUNT BUTTON
// //               Center(
// //                 child: SizedBox(
// //                   width: 310.w,
// //                   height: 45.h,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF008AD2),
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => HomePage()),
// //                       );
// //                     },
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           "Confirm",
// //                           style: TextStyle(fontSize: 16, color: Colors.white),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 15),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField(
// //     String hint,
// //     IconData icon, {
// //     bool isPassword = false,
// //     TextEditingController? controller,
// //     TextInputType keyboardType = TextInputType.text,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 15),
// //       child: TextField(
// //         controller: controller,
// //         obscureText: isPassword,
// //         keyboardType: keyboardType,
// //         decoration: InputDecoration(
// //           labelText: hint,
// //           suffixIcon: Icon(icon, color: const Color(0xFF515C6F), size: 20),
// //           filled: true,
// //           fillColor: const Color.fromARGB(255, 255, 255, 255),
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 12,
// //             vertical: 14,
// //           ),

// //           // Rounded corners
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide(color: Colors.black, width: 1.0),
// //           ),

// //           // focused & enabled states also have no visible border
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide(color: Colors.black, width: 1.0),
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide(color: Colors.black, width: 1.0),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';
// import 'package:tawasul_application/view/home_page.dart';

// class ChangePassword extends StatefulWidget {
//   const ChangePassword({Key? key}) : super(key: key);

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   bool isChecked = false;
//   String? selectedCountry;
//   final TextEditingController _oldpasswordController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmpasswordController =
//       TextEditingController();

//   bool _isOldPasswordValid = true;
//   bool _isPasswordValid = true;
//   bool _isConfirmPasswordValid = true;
//   String? _passwordErrorText;
//   String? _confirmPasswordErrorText;

//   final List<String> countries = ['Libya'];

//   String? _validateOldPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your old password';
//     }
//     // Here you would typically check against the actual current password
//     // For now, we'll just check it's not empty
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a password';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     if (!value.contains(RegExp(r'[A-Z]'))) {
//       return 'Password must contain at least one uppercase letter';
//     }
//     if (!value.contains(RegExp(r'[a-z]'))) {
//       return 'Password must contain at least one lowercase letter';
//     }
//     if (!value.contains(RegExp(r'[0-9]'))) {
//       return 'Password must contain at least one number';
//     }
//     if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
//       return 'Password must contain at least one special character';
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }

//   void _validateAndSubmit() {
//     final oldPasswordError = _validateOldPassword(_oldpasswordController.text);
//     final passwordError = _validatePassword(_passwordController.text);
//     final confirmPasswordError = _validateConfirmPassword(
//       _confirmpasswordController.text,
//     );

//     setState(() {
//       _isOldPasswordValid = oldPasswordError == null;
//       _isPasswordValid = passwordError == null;
//       _isConfirmPasswordValid = confirmPasswordError == null;
//       _passwordErrorText = passwordError;
//       _confirmPasswordErrorText = confirmPasswordError;
//     });

//     if (oldPasswordError == null &&
//         passwordError == null &&
//         confirmPasswordError == null) {
//       // All validations passed - proceed with password change
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmpasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         toolbarHeight: 56.h,
//         leadingWidth: 48.w,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 12.w),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ForgotPasswordEmail()),
//               );
//             },
//             child: Container(
//               width: 36.w,
//               height: 36.w,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF008AD2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 18.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           "Change password",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// LOGO
//               Center(
//                 child: Image.asset(
//                   "assets/images/tawasul_logo.png",
//                   height: 84.5,
//                   width: 84,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           Icon(Icons.account_circle, size: 80),
//                 ),
//               ),
//               SizedBox(height: 15),

//               /// TITLE + SUBTITLE
//               const Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       "Reset your password",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     SizedBox(height: 9),
//                     Text(
//                       "Please set your new password",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF3E3E3E),
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),

//               /// old PASSWORD
//               _buildTextField(
//                 "Old Password *",
//                 Icons.lock,
//                 controller: _oldpasswordController,
//                 isPassword: true,
//                 isValid: _isOldPasswordValid,
//                 errorText:
//                     _isOldPasswordValid
//                         ? null
//                         : 'Please enter your current password',
//               ),
//               const SizedBox(height: 20),

//               /// PASSWORD
//               _buildTextField(
//                 "New password *",
//                 Icons.lock,
//                 controller: _passwordController,
//                 isPassword: true,
//                 isValid: _isPasswordValid,
//                 errorText: _passwordErrorText,
//               ),
//               const SizedBox(height: 20),

//               /// CONFIRM PASSWORD
//               _buildTextField(
//                 "Confirm password *",
//                 Icons.lock,
//                 controller: _confirmpasswordController,
//                 isPassword: true,
//                 isValid: _isConfirmPasswordValid,
//                 errorText: _confirmPasswordErrorText,
//               ),
//               SizedBox(height: 20),

//               /// CREATE ACCOUNT BUTTON
//               Center(
//                 child: SizedBox(
//                   width: 310.w,
//                   height: 45.h,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF008AD2),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: _validateAndSubmit,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Confirm",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String hint,
//     IconData icon, {
//     bool isPassword = false,
//     TextEditingController? controller,
//     TextInputType keyboardType = TextInputType.text,
//     bool isValid = true,
//     String? errorText,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: hint,
//           suffixIcon: Icon(icon, color: const Color(0xFF515C6F), size: 20),
//           filled: true,
//           fillColor: const Color.fromARGB(255, 255, 255, 255),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 14,
//           ),
//           errorText: errorText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: isValid ? Colors.black : Colors.red,
//               width: 1.0,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: isValid ? Colors.black : Colors.red,
//               width: 1.0,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: isValid ? Colors.black : Colors.red,
//               width: 1.0,
//             ),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.red, width: 1.0),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.red, width: 1.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';
import 'package:tawasul_application/view/home_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isChecked = false;
  String? selectedCountry;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool _isOldPasswordValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  final List<String> countries = ['Libya'];

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return t.passwordIsRequired;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _validateAndSubmit() {
    final oldPasswordError = _validateOldPassword(_oldpasswordController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(
      _confirmpasswordController.text,
    );

    setState(() {
      _isOldPasswordValid = oldPasswordError == null;
      _isPasswordValid = passwordError == null;
      _isConfirmPasswordValid = confirmPasswordError == null;
      _passwordErrorText = passwordError;
      _confirmPasswordErrorText = confirmPasswordError;
    });

    if (oldPasswordError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
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
          padding: EdgeInsets.only(left: 12.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordEmail()),
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
          t.changePassword,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LOGO
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
              SizedBox(height: 15.h),

              /// TITLE + SUBTITLE
              Center(
                child: Column(
                  children: [
                    Text(
                      t.resetPassword,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 9.h),
                    Text(
                      t.pleaseSetYourNewPassword,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF3E3E3E),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              /// old PASSWORD
              _buildTextField(
                "${t.oldPassword} *",
                Icons.lock,
                controller: _oldpasswordController,
                isPassword: true,
                isValid: _isOldPasswordValid,
                errorText:
                    _isOldPasswordValid
                        ? null
                        : 'Please enter your current password',
              ),
              SizedBox(height: 20.h),

              /// PASSWORD
              _buildTextField(
                "${t.newPassword} *",
                Icons.lock,
                controller: _passwordController,
                isPassword: true,
                isValid: _isPasswordValid,
                errorText: _passwordErrorText,
              ),
              SizedBox(height: 20.h),

              /// CONFIRM PASSWORD
              _buildTextField(
                "${t.confirmPassword} *",
                Icons.lock,
                controller: _confirmpasswordController,
                isPassword: true,
                isValid: _isConfirmPasswordValid,
                errorText: _confirmPasswordErrorText,
              ),
              SizedBox(height: 20.h),

              /// CREATE ACCOUNT BUTTON
              Center(
                child: SizedBox(
                  width: 310.w,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008AD2),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _validateAndSubmit,
                    child: Text(
                      t.confirm,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),
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
    bool isValid = true,
    String? errorText,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: Icon(icon, color: const Color(0xFF515C6F), size: 20.sp),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: isValid ? Colors.black : Colors.red,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: isValid ? Colors.black : Colors.red,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: isValid ? Colors.black : Colors.red,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      ),
    );
  }
}