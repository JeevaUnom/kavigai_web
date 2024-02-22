// import 'package:flutter/material.dart';
// import 'package:kavigai/Pages/Home.dart';

// class TodoListOptions extends StatelessWidget {
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onSelectStartDate;
//   final VoidCallback onSelectEndDate;
//   final int serialNumber;
//   final TodoItem todo;

//   const TodoListOptions({
//     Key key,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onSelectStartDate,
//     required this.onSelectEndDate,
//     required this.serialNumber,
//     required this.todo,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text('Task $serialNumber'), // Display serial number or any other relevant information
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: onEdit,
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: onDelete,
//         ),
//         IconButton(
//           icon: const Icon(Icons.calendar_today),
//           onPressed: onSelectStartDate,
//         ),
//         IconButton(
//           icon: const Icon(Icons.calendar_today),
//           onPressed: onSelectEndDate,
//         ),
//       ],
//     );
//   }
// }
