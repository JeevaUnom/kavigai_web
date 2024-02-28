// ignore: file_names
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:kavigai/components/navbar.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Adjust the color based on your design
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo linking to the home page
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Image.asset(
              'assets/images/kavigai.jpg', // Replace with your logo image asset path
              width: 50.0,
              height: 50.0,
            ),
          ),

          // Navigation links
          Row(
            children: const [
              NavItem('Home', '/home'),
              SizedBox(width: 20.0),
              NavItem('Goal', '/goal'),
              SizedBox(width: 20.0),
              NavItem('Service', '/service'),
              SizedBox(width: 20.0),
              NavItem('Mentor', '/mentor'),
              SizedBox(width: 20.0),
              NavItem('Profile', '/profile'),
              SizedBox(width: 20.0),
              NavItem('Chart', '/chart'),
            ],
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final String route;

  const NavItem(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
