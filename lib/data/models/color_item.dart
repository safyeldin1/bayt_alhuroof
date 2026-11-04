import 'package:flutter/material.dart';

class ColorItem {
  const ColorItem({required this.id, required this.name, required this.hexColor, required this.emoji});
  final String id;
  final String name;
  final String hexColor;
  final String emoji;

  Color get color => Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
}
