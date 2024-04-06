// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/navbar.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;

  // ignore: use_super_parameters
  const ProfilePage({Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Color.fromARGB(255, 241, 244, 247),
      ),
      body: Column(
        children: [
          const NavBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Name: $userName'),
                ),
                ListTile(
                  title: Text('Email: $userEmail'),
                ),
                // Add more user information as needed
              ],
            ),
          ),
          // Your ProfilePage content goes here
        ],
      ),
    );
  }
}
