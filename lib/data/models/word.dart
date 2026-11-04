class Word {
  const Word({
    required this.id, required this.text, required this.textVowelled,
    required this.startsWithLetterId, required this.image, required this.audio,
    required this.emoji,
  });

  final String id;
  final String text;
  final String textVowelled;
  final String startsWithLetterId;
  final String image;
  final String audio;
  final String emoji;

  factory Word.fromJson(Map<String, dynamic> j) => Word(
        id: j['id'] as String,
        text: j['text'] as String,
        textVowelled: j['textVowelled'] as String,
        startsWithLetterId: j['startsWithLetterId'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String,
        emoji: j['emoji'] as String? ?? '❓',
      );
}
