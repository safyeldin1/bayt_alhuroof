import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class ItemProgress extends Table {
  TextColumn get contentId => text()();
  TextColumn get kind => text()();
  TextColumn get status => text().withDefault(const Constant('new'))();
  IntColumn get bestStars => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {contentId};
}

class ActivityResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get activityId => text()();
  TextColumn get contentId => text()();
  DateTimeColumn get finishedAt => dateTime()();
  IntColumn get attempts => integer()();
  IntColumn get correctCount => integer()();
  IntColumn get stars => integer()();
}

@DriftDatabase(tables: [ItemProgress, ActivityResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  AppDatabase.open() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {},
      );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      return NativeDatabase.createInBackground(File(p.join(dir.path, 'bayt.sqlite')));
    });
