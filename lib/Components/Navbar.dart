// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

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
          const Row(
            children: [
              NavItem('Home', '/home'),
              SizedBox(width: 20.0),
              NavItem('Goal', '/goal'),
              SizedBox(width: 20.0),
              NavItem('Service', '/service'),
              SizedBox(width: 20.0),
              NavItem('Mentor', '/mentor'),
              SizedBox(width: 20.0),
              NavItem('Profile', '/profile'),
              // SizedBox(width: 20.0),
              // NavItem('Chart', '/chart'),
            ],
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final String title;
  final String route;

  const NavItem(this.title, this.route);

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, widget.route);
      },
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _isHovered ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: _isHovered ? Colors.white : Colors.white70,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
