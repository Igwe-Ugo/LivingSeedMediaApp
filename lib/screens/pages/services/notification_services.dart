// notification_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItems> _generalNotifications = [];
  Map<String, List<NotificationItems>> _personalNotifications = {};

  List<NotificationItems> get generalNotifications => _generalNotifications;
  Map<String, List<NotificationItems>> get personalNotifications =>
      _personalNotifications;

  // load all notificationd form assets and local storage
  Future<void> loadNotifications() async {
    try {
      await _loadGeneralNoticesFromAssets();
      await _loadGeneralNoticesFromLocal();
      await _loadPersonalNoticesFromAssets();
      await _loadPersonalNoticesFromLocal();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
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
