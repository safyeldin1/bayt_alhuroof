import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';

class PillarsLearnScreen extends ConsumerStatefulWidget {
  const PillarsLearnScreen({super.key});

  @override
  ConsumerState<PillarsLearnScreen> createState() => _PillarsLearnScreenState();
}

class _PillarsLearnScreenState extends ConsumerState<PillarsLearnScreen> {
  final List<Map<String, String>> _pillars = [
    {'id': 'shahada', 'name': 'الشهادتان', 'emoji': '☝️', 'audio': 'pillars/shahada', 'color': 'FF7043'},
    {'id': 'salah', 'name': 'الصلاة', 'emoji': '🕌', 'audio': 'pillars/salah', 'color': '29B6F6'},
    {'id': 'zakat', 'name': 'الزكاة', 'emoji': '💰', 'audio': 'pillars/zakat', 'color': '66BB6A'},
    {'id': 'sawm', 'name': 'الصوم', 'emoji': '🌙', 'audio': 'pillars/sawm', 'color': 'AB47BC'},
    {'id': 'hajj', 'name': 'الحج', 'emoji': '🕋', 'audio': 'pillars/hajj', 'color': 'FFA726'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
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
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
                title: const Text('تعلّم أركان الإسلام', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                centerTitle: true,
              ),
              Expanded(
                child: Row(
                  children: [
                    // النص الشمال: لعبة الاختبار (هنعملها في الجزء التاني)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/pillars_game'),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade400,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.videogame_asset, size: 80, color: Colors.white),
                                  SizedBox(height: 16),
                                  Text('العب اللعبة', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // النص اليمين: الأركان الخمسة
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(16),
                        itemCount: _pillars.length,
                        itemBuilder: (context, index) {
                          final p = _pillars[index];
                          return GestureDetector(
                            onTap: () => context.push('/pillar_details/${p['id']}'),
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                color: Color(int.parse('0xFF${p['color']}')),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('الرُّكْن ${index + 1}', style: const TextStyle(fontSize: 24, color: Colors.white70)),
                                      Text(p['emoji']!, style: const TextStyle(fontSize: 80)),
                                      const SizedBox(height: 8),
                                      Text(p['name']!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
