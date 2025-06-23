import 'dart:async';
import 'package:flutter/material.dart';

/// شاشة البداية (SplashScreen) - تعرض صورة كخلفية، وتختفي بعد ثوانٍ
/// لتنتقل بنا إلى شاشة الترحيب (WelcomePage).
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // بعد 5 ثوانٍ، الانتقال إلى شاشة الترحيب.
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية تحوي الصورة
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/splashlogo.jpg'), // ضع اسم ملف الصورة التي تريدها
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
