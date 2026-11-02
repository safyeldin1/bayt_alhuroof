import 'dart:math' as math;
import 'dart:ui';
import 'package:path_drawing/path_drawing.dart';

class StrokeTracker {
  StrokeTracker(this.samples, {this.tolerance = 9});
  final List<Offset> samples;
  final double tolerance;
  int _next = 0;

  double get progress => samples.isEmpty ? 1 : _next / samples.length;
  bool get complete => progress >= 0.85;

  void update(Offset p) {
    if (samples.isEmpty) return;
    final end = math.min(_next + 5, samples.length - 1);
    for (var i = _next; i <= end; i++) {
      if ((samples[i] - p).distance <= tolerance) {
        _next = i + 1;
      }
    }
  }
}

// دالة مساعدة لأخذ 40 نقطة من مسار الـ SVG
List<Offset> sampleStroke(Path path, {int count = 40}) {
  final metrics = path.computeMetrics().toList();
  final samples = <Offset>[];
  for (final metric in metrics) {
    for (var i = 0; i < count; i++) {
      final tangent = metric.getTangentForOffset(metric.length * (i / (count - 1)));
      if (tangent != null) samples.add(tangent.position);
    }
  }
  return samples;
}
