import 'dart:convert';

class NotificationItems {
  final String notificationImage;
  final String notificationTitle;
  final String notificationMessage;
  final String notificationDate;
  final String notificationTime;

  NotificationItems(
      {required this.notificationImage,
      required this.notificationTitle,
      required this.notificationMessage,
      required this.notificationDate,
      required this.notificationTime});

  factory NotificationItems.fromJson(Map<String, dynamic> json) {
    return NotificationItems(
        notificationImage: json['notificationImage'],
        notificationTitle: json['notificationTitle'],
        notificationMessage: json['notificationMessage'],
        notificationDate: json['notificationDate'],
        notificationTime: json['notificationTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationImage': notificationImage,
      'notificationTitle': notificationTitle,
      'notificationMessage': notificationMessage,
      'notificationDate': notificationDate,
      'notificationTime': notificationTime
    };
  }

  static List<NotificationItems> fromJsonList(String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => NotificationItems.fromJson(json))
        .toList();
  }
}
