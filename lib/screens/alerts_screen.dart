import 'dart:convert';
import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// واجهة التنبيهات التي تعرض التذكيرات الخاصة بتناول الدواء أو قياس المؤشرات الحيوية.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreen();
}

class _AlertsScreen extends State<AlertsScreen> {
  List<dynamic> alerts = [];
  bool isLoading = true; // ✅ متغير لمتابعة حالة التحميل

  @override
  void initState() {
    super.initState();
    fetchAlert();
  }

  // تابع جلب التنبيهات
  Future<void> fetchAlert() async {
    //تحويل اذا كانت الid محرف ل عدد
    var userid = int.parse(logindata["user"]["UserID"].toString());
    assert(userid is int);
    print(userid);

    try {
      final response = await http.get(
        Uri.parse('$baseurl/index.php?action=fetch_reminders&user_id=$userid'),
      );

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> reminder = jsonDecode(response.body);
          alerts = (reminder['reminders'] ?? [])
              .cast<dynamic>(); // ✅ تأكد من أن البيانات قائمة وليست `null`
          isLoading = false; // ✅ إيقاف التحميل
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to load alerts");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching alerts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التنبيهات'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // ✅ تحميل فقط أثناء الجلب
          : alerts.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد تنبيهات متاحة.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ) // ✅ عرض رسالة عندما لا توجد بيانات
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final classItem = alerts[index];
                    return Card(
                      child: ListTile(
                        leading: Text(classItem["ReminderType"] ?? "غير معروف"),
                        title:
                            Text(classItem["ReminderMessage"] ?? "غير معروف"),
                        subtitle:
                            Text(classItem["ReminderDate"] ?? "غير معروف"),
                        trailing:
                            Text(classItem["ReminderTime"] ?? "غير معروف"),
                      ),
                    );
                  },
                ),
    );
  }
}
