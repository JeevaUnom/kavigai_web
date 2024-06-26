// // ignore_for_file: unused_import, avoid_print, use_super_parameters, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:kavigai/Components/Navbar.dart';
// import 'package:kavigai/Components/goal_list.dart';
// import 'service_book.dart';
// import 'service_event.dart';
// import 'service_meeting.dart';
// import 'service_todo.dart'; 

// class GoalDetailPage extends StatefulWidget {
//   final Goal goal;

//   const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

//   @override
//   _GoalDetailPageState createState() => _GoalDetailPageState();
// }

// class _GoalDetailPageState extends State<GoalDetailPage> {
//   String _selectedService = '--select service--'; // Dropdown value holder
//   final List<Todo> _todos = []; // List to hold todos
//   final List<Book> _books = [];
//   final List<Meeting> _meetings = [];
//   final List<Event> _events = [];

//   final List<String> _services = [
//     '--select service--',
//     'ToDo',
//     'Books',
//     'Events',
//     'Meetings'
//   ];

//   void _addTodoToList(Todo todo) {
//     setState(() {
//       _todos.add(todo);
//     });
//   }

//   void _addExistingTodoToList(Todo todo) {
//     setState(() {
//       _todos.add(todo);
//     });
//   }

//   // Methods to handle other service actions
//   void _addBookToList(Book book) {
//     setState(() {
//       _books.add(book);
//     });
//   }

//   void _addExistingBookToList(Book book) {
//     setState(() {
//       _books.add(book);
//     });
//   }

//   void _addMeetingToList(Meeting meeting) {
//     setState(() {
//       _meetings.add(meeting);
//     });
//   }

//   void _addEventToList(Event event) {
//     setState(() {
//       _events.add(event);
//     });
//   }

