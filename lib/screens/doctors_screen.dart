import 'dart:convert';

import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// واجهة قائمة الأطباء والمتخصصين التي تعرض معلومات مختصرة عن الأطباء.
class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreen();
}

class _DoctorsScreen extends State<DoctorsScreen> {
  List<dynamic> doctors = [];
  @override
  void initState() {
    super.initState();
    fetchDoctor();
  }

  Future<void> fetchDoctor() async {
    final response = await http.get(
      Uri.parse('$baseurl/index.php?action=fetch_doctors'),
    );
    if (response.statusCode == 200) {
      setState(() {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey("doctors")) {
          setState(() {
            doctors = List<Map<String, dynamic>>.from(data["doctors"]);
          });
        }
        print(doctors);
      });
    } else {
      print("Failed to load doctors");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الأطباء والمتخصصين'),
      ),
      body: doctors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final classItem = doctors[index];
                return Card(
                  child: ListTile(
                    leading: Text(classItem["Name"] ?? "غير معروف"),
                    title: Text(classItem["Specialization"] ?? "غير معروف"),
                    trailing: Text(classItem["PhoneNumber"] ?? "غير متوقر"),
                  ),
                );
              },
            ),
    );
  }
}
