// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tawasul_application/view/Connexion/reset_password_number.dart';
// import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';
// import 'package:tawasul_application/view/Connexion/login.dart';

// class ForgotPasswordNumber extends StatefulWidget {
//   const ForgotPasswordNumber({Key? key}) : super(key: key);

//   @override
//   State<ForgotPasswordNumber> createState() => _ForgotPasswordNumberState();
// }

// class _ForgotPasswordNumberState extends State<ForgotPasswordNumber> {
//   final TextEditingController _phoneController = TextEditingController(
//     text: '+218 ',
//   );
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _phoneController.addListener(_formatPhoneNumber);
//   }

//   @override
//   void dispose() {
//     _phoneController.removeListener(_formatPhoneNumber);
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _formatPhoneNumber() {
//     final text = _phoneController.text;

//     // Ensure it always starts with +218
//     if (!text.startsWith('+218')) {
//       _phoneController.value = _phoneController.value.copyWith(
//         text: '+218 ${text.replaceAll(RegExp(r'[^0-9]'), '')}',
//         selection: TextSelection.collapsed(offset: '+218 '.length),
//       );
//     }

//     // Remove any spaces between digits for validation
//     final cleanNumber = text.replaceAll(' ', '');
//     if (cleanNumber.length > 5 && !cleanNumber.startsWith('+218')) {
//       _phoneController.text = '+218 ' + cleanNumber.substring(4);
//     }
//   }

//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     }

//     final cleanNumber = value.replaceAll(' ', '');
//     if (!cleanNumber.startsWith('+218')) {
//       return 'Libyan number must start with +218';
//     }

//     if (cleanNumber.length < 12) {
//       return 'Phone number must be at least 9 digits after +218';
//     }

//     return null;
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
//                 MaterialPageRoute(builder: (context) => Login()),
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
//           "Reset password",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromARGB(255, 0, 0, 0),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// LOGO
//                 Center(
//                   child: Image.asset(
//                     "assets/images/tawasul_logo.png",
//                     height: 84.5,
//                     width: 84,
//                     errorBuilder:
//                         (context, error, stackTrace) =>
//                             Icon(Icons.account_circle, size: 80),
//                   ),
//                 ),

//                 /// TITLE + SUBTITLE
//                 const Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         "Forgot Password",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                       Text(
//                         "Please enter your phone number associated \nwith your account",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF3E3E3E),
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 60),

//                 // Phone number field with country code
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 15),
//                   child: TextFormField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: "Phone number *",
//                       prefixText: "",
//                       prefixStyle: TextStyle(color: Colors.black),
//                       suffixIcon: Icon(
//                         Icons.phone,
//                         color: Color(0xFF515C6F),
//                         size: 20,
//                       ),
//                       filled: true,
//                       fillColor: const Color.fromARGB(255, 255, 255, 255),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 14,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black, width: 1.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black, width: 1.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.black, width: 1.0),
//                       ),
//                     ),
//                     validator: _validatePhoneNumber,
//                     onChanged: (value) {
//                       // Format as user types
//                       if (!value.startsWith('+218')) {
//                         _phoneController.value = TextEditingValue(
//                           text:
//                               '+218 ${value.replaceAll(RegExp(r'[^0-9]'), '')}',
//                           selection: TextSelection.collapsed(
//                             offset: value.length + 5,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 15),

//                 /// CONFIRM BUTTON
//                 Center(
//                   child: SizedBox(
//                     width: 320.w,
//                     height: 45.h,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF008AD2),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CodeNumber(),
//                             ),
//                           );
//                         }
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Confirm",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 35),

//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ForgotPasswordEmail(),
//                         ),
//                       );
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: "Use email instead ",
//                         style: TextStyle(
//                           color: Colors.black87,
//                           decoration: TextDecoration.underline,
//                           decorationColor: const Color.fromARGB(255, 0, 0, 0),
//                           decorationThickness: 0.7,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 120.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/Connexion/reset_password_number.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';
import 'package:tawasul_application/view/Connexion/login.dart';

class ForgotPasswordNumber extends StatefulWidget {
  const ForgotPasswordNumber({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordNumber> createState() => _ForgotPasswordNumberState();
}

class _ForgotPasswordNumberState extends State<ForgotPasswordNumber> {
  final TextEditingController _phoneController = TextEditingController(
    text: '+218 ',
  );
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_formatPhoneNumber);
    _phoneController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    final text = _phoneController.text;

    if (!text.startsWith('+218')) {
      _phoneController.value = _phoneController.value.copyWith(
        text: '+218 ${text.replaceAll(RegExp(r'[^0-9]'), '')}',
        selection: TextSelection.collapsed(offset: '+218 '.length),
      );
    }

    final cleanNumber = text.replaceAll(' ', '');
    if (cleanNumber.length > 5 && !cleanNumber.startsWith('+218')) {
      _phoneController.text = '+218 ' + cleanNumber.substring(4);
    }
  }

  String? _validatePhoneNumber(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return t.phoneNumberIsRequired;
    }

    final cleanNumber = value.replaceAll(' ', '');
    if (!cleanNumber.startsWith('+218')) {
      return 'Libyan number must start with +218';
    }

    if (cleanNumber.length < 12) {
      return 'Phone number must be at least 9 digits after +218';
    }

    return null;
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
          padding: EdgeInsetsDirectional.only(start: 12.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
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
          t.resetPassword,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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

                /// TITLE + SUBTITLE
                Center(
                  child: Column(
                    children: [
                      Text(
                        t.forgotPassword,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        t.pleaseEnterYourPhoneNumber,
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
                SizedBox(height: 60.h),

                // Phone number field with country code
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "${t.phoneNumber} *",
                      prefixText: "",
                      prefixStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFF515C6F),
                        size: 20.sp,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    validator: _validatePhoneNumber,
                    onChanged: (value) {
                      if (!value.startsWith('+218')) {
                        _phoneController.value = TextEditingValue(
                          text:
                              '+218 ${value.replaceAll(RegExp(r'[^0-9]'), '')}',
                          selection: TextSelection.collapsed(
                            offset: value.length + 5,
                          ),
                        );
                      }
                    },
                  ),
                ),

                SizedBox(height: 15.h),

                /// CONFIRM BUTTON
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
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordNumber(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        t.confirm,
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 35.h),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordEmail(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: t.useEmailInstead,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color.fromARGB(255, 0, 0, 0),
                          decorationThickness: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}