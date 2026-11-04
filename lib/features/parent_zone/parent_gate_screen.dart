import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/settings/app_settings.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../core/widgets/kids_background.dart';
import '../../providers/parent_providers.dart';
import 'parent_gate_challenge.dart';

class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});
  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  late ParentGateChallenge _challenge = ParentGateChallenge.generate();

  void _pick(int v) {
    if (_challenge.check(v)) {
      ref.read(parentGateProvider.notifier).unlock();
      context.go('/parent');
    } else {
      setState(() => _challenge = ParentGateChallenge.generate());
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.watch(settingsProvider).numeralStyle;
    String f(int n) => formatNumber(n, style);

    return Scaffold(
      body: KidsBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text('منطقة وليّ الأمر', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('للكبار فقط: أجب على السؤال', style: TextStyle(fontSize: 20, color: Colors.white70)),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Text('${f(_challenge.a)} × ${f(_challenge.b)} = ؟', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final o in _challenge.options)
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FilledButton(
                                onPressed: () => _pick(o),
                                child: Text(f(o), style: const TextStyle(fontSize: 28)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('رجوع', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
