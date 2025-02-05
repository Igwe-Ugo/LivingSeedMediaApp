import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LivingSeedMediaPreferences {
  static const themeStatus = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  LivingSeedMediaPreferences livingSeedPreference =
      LivingSeedMediaPreferences();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    livingSeedPreference.setDarkTheme(value);
    notifyListeners();
  }
}
