import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_repository.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';

class LetterLessonScreen extends ConsumerStatefulWidget {
  const LetterLessonScreen({super.key, required this.letterId});
  final String letterId;

  @override
  ConsumerState<LetterLessonScreen> createState() =>
      _LetterLessonScreenState();
}

class _LetterLessonScreenState extends ConsumerState<LetterLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  Future<void> _speak() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return; // 👈 إضافة سطر الأمان هنا
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
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.apps),
          onPressed: () => context.go('/letters'),
        ),
      ),
      body: repo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (r) {
          final letter = r.letterById(widget.letterId);
          if (letter == null) {
            return const Center(child: Text('الحرف غير موجود'));
          }
          return _LessonBody(
            repo: r,
            letter: letter,
            onReplay: _speak,
          );
        },
      ),
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({
    required this.repo,
    required this.letter,
    required this.onReplay,
  });

  final ContentRepository repo;
  final Letter letter;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final word = repo.wordById(letter.primaryWordId);
    final next = repo.nextOf(letter);
    final prev = repo.previousOf(letter);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(letter.character,
                style: Theme.of(context).textTheme.displayLarge),
            Text(letter.name,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final k in ['isolated', 'initial', 'medial', 'final'])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(letter.forms[k] ?? '',
                        style: const TextStyle(fontSize: 40)),
                  ),
              ],
            ),
            const Spacer(),
            if (word != null) ...[
              SizedBox(
                height: 160,
                child: Image.asset(
                  'assets/images/${word.image}.png',
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 96),
                ),
              ),
              Text(word.textVowelled,
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
            const SizedBox(height: 16),
            IconButton.filled(
              iconSize: 56,
              onPressed: onReplay,
              icon: const Icon(Icons.volume_up),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: () => context.push('/letters/${letter.id}/recognize'),
                  icon: const Icon(Icons.touch_app),
                ),
                const SizedBox(width: 24),
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: () => context.push('/letters/${letter.id}/trace'),
                  icon: const Icon(Icons.draw),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: prev == null
                      ? null
                      : () => context.pushReplacement('/letters/${prev.id}'),
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: next == null
                      ? null
                      : () => context.pushReplacement('/letters/${next.id}'),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
