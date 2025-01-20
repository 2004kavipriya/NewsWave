import 'package:flutter/material.dart';
import 'auth_methods.dart';
import 'signup_screen.dart';  // Import the signup screen
import 'city_selection.dart';    // Import your home screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  String errorMessage = '';
  bool _obscurePassword = true; // To toggle password visibility

  void showError(String error) {
    setState(() {
      errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // White background for the whole screen
            Container(
              color: Colors.white,
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50), // Spacer for centering content

                    // Log In Here Text
                    const Text(
                      'LogIn Here',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD02805),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Error Message
                    if (errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.redAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.white),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Email Input Field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          borderSide: const BorderSide(color: Colors.black),  // Black border
                        ),
                        filled: true,
                        fillColor: Colors.transparent, // Transparent background
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black),  // Black border for inactive
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black),  // Black border for active
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Input Field
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword, // Toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          borderSide: const BorderSide(color: Colors.black),  // Black border
                        ),
                        filled: true,
                        fillColor: Colors.transparent, // Transparent background
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Toggle the visibility
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login Button
                    ElevatedButton(
                      onPressed: () async {
                        final error = await _authMethods.signInWithEmailAndPassword(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        if (error != null) {
                          showError(error);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => TamilNaduCitiesScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(

                        backgroundColor: const Color(0xFFD02805), // Button color
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black), // Font color
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // Sign Up Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
