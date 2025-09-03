import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _consoleOutput = [];
  bool _isLoading = false;

  // Your actual base URL
  final String baseUrl = 'http://t-api.dotit-corp.com/api';
  final int timeoutSeconds = 30;

  void _addToConsole(String message) {
    setState(() {
      _consoleOutput.add(
        '${DateTime.now().toString().split(' ')[1]}: $message',
      );
    });
  }

  void _clearConsole() {
    setState(() {
      _consoleOutput.clear();
    });
  }

  // REAL LOGIN function with actual API call
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      _addToConsole("🚀🚀🚀 STARTING LOGIN PROCESS 🚀🚀🚀");

      // Create the request body
      final Map<String, dynamic> requestBodyMap = {
        'username': username.trim(),
        'password': password.trim(),
      };

      final requestBody = jsonEncode(requestBodyMap);

      // DEBUG: Print everything about the request
      _addToConsole("📡 LOGIN REQUEST DEBUG 📡");
      _addToConsole("🌐 URL: $baseUrl/public/login");
      _addToConsole("👤 Username: '${username.trim()}'");
      _addToConsole("🔑 Password: '${password.trim()}'");
      _addToConsole("📦 Request Body: $requestBody");
      _addToConsole(
        "📋 Headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}",
      );
      _addToConsole("==========================================");

      // ACTUAL HTTP CALL (not simulated)
      final response = await http
          .post(
            Uri.parse('$baseUrl/public/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: requestBody,
          )
          .timeout(Duration(seconds: timeoutSeconds));

      // DEBUG: Print response details
      _addToConsole("📨 LOGIN RESPONSE RECEIVED 📨");
      _addToConsole("✅ Status Code: ${response.statusCode}");
      _addToConsole("📋 Response Headers: ${response.headers}");
      _addToConsole("📦 Response Body: ${response}");
      _addToConsole("==========================================");

      // Handle empty response
      if (response.body.isEmpty) {
        _addToConsole("❌ EMPTY RESPONSE FROM SERVER");
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        _addToConsole("🎉 LOGIN SUCCESSFUL! TOKEN RECEIVED");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseData['token']);
        return {'success': true, 'token': responseData['token']};
      } else {
        _addToConsole(
          "❌ LOGIN FAILED: ${responseData['message'] ?? 'No message'}",
        );
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid login credentials',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      _addToConsole("💥 LOGIN ERROR: $e");
      _addToConsole("🔍 Error type: ${e.runtimeType}");
      return {'success': false, 'message': 'Failed to connect to server: $e'};
    }
  }

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _addToConsole("❌ Please enter both username and password");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _clearConsole();

    final result = await login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      _addToConsole("✅ Login successful! Token saved.");
    } else {
      _addToConsole("❌ Login failed: ${result['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Login Console - REAL CALL'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearConsole,
            tooltip: 'Clear Console',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Login Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Login Form (Real API Call)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Console Output
            Expanded(
              child: Card(
                elevation: 4,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Console Output:',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _consoleOutput.length,
                          itemBuilder: (context, index) {
                            final message = _consoleOutput[index];
                            Color textColor = Colors.white;

                            if (message.contains('🚀'))
                              textColor = Colors.blue[200]!;
                            if (message.contains('✅') || message.contains('🎉'))
                              textColor = Colors.green;
                            if (message.contains('❌') || message.contains('💥'))
                              textColor = Colors.red;
                            if (message.contains('📡') ||
                                message.contains('📨'))
                              textColor = Colors.yellow;
                            if (message.contains('🌐')) textColor = Colors.cyan;
                            if (message.contains('👤'))
                              textColor = Colors.purple[200]!;
                            if (message.contains('🔑'))
                              textColor = Colors.orange;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Monospace',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
