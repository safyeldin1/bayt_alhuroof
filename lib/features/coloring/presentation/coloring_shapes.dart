import 'package:flutter/material.dart';

// كل رسمة عبارة عن Path ومجموعة من الألوان اللي الطفل ممكن يستخدمها
class ColoringTemplate {
  final String id;
  final String name;
  final IconData icon;
  final Color themeColor;
  final Widget Function() painter;

  const ColoringTemplate({
    required this.id, required this.name, required this.icon,
    required this.themeColor, required this.painter,
  });
}

class ColoringShapes {
  static List<ColoringTemplate> all() {
    return [
      ColoringTemplate(id: 'tree', name: 'شجرة', icon: Icons.park, themeColor: Colors.green, painter: () => const TreeShape()),
      ColoringTemplate(id: 'house', name: 'بيت', icon: Icons.home, themeColor: Colors.orange, painter: () => const HouseShape()),
      ColoringTemplate(id: 'cat', name: 'قطة', icon: Icons.pets, themeColor: Colors.pink, painter: () => const CatShape()),
      ColoringTemplate(id: 'dog', name: 'كلب', icon: Icons.pets, themeColor: Colors.brown, painter: () => const DogShape()),
      ColoringTemplate(id: 'fish', name: 'سمكة', icon: Icons.water, themeColor: Colors.blue, painter: () => const FishShape()),
      ColoringTemplate(id: 'butterfly', name: 'فراشة', icon: Icons.bug_report, themeColor: Colors.purple, painter: () => const ButterflyShape()),
      ColoringTemplate(id: 'car', name: 'سيارة', icon: Icons.directions_car, themeColor: Colors.red, painter: () => const CarShape()),
      ColoringTemplate(id: 'sun', name: 'شمس', icon: Icons.wb_sunny, themeColor: Colors.amber, painter: () => const SunShape()),
      ColoringTemplate(id: 'flower', name: 'زهرة', icon: Icons.local_florist, themeColor: Colors.pinkAccent, painter: () => const FlowerShape()),
      ColoringTemplate(id: 'star', name: 'نجمة', icon: Icons.star, themeColor: Colors.amber, painter: () => const StarShape()),
    ];
  }
}

// --- رسومات الـ Outline (أبيض وأسود) ---

class TreeShape extends StatelessWidget {
  const TreeShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.park_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class HouseShape extends StatelessWidget {
  const HouseShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.house_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class CatShape extends StatelessWidget {
  const CatShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.pets_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class DogShape extends StatelessWidget {
  const DogShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.pets_outlined, size: 400, color: Colors.grey.shade300), // مؤقتاً
  );
}

class FishShape extends StatelessWidget {
  const FishShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.water_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class ButterflyShape extends StatelessWidget {
  const ButterflyShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.bug_report_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class CarShape extends StatelessWidget {
  const CarShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.directions_car_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class SunShape extends StatelessWidget {
  const SunShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.wb_sunny_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class FlowerShape extends StatelessWidget {
  const FlowerShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.local_florist_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class StarShape extends StatelessWidget {
  const StarShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.star_outline, size: 400, color: Colors.grey.shade300),
  );
}
