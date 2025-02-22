import 'package:flutter/material.dart';

class UpcomingEvents {
  String eventName;
  String eventDetails;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  UpcomingEvents({
    required this.eventName,
    required this.eventDetails,
    required this.from,
    required this.to,
    this.background = Colors.blue,
    this.isAllDay = false,
  });
}
