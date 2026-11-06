import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';
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
    final style = ref.watch(settingsProvider).numeralStyle;

    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: repo.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
            data: (r) {
              final n = r.numberById(widget.numberId);
              final c = _counting;
              if (n == null || c == null) return const Center(child: CircularProgressIndicator(color: Colors.white));
              
              return Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(iconSize: 30, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/numbers')),
                    title: const Text('درس الرقم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    centerTitle: true,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        // النص الشمال: بطاقة الرقم
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(formatNumber(n.value, style), style: const TextStyle(fontSize: 150, fontWeight: FontWeight.bold, color: Color(0xFF29B6F6))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: FittedBox(child: Text(n.nameText, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // النص اليمين: العد والأزرار
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // منطقة العد
                              Expanded(
                                child: Center(
                                  child: n.value > 0 && n.value <= 20 
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          for (var i = 0; i < n.value; i++)
                                            GestureDetector(
                                              onTap: () => _onTapObject(i),
                                              child: AnimatedOpacity(
                                                duration: const Duration(milliseconds: 200),
                                                opacity: c.counted.contains(i) ? 1.0 : 0.5,
                                                child: Container(
                                                  width: 60, height: 60,
                                                  decoration: BoxDecoration(
                                                    color: c.counted.contains(i) ? Colors.green.shade100 : Colors.white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: c.counted.contains(i) ? Colors.green : Colors.grey.shade400, width: 3),
                                                  ),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: Text(c.counted.contains(i) ? '✅' : '🍎', style: const TextStyle(fontSize: 30)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    : const Text('', style: TextStyle(fontSize: 20)),
                                ),
                              ),
                              
                              // النجمة
                              if (_done) const Icon(Icons.star, size: 50, color: Colors.amber),

                              // أزرار التحكم
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton.filled(iconSize: 40, onPressed: _start, icon: const Icon(Icons.replay)),
                                    const SizedBox(width: 16),
                                    IconButton.filled(iconSize: 40, onPressed: () => context.push('/numbers/${n.id}/pick'), icon: const Icon(Icons.touch_app)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
