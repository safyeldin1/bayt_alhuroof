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

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    // جلب 3 كلمات عشوائية (شاملة كلمة الحرف الحالي)
    final targetLetter = repo.letterById(widget.letterId);
    if (targetLetter == null) return;

    final targetWord = repo.wordById(targetLetter.primaryWordId);
    if (targetWord == null) return;

    // جلب كلمتين إضافيتين من حروف أخرى
    final otherWords = repo.words.where((w) => w.id != targetWord.id).toList()..shuffle();
    final selectedWords = [targetWord, ...otherWords.take(2)];

    // جلب الحروف المطابقة
    final selectedLetters = selectedWords.map((w) => repo.letterById(w.startsWithLetterId)!).toList()..shuffle();

    setState(() {
      _words = selectedWords..shuffle();
      _options = selectedLetters;
      _matched = {for (var w in _words) w.id: false};
      _isLoading = false;
    });
  }

  void _onDragAccepted(Word word, Letter letter) {
    if (word.startsWithLetterId == letter.id) {
      // إجابة صحيحة
      setState(() {
        _matched[word.id] = true;
      });
      ref.read(audioServiceProvider).playVoice(letter.soundAudio, force: true);
      
      // التحقق من الفوز
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
      // إجابة خاطئة
      setState(() => _wrongAttempts++);
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
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters/${widget.letterId}')),
              title: const Text('اسحب الحرف للصورة الصح', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
        // منطقة الصور (أهداف السحب)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text(word.emoji, style: const TextStyle(fontSize: 50)),
                      Text(word.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                      if (isMatched) const Icon(Icons.check_circle, color: Colors.green, size: 24),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        // منطقة الحروف (الأشياء اللي بتتسحب)
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((letter) {
            // لو الحرف ده اتسحب صح، نخفيه
            final isUsed = _words.any((w) => w.startsWithLetterId == letter.id && _matched[w.id] == true);
            if (isUsed) return const SizedBox(width: 80, height: 80); // مساحة فاضية عشان التصميم ميبوظش

            return Draggable<Letter>(
              data: letter,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              child: Container(
                width: 80,
                height: 80,
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
                const Icon(Icons.star, size: 80, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () { setState(() { _isLoading = true; _isFinished = false; _wrongAttempts = 0; }); _initGame(); }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/letters/${widget.letterId}'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
