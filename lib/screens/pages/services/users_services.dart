import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/models.dart';

Future<List<Users>> loadUsers() async {
  try {
    String jsonString = await rootBundle.loadString('assets/json/users.json');
    List<Users> users = Users.fromJsonList(jsonString);
    return users;
  } catch (e) {
    debugPrint('Error Loading JSON: $e');
    return [];
  }
}
