import 'package:flutter/material.dart';
import '../../../data/models/color_item.dart';
import '../../../data/models/shape_item.dart';
import '../../colors/presentation/colors_screen.dart';
import '../../shapes/presentation/shapes_screen.dart';
import '../domain/engines/choice_engine.dart';
import 'choice_game_screen.dart';

class ColorGame extends StatelessWidget {
  const ColorGame({super.key});

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<ColorItem>(
        activityId: 'color_game',
        contentId: 'colors',
        kind: 'color',
        backRoute: '/colors',
        idOf: (c) => c.id,
        setup: (ref) async {
          final targets = ColorsScreen.colors.toList()..shuffle();
          return ChoiceGameSetup(
            instructionText: 'اختر اللون الصحيح',
            questions: ChoiceEngine<ColorItem>((c) => c.id).build(
              targets: targets,
              pool: ColorsScreen.colors,
              promptAudioFor: (c) => 'colors/${c.id}',
            ),
          );
        },
        optionBuilder: (ctx, ref, c) => Container(
          decoration: BoxDecoration(color: c.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
          child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 40))),
        ),
      );
}

class ShapeGame extends StatelessWidget {
  const ShapeGame({super.key});

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<ShapeItem>(
        activityId: 'shape_game',
        contentId: 'shapes',
        kind: 'shape',
        backRoute: '/shapes',
        idOf: (s) => s.id,
        setup: (ref) async {
          final targets = ShapesScreen.shapes.toList()..shuffle();
          return ChoiceGameSetup(
            instructionText: 'اختر الشكل الصحيح',
            questions: ChoiceEngine<ShapeItem>((s) => s.id).build(
              targets: targets,
              pool: ShapesScreen.shapes,
              promptAudioFor: (s) => 'shapes/${s.id}',
            ),
          );
        },
        optionBuilder: (ctx, ref, s) => SizedBox(
          width: 80, height: 80,
          child: CustomPaint(painter: ShapePainter(s.type, Colors.blue.shade400)),
        ),
      );
}
