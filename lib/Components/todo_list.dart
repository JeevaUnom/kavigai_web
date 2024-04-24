// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_element, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'functions.dart';

class TodoList extends StatefulWidget {
  final TextEditingController controller;

  const TodoList({super.key, required this.controller});

  @override
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
                    DateTime fromDate = DateTime.now();
                    DateTime toDate =
                        DateTime.now().add(const Duration(days: 7));

                    _todos.add(TodoItem(
                      widget.controller.text,
                      from: fromDate,
                      to: toDate,
                    ));
                    widget.controller.clear();
                  }),
                ),
              ],
            ),
          ),
          Expanded(
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
              children: _todos
                  .asMap()
                  .map((index, todo) => MapEntry(
                        index,
                        TodoListItem(
                          key: ValueKey(todo),
                          todo: todo,
                          serialNumber: index + 1,
                          index: index,
                          todos: _todos,
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
                            onUpdateTargetDate(
                                newDate, setState, _todos[index]);
                          },
                          onToUpdateTargetDate: (DateTime newDate) {
                            onToUpdateTargetDate(
                                newDate, setState, _todos[index]);
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
  final List<TodoItem> todos;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.serialNumber,
    required this.index,
    required this.todos,
    required this.onDelete,
    required this.onUpdate,
    required this.onToggleStatus,
    required this.onUpdateTargetDate,
    required this.onToUpdateTargetDate,
  });

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late double _fromSliderValue;
  late double _toSliderValue;

  @override
  void initState() {
    super.initState();
    _fromSliderValue = widget.todo.from.millisecondsSinceEpoch.toDouble();
    _toSliderValue = widget.todo.to.millisecondsSinceEpoch.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: 'current',
                  onChanged: (String? newValue) {},
                  items: <String>['current', 'new', 'completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${widget.serialNumber}. ',
                  style: TextStyle(
                    decoration: widget.todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.todo.text,
                    style: TextStyle(
                      decoration: widget.todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'From: ${DateFormat('dd-MM-yyyy').format(widget.todo.from)}',
                  style: const TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(_fromSliderValue, _toSliderValue),
                    min: DateTime(2024).millisecondsSinceEpoch.toDouble(),
                    max: DateTime(2026).millisecondsSinceEpoch.toDouble(),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _fromSliderValue = values.start;
                        _toSliderValue = values.end;
                        widget.todo.updateFrom(
                            DateTime.fromMillisecondsSinceEpoch(
                                _fromSliderValue.toInt()));
                        widget.todo.updateTo(
                            DateTime.fromMillisecondsSinceEpoch(
                                _toSliderValue.toInt()));
                      });
                    },
                    labels: RangeLabels(
                      DateFormat('dd-MM-yyyy').format(widget.todo.from),
                      DateFormat('dd-MM-yyyy').format(widget.todo.to),
                    ),
                  ),
                ),
                Text(
                  'To: ${DateFormat('dd-MM-yyyy').format(widget.todo.to)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onUpdateTargetDate(DateTime newDate) {
    setState(() {
      widget.todo.updateFrom(newDate);
      _fromSliderValue = widget.todo.from.millisecondsSinceEpoch.toDouble();
    });
  }

  void onToUpdateTargetDate(DateTime newDate) {
    setState(() {
      widget.todo.updateTo(newDate);
      _toSliderValue = widget.todo.to.millisecondsSinceEpoch.toDouble();
    });
  }

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

    // DateTime selectedDate = widget.todo.to; // Get the current task's "to" date
    // DateTime currentDate = DateTime.now(); // Get the current date

    // if (selectedDate.isBefore(currentDate)) {
    //   _dropdownValue = 'current';
    // } else {
    //   int differenceInDays = selectedDate.difference(currentDate).inDays;

    //   if (differenceInDays > 7) {
    //     _dropdownValue = 'new';
    //   } else {
    //     _dropdownValue = 'completed';
    //   }
    // }

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
}
