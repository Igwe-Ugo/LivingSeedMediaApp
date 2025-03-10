import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:livingseed_media/screens/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddEventProvider extends ChangeNotifier {
  List<UpcomingEventsModel> _events = [];
  UpcomingEventsModel? _selectedEvent; // Stores the selected event

  List<UpcomingEventsModel> get events => _events;
  UpcomingEventsModel? get selectedEvent => _selectedEvent;

  /// Select an event to show a tooltip
  void selectEvent(UpcomingEventsModel? event) {
    _selectedEvent = event;
    notifyListeners(); // Notify UI updates
  }

  /// Initialize events by loading from assets & local storage
  Future<void> initializeEvents() async {
    List<UpcomingEventsModel> assetEvents = await _loadEventsFromAssets();
    List<UpcomingEventsModel> localEvents = await _loadEventsFromLocal();

    // Merge events while preventing duplicates
    Set<String> existingTitles = localEvents.map((e) => e.eventName).toSet();
    assetEvents.removeWhere((e) => existingTitles.contains(e.eventName));

    _events = [...localEvents, ...assetEvents]; // Prioritize local storage
    notifyListeners();
  }

  /// Add a new event
  Future<void> addEvent(UpcomingEventsModel event) async {
    _events.add(event);
    await _saveEventsToLocal();
    notifyListeners();
  }

  /// Delete an event
  Future<void> deleteEvent(UpcomingEventsModel event) async {
    _events.remove(event);
    await _saveEventsToLocal();
    notifyListeners();
  }

  /// Load events from assets (initial setup)
  Future<List<UpcomingEventsModel>> _loadEventsFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/events.json');
      List<dynamic> jsonData = json.decode(jsonString);
      return jsonData
          .map((item) => UpcomingEventsModel.fromJson(item))
          .toList();
    } catch (e, trace) {
      debugPrint('Error loading events from assets: $e');
      print(trace);
      return [];
    }
  }

  /// Load events from local storage
  Future<List<UpcomingEventsModel>> _loadEventsFromLocal() async {
    try {
      final file = await _getEventFile();
      if (file.existsSync()) {
        String data = await file.readAsString();
        List<dynamic> jsonList = json.decode(data);
        return jsonList
            .map((json) => UpcomingEventsModel.fromJson(json))
            .toList();
      }
    } catch (e, trace) {
      debugPrint('Error loading events from local storage: $e');
      print(trace);
    }
    return [];
  }

  /// Save events to local storage
  Future<void> _saveEventsToLocal() async {
    try {
      final file = await _getEventFile();
      String jsonData =
          json.encode(_events.map((event) => event.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      debugPrint('Error saving events: $e');
    }
  }

  /// Get local file path for events
  Future<File> _getEventFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/events.json');
  }
}
