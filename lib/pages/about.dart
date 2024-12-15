import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('About AgePlay'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'AgePlay is a smart solution to help users find games that match their age and gender. '
                'By leveraging artificial intelligence technology to detect age and recognize user gender, AgePlay '
                'provides game recommendations specifically designed to fit the user\'s age category and preferences, whether for children, '
                'teenagers, or adults. This application is committed to creating a safe, educational, and entertaining gaming environment, '
                'allowing users to enjoy a gaming experience tailored to their needs and interests.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Choose the Right Game with AgePlay',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'AgePlay is your go-to application for finding games that match your personal characteristics. '
                'With advanced age and gender recognition technology, AgePlay helps filter games that are suitable, '
                'relevant, and safe for every user. For parents, AgePlay also serves as an essential tool to ensure '
                'their children receive recommendations for educational and age-appropriate games. Make AgePlay your '
                'companion in choosing quality games!',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Why AgePlay?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'In this digital age, finding the right game can be a challenge, especially with the vast number of options available. '
                'AgePlay comes as a solution, combining age detection technology and gender recognition to provide tailored '
                'recommendations. Each recommendation on AgePlay is carefully selected to provide a safe gaming experience that aligns '
                'with the user\'s psychological development. With AgePlay, games are not just entertainment, but also a suitable learning '
                'medium for every age stage.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
