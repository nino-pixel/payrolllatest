import 'package:flutter/material.dart';
import 'pages/login_page.dart'; 
import 'pages/signup_page.dart'; // Make sure to import your login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll Admin',
      debugShowCheckedModeBanner: false,  // Removes the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B2C91),  // Our purple theme color
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
         '/signup': (context) => const SignUpPage(),
        // '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}