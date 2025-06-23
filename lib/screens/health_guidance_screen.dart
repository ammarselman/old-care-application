import 'dart:convert';
import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthGuidanceScreen extends StatefulWidget {
  const HealthGuidanceScreen({super.key});

  @override
  State<HealthGuidanceScreen> createState() => _HealthGuidanceScreen();
}

class _HealthGuidanceScreen extends State<HealthGuidanceScreen> {
  List<dynamic> guids = []; // النصائح من الباك-إند
  bool isLoading = true;

  // ✅ نصائح ثابتة يتم عرضها دائمًا
  final List<Map<String, String>> staticTips = [
    {
      "Title": "اشرب الماء بانتظام",
      "Content": "تناول 8 أكواب من الماء يوميًا يعزز من نشاط الجسم.",
      "GuidelineType": "صحي"
    },
    {
      "Title": "نم جيدًا",
      "Content": "الحصول على 7-8 ساعات نوم ليلاً مهم لصحتك العامة.",
      "GuidelineType": "نوم"
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchGuids();
  }

  Future<void> fetchGuids() async {
    var userid = int.parse(logindata['user']['UserID'].toString());
    final response = await http.get(
      Uri.parse('$baseurl/index.php?action=fetch_guidelines&user_id=$userid'),
    );
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> guidelines = jsonDecode(response.body);
        guids = (guidelines['guidelines'] ?? []).cast<dynamic>();
        isLoading = false;
      });
    } else {
      print("Failed to load guidelines");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ دمج النصائح الثابتة مع القادمة من الباك-إند
    final allTips = [...staticTips, ...guids];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإرشاد والتوعية الصحية'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allTips.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد تنبيهات متاحة.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: allTips.length,
                    itemBuilder: (context, index) {
                      final tip = allTips[index];
                      return Card(
                        child: ListTile(
                          title: Text(tip["Title"] ?? "غير معروف"),
                          subtitle: Text(tip["Content"] ?? "غير معروف"),
                          trailing: Text(tip["GuidelineType"] ?? "غير معروف"),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
