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
  String? _draggedShapeId;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final allShapes = ShapesScreen.shapes.toList()..shuffle();
    final selected = allShapes.take(3).toList();

    setState(() {
      _targetShapes = selected;
      _options = selected.toList()..shuffle();
      _matched = {for (var s in selected) s.id: false};
      _isFinished = false;
      _draggedShapeId = null;
    });
  }

  void _onDragAccepted(String shadowId, ShapeItem draggedShape) {
    if (shadowId == draggedShape.id) {
      setState(() {
        _matched[shadowId] = true;
      });
      ref.read(audioServiceProvider).playVoice('shapes/${draggedShape.id}', force: true);

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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/shapes')),
                title: const Text('طابق الأشكال', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              Expanded(
                child: _isFinished ? _buildResult() : _buildGameBoard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // النص الشمال: الأشكال المفرغة (الهدف)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('اسحب الشكل إلى ظله', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _targetShapes.map((shape) {
                    final isMatched = _matched[shape.id] ?? false;
                    return DragTarget<ShapeItem>(
                      onAcceptWithDetails: (details) => _onDragAccepted(shape.id, details.data),
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: isMatched ? Colors.green.shade100 : Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isMatched ? Colors.green : Colors.white, width: 3),
                          ),
                          child: Center(
                            child: isMatched 
                              ? const Icon(Icons.check_circle, color: Colors.green, size: 50)
                              : SizedBox(
                                  width: 50, height: 50,
                                  child: CustomPaint(painter: ShapePainter(shape.type, Colors.grey.shade400)),
                                ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // النص اليمين: الأشكال الملونة (اللي بتتسحب)
          Expanded(
            flex: 1,
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _options.map((shape) {
                  final isUsed = _matched[shape.id] == true;
                  if (isUsed) return const SizedBox(width: 80, height: 80);

                  return Draggable<ShapeItem>(
                    data: shape,
                    onDragStarted: () => setState(() => _draggedShapeId = shape.id),
                    onDragEnd: (_) => setState(() => _draggedShapeId = null),
                    onDraggableCanceled: (_, __) => setState(() => _draggedShapeId = null),
                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 80, height: 80,
                        child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
                      ),
                    ),
                    childWhenDragging: _draggedShapeId == shape.id ? const SizedBox(width: 80, height: 80) : null,
                    child: SizedBox(
                      width: 80, height: 80,
                      child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (_) => const Icon(Icons.star, size: 60, color: Colors.amber))),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 50, onPressed: _initGame, icon: const Icon(Icons.replay)),
              const SizedBox(width: 24),
              IconButton.filled(iconSize: 50, onPressed: () => context.go('/shapes'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
