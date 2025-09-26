import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tawasul_application/view/Connexion/signup.dart';
import 'package:tawasul_application/view/home_page.dart';

class AccountValidation extends StatefulWidget {
  final String verificationCode;
  final String email;
  final String phone;

  const AccountValidation({
    Key? key,
    required this.verificationCode,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  State<AccountValidation> createState() => _AccountValidationState();
}

class _AccountValidationState extends State<AccountValidation> {
  final List<TextEditingController> _codeControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Set up focus node listeners for auto-moving between fields
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _codeControllers[i].text.isEmpty) {
          // Move focus to previous field if current is empty and losing focus
          if (i > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
          }
        }
      });
    }

    // Debug print the received verification code
    print("Received verification code: ${widget.verificationCode}");
    print("Email: ${widget.email}");
    print("Phone: ${widget.phone}");
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

  void _onCodeChanged(int index, String value) {
    if (value.length == 1 && index < _codeControllers.length - 1) {
      // Move to next field
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move to previous field when backspace is pressed
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    _validateCode();
  }

  void _validateCode() {
    setState(() {
      _errorMessage = null;
    });
  }

  String _getEnteredCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void _verifyCode() {
    final enteredCode = _getEnteredCode();

    if (enteredCode.length != 5) {
      setState(() {
        _errorMessage = 'Please enter the complete 5-digit code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });

      // Compare with the actual verification code (remove spaces from both)
      final cleanEnteredCode = enteredCode.replaceAll(' ', '');
      final cleanExpectedCode = widget.verificationCode.replaceAll(' ', '');

      print("Entered code: $cleanEnteredCode");
      print("Expected code: $cleanExpectedCode");

      if (cleanEnteredCode == cleanExpectedCode) {
        // Code is correct - navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
        });
      }
    });
  }

  void _resendCode() {
    // TODO: Implement resend code functionality
    print("Resending code to ${widget.email}");

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification code sent to ${widget.email}'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
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
          t.accountValidation,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

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
                      t.accountValidation,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      t.pleaseEnterTheCodeNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF3E3E3E),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Sent to: ${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35.h),

              // Error Message
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.only(left: 22.0.w),
                child: Text(
                  '${t.codeNumber} :',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Code Input Fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 44.w,
                      height: 52.h,
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Color(0xFF008AD2),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) => _onCodeChanged(index, value),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 30.h),

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
                    ),
                    onPressed: _isLoading ? null : _verifyCode,
                    child:
                        _isLoading
                            ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              t.confirm,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Resend Code
              Center(
                child: GestureDetector(
                  onTap: _resendCode,
                  child: RichText(
                    text: TextSpan(
                      text: t.resendTheCode,
                      style: TextStyle(
                        color: Color(0xFF008AD2),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Debug information (remove in production)
              if (widget.verificationCode.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Divider(),
                      Text(
                        'Debug Info (Remove in production):',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      Text(
                        'Expected Code: ${widget.verificationCode}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
