import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final String password;

  const ChangePassword({
    required this.password,
  });

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String _password = '';
  late String _email = 'unknown';
  late String _name = 'unknown';

  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _password = widget.password;
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Ambil auth_token dari storage
        final authToken = await storage.read(key: "auth_token");

        if (authToken == null) {
          throw Exception("Token tidak ditemukan. Silakan login ulang.");
        }

        // Kirim data ke API
        final uri =
            Uri.parse("https://polinemaesports.my.id/api/akun/edit-profile/");
        final request = http.MultipartRequest("POST", uri);

        // Tambahkan data form
        request.fields['nama'] = _name;
        request.fields['email'] = _email;
        if (_password.isNotEmpty) {
          request.fields['password'] = _password;
        }
        request.fields['token'] = authToken;

        // Tambahkan file jika ada
        if (_image != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'foto_profil',
            _image!.path,
          ));
        } else {
          request.fields['foto_profil'] = 'null';
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);

          if (jsonResponse['message'] == 'Profile updated successfully') {
            // Menyimpan perubahan profil ke FlutterSecureStorage
            await storage.write(key: 'name', value: _name);
            await storage.write(key: 'email', value: _email);
            // if (_image != null) {
            //   // Jika foto profil diperbarui, simpan URL atau path baru
            //   newProfilePicture = jsonResponse['foto_profil'];
            //   await storage.write(key: 'foto_profil', value: newProfilePicture);
            // } else {
            //   await storage.write(key: 'foto_profil', value: _profilePicture);
            // }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profil berhasil diperbarui")),
            );

            // Navigasi ke halaman profil
            Navigator.pushNamed(context, '/profile');
          } else {
            throw Exception(
                jsonResponse['error'] ?? "Gagal memperbarui profil.");
          }
        } else {
          throw Exception(
              "Gagal memperbarui profil. Status: ${response.statusCode}");
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

  Widget _buildEditableField({
    required String label,
    String? initialValue,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEditableField(
                      label: 'Current Password',
                      isPassword: true,
                      onSaved: (value) => _password = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildEditableField(
                      label: 'New Password',
                      isPassword: true,
                      onSaved: (value) => '',
                    ),
                    const SizedBox(height: 16),
                    _buildEditableField(
                      label: 'Confirmation New Password',
                      isPassword: true,
                      onSaved: (value) => _password = value ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
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
    );
  }
}
