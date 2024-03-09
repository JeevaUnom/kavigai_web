// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, avoid_print

import 'package:flutter/material.dart';
import '../Components/Navbar.dart';
import 'package:kavigai/Pages/ChatPage.dart'; // Import the ChatPage widget

class Todo {
  final String name;
  final String description;
  DateTime beginDate;
  DateTime endDate;
  final String status;

  Todo({
    required this.name,
    required this.description,
    required this.beginDate,
    required this.endDate,
    required this.status,
  });
}

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _beginDate;
  late DateTime _endDate;
  late String _status;

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _beginDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 7));
    _status = 'New';
  }

  void _saveTodo() {
    final todo = Todo(
      name: _nameController.text,
      description: _descriptionController.text,
      beginDate: _beginDate,
      endDate: _endDate,
      status: _status,
    );

    setState(() {
      _todos.add(todo);
      _nameController.clear();
      _descriptionController.clear();
      _beginDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 7));
      _status = 'New';
    });
  }

  Widget _buildTodoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _todos.map((todo) {
        double beginDateMilliseconds =
            todo.beginDate.millisecondsSinceEpoch.toDouble();
        double endDateMilliseconds =
            todo.endDate.millisecondsSinceEpoch.toDouble();
        double minMilliseconds = _beginDate.millisecondsSinceEpoch.toDouble();
        double maxMilliseconds = _endDate.millisecondsSinceEpoch.toDouble();

        // Ensure that beginDate and endDate are within the range of min and max
        if (beginDateMilliseconds < minMilliseconds) {
          beginDateMilliseconds = minMilliseconds;
        } else if (beginDateMilliseconds > maxMilliseconds) {
          beginDateMilliseconds = maxMilliseconds;
        }
        if (endDateMilliseconds < minMilliseconds) {
          endDateMilliseconds = minMilliseconds;
        } else if (endDateMilliseconds > maxMilliseconds) {
          endDateMilliseconds = maxMilliseconds;
        }

        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(todo.name),
            ),
            Expanded(
              flex: 3,
              child: RangeSlider(
                values: RangeValues(beginDateMilliseconds, endDateMilliseconds),
                min: minMilliseconds,
                max: maxMilliseconds,
                onChanged: (RangeValues values) {
                  setState(() {
                    todo.beginDate = DateTime.fromMillisecondsSinceEpoch(
                        values.start.toInt());
                    todo.endDate =
                        DateTime.fromMillisecondsSinceEpoch(values.end.toInt());
                  });
                },
                labels: RangeLabels(
                  _formatDate(todo.beginDate),
                  _formatDate(todo.endDate),
                ),
                divisions: 365,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Page'),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(),
            Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Todo',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child:
                                Text('Begin Date: ${_formatDate(_beginDate)}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectBeginDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text('End Date: ${_formatDate(_endDate)}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectEndDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _status,
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                        items: ['New', 'Optional', 'Completed']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _saveTodo();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(height: 32),
                      const Text('Todos:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildTodoList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the chatbot as a modal bottom sheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const ChatPage(), // Display the ChatPage widget
              );
            },
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _selectBeginDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _beginDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate != null) {
      setState(() {
        _beginDate = selectedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _beginDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _submitTodo() {
    // Implement your logic to store and display the entered data here
    print('Name: ${_nameController.text}');
    print('Description: ${_descriptionController.text}');
    print('Begin Date: ${_formatDate(_beginDate)}');
    print('End Date: ${_formatDate(_endDate)}');
    print('Status: $_status');
    // Reset form fields
    _formKey.currentState!.reset();
    setState(() {
      _beginDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 7));
      _status = 'New';
    });
  }
}
