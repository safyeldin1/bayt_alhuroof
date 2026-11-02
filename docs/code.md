# 💻 كود المشروع الكامل
> آخر تحديث: 2026-11-03 00:08:30
```yaml
name: bayt_alhuroof
description: "A new Flutter project."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.10.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.7
  just_audio: ^0.9.40
  audio_session: ^0.1.21
  drift: ^2.20.3
  sqlite3_flutter_libs: ^0.5.24
  shared_preferences: ^2.3.2
  path_drawing: ^1.0.1
  path_provider: ^2.1.4
  intl: ^0.20.3
  path: ^1.9.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  drift_dev: ^2.20.3
  build_runner: ^2.4.12
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
  assets:
    - assets/content/
    - assets/content/scenes/
    - assets/content/tracing/letters/
    - assets/content/tracing/numbers/
    - assets/images/letters/
    - assets/images/words/
    - assets/images/numbers/
    - assets/images/ui/
    - assets/audio/letters/
    - assets/audio/words/
    - assets/audio/numbers/
    - assets/audio/instructions/
    - assets/audio/feedback/
    - assets/audio/sfx/
```
## 📄 `lib/app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class BaytApp extends ConsumerWidget {
  const BaytApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'بيت الحروف',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
```
## 📄 `lib/core/audio/audio_service.dart`
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _voice = AudioPlayer();
  double voiceVolume = 1.0;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);
  int _token = 0;

  static const _debounce = Duration(milliseconds: 250);

  Future<void> playVoice(String ref, {bool force = false}) async {
    final now = DateTime.now();
    if (!force && now.difference(_lastTap) < _debounce) return;
    _lastTap = now;
    final myToken = ++_token;
    await _playOne(ref, myToken);
  }

  Future<void> playSequence(List<String> refs) async {
    final myToken = ++_token;
    for (final ref in refs) {
      if (myToken != _token) return;
      await _playOne(ref, myToken);
    }
  }

  Future<void> _playOne(String ref, int token) async {
    try {
      await _voice.stop();
      if (token != _token) return;
      await _voice.setAsset('assets/audio/$ref.m4a');
      await _voice.setVolume(voiceVolume);
      await _voice.play();
    } on MissingPluginException {
      debugPrint('⚠️ الصوت غير مدعوم على هذه المنصة (لينكس)، وسيعمل على أندرويد');
    } catch (e) {
      debugPrint('audio error ($ref): $e');
    }
  }

  Future<void> stop() async {
    _token++;
    try {
      await _voice.stop();
    } on MissingPluginException {
      // تجاهل على لينكس
    } catch (e) {
      debugPrint('audio stop error: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _voice.dispose();
    } catch (_) {}
  }
}
```
## 📄 `lib/core/router/app_router.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/letters/presentation/letter_lesson_screen.dart';
import '../../features/games/presentation/choice_games.dart';
import '../../features/tracing/presentation/tracing_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(
        path: '/letters/:id',
        builder: (c, s) => LetterLessonScreen(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/letters/:id/recognize',
        builder: (c, s) => RecognizeLetterGame(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/letters/:id/trace',
        builder: (c, s) => TracingScreen(letterId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/numbers',
        builder: (c, s) => Scaffold(
          appBar: AppBar(title: const Text('الأرقام')),
          body: const Center(child: Text('قريباً')),
        ),
      ),
    ],
  );
});
```
## 📄 `lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        fontFamily: 'Cairo',
      );
}
```
## 📄 `lib/data/content/content_loader.dart`
```dart
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
```
## 📄 `lib/data/content/content_repository.dart`
```dart
import '../models/letter.dart';
import '../models/word.dart';
import 'content_loader.dart';

class ContentRepository {
  ContentRepository(this._loader);
  final ContentLoader _loader;

  List<Letter> letters = [];
  List<Word> words = [];

  Future<void> load() async {
    letters = await _loader.loadLetters();
    words = await _loader.loadWords();
  }

  Letter? letterById(String id) {
    for (final l in letters) { if (l.id == id) return l; }
    return null;
  }

  Word? wordById(String id) {
    for (final w in words) { if (w.id == id) return w; }
    return null;
  }

  Letter? nextOf(Letter l) {
    final i = letters.indexWhere((x) => x.id == l.id);
    return (i >= 0 && i < letters.length - 1) ? letters[i + 1] : null;
  }

