// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoList extends StatefulWidget {
  final TextEditingController controller;

  const TodoList({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task',
                    ),
                  ),
                ), //text field for new  task
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    DateTime fromDate =
                        DateTime.now(); // get from date as today's date
                    DateTime toDate = DateTime.now().add(const Duration(
                        days: 7)); // calculate 'to' date as 7 days from date

                    _todos.add(TodoItem(
                      widget.controller.text,
                      from: fromDate,
                      to: toDate,
                    ));
                    widget.controller
                        .clear(); // clear text field after creating task
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            // drag and drop function
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final TodoItem item = _todos.removeAt(oldIndex);
                  _todos.insert(newIndex, item);
                });
              },
              children: _todos // create obj for todoitems
                  .asMap()
                  .map((index, todo) => MapEntry(
                        index,
                        TodoListItem(
                          key: ValueKey(todo),
                          todo: todo,
                          serialNumber: index + 1,
                          index: index,
                          todos: _todos, // Pass _todos list here
                          onDelete: () {
                            setState(() {
                              _todos.removeAt(index);
                            });
                          },
                          onUpdate: (String newText) {
                            setState(() {
                              _todos[index].text = newText;
                            });
                          },
                          onToggleStatus: () {
                            setState(() {
                              _todos[index].toggleStatus();
                            });
                          },
                          onUpdateTargetDate: (DateTime newDate) {
                            setState(() {
                              _todos[index].updateFrom(newDate);
                            });
                          },
                          onToUpdateTargetDate: (DateTime newDate) {
                            setState(() {
                              _todos[index].updateTo(newDate);
                            });
                          },
                        ),
                      ))
                  .values
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String text;
  bool isDone;
  DateTime from;
  DateTime to;

  TodoItem(this.text,
      {this.isDone = false, required this.from, required this.to});

  void toggleStatus() {
    isDone = !isDone;
  }

  void updateFrom(DateTime newDate) {
    from = newDate;
  }

  void updateTo(DateTime newDate) {
    to = newDate;
  }
}

class TodoListItem extends StatefulWidget {
  final TodoItem todo;
  final VoidCallback onDelete;
  final ValueChanged<String> onUpdate;
  final VoidCallback onToggleStatus;
  final Function(DateTime) onUpdateTargetDate;
  final Function(DateTime) onToUpdateTargetDate;
  final int serialNumber;
  final int index;
  final List<TodoItem> todos; // Receive _todos list here

  const TodoListItem({
    super.key,
    required this.todo,
    required this.serialNumber,
    required this.index,
    required this.todos, // Accept _todos list here
    required this.onDelete,
    required this.onUpdate,
    required this.onToggleStatus,
    required this.onUpdateTargetDate,
    required this.onToUpdateTargetDate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = 'current'; //  initial value for status
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      // drag & drop button with task content
      data: widget.index,
      feedback: SizedBox(
        width: 100.0,
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.todo.text),
          ),
        ),
      ),
      childWhenDragging: const SizedBox(),
      child: DragTarget<int>(
        //triggers reorder
        onAccept: (int data) {
          if (data != widget.index) {
            onReorder(data, widget.index);
          }
        },
        builder: (BuildContext context,
            List<int?> candidateData, // display optiion for all task
            List<dynamic> rejectedData) {
          return ListTile(
            key: ValueKey(widget.todo),
            title: Row(
              children: [
                DropdownButton<String>(
                  value: _dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                      if (_dropdownValue == 'completed') {
                        widget.todo.isDone = true;
                      } else {
                        widget.todo.isDone = false;
                      }
                    });
                  },
                  items: <String>[
                    'current',
                    'skipped',
                    'new',
                    'completed'
                  ] //status list
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text('${widget.serialNumber}. ', // serial no, task content
                    style: TextStyle(
                      decoration: widget.todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    )),
                Text(
                  widget.todo.text,
                  style: TextStyle(
                    // strike the task if we select completed
                    decoration: widget.todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const Spacer(), // begin & end date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'From: ${DateFormat('dd-MM-yyyy').format(widget.todo.from)}'),
                    Text(
                        'To: ${DateFormat('dd-MM-yyyy').format(widget.todo.to)}'),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _changeFromDate(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _changeToDate(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showMoreOptions(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onUpdateTargetDate(DateTime newDate) {
    setState(() {
      widget.todo.updateFrom(newDate);
    });
  }

  void onToUpdateTargetDate(DateTime newDate) {
    setState(() {
      widget.todo.updateTo(newDate);
    });
  }

//for begin date
  void _changeFromDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: widget.todo.from,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: widget.todo.to.subtract(const Duration(days: 1)),
    );

    if (newDate != null) {
      if (newDate.isBefore(widget.todo.to.subtract(const Duration(days: 1)))) {
        onUpdateTargetDate(newDate);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date before the current "to" date.'),
          ),
        );
      }
    }
  }

//  for end date
  void _changeToDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: widget.todo.to,
      firstDate: widget.todo.from.add(const Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate != null) {
      if (newDate.isAfter(widget.todo.from.add(const Duration(days: 1)))) {
        onToUpdateTargetDate(newDate);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please select a date after the current "from" date.'),
          ),
        );
      }
    }
  }

//more options part
  void _showMoreOptions(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
          500, 200, 0, 0), // Adjust position as needed
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Task'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Task'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _showEditDialog(context);
      } else if (value == 'delete') {
        widget.onDelete(); // Call the onDelete callback to delete the task
      }
    });
  }

  Future<void> _showEditDialog(BuildContext context) async {
    TextEditingController editController = TextEditingController();
    editController.text = widget.todo.text;

    DateTime selectedDate = widget.todo.to; // Get the current task's "to" date
    DateTime currentDate = DateTime.now(); // Get the current date

    if (selectedDate.isBefore(currentDate)) {
      _dropdownValue = 'current';
    } else {
      int differenceInDays = selectedDate.difference(currentDate).inDays;

      if (differenceInDays > 7) {
        _dropdownValue = 'new';
      } else {
        _dropdownValue = 'completed';
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // edit dialbox
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onUpdate(editController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

//reorder function after drag & drop
  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    TodoItem item = widget.todos.removeAt(oldIndex);
    widget.todos.insert(newIndex, item);
  }
}
