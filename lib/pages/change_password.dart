import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final String currentPassword;

  const ChangePassword({required this.currentPassword});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.currentPassword;
  }

  Future<void> _savePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_newPassword != _confirmNewPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New Password and Confirmation Password do not match"),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Ambil token autentikasi
        final authToken = await storage.read(key: "auth_token");

        if (authToken == null) {
          throw Exception("Authentication token not found. Please log in again.");
        }

        // Kirim data ke API dengan multipart request
        final uri =
            Uri.parse("https://polinemaesports.my.id/api/akun/edit-password/");
        final request = http.MultipartRequest("POST", uri);

        request.fields['token'] = authToken;
        request.fields['password'] = _currentPassword;
        request.fields['new_password'] = _newPassword;

        // Kirim request dan tangani response
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);

          if (jsonResponse['message'] == 'Password updated successfully') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password updated successfully")),
            );
            Navigator.pushNamed(context, '/profile');
          } else {
            throw Exception(jsonResponse['error'] ?? "Failed to update password");
          }
        } else {
          throw Exception(
              "Failed to update password. Status code: ${response.statusCode}");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPasswordField({
    required String label,
    required bool isPassword,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField(
                  label: 'Current Password',
                  isPassword: true,
                  onSaved: (value) => _currentPassword = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'New Password',
                  isPassword: true,
                  onSaved: (value) => _newPassword = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Confirm New Password',
                  isPassword: true,
                  onSaved: (value) => _confirmNewPassword = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmation Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
