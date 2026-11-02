import 'package:flutter/material.dart';
import '../../../data/models/letter.dart';
import '../../../providers/content_providers.dart';
import '../domain/engines/choice_engine.dart';
import 'choice_game_screen.dart';

class RecognizeLetterGame extends StatelessWidget {
  const RecognizeLetterGame({super.key, required this.letterId});
  final String letterId;

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<Letter>(
        activityId: 'recognize_$letterId',
        contentId: letterId,
        kind: 'letter',
        backRoute: '/letters/$letterId',
        idOf: (l) => l.id,
        setup: (ref) async {
          final repo = await ref.read(contentRepositoryProvider.future);
          final target = repo.letterById(letterId);
          if (target == null) return const ChoiceGameSetup(questions: []);
          return ChoiceGameSetup(
            instructionText: 'اسمع الصوت واختر الحرف الصح',
            questions: ChoiceEngine<Letter>((l) => l.id).build(
              targets: [target],
              pool: repo.letters,
              promptAudioFor: (l) => l.soundAudio,
            ),
          );
        },
        optionBuilder: (c, ref, l) => Text(
          l.character,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
      );
}
