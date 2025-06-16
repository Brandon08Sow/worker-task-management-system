// lib/view/loginscreen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../myconfig.dart';
import 'package:lab_assignment2/view/mainscreen.dart';
import 'package:lab_assignment2/view/registerscreen.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
  }

  Future<void> _loadRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool("remember_me") ?? false;
    if (rememberMe) {
      emailController.text = prefs.getString("remember_email") ?? "";
      passwordController.text = prefs.getString("remember_password") ?? "";
      setState(() {});
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Worker Task Management System",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      "Email",
                      emailController,
                      TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      "Password",
                      passwordController,
                      TextInputType.text,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged:
                              (v) => setState(() => rememberMe = v ?? false),
                        ),
                        const Text("Remember Me"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => _showDialog(
                            "Forgot Password?",
                            "Please contact the administrator.",
                          ),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextButton(
                      child: const Text(
                        "Register New Account",
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController c,
    TextInputType t, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: c,
      obscureText: isPassword,
      keyboardType: t,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.yellow[50],
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty)
      return _showDialog("Error", "Fill in both email and password.");

    setState(() => isLoading = true);
    try {
      final res = await http.post(
        Uri.parse("${MyConfig.server}/login_user.php"),
        body: {"email": email, "password": password},
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        final u = data['data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs
          ..setString("id", (u['id'] ?? '').toString())
          ..setString("full_name", u['full_name'] ?? '')
          ..setString("email", u['email'] ?? '')
          ..setString("phone", u['phone'] ?? '')
          ..setString("address", u['address'] ?? '');

        if (rememberMe) {
          await prefs
            ..setBool("remember_me", true)
            ..setString("remember_email", email)
            ..setString("remember_password", password);
        } else {
          await prefs.remove("remember_me");
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => MainScreen(
                    user: User(
                      id: (u['id'] ?? '').toString(),
                      fullname: u['full_name'] ?? '',
                      email: u['email'] ?? '',
                      phone: u['phone'],
                      address: u['address'],
                    ),
                  ),
            ),
          );
        }
      } else {
        _showDialog("Login failed", "Please check your credentials.");
      }
    } catch (e) {
      _showDialog("Error", "$e");
    }
    if (mounted) setState(() => isLoading = false);
  }

  void _showDialog(String title, String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }
}
