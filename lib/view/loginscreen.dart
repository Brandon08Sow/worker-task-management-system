import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../myconfig.dart';
import 'mainscreen.dart';

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

  void _loadRememberedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Worker Task Management System",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                            onChanged: (bool? value) {
                              setState(() => rememberMe = value ?? false);
                            },
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
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text("Forgot Password?"),
                                  content: const Text(
                                    "Please contact the system administrator to reset your password.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Back to main menu
                        },
                        child: const Text(
                          "Back to Main Menu",
                          style: TextStyle(color: Colors.black87),
                        ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType inputType, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.yellow[50],
      ),
    );
  }

  void _onLoginPressed() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please fill in both email and password.");
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("${MyConfig.server}/login_user.php");

    try {
      final response = await http.post(
        url,
        body: {"email": email, "password": password},
      );

      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        final user = jsonData['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", user['id']);
        await prefs.setString("name", user['full_name']);
        await prefs.setString("email", user['email']);
        await prefs.setString("phone", user['phone']);
        await prefs.setString("address", user['address']);

        // Save login only if rememberMe is checked
        if (rememberMe) {
          await prefs.setBool("remember_me", true);
          await prefs.setString("remember_email", email);
          await prefs.setString("remember_password", password);
        } else {
          await prefs.remove("remember_me");
          await prefs.remove("remember_email");
          await prefs.remove("remember_password");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => MainScreen(
                  id: user['id'],
                  fullName: user['full_name'],
                  email: user['email'],
                  phone: user['phone'],
                  address: user['address'],
                ),
          ),
        );
      } else {
        _showMessage("Login failed. Please check your credentials.");
      }
    } catch (e) {
      _showMessage("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isSuccess ? "Success" : "Error"),
            content: Text(message),
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
