import 'dart:ui';
import 'package:flutter/material.dart';

class ColoringScreen extends StatefulWidget {
  final String title;
  final Widget? shapeWidget;
  const ColoringScreen({super.key, required this.title, this.shapeWidget});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  Color _selectedColor = Colors.red;
  final List<DrawnLine> _lines = [];
  DrawnLine? _currentLine;

  final List<Color> _palette = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.purple, Colors.pink, Colors.brown, Colors.black, Colors.white,
  ];

  void _clearCanvas() {
    setState(() {
      _lines.clear();
      _currentLine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'لوحة جديدة',
            onPressed: () {
              setState(() {
                _lines.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'مسح التلوين',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentLine = DrawnLine([details.localPosition], _selectedColor, 15.0);
                    _lines.add(_currentLine!);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentLine?.path.add(details.localPosition);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _currentLine = null;
                  });
                },
                child: Stack(
                  children: [
                    if (widget.shapeWidget != null) Positioned.fill(child: widget.shapeWidget!),
                    Positioned.fill(child: CustomPaint(painter: _DrawingPainter(_lines))),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 90,
            color: Colors.grey.shade200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _palette.length,
              itemBuilder: (context, i) {
                final color = _palette[i];
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 60, height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 5 : 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawnLine {
  DrawnLine(this.path, this.color, this.width);
  final List<Offset> path;
  final Color color;
  final double width;
}

class _DrawingPainter extends CustomPainter {
  _DrawingPainter(this.lines);
  final List<DrawnLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.width
        ..style = PaintingStyle.stroke;
      
      if (line.path.length < 2) {
        canvas.drawPoints(PointMode.points, line.path, paint);
      } else {
        final path = Path()..moveTo(line.path[0].dx, line.path[0].dy);
        for (var i = 1; i < line.path.length; i++) {
          path.lineTo(line.path[i].dx, line.path[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
