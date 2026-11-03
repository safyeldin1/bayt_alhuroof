import 'package:flutter/material.dart';
import '../../../data/models/letter.dart';
import '../../../data/models/number_item.dart';
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

class PickNumberGame extends StatelessWidget {
  const PickNumberGame({super.key, required this.numberId});
  final String numberId;

  String _formatNumber(int n) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<NumberItem>(
        activityId: 'pick_number_$numberId',
        contentId: numberId,
        kind: 'number',
        backRoute: '/numbers/$numberId',
        idOf: (n) => n.id,
        setup: (ref) async {
          final repo = await ref.read(contentRepositoryProvider.future);
          final n = repo.numberById(numberId);
          if (n == null) return const ChoiceGameSetup(questions: []);
          
          final targets = [
            n,
            if (repo.numberByValue(n.value - 1) != null) repo.numberByValue(n.value - 1)!,
            if (repo.numberByValue(n.value + 1) != null) repo.numberByValue(n.value + 1)!,
          ];
          
          return ChoiceGameSetup(
            instructionText: 'اختر الرقم الصحيح',
            questions: ChoiceEngine<NumberItem>((x) => x.id).build(
              targets: targets,
              pool: repo.numbers,
              rounds: targets.length,
            ),
          );
        },
        optionBuilder: (c, ref, n) => Text(_formatNumber(n.value), style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
      );
}
