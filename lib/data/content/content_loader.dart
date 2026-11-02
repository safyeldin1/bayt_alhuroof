import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/letter.dart';
import '../models/word.dart';
import '../models/tracing_path.dart';

class ContentLoader {
  Future<List<Letter>> loadLetters() async {
    final raw = await rootBundle.loadString('assets/content/letters.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(Letter.fromJson)
        .where((l) => l.status == 'published')
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<TracingPath> loadTracing(String id) async {
    final raw = await rootBundle.loadString('assets/content/tracing/letters/$id.json');
    return TracingPath.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<List<Word>> loadWords() async {
    final raw = await rootBundle.loadString('assets/content/words.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['items'] as List).cast<Map<String, dynamic>>().map(Word.fromJson).toList();
  }
}

// إضافة في نهاية كلاس ContentLoader (سنقوم بتعديله برمجياً)
