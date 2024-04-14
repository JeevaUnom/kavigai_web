// // ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, duplicate_ignore

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:email_validator/email_validator.dart';

// class LoginPage1 extends StatefulWidget {
//   const LoginPage1({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage1> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   String emailErrorText = '';
//   String passwordErrorText = '';

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Welcome to Kavigai",
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   "Sign in Page",
//                   style: TextStyle(
//                       fontSize: 30,
//                       color: Color.fromARGB(255, 3, 5, 133),
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Center(
//                   child: Image.asset(
//                     'assets/images/lock.jpg',
//                     width: 150,
//                     height: 150,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Email ID",
//                     labelStyle:
//                         TextStyle(fontSize: 15, color: Colors.grey.shade400),
//                     errorText: emailErrorText,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Enter Password",
//                     labelStyle:
//                         TextStyle(fontSize: 15, color: Colors.grey.shade400),
//                     errorText: passwordErrorText,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 const Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     "Forget Password?",
//                     style:
//                         TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Add logic for form validation and authentication
//                     _handleLogin();
//                   },
//                   child: Container(
//                     alignment: Alignment.center,
//                     height: size.height / 14,
//                     width: size.width,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 35, 245, 245),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: const Text(
//                       "Login ",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 0, 0, 0),
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "I'm a new User - ",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 211, 136, 23),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleLogin() async {
//     // Perform form validation
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       setState(() {
//         emailErrorText =
//             emailController.text.isEmpty ? 'Email is required' : '';
//         passwordErrorText =
//             passwordController.text.isEmpty ? 'Password is required' : '';
//       });
//       return;
//     } else {
//       // Check if the entered email follows a valid format
//       bool isEmailValid = _isEmailValid(emailController.text);

//       if (!isEmailValid) {
//         setState(() {
//           emailErrorText = 'Invalid email format';
//           passwordErrorText = '';
//         });
//         return;
//       } else {
//         setState(() {
//           emailErrorText = '';
//           passwordErrorText = '';
//         });
//       }
//     }

//     // Make HTTP POST request to your backend API
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:5000/api/login'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': emailController.text,
//         'password': passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Login successful, navigate to home page
//       Navigator.pushNamed(context, '/home');
//     } else {
//       // Login failed, show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Login failed. Please try again.'),
//         ),
//       );
//     }
//   }

//   bool _isEmailValid(String email) {
//     // Use the built-in EmailValidator class from the 'email_validator' package
//     return EmailValidator.validate(email);
//   }
// }
