import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import '../../../data/models/tracing_path.dart';
import '../domain/stroke_tracker.dart';

class TracingCanvas extends StatefulWidget {
  const TracingCanvas({super.key, required this.trace, required this.onComplete});
  final TracingPath trace;
  final VoidCallback onComplete;

  @override
  State<TracingCanvas> createState() => _TracingCanvasState();
}

class _TracingCanvasState extends State<TracingCanvas> {
  late final List<Path> _paths;
  late final List<StrokeTracker?> _trackers;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _paths = [];
    _trackers = [];
    for (final s in widget.trace.strokes) {
      if (s.type == 'path' && s.d != null) {
        final p = parseSvgPathData(s.d!);
        _paths.add(p);
        _trackers.add(StrokeTracker(sampleStroke(p), tolerance: s.tolerance));
      } else {
        _paths.add(Path());
        _trackers.add(null);
      }
    }
  }

  void _onPoint(Offset local, double scale) {
    if (_current >= widget.trace.strokes.length) return;
    final p = local / scale;
    final s = widget.trace.strokes[_current];
    var advance = false;

    if (s.type == 'dot') {
      final c = Offset(s.center![0], s.center![1]);
      advance = (p - c).distance <= s.radius + s.tolerance;
    } else {
      final t = _trackers[_current];
      t?.update(p);
      advance = t?.complete ?? false;
    }

    setState(() {
      if (advance) _current++;
    });

    if (advance && _current >= widget.trace.strokes.length) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(builder: (context, c) {
        final scale = c.maxWidth / widget.trace.size;
        return Listener(
          onPointerDown: (e) => _onPoint(e.localPosition, scale),
          onPointerMove: (e) => _onPoint(e.localPosition, scale),
          child: CustomPaint(
            size: Size.square(c.maxWidth),
            painter: _TracePainter(widget.trace, _paths, _trackers, _current),
          ),
        );
      }),
    );
  }
}

class _TracePainter extends CustomPainter {
  _TracePainter(this.trace, this.paths, this.trackers, this.current);
  final TracingPath trace;
  final List<Path> paths;
  final List<StrokeTracker?> trackers;
  final int current;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / trace.size;
    canvas.scale(scale);

    // رسم المسارات الخافتة
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < paths.length; i++) {
      if (trace.strokes[i].type == 'path') {
        canvas.drawPath(paths[i], guidePaint);
        // هنا ممكن نرسم جزء من المسار حسب التقدم لو حبينا نعقدها
      } else {
        // رسم النقطة
        final center = Offset(trace.strokes[i].center![0], trace.strokes[i].center![1]);
        canvas.drawCircle(center, trace.strokes[i].radius, Paint()..color = Colors.grey.shade300);
        if (i < current) {
          canvas.drawCircle(center, trace.strokes[i].radius, Paint()..color = Colors.green);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter old) => true;
}
