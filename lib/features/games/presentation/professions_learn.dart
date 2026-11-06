import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';

class ProfessionsLearn extends ConsumerStatefulWidget {
  const ProfessionsLearn({super.key});
  @override
  ConsumerState<ProfessionsLearn> createState() => _ProfessionsLearnState();
}

class _ProfessionsLearnState extends ConsumerState<ProfessionsLearn> {
  static const List<Map<String, String>> professions = [
    {'name': 'نَجَّار', 'emoji': '👨‍🔧', 'tool': 'مِنْشَار', 'toolEmoji': '🪚', 'audio': 'professions/carpenter'},
    {'name': 'طَبِيب', 'emoji': '👨‍⚕️', 'tool': 'سَمَّاعَة', 'toolEmoji': '🩺', 'audio': 'professions/doctor'},
    {'name': 'مُعَلِّم', 'emoji': '👨‍🏫', 'tool': 'كِتَاب', 'toolEmoji': '📚', 'audio': 'professions/teacher'},
    {'name': 'طَبَّاخ', 'emoji': '👨‍🍳', 'tool': 'مِقْلَاة', 'toolEmoji': '🍳', 'audio': 'professions/chef'},
    {'name': 'طَيَّار', 'emoji': '👨‍✈️', 'tool': 'طَائِرَة', 'toolEmoji': '✈️', 'audio': 'professions/pilot'},
    {'name': 'فَلَّاح', 'emoji': '👨‍🌾', 'tool': 'جَرَّارَة', 'toolEmoji': '🚜', 'audio': 'professions/farmer'},
    {'name': 'رَجُل إِطْفَاء', 'emoji': '👨‍🚒', 'tool': 'عَرَبَة إِطْفَاء', 'toolEmoji': '🚒', 'audio': 'professions/firefighter'},
    {'name': 'شُرْطِي', 'emoji': '👮', 'tool': 'شَارَة', 'toolEmoji': '🛡️', 'audio': 'professions/police'},
    {'name': 'مُهَنْدِس', 'emoji': '👷', 'tool': 'خُوذَة', 'toolEmoji': '⛑️', 'audio': 'professions/engineer'},
    {'name': 'رَسَّام', 'emoji': '👨‍🎨', 'tool': 'لَوْحَة أَلْوَان', 'toolEmoji': '🎨', 'audio': 'professions/artist'},
    {'name': 'عَالِم', 'emoji': '👨‍🔬', 'tool': 'مِجْهَر', 'toolEmoji': '🔬', 'audio': 'professions/scientist'},
    {'name': 'خَبَّاز', 'emoji': '👨‍🍳', 'tool': 'خُبْز', 'toolEmoji': '🥖', 'audio': 'professions/baker'},
  ];

  int _currentIndex = 0;
  void _speak() {
    if (!mounted) return;
    ref.read(audioServiceProvider).playVoice(professions[_currentIndex]['audio']!, force: true);
  }

  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => _speak()); }
  @override
  void dispose() { ref.read(audioServiceProvider).stop(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final p = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/professions')), title: const Text('تعلّم المهن', style: TextStyle(color: Colors.white))),
              Expanded(
                child: Row(
                  children: [
                    IconButton(iconSize: 30, icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () { setState(() => _currentIndex = (_currentIndex - 1 + professions.length) % professions.length); _speak(); }),
                    
                    // القسم الأول (المهنة) - بدون إطار
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: FittedBox(fit: BoxFit.contain, child: Text(p['emoji']!, style: const TextStyle(fontSize: 100)))),
                          Expanded(flex: 1, child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: Text(p['name']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                            ),
                          )),
                        ],
                      ),
                    ),
                    
                    // القسم الثاني (يستخدم)
                    const Expanded(
                      child: Center(child: FittedBox(fit: BoxFit.contain, child: Text('يستخدم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)))),
                    ),
                    
                    // القسم الثالث (الأداة) - بدون إطار + السماعة
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: FittedBox(fit: BoxFit.contain, child: Text(p['toolEmoji']!, style: const TextStyle(fontSize: 100)))),
                          Expanded(flex: 1, child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.volume_up, color: Colors.orange), onPressed: _speak),
                                  Text(p['tool']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    
                    IconButton(iconSize: 30, icon: const Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: () { setState(() => _currentIndex = (_currentIndex + 1) % professions.length); _speak(); }),
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
