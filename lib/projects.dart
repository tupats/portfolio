import 'package:flutter/material.dart';

class Project {
  final String title;
  final IconData icon;
  final List<String> images;

  const Project({
    required this.title,
    required this.icon,
    this.images = const [],
  });
}

const List<Project> projects = [
  Project(title: 'Airsoft Run', icon: Icons.airplanemode_active),
  Project(title: 'Android TV Player', icon: Icons.tv),
  Project(title: 'Nutritions App', icon: Icons.food_bank),
  Project(title: 'Local IPTV Camera player', icon: Icons.camera),
  Project(title: 'Flutter ABC', icon: Icons.book),
];
