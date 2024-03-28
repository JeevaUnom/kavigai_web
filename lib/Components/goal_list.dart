// ignore_for_file: library_private_types_in_public_api, unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Components/goal_detail_page.dart';
import 'dart:convert';

class Goal {
  final String name;
  final String description;
  final String beginDate;
  final String endDate;
  final String url;
  final String status;

  Goal({
    required this.name,
    required this.description,
    required this.beginDate,
    required this.endDate,
    required this.url,
    required this.status,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'],
      description: json['description'],
      beginDate: json['beginDate'],
      endDate: json['endDate'],
      url: json['url'],
      status: json['status'],
    );
  }
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  late Future<List<Goal>> _goalListFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _goalListFuture = _fetchGoalList();
  // }

  // Future<List<Goal>> _fetchGoalList() async {
  //   final Uri url = Uri.parse('http://127.0.0.1:5000/api/goals');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> goalsJson = json.decode(response.body)['goals'];
  //     return goalsJson.map((goalJson) => Goal.fromJson(goalJson)).toList();
  //   } else {
  //     throw Exception('Failed to fetch goal list');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Page'),
        backgroundColor: const Color.fromARGB(255, 251, 253, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<Goal>>(
              future: _goalListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final List<Goal>? goals = snapshot.data;
                  if (goals != null && goals.isNotEmpty) {
                    return GoalList(goals: goals);
                  } else {
                    return const Text('No goals available');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoalList extends StatelessWidget {
  final List<Goal> goals;

  const GoalList({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: goals.map((goal) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${goal.beginDate} - ${goal.endDate}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalDetailPage(goal: goal),
                          ),
                        );
                      },
                      child: const Text('View Goal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