  Letter? previousOf(Letter l) {
    final i = letters.indexWhere((x) => x.id == l.id);
    return i > 0 ? letters[i - 1] : null;
  }
}
```
## 📄 `lib/data/db/app_database.dart`
```dart
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
```
## 📄 `lib/data/db/app_database.g.dart`
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ItemProgressTable extends ItemProgress
    with TableInfo<$ItemProgressTable, ItemProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _bestStarsMeta = const VerificationMeta(
    'bestStars',
  );
  @override
  late final GeneratedColumn<int> bestStars = GeneratedColumn<int>(
    'best_stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    kind,
    status,
    bestStars,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('best_stars')) {
      context.handle(
        _bestStarsMeta,
        bestStars.isAcceptableOrUnknown(data['best_stars']!, _bestStarsMeta),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  ItemProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemProgressData(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bestStars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_stars'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      ),
    );
  }

  @override
  $ItemProgressTable createAlias(String alias) {
    return $ItemProgressTable(attachedDatabase, alias);
  }
}

class ItemProgressData extends DataClass
    implements Insertable<ItemProgressData> {
  final String contentId;
  final String kind;
  final String status;
  final int bestStars;
  final DateTime? lastSeenAt;
  const ItemProgressData({
    required this.contentId,
    required this.kind,
    required this.status,
    required this.bestStars,
    this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['kind'] = Variable<String>(kind);
    map['status'] = Variable<String>(status);
    map['best_stars'] = Variable<int>(bestStars);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    return map;
  }

  ItemProgressCompanion toCompanion(bool nullToAbsent) {
    return ItemProgressCompanion(
      contentId: Value(contentId),
      kind: Value(kind),
      status: Value(status),
      bestStars: Value(bestStars),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
    );
  }

  factory ItemProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemProgressData(
      contentId: serializer.fromJson<String>(json['contentId']),
      kind: serializer.fromJson<String>(json['kind']),
      status: serializer.fromJson<String>(json['status']),
      bestStars: serializer.fromJson<int>(json['bestStars']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(status),
      'bestStars': serializer.toJson<int>(bestStars),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
    };
  }

  ItemProgressData copyWith({
    String? contentId,
    String? kind,
    String? status,
    int? bestStars,
    Value<DateTime?> lastSeenAt = const Value.absent(),
  }) => ItemProgressData(
    contentId: contentId ?? this.contentId,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    bestStars: bestStars ?? this.bestStars,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
  );
  ItemProgressData copyWithCompanion(ItemProgressCompanion data) {
    return ItemProgressData(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      bestStars: data.bestStars.present ? data.bestStars.value : this.bestStars,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemProgressData(')
          ..write('contentId: $contentId, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('bestStars: $bestStars, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(contentId, kind, status, bestStars, lastSeenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemProgressData &&
          other.contentId == this.contentId &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.bestStars == this.bestStars &&
          other.lastSeenAt == this.lastSeenAt);
}

class ItemProgressCompanion extends UpdateCompanion<ItemProgressData> {
  final Value<String> contentId;
  final Value<String> kind;
  final Value<String> status;
  final Value<int> bestStars;
  final Value<DateTime?> lastSeenAt;
  final Value<int> rowid;
  const ItemProgressCompanion({
    this.contentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemProgressCompanion.insert({
    required String contentId,
    required String kind,
    this.status = const Value.absent(),
    this.bestStars = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       kind = Value(kind);
  static Insertable<ItemProgressData> custom({
    Expression<String>? contentId,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<int>? bestStars,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (bestStars != null) 'best_stars': bestStars,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemProgressCompanion copyWith({
    Value<String>? contentId,
    Value<String>? kind,
    Value<String>? status,
    Value<int>? bestStars,
    Value<DateTime?>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return ItemProgressCompanion(
      contentId: contentId ?? this.contentId,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      bestStars: bestStars ?? this.bestStars,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bestStars.present) {
      map['best_stars'] = Variable<int>(bestStars.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemProgressCompanion(')
          ..write('contentId: $contentId, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('bestStars: $bestStars, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityResultsTable extends ActivityResults
    with TableInfo<$ActivityResultsTable, ActivityResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    contentId,
    finishedAt,
    attempts,
    correctCount,
    stars,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptsMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctCountMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
    );
  }

  @override
  $ActivityResultsTable createAlias(String alias) {
    return $ActivityResultsTable(attachedDatabase, alias);
  }
}

class ActivityResult extends DataClass implements Insertable<ActivityResult> {
  final int id;
  final String activityId;
  final String contentId;
  final DateTime finishedAt;
  final int attempts;
  final int correctCount;
  final int stars;
  const ActivityResult({
    required this.id,
    required this.activityId,
    required this.contentId,
    required this.finishedAt,
    required this.attempts,
    required this.correctCount,
    required this.stars,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['content_id'] = Variable<String>(contentId);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    map['attempts'] = Variable<int>(attempts);
    map['correct_count'] = Variable<int>(correctCount);
    map['stars'] = Variable<int>(stars);
    return map;
  }

  ActivityResultsCompanion toCompanion(bool nullToAbsent) {
    return ActivityResultsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      contentId: Value(contentId),
      finishedAt: Value(finishedAt),
      attempts: Value(attempts),
      correctCount: Value(correctCount),
      stars: Value(stars),
    );
  }

  factory ActivityResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityResult(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<String>(json['activityId']),
      contentId: serializer.fromJson<String>(json['contentId']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      stars: serializer.fromJson<int>(json['stars']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<String>(activityId),
      'contentId': serializer.toJson<String>(contentId),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'attempts': serializer.toJson<int>(attempts),
      'correctCount': serializer.toJson<int>(correctCount),
      'stars': serializer.toJson<int>(stars),
    };
  }

  ActivityResult copyWith({
    int? id,
    String? activityId,
    String? contentId,
    DateTime? finishedAt,
    int? attempts,
    int? correctCount,
    int? stars,
  }) => ActivityResult(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    contentId: contentId ?? this.contentId,
    finishedAt: finishedAt ?? this.finishedAt,
    attempts: attempts ?? this.attempts,
    correctCount: correctCount ?? this.correctCount,
    stars: stars ?? this.stars,
  );
  ActivityResult copyWithCompanion(ActivityResultsCompanion data) {
    return ActivityResult(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      stars: data.stars.present ? data.stars.value : this.stars,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityResult(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('contentId: $contentId, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('attempts: $attempts, ')
          ..write('correctCount: $correctCount, ')
          ..write('stars: $stars')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    contentId,
    finishedAt,
    attempts,
    correctCount,
    stars,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityResult &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.contentId == this.contentId &&
          other.finishedAt == this.finishedAt &&
          other.attempts == this.attempts &&
          other.correctCount == this.correctCount &&
          other.stars == this.stars);
}

class ActivityResultsCompanion extends UpdateCompanion<ActivityResult> {
  final Value<int> id;
  final Value<String> activityId;
  final Value<String> contentId;
  final Value<DateTime> finishedAt;
  final Value<int> attempts;
  final Value<int> correctCount;
  final Value<int> stars;
  const ActivityResultsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.contentId = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.stars = const Value.absent(),
  });
  ActivityResultsCompanion.insert({
    this.id = const Value.absent(),
    required String activityId,
    required String contentId,
    required DateTime finishedAt,
    required int attempts,
    required int correctCount,
    required int stars,
  }) : activityId = Value(activityId),
       contentId = Value(contentId),
       finishedAt = Value(finishedAt),
       attempts = Value(attempts),
       correctCount = Value(correctCount),
       stars = Value(stars);
  static Insertable<ActivityResult> custom({
    Expression<int>? id,
    Expression<String>? activityId,
    Expression<String>? contentId,
    Expression<DateTime>? finishedAt,
    Expression<int>? attempts,
    Expression<int>? correctCount,
    Expression<int>? stars,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (contentId != null) 'content_id': contentId,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (attempts != null) 'attempts': attempts,
      if (correctCount != null) 'correct_count': correctCount,
      if (stars != null) 'stars': stars,
    });
  }

  ActivityResultsCompanion copyWith({
    Value<int>? id,
    Value<String>? activityId,
    Value<String>? contentId,
    Value<DateTime>? finishedAt,
    Value<int>? attempts,
    Value<int>? correctCount,
    Value<int>? stars,
  }) {
    return ActivityResultsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      contentId: contentId ?? this.contentId,
      finishedAt: finishedAt ?? this.finishedAt,
      attempts: attempts ?? this.attempts,
      correctCount: correctCount ?? this.correctCount,
      stars: stars ?? this.stars,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityResultsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('contentId: $contentId, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('attempts: $attempts, ')
          ..write('correctCount: $correctCount, ')
          ..write('stars: $stars')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemProgressTable itemProgress = $ItemProgressTable(this);
  late final $ActivityResultsTable activityResults = $ActivityResultsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    itemProgress,
    activityResults,
  ];
}

typedef $$ItemProgressTableCreateCompanionBuilder =
    ItemProgressCompanion Function({
      required String contentId,
      required String kind,
      Value<String> status,
      Value<int> bestStars,
      Value<DateTime?> lastSeenAt,
      Value<int> rowid,
    });
typedef $$ItemProgressTableUpdateCompanionBuilder =
    ItemProgressCompanion Function({
      Value<String> contentId,
      Value<String> kind,
      Value<String> status,
      Value<int> bestStars,
      Value<DateTime?> lastSeenAt,
      Value<int> rowid,
    });

class $$ItemProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ItemProgressTable> {
  $$ItemProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemProgressTable> {
  $$ItemProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStars => $composableBuilder(
    column: $table.bestStars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemProgressTable> {
  $$ItemProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get bestStars =>
      $composableBuilder(column: $table.bestStars, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );
}

class $$ItemProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemProgressTable,
          ItemProgressData,
          $$ItemProgressTableFilterComposer,
          $$ItemProgressTableOrderingComposer,
          $$ItemProgressTableAnnotationComposer,
          $$ItemProgressTableCreateCompanionBuilder,
          $$ItemProgressTableUpdateCompanionBuilder,
          (
            ItemProgressData,
            BaseReferences<_$AppDatabase, $ItemProgressTable, ItemProgressData>,
          ),
          ItemProgressData,
          PrefetchHooks Function()
        > {
  $$ItemProgressTableTableManager(_$AppDatabase db, $ItemProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> bestStars = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemProgressCompanion(
                contentId: contentId,
                kind: kind,
                status: status,
                bestStars: bestStars,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String kind,
                Value<String> status = const Value.absent(),
                Value<int> bestStars = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemProgressCompanion.insert(
                contentId: contentId,
                kind: kind,
                status: status,
                bestStars: bestStars,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemProgressTable, ItemProgressData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ItemProgressTable,
                    ItemProgressData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemProgressTable,
      ItemProgressData,
      $$ItemProgressTableFilterComposer,
      $$ItemProgressTableOrderingComposer,
      $$ItemProgressTableAnnotationComposer,
      $$ItemProgressTableCreateCompanionBuilder,
      $$ItemProgressTableUpdateCompanionBuilder,
      (
        ItemProgressData,
        BaseReferences<_$AppDatabase, $ItemProgressTable, ItemProgressData>,
      ),
      ItemProgressData,
      PrefetchHooks Function()
    >;
typedef $$ActivityResultsTableCreateCompanionBuilder =
    ActivityResultsCompanion Function({
      Value<int> id,
      required String activityId,
      required String contentId,
      required DateTime finishedAt,
      required int attempts,
      required int correctCount,
      required int stars,
    });
typedef $$ActivityResultsTableUpdateCompanionBuilder =
    ActivityResultsCompanion Function({
      Value<int> id,
      Value<String> activityId,
      Value<String> contentId,
      Value<DateTime> finishedAt,
      Value<int> attempts,
      Value<int> correctCount,
      Value<int> stars,
    });

class $$ActivityResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityResultsTable> {
  $$ActivityResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityResultsTable> {
  $$ActivityResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityResultsTable> {
  $$ActivityResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);
}

class $$ActivityResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityResultsTable,
          ActivityResult,
          $$ActivityResultsTableFilterComposer,
          $$ActivityResultsTableOrderingComposer,
          $$ActivityResultsTableAnnotationComposer,
          $$ActivityResultsTableCreateCompanionBuilder,
          $$ActivityResultsTableUpdateCompanionBuilder,
          (
            ActivityResult,
            BaseReferences<
              _$AppDatabase,
              $ActivityResultsTable,
              ActivityResult
            >,
          ),
          ActivityResult,
          PrefetchHooks Function()
        > {
  $$ActivityResultsTableTableManager(
    _$AppDatabase db,
    $ActivityResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> stars = const Value.absent(),
              }) => ActivityResultsCompanion(
                id: id,
                activityId: activityId,
                contentId: contentId,
                finishedAt: finishedAt,
                attempts: attempts,
                correctCount: correctCount,
                stars: stars,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String activityId,
                required String contentId,
                required DateTime finishedAt,
                required int attempts,
                required int correctCount,
                required int stars,
              }) => ActivityResultsCompanion.insert(
                id: id,
                activityId: activityId,
                contentId: contentId,
                finishedAt: finishedAt,
                attempts: attempts,
                correctCount: correctCount,
                stars: stars,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityResultsTable, ActivityResult>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityResultsTable,
                    ActivityResult
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityResultsTable,
      ActivityResult,
      $$ActivityResultsTableFilterComposer,
      $$ActivityResultsTableOrderingComposer,
      $$ActivityResultsTableAnnotationComposer,
      $$ActivityResultsTableCreateCompanionBuilder,
      $$ActivityResultsTableUpdateCompanionBuilder,
      (
        ActivityResult,
        BaseReferences<_$AppDatabase, $ActivityResultsTable, ActivityResult>,
      ),
      ActivityResult,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemProgressTableTableManager get itemProgress =>
      $$ItemProgressTableTableManager(_db, _db.itemProgress);
  $$ActivityResultsTableTableManager get activityResults =>
      $$ActivityResultsTableTableManager(_db, _db.activityResults);
}
```
## 📄 `lib/data/models/letter.dart`
```dart
class Letter {
  const Letter({
    required this.id, required this.order, required this.character,
    required this.name, required this.forms, required this.nameAudio,
    required this.soundAudio, required this.primaryWordId,
    required this.tracingId, required this.status,
  });

  final String id;
  final int order;
  final String character;
  final String name;
  final Map<String, String> forms;
  final String nameAudio;
  final String soundAudio;
  final String primaryWordId;
  final String tracingId;
  final String status;

  factory Letter.fromJson(Map<String, dynamic> j) => Letter(
        id: j['id'] as String,
        order: j['order'] as int,
        character: j['character'] as String,
        name: j['name'] as String,
        forms: Map<String, String>.from(j['forms'] as Map),
        nameAudio: j['audio']['name'] as String,
        soundAudio: j['audio']['sound'] as String,
        primaryWordId: j['primaryWordId'] as String,
        tracingId: j['tracingId'] as String,
        status: j['status'] as String,
      );
}
```
## 📄 `lib/data/models/tracing_path.dart`
```dart
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
```
## 📄 `lib/data/models/word.dart`
```dart
class Word {
  const Word({
    required this.id, required this.text, required this.textVowelled,
    required this.startsWithLetterId, required this.image, required this.audio,
  });

  final String id;
  final String text;
  final String textVowelled;
  final String startsWithLetterId;
  final String image;
  final String audio;

  factory Word.fromJson(Map<String, dynamic> j) => Word(
        id: j['id'] as String,
        text: j['text'] as String,
        textVowelled: j['textVowelled'] as String,
        startsWithLetterId: j['startsWithLetterId'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String,
      );
}
```
## 📄 `lib/data/progress/progress_repository.dart`
```dart
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
```
## 📄 `lib/features/games/domain/engines/choice_engine.dart`
```dart
import 'dart:math';
import '../evaluation.dart';

class ChoiceQuestion<T> {
  const ChoiceQuestion(this.target, this.options, {this.promptAudio});
  final T target;
  final List<T> options;
  final String? promptAudio;
}

class ChoiceEngine<T> {
  ChoiceEngine(this.idOf);
  final String Function(T) idOf;

  List<ChoiceQuestion<T>> build({
    required List<T> targets,
    required List<T> pool,
    int rounds = 3,
    int choices = 3,
    String? Function(T target)? promptAudioFor,
    Random? rng,
  }) {
    final r = rng ?? Random();
    return List.generate(rounds, (i) {
      final target = targets[i % targets.length];
      final others = pool.where((x) => idOf(x) != idOf(target)).toList()..shuffle(r);
      final options = [target, ...others.take(choices - 1)]..shuffle(r);
      return ChoiceQuestion<T>(target, options, promptAudio: promptAudioFor?.call(target));
    });
  }

  Evaluation evaluate(ChoiceQuestion<T> q, T answer, int wrongSoFar) {
    if (idOf(answer) == idOf(q.target)) return Evaluation.correct;
    return wrongSoFar + 1 >= 2 ? Evaluation.reveal : Evaluation.retry;
  }
}

class ChoiceSession<T> {
  ChoiceSession(this.questions, this.engine);
  final List<ChoiceQuestion<T>> questions;
  final ChoiceEngine<T> engine;
  int index = 0;
  int wrongOnCurrent = 0;
  int totalWrong = 0;

  bool get finished => index >= questions.length;
  ChoiceQuestion<T> get current => questions[index];
  int get stars => totalWrong == 0 ? 3 : (totalWrong <= 2 ? 2 : 1);

  Evaluation answer(T choice) {
    final result = engine.evaluate(current, choice, wrongOnCurrent);
    if (result != Evaluation.correct) {
      wrongOnCurrent++;
      totalWrong++;
    }
    return result;
  }

  void next() {
    index++;
    wrongOnCurrent = 0;
  }
}
```
## 📄 `lib/features/games/domain/evaluation.dart`
```dart
enum Evaluation { correct, retry, reveal }
```
## 📄 `lib/features/games/presentation/choice_game_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../domain/engines/choice_engine.dart';
import '../domain/evaluation.dart';
import '../../../providers/progress_providers.dart';

