// goal.dart

import 'package:flutter/material.dart';
import '../Components/Navbar.dart'; // Assuming NavBar is in the same directory

class MentorPage extends StatelessWidget {
  // ignore: use_super_parameters
  const MentorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Page'),
        backgroundColor: const Color.fromARGB(
            255, 251, 253, 255), // Set the background color as desired
      ),
      body: const Column(
        children: [
          // Add the NavBar at the top of the Page
          NavBar(),
          Center(
            child: Text(
              'Your Mentor Page Content Goes Here',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
