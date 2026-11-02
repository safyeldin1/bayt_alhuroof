import 'dart:math';
import '../evaluation.dart';

class ChoiceQuestion<T> {
  const ChoiceQuestion(this.target, this.options, {this.promptAudio});
  final T target;
  final List<T> options;
  final String? promptAudio;
}

class ChoiceEngine<T> {
  ChoiceEngine(this.idOf);
  final String Function(T) idOf;

  List<ChoiceQuestion<T>> build({
    required List<T> targets,
    required List<T> pool,
    int rounds = 3,
    int choices = 3,
    String? Function(T target)? promptAudioFor,
    Random? rng,
  }) {
    final r = rng ?? Random();
    return List.generate(rounds, (i) {
      final target = targets[i % targets.length];
      final others = pool.where((x) => idOf(x) != idOf(target)).toList()..shuffle(r);
      final options = [target, ...others.take(choices - 1)]..shuffle(r);
      return ChoiceQuestion<T>(target, options, promptAudio: promptAudioFor?.call(target));
    });
  }

  Evaluation evaluate(ChoiceQuestion<T> q, T answer, int wrongSoFar) {
    if (idOf(answer) == idOf(q.target)) return Evaluation.correct;
    return wrongSoFar + 1 >= 2 ? Evaluation.reveal : Evaluation.retry;
  }
}

class ChoiceSession<T> {
  ChoiceSession(this.questions, this.engine);
  final List<ChoiceQuestion<T>> questions;
  final ChoiceEngine<T> engine;
  int index = 0;
  int wrongOnCurrent = 0;
  int totalWrong = 0;

  bool get finished => index >= questions.length;
  ChoiceQuestion<T> get current => questions[index];
  int get stars => totalWrong == 0 ? 3 : (totalWrong <= 2 ? 2 : 1);

  Evaluation answer(T choice) {
    final result = engine.evaluate(current, choice, wrongOnCurrent);
    if (result != Evaluation.correct) {
      wrongOnCurrent++;
      totalWrong++;
    }
    return result;
  }

  void next() {
    index++;
    wrongOnCurrent = 0;
  }
}
