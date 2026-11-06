import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/numbers');
    });
    final repo = ref.watch(contentRepositoryProvider);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final style = ref.watch(settingsProvider).numeralStyle;

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الأرقام', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) => LayoutBuilder(
                  builder: (context, constraints) {
                    // شبكة ذكية: 5 أعمدة للموبايل، 8 للتابلت، 10 للكمبيوتر
                    int crossAxisCount = constraints.maxWidth > 1200 ? 10 : (constraints.maxWidth > 800 ? 8 : (constraints.maxWidth > 500 ? 5 : 4));
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: r.numbers.length,
                      itemBuilder: (context, i) {
                        final n = r.numbers[i];
                        final earnedStars = stars[n.id] ?? 0;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: KidsButton(
                                color: const Color(0xFF29B6F6),
                                onTap: () => context.push('/numbers/${n.id}'),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(formatNumber(n.value, style), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                            if (earnedStars > 0)
                              const PositionedDirectional(top: 4, end: 4, child: Icon(Icons.star, color: Colors.amber, size: 24)),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
