import 'package:flutter/material.dart';
import 'package:age_play/widgets/bottom_navbar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none, // Allow elements to overflow outside the Stack
                children: [
                  // Background image
                  Container(
                    height: screenHeight * 0.5, // Tinggi background lebih besar agar tampak jelas
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/splash.png'), // Ganti dengan path gambar Anda
                        fit: BoxFit.cover, // Pastikan gambar mencakup seluruh kontainer
                      ),
                    ),
                    
                  ),
                  Positioned(
                    top: screenHeight * 0.255, // Posisi dari atas
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50, // Radius lingkaran
                          backgroundColor: Colors.white, // Warna latar belakang untuk border (opsional)
                          child: CircleAvatar(
                            radius: 45, // Radius lingkaran dalam (kurangi untuk border)
                            backgroundImage: AssetImage('assets/logo.png'), // Gambar di dalam
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'AgePlay',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '@ageplay',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70), // Tambahkan jarak setelah avatar
                  Positioned(
                    top: screenHeight * 0.45, // Posisi dari atas
                    left: 20, // Posisi dari kiri
                    right: 20, // Posisi dari kanan
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserInfoRow(
                                title: 'Nama',
                                value: 'Age Play',
                              ),
                              Divider(),
                              UserInfoRow(
                                title: 'Email',
                                value: 'ageplay@gmail.com',
                              ),
                              Divider(),
                              UserInfoRow(
                                title: 'Password',
                                value: '**********',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Garis tiga di pojok kanan atas
                  // Avatar and user info
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        // Logika ketika ikon ditekan
                        print("Menu icon tapped");
                      },
                      child: Icon(
                        Icons.menu,
                        size: 30,
                        color: Colors.white, // Warna putih agar tampak di background
                      ),
                    ),
                  ),
                ],
              ),
              
              // Card for user information
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for central button
          Navigator.pushNamed(context, '/camera');
        },
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.camera_alt_outlined, color: Colors.white),
        backgroundColor: Colors.red, // Red color for the central button
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
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const UserInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
