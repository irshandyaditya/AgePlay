import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final String name;
  final String email;
  final String profilePicture;

  const EditProfile({
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  String _password = '';
  late String _profilePicture;
  late String newProfilePicture;

  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _profilePicture = widget.profilePicture;
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
        request.fields['password'] = _password;
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
            if (_image != null) {
              // Jika foto profil diperbarui, simpan URL atau path baru
              newProfilePicture = jsonResponse['foto_profil'];
              await storage.write(key: 'foto_profil', value: newProfilePicture);
            } else {
              await storage.write(key: 'foto_profil', value: _profilePicture);
            }

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
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_profilePicture.isNotEmpty
                                ? NetworkImage('https://polinemaesports.my.id/$_profilePicture')
                                : const AssetImage('assets/foto_profil.png'))
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => _pickImage(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEditableField(
                      label: 'Nama',
                      initialValue: _name,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 16),
                    _buildEditableField(
                      label: 'Email',
                      initialValue: _email,
                      onSaved: (value) => _email = value!,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 64),
                    _buildEditableField(
                      label: 'Confirm Password',
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
