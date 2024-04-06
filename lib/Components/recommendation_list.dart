// // ignore_for_file: unused_import, use_super_parameters, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:kavigai/Components/Navbar.dart';
// import 'package:kavigai/Components/goal_list.dart';
// import '../pages/goal.dart'; // Import the Goal class
// import '../services/goal_service.dart'; // Import the service to fetch goals

// class RecommendationListPage extends StatefulWidget {
//   final String bookTitle;
//   final String bookGenre;

//   const RecommendationListPage({
//     Key? key,
//     required this.bookTitle,
//     required this.bookGenre,
//   }) : super(key: key);

//   @override
//   _RecommendationListPageState createState() => _RecommendationListPageState();
// }

// class _RecommendationListPageState extends State<RecommendationListPage> {
//   List<Goal> recommendedGoals = []; // List to store recommended goals

//   @override
//   void initState() {
//     super.initState();
//     // Fetch recommended goals when the page is initialized
//     fetchRecommendedGoals();
//   }

//   Future<void> fetchRecommendedGoals() async {
//     // Fetch goals matching the book's title or genre
//     final goals = await GoalService.getGoalsMatchingBook(
//         widget.bookTitle, widget.bookGenre);
//     setState(() {
//       recommendedGoals = goals;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recommendation List'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const NavBar(),
//             Text(
//               'Recommended Goals for "${widget.bookTitle}"',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             if (recommendedGoals.isNotEmpty)
//               GoalList(goals: recommendedGoals)
//             else
//               const Text('No recommended goals found.'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GoalService {
//   static getGoalsMatchingBook(String bookTitle, String bookGenre) {}
// }
