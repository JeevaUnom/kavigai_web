// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, avoid_print, unused_import, unused_field, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kavigai/Components/Navbar.dart';
import 'package:kavigai/Pages/ChatPage.dart';
import '../Components/service_todo.dart';
import '../Components/service_book.dart';
import '../Components/service_event.dart';
import '../Components/service_meeting.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key});

  @override
  _ServicePageState createState() => _ServicePageState();

  void onSave(Event updatedEvent) {}
}

class _ServicePageState extends State<ServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _beginDate;
  late DateTime _endDate;
  late String _status;

  List<Todo> _todos = [];
  List<Book> _books = [];
  List<Event> _events = [];
  List<Meeting> _meetings = [];
  @override
  void initState() {
    super.initState();
    _fetchTodos();
    _fetchBooks().then((books) {
      setState(() {
        _books = books;
      });
    }).catchError((error) {
      print("Error fetching books: $error");
    });
    _fetchEvents();
    _fetchMeetings();
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

  void _openTodoForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoForm(onSave: _saveNewTodo),
      ),
    );
  }

  void _saveNewTodo(Todo todo) {
    // You can handle saving the new todo here, if you wish, or directly in the form.
    setState(() {
      _todos.add(todo);
    });
  }

  void _openBookForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookForm(onSave: _saveNewBook),
      ),
    );
  }

  void _saveNewBook(Book book) {
    // You can handle saving the new todo here, if you wish, or directly in the form.
    setState(() {
      _books.add(book);
    });
  }

  void _openEventForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventForm(onSave: _saveNewEvent),
      ),
    );
  }

  void _saveNewEvent(Event event) {
    setState(() {
      _events.add(event);
    });
  }

  void _openMeetingForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingForm(onSave: _saveNewMeeting),
      ),
    );
  }

  void _saveNewMeeting(Meeting meeting) {
    setState(() {
      _meetings.add(meeting);
    });
  }

  Future<void> _fetchTodos() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/api/todos'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['todos'];
        List<Todo> loadedTodos = data
            .map((item) => Todo(
                  name: item['todoName'],
                  description: item['todoDescription'],
                  beginDate: DateTime.parse(item['todoBeginDate']),
                  endDate: DateTime.parse(item['todoEndDate']),
                  status: item['todoStatus'],
                ))
            .toList();
        setState(() {
          _todos = loadedTodos;
        });
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Failed to load todos: $e');
    }
  }

  Future<List<Book>> _fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/userBooks'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['books'];
      List<Book> books = data.map((item) {
        return Book(
          title: item['bookTitle'], // Ensure consistency with Flask API key
          author: item['bookAuthor'], // Ensure consistency with Flask API key
          description:
              item['bookDescription'], // Ensure consistency with Flask API key
          pageCount:
              item['bookPageCount'], // Ensure consistency with Flask API key
          genre: item['bookGenre'], // Ensure consistency with Flask API key
          status: item['bookStatus'], // Ensure consistency with Flask API key
          beginDate: DateTime.parse(item['bookBeginDate']),
          endDate: DateTime.parse(item['bookEndDate']),
        );
      }).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Event>> _fetchEvents() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/api/events'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['events'];
        List<Event> events = data
            .map((item) => Event(
                  domain: item['eventDomain'],
                  title: item['eventTitle'],
                  beginDate: DateTime.parse(item['eventBeginDate']),
                  endDate: DateTime.parse(item['eventEndDate']),
                  location: item['eventLocation'],
                  speaker: item['eventSpeaker'],
                  eventMode: item['eventMode'],
                  description: item['eventDescription'],
                  status: item['eventStatus'],
                ))
            .toList();

        setState(() {
          _events = events;
        });
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      throw Exception('Error fetching events: $error');
    }
  }

  Future<List<Meeting>> _fetchMeetings() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/api/meetings'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['meetings'];
        List<Meeting> meetings = data
            .map((item) => Meeting(
                  title: item['meetingTitle'],
                  beginDate: DateTime.parse(item['meetingBeginDate']),
                  endDate: DateTime.parse(item['meetingEndDate']),
                  description: item['meetingDescription'],
                  status: item['meetingStatus'],
                ))
            .toList();
        setState(() {
          _meetings = meetings;
        });
        return meetings;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      throw Exception('Error fetching events: $error');
    }
  }

  void _openEditTodoForm(Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Initialize form controllers with current todo data
        _nameController.text = todo.name;
        _descriptionController.text = todo.description;
        _beginDate = todo.beginDate;
        _endDate = todo.endDate;
        _status = todo.status;

        return AlertDialog(
          title: const Text('Edit Todo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Todo Name'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Todo Description'),
                ),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_beginDate)),
                  decoration: const InputDecoration(
                    labelText: 'Begin Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _beginDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _beginDate) {
                      setState(() {
                        _beginDate = pickedDate;
                      });
                    }
                  },
                ),
                // End Date Picker
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_endDate)),
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate:
                          _beginDate, // Ensure end date is not before begin date
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _endDate) {
                      setState(() {
                        _endDate = pickedDate;
                      });
                    }
                  },
                ),
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openEditBookForm(Book book) {
    // Initialize controllers with the current book data
    TextEditingController titleController =
        TextEditingController(text: book.title);
    TextEditingController authorController =
        TextEditingController(text: book.author);
    TextEditingController descriptionController =
        TextEditingController(text: book.description);
    TextEditingController beginDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(book.beginDate));
    TextEditingController endDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(book.endDate));
    String? selectedStatus = book.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: book.beginDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      beginDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      book.beginDate =
                          pickedDate; // Update the beginDate of the book
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: beginDateController,
                      decoration: const InputDecoration(
                        labelText: 'Begin Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: book.endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      endDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      book.endDate =
                          pickedDate; // Update the endDate of the book
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
// Update the book with new details
                setState(() {
                  book.title = titleController.text;
                  book.author = authorController.text;
                  book.description = descriptionController.text;
                  book.beginDate =
                      DateFormat('yyyy-MM-dd').parse(beginDateController.text);
                  book.endDate =
                      DateFormat('yyyy-MM-dd').parse(endDateController.text);
                  book.status = selectedStatus;
                });
                Navigator.of(context).pop(); // Close the dialog after saving
              },
            ),
          ],
        );
      },
    );
  }

  void _openEditEventForm(Event event) {
    TextEditingController titleController =
        TextEditingController(text: event.title);
    TextEditingController locationController =
        TextEditingController(text: event.location);
    TextEditingController descriptionController =
        TextEditingController(text: event.description);
    DateTime beginDate = event.beginDate;
    DateTime endDate = event.endDate;
    String selectedStatus = event.status;
    String eventMode = event.eventMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: beginDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        beginDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(beginDate)),
                      decoration: const InputDecoration(
                        labelText: 'Begin Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(endDate)),
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context)
                  .pop(), // Close the dialog without saving
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
// Construct the updated event with new details
                Event updatedEvent = Event(
                  domain: event.domain, // Assuming domain remains constant
                  title: titleController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                  beginDate: beginDate,
                  endDate: endDate,
                  speaker: event.speaker, // Assuming speaker remains constant
                  eventMode: eventMode,
                  status: selectedStatus,
                );
