import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
        title: const Text('الحروف'),
      ),
      body: repo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (r) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: r.letters.length,
          itemBuilder: (context, i) {
            final l = r.letters[i];
            return FilledButton(
              onPressed: () => context.push('/letters/${l.id}'),
              child: Text(l.character, style: const TextStyle(fontSize: 64)),
            );
          },
        ),
      ),
    );
  }
}