//   void _handleServiceSelection(String selectedService) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             width: double.maxFinite,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _handleServiceAction(selectedService, 'New');
//                       },
//                       child: const Text('New'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _handleServiceAction(selectedService, 'Existing');
//                       },
//                       child: const Text('Existing'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _handleServiceAction(selectedService, 'Recommendation');
//                       },
//                       child: const Text('Recommend'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 // Content area to display form or list based on the selected service
//                 // _buildServiceContent(selectedService),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _handleServiceAction(String selectedService, String action) {
//     switch (action) {
//       case 'New':
//         if (selectedService == 'ToDo') {
//           // Open the TodoForm within the dialog box
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: TodoForm(
//                   onSave: (todo) {
//                     _addTodoToList(todo);
//                     print('Todo saved: $todo');
//                     Navigator.pop(context);
//                   },
//                 ),
//               );
//             },
//           );
//         } else if (selectedService == 'Books') {
//           // Open the BookForm within the dialog box
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: BookForm(
//                   onSave: (book) {
//                     _addBookToList(book);
//                     print('Book saved: $book');
//                     Navigator.pop(context);
//                   },
//                   // onAddToGoalDetails: (Book) {},
//                 ),
//               );
//             },
//           );
//         } else if (selectedService == 'Meetings') {
//           // Open the MeetingForm within the dialog box
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: MeetingForm(
//                   onSave: (meeting) {
//                     _addMeetingToList(meeting);
//                     print('Meeting saved: $meeting');
//                     Navigator.pop(context);
//                   },
//                 ),
//               );
//             },
//           );
//         } else if (selectedService == 'Events') {
//           // Open the EventForm within the dialog box
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: EventForm(
//                   onSave: (event) {
//                     _addEventToList(event);
//                     print('Event saved: $event');
//                     Navigator.pop(context);
//                   },
//                 ),
//               );
//             },
//           );
//         } else {
//           print('Action for $selectedService is not defined.');
//         }
//         break;
//       case 'Existing':
//         if (selectedService == 'ToDo') {
//           // Open the ExistingTodosDialog within the dialog box
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: ExistingTodosDialog(
//                   onSelect: _addExistingTodoToList,
//                 ),
//               );
//             },
//           );
//         } else if (selectedService == 'Books') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 child: ExistingBooksDialog(
//                   onSelect: _addExistingBookToList,
//                 ),
//               );
//             },
//           );
//           // Handle action for selecting existing book
//           // Implement opening book selection dialog
//         } else if (selectedService == 'Meetings') {
//           // Handle action for selecting existing meeting
//           // Implement opening meeting selection dialog
//         } else if (selectedService == 'Events') {
//           // Handle action for selecting existing event
//           // Implement opening event selection dialog
//         } else {
//           print('Action for $selectedService is not defined.');
//         }
//         break;

//       case 'Recommendation':
//         // Handle recommendation button action
//         break;
//       default:
//         print('Action for $selectedService is not defined.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Goal Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const NavBar(),
//             Text(
//               widget.goal.name,
//               style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             Text('Description: ${widget.goal.description}'),
//             Text('URL: ${widget.goal.url}'),
//             Text('Status: ${widget.goal.status}'),
//             Text('Begin Date: ${widget.goal.beginDate}'),
//             Text('End Date: ${widget.goal.endDate}'),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         // Add update functionality
//                       },
//                     ),
//                     Text('Update'), // Icon label
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // Add delete functionality
//                       },
//                     ),
//                     Text('Delete'), // Icon label
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.share),
//                       onPressed: () {
//                         // Add share functionality
//                       },
//                     ),
//                     Text('Share'), // Icon label
//                   ],
//                 ),
//               ],
//             ),
//             DropdownButton<String>(
//               value: _selectedService,
//               onChanged: (newValue) {
//                 setState(() {
//                   _selectedService = newValue!;
//                   _handleServiceSelection(_selectedService);
//                 });
//               },
//               items: _services.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'List of Services:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _todos.length +
//                     _meetings.length +
//                     _books.length +
//                     _events
//                         .length, // Combine the lengths of todo, meeting, book, and event lists
//                 itemBuilder: (context, index) {
//                   if (index < _todos.length) {
//                     // If the index is within the range of todos
//                     return ListTile(
//                       title: Text(_todos[index].name),
//                       subtitle: Text(
//                         '${_todos[index].beginDate.toString().substring(0, 10)} - ${_todos[index].endDate.toString().substring(0, 10)}',
//                       ),
//                       // Other todo details...
//                     );
//                   } else if (index < _todos.length + _meetings.length) {
//                     // If the index is within the range of meetings
//                     int meetingIndex =
//                         index - _todos.length; // Adjust index for meetings list
//                     return ListTile(
//                       title: Text(_meetings[meetingIndex].title),
//                       subtitle: Text(
//                         '${_meetings[meetingIndex].beginDate.toString().substring(0, 10)} - ${_meetings[meetingIndex].endDate.toString().substring(0, 10)}',
//                       ),
//                       // Other meeting details...
//                     );
//                   } else if (index <
//                       _todos.length + _meetings.length + _books.length) {
//                     // If the index is within the range of books
//                     int bookIndex = index -
//                         _todos.length -
//                         _meetings.length; // Adjust index for books list
//                     return ListTile(
//                       title: Text(_books[bookIndex].title),
//                       subtitle: Text(
//                         'Begin Date: ${_books[bookIndex].beginDate.toString().substring(0, 10)}\nEnd Date: ${_books[bookIndex].endDate.toString().substring(0, 10)}',
//                       ),
//                       // Other book details...
//                     );
//                   } else {
//                     // If the index is within the range of events
//                     int eventIndex = index -
//                         _todos.length -
//                         _meetings.length -
//                         _books.length; // Adjust index for events list
//                     return ListTile(
//                       title: Text(_events[eventIndex].title),
//                       subtitle: Text(
//                         'Begin Date: ${_events[eventIndex].beginDate.toString().substring(0, 10)}\nEnd Date: ${_events[eventIndex].endDate.toString().substring(0, 10)}',
//                       ),
//                       // Other event details...
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
