// ignore_for_file: library_private_types_in_public_api, unused_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:kavigai/Components/Navbar.dart';
import 'package:kavigai/Components/goal_list.dart';
import '../pages/goal.dart'; // Import the Goal class
import '../Components/service_list.dart'; // Import the recommendation list page
import 'package:http/http.dart' as http;

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  String _selectedService = '--select service--'; // Dropdown value holder
  // ignore: prefer_final_fields
  List<Todo> _todos = []; // List to hold todos

  final List<String> _services = [
    '--select service--',
    'ToDo',
    'Books',
    'Events',
    'Meeting'
  ];

  void _handleServiceSelection(String selectedService) {
    setState(() {
      _selectedService = selectedService;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommendation for $_selectedService',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle adding details here
                        // You can implement the logic to add details for the selected service
                        if (_selectedService == 'ToDo') {
                          // Navigate to TodoForm page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoForm(
                                onSave: (todo) {
                                  // Handle saving todo details here
                                  print('Todo saved: $todo');
                                },
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'This is where custom recommendation UI goes for $_selectedService.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTodoToList(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NavBar(),
            Text(
              widget.goal.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Description: ${widget.goal.description}'),
            Text('URL: ${widget.goal.url}'),
            Text('Status: ${widget.goal.status}'),
            Text('Begin Date: ${widget.goal.beginDate}'),
            Text('End Date: ${widget.goal.endDate}'),
            const SizedBox(height: 25),
            DropdownButton<String>(
              value: _selectedService,
              onChanged: (newValue) {
                setState(() {
                  _selectedService = newValue!;
                  _handleServiceSelection(_selectedService);
                });
              },
              items: _services.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'List of Services:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index].name),
                    subtitle: Text(
                      '${_todos[index].beginDate.toString().substring(0, 10)} - ${_todos[index].endDate.toString().substring(0, 10)}',
                    ),
                    // Other details...
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
