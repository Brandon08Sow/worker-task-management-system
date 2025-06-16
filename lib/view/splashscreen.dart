import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginscreen.dart';
import 'mainscreen.dart';
import '../model/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _checkLogin);
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? fullname = prefs.getString('full_name');
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    String? address = prefs.getString('address');

    if (id != null &&
        fullname != null &&
        email != null &&
        phone != null &&
        address != null) {
      // Already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainScreen(
                user: User(
                  id: id,
                  fullname: fullname,
                  email: email,
                  phone: phone,
                  address: address,
                ),
              ),
        ),
      );
    } else {
      // Not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7AD), Color(0xFFFFE57F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hi, Worker! Nice to meet you.",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/worker_logo.png', height: 180, width: 180),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.amber),
              const SizedBox(height: 10),
              const Text(
                "Loading...",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
