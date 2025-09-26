// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:tawasul_application/view/Connexion/reset_password.dart';
// import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';

// class ResetPasswordEmail extends StatefulWidget {
//   const ResetPasswordEmail({Key? key}) : super(key: key);

//   @override
//   State<ResetPasswordEmail> createState() => _ResetPasswordEmailState();
// }

// class _ResetPasswordEmailState extends State<ResetPasswordEmail> {
//   bool isChecked = false;
//   String? selectedCountry;
//   final TextEditingController _emailController = TextEditingController();

//   final List<String> countries = ['Libya'];

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         toolbarHeight: 56.h,
//         leadingWidth: 48.w,
//         leading: Padding(
//           padding: EdgeInsetsDirectional.only(start: 12.w),
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
//           t.resetPassword,
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
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 25.h),

//               /// LOGO
//               Center(
//                 child: Image.asset(
//                   "assets/images/tawasul_logo.png",
//                   height: 84.5.h,
//                   width: 84.w,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           Icon(Icons.account_circle, size: 80.sp),
//                 ),
//               ),

//               /// TITLE + SUBTITLE
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       t.forgotPassword,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     Text(
//                       t.pleaseEnterTheCodeNumber,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Color(0xFF3E3E3E),
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               //Phone number
//               Padding(
//                 padding: EdgeInsets.only(left: 22.0.w),
//                 child: Text(
//                   '${t.codeNumber} :',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       width: 44.w,
//                       height: 52.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                     Container(
//                       width: 44.w,
//                       height: 52.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                     Container(
//                       width: 44.w,
//                       height: 52.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                     Container(
//                       width: 44.w,
//                       height: 52.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                     Container(
//                       width: 44.w,
//                       height: 52.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20.h),

//               /// CREATE ACCOUNT BUTTON
//               Center(
//                 child: SizedBox(
//                   width: 310.w,
//                   height: 45.h,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF008AD2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResetPassword(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       t.confirm,
//                       style: TextStyle(fontSize: 16.sp, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 45.h),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ResetPasswordEmail(),
//                       ),
//                     );
//                   },
//                   child: RichText(
//                     text: TextSpan(
//                       text: t.resendTheCode,
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 14.sp,
//                         decoration: TextDecoration.underline,
//                         decorationColor: const Color.fromARGB(255, 0, 0, 0),
//                         decorationThickness: 0.7,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 120.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/view/Connexion/reset_password.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_email.dart';

class ResetPasswordEmail extends StatefulWidget {
  final String email;
  final String verificationCode;
  
  const ResetPasswordEmail({
    Key? key,
    required this.email,
    required this.verificationCode,
  }) : super(key: key);

  @override
  State<ResetPasswordEmail> createState() => _ResetPasswordEmailState();
}

class _ResetPasswordEmailState extends State<ResetPasswordEmail> {
  bool isLoading = false;
  final List<TextEditingController> _codeControllers = 
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _setupFocusNodes();
  }

  void _setupFocusNodes() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && i < _focusNodes.length - 1) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  String getEnteredCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  bool isCodeValid() {
    final enteredCode = getEnteredCode();
    return enteredCode.length == 5 && enteredCode == widget.verificationCode;
  }

  Future<void> _resendCode() async {
    setState(() {
      isLoading = true;
    });

    final response = await ApiService.verifyPassword(widget.email);

    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Code resent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to resend code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyCode() {
    if (isCodeValid()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(
            email: widget.email,
            code: widget.verificationCode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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
          padding: EdgeInsetsDirectional.only(start: 12.w),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),

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
                      t.pleaseEnterTheCodeNumber,
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
              SizedBox(height: 20.h),
              
              // Code number
              Padding(
                padding: EdgeInsets.only(left: 22.0.w),
                child: Text(
                  '${t.codeNumber} :',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              
              // Code input fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return Container(
                      width: 44.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 4) {
                            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 20.h),

              /// CONFIRM BUTTON
              Center(
                child: SizedBox(
                  width: 310.w,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008AD2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: _verifyCode,
                    child: Text(
                      t.confirm,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 45.h),
              Center(
                child: GestureDetector(
                  onTap: isLoading ? null : _resendCode,
                  child: RichText(
                    text: TextSpan(
                      text: t.resendTheCode,
                      style: TextStyle(
                        color: isLoading ? Colors.grey : Colors.black87,
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
    );
  }
}