import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tawasul_application/view/Checkout/checkout.dart';

void main() {
  debugPaintBaselinesEnabled = false;
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Checkout()));
}
