// ignore_for_file: library_private_types_in_public_api, unused_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:kavigai/Components/Navbar.dart';
import 'package:kavigai/Components/goal_list.dart';
import '../pages/goal.dart'; // Import the Goal class
import '../Components/recommendation_list.dart'; // Import the recommendation list page

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  String _selectedService = '--select service--'; // Dropdown value holder

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
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'This is where your custom recommendation UI goes for $_selectedService.',
                ),
              ],
            ),
          ),
        );
      },
    );
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
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add service logic here
            //     if (_selectedService != '--select service--') {
            //       // Perform actions based on the selected service
            //       print('Selected service: $_selectedService');
            //     }
            //   },
            //   child: const Text('Add Service'),
            // ),
          ],
        ),
      ),
    );
  }
}
