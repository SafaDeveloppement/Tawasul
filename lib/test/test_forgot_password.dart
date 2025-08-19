import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tawasul_application/view/Connexion/forgot_password_number.dart';

void main() {
  debugPaintBaselinesEnabled = false;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordNumber(),
    ),
  );
}
