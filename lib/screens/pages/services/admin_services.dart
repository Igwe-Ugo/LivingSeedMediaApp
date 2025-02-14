import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:livingseed_media/screens/models/models.dart';
import 'package:livingseed_media/screens/pages/services/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AdminAuthProvider extends ChangeNotifier {
  List<NotificationItems> _generalNotices = [];
  Map<String, List<NotificationItems>> _personalNotices = {};

  List<NotificationItems> get generalNotices => _generalNotices;
  Map<String, List<NotificationItems>> get personalNotices => _personalNotices;
  bool _isInitialized = false;

  Future<void> initializeNotifications(BuildContext context) async {
    if (_isInitialized) return; // Prevent multiple calls
    _isInitialized = true;
    debugPrint("Initializing Notifications..."); // Debugging print
    await _loadNotices(context); // Load all notices on startup
    notifyListeners();
  }

  /// **Load all notifications from assets and local storage**
  Future<void> _loadNotices(BuildContext context) async {
    //final userAuthProvider = Provider.of<UsersAuthProvider>(context, listen: false);
    //String? userEmail = userAuthProvider.userData?.emailAddress;

    //if (userEmail == null) return; // No user logged in, so skip loading

    debugPrint("Loading general notifications...");
    // Load General Notifications
    List<NotificationItems> assetGeneralNotices =
        await _loadNoticesFromAssets();
    List<NotificationItems> localGeneralNotices =
        await _loadGeneralNoticesFromLocal();

    // Merge notices while preventing duplicates
    Set<String> existingTitles =
        localGeneralNotices.map((n) => n.notificationTitle).toSet();
    assetGeneralNotices
        .removeWhere((n) => existingTitles.contains(n.notificationTitle));

    _generalNotices = [...localGeneralNotices, ...assetGeneralNotices];

    debugPrint("Loading personal notifications...");
    // Load Personal Notifications for this specific user!
    //_personalNotices = await _loadPersonalNoticesFromLocal(userEmail);

    notifyListeners(); // Ensure UI updates with new notifications
    debugPrint("Notifications loaded successfully!");
  }

  /// **Load general notifications from assets**
  Future<List<NotificationItems>> _loadNoticesFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/notifications.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      if (jsonData.containsKey('generalNotifications') &&
          jsonData['generalNotifications'] is List) {
        return (jsonData['generalNotifications'] as List)
            .map((item) => NotificationItems.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading general notifications from assets: $e');
    }
    return [];
  }

  /// **Load general notifications from local storage**
  Future<List<NotificationItems>> _loadGeneralNoticesFromLocal() async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        Map<String, dynamic> jsonData = json.decode(data);

        if (jsonData.containsKey('generalNotifications') &&
            jsonData['generalNotifications'] is List) {
          return (jsonData['generalNotifications'] as List)
              .map((item) => NotificationItems.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error loading general notifications from local: $e');
    }
    return [];
  }

  /// **Load personal notifications from local storage**
  Future<Map<String, List<NotificationItems>>> _loadPersonalNoticesFromLocal(
      String userEmail) async {
    try {
      final file = await _getNotificationFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        Map<String, dynamic> jsonMap = json.decode(data);

        if (jsonMap.containsKey("personalNotifications")) {
          Map<String, dynamic> personalJson = jsonMap["personalNotifications"];

          // Get only the notifications for the logged-in user
          if (personalJson.containsKey(userEmail)) {
            return {
              userEmail: (personalJson[userEmail] as List)
                  .map((item) => NotificationItems.fromJson(item))
                  .toList()
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading personal notifications: $e');
    }
    return {}; // Return empty map if user has no notifications
  }

  /// **Get the file for storing notifications**
  Future<File> _getNotificationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  /// **Save notifications to local storage**
  Future<void> _saveNotificationToLocal() async {
    try {
      final file = await _getNotificationFile();
      String jsonData = json.encode({
        "generalNotifications": _generalNotices.map((n) => n.toJson()).toList(),
        "personalNotifications": _personalNotices.map(
          (key, value) => MapEntry(key, value.map((n) => n.toJson()).toList()),
        ),
      });
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  /// **Send a general notification**
  Future<bool> sendGeneralNotification(
      NotificationItems newNotification) async {
    if (_generalNotices
        .any((n) => n.notificationTitle == newNotification.notificationTitle)) {
      return false;
    }

    _generalNotices.add(newNotification);
    await _saveNotificationToLocal();
    notifyListeners();
    return true;
  }

  /// **Send a personal notification**
  Future<bool> sendPersonalNotification(
      String email, NotificationItems newNotification) async {
    if (!_personalNotices.containsKey(email)) {
      _personalNotices[email] = [];
    }

    _personalNotices[email]!.add(newNotification);
    await _saveNotificationToLocal();
    notifyListeners();
    return true;
  }

  /// **Delete a general notification**
  Future<bool> deleteGeneralNotification(String notificationTitle) async {
    int initialLength = _generalNotices.length;
    _generalNotices
        .removeWhere((n) => n.notificationTitle == notificationTitle);

    if (_generalNotices.length != initialLength) {
      await _saveNotificationToLocal();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// **Delete a personal notification**
  Future<bool> deletePersonalNotification(
      String email, String notificationTitle) async {
    if (_personalNotices.containsKey(email)) {
      int initialLength = _personalNotices[email]!.length;
      _personalNotices[email]!
          .removeWhere((n) => n.notificationTitle == notificationTitle);

      if (_personalNotices[email]!.isEmpty) {
        _personalNotices.remove(email);
      }

      if (_personalNotices.length != initialLength) {
        await _saveNotificationToLocal();
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
