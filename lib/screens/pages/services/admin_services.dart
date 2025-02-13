import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';

class AdminAuthProvider extends ChangeNotifier {
  List<NotificationItems> _notices = [];
  List<NotificationItems> get allNotices => _notices;
  Future<List<NotificationItems>>? notificationFuture;

  Future<void> initializeNotifications() async {
    notificationFuture = _loadNotices();
    notifyListeners();
  }

  Future<List<NotificationItems>> _loadNotices() async {
    List<NotificationItems> assetNotices = await _loadNoticesFromAssets();
    List<NotificationItems> localNotices = await _loadNotificationFromLocal();

    Set<String> existingTitles =
        localNotices.map((notice) => notice.notificationTitle).toSet();
    assetNotices.removeWhere(
        (notice) => existingTitles.contains(notice.notificationTitle));

    _notices = [...localNotices, ...assetNotices]; // Prioritize local notices
    return _notices;
  }

  // Load notifications from assets (JSON)
  Future<List<NotificationItems>> _loadNoticesFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/notifications.json');
      List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => NotificationItems.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error Loading JSON: $e');
      return [];
    }
  }

  // Load notifications from local storage
  Future<List<NotificationItems>> _loadNotificationFromLocal() async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList.map((json) => NotificationItems.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local Notification data: $e');
    }
    return []; // Return an empty list instead of void
  }


  Future<File> _getNotificationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  Future<void> _saveNotificationToLocal() async {
    try {
      final file = await _getNotificationFile();
      String jsonData =
          json.encode(_notices.map((notice) => notice.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  Future<bool> sendNotification(NotificationItems newNotification) async {
    if (_notices.any((notice) =>
        notice.notificationTitle == newNotification.notificationTitle)) {
      return false;
    }

    _notices.add(newNotification);
    await _saveNotificationToLocal();
    notifyListeners();
    return true;
  }

  Future<bool> deleteNotification(String notificationTitle) async {
    int initialLength = _notices.length;
    _notices.removeWhere((item) => item.notificationTitle == notificationTitle);

    if (_notices.length != initialLength) {
      await _saveNotificationToLocal();
      notifyListeners();
      return true; // Successfully deleted
    }
    return false; // Notification not found
  }

}
