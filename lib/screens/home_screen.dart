import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed("/");
          }
          if (index == 1) {
            Navigator.of(context).pushNamed("/alerts");
          }
          if (index == 2) {
            Navigator.of(context).pushNamed("/welcome");
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'التنبيهات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'تسجيل الخروج',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              //=============================
              //  ملف المستخدم (صورة + اسم)
              //=============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // صورة دائرية للمستخدم
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                          'assets/user.png'), // استبدل بالصورة المناسبة
                    ),
                    const SizedBox(width: 12),
                    // اسم المستخدم
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " $username مرحباً", // استبدل باسم المستخدم الحقيقي
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //=============================
              //  Grid للوظائف
              //=============================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildHomeItem(context, Icons.monitor_heart,
                        'متابعة القياسات', '/measurement'),
                    _buildHomeItem(context, Icons.person_search,
                        'الأطباء والمتخصصين', '/doctors'),
                    _buildHomeItem(context, Icons.chat, 'التواصل مع الأطباء',
                        '/communication'),
                    _buildHomeItem(
                        context, Icons.alarm, 'التنبيهات', '/alerts'),
                    _buildHomeItem(context, Icons.health_and_safety,
                        'الإرشاد الصحي', '/health_guidance'),
                    _buildHomeItem(
                        context, Icons.warning_amber, 'الطوارئ', '/emergency',
                        iconColor: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// دالة مساعدة لبناء عنصر في Grid
  Widget _buildHomeItem(
      BuildContext context, IconData icon, String label, String routeName,
      {Color iconColor = Colors.blue}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
