import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/letter.dart';
import '../models/word.dart';
import '../models/tracing_path.dart';
import '../models/number_item.dart';

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

  Future<List<NumberItem>> loadNumbers() async {
    final raw = await rootBundle.loadString('assets/content/numbers.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(NumberItem.fromJson)
        .where((n) => n.status == 'published')
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
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
