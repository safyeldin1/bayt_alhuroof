import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/content/content_loader.dart';
import '../data/content/content_repository.dart';

final contentRepositoryProvider = FutureProvider<ContentRepository>((ref) async {
  final repo = ContentRepository(ContentLoader());
  await repo.load();
  return repo;
});
