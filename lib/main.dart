import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Please enter both username and password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Using ReqRes API for testing
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=2'),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> data = json.decode(response.body);
        final users = data['data'] as List;

        // Check if the provided username and password are valid
        bool isValidUser = users.any((user) {
          return user['first_name'].toLowerCase() == username.toLowerCase() &&
                 user['id'].toString() == password; // Use user ID as password
        });

        setState(() {
          _message = isValidUser ? 'Login successful!' : 'Login failed: Invalid credentials.';
        });
      } else {
        setState(() {
          _message = 'Login failed: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                key: const ValueKey('usernameField'), // Add this line
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (First Name)',
                ),
              ),
              TextField(
                key: const ValueKey('passwordField'), // Add this line
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (User ID)',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const ValueKey('loginButton'), // Add this line
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              const SizedBox(height: 20),
              Text(_message),
            ],
          ),
        ),
      ),
    );
  }
}
