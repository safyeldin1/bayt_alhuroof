import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
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
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الأشكال', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade400),
                        onPressed: () => context.push('/shapes/game'),
                        icon: const Icon(Icons.videogame_asset, color: Colors.white),
                        label: const Text('لعبة الأشكال', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
                        onPressed: () => context.push('/shapes/shadow_game'),
                        icon: const Icon(Icons.extension, color: Colors.white),
                        label: const Text('طابق الظل', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: shapes.length,
                    itemBuilder: (context, i) {
                      final s = shapes[i];
                      return BounceIn(
                        child: GestureDetector(
                          onTap: () => ref.read(audioServiceProvider).playVoice('shapes/${s.id}', force: true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                              border: Border.all(color: Colors.blue.shade200, width: 4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 80, height: 80, child: CustomPaint(painter: ShapePainter(s.type, Colors.blue.shade400))),
                                const SizedBox(height: 8),
                                Text(s.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
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

class ShapePainter extends CustomPainter {
  ShapePainter(this.type, this.color);
  final ShapeType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
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
