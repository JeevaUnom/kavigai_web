// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'functions.dart'; // Import functions.dart where the functions are defined

class TodoList extends StatefulWidget {
  final TextEditingController controller;

  const TodoList({Key? key, required this.controller}) : super(key: key);

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
  // ignore: library_private_types_in_public_api
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late String _dropdownValue;
  double _fromSliderValue = 0.0;
  double _toSliderValue = 1.0;
  void _changeFromToDate(BuildContext context) {
    changeFromToDate(
      context,
      widget.todo,
      widget.onUpdateTargetDate,
      widget.onToUpdateTargetDate,
      _fromSliderValue, // Pass the value of the from slider
      _toSliderValue, // Pass the value of the to slider
    );
  }

  @override
  void initState() {
    super.initState();
    _dropdownValue = 'current';
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
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
        onAccept: (int data) {
          if (data != widget.index) {
            onReorder(data, widget.index, setState, widget.todos);
          }
        },
        builder: (BuildContext context, List<int?> candidateData,
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
                  items: <String>['current', 'skipped', 'new', 'completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text(
                  '${widget.serialNumber}. ',
                  style: TextStyle(
                    decoration: widget.todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                Text(
                  widget.todo.text,
                  style: TextStyle(
                    decoration: widget.todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const Spacer(),
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
                IconButton(
                  // Add an additional IconButton for changing from/to dates
                  icon: const Icon(
                      Icons.tune), // Change the icon to a slider icon
                  onPressed: () {
                    _showSliderDialog(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _changeFromDate(BuildContext context) async {
    changeFromDate(context, widget.todo, widget.onUpdateTargetDate);
  }

  void _changeToDate(BuildContext context) async {
    changeToDate(context, widget.todo, widget.onToUpdateTargetDate);
  }

  void _showSliderDialog(BuildContext context) {
    // Get the current from and to dates
    DateTime fromDate = widget.todo.from;
    DateTime toDate = widget.todo.to;

    // Calculate the maximum slider value based on the difference between from and to dates
    double maxSliderValue = toDate.difference(fromDate).inDays.toDouble();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Adjust Dates'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d').format(fromDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          DateFormat('MMM d').format(toDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  RangeSlider(
                    min: 0.0,
                    max: maxSliderValue,
                    values: RangeValues(_fromSliderValue, _toSliderValue),
                    onChanged: (RangeValues newValues) {
                      setState(() {
                        // Update the from and to slider values
                        _fromSliderValue =
                            newValues.start.clamp(0.0, maxSliderValue);
                        _toSliderValue =
                            newValues.end.clamp(0.0, maxSliderValue);

                        // Calculate the new from and to dates based on the slider values
                        DateTime newFromDate = fromDate
                            .add(Duration(days: _fromSliderValue.toInt()));
                        DateTime newToDate = fromDate
                            .add(Duration(days: _toSliderValue.toInt()));

                        // Update the from and to dates of the todo item
                        widget.onUpdateTargetDate(newFromDate);
                        widget.onToUpdateTargetDate(newToDate);
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMoreOptions(BuildContext context) {
    showMoreOptions(context, widget.onDelete, () {
      showEditDialog(context, TextEditingController(), (String value) {});
    });
  }
}
