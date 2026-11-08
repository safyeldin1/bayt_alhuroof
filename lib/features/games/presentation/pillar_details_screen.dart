import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';

class PillarDetailsScreen extends ConsumerStatefulWidget {
  const PillarDetailsScreen({super.key, required this.pillarId});
  final String pillarId;

  @override
  ConsumerState<PillarDetailsScreen> createState() => _PillarDetailsScreenState();
}

class _PillarDetailsScreenState extends ConsumerState<PillarDetailsScreen> {
  // النصوص الكاملة لكل رُكن
  static const Map<String, Map<String, String>> _data = {
    'shahada': {
      'name': 'الرُّكْن الأَوَّل: الشهادتان',
      'emoji': '☝️',
      'desc': 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا الله\nوَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ الله',
      'audio': 'pillars/shahada',
      'color': 'FF7043',
    },
    'salah': {
      'name': 'الرُّكْن الثَّانِي: الصلاة',
      'emoji': '🕌',
      'desc': 'نُصَلِّي فِي الْيَوْم خَمْس صَلَوَات:\nالفَجْر، الظُّهْر، العَصْر، المَغْرِب، العِشَاء',
      'audio': 'pillars/salah',
      'color': '29B6F6',
    },
    'zakat': {
      'name': 'الرُّكْن الثَّالِث: الزكاة',
      'emoji': '💰',
      'desc': 'نُعْطِي جُزْءًا مِنْ أَمْوَالِنَا\nلِلْفُقَرَاء وَالْمَسَاكِين كُلَّ عَام',
      'audio': 'pillars/zakat',
      'color': '66BB6A',
    },
    'sawm': {
      'name': 'الرُّكْن الرَّابِع: الصوم',
      'emoji': '🌙',
      'desc': 'نَصُوم شَهْر رَمَضَان كَامِلًا\nمِنْ طُلُوع الفَجْر حَتَّى غُرُوب الشَّمْس',
      'audio': 'pillars/sawm',
      'color': 'AB47BC',
    },
    'hajj': {
      'name': 'الرُّكْن الخَامِس: الحج',
      'emoji': '🕋',
      'desc': 'نَزُور بَيْت الله الحَرَام فِي مَكَّة\nمَرَّة وَاحِدَة فِي العُمْر لِمَنِ اسْتَطَاع',
      'audio': 'pillars/hajj',
      'color': 'FFA726',
    },
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audio = _data[widget.pillarId]?['audio'];
      if (audio != null) ref.read(audioServiceProvider).playVoice(audio, force: true);
    });
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop(); // إيقاف الصوت
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _data[widget.pillarId];
    if (p == null) return const Scaffold(body: Center(child: Text('غير موجود')));
    final color = Color(int.parse('0xFF${p['color']}'));

    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, elevation: 0,
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
                title: Text(p['name']!, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // الإيموجي
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.2)),
                            child: Center(child: FittedBox(fit: BoxFit.contain, child: Text(p['emoji']!, style: const TextStyle(fontSize: 150)))),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // النص والصوت
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(p['desc']!, textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color, height: 1.5)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              IconButton.filled(
                                style: IconButton.styleFrom(backgroundColor: color),
                                iconSize: 40,
                                onPressed: () => ref.read(audioServiceProvider).playVoice(p['audio']!, force: true),
                                icon: const Icon(Icons.volume_up, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
