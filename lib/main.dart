import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:age_play/pages/sign_up.dart';
import 'package:age_play/pages/home_page.dart';
import 'package:age_play/pages/profile.dart';
import 'package:age_play/pages/camera.dart';
import 'package:age_play/pages/about.dart';
import 'package:age_play/pages/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => Profile(),
        '/camera': (context) => Camera(),
        '/about': (context) => AboutPage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}
