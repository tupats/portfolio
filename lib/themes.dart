import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static ThemeData getTheme({Color? color}) =>
      ThemeData(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: color ?? defaultColor),
      );

  static const List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow
  ];

  static const defaultColor = Colors.red;
}
