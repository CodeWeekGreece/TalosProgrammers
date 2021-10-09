library config.globals;

import 'package:flutter/material.dart';

import 'theme.dart';

globalTheme appTheme = globalTheme();

ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.indigo,
    accentColor: Colors.indigo,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.indigo)),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.indigo));
