import 'package:flutter/material.dart';
import 'package:lab_assignment2/view/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Task Management System',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const SplashScreen(),
    );
  }
}
