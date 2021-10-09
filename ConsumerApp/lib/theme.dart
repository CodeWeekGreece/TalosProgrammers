import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class globalTheme with ChangeNotifier {
  bool isDark = false;

  Future getIsDark() async {
    var prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
  }

  ThemeMode currentTheme() {
    getIsDark();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() async {
    isDark = !isDark;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  bool getTheme() {
    return isDark;
  }
}
