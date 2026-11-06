import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/number_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';

class CountingGame extends ConsumerStatefulWidget {
  const CountingGame({super.key, required this.numberId});
  final String numberId;

  @override
  ConsumerState<CountingGame> createState() => _CountingGameState();
}

class _CountingGameState extends ConsumerState<CountingGame> {
  NumberItem? _number;
  Set<int> _counted = {};
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
    final n = repo.numberById(widget.numberId);
    if (n != null) {
      setState(() {
        _number = n;
        _counted = {};
        _isLoading = false;
        _isFinished = false;
        _wrongAttempts = 0;
      });
      ref.read(audioServiceProvider).playVoice(n.audio, force: true);
    }
  }

  void _onTapObject(int index) {
    if (_isFinished) return;
    if (_counted.contains(index)) return;

    setState(() {
      _counted.add(index);
    });

    final repo = ref.read(contentRepositoryProvider).valueOrNull;
    if (repo != null) {
      final spokenNumber = repo.numberByValue(_counted.length);
      if (spokenNumber != null) {
        ref.read(audioServiceProvider).playVoice(spokenNumber.audio, force: true);
      }
    }

    if (_counted.length == _number!.value) {
      setState(() => _isFinished = true);
      ref.read(progressRepositoryProvider).recordResult(
        activityId: 'count_game_${_number!.id}',
        contentId: _number!.id,
        kind: 'number',
        attempts: _number!.value + _wrongAttempts,
        correct: _number!.value,
        stars: 3,
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
                leading: IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/numbers/${widget.numberId}')),
                title: const Text('عُدَّ العناصر', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
    final style = ref.watch(settingsProvider).numeralStyle;
    final targetCount = _number!.value;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // النص الشمال: الرقم
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(formatNumber(targetCount, style), style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Color(0xFF29B6F6))),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('اضغط على $targetCount عناصر', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          
          // النص اليمين: العناصر
          Expanded(
            flex: 2,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < targetCount + 3; i++)
                    GestureDetector(
                      onTap: () => _onTapObject(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: _counted.contains(i) ? Colors.green.shade100 : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: _counted.contains(i) ? Colors.green : Colors.grey.shade300, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        child: Center(
                          child: FittedBox(child: Text(_counted.contains(i) ? '✅' : '🍎', style: const TextStyle(fontSize: 35))),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final style = ref.watch(settingsProvider).numeralStyle;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('أحسنت! لقد عددت ${formatNumber(_number!.value, style)} بشكل صحيح', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 50, onPressed: _initGame, icon: const Icon(Icons.replay)),
              const SizedBox(width: 24),
              IconButton.filled(iconSize: 50, onPressed: () => context.go('/numbers/${widget.numberId}'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
