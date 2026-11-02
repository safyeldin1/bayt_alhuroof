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
