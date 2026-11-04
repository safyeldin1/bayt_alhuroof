import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';
import '../../../data/models/shape_item.dart';
import '../../shapes/presentation/shapes_screen.dart';

class ShapeShadowGame extends ConsumerStatefulWidget {
  const ShapeShadowGame({super.key});

  @override
  ConsumerState<ShapeShadowGame> createState() => _ShapeShadowGameState();
}

class _ShapeShadowGameState extends ConsumerState<ShapeShadowGame> {
  List<ShapeItem> _targetShapes = [];
  List<ShapeItem> _options = [];
  Map<String, bool> _matched = {};
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // نختار 3 أشكال عشوائية
    final allShapes = ShapesScreen.shapes.toList()..shuffle();
    final selected = allShapes.take(3).toList();

    setState(() {
      _targetShapes = selected;
      _options = selected.toList()..shuffle();
      _matched = {for (var s in selected) s.id: false};
      _isFinished = false;
    });
  }

  void _onDragAccepted(String shadowId, ShapeItem draggedShape) {
    if (shadowId == draggedShape.id) {
      setState(() {
        _matched[shadowId] = true;
      });
      ref.read(audioServiceProvider).playVoice('shapes/${draggedShape.id}', force: true);

      // التحقق من الفوز
      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'shape_shadow_game',
          contentId: 'shapes',
          kind: 'shape',
          attempts: 3,
          correct: 3,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/shapes')),
              title: const Text('طابق الأشكال', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('اسحب الشكل الملون وضعه على ظله', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        // الأشكال المفرغة (الأهداف)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _targetShapes.map((shape) {
            final isMatched = _matched[shape.id] ?? false;
            return DragTarget<ShapeItem>(
              onAcceptWithDetails: (details) => _onDragAccepted(shape.id, details.data),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: isMatched ? Colors.green.shade100 : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isMatched ? Colors.green : Colors.white, width: 3),
                  ),
                  child: Center(
                    child: isMatched 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 60)
                      : SizedBox(
                          width: 70, height: 70,
                          child: CustomPaint(painter: ShapePainter(shape.type, Colors.grey.shade400)), // ظل رمادي
                        ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        
        // الأشكال الملونة (اللي بتتسحب)
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((shape) {
            final isUsed = _matched[shape.id] == true;
            if (isUsed) return const SizedBox(width: 80, height: 80);

            return Draggable<ShapeItem>(
              data: shape,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: 80, height: 80,
                  child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
                ),
              ),
              childWhenDragging: const SizedBox(width: 80, height: 80),
              child: SizedBox(
                width: 80, height: 80,
                child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber)),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: _initGame, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/shapes'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
