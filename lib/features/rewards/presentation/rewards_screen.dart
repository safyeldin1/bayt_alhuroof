import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final totalStars = stars.values.fold<int>(0, (sum, s) => sum + s);

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('المكافآت', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: BounceIn(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
                        const SizedBox(height: 24),
                        Text('إجمالي النجوم: $totalStars', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                        const SizedBox(height: 16),
                        const Text('استمر في اللعب لتجمع المزيد!', style: TextStyle(fontSize: 20, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
