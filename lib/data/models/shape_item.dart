
enum ShapeType { triangle, square, rectangle, circle, diamond }

class ShapeItem {
  const ShapeItem({required this.id, required this.name, required this.type, required this.emoji});
  final String id;
  final String name;
  final ShapeType type;
  final String emoji;
}
