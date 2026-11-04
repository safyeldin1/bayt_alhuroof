import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class LetterShadowGame extends ConsumerStatefulWidget {
  const LetterShadowGame({super.key});

  @override
  ConsumerState<LetterShadowGame> createState() => _LetterShadowGameState();
}

class _LetterShadowGameState extends ConsumerState<LetterShadowGame> {
  List<Letter> _targetLetters = [];
  List<Letter> _options = [];
  Map<String, bool> _matched = {};
  bool _isLoading = true;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final allLetters = repo.letters.toList()..shuffle();
    final selected = allLetters.take(3).toList();

    setState(() {
      _targetLetters = selected;
      _options = selected.toList()..shuffle();
      _matched = {for (var l in selected) l.id: false};
      _isLoading = false;
      _isFinished = false;
    });
  }

  void _onDragAccepted(String shadowId, Letter draggedLetter) {
    if (shadowId == draggedLetter.id) {
      setState(() => _matched[shadowId] = true);
      ref.read(audioServiceProvider).playVoice(draggedLetter.soundAudio, force: true);

      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'letter_shadow_game',
          contentId: 'letters',
          kind: 'letter',
          attempts: 3,
          correct: 3,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters')),
              title: const Text('طابق الحروف', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _isFinished 
                  ? _buildResult() 
                  : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('اسحب الحرف وضعه على ظله', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _targetLetters.map((letter) {
            final isMatched = _matched[letter.id] ?? false;
            return DragTarget<Letter>(
              onAcceptWithDetails: (details) => _onDragAccepted(letter.id, details.data),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: isMatched ? Colors.green.shade100 : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isMatched ? Colors.green : Colors.white, width: 3),
                  ),
                  child: Center(
                    child: isMatched 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 60)
                      : Text(letter.character, style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((letter) {
            final isUsed = _matched[letter.id] == true;
            if (isUsed) return const SizedBox(width: 80, height: 80);

            return Draggable<Letter>(
              data: letter,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              childWhenDragging: const SizedBox(width: 80, height: 80), // شيل الشكل خالص وهو بيتسحب
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () { setState(() => _isLoading = true); _initGame(); }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/letters'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
