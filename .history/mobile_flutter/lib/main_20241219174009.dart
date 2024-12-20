import 'package:flutter/material.dart';
import 'pages/login_page.dart'; 
import 'pages/signup_page.dart'; 
import 'package:flutter/foundation.dart'; 
import 'pages/dashboard_page.dart'; 
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;


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