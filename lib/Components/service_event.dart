// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_field, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Event {
  // final int eventId;
  final String domain;
  final String title;
  DateTime beginDate;
  DateTime endDate; 
  final String location;
  final String speaker;
  final String eventMode;
  final String description;
  final String status;

  Event({
    // required this.eventId,
    required this.domain,
    required this.title,
    required this.beginDate,
    required this.endDate,
    required this.location,
    required this.speaker,
    required this.eventMode,
    required this.description,
    required this.status,
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
  late String _status;
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _beginDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();
  final TextEditingController _eventModeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beginDate = DateTime.now();
    _endDate = _beginDate.add(
        const Duration(hours: 2)); // Default end date 2 hours after begin date
    _status = 'New';
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

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final Event event = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        beginDate: _beginDate,
        endDate: _endDate,
        domain: _domainController.text,
        location: _locationController.text,
        speaker: _speakerController.text,
        eventMode: _eventModeController.text,
        status: _status,
      );

      final Uri url = Uri.parse('http://127.0.0.1:5000/api/events');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'eventTitle': event.title,
            'eventDomain': event.domain,
            'eventDescription': event.description,
            'eventBeginDate':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.beginDate),
            'eventEndDate':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(event.endDate),
            'eventLocation': event.location,
            'eventSpeaker': event.speaker,
            'eventStatus': event.status,
            'eventMode': event.eventMode,
          }),
        );
        print('Request sent to server');

        if (response.statusCode == 201) {
          print("saved");
        } else {
          print("failed");
        }
      } catch (e) {
        // print(e);
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
                        _endDate = _beginDate.add(const Duration(hours: 2));
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
                    Event event = Event(
                      // eventId: 0, // Set a default value for eventId
                      domain: _domainController.text,
                      title: _titleController.text,
                      beginDate: _beginDate,
                      endDate: _endDate,
                      location: _locationController.text,
                      speaker: _speakerController.text,
                      eventMode: _eventModeController.text,
                      description: _descriptionController.text,
                      status: _status,
                    );
                    widget.onSave(event);
                    _saveEvent();
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
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/api/events'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['events'];
        List<Event> events = data.map((item) {
          return Event(
            // eventId: item['eventId'],
            domain: item['eventDomain'],
            title: item['eventTitle'],
            beginDate: DateTime.parse(item['eventBeginDate']),
            endDate: DateTime.parse(item['eventEndDate']),
            location: item['eventLocation'],
            speaker: item['eventSpeaker'],
            eventMode: item['eventMode'],
            description: item['eventDescription'],
            status: item['eventStatus'],
          );
        }).toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      throw Exception('Error fetching events: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                  const Text(
                    'Existing Events',
                    style: TextStyle(
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
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              onSelect(events[index]);
                              // Navigator.pop(
                              //     context); // Close the dialog after selecting event
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
