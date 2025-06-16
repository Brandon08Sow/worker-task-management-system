import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../myconfig.dart';
import 'loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final phoneC = TextEditingController();
  final addrC = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Registration"),
        backgroundColor: Colors.amber[700],
      ),
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
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "New Worker Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _field("Full Name", nameC),
                      _field(
                        "Email",
                        emailC,
                        keyType: TextInputType.emailAddress,
                        validator: _emailRule,
                      ),
                      _field(
                        "Password",
                        passC,
                        isPass: true,
                        validator: _pwdRule,
                      ),
                      _field("Phone", phoneC),
                      _field("Address", addrC),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child:
                            _loading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                        child: const Text("Already have an account? Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    bool isPass = false,
    TextInputType keyType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        obscureText: isPass,
        keyboardType: keyType,
        validator: validator ?? (v) => v!.isEmpty ? '$label is required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.yellow[50],
        ),
      ),
    );
  }

  String? _emailRule(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? _pwdRule(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse("${MyConfig.server}/register_user.php"),
        body: {
          "full_name": nameC.text,
          "email": emailC.text,
          "password": passC.text,
          "phone": phoneC.text,
          "address": addrC.text,
        },
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        _dialog("Registration failed. Try again.");
      }
    } catch (e) {
      _dialog("Error: $e");
    }
    if (mounted) setState(() => _loading = false);
  }

  void _dialog(String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Error"),
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
