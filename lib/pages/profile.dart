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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text('profile'),
              )
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
        child: Icon(Icons.camera_alt_outlined, color: Colors.white,),
        backgroundColor: Colors.red, // Red color for the central button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex, 
        onTap: (index){
          _currentIndex = index;
        }
      ),
    );
  }
}