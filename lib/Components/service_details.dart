// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Pages/service.dart';

class TodoList extends StatefulWidget {
  final List<Todo> todos;

  const TodoList({super.key, required this.todos});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.todos.map((todo) {
        double beginDateMilliseconds =
            todo.beginDate.millisecondsSinceEpoch.toDouble();
        double endDateMilliseconds =
            todo.endDate.millisecondsSinceEpoch.toDouble();
        double minMilliseconds =
            DateTime.now().millisecondsSinceEpoch.toDouble();
        double maxMilliseconds = DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch
            .toDouble();

        // Ensure that beginDate and endDate are within the range of min and max
        if (beginDateMilliseconds < minMilliseconds) {
          beginDateMilliseconds = minMilliseconds;
        } else if (beginDateMilliseconds > maxMilliseconds) {
          beginDateMilliseconds = maxMilliseconds;
        }
        if (endDateMilliseconds < minMilliseconds) {
          endDateMilliseconds = minMilliseconds;
        } else if (endDateMilliseconds > maxMilliseconds) {
          endDateMilliseconds = maxMilliseconds;
        }

        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(todo.name),
            ),
            Expanded(
              flex: 3,
              child: RangeSlider(
                values: RangeValues(beginDateMilliseconds, endDateMilliseconds),
                min: minMilliseconds,
                max: maxMilliseconds,
                onChanged: (RangeValues values) {
                  setState(() {
                    // Update the todo's beginDate and endDate when slider values change
                    todo.beginDate = DateTime.fromMillisecondsSinceEpoch(
                        values.start.toInt());
                    todo.endDate =
                        DateTime.fromMillisecondsSinceEpoch(values.end.toInt());
                  });
                },
                labels: RangeLabels(
                  _formatDate(todo.beginDate),
                  _formatDate(todo.endDate),
                ),
                divisions: 365,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