class ChoiceGameSetup<T> {
  const ChoiceGameSetup({required this.questions, this.promptBuilder, this.instructionText});
  final List<ChoiceQuestion<T>> questions;
  final Widget Function(BuildContext, ChoiceQuestion<T>)? promptBuilder;
  final String? instructionText;
}

class ChoiceGameScreen<T> extends ConsumerStatefulWidget {
  const ChoiceGameScreen({
    super.key,
    required this.activityId,
    required this.contentId,
    required this.kind,
    required this.backRoute,
    required this.idOf,
    required this.setup,
    required this.optionBuilder,
  });
  final String activityId;
  final String contentId;
  final String kind;
  final String backRoute;
  final String Function(T) idOf;
  final Future<ChoiceGameSetup<T>> Function(WidgetRef ref) setup;
  final Widget Function(BuildContext, WidgetRef, T) optionBuilder;

  @override
  ConsumerState<ChoiceGameScreen<T>> createState() => _ChoiceGameScreenState<T>();
}

class _ChoiceGameScreenState<T> extends ConsumerState<ChoiceGameScreen<T>> {
  ChoiceSession<T>? _session;
  ChoiceGameSetup<T>? _setup;
  String? _wrongId;
  String? _okId;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final setup = await widget.setup(ref);
    if (!mounted) return;
    setState(() {
      _setup = setup;
      _session = ChoiceSession<T>(setup.questions, ChoiceEngine<T>(widget.idOf));
    });
    _playPrompt();
  }

  void _playPrompt() {
    final s = _session;
    final audio = (s == null || s.finished) ? null : s.current.promptAudio;
    if (audio != null) ref.read(audioServiceProvider).playVoice(audio);
  }

  Future<void> _onTap(T choice) async {
    final s = _session;
    if (s == null || s.finished || _locked) return;
    final id = widget.idOf(choice);
    switch (s.answer(choice)) {
      case Evaluation.correct:
        setState(() { _okId = id; _locked = true; });
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;
        s.next();
        setState(() { _okId = null; _wrongId = null; _locked = false; });
        s.finished ? _saveResult(s) : _playPrompt();
      case Evaluation.retry:
        setState(() => _wrongId = id);
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) setState(() => _wrongId = null);
      case Evaluation.reveal:
        setState(() { _wrongId = id; _okId = widget.idOf(s.current.target); });
        await Future.delayed(const Duration(milliseconds: 1000));
        if (!mounted) return;
        s.next();
        setState(() { _okId = null; _wrongId = null; });
        s.finished ? _saveResult(s) : _playPrompt();
    }
  }

  void _saveResult(ChoiceSession<T> s) {
    ref.read(progressRepositoryProvider).recordResult(
          activityId: widget.activityId,
          contentId: widget.contentId,
          kind: widget.kind,
          attempts: s.questions.length + s.totalWrong,
          correct: s.questions.length,
          stars: s.stars,
        );
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _session;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.apps),
          onPressed: () => context.go(widget.backRoute),
        ),
        title: s == null ? null : Text('سؤال ${s.index + 1} من ${s.questions.length}'),
        centerTitle: true,
      ),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : s.finished
              ? _Result(stars: s.stars, onReplay: () { setState(() => _session = null); _init(); }, onBack: () => context.go(widget.backRoute))
              : _board(context, s),
    );
  }

  Widget _board(BuildContext context, ChoiceSession<T> s) {
    final q = s.current;
    final prompt = _setup?.promptBuilder;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // تلميح بصري للطفل
          if (_setup?.instructionText != null)
            Text(
              _setup!.instructionText!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 16),
          if (prompt != null) prompt(context, q),
          
          // زر السماعة ضخم جداً
          if (q.promptAudio != null)
            GestureDetector(
              onTap: _playPrompt,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: const Icon(Icons.volume_up, size: 60, color: Colors.white),
              ),
            ),
          const Spacer(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final o in q.options)
                SizedBox(
                  width: 110,
                  height: 110,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.idOf(o) == _okId
                          ? Colors.green
                          : (widget.idOf(o) == _wrongId ? Colors.orange.shade300 : Colors.white),
                      foregroundColor: widget.idOf(o) == _okId || widget.idOf(o) == _wrongId ? Colors.white : Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                    onPressed: () => _onTap(o),
                    child: widget.optionBuilder(context, ref, o),
                  ),
                ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.stars, required this.onReplay, required this.onBack});
  final int stars;
  final VoidCallback onReplay;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < stars; i++)
                  const Icon(Icons.star, size: 80, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filled(iconSize: 64, onPressed: onReplay, icon: const Icon(Icons.replay)),
                const SizedBox(width: 32),
                IconButton.filled(iconSize: 64, onPressed: onBack, icon: const Icon(Icons.check)),
              ],
            ),
          ],
        ),
      );
}
```
## 📄 `lib/features/games/presentation/choice_games.dart`
```dart
import 'package:flutter/material.dart';
import '../../../data/models/letter.dart';
import '../../../providers/content_providers.dart';
import '../domain/engines/choice_engine.dart';
import 'choice_game_screen.dart';

