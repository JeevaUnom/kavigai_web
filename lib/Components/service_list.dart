// // ignore_for_file: unused_import, library_private_types_in_public_api, use_super_parameters, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:kavigai/Components/todo_list.dart';
// import 'functions.dart'; // Import functions.dart where the functions are defined

// class ServiceList extends StatefulWidget {
//   final List<TodoItem> todos;
//   final void Function(TodoItem) onAddTodo;
//   final void Function(TodoItem) onDeleteTodo;
//   final void Function(TodoItem, String) onUpdateTodo;

//   const ServiceList({
//     Key? key,
//     required this.todos,
//     required this.onAddTodo,
//     required this.onDeleteTodo,
//     required this.onUpdateTodo,
//   }) : super(key: key);

//   @override
//   _ServiceListState createState() => _ServiceListState();
// }

// class _ServiceListState extends State<ServiceList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: widget.todos.map((todo) {
//         final index = widget.todos.indexOf(todo) + 1;
//         return TodoListItem(
//           key: ValueKey(todo),
//           todo: todo,
//           serialNumber: index,
//           onDelete: () {
//             widget.onDeleteTodo(todo);
//           },
//           onUpdate: (String newText) {
//             widget.onUpdateTodo(todo, newText);
//           },
//           onUpdateTargetDate: (DateTime newDate) {
//             _updateTargetDate(newDate, todo);
//           },
//           onToUpdateTargetDate: (DateTime newDate) {
//             _updateTargetDate(newDate, todo);
//           },
//         );
//       }).toList(),
//     );
//   }

//   void _updateTargetDate(DateTime newDate, TodoItem todo) {
//     setState(() {
//       todo.updateFrom(newDate);
//     });
//   }
// }

// class TodoListItem extends StatefulWidget {
//   final TodoItem todo;
//   final VoidCallback onDelete;
//   final ValueChanged<String> onUpdate;
//   final Function(DateTime) onUpdateTargetDate;
//   final Function(DateTime) onToUpdateTargetDate;
//   final int serialNumber;

//   const TodoListItem({
//     Key? key,
//     required this.todo,
//     required this.serialNumber,
//     required this.onDelete,
//     required this.onUpdate,
//     required this.onUpdateTargetDate,
//     required this.onToUpdateTargetDate,
//   }) : super(key: key);

//   @override
//   _TodoListItemState createState() => _TodoListItemState();
// }

// class _TodoListItemState extends State<TodoListItem> {
//   late double _fromSliderValue;
//   late double _toSliderValue;

//   @override
//   void initState() {
//     super.initState();
//     _fromSliderValue = widget.todo.from.millisecondsSinceEpoch.toDouble();
//     _toSliderValue = widget.todo.to.millisecondsSinceEpoch.toDouble();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(
//                   '${widget.serialNumber}. ',
//                   style: TextStyle(
//                     decoration: widget.todo.isDone
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     widget.todo.text,
//                     style: TextStyle(
//                       decoration: widget.todo.isDone
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: () {
//                     _changeFromDate(context);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: () {
//                     _changeToDate(context);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.more_vert),
//                   onPressed: () {
//                     _showMoreOptions(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 Text(
//                   'Begin: ${DateFormat('dd-MM-yyyy').format(widget.todo.from)}',
//                   style: const TextStyle(fontSize: 12),
//                 ),
//                 Expanded(
//                   child: RangeSlider(
//                     values: RangeValues(_fromSliderValue, _toSliderValue),
//                     min: DateTime(2024).millisecondsSinceEpoch.toDouble(),
//                     max: DateTime(2026).millisecondsSinceEpoch.toDouble(),
//                     onChanged: (RangeValues values) {
//                       setState(() {
//                         _fromSliderValue = values.start;
//                         _toSliderValue = values.end;
//                         widget.todo.updateFrom(
//                             DateTime.fromMillisecondsSinceEpoch(
//                                 _fromSliderValue.toInt()));
//                         widget.todo.updateTo(
//                             DateTime.fromMillisecondsSinceEpoch(
//                                 _toSliderValue.toInt()));
//                       });
//                     },
//                     labels: RangeLabels(
//                       DateFormat('dd-MM-yyyy').format(widget.todo.from),
//                       DateFormat('dd-MM-yyyy').format(widget.todo.to),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'End: ${DateFormat('dd-MM-yyyy').format(widget.todo.to)}',
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _changeFromDate(BuildContext context) async {
//     final DateTime? newDate = await showDatePicker(
//       context: context,
//       initialDate: widget.todo.from,
//       firstDate: DateTime(DateTime.now().year - 1),
//       lastDate: widget.todo.to.subtract(const Duration(days: 1)),
//     );

//     if (newDate != null) {
//       if (newDate.isBefore(widget.todo.to.subtract(const Duration(days: 1)))) {
//         onUpdateTargetDate(newDate);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select a date before the current "to" date.'),
//           ),
//         );
//       }
//     }
//   }

//   void _showMoreOptions(BuildContext context) {
//     showMenu<String>(
//       context: context,
//       position: const RelativeRect.fromLTRB(
//           500, 200, 0, 0), // Adjust position as needed
//       items: <PopupMenuEntry<String>>[
//         const PopupMenuItem<String>(
//           value: 'edit',
//           child: ListTile(
//             leading: Icon(Icons.edit),
//             title: Text('Edit Task'),
//           ),
//         ),
//         const PopupMenuItem<String>(
//           value: 'delete',
//           child: ListTile(
//             leading: Icon(Icons.delete),
//             title: Text('Delete Task'),
//           ),
//         ),
//       ],
//     ).then((value) {
//       if (value == 'edit') {
//         _showEditDialog(context);
//       } else if (value == 'delete') {
//         widget.onDelete(); // Call the onDelete callback to delete the task
//       }
//     });
//   }

//   Future<void> _showEditDialog(BuildContext context) async {
//     TextEditingController editController = TextEditingController();
//     editController.text = widget.todo.text;

//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Task'),
//           content: TextField(
//             controller: editController,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 widget.onUpdate(editController.text);
//                 Navigator.pop(context);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _changeToDate(BuildContext context) async {
//     final DateTime? newDate = await showDatePicker(
//       context: context,
//       initialDate: widget.todo.to,
//       firstDate: widget.todo.from.add(const Duration(days: 1)),
//       lastDate: DateTime(DateTime.now().year + 1),
//     );

//     if (newDate != null) {
//       if (newDate.isAfter(widget.todo.from.add(const Duration(days: 1)))) {
//         onToUpdateTargetDate(newDate);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select a date after the current "from" date.'),
//           ),
//         );
//       }
//     }
//   }

//   void onUpdateTargetDate(DateTime newDate) {
//     setState(() {
//       widget.todo.updateFrom(newDate);
//       _fromSliderValue = widget.todo.from.millisecondsSinceEpoch.toDouble();
//     });
//   }

//   void onToUpdateTargetDate(DateTime newDate) {
//     setState(() {
//       widget.todo.updateTo(newDate);
//       _toSliderValue = widget.todo.to.millisecondsSinceEpoch.toDouble();
//     });
//   }
// }
