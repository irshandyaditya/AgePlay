import 'package:flutter/material.dart';
import 'package:age_play/pages/home_page.dart';
import 'package:age_play/pages/profile.dart';
import 'package:age_play/pages/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgePlay',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        // '/': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/profile': (context) => Profile(),
        '/camera': (context) => Camera(),
      },
    );
  }
}
