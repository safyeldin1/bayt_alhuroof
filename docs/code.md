# 💻 كود المشروع الكامل
> آخر تحديث: 2026-11-02 23:46:30
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
    } catch (e) {
      debugPrint('audio error ($ref): $e');
    }
  }

  Future<void> stop() async {
    _token++;
    try {
      await _voice.stop();
    } catch (e) {
      debugPrint('audio stop error: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _voice.dispose();
    } catch (e) {
      debugPrint('audio dispose error: $e');
    }
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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(
        path: '/letters/:id',
        builder: (c, s) =>
            LetterLessonScreen(letterId: s.pathParameters['id']!),
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

  Future<List<Word>> loadWords() async {
    final raw = await rootBundle.loadString('assets/content/words.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['items'] as List).cast<Map<String, dynamic>>().map(Word.fromJson).toList();
  }
}
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
    final letter = repo.letterById(widget.letterId);
    if (letter == null || !mounted) return;
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

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
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
            return FilledButton(
              onPressed: () => context.push('/letters/${l.id}'),
              child: Text(l.character, style: const TextStyle(fontSize: 64)),
            );
          },
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
