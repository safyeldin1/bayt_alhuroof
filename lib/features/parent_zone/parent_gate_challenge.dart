import 'dart:math';

class ParentGateChallenge {
  ParentGateChallenge({required this.a, required this.b, required this.answer, required this.options});
  final int a, b, answer;
  final List<int> options;

  factory ParentGateChallenge.generate([Random? rng]) {
    final r = rng ?? Random();
    final a = r.nextInt(6) + 4; // 4 to 9
    final b = r.nextInt(6) + 4; // 4 to 9
    final answer = a * b;
    final options = <int>{answer, answer + 2, answer - 3, answer + 5}.toList()..shuffle(r);
    return ParentGateChallenge(a: a, b: b, answer: answer, options: options);
  }

  bool check(int v) => v == answer;
}
