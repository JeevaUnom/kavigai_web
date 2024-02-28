// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';

// class TodoItem {
//   String text;
//   bool isDone;

//   TodoItem(this.text, {this.isDone = false});

//   void toggleStatus() {
//     isDone = !isDone;
//   }
// }

// class TodoListItem extends StatelessWidget {
//   final TodoItem todo;
//   final VoidCallback onDelete;
//   final ValueChanged<String> onUpdate;
//   final VoidCallback onToggleStatus;
//   final int serialNumber;

//   const TodoListItem({
//     required Key key,
//     required this.todo,
//     required this.serialNumber,
//     required this.onDelete,
//     required this.onUpdate,
//     required this.onToggleStatus,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Draggable<int>(
//       data: serialNumber, // Use serialNumber as the data being dragged
//       feedback: Material(
//         child: ListTile(
//           title: todo.isDone
//               ? Text(
//                   todo.text,
//                   style: const TextStyle(
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 )
//               : Text(todo.text),
//         ),
//       ),
//       child: DragTarget<int>(
//         builder: (BuildContext context, List<int?> candidateData,
//             List<dynamic> rejectedData) {
//           return ListTile(
//             title: todo.isDone
//                 ? Text(
//                     todo.text,
//                     style: todo.isDone
//                         ? const TextStyle(
//                             decoration: TextDecoration.lineThrough)
//                         : null,
//                   )
//                 : Text(todo.text),
//             leading: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Text(
//                     '$serialNumber.',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Checkbox(
//                   value: todo.isDone,
//                   onChanged: (bool? value) {
//                     onToggleStatus();
//                   },
//                 ),
//               ],
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     _showEditDialog(context);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: onDelete,
//                 ),
//                 const Icon(Icons.drag_handle),
//               ],
//             ),
//           );
//         },
//         onAccept: (int data) {
//           // Implement reordering logic here
//           // ignore: avoid_print
//           print('Reordered: $data');
//         },
//       ),
//     );
//   }

//   Future<void> _showEditDialog(BuildContext context) async {
//     TextEditingController editController = TextEditingController();
//     editController.text = todo.text;

//     showDialog(
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
//                 onUpdate(editController.text);
//                 Navigator.pop(context);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class CustomFloatingActionButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const CustomFloatingActionButton({super.key, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: onPressed,
//       child: const Icon(Icons.add),
//     );
//   }
// }

// class TodoList extends StatefulWidget {
//   final List<TodoItem> todos;
//   final ValueChanged<List<TodoItem>> onReorder;
//   final VoidCallback onDelete;

//   const TodoList({
//     super.key,
//     required this.todos,
//     required this.onReorder,
//     required this.onDelete,
//   });

//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   late List<TodoItem> _todos;

//   @override
//   void initState() {
//     super.initState();
//     _todos = List.from(widget.todos);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView(
//       onReorder: _onReorder,
//       children: _todos.map((todo) {
//         final index = _todos.indexOf(todo);
//         return TodoListItem(
//           key: ValueKey(todo),
//           todo: todo,
//           serialNumber: index + 1,
//           onDelete: () => _deleteTodoItem(index),
//           onUpdate: (String newText) => _updateTodoItem(index, newText),
//           onToggleStatus: () => _toggleTodoItemStatus(index),
//         );
//       }).toList(),
//     );
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final TodoItem item = _todos.removeAt(oldIndex);
//       _todos.insert(newIndex, item);
//     });
//     widget.onReorder(_todos);
//   }

//   void _deleteTodoItem(int index) {
//     setState(() {
//       _todos.removeAt(index);
//     });
//     widget.onDelete();
//   }

//   void _updateTodoItem(int index, String newText) {
//     setState(() {
//       _todos[index].text = newText;
//     });
//   }

//   void _toggleTodoItemStatus(int index) {
//     setState(() {
//       _todos[index].toggleStatus();
//     });
//   }
// }
