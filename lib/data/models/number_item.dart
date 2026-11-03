class NumberItem {
  const NumberItem({
    required this.id,
    required this.value,
    required this.nameText,
    required this.audio,
    required this.objectImage,
    required this.status,
  });

  final String id;
  final int value;
  final String nameText;
  final String audio;
  final String objectImage;
  final String status;

  factory NumberItem.fromJson(Map<String, dynamic> j) => NumberItem(
        id: j['id'] as String,
        value: j['value'] as int,
        nameText: j['nameText'] as String,
        audio: j['audio'] as String,
        objectImage: j['objectImage'] as String,
        status: j['status'] as String? ?? 'published',
      );
}
