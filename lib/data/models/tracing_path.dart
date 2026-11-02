import 'package:flutter/material.dart';

class TraceStroke {
  const TraceStroke({
    required this.type,
    this.d,
    this.center,
    this.radius = 8,
    this.tolerance = 9,
  });

  final String type;
  final String? d;
  final List<double>? center;
  final double radius;
  final double tolerance;

  factory TraceStroke.fromJson(Map<String, dynamic> j) => TraceStroke(
        type: j['type'] as String,
        d: j['d'] as String?,
        center: (j['center'] as List?)?.map((e) => (e as num).toDouble()).toList(),
        radius: (j['radius'] as num?)?.toDouble() ?? 8,
        tolerance: (j['tolerance'] as num?)?.toDouble() ?? 9,
      );
}

class TracingPath {
  const TracingPath({required this.id, required this.size, required this.strokes});
  final String id;
  final double size;
  final List<TraceStroke> strokes;

  factory TracingPath.fromJson(Map<String, dynamic> j) {
    final list = (j['strokes'] as List).cast<Map<String, dynamic>>()
      ..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    return TracingPath(
      id: j['id'] as String,
      size: ((j['viewBox'] as List)[2] as num).toDouble(),
      strokes: list.map(TraceStroke.fromJson).toList(),
    );
  }
}
