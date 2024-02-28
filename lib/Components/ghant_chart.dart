// import 'package:flutter/material.dart';

// class GanttChartView extends StatelessWidget {
//   final Duration maxDuration;
//   final DateTime startDate;
//   final double dayWidth;
//   final double eventHeight;
//   final double stickyAreaWidth;
//   final bool showStickyArea;
//   final bool showDays;
//   final DateTime startOfTheWeek;
//   final Set<int> weekEnds;
//   final bool Function(BuildContext context, DateTime day) isExtraHoliday;
//   final List<GanttEvent> events;

//   const GanttChartView({
//      Key? key,
//     required this.maxDuration,
//     required this.startDate,
//     required this.dayWidth,
//     required this.eventHeight,
//     required this.stickyAreaWidth,
//     required this.showStickyArea,
//     required this.showDays,
//     required this.startOfTheWeek,
//     this.weekEnds = const {DateTime.friday, DateTime.saturday},
//     required this.isExtraHoliday,
//     required this.events,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Implement the Gantt chart UI here
//     return Container(
//       // Placeholder for Gantt chart UI
//       child: const Text('Gantt Chart'),
//     );
//   }
// }

// class GanttEvent {}

// class GanttRelativeEvent extends GanttEvent {
//   final Duration relativeToStart;
//   final Duration duration;
//   final String displayName;

//   GanttRelativeEvent({
//     required this.relativeToStart,
//     required this.duration,
//     required this.displayName,
//   });
// }

// class GanttAbsoluteEvent extends GanttEvent {
//   final DateTime startDate;
//   final DateTime endDate;
//   final String displayName;

//   GanttAbsoluteEvent({
//     required this.startDate,
//     required this.endDate,
//     required this.displayName,
//   });
// }

// class GanttChartPage extends StatefulWidget {
//   @override
//   _GanttChartPageState createState() => _GanttChartPageState();
// }

// class _GanttChartPageState extends State<GanttChartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gantt Chart'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GanttChartView(
//           maxDuration: const Duration(
//               days: 30 *
//                   2), //optional, set to null for infinite horizontal scroll
//           startDate: DateTime(2022, 6, 7), //required
//           dayWidth: 30, //column width for each day
//           eventHeight: 30, //row height for events
//           stickyAreaWidth: 200, //sticky area width
//           showStickyArea: true, //show sticky area or not
//           showDays: true, //show days or not
//           startOfTheWeek: DateTime.sunday, //custom start of the week
//           weekEnds: const {
//             DateTime.friday,
//             DateTime.saturday
//           }, // Pass DateTime values for Friday and Saturday
//           isExtraHoliday: (context, day) {
//             //define custom holiday logic for each day
//             return DateUtils.isSameDay(DateTime(2022, 7, 1), day);
//           },
//           events: [
//             //event relative to startDate
//             GanttRelativeEvent(
//               relativeToStart: const Duration(days: 0),
//               duration: const Duration(days: 5),
//               displayName: 'Do a very helpful task',
//             ),
//             //event with absolute start and end
//             GanttAbsoluteEvent(
//               startDate: DateTime(2022, 6, 10),
//               endDate: DateTime(2022, 6, 16),
//               displayName: 'Another task',
//             ),
//           ], key: null,  
//         ),
//       ),
//     );
//   }
// }

// class DateUtils {
//   static bool isSameDay(DateTime day1, DateTime day2) {
//     return day1.year == day2.year &&
//         day1.month == day2.month &&
//         day1.day == day2.day;
//   }
// }
