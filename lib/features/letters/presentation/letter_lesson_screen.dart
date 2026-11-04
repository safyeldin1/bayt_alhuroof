import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_repository.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/widgets/animated_image.dart'; // 👈 الصورة المتحركة

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
    ref.read(audioServiceProvider).playSequence([
      letter.nameAudio,
      if (word != null) word.audio,
    ]);
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
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters')),
            ),
            Expanded(
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
          ],
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

    // استخدام SingleChildScrollView عشان نمنع مشكلة الأصفر والأسود
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة الحرف
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                children: [
                  BounceIn(
                    child: Text(letter.character, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Color(0xFF00796B), height: 1.0)),
                  ),
                  Text(letter.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final k in ['isolated', 'initial', 'medial', 'final'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(letter.forms[k] ?? '', style: const TextStyle(fontSize: 32, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // بطاقة الكلمة والصورة
            if (word != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedImage(
                      imagePath: 'assets/images/${word.image}.png',
                      emoji: word.emoji,
                      onTap: onReplay,
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        Text(word.textVowelled, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: onReplay,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                            child: const Icon(Icons.volume_up, size: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            
            // أزرار الأنشطة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KidsButton(
                  width: 80,
                  height: 80,
                  color: Colors.purple.shade400,
                  onTap: () => context.push('/letters/${letter.id}/recognize'),
                  child: const Icon(Icons.touch_app, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                KidsButton(
                  width: 80,
                  height: 80,
                  color: Colors.amber.shade600,
                  onTap: () => context.push('/letters/${letter.id}/match'),
                  child: const Icon(Icons.image, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                KidsButton(
                  width: 80,
                  height: 80,
                  color: Colors.teal.shade400,
                  onTap: () => context.push('/letters/${letter.id}/trace'),
                  child: const Icon(Icons.draw, size: 40, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // أزرار التنقل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                  iconSize: 40,
                  onPressed: prev == null ? null : () => context.pushReplacement('/letters/${prev.id}'),
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                  iconSize: 40,
                  onPressed: next == null ? null : () => context.pushReplacement('/letters/${next.id}'),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
