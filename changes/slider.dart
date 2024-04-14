// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DateRangeSlider extends StatefulWidget {
//   final DateTime fromDate;
//   final DateTime toDate;
//   final ValueChanged<DateTime> onFromDateChanged;
//   final ValueChanged<DateTime> onToDateChanged;

//   const DateRangeSlider({
//     super.key,
//     required this.fromDate,
//     required this.toDate,
//     required this.onFromDateChanged,
//     required this.onToDateChanged,
//   });

//   @override
//   _DateRangeSliderState createState() => _DateRangeSliderState();
// }

// class _DateRangeSliderState extends State<DateRangeSlider> {
//   double _fromSliderValue = 0.0;
//   double _toSliderValue = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text('From: ${DateFormat('yyyy-MM-dd').format(widget.fromDate)}'),
//         Slider(
//           value: _fromSliderValue,
//           min: 0.0,
//           max: widget.toDate.difference(widget.fromDate).inDays.toDouble(),
//           onChanged: (value) {
//             setState(() {
//               _fromSliderValue = value;
//               widget.onFromDateChanged(
//                 widget.fromDate.add(Duration(days: value.toInt())),
//               );
//             });
//           },
//         ),
//         Text('To: ${DateFormat('yyyy-MM-dd').format(widget.toDate)}'),
//         Slider(
//           value: _toSliderValue,
//           min: 0.0,
//           max: widget.toDate.difference(widget.fromDate).inDays.toDouble(),
//           onChanged: (value) {
//             setState(() {
//               _toSliderValue = value;
//               widget.onToDateChanged(
//                 widget.fromDate.add(Duration(days: value.toInt())),
//               );
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
