// ignore_for_file: unused_import, avoid_print, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Components/goal_list.dart';
import '../Components/Navbar.dart';
import 'dart:convert';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _goalDescriptionController =
      TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  DateTime _beginDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<Goal> enteredGoals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Page'),
        backgroundColor: const Color.fromARGB(255, 251, 253, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavBar(),
            const SizedBox(height: 20.0),
            if (enteredGoals
                .isNotEmpty) // Only display if there are entered goals
              GoalList(goals: enteredGoals),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalDialog(context);
        },
        tooltip: 'Add Goal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    String? selectedStatus = 'New'; // Initialize the status with 'New'

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _goalNameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Name *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _goalDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Description *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child:
                          _buildDateField('Begin Date *', _beginDate, (date) {
                        setState(() {
                          _beginDate = date ?? _beginDate;
                        });
                      }, context),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: _buildDateField('End Date *', _endDate, (date) {
                        setState(() {
                          _endDate = date ?? _endDate;
                        });
                      }, context),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL for Reference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['New', 'In Progress', 'Completed'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedStatus = newValue;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedStatus != null) {
                  _handleSubmit(
                      status:
                          selectedStatus); // Pass the selected status to the submit handler
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

// void _handleSubmit({String status = 'New'}) {
//   // Your existing submit logic here
//   print('Submit button pressed with status: $status');
//   // Additional logic to handle submission based on status
// }

  Widget _buildDateField(String labelText, DateTime? selectedDate,
      Function(DateTime?) onChanged, BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
          text: selectedDate != null
              ? selectedDate.toString().split(" ")[0]
              : ''),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context, selectedDate, onChanged);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime?) onChanged) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onChanged(pickedDate);
    }
  }

  void _handleSubmit({String? status}) async {
    // ignore: avoid_print
    print('Submit button pressed');
    if (_goalNameController.text.isNotEmpty &&
        _goalDescriptionController.text.isNotEmpty) {
      final Map<String, dynamic> goalData = {
        'name': _goalNameController.text,
        'description': _goalDescriptionController.text,
        'begin_date': DateFormat('yyyy-MM-dd')
            .format(_beginDate), // Corrected key to snake_case
        'end_date': DateFormat('yyyy-MM-dd')
            .format(_endDate), // Corrected key to snake_case
        'url': _urlController.text,
        'status': 'New', // You might want to add logic for status selection
      };

      final Uri url = Uri.parse('http://127.0.0.1:5000/api/goals');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(goalData), // Corrected method name to json.encode
      );

      if (response.statusCode == 201) {
        // Successfully saved to the database
        //_showSuccessDialog();
        // Fetch updated list of goals from the server
        final Goal newGoal = Goal(
          name: _goalNameController.text,
          description: _goalDescriptionController.text,
          beginDate: DateFormat('yyyy-MM-dd').format(_beginDate),
          endDate: DateFormat('yyyy-MM-dd').format(_endDate),
          url: _urlController.text,
          status: 'New',
        );
        setState(() {
          enteredGoals.add(newGoal);
        });
        // Clear form fields
        _goalNameController.clear();
        _goalDescriptionController.clear();
        _urlController.clear();
        setState(() {
          _beginDate;
          _endDate;
        });
      } else {
        // Failed to save to the database
        //_showErrorDialog();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch goals data when the widget is initialized
    _fetchUpdatedGoals();
  }

  Future<void> _fetchUpdatedGoals() async {
    final Uri url = Uri.parse('http://127.0.0.1:5000/api/goals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> goalsJson = json.decode(response.body)['goals'];
      final List<Goal> updatedGoals =
          goalsJson.map((goalJson) => Goal.fromJson(goalJson)).toList();
      setState(() {
        enteredGoals = updatedGoals;
      });
    } else {
      print('Failed to fetch updated goal list');
    }
  }

  // void _showSuccessDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Success'),
  //         content: const Text('Goal submitted successfully'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showErrorDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Error'),
  //         content: const Text('Failed to submit goal'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
