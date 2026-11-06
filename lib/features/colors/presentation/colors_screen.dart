import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../data/models/color_item.dart';
import '../../../providers/audio_providers.dart';

class ColorsScreen extends ConsumerWidget {
  const ColorsScreen({super.key});

  static const List<ColorItem> colors = [
    ColorItem(id: 'red', name: 'أَحْمَر', hexColor: '#F44336', emoji: '🍎'),
    ColorItem(id: 'blue', name: 'أَزْرَق', hexColor: '#2196F3', emoji: '🌊'),
    ColorItem(id: 'yellow', name: 'أَصْفَر', hexColor: '#FFEB3B', emoji: '🌞'),
    ColorItem(id: 'green', name: 'أَخْضَر', hexColor: '#4CAF50', emoji: '🌿'),
    ColorItem(id: 'orange', name: 'بُرْتُقَالِي', hexColor: '#FF9800', emoji: '🍊'),
    ColorItem(id: 'purple', name: 'بَنَفْسَجِي', hexColor: '#9C27B0', emoji: '🍇'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/colors');
    });

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الألوان', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity, height: 60,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
                  onPressed: () => context.push('/colors/game'),
                  icon: const Icon(Icons.videogame_asset, color: Colors.white),
                  label: const Text('العب لعبة الألوان', style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, i) {
                      final c = colors[i];
                      return BounceIn(
                        child: GestureDetector(
                          onTap: () => ref.read(audioServiceProvider).playVoice('colors/${c.id}', force: true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: c.color,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [BoxShadow(color: c.color.withValues(alpha: 0.6), blurRadius: 15, offset: const Offset(0, 8))],
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(c.emoji, style: const TextStyle(fontSize: 60)),
                                const SizedBox(height: 8),
                                Text(c.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: c.id == 'yellow' ? Colors.black87 : Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
