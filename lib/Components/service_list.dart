import 'package:flutter/material.dart';

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

  TodoForm({required this.onSave});
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
    _endDate = _beginDate.add(Duration(days: 7));
    _status = 'New';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Todo Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
              SizedBox(height: 10),
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
                                  // If begin date is after end date, set end date to begin date + 7 days
                                  _endDate = _beginDate.add(Duration(days: 7));
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _beginDate.toString().substring(0, 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
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
                                  // If end date is before begin date, set begin date to end date
                                  _beginDate = _endDate;
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endDate.toString().substring(0, 10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                decoration: InputDecoration(
                  labelText: 'Status',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, create Todo object
                    Todo todo = Todo(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      beginDate: _beginDate,
                      endDate: _endDate,
                      status: _status,
                    );
                    // Call onSave callback to save the Todo
                    widget.onSave(todo);
                    Navigator.pop(context); // Close the form after saving
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
