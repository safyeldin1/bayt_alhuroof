import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';

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
                        
                        // شرط القفل: أول حرف مفتوح، والباقي بيتفتح لو الحرف اللي قبله متعلم (3 نجوم)
                        bool isUnlocked = i == 0;
                        if (i > 0) {
                          final prevLetter = r.letters[i - 1];
                          final prevStars = stars[prevLetter.id] ?? 0;
                          if (prevStars >= 1) { // ممكن نغير الرقم لـ 3 لو عايزه أصعب
                            isUnlocked = true;
                          }
                        }
                        
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: KidsButton(
                                color: isUnlocked ? Colors.white : Colors.grey.shade300,
                                onTap: isUnlocked ? () => context.push('/letters/${l.id}') : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('أكمل الحرف السابق أولاً!'), duration: Duration(seconds: 1)),
                                  );
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      l.character, 
                                      style: TextStyle(
                                        fontSize: 60, 
                                        fontWeight: FontWeight.bold, 
                                        color: isUnlocked ? const Color(0xFF00796B) : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (!isUnlocked)
                              const Positioned.fill(
                                child: Center(child: Icon(Icons.lock, size: 40, color: Colors.grey)),
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
