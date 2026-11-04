class ProfessionItem {
  const ProfessionItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.toolId,
  });

  final String id;
  final String name;
  final String emoji;
  final String toolId;
}

class ToolItem {
  const ToolItem({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;
}
