import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tawasul_application/view/voice_search.dart';

void main() {
  debugPaintBaselinesEnabled = false;
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: VoiceSearchScreen()),
  );
}
