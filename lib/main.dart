// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kavigai/Pages/Home.dart';
import 'package:kavigai/Pages/Profile.dart';
import 'package:kavigai/Pages/goal.dart';
import 'package:kavigai/Pages/login.dart';
import 'package:kavigai/Pages/mentor.dart';
import 'package:kavigai/Pages/service.dart';
//import 'package:kavigai/Components/ghant_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kavigai',
      theme: ThemeData(),
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/goal': (context) => GoalPage(),
        '/service': (context) => ServicePage(),
        '/mentor': (context) => MentorPage(),
        '/profile': (context) => ProfilePage(
              userName: '',
              userEmail: '',
            ),
       // '/chart': (context) => GanttChartPage(),
      },
    );
  }
}
