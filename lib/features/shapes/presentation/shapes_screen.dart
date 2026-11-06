import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../data/models/shape_item.dart';
import '../../../providers/audio_providers.dart';

class ShapesScreen extends ConsumerWidget {
  const ShapesScreen({super.key});

  static const List<ShapeItem> shapes = [
    ShapeItem(id: 'circle', name: 'دَائِرَة', type: ShapeType.circle, emoji: '⭕'),
    ShapeItem(id: 'square', name: 'مُرَبَّع', type: ShapeType.square, emoji: '🟦'),
    ShapeItem(id: 'triangle', name: 'مُثَلَّث', type: ShapeType.triangle, emoji: '🔺'),
    ShapeItem(id: 'rectangle', name: 'مُسْتَطِيل', type: ShapeType.rectangle, emoji: '▬'),
    ShapeItem(id: 'diamond', name: 'مُعَيَّن', type: ShapeType.diamond, emoji: '🔷'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/shapes');
    });

    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(iconSize: 30, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/')),
                title: const Text('الأشكال', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                centerTitle: true,
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade400),
                          onPressed: () => context.push('/shapes/game'),
                          icon: const Icon(Icons.videogame_asset, color: Colors.white, size: 20),
                          label: const Text('لعبة الأشكال', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
                          onPressed: () => context.push('/shapes/shadow_game'),
                          icon: const Icon(Icons.extension, color: Colors.white, size: 20),
                          label: const Text('طابق الظل', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: shapes.length,
                  itemBuilder: (context, i) {
                    final s = shapes[i];
                    return GestureDetector(
                      onTap: () {
                        ref.read(audioServiceProvider).playVoice('shapes/${s.id}', force: true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('هَذَا هُوَ الشَّكْل ${s.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            backgroundColor: Colors.blue.shade700,
                            duration: const Duration(milliseconds: 1500),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 8))],
                          border: Border.all(color: Colors.blue.shade200, width: 4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // الرسمة هنا
                            SizedBox(
                              width: 80, height: 80,
                              child: CustomPaint(
                                size: const Size(80, 80), // إجبار الرسمة على حجم معين
                                painter: ShapePainter(s.type, Colors.blue.shade400),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(s.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter(this.type, this.color);
  final ShapeType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return; // حماية للرسمة
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    switch (type) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
        break;
      case ShapeType.rectangle:
        canvas.drawRect(Rect.fromLTWH(0, h / 4, w, h / 2), paint);
        break;
      case ShapeType.triangle:
        final path = Path()..moveTo(w / 2, 0)..lineTo(w, h)..lineTo(0, h)..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.diamond:
        final path = Path()..moveTo(w / 2, 0)..lineTo(w, h / 2)..lineTo(w / 2, h)..lineTo(0, h / 2)..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