class RecognizeLetterGame extends StatelessWidget {
  const RecognizeLetterGame({super.key, required this.letterId});
  final String letterId;

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<Letter>(
        activityId: 'recognize_$letterId',
        contentId: letterId,
        kind: 'letter',
        backRoute: '/letters/$letterId',
        idOf: (l) => l.id,
        setup: (ref) async {
          final repo = await ref.read(contentRepositoryProvider.future);
          final target = repo.letterById(letterId);
          if (target == null) return const ChoiceGameSetup(questions: []);
          return ChoiceGameSetup(
            instructionText: 'اسمع الصوت واختر الحرف الصح',
            questions: ChoiceEngine<Letter>((l) => l.id).build(
              targets: [target],
              pool: repo.letters,
              promptAudioFor: (l) => l.soundAudio,
            ),
          );
        },
        optionBuilder: (c, ref, l) => Text(
          l.character,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
      );
}
```
## 📄 `lib/features/home/home_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bigButton(String label, String route) => SizedBox(
          width: double.infinity,
          height: 120,
          child: FilledButton(
            onPressed: () => context.go(route),
            child: Text(label, style: const TextStyle(fontSize: 36)),
          ),
        );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('بيت الحروف',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              bigButton('الحروف', '/letters'),
              const SizedBox(height: 16),
              bigButton('الأرقام', '/numbers'),
            ],
          ),
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/letters/presentation/letter_lesson_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_repository.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';

