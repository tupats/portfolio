import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mousePositionProvider = StateProvider<Offset>(
  (ref) => const Offset(0, 0),
);

final pointerProvider = StateProvider<Offset>(
  (ref) => const Offset(0, 0),
);

final pointerTappedProvider = StateP