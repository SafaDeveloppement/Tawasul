// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(LoginDebugApp());
// }

// class LoginDebugApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Debug Console',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: LoginDebugScreen(),
//     );
//   }
// }

// class LoginDebugScreen extends StatefulWidget {
//   @override
//   _LoginDebugScreenState createState() => _LoginDebugScreenState();
// }

// class _LoginDebugScreenState extends State<LoginDebugScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _debugOutput = '';
//   bool _isLoading = false;

//   // Simulate the login function from your code
//   Future<void> simulateLogin() async {
//     setState(() {
//       _isLoading = true;
//       _debugOutput = '';
//     });

//     // Simulate the debug output that would appear in the console
//     String debugText = '';

//     debugText += "🚀🚀🚀 STARTING LOGIN PROCESS 🚀🚀🚀\n\n";
    
//     debugText += "📡 LOGIN REQUEST DEBUG 📡\n";
//     debugText += "🌐 URL: https://api.example.com/public/login\n";
//     debugText += "👤 Username: '${_usernameController.text.trim()}'\n";
//     debugText += "🔑 Password: '${_passwordController.text.trim()}'\n";
//     debugText += "📦 Request Body: {\"username\":\"${_usernameController.text.trim()}\",\"password\":\"${_passwordController.text.trim()}\"}\n";
//     debugText += "📋 Headers: {Content-Type: application/json, Accept: application/json}\n";
//     debugText += "==========================================\n\n";
    
//     // Simulate network delay
//     await Future.delayed(Duration(seconds: 2));
    
//     debugText += "📨 LOGIN RESPONSE RECEIVED 📨\n";
//     debugText += "✅ Status Code: 200\n";
//     debugText += "📋 Response Headers: {content-type: application/json, content-length: 132, connection: keep-alive}\n";
//     debugText += "📦 Response Body: {\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...\",\"message\":\"Login successful\"}\n";
//     debugText += "==========================================\n\n";
    
//     debugText += "🎉 LOGIN SUCCESSFUL! TOKEN RECEIVED\n";
//     debugText += "🔐 Token saved to SharedPreferences\n";

//     setState(() {
//       _debugOutput = debugText;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Debug Console'),
//         backgroundColor: Colors.blue[800],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Debug Console Output',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'This simulates what appears in your debug console when using the login function',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[900],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _debugOutput,
//                     style: TextStyle(
//                       fontFamily: 'Monospace',
//                       fontSize: 12,
//                       color: Colors.green[300],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock),
//               ),
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : simulateLogin,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[800],
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: _isLoading
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         'Simulate Login',
//                         style: TextStyle(fontSize: 16),
//                       ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'In a real Flutter app, these debug messages would appear in:',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.arrow_right, size: 16),
//                 SizedBox(width: 4),
//                 Text('Android Studio / IntelliJ: Run console'),
//               ],
//             ),
//             Row(
//               children: [
//                 Icon(Icons.arrow_right, size: 16),
//                 SizedBox(width: 4),
//                 Text('VS Code: Debug Console'),
//               ],
//             ),
//             Row(
//               children: [
//                 Icon(Icons.arrow_right, size: 16),
//                 SizedBox(width: 4),
//                 Text('Terminal: If using `flutter run`'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }