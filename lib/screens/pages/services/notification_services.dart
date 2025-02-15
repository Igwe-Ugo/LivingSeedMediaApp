// notification_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingseed_media/screens/models/models.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItems> _generalNotifications = [];
  Map<String, List<NotificationItems>> _personalNotifications = {};
  
  List<NotificationItems> get generalNotifications => _generalNotifications;
  Map<String, List<NotificationItems>> get personalNotifications => _personalNotifications;

  Future<void> loadNotifications() async {
    try {
      // Load the JSON file
      final String jsonString = await rootBundle.loadString('assets/json/notifications.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse general notifications
      if (jsonData.containsKey('generalNotifications')) {
        _generalNotifications = (jsonData['generalNotifications'] as List)
            .map((item) => NotificationItems.fromJson(item))
            .toList();
      }

      // Parse personal notifications
      if (jsonData.containsKey('personalNotifications')) {
        final personalData = jsonData['personalNotifications'] as Map<String, dynamic>;
        _personalNotifications = {};
        
        personalData.forEach((email, notifications) {
          _personalNotifications[email] = (notifications as List)
              .map((item) => NotificationItems.fromJson(item))
              .toList();
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }
}