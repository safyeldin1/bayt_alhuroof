import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/animations/bounce_in.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الحروف', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) => LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 900 ? 6 : (constraints.maxWidth > 600 ? 4 : 3);
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: r.letters.length,
                      itemBuilder: (context, i) {
                        final l = r.letters[i];
                        final earnedStars = stars[l.id] ?? 0;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: KidsButton(
                                color: Colors.white,
                                onTap: () => context.push('/letters/${l.id}'),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(l.character, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                                  ),
                                ),
                              ),
                            ),
                            if (earnedStars > 0)
                              const PositionedDirectional(top: 4, end: 4, child: Icon(Icons.star, color: Colors.amber, size: 28)),
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
