import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/settings/app_settings.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../providers/parent_providers.dart';
import '../../providers/progress_providers.dart';

class ParentScreen extends ConsumerWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final learned = stars.values.where((s) => s > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة وليّ الأمر'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(parentGateProvider.notifier).lock();
            context.go('/');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('مستوى الصوت', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Slider(
            value: settings.voiceVolume,
            onChanged: (v) => ctrl.setVolume(v),
          ),
          const SizedBox(height: 24),
          const Text('شكل الأرقام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<NumeralStyle>(
            segments: const [
              ButtonSegment(value: NumeralStyle.arabicIndic, label: Text('١٢٣')),
              ButtonSegment(value: NumeralStyle.western, label: Text('123')),
            ],
            selected: {settings.numeralStyle},
            onSelectionChanged: (s) => ctrl.setNumerals(s.first),
          ),
          const SizedBox(height: 32),
          Text('تقدم الطفل: $learned عنصر تم تعلمه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('مسح كل التقدم', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('مسح كل التقدم؟'),
                  content: const Text('هل أنت متأكد؟ سيتم حذف كل النجوم والنتائج نهائياً.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('مسح', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(progressRepositoryProvider).resetAll();
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح التقدم')));
              }
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'الخصوصية: لا يجمع التطبيق أي بيانات شخصية، ولا يتصل بالإنترنت إطلاقاً. يُحفظ التقدم على هذا الجهاز فقط.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
