import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_loader.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import 'tracing_canvas.dart';

final tracingProvider = FutureProvider.family((ref, String letterId) async {
  final repo = await ref.watch(contentRepositoryProvider.future);
  final letter = repo.letterById(letterId);
  if (letter == null) throw Exception('Letter not found');
  return ContentLoader().loadTracing(letter.tracingId);
});

class TracingScreen extends ConsumerStatefulWidget {
  const TracingScreen({super.key, required this.letterId});
  final String letterId;
  @override
  ConsumerState<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends ConsumerState<TracingScreen> {
  bool _done = false;

  void _complete() {
    if (_done) return;
    setState(() => _done = true);
    ref.read(progressRepositoryProvider).recordResult(
          activityId: 'trace_${widget.letterId}',
          contentId: widget.letterId,
          kind: 'letter',
          attempts: 1,
          correct: 1,
          stars: 3,
        );
  }

  @override
  Widget build(BuildContext context) {
    final trace = ref.watch(tracingProvider(widget.letterId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.apps),
          onPressed: () => context.go('/letters/${widget.letterId}'),
        ),
        title: const Text('رسم الحرف'),
      ),
      body: trace.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('تعذر تحميل المسار: $e')),
        data: (t) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: TracingCanvas(trace: t, onComplete: _complete)),
              const SizedBox(height: 24),
              if (_done)
                const Column(
                  children: [
                    Icon(Icons.star, size: 96, color: Colors.amber),
                    Text('أحسنت!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
