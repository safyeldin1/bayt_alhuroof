import 'dart:math';
import 'package:drift/drift.dart';
import '../db/app_database.dart';

class ProgressRepository {
  ProgressRepository(this._db);
  final AppDatabase _db;

  Future<void> recordResult({
    required String activityId,
    required String contentId,
    required String kind,
    required int attempts,
    required int correct,
    required int stars,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. حفظ تفاصيل المحاولة
      await _db.into(_db.activityResults).insert(
            ActivityResultsCompanion.insert(
              activityId: activityId,
              contentId: contentId,
              finishedAt: now,
              attempts: attempts,
              correctCount: correct,
              stars: stars,
            ),
          );

      // 2. تحديث أفضل نتيجة للعنصر
      final existing = await (_db.select(_db.itemProgress)
            ..where((t) => t.contentId.equals(contentId)))
          .getSingleOrNull();
      
      final best = max(existing?.bestStars ?? 0, stars);
      
      await _db.into(_db.itemProgress).insertOnConflictUpdate(
            ItemProgressCompanion.insert(
              contentId: contentId,
              kind: kind,
              status: Value(best >= 3 ? 'mastered' : 'practiced'),
              bestStars: Value(best),
              lastSeenAt: Value(now),
            ),
          );
    });
  }

  Stream<Map<String, int>> watchStars() {
    return _db.select(_db.itemProgress).watch().map(
          (rows) => {for (final r in rows) r.contentId: r.bestStars},
        );
  }
}
