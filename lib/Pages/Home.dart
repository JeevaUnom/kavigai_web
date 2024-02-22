// ignore: file_names
import 'package:flutter/material.dart';
import '../components/navbar.dart'; // Import the NavBar file
// ignore: unused_import
import 'package:intl/intl.dart';
import '../Components/todo_list.dart';

class HomePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomePage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add the NavBar
          const NavBar(),
          TodoList(controller: _todoController),
        ],
      ),
    );
  }
}
