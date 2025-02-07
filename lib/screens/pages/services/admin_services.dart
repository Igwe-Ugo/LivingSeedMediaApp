import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';

class AdminAuthProvider extends ChangeNotifier {
  NotificationItems? _notice;
  NotificationItems? get noticesData => _notice;
  List<NotificationItems> notices = [];

  Future<void> initializeNotifications() async {
    String jsonString =
        await rootBundle.loadString('assets/json/notifications.json');
    notices = NotificationItems.fromJsonList(jsonString);
    await _loadNotificationFromLocal();
    notifyListeners();
  }

  Future<void> _loadNotificationFromLocal() async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        notices =
            jsonList.map((json) => NotificationItems.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local Notification data: $e');
    }
  }

  Future<File> _getNotificationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  Future<void> _saveNotificationToLocal() async {
    final file = await _getNotificationFile();
    String jsonData =
        json.encode(notices.map((notice) => notice.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  void sendNotification(String notificationImage, String notificationTitle,
      String notificationMessage) {
    if (_notice != null) {
      notices.add(NotificationItems(
          notificationImage: notificationImage,
          notificationTitle: notificationTitle,
          notificationMessage: notificationMessage,
          notificationDate: DateTime.now().toString(),
          notificationTime: DateTime.now().toString()));
    }
    notifyListeners();
    _saveNotificationToLocal();
  }

  void deleteNotification(String notificationTitle) {
    if (notices != null) {
      notices
          .removeWhere((item) => item.notificationTitle == notificationTitle);
      notifyListeners();
      _saveNotificationToLocal();
    }
  }
}
