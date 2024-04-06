import 'package:flutter/material.dart';
import 'package:kavigai/Components/Navbar.dart';
import 'package:kavigai/Components/goal_list.dart';
import '../pages/goal.dart'; // Import the Goal class
import 'service_todo.dart'; // Import the recommendation list page

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  String _selectedService = '--select service--'; // Dropdown value holder
  List<Todo> _todos = []; // List to hold todos

  final List<String> _services = [
    '--select service--',
    'ToDo',
    'Books',
    'Events',
    'Meeting'
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
                _buildServiceContent(selectedService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceContent(String selectedService) {
    switch (selectedService) {
      case 'ToDo':
        return SizedBox(
          height: 100, // Adjust the height as per your requirement
          child: SingleChildScrollView(
            child: TodoForm(
              onSave: (todo) {
                _addTodoToList(todo);
                print('Todo saved: $todo');
                Navigator.pop(context);
              },
            ),
          ),
        );
      case 'Existing':
        return SizedBox(
          height: 300, // Adjust the height as per your requirement
          child: SingleChildScrollView(
            child: ExistingTodosDialog(
              onSelect: (todo) {},
            ),
          ),
        );
      // Add cases for other services here
      default:
        return const SizedBox();
    }
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
                    // Navigator.pop(context);
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Description: ${widget.goal.description}'),
            Text('URL: ${widget.goal.url}'),
            Text('Status: ${widget.goal.status}'),
            Text('Begin Date: ${widget.goal.beginDate}'),
            Text('End Date: ${widget.goal.endDate}'),
            const SizedBox(height: 25),
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
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index].name),
                    subtitle: Text(
                      '${_todos[index].beginDate.toString().substring(0, 10)} - ${_todos[index].endDate.toString().substring(0, 10)}',
                    ),
                    // Other details...
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
