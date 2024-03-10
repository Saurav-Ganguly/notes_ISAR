import 'package:flutter/material.dart';
import 'package:notes_isar/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  //initially, theme is light mode
  ThemeData _themeData = lightMode;

  //getter method to access the theme
  ThemeData get themeData => _themeData;

  // getter method to see if in the dark mode
  bool get isDarkMode => _themeData == darkMode;

  //setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
