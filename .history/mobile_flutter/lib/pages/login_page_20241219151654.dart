import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Purple wave background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B2C91), Color(0xFF4A1F64)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Payroll E',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                     // ... previous code remains the same ...

                        // Username field
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF6B2C91)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF6B2C91)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Error message (if any)
                        if (_error != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC3545).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: Color(0xFFDC3545),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Sign In button
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement login logic
                            if (_usernameController.text.isEmpty || 
                                _passwordController.text.isEmpty) {
                              setState(() {
                                _error = 'Please enter both username and password';
                              });
                              return;
                            }
                            // Clear error if exists
                            setState(() {
                              _error = null;
                            });
                            // Navigate to dashboard (temporary)
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A1F64),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Or divider
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or',
                                style: TextStyle(
                                  color: Color(0xFF6B2C91),
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                                                const SizedBox(height: 20),
                        
                        // Social login buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google button
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFDDDDDD),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/google-icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () {
                                  // TODO: Implement Google login
                                  print('Google login clicked');
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            
                            // Facebook button
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFDDDDDD),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/facebook-icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () {
                                  // TODO: Implement Facebook login
                                  print('Facebook login clicked');
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Color(0xFF6B2C91),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: const Text(
                                'Create',
                                style: TextStyle(
                                  color: Color(0xFF6B2C91),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
                        