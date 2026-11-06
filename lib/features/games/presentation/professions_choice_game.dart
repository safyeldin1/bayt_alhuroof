import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profession_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';

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
  ];
  static const Map<String, ToolItem> allTools = {
    'saw': ToolItem(id: 'saw', name: 'مِنْشَار', emoji: '🪚'), 
    'stethoscope': ToolItem(id: 'stethoscope', name: 'سَمَّاعَة', emoji: '🩺'),
    'book': ToolItem(id: 'book', name: 'كِتَاب', emoji: '📚'), 
    'pan': ToolItem(id: 'pan', name: 'مِقْلَاة', emoji: '🍳'),
  };
  
  int _currentIndex = 0; 
  List<String> _options = []; 
  String? _okId; 
  bool _locked = false;

  @override
  void initState() { super.initState(); _initRound(); }
  
  void _initRound() {
    if (!mounted) return;
    final prof = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice('professions/q_${prof.id}');
    final others = allTools.keys.where((k) => k != prof.toolId).toList()..shuffle();
    setState(() { _options = [prof.toolId, ...others.take(2)]..shuffle(); _okId = null; _locked = false; });
  }
  
  void _onTap(String toolId) async {
    if (_locked) return;
    if (toolId == professions[_currentIndex].toolId) {
      setState(() { _okId = toolId; _locked = true; });
      ref.read(audioServiceProvider).playSequence(['instructions/right', 'tools/$toolId']);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      if (_currentIndex < professions.length - 1) { setState(() => _currentIndex++); _initRound(); }
      else { setState(() => _locked = false); context.go('/professions'); }
    } else {
      ref.read(audioServiceProvider).playVoice('instructions/try_again');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final prof = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/professions')), title: const Text('اختيار الأداة', style: TextStyle(color: Colors.white))),
              Expanded(
                child: Row(
                  children: [
                    // القسم الأول (الخيارات)
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
                          children: _options.map((toolId) {
                            final tool = allTools[toolId]!;
                            return GestureDetector(
                              onTap: () => _onTap(toolId),
                              child: Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  color: _okId == toolId ? Colors.green.shade100 : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _okId == toolId ? Colors.green : Colors.orange, width: 3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: FittedBox(fit: BoxFit.contain, child: Text(tool.emoji, style: const TextStyle(fontSize: 50)))),
                                    FittedBox(fit: BoxFit.contain, child: Text(tool.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // القسم الثاني (السؤال)
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: const Text('ما الأداة التي يستخدمها؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          ),
                        ),
                      ),
                    ),
                    // القسم الثالث (الصورة بدون إطار + السماعة)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: FittedBox(fit: BoxFit.contain, child: Text(prof.emoji, style: const TextStyle(fontSize: 100)))),
                          Expanded(flex: 1, child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.volume_up, color: Colors.blue), onPressed: () => ref.read(audioServiceProvider).playVoice('professions/q_${prof.id}')),
                                  Text(prof.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
