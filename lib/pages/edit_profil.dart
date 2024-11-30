import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  final String name;
  final String email;
  final String profilePicture;

  EditProfile({
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
  String _password = ''; // Password baru
  late String _profilePicture;

  File? _image;

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

      // Simpan ke Secure Storage
      await storage.write(key: 'name', value: _name);
      await storage.write(key: 'email', value: _email);
      if (_password.isNotEmpty) {
        await storage.write(key: 'password', value: _password);
      }

      // Simpan foto ke server jika diperlukan (tidak diimplementasikan di sini)
      Navigator.pop(context); // Kembali ke halaman Profile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
                            ? NetworkImage(_profilePicture)
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
                    const SizedBox(height: 16),
                    _buildEditableField(
                      label: 'Password Baru',
                      isPassword: true,
                      onSaved: (value) => _password = value ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
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
        border: OutlineInputBorder(),
      ),
      onSaved: onSaved,
    );
  }
}