// Call onSave callback to save the updated event details
                widget.onSave(updatedEvent);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
            ),
          ],
        );
      },
    );
  }

  void _openEditMeetingForm(Meeting meeting) {
    TextEditingController titleController =
        TextEditingController(text: meeting.title);
    TextEditingController descriptionController =
        TextEditingController(text: meeting.description);
    DateTime beginDate = meeting.beginDate;
    DateTime endDate = meeting.endDate;
    String selectedStatus = meeting.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Meeting'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: beginDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != beginDate) {
                      setState(() {
                        beginDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(beginDate)),
                      decoration: const InputDecoration(
                        labelText: 'Begin Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != endDate) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(endDate)),
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
// Construct the updated meeting with new details
                Meeting updatedMeeting = Meeting(
                  title: titleController.text,
                  description: descriptionController.text,
                  beginDate: beginDate,
                  endDate: endDate,
                  status: selectedStatus,
                );
// Call onSave callback to save the updated meeting details
                // widget.onSave(updatedMeeting);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        // Title section with icons
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                todo.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {
                _openEditTodoForm(todo);
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {},
            ),
          ],
        ),
        leading: const Icon(Icons.event_note), // Leading icon for the tile
        childrenPadding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Begin Date:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_formatDate(todo.beginDate)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("End Date:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_formatDate(todo.endDate)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(todo.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(todo.description),
        ],
      ),
    );
  }

  Widget _buildBookItem(Book book) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        // Title section with icons
        title: Row(
          children: [
            Expanded(
              child: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {
                _openEditBookForm(
                    book); // Assuming this method is implemented similarly to todos
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {
                _deleteBook(book); // Assuming this method is implemented
              },
            ),
          ],
        ),
        leading: const Icon(Icons.book), // Leading icon for the book tile
        childrenPadding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Author:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(book.author),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Page Count:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(book.pageCount.toString()),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Genre:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(book.genre),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Begin Date:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_formatDate(book.beginDate)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("End Date:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_formatDate(book.endDate)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(book.status),
            ],
          ),
          const SizedBox(height: 8),
          Text("Description: ${book.description}"),
        ],
      ),
    );
  }

  // Helper function to format dates
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Widget buildEventsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) => _buildEventItem(_events[index]),
      ),
    );
  }

  Widget buildMeetingsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: _meetings.length,
        itemBuilder: (context, index) => _buildMeetingItem(_meetings[index]),
      ),
    );
  }

  Widget _buildEventItem(Event event) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Aligns items on the row's main axis
          children: [
            Expanded(
              // This ensures the title doesn't get squashed by the icons
              child: Text(event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisSize:
                  MainAxisSize.min, // Makes the row as small as possible
              children: [
                IconButton(
                  icon: const Icon(Icons.edit,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    // handle event edit
                    _openEditEventForm(event);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Color.fromARGB(255, 0, 5, 5)),
                  onPressed: () {
                    // handle event delete
                    _deleteEvent(event);
                  },
                ),
              ],
            )
          ],
        ),
        leading: const Icon(Icons.event),
        children: [
          ListTile(
            title: Text('Domain: ${event.domain}'),
            subtitle: Text('Speaker: ${event.speaker}'),
          ),
          ListTile(
            title: Text('Starts: ${_formatDate(event.beginDate)}'),
            subtitle: Text('Ends: ${_formatDate(event.endDate)}'),
          ),
          ListTile(
            title: Text('Location: ${event.location}'),
            subtitle: Text('Mode: ${event.eventMode}'),
          ),
          ListTile(
            title: Text('Status: ${event.status}'),
            subtitle: Text('Description: ${event.description}'),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                meeting.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {
                _openEditMeetingForm(meeting);
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Color.fromARGB(255, 0, 5, 5)),
              onPressed: () {},
            ),
          ],
        ),
        leading: const Icon(Icons.meeting_room),
        children: [
          ListTile(
            title: Text(
                'Starts: ${DateFormat('yyyy-MM-dd HH:mm').format(meeting.beginDate)}'),
            subtitle: Text(
                'Ends: ${DateFormat('yyyy-MM-dd HH:mm').format(meeting.endDate)}'),
          ),
          ListTile(
            title: const Text('Status:'),
            subtitle: Text(meeting.status),
          ),
          ListTile(
            title: const Text('Description:'),
            subtitle: Text(meeting.description),
          ),
        ],
      ),
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
            buildSection('Todos', _todos, _openTodoForm, _buildTodoItem),
            buildSection('Books', _books, _openBookForm, _buildBookItem),
            buildSection('Events', _events, _openEventForm, _buildEventItem),
            buildSection(
                'Meeting', _meetings, _openMeetingForm, _buildMeetingItem)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const ChatPage(),
              );
            },
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget buildSection<T>(String title, List<T> items, VoidCallback onAdd,
      Widget Function(T) buildItem) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[300]!,
                  Colors.blue[100]!
                ], // Ensure colors are not null
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title (${items.length})',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .black87 // Optional: Change text color if needed
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  onPressed: onAdd,
                ),
              ],
            ),
          ),
          Container(
            height: 200, // You can adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => buildItem(items[index]),
            ),
          ),
        ],
      ),
    );
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
}

// void _confirmDeleteMeeting(Meeting meeting) {
// }

// void _openEditBookForm(Book book) {}

void _deleteBook(Book book) {}

// void _openEditEventForm(Event event) {}

void _deleteEvent(Event event) {}
