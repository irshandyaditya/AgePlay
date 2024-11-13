import 'package:flutter/material.dart';
import 'page/splash_screen.dart';
import 'package:age_play/page/sign_up.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}
