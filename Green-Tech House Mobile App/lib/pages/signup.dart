import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Import the LoginPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _passwordVisible = false;
  bool _agreeToTerms = false;

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _register() async {
    if (!_agreeToTerms) {
      _showErrorDialog(
          'Agreement Required', 'Please agree to the terms and conditions.');
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (!_isEmailValid(email)) {
      _showErrorDialog('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    if (!_isPasswordValid(password)) {
      _showErrorDialog(
          'Invalid Password', 'Password must be at least 6 characters long.');
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'role': 'user', // Default role is 'user', change as needed
        });

        _showSuccessDialog();
      } else {
        _showErrorDialog('Registration Failed', 'Failed to register.');
      }
    } catch (e) {
      print(e);
      _showErrorDialog('Registration Failed',
          'An error occurred while registering. Please try again later.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(
          'Registration successful!',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dismiss the success dialog
              Navigator.pushReplacement(
                // Push the login page and remove all routes in between
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearTextFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 13, 32, 13)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 13, 32, 13),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        // Set back arrow color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Together, let's make a greener tomorrow",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 19,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon:
                      Icon(Icons.email, color: Color.fromARGB(255, 13, 32, 13)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color.fromARGB(255, 13, 32, 13),
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  prefixIcon:
                      Icon(Icons.lock, color: Color.fromARGB(255, 13, 32, 13)),
                ),
                obscureText: !_passwordVisible,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'I agree to all the terms and conditions.',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 3, 110, 3),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _register,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 13, 32, 13)), // background color
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ), // text color
                    ),
                    child: const Text('Sign Up'),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: _clearTextFields,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
