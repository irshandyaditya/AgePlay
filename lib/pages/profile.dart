import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:age_play/pages/edit_profil.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = const FlutterSecureStorage(); // Instance Secure Storage
  int _currentIndex = 3;

  String? _name; // Nama user
  String? _email; // Email user
  String? _password; // Password user
  String? _profilePicture; // URL foto profil user

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Ambil data akun dari secure storage
    final name = await storage.read(key: 'name'); // Nama user
    final email = await storage.read(key: 'email'); // Email user
    final password = await storage.read(key: 'password'); // Password user
    final profilePicture = await storage.read(key: 'foto_profil'); // Foto profil user

    setState(() {
      _name = name ?? 'Unknown';
      _email = email ?? 'Unknown';
      _password = password ?? '****'; // Jika tidak ada, tampilkan default
      _profilePicture = profilePicture; // Jika tidak ada, akan ditangani di UI
    });
  }

  Future<void> _logout() async {
    // Hapus semua data dari secure storage
    await storage.deleteAll();
    // Navigasi ke halaman login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            // Profile Details
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_email ?? 'Loading...'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: _profilePicture != null
                        ? NetworkImage('https://polinemaesports.my.id/$_profilePicture') // Jika ada foto profil
                        : const AssetImage('assets/foto_profil.png')
                            as ImageProvider, // Default foto profil
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            // Account Details Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Account Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.red),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                            name: _name ?? 'Unknown',
                            email: _email ?? 'Unknown',
                            profilePicture: _profilePicture ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(thickness: 1, height: 0, color: Colors.grey[300]),
                  Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        _buildDetailRow('Nama', _name ?? 'Loading...'),
                        const SizedBox(height: 16),
                        _buildDetailRow('Email', _email ?? 'Loading...'),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Password',
                          '*' * (_password?.length ?? 10), // Sembunyikan password
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            // About Us Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title: const Text(
                  'About Us',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ),
            const SizedBox(height: 8.0),
            // Log Out Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: _logout, // Logout function
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
