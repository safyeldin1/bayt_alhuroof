import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profession_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/floating.dart';
import '../../../core/animations/star_burst.dart';

class ProfessionsChoiceGame extends ConsumerStatefulWidget {
  const ProfessionsChoiceGame({super.key});
  @override
  ConsumerState<ProfessionsChoiceGame> createState() => _ProfessionsChoiceGameState();
}

class _ProfessionsChoiceGameState extends ConsumerState<ProfessionsChoiceGame> {
  static const List<ProfessionItem> professions = [
    ProfessionItem(id: 'carpenter', name: 'نَجَّار', emoji: '👨‍🔧', toolId: 'saw'),
    ProfessionItem(id: 'doctor', name: 'طَبِيب', emoji: '👨‍⚕️', toolId: 'stethoscope'),
    ProfessionItem(id: 'teacher', name: 'مُعَلِّم', emoji: '👨‍🏫', toolId: 'book'),
    ProfessionItem(id: 'chef', name: 'طَبَّاخ', emoji: '👨‍🍳', toolId: 'pan'),
    ProfessionItem(id: 'pilot', name: 'طَيَّار', emoji: '👨‍✈️', toolId: 'plane'),
    ProfessionItem(id: 'farmer', name: 'فَلَّاح', emoji: '👨‍🌾', toolId: 'tractor'),
    ProfessionItem(id: 'firefighter', name: 'رَجُل إِطْفَاء', emoji: '👨‍🚒', toolId: 'firetruck'),
    ProfessionItem(id: 'police', name: 'شُرْطِي', emoji: '👮', toolId: 'badge'),
    ProfessionItem(id: 'engineer', name: 'مُهَنْدِس', emoji: '👷', toolId: 'helmet'),
    ProfessionItem(id: 'artist', name: 'رَسَّام', emoji: '👨‍🎨', toolId: 'palette'),
    ProfessionItem(id: 'scientist', name: 'عَالِم', emoji: '👨‍🔬', toolId: 'microscope'),
    ProfessionItem(id: 'baker', name: 'خَبَّاز', emoji: '🥖', toolId: 'bread'),
  ];

  static const Map<String, ToolItem> allTools = {
    'saw': ToolItem(id: 'saw', name: 'مِنْشَار', emoji: '🪚'),
    'stethoscope': ToolItem(id: 'stethoscope', name: 'سَمَّاعَة', emoji: '🩺'),
    'book': ToolItem(id: 'book', name: 'كِتَاب', emoji: '📚'),
    'pan': ToolItem(id: 'pan', name: 'مِقْلَاة', emoji: '🍳'),
    'plane': ToolItem(id: 'plane', name: 'طَائِرَة', emoji: '✈️'),
    'tractor': ToolItem(id: 'tractor', name: 'جَرَّارَة', emoji: '🚜'),
    'firetruck': ToolItem(id: 'firetruck', name: 'عَرَبَة إِطْفَاء', emoji: '🚒'),
    'badge': ToolItem(id: 'badge', name: 'شَارَة', emoji: '🛡️'),
    'helmet': ToolItem(id: 'helmet', name: 'خُوذَة', emoji: '⛑️'),
    'palette': ToolItem(id: 'palette', name: 'لَوْحَة أَلْوَان', emoji: '🎨'),
    'microscope': ToolItem(id: 'microscope', name: 'مِجْهَر', emoji: '🔬'),
    'bread': ToolItem(id: 'bread', name: 'خُبْز', emoji: '🥖'),
  };

  int _currentIndex = 0;
  List<String> _options = [];
  String? _wrongId;
  String? _okId;
  bool _isFinished = false;
  int _wrongAttempts = 0;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _initRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/professions');
    });
  }

  void _initRound() {
    final profession = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice('professions/q_${profession.id}', force: true);
    final otherTools = allTools.keys.where((k) => k != profession.toolId).toList()..shuffle();
    setState(() {
      _options = [profession.toolId, ...otherTools.take(2)]..shuffle();
      _okId = null;
      _wrongId = null;
      _locked = false;
    });
  }

  void _onTapTool(String toolId) async {
    if (_locked) return;
    final profession = professions[_currentIndex];
    if (toolId == profession.toolId) {
      setState(() { _okId = toolId; _locked = true; });
      ref.read(audioServiceProvider).playSequence(['instructions/right', 'tools/$toolId']);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (_currentIndex < professions.length - 1) {
        setState(() { _currentIndex++; });
        _initRound();
      } else {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'professions_choice_game',
          contentId: 'professions',
          kind: 'profession',
          attempts: professions.length + _wrongAttempts,
          correct: professions.length,
          stars: _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 3 ? 2 : 1),
        );
      }
    } else {
      setState(() { _wrongId = toolId; _wrongAttempts++; });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() => _wrongId = null);
    }
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profession = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: Text('اختيار الأداة (${_currentIndex + 1}/${professions.length})', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(profession),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard(ProfessionItem profession) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Text('مَا هِيَ الأَدَاة الَّتِي يَسْتَخْدِمُهَا؟', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
        ),
        const SizedBox(height: 24),
        Floating(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))]),
            child: Column(
              children: [
                Text(profession.emoji, style: const TextStyle(fontSize: 120)),
                const SizedBox(height: 8),
                Text(profession.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
              ],
            ),
          ),
        ),
        const Spacer(),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _options.map((toolId) {
            final tool = allTools[toolId]!;
            final isOk = toolId == _okId;
            final isWrong = toolId == _wrongId;
            return GestureDetector(
              onTap: () => _onTapTool(toolId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 110, height: 130,
                decoration: BoxDecoration(
                  color: isOk ? Colors.green.shade100 : (isWrong ? Colors.orange.shade100 : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isOk ? Colors.green : (isWrong ? Colors.orange : Colors.grey.shade300), width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tool.emoji, style: const TextStyle(fontSize: 60)),
                    const SizedBox(height: 8),
                    Text(tool.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isOk ? Colors.green : (isWrong ? Colors.orange : Colors.black87))),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildResult() {
    final stars = _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 3 ? 2 : 1);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarBurst(stars: stars),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(stars, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () {
                setState(() { _currentIndex = 0; _isFinished = false; _wrongAttempts = 0; });
                _initRound();
              }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
