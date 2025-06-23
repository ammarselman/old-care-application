import 'dart:convert';
import 'package:care_old/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var baseurl = "http://192.168.1.102/xampp/back";
Map<String, dynamic> logindata = {};
var username;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureTextPassword = true;
  final _formKey = GlobalKey<FormState>();
  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('$baseurl/index.php?action=login'),
        body: jsonEncode({
          "phone": phoneController.text,
          "password": passwordController.text
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body);
          logindata = data;
          print(logindata);
          username = logindata['user']['Name'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('✅ تم تسجيل الدخول: ${responseData['message']}')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["message"] ?? "فشل تسجيل الدخول")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              color: const Color.fromARGB(255, 111, 172, 221),
              child: const Column(
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.health_and_safety_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سجل دخولك لحسابك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefix: const Icon(Icons.phone),
                        hintText: 'رقم الهاتف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureTextPassword,
                      decoration: InputDecoration(
                        prefix: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureTextPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
                            });
                          },
                        ),
                        hintText: 'كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء ادخال كلمة المرور';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 111, 172, 221),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/register");
                          },
                          child: const Text(
                            'سجل هنا',
                            style: TextStyle(
                              color: Color.fromARGB(255, 111, 172, 221),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text("أليس لديك حساب؟"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
