import 'package:care_old/screens/alerts_screen.dart';
import 'package:care_old/screens/communication_screen.dart';
import 'package:care_old/screens/doctors_screen.dart';
import 'package:care_old/screens/emergency_screen.dart';
import 'package:care_old/screens/health_guidance_screen.dart';
import 'package:care_old/screens/home_screen.dart';
import 'package:care_old/screens/login_screen.dart';
import 'package:care_old/screens/measurement_screen.dart';
import 'package:care_old/screens/registration_screen.dart';
import 'package:care_old/screens/splashscreen.dart';
import 'package:care_old/screens/welcome_page.dart';
import 'package:flutter/material.dart';

/// الملف الرئيسي للتطبيق حيث يتم تعريف جميع المسارات (Routes)
void main() {
  runApp(const AetinaApp());
}

class AetinaApp extends StatelessWidget {
  const AetinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aetina Health App',
      debugShowCheckedModeBanner: false,
      // الشاشة الأولية هي شاشة الترحيب
      initialRoute: '/splash',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        // عند الضغط على زر الدخول في شاشة تسجيل الدخول يتم الانتقال إلى الشاشة الرئيسية
        '/': (context) => const HomeScreen(),
        '/measurement': (context) => const MeasurementScreen(),
        '/doctors': (context) => const DoctorsScreen(),
        '/communication': (context) => const CommunicationScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/health_guidance': (context) => const HealthGuidanceScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
