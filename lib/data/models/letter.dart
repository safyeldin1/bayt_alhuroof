class Letter {
  const Letter({
    required this.id, required this.order, required this.character,
    required this.name, required this.forms, required this.nameAudio,
    required this.soundAudio, required this.primaryWordId,
    required this.tracingId, required this.status,
  });

  final String id;
  final int order;
  final String character;
  final String name;
  final Map<String, String> forms;
  final String nameAudio;
  final String soundAudio;
  final String primaryWordId;
  final String tracingId;
  final String status;

  factory Letter.fromJson(Map<String, dynamic> j) => Letter(
        id: j['id'] as String,
        order: j['order'] as int,
        character: j['character'] as String,
        name: j['name'] as String,
        forms: Map<String, String>.from(j['forms'] as Map),
        nameAudio: j['audio']['name'] as String,
        soundAudio: j['audio']['sound'] as String,
        primaryWordId: j['primaryWordId'] as String,
        tracingId: j['tracingId'] as String,
        status: j['status'] as String,
      );
}