class LetterLessonScreen extends ConsumerStatefulWidget {
  const LetterLessonScreen({super.key, required this.letterId});
  final String letterId;

  @override
  ConsumerState<LetterLessonScreen> createState() =>
      _LetterLessonScreenState();
}

class _LetterLessonScreenState extends ConsumerState<LetterLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  Future<void> _speak() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return; // 👈 إضافة سطر الأمان هنا
    final letter = repo.letterById(widget.letterId);
    if (letter == null) return;
    final word = repo.wordById(letter.primaryWordId);
    ref.read(audioServiceProvider).playSequence([
      letter.nameAudio,
      if (word != null) word.audio,
    ]);
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(contentRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.apps),
          onPressed: () => context.go('/letters'),
        ),
      ),
      body: repo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (r) {
          final letter = r.letterById(widget.letterId);
          if (letter == null) {
            return const Center(child: Text('الحرف غير موجود'));
          }
          return _LessonBody(
            repo: r,
            letter: letter,
            onReplay: _speak,
          );
        },
      ),
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({
    required this.repo,
    required this.letter,
    required this.onReplay,
  });

  final ContentRepository repo;
  final Letter letter;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final word = repo.wordById(letter.primaryWordId);
    final next = repo.nextOf(letter);
    final prev = repo.previousOf(letter);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(letter.character,
                style: Theme.of(context).textTheme.displayLarge),
            Text(letter.name,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final k in ['isolated', 'initial', 'medial', 'final'])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(letter.forms[k] ?? '',
                        style: const TextStyle(fontSize: 40)),
                  ),
              ],
            ),
            const Spacer(),
            if (word != null) ...[
              SizedBox(
                height: 160,
                child: Image.asset(
                  'assets/images/${word.image}.png',
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 96),
                ),
              ),
              Text(word.textVowelled,
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
            const SizedBox(height: 16),
            IconButton.filled(
              iconSize: 56,
              onPressed: onReplay,
              icon: const Icon(Icons.volume_up),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: () => context.push('/letters/${letter.id}/recognize'),
                  icon: const Icon(Icons.touch_app),
                ),
                const SizedBox(width: 24),
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: () => context.push('/letters/${letter.id}/trace'),
                  icon: const Icon(Icons.draw),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: prev == null
                      ? null
                      : () => context.pushReplacement('/letters/${prev.id}'),
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton.filledTonal(
                  iconSize: 48,
                  onPressed: next == null
                      ? null
                      : () => context.pushReplacement('/letters/${next.id}'),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/letters/presentation/letters_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
        title: const Text('الحروف'),
      ),
      body: repo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (r) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: r.letters.length,
          itemBuilder: (context, i) {
            final l = r.letters[i];
            final earnedStars = stars[l.id] ?? 0;
            return Stack(
              children: [
                Positioned.fill(
                  child: FilledButton(
                    onPressed: () => context.push('/letters/${l.id}'),
                    child: Text(l.character, style: const TextStyle(fontSize: 64)),
                  ),
                ),
                if (earnedStars > 0)
                  const PositionedDirectional(
                    top: 6,
                    end: 6,
                    child: Icon(Icons.star, color: Colors.amber, size: 28),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/tracing/domain/stroke_tracker.dart`
```dart
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
```
## 📄 `lib/features/tracing/presentation/tracing_canvas.dart`
```dart
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

    // رسم التقدم (الأخضر)
    final progressPaint = Paint()
      ..color = Colors.green
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
```
## 📄 `lib/features/tracing/presentation/tracing_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/content/content_loader.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import 'tracing_canvas.dart';

final tracingProvider = FutureProvider.family((ref, String letterId) async {
  final repo = await ref.watch(contentRepositoryProvider.future);
  final letter = repo.letterById(letterId);
  if (letter == null) throw Exception('Letter not found');
  return ContentLoader().loadTracing(letter.tracingId);
});

class TracingScreen extends ConsumerStatefulWidget {
  const TracingScreen({super.key, required this.letterId});
  final String letterId;
  @override
  ConsumerState<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends ConsumerState<TracingScreen> {
  bool _done = false;

  void _complete() {
    if (_done) return;
    setState(() => _done = true);
    ref.read(progressRepositoryProvider).recordResult(
          activityId: 'trace_${widget.letterId}',
          contentId: widget.letterId,
          kind: 'letter',
          attempts: 1,
          correct: 1,
          stars: 3,
        );
  }

  @override
  Widget build(BuildContext context) {
    final trace = ref.watch(tracingProvider(widget.letterId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          icon: const Icon(Icons.apps),
          onPressed: () => context.go('/letters/${widget.letterId}'),
        ),
        title: const Text('رسم الحرف'),
      ),
      body: trace.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('تعذر تحميل المسار: $e')),
        data: (t) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: TracingCanvas(trace: t, onComplete: _complete)),
              const SizedBox(height: 24),
              if (_done)
                const Column(
                  children: [
                    Icon(Icons.star, size: 96, color: Colors.amber),
                    Text('أحسنت!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```
## 📄 `lib/main.dart`
```dart
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  } catch (e) {
    debugPrint('AudioSession init failed: $e');
  }
  runApp(const ProviderScope(child: BaytApp()));
}
```
## 📄 `lib/providers/audio_providers.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/audio/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
```
## 📄 `lib/providers/content_providers.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/content/content_loader.dart';
import '../data/content/content_repository.dart';

final contentRepositoryProvider = FutureProvider<ContentRepository>((ref) async {
  final repo = ContentRepository(ContentLoader());
  await repo.load();
  return repo;
});
```
## 📄 `lib/providers/progress_providers.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/db/app_database.dart';
import '../data/progress/progress_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(appDatabaseProvider));
});

final starsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(progressRepositoryProvider).watchStars();
});
```
