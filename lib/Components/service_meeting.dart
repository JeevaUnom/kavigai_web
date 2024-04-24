// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Meeting {
  final String title;
  DateTime beginDate;
  DateTime endDate;
  final String description;
  final String status;

  Meeting({
    required this.title,
    required this.beginDate,
    required this.endDate,
    required this.description,
    required this.status,
  });
}

class MeetingForm extends StatefulWidget {
  final Function(Meeting) onSave;

  const MeetingForm({required this.onSave});
  @override
  _MeetingFormState createState() => _MeetingFormState();
}

class _MeetingFormState extends State<MeetingForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _beginDate;
  late DateTime _endDate;
  late String _description;
  late String _status;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beginDate = DateTime.now();
    _endDate = _beginDate.add(const Duration(hours: 1));
    _status = 'Planned';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveMeeting() async {
    if (_formKey.currentState!.validate()) {
      final Meeting meeting = Meeting(
        title: _titleController.text,
        description: _descriptionController.text,
        beginDate: _beginDate,
        endDate: _endDate,
        status: _status,
      );

      final Uri url = Uri.parse('http://127.0.0.1:5000/api/meetings');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'meetingTitle': meeting.title,
            'meetingBeginDate':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(meeting.beginDate),
            'meetingEndDate':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(meeting.endDate),
            'meetingDescription': meeting.description,
            'meetingStatus': meeting.status,
          }),
        );
        print('Request sent to server');

        if (response.statusCode == 201) {
          print("Meeting saved successfully");
          // Add any further actions needed upon successful saving of meeting
        } else {
          print("Failed to save meeting: ${response.body}");
          // Handle error or show appropriate message to the user
        }
      } catch (e) {
        print('Error sending request: $e');
        // Handle error or show appropriate message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meeting Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Title *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter meeting title';
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
                                      _beginDate.add(const Duration(hours: 1));
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _beginDate.toString().substring(0, 16),
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
                                  _beginDate = _endDate
                                      .subtract(const Duration(hours: 1));
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endDate.toString().substring(0, 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: ['Planned', 'In Progress', 'Completed', 'Cancelled']
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
                    Meeting meeting = Meeting(
                      title: _titleController.text,
                      beginDate: _beginDate,
                      endDate: _endDate,
                      description: _descriptionController.text,
                      status: _status,
                    );
                    widget.onSave(meeting);
                    _saveMeeting();
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

class ExistingMeetingsDialog extends StatelessWidget {
  final Function(Meeting) onSelect; // Define onSelect function

  const ExistingMeetingsDialog({required this.onSelect});
  // Implement the function to fetch existing meetings from the server
  // Replace the URL with your actual API endpoint
  Future<List<Meeting>> _fetchMeetings() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/meetings'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['meetings'];
      List<Meeting> meetings = data.map((item) {
        return Meeting(
          title: item['meetingTitle'],
          beginDate: DateTime.parse(item['meetingBeginDate']),
          endDate: DateTime.parse(item['meetingEndDate']),
          description: item['meetingDescription'],
          status: item['meetingStatus'],
        );
      }).toList();
      return meetings;
    } else {
      throw Exception('Failed to load meetings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meeting>>(
      future: _fetchMeetings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Meeting> meetings = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing Meetings',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(meetings[index].title),
                          subtitle: Text(
                            'Begin: ${meetings[index].beginDate.toString().substring(0, 16)}\nEnd: ${meetings[index].endDate.toString().substring(0, 16)}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              onSelect(meetings[index]);
                              // Navigator.pop(
                              //     context); // Close the dialog after selecting meeting
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
