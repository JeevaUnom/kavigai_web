// ignore_for_file: library_private_types_in_public_api, unused_import, use_super_parameters

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

  const GoalList({Key? key, required this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: goals.asMap().entries.map((entry) {
        final index = entry.key;
        final goal = entry.value;

        // Calculate the difference in days between begin date and end date
        final beginDate = DateTime.parse(goal.beginDate);
        final endDate = DateTime.parse(goal.endDate);
        final differenceInDays = endDate.difference(beginDate).inDays;

        // Adjust the text based on the difference in days
        String targetDaysText;
        if (differenceInDays == 0) {
          targetDaysText = 'Single day';
        } else if (differenceInDays == 1) {
          targetDaysText = 'Single day';
        } else {
          targetDaysText = '$differenceInDays days';
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoalDetailPage(goal: goal),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon(
                  //   Icons.,
                  //   // color: Colors.blue
                  // ), // Icon representing the goal
                  const SizedBox(width: 16.0),
                  CircleAvatar(
                    // backgroundColor: Colors.blue,
                    child: Text(
                      (index + 1).toString(),
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${goal.beginDate} - ${goal.endDate}  (Target: $targetDaysText)',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  // Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
