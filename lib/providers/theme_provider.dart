import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal/themes.dart';

final colorProvider =
    StateProvider<Color>((ref) => Themes.availableColors.first);

final tempColorProvider = StateProvider<Color>(
  (ref) => Themes.availableColors.first,
);

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);
