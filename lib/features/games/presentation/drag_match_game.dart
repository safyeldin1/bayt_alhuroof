import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/letter.dart';
import '../../../data/models/word.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class DragMatchGame extends ConsumerStatefulWidget {
  const DragMatchGame({super.key, required this.letterId});
  final String letterId;

  @override
  ConsumerState<DragMatchGame> createState() => _DragMatchGameState();
}

class _DragMatchGameState extends ConsumerState<DragMatchGame> {
  List<Word> _words = [];
  List<Letter> _options = [];
  Map<String, bool> _matched = {};
  bool _isLoading = true;
  bool _isFinished = false;
  int _wrongAttempts = 0;
  String? _draggedLetterId;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final targetLetter = repo.letterById(widget.letterId);
    if (targetLetter == null) return;

    final targetWord = repo.wordById(targetLetter.primaryWordId);
    if (targetWord == null) return;

    // جلب 3 كلمات عشوائية (شاملة كلمة الحرف الحالي)
    final otherWords = repo.words.where((w) => w.id != targetWord.id).toList()..shuffle();
    final selectedWords = [targetWord, ...otherWords.take(2)];

    // جلب الحروف المطابقة
    final selectedLetters = selectedWords.map((w) => repo.letterById(w.startsWithLetterId)!).toList()..shuffle();

    setState(() {
      _words = selectedWords..shuffle();
      _options = selectedLetters;
      _matched = {for (var w in _words) w.id: false};
      _isLoading = false;
      _isFinished = false;
      _wrongAttempts = 0;
    });
  }

  void _onDragAccepted(Word word, Letter letter) {
    if (word.startsWithLetterId == letter.id) {
      setState(() {
        _matched[word.id] = true;
      });
      ref.read(audioServiceProvider).playVoice(letter.soundAudio, force: true);
      
      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'drag_match_${widget.letterId}',
          contentId: widget.letterId,
          kind: 'letter',
          attempts: 3 + _wrongAttempts,
          correct: 3,
          stars: _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 2 ? 2 : 1),
        );
      }
    } else {
      setState(() => _wrongAttempts++);
      ref.read(audioServiceProvider).playVoice('instructions/try_again', force: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/letters/${widget.letterId}')),
                title: const Text('اسحب الحرف للصورة الصح', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  Widget _buildGameBoard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // النص الشمال: الصور (أهداف السحب)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('اسحب الحرف إلى الصورة الصحيحة', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: _words.map((word) {
                    final isMatched = _matched[word.id] ?? false;
                    return DragTarget<Letter>(
                      onAcceptWithDetails: (details) => _onDragAccepted(word, details.data),
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            color: isMatched ? Colors.green.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isMatched ? Colors.green : Colors.grey.shade300, width: 3),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text(word.emoji, style: const TextStyle(fontSize: 50)))),
                              FittedBox(fit: BoxFit.scaleDown, child: Text(word.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00796B)))),
                              if (isMatched) const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // النص اليمين: الحروف (اللي بتتسحب)
          Expanded(
            flex: 1,
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _options.map((letter) {
                  final isUsed = _words.any((w) => w.startsWithLetterId == letter.id && _matched[w.id] == true);
                  if (isUsed) return const SizedBox(width: 80, height: 80);

                  return Draggable<Letter>(
                    data: letter,
                    onDragStarted: () => setState(() => _draggedLetterId = letter.id),
                    onDragEnd: (_) => setState(() => _draggedLetterId = null),
                    onDraggableCanceled: (_, __) => setState(() => _draggedLetterId = null),
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                        child: Center(child: FittedBox(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)))),
                      ),
                    ),
                    childWhenDragging: _draggedLetterId == letter.id ? const SizedBox(width: 80, height: 80) : null,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      child: Center(child: FittedBox(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)))),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final stars = _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 2 ? 2 : 1);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarBurst(stars: stars),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < stars; i++)
                const Icon(Icons.star, size: 60, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 50, onPressed: () { setState(() { _isLoading = true; _isFinished = false; _wrongAttempts = 0; }); _initGame(); }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 24),
              IconButton.filled(iconSize: 50, onPressed: () => context.go('/letters/${widget.letterId}'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
