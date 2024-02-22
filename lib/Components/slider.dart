import 'package:flutter/material.dart';

class DateRangeSlider extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;

  const DateRangeSlider({
    Key? key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  }) : super(key: key);

  @override
  _DateRangeSliderState createState() => _DateRangeSliderState();
}

class _DateRangeSliderState extends State<DateRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('From: ${widget.fromDate.toString().split(' ')[0]}'),
        Slider(
          value: widget.fromDate.microsecondsSinceEpoch.toDouble(),
          min: DateTime.now().microsecondsSinceEpoch.toDouble(),
          max: widget.toDate.microsecondsSinceEpoch.toDouble(),
          onChanged: (value) {
            final newDate = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
            widget.onFromDateChanged(newDate);
          },
        ),
        Text('To: ${widget.toDate.toString().split(' ')[0]}'),
        Slider(
          value: widget.toDate.microsecondsSinceEpoch.toDouble(),
          min: widget.fromDate.microsecondsSinceEpoch.toDouble(),
          max: widget.fromDate
              .add(const Duration(days: 7))
              .microsecondsSinceEpoch
              .toDouble(),
          onChanged: (value) {
            final newDate = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
            widget.onToDateChanged(newDate);
          },
        ),
      ],
    );
  }
}
