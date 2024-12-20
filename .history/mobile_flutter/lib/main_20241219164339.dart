import 'package:flutter/material.dart';
import 'pages/login_page.dart'; 
import 'pages/signup_page.dart'; 
import 'package:flutter/foundation.dart'; 
import 'pages/dashboard_page.dart'; // Add this import for kIsWeb
// Make sure to import your login page

void main() {
    if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Payroll Admin',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B2C91),
    ),
    fontFamily: 'Noto Sans',  // Add this line
    useMaterial3: true,
  ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
         '/signup': (context) => const SignUpPage(),
  '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}