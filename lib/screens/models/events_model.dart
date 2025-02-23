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

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) {
    return UpcomingEvents(
      eventName: json['eventName'],
      eventDetails: json['eventDetails'],
      from: json['from'],
      to: json['to'],
      background: Color(json['background']),
      isAllDay: json['isAllDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'eventDetails': eventDetails,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'background': background.value,
      'isAllDay': isAllDay,
    };
  }
}
