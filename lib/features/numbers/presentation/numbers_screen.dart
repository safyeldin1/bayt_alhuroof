import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/animations/bounce_in.dart';

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  String _formatNumber(int n) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

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
              title: const Text('الأرقام', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) => GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: r.numbers.length,
                  itemBuilder: (context, i) {
                    final n = r.numbers[i];
                    final earnedStars = stars[n.id] ?? 0;
                    return Stack(
                      children: [
                        BounceIn(
                          child: KidsButton(
                            color: const Color(0xFF29B6F6), // أزرق مبهج
                            height: 100,
                            onTap: () => context.push('/numbers/${n.id}'),
                            child: Text(_formatNumber(n.value), style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        if (earnedStars > 0)
                          const PositionedDirectional(top: 4, end: 4, child: Icon(Icons.star, color: Colors.amber, size: 32)),
                      ],
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
