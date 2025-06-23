import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:care_old/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  bool _obscureTextPassword = true;
  bool _obscureTextPassword2 = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? userType;

  Future<void> signup() async {
    try {
      final response = await http.post(
        Uri.parse('$baseurl/index.php?action=signup'),
        body: jsonEncode({
          "name": nameController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "userType": userType.toString()
        }),
      );

      final responseData = jsonDecode(response.body);
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // ✅ اطبع الاستجابة
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '✅ تم تسجيل المستخدم بنجاح: ${responseData['message']}')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["message"] ?? "فشل تسجيل المستخدم")),
        );
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$baseurl/index.php?action=signup'),
        body: jsonEncode({
          "name": nameController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "userType": userType.toString()
        }),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // ✅ اطبع الاستجابة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                    nameController, 'الاسم الكامل', Icons.person, false),
                buildTextField(
                    phoneController, 'رقم الهاتف', Icons.phone_android, false),
                buildTextField(
                    passwordController, 'كلمة المرور', Icons.lock, true),
                buildTextField(confirmpasswordController, 'تأكيد كلمة المرور',
                    Icons.lock, true),
                const SizedBox(height: 15),
                const Text('الحالة:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: ['Elderly', 'Relative', 'Assistant']
                      .map((option) => ChoiceChip(
                            label: Text(option),
                            selected: userType == option,
                            onSelected: (selected) {
                              setState(() {
                                userType = option;
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (passwordController.text !=
                            confirmpasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("كلمتا المرور لا تتطابقان")));
                        } else {
                          signup();
                        }
                      }
                    },
                    child: const Text('تسجيل', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      IconData icon, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword
            ? (controller == passwordController
                ? _obscureTextPassword
                : _obscureTextPassword2)
            : false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(controller == passwordController
                      ? _obscureTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off
                      : _obscureTextPassword2
                          ? Icons.visibility
                          : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      if (controller == passwordController) {
                        _obscureTextPassword = !_obscureTextPassword;
                      } else {
                        _obscureTextPassword2 = !_obscureTextPassword2;
                      }
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال $label';
          }

          if (controller == phoneController) {
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'يجب أن يحتوي رقم الهاتف على 10 أرقام';
            }
          }

          if (isPassword && value.length < 8) {
            return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
          }

          return null;
        },
      ),
    );
  }
}
