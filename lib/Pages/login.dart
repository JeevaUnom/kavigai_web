// ignore_for_file: dead_code, use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String emailErrorText = '';
  String passwordErrorText = '';
  String usernameErrorText = '';
  String confirmPasswordErrorText = '';
  bool isLoginPage = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Kavigai",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  isLoginPage ? "Sign in Page" : "Sign up Page",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 3, 5, 133),
                      fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/lock.jpg',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (!isLoginPage)
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Enter Username",
                      labelStyle:
                          TextStyle(fontSize: 15, color: Colors.grey.shade400),
                      errorText: usernameErrorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Email ID",
                    labelStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    errorText: emailErrorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    labelStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    errorText: passwordErrorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (!isLoginPage) ...[
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle:
                          TextStyle(fontSize: 15, color: Colors.grey.shade400),
                      errorText: confirmPasswordErrorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 5,
                ),
                if (isLoginPage)
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    if (isLoginPage) {
                      _handleLogin();
                    } else {
                      _handleSignUp();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height / 14,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 35, 245, 245),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      isLoginPage ? "Login" : "Sign Up",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLoginPage
                          ? "I'm a new User - "
                          : "Already have an account? ",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: Text(
                        isLoginPage ? "Sign Up" : "Login",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 211, 136, 23),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    // Perform form validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        emailErrorText =
            emailController.text.isEmpty ? 'Email is required' : '';
        passwordErrorText =
            passwordController.text.isEmpty ? 'Password is required' : '';
      });
      return;
    } else {
      // Check if the entered email follows a valid format
      bool isEmailValid = _isEmailValid(emailController.text);

      if (!isEmailValid) {
        setState(() {
          emailErrorText = 'Invalid email format';
          passwordErrorText = '';
        });
        return;
      } else {
        setState(() {
          emailErrorText = '';
          passwordErrorText = '';
        });
      }

      // Check if the password meets the minimum length requirement
      if (passwordController.text.length < 8) {
        setState(() {
          passwordErrorText = 'Password must be at least 8 characters long';
        });
        return;
      } else {
        setState(() {
          passwordErrorText = '';
        });
      }
    }

    // Add your authentication logic here.
    // For demonstration purposes, assume authentication is successful.
    bool authenticationSuccessful = true;

    if (authenticationSuccessful) {
      // Navigate to the home page without replacing the current route
      Navigator.pushNamed(context, '/home');
    } else {
      // Handle authentication failure
      // You may display an error message or take other actions.
    }
  }

  Future<void> _handleSignUp() async {
    // Perform form validation
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        usernameErrorText =
            usernameController.text.isEmpty ? 'Username is required' : '';
        emailErrorText =
            emailController.text.isEmpty ? 'Email is required' : '';
        passwordErrorText =
            passwordController.text.isEmpty ? 'Password is required' : '';
        confirmPasswordErrorText = confirmPasswordController.text.isEmpty
            ? 'Confirm Password is required'
            : '';
      });
      return;
    } else {
      // Check if the entered email follows a valid format
      bool isEmailValid = _isEmailValid(emailController.text);

      if (!isEmailValid) {
        setState(() {
          emailErrorText = 'Invalid email format';
          passwordErrorText = '';
          confirmPasswordErrorText = '';
        });
        return;
      } else {
        setState(() {
          emailErrorText = '';
          passwordErrorText = '';
          confirmPasswordErrorText = '';
        });
      }

      // Check if the password meets the minimum length requirement
      if (passwordController.text.length < 8) {
        setState(() {
          passwordErrorText = 'Password must be at least 8 characters long';
          confirmPasswordErrorText = '';
        });
        return;
      } else {
        setState(() {
          passwordErrorText = '';
        });
      }

      // Check if password and confirm password match
      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          confirmPasswordErrorText = 'Passwords do not match';
        });
        return;
      } else {
        setState(() {
          confirmPasswordErrorText = '';
        });
      }
    }
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful, navigate to home page
        Navigator.pushNamed(context, '/home');
      } else {
        // Registration failed, display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      // Error occurred during registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  // Add your sign-up logic here.
  // For demonstration purposes, assume sign-up is successful.
  bool signUpSuccessful = true;

  bool _isEmailValid(String email) {
    // Use the built-in EmailValidator class from the 'email_validator' package
    return EmailValidator.validate(email);
  }
}
