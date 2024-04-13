// ignore_for_file: use_build_context_synchronously, unused_import, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/todo_list.dart';

void onUpdateTargetDate(DateTime newDate, Function setState, TodoItem todo) {
  setState(() {
    todo.updateFrom(newDate);
  });
}

void onToUpdateTargetDate(DateTime newDate, Function setState, TodoItem todo) {
  setState(() {
    todo.updateTo(newDate);
  });
}

// void onReorder(
//     int oldIndex, int newIndex, Function setState, List<TodoItem> todos) {
//   if (oldIndex < newIndex) {
//     newIndex -= 1;
//   }
//   TodoItem item = todos.removeAt(oldIndex);
//   todos.insert(newIndex, item);
// }

// void showMoreOptions(
//     // ignore: no_leading_underscores_for_local_identifiers
//     BuildContext context, Function onDelete, Function _showEditDialog) {
//   showMenu<String>(
//     context: context,
//     position: const RelativeRect.fromLTRB(
//       500,
//       200,
//       0,
//       0,
//     ), // Adjust position as needed
//     items: <PopupMenuEntry<String>>[
//       const PopupMenuItem<String>(
//         value: 'edit',
//         child: ListTile(
//           leading: Icon(Icons.edit),
//           title: Text('Edit Task'),
//         ),
//       ),
//       const PopupMenuItem<String>(
//         value: 'delete',
//         child: ListTile(
//           leading: Icon(Icons.delete),
//           title: Text('Delete Task'),
//         ),
//       ),
//     ],
//   ).then((value) {
//     if (value == 'edit') {
//       _showEditDialog(context);
//     } else if (value == 'delete') {
//       onDelete(); // Call the onDelete callback to delete the task
//     }
//   });
// }

// void showEditDialog(BuildContext context, TextEditingController editController,
//     Function onUpdate) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         // edit dialog box
//         title: const Text('Edit Task'),
//         content: TextField(
//           controller: editController,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               onUpdate(editController.text);
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       );
//     },
//   );
// }

// void changeFromDate(
//     BuildContext context, TodoItem todo, Function onUpdateTargetDate) async {
//   final DateTime? newDate = await showDatePicker(
//     context: context,
//     initialDate: todo.from,
//     firstDate: DateTime(DateTime.now().year - 1),
//     lastDate: todo.to.subtract(const Duration(days: 1)),
//   );

//   if (newDate != null) {
//     if (newDate.isBefore(todo.to.subtract(const Duration(days: 1)))) {
//       onUpdateTargetDate(newDate);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a date before the current "to" date.'),
//         ),
//       );
//     }
//   }
// }

// void changeToDate(
//     BuildContext context, TodoItem todo, Function onToUpdateTargetDate) async {
//   final DateTime? newDate = await showDatePicker(
//     context: context,
//     initialDate: todo.to,
//     firstDate: todo.from.add(const Duration(days: 1)),
//     lastDate: DateTime(DateTime.now().year + 1),
//   );

//   if (newDate != null) {
//     if (newDate.isAfter(todo.from.add(const Duration(days: 1)))) {
//       onToUpdateTargetDate(newDate);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a date after the current "from" date.'),
//         ),
//       );
//     }
//   }
// }

// void changeFromToDate(BuildContext context, TodoItem todo, Function(DateTime) onUpdateTargetDate, Function(DateTime) onToUpdateTargetDate, double fromSliderValue, double toSliderValue) async {
//   DateTime fromDate = todo.from.add(Duration(days: ((DateTime.now().difference(todo.from).inDays) * fromSliderValue).round()));
//   DateTime toDate = todo.from.add(Duration(days: ((DateTime.now().difference(todo.to).inDays) * toSliderValue).round()));

  // final DateTime? newFromDate = await showDatePicker(
  //   context: context,
  //   initialDate: fromDate,
  //   firstDate: DateTime(DateTime.now().year - 1),
  //   lastDate: toDate.subtract(const Duration(days: 1)),
  // );

  // if (newFromDate != null) {
  //   if (newFromDate.isBefore(toDate.subtract(const Duration(days: 1)))) {
  //     onUpdateTargetDate(newFromDate);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select a date before the current "to" date.'),
  //       ),
  //     );
  //   }
  // }

  // final DateTime? newToDate = await showDatePicker(
  //   context: context,
  //   initialDate: toDate,
  //   firstDate: fromDate.add(const Duration(days: 1)),
  //   lastDate: DateTime(DateTime.now().year + 1),
  // );

//   if (newToDate != null) {
//     if (newToDate.isAfter(fromDate.add(const Duration(days: 1)))) {
//       onToUpdateTargetDate(newToDate);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a date after the current "from" date.'),
//         ),
//       );
//     }
//   }
// }
