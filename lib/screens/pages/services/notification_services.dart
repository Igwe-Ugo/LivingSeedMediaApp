// notification_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItems> _generalNotifications = [];
  Map<String, List<NotificationItems>> _personalNotifications = {};

  List<NotificationItems> get generalNotifications => _generalNotifications;
  Map<String, List<NotificationItems>> get personalNotifications =>
      _personalNotifications;

  // get unread count for a specific user
  int getUnreadCount(String? userEmail) {
    int generalUnread = _generalNotifications.where((n) => !n.isRead).length;
    int personalUnread = 0;
    if (userEmail != null && _personalNotifications.containsKey(userEmail)) {
      personalUnread =
          _personalNotifications[userEmail]!.where((n) => !n.isRead).length;
    }
    return generalUnread + personalUnread;
  }

  // load all notificationd form assets and local storage
  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final generalReadStatus =
        json.decode(prefs.getString('general_read_status') ?? '[]');
    final personalReadStatus =
        json.decode(prefs.getString('personal_read_status') ?? '{}');
    //_applyReadStatus(generalReadStatus, personalReadStatus);
    await _loadGeneralNoticesFromAssets();
    await _loadGeneralNoticesFromLocal();
    await _loadPersonalNoticesFromAssets();
    await _loadPersonalNoticesFromLocal();
    notifyListeners();
  }

  Future<void> _loadGeneralNoticesFromAssets() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/notifications.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse general notifications
      if (jsonData.containsKey('generalNotifications')) {
        _generalNotifications = (jsonData['generalNotifications'] as List)
            .map((item) => NotificationItems.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> _loadPersonalNoticesFromAssets() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/notifications.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      // Parse personal notifications
      if (jsonData.containsKey('personalNotifications')) {
        final personalData =
            jsonData['personalNotifications'] as Map<String, dynamic>;
        _personalNotifications = {};

        personalData.forEach((email, notifications) {
          _personalNotifications[email] = (notifications as List)
              .map((item) => NotificationItems.fromJson(item))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  // load general notification from local storage
  Future<void> _loadGeneralNoticesFromLocal() async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        Map<String, dynamic> jsonData = json.decode(data);
        if (jsonData.containsKey('generalNotifications')) {
          _generalNotifications = (jsonData['generalNotifications'] as List)
              .map((item) => NotificationItems.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error loading personal notifications: $e');
    }
  }

  // load personal notification from local storage
  Future<void> _loadPersonalNoticesFromLocal() async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        Map<String, dynamic> jsonMap = json.decode(data);
        if (jsonMap.containsKey('personalNotifications')) {
          Map<String, dynamic> personalJson = jsonMap['personalNotifications'];
          _personalNotifications = {};
          personalJson.forEach((email, notifications) {
            _personalNotifications[email] = (notifications as List)
                .map((item) => NotificationItems.fromJson(item))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading personal notifications: $e');
    }
  }

  // get the file for storing notifications
  Future<File> _getNotificationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  // save notifications to local storage
  Future<void> _saveNotificationToLocal() async {
    try {
      final file = await _getNotificationFile();
      String jsonData = json.encode({
        "generalNotifications":
            _generalNotifications.map((n) => n.toJson()).toList(),
        "personalNotifications": _personalNotifications.map((key, value) =>
            MapEntry(key, value.map((n) => n.toJson()).toList()))
      });
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error Saving notifications: $e');
    }
  }

  // mark a notification as read
  Future<void> markAsRead(
      NotificationItems notification, String? userEmail) async {
    // check general notifications
    int generalIndex = _generalNotifications.indexOf(notification);
    if (generalIndex != -1) {
      _generalNotifications[generalIndex].isRead = true;
    }

    // check personal notification
    if (userEmail != null && _personalNotifications.containsKey(userEmail)) {
      int personalIndex =
          _personalNotifications[userEmail]!.indexOf(notification);
      if (personalIndex != -1) {
        _personalNotifications[userEmail]![personalIndex].isRead = true;
      }
    }
    await _saveReadStatus();
    await _saveNotificationToLocal();
    notifyListeners();
  }

  // read status
  Future<void> _saveReadStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // save general notifications read status
    final generalReadStatus = _generalNotifications
        .map((n) => {'title': n.notificationTitle, 'isRead': n.isRead})
        .toList();
    await prefs.setString(
        'general_read_status', json.encode(generalReadStatus));

    // save personal notifications read status
    final personalReadStatus = {};
    _personalNotifications.forEach((email, notifications) {
      personalReadStatus[email] = notifications
          .map((n) => {'title': n.notificationTitle, 'isRead': n.isRead})
          .toList();
    });
    await prefs.setString(
        'personal_read_status', json.encode(personalReadStatus));
  }

  // send a general notification
  Future<bool> sendGeneralNotification(
      NotificationItems newNotification) async {
    if (_generalNotifications
        .any((n) => n.notificationTitle == newNotification.notificationTitle)) {
      return false;
    }
    _generalNotifications.add(newNotification);
    await _saveNotificationToLocal();
    notifyListeners();
    return true;
  }

  // send personal information
  Future<bool> sendPersonalNotification(
      String email, NotificationItems newNotification) async {
    if (!_personalNotifications.containsKey(email)) {
      _personalNotifications[email] = [];
    }
    _personalNotifications[email]!.add(newNotification);
    await _saveNotificationToLocal();
    notifyListeners();
    return true;
  }

  // delete general notification
  Future<bool> deleteGeneralNotification(String notificationTitle) async {
    int initialLength = _generalNotifications.length;
    _generalNotifications
        .removeWhere((n) => n.notificationTitle == notificationTitle);
    if (_generalNotifications.length != initialLength) {
      await _saveNotificationToLocal();
      notifyListeners();
      return true;
    }
    return false;
  }

  // delete personal notification
  Future<bool> deletePersonalNotification(
      String email, String notificationTitle) async {
    if (_personalNotifications.containsKey(email)) {
      int initialLength = _personalNotifications[email]!.length;
      _personalNotifications[email]!
          .removeWhere((n) => n.notificationTitle == notificationTitle);
      if (_personalNotifications[email]!.isEmpty) {
        _personalNotifications.remove(email);
      }
      if (_personalNotifications.length != initialLength) {
        await _saveNotificationToLocal();
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
