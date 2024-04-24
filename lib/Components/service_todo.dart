// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

class TodoForm extends StatefulWidget {
  final Function(Todo) onSave;

  const TodoForm({required this.onSave});
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _beginDate;
  late DateTime _endDate;
  late String _status;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beginDate = DateTime.now();
    _endDate = _beginDate.add(const Duration(days: 7));
    _status = 'New';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      final Todo todo = Todo(
        name: _nameController.text,
        description: _descriptionController.text,
        beginDate: _beginDate,
        endDate: _endDate,
        status: _status,
      );

      final Uri url = Uri.parse('http://127.0.0.1:5000/api/todos');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'todoName': todo.name,
            'todoDescription': todo.description,
            'todoBeginDate': DateFormat('yyyy-MM-dd').format(todo.beginDate),
            'todoEndDate': DateFormat('yyyy-MM-dd').format(todo.endDate),
            'todoStatus': todo.status,
            'id': 1,
          }),
        );
        print('Request sent to server');

        if (response.statusCode == 201) {
          // If the server returns a success status code
          print(response);
          // widget.onSave(todo);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Todo saved successfully')),
          // );
          // // Clear form fields if needed
          // _nameController.clear();
          // _descriptionController.clear();
          // // Optionally, update the state to reflect the new todo
          // setState(() {
          //   // Update state if needed
          // });
        } else {
          // If the server returns an error status code
          print(response);
          // print('Failed to save todo: ${response.body}');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Failed to save todo')),
          // );
        }
      } catch (e) {
        print('Error sending request: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Todo Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Todo Name *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter todo name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Todo Description *',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter todo description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Begin Date',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _beginDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _beginDate = selectedDate;
                                if (_beginDate.isAfter(_endDate)) {
                                  _endDate =
                                      _beginDate.add(const Duration(days: 7));
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _beginDate.toString().substring(0, 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _endDate = selectedDate;
                                if (_endDate.isBefore(_beginDate)) {
                                  _beginDate = _endDate;
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endDate.toString().substring(0, 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ['New', 'In Progress', 'Completed', 'Optional']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Todo todo = Todo(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      beginDate: _beginDate,
                      endDate: _endDate,
                      status: _status,
                    );
                    widget.onSave(todo);
                    _saveTodo();
                    // Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExistingTodosDialog extends StatelessWidget {
  final Function(Todo) onSelect; // Define onSelect function

  const ExistingTodosDialog({required this.onSelect});
  Future<List<Todo>> _fetchTodos() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/todos'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['todos'];
      List<Todo> todos = data.map((item) {
        return Todo(
          name: item['todoName'],
          description: item['todoDescription'],
          beginDate: DateTime.parse(item['todoBeginDate']),
          endDate: DateTime.parse(item['todoEndDate']),
          status: item['todoStatus'],
        );
      }).toList();
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _fetchTodos(), // Pass any required date here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Todo> todos = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing Todos ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(todos[index].name),
                          subtitle: Text(
                            'Status: ${todos[index].status}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              onSelect(todos[index]);
                              // Navigator.pop(
                              // context); // Close the dialog after adding todo
                            },
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
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
