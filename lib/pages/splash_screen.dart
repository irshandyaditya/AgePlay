import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      childWidget: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
            child: Image.asset(
              "assets/splash.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 4500),
      animationDuration: const Duration(milliseconds: 1000),
      onAnimationEnd: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
