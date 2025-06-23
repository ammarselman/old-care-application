import 'package:flutter/material.dart';

/// واجهة الطوارئ التي تتيح للمستخدم الاتصال بخدمات الطوارئ أو إرسال تنبيه للأقارب.
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("الاتصال بالطوارئ"),
          content: const Text("هل تريد الاتصال برقم الطوارئ 911؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                // تنفيذ عملية الاتصال هنا
                Navigator.pop(context);
              },
              child: const Text("اتصال"),
            ),
          ],
        );
      },
    );
  }

  void _showFamilyAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("إرسال تنبيه للأقارب"),
          content: const Text(
              "تم إرسال تنبيه إلى (أحمد - قريبك) لإعلامه بحالتك الطارئة."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("موافق"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطوارئ'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // تعليمات في حالة الطوارئ
            const Text(
              'في حالة الطوارئ، يمكنك الاتصال بالخدمات الطبية الفورية أو إرسال تنبيه للأقارب.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // زر الاتصال بالطوارئ
            ElevatedButton.icon(
              onPressed: () => _showEmergencyDialog(context),
              icon: const Icon(Icons.call, size: 30),
              label: const Text('اتصال طوارئ', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            // زر إرسال تنبيه للأقارب
            ElevatedButton.icon(
              onPressed: () => _showFamilyAlertDialog(context),
              icon: const Icon(Icons.notification_important, size: 30),
              label: const Text('إرسال تنبيه للأقارب',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
