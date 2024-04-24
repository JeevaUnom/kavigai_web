// ignore_for_file: unused_import, avoid_print, use_super_parameters, library_private_types_in_public_api, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kavigai/Components/Navbar.dart';
import 'package:kavigai/Components/goal_list.dart';
import 'package:kavigai/Components/service_todo.dart';
// import '../pages/goal.dart'; // Import the Goal class
import 'service_book.dart';
import 'service_event.dart';
import 'service_meeting.dart';
// import 'service_todo.dort the recommendation list page

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  String _selectedService = '--select service--'; // Dropdown value holder
  final List<Todo> _todos = []; // List to hold todos
  final List<Book> _books = [];
  final List<Meeting> _meetings = [];
  final List<Event> _events = [];

  final List<String> _services = [
    '--select service--',
    'ToDo',
    'Books',
    'Events',
    'Meetings'
  ];

  void _addTodoToList(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _addExistingTodoToList(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  // Methods to handle other service actions
  void _addBookToList(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _addExistingBookToList(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _addMeetingToList(Meeting meeting) {
    setState(() {
      _meetings.add(meeting);
    });
  }

  void _addExistingMeetingToList(Meeting meeting) {
    setState(() {
      _meetings.add(meeting);
    });
  }

  void _addEventToList(Event event) {
    setState(() {
      _events.add(event);
    });
  }

  void _addExistingEventToList(Event event) {
    setState(() {
      _events.add(event);
    });
  }

  void _handleServiceSelection(String selectedService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleServiceAction(selectedService, 'New');
                      },
                      child: const Text('New'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleServiceAction(selectedService, 'Existing');
                      },
                      child: const Text('Existing'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleServiceAction(selectedService, 'Recommendation');
                      },
                      child: const Text('Recommend'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Content area to display form or list based on the selected service
                // _buildServiceContent(selectedService),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleServiceAction(String selectedService, String action) {
    switch (action) {
      case 'New':
        if (selectedService == 'ToDo') {
          // Open the TodoForm within the dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: TodoForm(
                  onSave: (todo) {
                    _addTodoToList(todo);
                    print('Todo saved: $todo');
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        } else if (selectedService == 'Books') {
          // Open the BookForm within the dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: BookForm(
                  onSave: (book) {
                    _addBookToList(book);
                    print('Book saved: $book');
                    Navigator.pop(context);
                  },
                  // onAddToGoalDetails: (Book) {},
                ),
              );
            },
          );
        } else if (selectedService == 'Meetings') {
          // Open the MeetingForm within the dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: MeetingForm(
                  onSave: (meeting) {
                    _addMeetingToList(meeting);
                    print('Meeting saved: $meeting');
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        } else if (selectedService == 'Events') {
          // Open the EventForm within the dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: EventForm(
                  onSave: (event) {
                    _addEventToList(event);
                    print('Event saved: $event');
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        } else {
          print('Action for $selectedService is not defined.');
        }
        break;
      case 'Existing':
        if (selectedService == 'ToDo') {
          // Open the ExistingTodosDialog within the dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: ExistingTodosDialog(
                  onSelect: _addExistingTodoToList,
                ),
              );
            },
          );
        } else if (selectedService == 'Books') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: ExistingBooksDialog(
                  onSelect: _addExistingBookToList,
                ),
              );
            },
          );
          // Handle action for selecting existing book
          // Implement opening book selection dialog
        } else if (selectedService == 'Meetings') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: ExistingMeetingsDialog(
                  onSelect: _addExistingMeetingToList,
                ),
              );
            },
          );
        } else if (selectedService == 'Events') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: ExistingEventsDialog(
                  onSelect: _addExistingEventToList,
                ),
              );
            },
          );
        } else {
          print('Action for $selectedService is not defined.');
        }
        break;

      case 'Recommendation':
        // Handle recommendation button action
        break;
      default:
        print('Action for $selectedService is not defined.');
    }
  }

  void _viewServiceDetails(String title) {
    // Implement functionality to view service details
    print('Viewing details of service: $title');
    // Here, you can open a dialog or navigate to a new page to show service details

    // Example: Open a dialog to display service details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Service Details'),
          content: Text('Details of service $title will be displayed here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editService(String title) {
    // Implement functionality to edit service
    print('Editing service: $title');
    // You can open a dialog or navigate to a new page to edit the service
  }

  void _deleteService(String title) {
    // Implement functionality to delete service
    print('Deleting service: $title');
    // You can show a confirmation dialog and delete the service from the list
    setState(() {
      // Assuming _todos, _meetings, _books, and _events are lists holding your services
      _todos.removeWhere((todo) => todo.name == title);
      _meetings.removeWhere((meeting) => meeting.title == title);
      _books.removeWhere((book) => book.title == title);
      _events.removeWhere((event) => event.title == title);
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
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Description: ${widget.goal.description}'),
            Text('URL: ${widget.goal.url}'),
            Text('Status: ${widget.goal.status}'),
            Text('Begin Date: ${widget.goal.beginDate}'),
            Text('End Date: ${widget.goal.endDate}'),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Add update functionality
                      },
                    ),
                    const Text('Update'), // Icon label

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Add delete functionality
                      },
                    ),
                    const Text('Delete'), // Icon label

                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Add share functionality
                      },
                    ),
                    const Text('Share'), // Icon label
                  ],
                ),
              ],
            ),
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
            const SizedBox(height: 20),
            const Text(
              'List of Services:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length +
                    _meetings.length +
                    _books.length +
                    _events
                        .length, // Combine the lengths of todo, meeting, book, and event lists
                itemBuilder: (context, index) {
                  if (index < _todos.length) {
                    // If the index is within the range of todos
                    return _buildListItem(
                      title: _todos[index].name,
                      beginDate: _todos[index].beginDate,
                      endDate: _todos[index].endDate,
                      onUpdateDate:
                          (DateTime newBeginDate, DateTime newEndDate) {
                        setState(() {
                          _todos[index].beginDate = newBeginDate;
                          _todos[index].endDate = newEndDate;
                        });
                      },
                      index: index + 1, // Adding 1 to make index start from 1
                      iconData: Icons.task,
                    );
                  } else if (index < _todos.length + _meetings.length) {
                    // If the index is within the range of meetings
                    int meetingIndex =
                        index - _todos.length; // Adjust index for meetings list
                    return _buildListItem(
                      title: _meetings[meetingIndex].title,
                      beginDate: _meetings[meetingIndex].beginDate,
                      endDate: _meetings[meetingIndex].endDate,
                      onUpdateDate:
                          (DateTime newBeginDate, DateTime newEndDate) {
                        setState(() {
                          _meetings[meetingIndex].beginDate = newBeginDate;
                          _meetings[meetingIndex].endDate = newEndDate;
                        });
                      },
                      index: index + 1, // Adding 1 to make index start from 1
                      iconData: Icons.people,
                    );
                  } else if (index <
                      _todos.length + _meetings.length + _books.length) {
                    // If the index is within the range of books
                    int bookIndex = index -
                        _todos.length -
                        _meetings.length; // Adjust index for books list
                    return _buildListItem(
                      title: _books[bookIndex].title,
                      beginDate: _books[bookIndex].beginDate,
                      endDate: _books[bookIndex].endDate,
                      onUpdateDate:
                          (DateTime newBeginDate, DateTime newEndDate) {
                        setState(() {
                          _books[bookIndex].beginDate = newBeginDate;
                          _books[bookIndex].endDate = newEndDate;
                        });
                      },
                      index: index + 1, // Adding 1 to make index start from 1
                      iconData: Icons.menu_book_outlined,
                    );
                  } else {
                    // If the index is within the range of events
                    int eventIndex = index -
                        _todos.length -
                        _meetings.length -
                        _books.length; // Adjust index for events list
                    return _buildListItem(
                      title: _events[eventIndex].title,
                      beginDate: _events[eventIndex].beginDate,
                      endDate: _events[eventIndex].endDate,
                      onUpdateDate:
                          (DateTime newBeginDate, DateTime newEndDate) {
                        setState(() {
                          _events[eventIndex].beginDate = newBeginDate;
                          _events[eventIndex].endDate = newEndDate;
                        });
                      },
                      index: index + 1, // Adding 1 to make index start from 1
                      iconData: Icons.event_available,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required DateTime beginDate,
    required DateTime endDate,
    required void Function(DateTime, DateTime) onUpdateDate,
    required int index, // New parameter for index
    required IconData iconData,
  }) {
    double _beginSliderValue = beginDate.millisecondsSinceEpoch.toDouble();
    double _endSliderValue = endDate.millisecondsSinceEpoch.toDouble();

    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$index.',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(iconData), // Display icon

                // Display index number
              ],
            ),
            title: Text(title),
            trailing: Row(
              // Add icons on the right side
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _viewServiceDetails(
                        title); // Call function to view service details
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editService(title); // Call function to edit service
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteService(title); // Call function to delete service
                  },
                ),
                const Icon(Icons.drag_handle), // Add drag icon
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              // Display begin and end dates at the start and end of the slider
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today), // Calendar icon
                    const SizedBox(width: 8),
                    Text(' ${DateFormat('dd-MM-yyyy').format(beginDate)}'),
                  ],
                ),
                Expanded(
                  // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RangeSlider(
                    values: RangeValues(_beginSliderValue, _endSliderValue),
                    min: DateTime(2024).millisecondsSinceEpoch.toDouble(),
                    max: DateTime(2026).millisecondsSinceEpoch.toDouble(),
                    onChanged: (RangeValues values) {
                      onUpdateDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            values.start.toInt()),
                        DateTime.fromMillisecondsSinceEpoch(values.end.toInt()),
                      );
                    },
                    labels: RangeLabels(
                      DateFormat('dd-MM-yyyy').format(beginDate),
                      DateFormat('dd-MM-yyyy').format(endDate),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(' ${DateFormat('dd-MM-yyyy').format(endDate)}'),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today), // Calendar icon
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
