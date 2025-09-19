import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_number.dart';
import 'package:tawasul_application/view/home_page.dart';

class ResetPasswordNumber extends StatefulWidget {
  const ResetPasswordNumber({Key? key}) : super(key: key);

  @override
  State<ResetPasswordNumber> createState() => _ResetPasswordNumberState();
}

class _ResetPasswordNumberState extends State<ResetPasswordNumber> {
  bool isChecked = false;
  String? selectedCountry;
  final TextEditingController _phoneController = TextEditingController();

  final List<String> countries = ['Libya'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => ForgotPasswordNumber()),
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
          "Change password",
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),

              /// LOGO
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

              /// TITLE + SUBTITLE
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Please enter the code number",
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
              SizedBox(height: 20),

              //Phone number
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Text(
                  'Code number :',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  spacing: 19,
                  children: [
                    Container(
                      width: 44,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// CREATE ACCOUNT BUTTON
              Center(
                child: SizedBox(
                  width: 310.w,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008AD2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Confirm",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 45),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordNumber(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Resend the code ",
                      style: TextStyle(
                        color: Colors.black87,
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
