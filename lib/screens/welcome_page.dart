import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

/// شاشة الترحيب (WelcomePage) - تحوي الخلفية ذاتها أو خلفية أخرى
/// بالإضافة إلى عناصر الواجهة السابقة مع بعض التحسينات اللونية.
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية الصورة
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // يمكنك إضافة أي حركات من animate_do حسب الرغبة
                BounceInDown(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      // خلفية شبه شفافة لوضع النصوص فوق الصورة
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'أهلاً بكم',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // يمكنك وضع صورة أخرى هنا أو أيقونة
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/logo.jpg', // ضع الصورة الخاصة بالترحيب
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  child: const Text(
                    'Aetina مرحباً بكم في تطبيق ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  child: const Text(
                    'تطبيق رعاية صحية يساعد كبار السن على متابعة صحتهم بسهولة.',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                ZoomIn(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      // الانتقال إلى شاشة تسجيل الدخول عند الضغط على "ابدأ"
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'ابدأ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
