import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_repository.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../core/widgets/kids_background.dart';

class LetterLessonScreen extends ConsumerStatefulWidget {
  const LetterLessonScreen({super.key, required this.letterId});
  final String letterId;
  @override
  ConsumerState<LetterLessonScreen> createState() => _LetterLessonScreenState();
}

class _LetterLessonScreenState extends ConsumerState<LetterLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  Future<void> _speak() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return;
    final letter = repo.letterById(widget.letterId);
    if (letter == null) return;
    final word = repo.wordById(letter.primaryWordId);
    ref.read(audioServiceProvider).playSequence([letter.nameAudio, if (word != null) word.audio]);
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(contentRepositoryProvider);
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: repo.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
            data: (r) {
              final letter = r.letterById(widget.letterId);
              if (letter == null) return const Center(child: Text('الحرف غير موجود', style: TextStyle(color: Colors.white)));
              return _LessonBody(repo: r, letter: letter, onReplay: _speak);
            },
          ),
        ),
      ),
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({required this.repo, required this.letter, required this.onReplay});
  final ContentRepository repo;
  final Letter letter;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final word = repo.wordById(letter.primaryWordId);
    final next = repo.nextOf(letter);
    final prev = repo.previousOf(letter);

    return Column(
      children: [
        // شريط علوي بسيط
        AppBar(
          backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/letters')),
        ),
        
        // تقسيم الشاشة لعرض الحرف (شمال) والكلمة (يمين)
        Expanded(
          child: Row(
            children: [
              // النص الشمال: بطاقة الحرف
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الحرف بحجم كبير ومتجاوب
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(letter.character, style: const TextStyle(fontSize: 150, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          ),
                        ),
                      ),
                      Text(letter.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              
              // النص اليمين: الكلمة والألعاب
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // بطاقة الكلمة
                    if (word != null)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.orange.shade200, width: 2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(child: Text(word.emoji, style: const TextStyle(fontSize: 60))),
                            const SizedBox(width: 16),
                            FittedBox(child: Text(word.textVowelled, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))),
                            const SizedBox(width: 8),
                            IconButton.filled(iconSize: 30, onPressed: onReplay, icon: const Icon(Icons.volume_up)),
                          ],
                        ),
                      ),
                    
                    // أزرار الأنشطة (التعرف، السحب، التتبع)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(iconSize: 50, onPressed: () => context.push('/letters/${letter.id}/recognize'), icon: const Icon(Icons.touch_app)),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(iconSize: 50, onPressed: () => context.push('/letters/${letter.id}/drag'), icon: const Icon(Icons.drag_indicator)),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(iconSize: 50, onPressed: () => context.push('/letters/${letter.id}/trace'), icon: const Icon(Icons.draw)),
                      ],
                    ),
                    
                    // أزرار التنقل (السابق والتالي)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filled(iconSize: 40, onPressed: prev == null ? null : () => context.pushReplacement('/letters/${prev.id}'), icon: const Icon(Icons.arrow_back)),
                        IconButton.filled(iconSize: 40, onPressed: next == null ? null : () => context.pushReplacement('/letters/${next.id}'), icon: const Icon(Icons.arrow_forward)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
