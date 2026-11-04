import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../providers/audio_providers.dart';
import 'coloring_screen.dart';
import 'coloring_shapes.dart';

class ColoringGallery extends ConsumerWidget {
  const ColoringGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/coloring');
    });

    final templates = ColoringShapes.all();

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('التلوين', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 500 ? 3 : 2);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: templates.length + 1,
                    itemBuilder: (context, i) {
                      if (i == templates.length) {
                        return KidsButton(
                          color: Colors.white,
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ColoringScreen(title: 'رسم حر', shapeWidget: null),
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.brush, size: 80, color: Colors.purple),
                              SizedBox(height: 12),
                              Text('رسم حر', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
                            ],
                          ),
                        );
                      }
                      final template = templates[i];
                      return KidsButton(
                        color: Colors.white,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ColoringScreen(title: template.name, shapeWidget: template.painter()),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(template.icon, size: 80, color: template.themeColor),
                            const SizedBox(height: 12),
                            Text(template.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: template.themeColor)),
                          ],
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
