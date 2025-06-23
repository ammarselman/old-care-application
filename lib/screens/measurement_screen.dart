import 'dart:convert';

import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// واجهة متابعة القياسات حيث يمكن للمستخدم إدخال قياساته مثل ضغط الدم ومستوى السكر.
class MeasurementScreen extends StatelessWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController sugarController = TextEditingController();
    TextEditingController presureController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    // تابع إرسال قيم الضغط والسكر
    Future<void> sendvalue() async {
      String apiUrl = "$baseurl/index.php?action=insert_scan";
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "user_id": logindata['user']['UserID'].toString(),
            "blood_pressure": presureController.text,
            "sugar": sugarController.text,
          }),
        );
        print(response.body);
        print("Response status: \${response.statusCode}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String message = responseData['message'] ?? "لم يتم استلام رسالة";

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("نتيجة القياس"),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("موافق"),
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception("فشل في حفظ القيم: \${response.statusCode}");
        }
      } catch (e) {
        print("خطأ في حفظ القيم: \$e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: \$e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('متابعة القياسات'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // تعليمات إدخال القياسات
              const Text(
                'أدخل القياسات الخاصة بك لمتابعة ضغط الدم ومستوى السكر',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // حقل إدخال ضغط الدم
              TextFormField(
                controller: presureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ضغط الدم'),
              ),
              // حقل إدخال مستوى السكر
              TextFormField(
                controller: sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'مستوى السكر'),
              ),
              const SizedBox(height: 20),
              // زر حفظ القياسات
              ElevatedButton(
                onPressed: () {
                  // تنفيذ عملية حفظ القياسات هنا
                  sendvalue();
                },
                child: const Text('حفظ القياسات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
