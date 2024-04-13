// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Event {
  final int eventId;
  final String domain;
  final String title;
  final DateTime beginDate;
  final DateTime endDate; // Add endDate property
  final String location;
  final String speaker;
  final String eventMode;
  final String description;

  Event({
    required this.eventId,
    required this.domain,
    required this.title,
    required this.beginDate,
    required this.endDate,
    required this.location,
    required this.speaker,
    required this.eventMode,
    required this.description,
  });
}

class EventForm extends StatefulWidget {
  final Function(Event) onSave;

  const EventForm({required this.onSave});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late String _domain;
  late String _title;
  late DateTime _beginDate;
  late DateTime _endDate;
  late String _location;
  late String _speaker;
  late String _eventMode;
  late String _description;
  TextEditingController _domainController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _beginDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _speakerController = TextEditingController();
  TextEditingController _eventModeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beginDate = DateTime.now();
    _endDate = _beginDate
        .add(Duration(hours: 2)); // Default end date 2 hours after begin date
  }

  @override
  void dispose() {
    _domainController.dispose();
    _titleController.dispose();
    _beginDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    _speakerController.dispose();
    _eventModeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Event Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _domainController,
                decoration: const InputDecoration(
                  labelText: 'Domain *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter domain';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _beginDateController,
                decoration: const InputDecoration(
                  labelText: 'Begin Date *',
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _beginDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _beginDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _beginDateController.text =
                            _beginDate.toString().substring(0, 16);
                        // Set default end date 2 hours after begin date
                        _endDate = _beginDate.add(Duration(hours: 2));
                        _endDateController.text =
                            _endDate.toString().substring(0, 16);
                      });
                    }
                  }
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date *',
                ),
                onTap: () async {
                  // Similar to Begin Date onTap method
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speakerController,
                decoration: const InputDecoration(
                  labelText: 'Speaker *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter speaker';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventModeController,
                decoration: const InputDecoration(
                  labelText: 'Event Mode *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event mode';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Event event = Event(
                      eventId: 0, // Set a default value for eventId
                      domain: _domainController.text,
                      title: _titleController.text,
                      beginDate: _beginDate,
                      endDate: _endDate,
                      location: _locationController.text,
                      speaker: _speakerController.text,
                      eventMode: _eventModeController.text,
                      description: _descriptionController.text,
                    );
                    widget.onSave(event);
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

class ExistingEventsDialog extends StatelessWidget {
  final Function(Event) onSelect; // Define onSelect function

  const ExistingEventsDialog({required this.onSelect});

  Future<List<Event>> _fetchEvents() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/events'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['events'];
      List<Event> events = data.map((item) {
        return Event(
          eventId: item['event_id'],
          domain: item['domain'],
          title: item['title'],
          beginDate: DateTime.parse(item['begin_date']),
          endDate:
              DateTime.parse(item['end_date']), // Parse the end date as well
          location: item['location'],
          speaker: item['speaker'],
          eventMode: item['event_mode'],
          description: item['description'],
        );
      }).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Event> events = snapshot.data!;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing Events',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(events[index].title),
                          subtitle: Text(
                            'Begin Date: ${events[index].beginDate.toString().substring(0, 16)}\nEnd Date: ${events[index].endDate.toString().substring(0, 16)}\nLocation: ${events[index].location}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              onSelect(events[index]);
                              Navigator.pop(
                                  context); // Close the dialog after selecting event
                            },
                          ),
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
