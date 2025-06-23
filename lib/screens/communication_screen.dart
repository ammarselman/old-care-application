import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// واجهة "التواصل مع الأطباء" تعرض رسالة توضيحية
/// وتعرض قائمة بأرقام الأطباء مع أيقونة اتصال لكل رقم.
class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreen();
}

class _CommunicationScreen extends State<CommunicationScreen> {
  List<dynamic> doctors = [];
  List<dynamic> appointments = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    fetchDoctor();
  }

  //كود لجلب الاطباء
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

//كود لتابع اظهار الموعد
  void _showReviewDialog(String doctorid) {
    TextEditingController timeController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Center(
                child: Text(
                  "الرجاء تحديد موعد الجلسة",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // حقل اختيار التاريخ
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "تاريخ الجلسة",
                      hintText: "اختر التاريخ",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setDialogState(() {
                          dateController.text =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  // حقل اختيار الوقت
                  TextField(
                    controller: timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "موعد الجلسة",
                      hintText: "اختر الوقت",
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setDialogState(() {
                          timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("إلغاء", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitMeet(
                        doctorid, dateController.text, timeController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("تأكيد"),
                ),
              ],
            );
          },
        );
      },
    );
  }

//كود ارسال الموعد
  Future<void> _submitMeet(String doctorid, String date, String time) async {
    String apiUrl = "$baseurl/index.php?action=insert_appointment";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": logindata["user"]["UserID"].toString(),
          "doctor_id": doctorid,
          "date": date,
          "time": time,
          "status": ""
        }),
      );

      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم حجز الموعد بنجاح")),
        );
      } else {
        throw Exception("فشل في تحديد موعد الجلسة: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ في تحديد موعد الجلسة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  //كود لتابع المكالمة
  Future<void> _launchCaller(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // عرض Dialog عند الفشل في إجراء المكالمة
      _showErrorDialog(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع الإغلاق بالضغط خارج الـ Dialog
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return const AlertDialog(
          title: Text("خطأ"),
          content: Text("تعذر إجراء المكالمة. الرجاء التحقق من الإعدادات."),
        );
      },
    );
  }

//كود جلب الحجوزات
  Future<void> fetchAppointments() async {
    var userid = int.parse(logindata['user']['UserID'].toString());
    assert(userid is int);
    print(userid);
    final response = await http.get(Uri.parse(
        '$baseurl/index.php?action=fetch_appointment&user_id=$userid'));
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(response.body);
        appointments = (data['appointment'] ?? []).cast<dynamic>();
        isloading = false;
        print(appointments);
      });
      _showAppointmentsDialog();
    } else {
      isloading = false;
      print("Failed to load appointments");
    }
  }

//كود اظهار الحجوزات
  void _showAppointmentsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("حجوزاتي"),
          content: isloading
              ? const Center(child: CircularProgressIndicator())
              : appointments.isEmpty
                  ? const Text("لا توجد حجوزات متاحة.")
                  : SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.5, // تخصيص ارتفاع مناسب
                      width: double
                          .maxFinite, // يسمح للـ ListView باستخدام العرض الكامل
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Text("${appointment['Name']}"),
                              title: Text(
                                "التاريخ: ${appointment['AppointmentDate']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "الوقت: ${appointment['AppointmentTime']}\nالحالة: ${appointment['Status']}",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
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
        title: const Text('التواصل مع الأطباء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note),
            onPressed: fetchAppointments,
            tooltip: "حجوزاتي",
          ),
        ],
      ),
      body: doctors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // رسالة توضيحية للتواصل مع الأطباء
                  const Text(
                    'للتواصل مع الأطباء، الرجاء اختيار الرقم المناسب للاتصال:',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // عرض قائمة الأطباء مع أرقامهم وأيقونة الاتصال
                  Expanded(
                    child: ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        return InkWell(
                          onTap: () {
                            _showReviewDialog(doctor['DoctorID'].toString());
                          },
                          child: ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.green),
                            title: Text(doctor['Name'] ?? ''),
                            subtitle: Text(doctor['PhoneNumber'] ?? ''),
                            // أيقونة الاتصال، عند الضغط عليها يتم تنفيذ _launchCaller
                            trailing: IconButton(
                              icon: const Icon(Icons.call, color: Colors.blue),
                              onPressed: () {
                                _launchCaller(context, doctor['PhoneNumber']!);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
