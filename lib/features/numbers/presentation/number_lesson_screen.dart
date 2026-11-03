import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../core/animations/pulse_hint.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../domain/counting_state.dart';

class NumberLessonScreen extends ConsumerStatefulWidget {
  const NumberLessonScreen({super.key, required this.numberId});
  final String numberId;
  @override
  ConsumerState<NumberLessonScreen> createState() => _NumberLessonScreenState();
}

class _NumberLessonScreenState extends ConsumerState<NumberLessonScreen> {
  CountingState? _counting;
  bool _done = false;

  String _formatNumber(int n) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return;
    final n = repo.numberById(widget.numberId);
    if (n == null) return;
    setState(() { _counting = CountingState(n.value); _done = false; });
    ref.read(audioServiceProvider).playVoice(n.audio, force: true);
  }

  Future<void> _onTapObject(int index) async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final c = _counting;
    final n = repo.numberById(widget.numberId);
    if (c == null || n == null) return;
    
    final spoken = c.tap(index);
    if (spoken == 0) return;
    setState(() {});
    
    final item = repo.numberByValue(spoken);
    if (item != null) ref.read(audioServiceProvider).playVoice(item.audio, force: true);

    if (c.complete && !_done) {
      setState(() => _done = true);
      ref.read(progressRepositoryProvider).recordResult(
            activityId: 'count_${n.id}',
            contentId: n.id,
            kind: 'number',
            attempts: 1,
            correct: 1,
            stars: 3,
          );
    }
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
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/numbers')),
              title: const Text('درس الرقم', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) {
                  final n = r.numberById(widget.numberId);
                  final c = _counting;
                  if (n == null || c == null) return const Center(child: CircularProgressIndicator(color: Colors.white));
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // بطاقة الرقم
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                          ),
                          child: Column(
                            children: [
                              BounceIn(child: Text(_formatNumber(n.value), style: const TextStyle(fontSize: 140, fontWeight: FontWeight.bold, color: Color(0xFF29B6F6), height: 1.0))),
                              Text(n.nameText, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // منطقة العد
                        if (n.value > 0) Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (var i = 0; i < n.value; i++)
                              GestureDetector(
                                onTap: () => _onTapObject(i),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: c.counted.contains(i) ? 1.0 : 0.5,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: c.counted.contains(i) ? Colors.green.shade100 : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: c.counted.contains(i) ? Colors.green : Colors.grey.shade400, width: 4),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                                    ),
                                    child: Center(
                                      child: c.counted.contains(i) 
                                        ? const Icon(Icons.check, color: Colors.green, size: 40)
                                        : const Icon(Icons.apple, color: Colors.redAccent, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ) else const Text('صِفْر (لَا شَيْء)', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Spacer(),
                        if (_done) const Icon(Icons.star, size: 80, color: Colors.amber),
                        const Spacer(),
                        // أزرار التحكم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            KidsButton(width: 80, height: 80, color: Colors.blue.shade400, onTap: _start, child: const Icon(Icons.replay, size: 40, color: Colors.white)),
                            const SizedBox(width: 24),
                            KidsButton(width: 80, height: 80, color: Colors.purple.shade400, onTap: () => context.push('/numbers/${n.id}/pick'), child: const Icon(Icons.touch_app, size: 40, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
