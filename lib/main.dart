import 'package:age_play/pages/filter.dart';
import 'package:age_play/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/splash_screen.dart';
import 'package:age_play/pages/sign_up.dart';
import 'package:age_play/pages/home_page.dart';
import 'package:age_play/pages/camera.dart';
import 'package:age_play/pages/about.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Menyesuaikan status bar menggunakan SystemChrome
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Membuat status bar transparan
      statusBarIconBrightness: Brightness.dark, // Ikon terang (untuk background gelap)
    ),
  );
  await Hive.initFlutter();
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
        '/camera': (context) => Camera(),
        '/about': (context) => AboutPage(),
        '/login': (context) => LoginPage(),
        '/filter': (context) => FilterPage()
      },
    );
  }
}
