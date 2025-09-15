import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Import the new login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Student Hub",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LoginPage(), // Set LoginPage as the home
    );
  }
}
