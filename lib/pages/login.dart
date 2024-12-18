import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:age_play/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage(); // Instance Secure Storage

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // API Endpoint
    const String apiUrl = 'https://polinemaesports.my.id/api/akun/login/';

    try {
    // Gunakan MultipartRequest untuk mendukung format sebelumnya
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());

      if (responseData['status'] == 'success') {
        // Simpan data ke Secure Storage
        String? csrfToken = response.headers['set-cookie']
            ?.split(';')
            .firstWhere((cookie) => cookie.contains('csrftoken'), orElse: () => '')
            .split('=')
            .last;

        String? sessionId = response.headers['set-cookie']
            ?.split(';')
            .firstWhere((cookie) => cookie.contains('sessionid'), orElse: () => '')
            .split('=')
            .last;

        await storage.write(key: 'auth_token', value: responseData['token']);
        await storage.write(key: 'csrf_token', value: csrfToken);
        await storage.write(key: 'session_id', value: sessionId);
        await storage.write(key: 'id', value: responseData['user']['id'].toString());
        await storage.write(key: 'name', value: responseData['user']['name']);
        await storage.write(key: 'email', value: responseData['user']['email']);
        await storage.write(key: 'foto_profil', value: responseData['user']['foto_profil']);

        Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Login failed';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Username or password is incorrect';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_abu.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),

                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Log',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'in',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
