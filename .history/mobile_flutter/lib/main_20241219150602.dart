import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B2C91),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // Add these routes when you create the pages
        // '/signup': (context) => const SignUpPage(),
        // '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}