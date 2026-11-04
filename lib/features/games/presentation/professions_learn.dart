import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../core/animations/floating.dart';

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
    final p = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice(p['audio']!, force: true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
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
              title: const Text('تعلّم المهن', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BounceIn(
                    key: ValueKey(_currentIndex),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Floating(child: Text(p['emoji']!, style: const TextStyle(fontSize: 100))),
                          const SizedBox(height: 8),
                          Text(p['name']!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          const SizedBox(height: 16),
                          const Text('يَسْتَخْدِمُ:', style: TextStyle(fontSize: 20, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p['toolEmoji']!, style: const TextStyle(fontSize: 60)),
                              const SizedBox(width: 16),
                              Text(p['tool']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          IconButton.filled(iconSize: 40, onPressed: _speak, icon: const Icon(Icons.volume_up)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                    iconSize: 48,
                    onPressed: () { setState(() { _currentIndex = (_currentIndex - 1 + professions.length) % professions.length; }); _speak(); },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('${_currentIndex + 1} / ${professions.length}', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                    iconSize: 48,
                    onPressed: () { setState(() { _currentIndex = (_currentIndex + 1) % professions.length; }); _speak(); },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
