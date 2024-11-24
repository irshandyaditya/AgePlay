import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/foto.png'),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AgePlay',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '@ageplay',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.black),
                  title: Text(
                    'Profile',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.black),
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
              ],
            ),
          ),
          // Spacer untuk mendorong Logout ke bagian bawah
          Expanded(child: Container()),
          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (route) => false);
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
