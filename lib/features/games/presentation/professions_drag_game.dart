import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profession_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class ProfessionsDragGame extends ConsumerStatefulWidget {
  const ProfessionsDragGame({super.key});
  @override
  ConsumerState<ProfessionsDragGame> createState() => _ProfessionsDragGameState();
}

class _ProfessionsDragGameState extends ConsumerState<ProfessionsDragGame> {
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
  bool _isFinished = false;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _initRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/match');
    });
  }

  void _initRound() {
    final profession = professions[_currentIndex];
    final others = allTools.keys.where((k) => k != profession.toolId).toList()..shuffle();
    setState(() {
      _options = [profession.toolId, ...others.take(2)]..shuffle();
      _locked = false;
    });
  }

  void _onDragAccepted(String toolId) async {
    if (_locked) return;
    final profession = professions[_currentIndex];
    if (toolId == profession.toolId) {
      setState(() => _locked = true);
      ref.read(audioServiceProvider).playVoice('instructions/right', force: true);
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (_currentIndex < professions.length - 1) {
        setState(() { _currentIndex++; });
        _initRound();
      } else {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'professions_drag_game',
          contentId: 'professions',
          kind: 'profession',
          attempts: professions.length,
          correct: professions.length,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
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
    final p = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: Text('توصيل المهن (${_currentIndex + 1}/${professions.length})', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(p),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Text('اسْحَب الأَدَاة الصَّحِيحَة إِلَى المُهِمَّة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
        ),
        const SizedBox(height: 24),
        
        DragTarget<String>(
          onAcceptWithDetails: (details) => _onDragAccepted(details.data),
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 180, height: 220, // الارتفاع ده مهم عشان نمنع الشريط الأصفر
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange, width: 5),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(profession.emoji, style: const TextStyle(fontSize: 90)),
                  const SizedBox(height: 8),
                  Text(profession.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                ],
              ),
            );
          },
        ),
        const Spacer(),
        
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _options.map((toolId) {
            final tool = allTools[toolId]!;
            return Draggable<String>(
              data: toolId,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 100, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tool.emoji, style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 8),
                      Text(tool.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              childWhenDragging: const SizedBox(width: 100, height: 120),
              child: Container(
                width: 100, height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tool.emoji, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(tool.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () {
                setState(() { _currentIndex = 0; _isFinished = false; });
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
