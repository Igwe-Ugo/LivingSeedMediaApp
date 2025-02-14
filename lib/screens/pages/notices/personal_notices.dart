import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/models/models.dart';

class PersonalNotices extends StatelessWidget {
  final NotificationItems notification;
  const PersonalNotices(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(notification.notificationImage, width: 40),
      title: Text(notification.notificationTitle, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(notification.notificationMessage),
      trailing: Column(
        children: [
          Text(notification.notificationDate, style: TextStyle(fontSize: 12)),
          Text(notification.notificationTime, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
