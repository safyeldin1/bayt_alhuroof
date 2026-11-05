# 💻 كود المشروع الكامل
> آخر تحديث: 2026-11-05 21:48:45
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
  flutter_launcher_icons: ^0.9.3

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
## 📄 `lib/core/animations/bounce_in.dart`
```dart
import 'package:flutter/material.dart';

class BounceIn extends StatefulWidget {
  const BounceIn({super.key, required this.child, this.duration = const Duration(milliseconds: 600)});
  final Widget child;
  final Duration duration;

  @override
  State<BounceIn> createState() => _BounceInState();
}

class _BounceInState extends State<BounceIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _animation, child: widget.child);
}
```
## 📄 `lib/core/animations/floating.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';

class Floating extends StatefulWidget {
  const Floating({super.key, required this.child});
  final Widget child;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = sin(_controller.value * 2 * pi) * 8;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: widget.child,
    );
  }
}
```
## 📄 `lib/core/animations/pulse_hint.dart`
```dart
import 'package:flutter/material.dart';

class PulseHint extends StatefulWidget {
  const PulseHint({super.key, required this.child});
  final Widget child;

  @override
  State<PulseHint> createState() => _PulseHintState();
}

class _PulseHintState extends State<PulseHint> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _animation, child: widget.child);
}
```
## 📄 `lib/core/animations/star_burst.dart`
```dart
import 'dart:math';
import 'package:flutter/material.dart';

class StarBurst extends StatefulWidget {
  const StarBurst({super.key, required this.stars});
  final int stars;

  @override
  State<StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<StarBurst> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(widget.stars * 4, (index) {
            final angle = (index / (widget.stars * 4)) * 2 * pi;
            final distance = 120 * _controller.value;
            final dx = cos(angle) * distance;
            final dy = sin(angle) * distance;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: Opacity(
                opacity: 1.0 - _controller.value,
                child: Icon(Icons.star, color: Colors.amber.shade400, size: 40),
              ),
            );
          }),
        );
      },
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/letters/presentation/letters_screen.dart';
import '../../features/letters/presentation/letter_lesson_screen.dart';
import '../../features/games/presentation/choice_games.dart';
import '../../features/games/presentation/drag_match_game.dart';
import '../../features/games/presentation/counting_game.dart';
import '../../features/games/presentation/colors_shapes_games.dart';
import '../../features/games/presentation/shape_shadow_game.dart';
import '../../features/games/presentation/letter_shadow_game.dart';
import '../../features/tracing/presentation/tracing_screen.dart';
import '../../features/numbers/presentation/numbers_screen.dart';
import '../../features/numbers/presentation/number_lesson_screen.dart';
import '../../features/parent_zone/parent_gate_screen.dart';
import '../../features/parent_zone/parent_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import '../../features/colors/presentation/colors_screen.dart';
import '../../features/shapes/presentation/shapes_screen.dart';
import '../../features/coloring/presentation/coloring_gallery.dart';
import '../../features/about/about_screen.dart';
import '../../providers/parent_providers.dart';

// === ملفات المهن ===
import '../../features/games/presentation/professions_menu.dart';
import '../../features/games/presentation/professions_choice_game.dart';
import '../../features/games/presentation/professions_drag_game.dart';
import '../../features/games/presentation/professions_learn.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      
      // الحروف
      GoRoute(path: '/letters', builder: (c, s) => const LettersScreen()),
      GoRoute(path: '/letters/shadow_game', builder: (c, s) => const LetterShadowGame()),
      GoRoute(path: '/letters/:id', builder: (c, s) => LetterLessonScreen(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/recognize', builder: (c, s) => RecognizeLetterGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/match', builder: (c, s) => MatchImageGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/drag', builder: (c, s) => DragMatchGame(letterId: s.pathParameters['id']!)),
      GoRoute(path: '/letters/:id/trace', builder: (c, s) => TracingScreen(letterId: s.pathParameters['id']!)),
      
      // الأرقام
      GoRoute(path: '/numbers', builder: (c, s) => const NumbersScreen()),
      GoRoute(path: '/numbers/:id', builder: (c, s) => NumberLessonScreen(numberId: s.pathParameters['id']!)),
      GoRoute(path: '/numbers/:id/pick', builder: (c, s) => PickNumberGame(numberId: s.pathParameters['id']!)),
      GoRoute(path: '/numbers/:id/count_game', builder: (c, s) => CountingGame(numberId: s.pathParameters['id']!)),
      
      // الألوان والأشكال
      GoRoute(path: '/colors', builder: (c, s) => const ColorsScreen()),
      GoRoute(path: '/colors/game', builder: (c, s) => const ColorGame()),
      GoRoute(path: '/shapes', builder: (c, s) => const ShapesScreen()),
      GoRoute(path: '/shapes/game', builder: (c, s) => const ShapeGame()),
      GoRoute(path: '/shapes/shadow_game', builder: (c, s) => const ShapeShadowGame()),
      
      // التلوين
      GoRoute(path: '/coloring', builder: (c, s) => const ColoringGallery()),
      
      // المهن (الـ 4 مسارات)
      GoRoute(path: '/professions', builder: (c, s) => const ProfessionsMenu()),
      GoRoute(path: '/professions/learn', builder: (c, s) => const ProfessionsLearn()),
      GoRoute(path: '/professions/choice', builder: (c, s) => const ProfessionsChoiceGame()),
      GoRoute(path: '/professions/drag', builder: (c, s) => const ProfessionsDragGame()),
      
      // حول التطبيق
      GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
      
      // المكافآت
      GoRoute(path: '/rewards', builder: (c, s) => const RewardsScreen()),
      
      // ولي الأمر
      GoRoute(path: '/parent-gate', builder: (c, s) => const ParentGateScreen()),
      GoRoute(
        path: '/parent',
        builder: (c, s) => const ParentScreen(),
        redirect: (c, s) => ref.read(parentGateProvider.notifier).isUnlocked ? null : '/parent-gate',
      ),
    ],
  );
});
```
## 📄 `lib/core/settings/app_settings.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/arabic_numbers.dart';

class AppSettings {
  const AppSettings({this.voiceVolume = 1.0, this.numeralStyle = NumeralStyle.arabicIndic});
  final double voiceVolume;
  final NumeralStyle numeralStyle;

  AppSettings copyWith({double? voiceVolume, NumeralStyle? numeralStyle}) => AppSettings(
        voiceVolume: voiceVolume ?? this.voiceVolume,
        numeralStyle: numeralStyle ?? this.numeralStyle,
      );
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SettingsController extends Notifier<AppSettings> {
  static const _kVolume = 'voice_volume';
  static const _kNumerals = 'numeral_style';

  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final name = prefs.getString(_kNumerals);
    return AppSettings(
      voiceVolume: prefs.getDouble(_kVolume) ?? 1.0,
      numeralStyle: NumeralStyle.values.firstWhere((s) => s.name == name, orElse: () => NumeralStyle.arabicIndic),
    );
  }

  Future<void> setVolume(double v) async {
    state = state.copyWith(voiceVolume: v);
    await ref.read(sharedPreferencesProvider).setDouble(_kVolume, v);
    // تحديث الصوت في الخدمة
    // ref.read(audioServiceProvider).voiceVolume = v; // سنحتاج نمررها لاحقاً
  }

  Future<void> setNumerals(NumeralStyle s) async {
    state = state.copyWith(numeralStyle: s);
    await ref.read(sharedPreferencesProvider).setString(_kNumerals, s.name);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
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
## 📄 `lib/core/utils/arabic_numbers.dart`
```dart
enum NumeralStyle { arabicIndic, western }

String formatNumber(int n, NumeralStyle style) {
  if (style == NumeralStyle.western) return n.toString();
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return n.toString().split('').map((c) => digits[int.parse(c)]).join();
}
```
## 📄 `lib/core/widgets/animated_image.dart`
```dart
import 'package:flutter/material.dart';

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({super.key, required this.imagePath, required this.emoji, required this.onTap});
  final String imagePath;
  final String emoji;
  final VoidCallback onTap;

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _controller.repeat(reverse: true);
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  // لو الصورة مش موجودة، بنعرض الإيموجي
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(widget.emoji, style: const TextStyle(fontSize: 80)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```
## 📄 `lib/core/widgets/feedback_popup.dart`
```dart
import 'package:flutter/material.dart';

class FeedbackPopup extends StatefulWidget {
  const FeedbackPopup({super.key, required this.isCorrect, required this.onDismiss});
  final bool isCorrect;
  final VoidCallback onDismiss;

  @override
  State<FeedbackPopup> createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black45,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isCorrect ? Icons.check_circle : Icons.face,
                    size: 100,
                    color: widget.isCorrect ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.isCorrect ? 'أحسنت!' : 'حاول مرة أخرى',
                    style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold,
                      color: widget.isCorrect ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCorrect ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('متابعة', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
## 📄 `lib/core/widgets/kids_background.dart`
```dart
import 'package:flutter/material.dart';

class KidsBackground extends StatelessWidget {
  const KidsBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF81D4FA)], // سماء زرقاء
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _CartoonBackgroundPainter()),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _CartoonBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. الشمس
    final sunPaint = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 60, sunPaint);
    
    // 2. السحاب
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
    _drawCloud(canvas, Offset(size.width * 0.2, size.height * 0.1), 1.0, cloudPaint);
    _drawCloud(canvas, Offset(size.width * 0.6, size.height * 0.25), 0.8, cloudPaint);

    // 3. التلال الخضراء
    final hillPaint1 = Paint()..color = const Color(0xFF81C784);
    final path1 = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.6, size.height)
      ..close();
    canvas.drawPath(path1, hillPaint1);

    final hillPaint2 = Paint()..color = const Color(0xFF66BB6A);
    final path2 = Path()
      ..moveTo(size.width * 0.4, size.height)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width, size.height)
      ..close();
    canvas.drawPath(path2, hillPaint2);
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, Paint paint) {
    canvas.drawCircle(center, 30 * scale, paint);
    canvas.drawCircle(center.translate(-30 * scale, 10 * scale), 20 * scale, paint);
    canvas.drawCircle(center.translate(30 * scale, 10 * scale), 25 * scale, paint);
    canvas.drawRect(Rect.fromLTRB(center.dx - 30 * scale, center.dy, center.dx + 30 * scale, center.dy + 30 * scale), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```
## 📄 `lib/core/widgets/kids_button.dart`
```dart
import 'package:flutter/material.dart';

class KidsButton extends StatefulWidget {
  const KidsButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.child,
    this.width = 180, // مربع افتراضي
    this.height = 180,
  });
  final VoidCallback onTap;
  final Color color;
  final Widget child;
  final double width;
  final double height;

  @override
  State<KidsButton> createState() => _KidsButtonState();
}

class _KidsButtonState extends State<KidsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.8),
              offset: Offset(0, _isPressed ? 4 : 12),
              blurRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 6),
        ),
        transform: Matrix4.translationValues(0, _isPressed ? 8 : 0, 0),
        child: Center(child: widget.child),
      ),
    );
  }
}
```
## 📄 `lib/data/content/content_loader.dart`
```dart
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
```
## 📄 `lib/data/content/content_repository.dart`
```dart
import '../models/letter.dart';
import '../models/word.dart';
import '../models/number_item.dart';
import 'content_loader.dart';

class ContentRepository {
  ContentRepository(this._loader);
  final ContentLoader _loader;

  List<Letter> letters = [];
  List<Word> words = [];
  List<NumberItem> numbers = [];

  Future<void> load() async {
    letters = await _loader.loadLetters();
    words = await _loader.loadWords();
    numbers = await _loader.loadNumbers();
  }

  Letter? letterById(String id) {
    for (final l in letters) { if (l.id == id) return l; }
    return null;
  }

  NumberItem? numberById(String id) {
    for (final n in numbers) { if (n.id == id) return n; }
    return null;
  }

  NumberItem? numberByValue(int val) {
    for (final n in numbers) { if (n.value == val) return n; }
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
## 📄 `lib/data/models/color_item.dart`
```dart
import 'package:flutter/material.dart';

class ColorItem {
  const ColorItem({required this.id, required this.name, required this.hexColor, required this.emoji});
  final String id;
  final String name;
  final String hexColor;
  final String emoji;

  Color get color => Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
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
## 📄 `lib/data/models/number_item.dart`
```dart
class NumberItem {
  const NumberItem({
    required this.id,
    required this.value,
    required this.nameText,
    required this.audio,
    required this.objectImage,
    required this.status,
  });

  final String id;
  final int value;
  final String nameText;
  final String audio;
  final String objectImage;
  final String status;

  factory NumberItem.fromJson(Map<String, dynamic> j) => NumberItem(
        id: j['id'] as String,
        value: j['value'] as int,
        nameText: j['nameText'] as String,
        audio: j['audio'] as String,
        objectImage: j['objectImage'] as String,
        status: j['status'] as String? ?? 'published',
      );
}
```
## 📄 `lib/data/models/profession_item.dart`
```dart
class ProfessionItem {
  const ProfessionItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.toolId,
  });

  final String id;
  final String name;
  final String emoji;
  final String toolId;
}

class ToolItem {
  const ToolItem({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;
}
```
## 📄 `lib/data/models/shape_item.dart`
```dart

enum ShapeType { triangle, square, rectangle, circle, diamond }

class ShapeItem {
  const ShapeItem({required this.id, required this.name, required this.type, required this.emoji});
  final String id;
  final String name;
  final ShapeType type;
  final String emoji;
}
```
## 📄 `lib/data/models/tracing_path.dart`
```dart

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
    required this.emoji,
  });

  final String id;
  final String text;
  final String textVowelled;
  final String startsWithLetterId;
  final String image;
  final String audio;
  final String emoji;

  factory Word.fromJson(Map<String, dynamic> j) => Word(
        id: j['id'] as String,
        text: j['text'] as String,
        textVowelled: j['textVowelled'] as String,
        startsWithLetterId: j['startsWithLetterId'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String,
        emoji: j['emoji'] as String? ?? '❓',
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


  Future<void> resetAll() => _db.transaction(() async {
    await _db.delete(_db.activityResults).go();
    await _db.delete(_db.itemProgress).go();
  });

  Stream<Map<String, int>> watchStars() {
    return _db.select(_db.itemProgress).watch().map(
          (rows) => {for (final r in rows) r.contentId: r.bestStars},
        );
  }
}
```
## 📄 `lib/features/about/about_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/animations/bounce_in.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('حول التطبيق', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: BounceIn(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school, size: 100, color: Colors.orange),
                        SizedBox(height: 16),
                        Text('أول خطوة', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                        SizedBox(height: 8),
                        Text('الإصدار 1.0.0', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 24),
                        Divider(),
                        SizedBox(height: 16),
                        Text('تطبيق تعليمي للأطفال لتعلم الحروف والأرقام والألوان والأشكال والمهن.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 24),
                        Text('Powered by Safyeldin Abdo © Ghinax', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/coloring/presentation/coloring_gallery.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../providers/audio_providers.dart';
import 'coloring_screen.dart';
import 'coloring_shapes.dart';

class ColoringGallery extends ConsumerWidget {
  const ColoringGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/coloring');
    });

    final templates = ColoringShapes.all();

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('التلوين', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 500 ? 3 : 2);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: templates.length + 1,
                    itemBuilder: (context, i) {
                      if (i == templates.length) {
                        return KidsButton(
                          color: Colors.white,
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ColoringScreen(title: 'رسم حر', shapeWidget: null),
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.brush, size: 80, color: Colors.purple),
                              SizedBox(height: 12),
                              Text('رسم حر', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
                            ],
                          ),
                        );
                      }
                      final template = templates[i];
                      return KidsButton(
                        color: Colors.white,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ColoringScreen(title: template.name, shapeWidget: template.painter()),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(template.icon, size: 80, color: template.themeColor),
                            const SizedBox(height: 12),
                            Text(template.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: template.themeColor)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/coloring/presentation/coloring_screen.dart`
```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class ColoringScreen extends StatefulWidget {
  final String title;
  final Widget? shapeWidget;
  const ColoringScreen({super.key, required this.title, this.shapeWidget});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  Color _selectedColor = Colors.red;
  final List<DrawnLine> _lines = [];
  DrawnLine? _currentLine;

  final List<Color> _palette = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.purple, Colors.pink, Colors.brown, Colors.black, Colors.white,
  ];

  void _clearCanvas() {
    setState(() {
      _lines.clear();
      _currentLine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'لوحة جديدة',
            onPressed: () {
              setState(() {
                _lines.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'مسح التلوين',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentLine = DrawnLine([details.localPosition], _selectedColor, 15.0);
                    _lines.add(_currentLine!);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentLine?.path.add(details.localPosition);
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _currentLine = null;
                  });
                },
                child: Stack(
                  children: [
                    if (widget.shapeWidget != null) Positioned.fill(child: widget.shapeWidget!),
                    Positioned.fill(child: CustomPaint(painter: _DrawingPainter(_lines))),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 90,
            color: Colors.grey.shade200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _palette.length,
              itemBuilder: (context, i) {
                final color = _palette[i];
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 60, height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 5 : 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawnLine {
  DrawnLine(this.path, this.color, this.width);
  final List<Offset> path;
  final Color color;
  final double width;
}

class _DrawingPainter extends CustomPainter {
  _DrawingPainter(this.lines);
  final List<DrawnLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.width
        ..style = PaintingStyle.stroke;
      
      if (line.path.length < 2) {
        canvas.drawPoints(PointMode.points, line.path, paint);
      } else {
        final path = Path()..moveTo(line.path[0].dx, line.path[0].dy);
        for (var i = 1; i < line.path.length; i++) {
          path.lineTo(line.path[i].dx, line.path[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```
## 📄 `lib/features/coloring/presentation/coloring_shapes.dart`
```dart
import 'package:flutter/material.dart';

// كل رسمة عبارة عن Path ومجموعة من الألوان اللي الطفل ممكن يستخدمها
class ColoringTemplate {
  final String id;
  final String name;
  final IconData icon;
  final Color themeColor;
  final Widget Function() painter;

  const ColoringTemplate({
    required this.id, required this.name, required this.icon,
    required this.themeColor, required this.painter,
  });
}

class ColoringShapes {
  static List<ColoringTemplate> all() {
    return [
      ColoringTemplate(id: 'tree', name: 'شجرة', icon: Icons.park, themeColor: Colors.green, painter: () => const TreeShape()),
      ColoringTemplate(id: 'house', name: 'بيت', icon: Icons.home, themeColor: Colors.orange, painter: () => const HouseShape()),
      ColoringTemplate(id: 'cat', name: 'قطة', icon: Icons.pets, themeColor: Colors.pink, painter: () => const CatShape()),
      ColoringTemplate(id: 'dog', name: 'كلب', icon: Icons.pets, themeColor: Colors.brown, painter: () => const DogShape()),
      ColoringTemplate(id: 'fish', name: 'سمكة', icon: Icons.water, themeColor: Colors.blue, painter: () => const FishShape()),
      ColoringTemplate(id: 'butterfly', name: 'فراشة', icon: Icons.bug_report, themeColor: Colors.purple, painter: () => const ButterflyShape()),
      ColoringTemplate(id: 'car', name: 'سيارة', icon: Icons.directions_car, themeColor: Colors.red, painter: () => const CarShape()),
      ColoringTemplate(id: 'sun', name: 'شمس', icon: Icons.wb_sunny, themeColor: Colors.amber, painter: () => const SunShape()),
      ColoringTemplate(id: 'flower', name: 'زهرة', icon: Icons.local_florist, themeColor: Colors.pinkAccent, painter: () => const FlowerShape()),
      ColoringTemplate(id: 'star', name: 'نجمة', icon: Icons.star, themeColor: Colors.amber, painter: () => const StarShape()),
    ];
  }
}

// --- رسومات الـ Outline (أبيض وأسود) ---

class TreeShape extends StatelessWidget {
  const TreeShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.park_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class HouseShape extends StatelessWidget {
  const HouseShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.house_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class CatShape extends StatelessWidget {
  const CatShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.pets_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class DogShape extends StatelessWidget {
  const DogShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.pets_outlined, size: 400, color: Colors.grey.shade300), // مؤقتاً
  );
}

class FishShape extends StatelessWidget {
  const FishShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.water_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class ButterflyShape extends StatelessWidget {
  const ButterflyShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.bug_report_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class CarShape extends StatelessWidget {
  const CarShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.directions_car_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class SunShape extends StatelessWidget {
  const SunShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.wb_sunny_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class FlowerShape extends StatelessWidget {
  const FlowerShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.local_florist_outlined, size: 400, color: Colors.grey.shade300),
  );
}

class StarShape extends StatelessWidget {
  const StarShape({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.star_outline, size: 400, color: Colors.grey.shade300),
  );
}
```
## 📄 `lib/features/colors/presentation/colors_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../data/models/color_item.dart';
import '../../../providers/audio_providers.dart';

class ColorsScreen extends ConsumerWidget {
  const ColorsScreen({super.key});

  static const List<ColorItem> colors = [
    ColorItem(id: 'red', name: 'أَحْمَر', hexColor: '#F44336', emoji: '🍎'),
    ColorItem(id: 'blue', name: 'أَزْرَق', hexColor: '#2196F3', emoji: '🌊'),
    ColorItem(id: 'yellow', name: 'أَصْفَر', hexColor: '#FFEB3B', emoji: '🌞'),
    ColorItem(id: 'green', name: 'أَخْضَر', hexColor: '#4CAF50', emoji: '🌿'),
    ColorItem(id: 'orange', name: 'بُرْتُقَالِي', hexColor: '#FF9800', emoji: '🍊'),
    ColorItem(id: 'purple', name: 'بَنَفْسَجِي', hexColor: '#9C27B0', emoji: '🍇'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/colors');
    });

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الألوان', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity, height: 60,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
                  onPressed: () => context.push('/colors/game'),
                  icon: const Icon(Icons.videogame_asset, color: Colors.white),
                  label: const Text('العب لعبة الألوان', style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, i) {
                      final c = colors[i];
                      return BounceIn(
                        child: GestureDetector(
                          onTap: () => ref.read(audioServiceProvider).playVoice('colors/${c.id}', force: true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: c.color,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [BoxShadow(color: c.color.withValues(alpha: 0.6), blurRadius: 15, offset: const Offset(0, 8))],
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(c.emoji, style: const TextStyle(fontSize: 60)),
                                const SizedBox(height: 8),
                                Text(c.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: c.id == 'yellow' ? Colors.black87 : Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/games/domain/engines/choice_engine.dart`
```dart
import 'dart:math';
import '../evaluation.dart';

class ChoiceQuestion<T> {
  const ChoiceQuestion(
    this.target, 
    this.options, {
    this.promptAudio, 
    this.promptImage, 
    this.promptText,
  });
  
  final T target;
  final List<T> options;
  final String? promptAudio;
  final String? promptImage;
  final String? promptText;
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
    String? Function(T target)? promptImageFor,
    String? Function(T target)? promptTextFor,
    Random? rng,
  }) {
    final r = rng ?? Random();
    return List.generate(rounds, (i) {
      final target = targets[i % targets.length];
      final others = pool.where((x) => idOf(x) != idOf(target)).toList()..shuffle(r);
      final options = [target, ...others.take(choices - 1)]..shuffle(r);
      
      return ChoiceQuestion<T>(
        target, 
        options, 
        promptAudio: promptAudioFor?.call(target),
        promptImage: promptImageFor?.call(target),
        promptText: promptTextFor?.call(target),
      );
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
import '../../../providers/progress_providers.dart';
import '../domain/engines/choice_engine.dart';
import '../domain/evaluation.dart';
import '../../../core/animations/star_burst.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/feedback_popup.dart';

class ChoiceGameSetup<T> {
  const ChoiceGameSetup({
    required this.questions, 
    this.instructionText,
    this.promptBuilder,
  });
  final List<ChoiceQuestion<T>> questions;
  final String? instructionText;
  final Widget Function(BuildContext, ChoiceQuestion<T>)? promptBuilder;
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
  
  // حالة الرسائل
  bool? _showFeedback;
  bool _feedbackIsCorrect = false;

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
        setState(() { 
          _okId = id; 
          _locked = true; 
          _showFeedback = true;
          _feedbackIsCorrect = true;
        });
        ref.read(audioServiceProvider).playVoice('instructions/right', force: true);
        
        // نستنى شوية عشان الصوت والرسالة يظهروا
        await Future.delayed(const Duration(milliseconds: 2000));
        if (!mounted) return;
        
        s.next();
        setState(() { 
          _okId = null; 
          _wrongId = null; 
          _locked = false;
          _showFeedback = null;
        });
        
        if (s.finished) {
          _saveResult(s);
        } else {
          _playPrompt();
        }
        
      case Evaluation.retry:
        setState(() { 
          _wrongId = id;
          _showFeedback = true;
          _feedbackIsCorrect = false;
        });
        ref.read(audioServiceProvider).playVoice('instructions/try_again', force: true);
        
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          setState(() { 
            _wrongId = null;
            _showFeedback = null;
          });
        }
        
      case Evaluation.reveal:
        setState(() { 
          _wrongId = id; 
          _okId = widget.idOf(s.current.target);
          _showFeedback = true;
          _feedbackIsCorrect = false;
        });
        ref.read(audioServiceProvider).playVoice('instructions/try_again', force: true);
        
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;
        
        s.next();
        setState(() { 
          _okId = null; 
          _wrongId = null;
          _showFeedback = null;
        });
        
        if (s.finished) {
          _saveResult(s);
        } else {
          _playPrompt();
        }
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
      body: KidsBackground(
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go(widget.backRoute)),
                  title: s == null ? null : Text('سؤال ${s.index + 1} من ${s.questions.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                Expanded(
                  child: s == null
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : s.finished
                          ? _Result(stars: s.stars, onReplay: () { setState(() => _session = null); _init(); }, onBack: () => context.go(widget.backRoute))
                          : _board(context, s),
                ),
              ],
            ),
            
            // الرسالة المنبثقة
            if (_showFeedback != null)
              FeedbackPopup(
                isCorrect: _feedbackIsCorrect,
                onDismiss: () {
                  setState(() => _showFeedback = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _board(BuildContext context, ChoiceSession<T> s) {
    final q = s.current;
    final prompt = _setup?.promptBuilder;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          if (_setup?.instructionText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(_setup!.instructionText!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
            ),
          const SizedBox(height: 16),
          if (prompt != null) prompt(context, q),
          
          if (q.promptAudio != null)
            IconButton.filled(
              iconSize: 64,
              onPressed: _playPrompt,
              icon: const Icon(Icons.volume_up),
            ),
          const Spacer(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final o in q.options)
                SizedBox(
                  width: 100,
                  height: 100,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.idOf(o) == _okId
                          ? Colors.green
                          : (widget.idOf(o) == _wrongId ? Colors.orange.shade300 : Colors.white),
                      foregroundColor: widget.idOf(o) == _okId || widget.idOf(o) == _wrongId ? Colors.white : const Color(0xFF00796B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF00796B), width: 3)),
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
            Stack(
              alignment: Alignment.center,
              children: [
                StarBurst(stars: stars),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < stars; i++)
                      const Icon(Icons.star, size: 80, color: Colors.amber),
                  ],
                ),
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
import '../../../data/models/number_item.dart';
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
        optionBuilder: (c, ref, l) => Text(l.character, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
      );
}

class PickNumberGame extends StatelessWidget {
  const PickNumberGame({super.key, required this.numberId});
  final String numberId;

  String _formatNumber(int n) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<NumberItem>(
        activityId: 'pick_number_$numberId',
        contentId: numberId,
        kind: 'number',
        backRoute: '/numbers/$numberId',
        idOf: (n) => n.id,
        setup: (ref) async {
          final repo = await ref.read(contentRepositoryProvider.future);
          final n = repo.numberById(numberId);
          if (n == null) return const ChoiceGameSetup(questions: []);
          
          final targets = [
            n,
            if (repo.numberByValue(n.value - 1) != null) repo.numberByValue(n.value - 1)!,
            if (repo.numberByValue(n.value + 1) != null) repo.numberByValue(n.value + 1)!,
          ];
          
          return ChoiceGameSetup(
            instructionText: 'عُدَّ العناصر وَاخْتَر الرَّقَم الصَّحِيح',
            promptBuilder: (ctx, q) {
              if (q.target.value == 0) {
                return const Text('لا يوجد شيء', style: TextStyle(fontSize: 24, color: Colors.white));
              }
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  for (var i = 0; i < q.target.value; i++)
                    const Text('🍎', style: TextStyle(fontSize: 40)),
                ],
              );
            },
            questions: ChoiceEngine<NumberItem>((x) => x.id).build(
              targets: targets,
              pool: repo.numbers,
              rounds: targets.length,
              promptAudioFor: (target) => target.audio, // 👈 هنا المكان الصح
            ),
          );
        },
        optionBuilder: (c, ref, n) => Text(_formatNumber(n.value), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
      );
}

class MatchImageGame extends StatelessWidget {
  const MatchImageGame({super.key, required this.letterId});
  final String letterId;

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<Letter>(
        activityId: 'match_image_$letterId',
        contentId: letterId,
        kind: 'letter',
        backRoute: '/letters/$letterId',
        idOf: (l) => l.id,
        setup: (ref) async {
          final repo = await ref.read(contentRepositoryProvider.future);
          final target = repo.letterById(letterId);
          if (target == null) return const ChoiceGameSetup(questions: []);
          
          final word = repo.wordById(target.primaryWordId);
          
          return ChoiceGameSetup(
            instructionText: 'ما هو الحرف الذي تبدأ به هذه الصورة؟',
            promptBuilder: (ctx, q) {
              if (word == null) return const SizedBox.shrink();
              return Container(
                width: 180, height: 200,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Image.asset(
                    'assets/images/${word.image}.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(child: Text(word.emoji, style: const TextStyle(fontSize: 60))),
                    )),
                    Text(word.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                  ],
                ),
              );
            },
            questions: ChoiceEngine<Letter>((l) => l.id).build(
              targets: [target],
              pool: repo.letters,
            ),
          );
        },
        optionBuilder: (c, ref, l) => Text(l.character, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
      );
}
```
## 📄 `lib/features/games/presentation/colors_shapes_games.dart`
```dart
import 'package:flutter/material.dart';
import '../../../data/models/color_item.dart';
import '../../../data/models/shape_item.dart';
import '../../colors/presentation/colors_screen.dart';
import '../../shapes/presentation/shapes_screen.dart';
import '../domain/engines/choice_engine.dart';
import 'choice_game_screen.dart';

class ColorGame extends StatelessWidget {
  const ColorGame({super.key});

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<ColorItem>(
        activityId: 'color_game',
        contentId: 'colors',
        kind: 'color',
        backRoute: '/colors',
        idOf: (c) => c.id,
        setup: (ref) async {
          final targets = ColorsScreen.colors.toList()..shuffle();
          return ChoiceGameSetup(
            instructionText: 'اختر اللون الصحيح',
            questions: ChoiceEngine<ColorItem>((c) => c.id).build(
              targets: targets,
              pool: ColorsScreen.colors,
              promptAudioFor: (c) => 'colors/${c.id}',
            ),
          );
        },
        optionBuilder: (ctx, ref, c) => Container(
          decoration: BoxDecoration(color: c.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
          child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 40))),
        ),
      );
}

class ShapeGame extends StatelessWidget {
  const ShapeGame({super.key});

  @override
  Widget build(BuildContext context) => ChoiceGameScreen<ShapeItem>(
        activityId: 'shape_game',
        contentId: 'shapes',
        kind: 'shape',
        backRoute: '/shapes',
        idOf: (s) => s.id,
        setup: (ref) async {
          final targets = ShapesScreen.shapes.toList()..shuffle();
          return ChoiceGameSetup(
            instructionText: 'اختر الشكل الصحيح',
            questions: ChoiceEngine<ShapeItem>((s) => s.id).build(
              targets: targets,
              pool: ShapesScreen.shapes,
              promptAudioFor: (s) => 'shapes/${s.id}',
            ),
          );
        },
        optionBuilder: (ctx, ref, s) => SizedBox(
          width: 80, height: 80,
          child: CustomPaint(painter: ShapePainter(s.type, Colors.blue.shade400)),
        ),
      );
}
```
## 📄 `lib/features/games/presentation/counting_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/number_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';

class CountingGame extends ConsumerStatefulWidget {
  const CountingGame({super.key, required this.numberId});
  final String numberId;

  @override
  ConsumerState<CountingGame> createState() => _CountingGameState();
}

class _CountingGameState extends ConsumerState<CountingGame> {
  NumberItem? _number;
  Set<int> _counted = {};
  bool _isLoading = true;
  bool _isFinished = false;
  int _wrongAttempts = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final n = repo.numberById(widget.numberId);
    if (n != null) {
      setState(() {
        _number = n;
        _counted = {};
        _isLoading = false;
        _isFinished = false;
        _wrongAttempts = 0;
      });
      ref.read(audioServiceProvider).playVoice(n.audio, force: true);
    }
  }

  void _onTapObject(int index) {
    if (_isFinished) return;
    if (_counted.contains(index)) return;

    setState(() {
      _counted.add(index);
    });

    // تشغيل صوت الرقم اللي اتعد
    final repo = ref.read(contentRepositoryProvider).valueOrNull;
    if (repo != null) {
      final spokenNumber = repo.numberByValue(_counted.length);
      if (spokenNumber != null) {
        ref.read(audioServiceProvider).playVoice(spokenNumber.audio, force: true);
      }
    }

    // لو خلص العد
    if (_counted.length == _number!.value) {
      setState(() => _isFinished = true);
      ref.read(progressRepositoryProvider).recordResult(
        activityId: 'count_game_${_number!.id}',
        contentId: _number!.id,
        kind: 'number',
        attempts: _number!.value + _wrongAttempts,
        correct: _number!.value,
        stars: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/numbers/${widget.numberId}')),
              title: const Text('عُدَّ العناصر', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _isFinished
                  ? _buildResult()
                  : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    final style = ref.watch(settingsProvider).numeralStyle;
    final targetCount = _number!.value;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // الرقم المطلوب
          Container(
            width: 120, height: 120,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
            child: Center(
              child: Text(formatNumber(targetCount, style), style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Color(0xFF29B6F6))),
            ),
          ),
          const SizedBox(height: 16),
          Text('اضغط على $targetCount عناصر', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          
          // العناصر
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  // هنعرض عناصر أكتر من الرقم عشان الطفل يعد بنفسه
                  for (var i = 0; i < targetCount + 3; i++)
                    GestureDetector(
                      onTap: () => _onTapObject(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: _counted.contains(i) ? Colors.green.shade100 : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: _counted.contains(i) ? Colors.green : Colors.grey.shade300, width: 4),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        child: Center(
                          child: Text(_counted.contains(i) ? '✅' : '🍎', style: const TextStyle(fontSize: 40)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final style = ref.watch(settingsProvider).numeralStyle;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          const SizedBox(height: 16),
          Text('أحسنت! لقد عددت ${formatNumber(_number!.value, style)} بشكل صحيح', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: _initGame, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/numbers/${widget.numberId}'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/drag_match_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/letter.dart';
import '../../../data/models/word.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class DragMatchGame extends ConsumerStatefulWidget {
  const DragMatchGame({super.key, required this.letterId});
  final String letterId;

  @override
  ConsumerState<DragMatchGame> createState() => _DragMatchGameState();
}

class _DragMatchGameState extends ConsumerState<DragMatchGame> {
  List<Word> _words = [];
  List<Letter> _options = [];
  Map<String, bool> _matched = {};
  bool _isLoading = true;
  bool _isFinished = false;
  int _wrongAttempts = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    // جلب 3 كلمات عشوائية (شاملة كلمة الحرف الحالي)
    final targetLetter = repo.letterById(widget.letterId);
    if (targetLetter == null) return;

    final targetWord = repo.wordById(targetLetter.primaryWordId);
    if (targetWord == null) return;

    // جلب كلمتين إضافيتين من حروف أخرى
    final otherWords = repo.words.where((w) => w.id != targetWord.id).toList()..shuffle();
    final selectedWords = [targetWord, ...otherWords.take(2)];

    // جلب الحروف المطابقة
    final selectedLetters = selectedWords.map((w) => repo.letterById(w.startsWithLetterId)!).toList()..shuffle();

    setState(() {
      _words = selectedWords..shuffle();
      _options = selectedLetters;
      _matched = {for (var w in _words) w.id: false};
      _isLoading = false;
    });
  }

  void _onDragAccepted(Word word, Letter letter) {
    if (word.startsWithLetterId == letter.id) {
      // إجابة صحيحة
      setState(() {
        _matched[word.id] = true;
      });
      ref.read(audioServiceProvider).playVoice(letter.soundAudio, force: true);
      
      // التحقق من الفوز
      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'drag_match_${widget.letterId}',
          contentId: widget.letterId,
          kind: 'letter',
          attempts: 3 + _wrongAttempts,
          correct: 3,
          stars: _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 2 ? 2 : 1),
        );
      }
    } else {
      // إجابة خاطئة
      setState(() => _wrongAttempts++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters/${widget.letterId}')),
              title: const Text('اسحب الحرف للصورة الصح', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _isFinished
                  ? _buildResult()
                  : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // منطقة الصور (أهداف السحب)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _words.map((word) {
            final isMatched = _matched[word.id] ?? false;
            return DragTarget<Letter>(
              onAcceptWithDetails: (details) => _onDragAccepted(word, details.data),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isMatched ? Colors.green.shade100 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isMatched ? Colors.green : Colors.grey.shade300, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(word.emoji, style: const TextStyle(fontSize: 50)),
                      Text(word.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                      if (isMatched) const Icon(Icons.check_circle, color: Colors.green, size: 24),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        // منطقة الحروف (الأشياء اللي بتتسحب)
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((letter) {
            // لو الحرف ده اتسحب صح، نخفيه
            final isUsed = _words.any((w) => w.startsWithLetterId == letter.id && _matched[w.id] == true);
            if (isUsed) return const SizedBox(width: 80, height: 80); // مساحة فاضية عشان التصميم ميبوظش

            return Draggable<Letter>(
              data: letter,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResult() {
    final stars = _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 2 ? 2 : 1);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarBurst(stars: stars),
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
              IconButton.filled(iconSize: 64, onPressed: () { setState(() { _isLoading = true; _isFinished = false; _wrongAttempts = 0; }); _initGame(); }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/letters/${widget.letterId}'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/letter_shadow_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/letter.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class LetterShadowGame extends ConsumerStatefulWidget {
  const LetterShadowGame({super.key});

  @override
  ConsumerState<LetterShadowGame> createState() => _LetterShadowGameState();
}

class _LetterShadowGameState extends ConsumerState<LetterShadowGame> {
  List<Letter> _targetLetters = [];
  List<Letter> _options = [];
  Map<String, bool> _matched = {};
  bool _isLoading = true;
  bool _isFinished = false;
  String? _draggedLetterId;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final allLetters = repo.letters.toList()..shuffle();
    final selected = allLetters.take(3).toList();

    setState(() {
      _targetLetters = selected;
      _options = selected.toList()..shuffle();
      _matched = {for (var l in selected) l.id: false};
      _isLoading = false;
      _isFinished = false;
    });
  }

  void _onDragAccepted(String shadowId, Letter draggedLetter) {
    if (shadowId == draggedLetter.id) {
      setState(() => _matched[shadowId] = true);
      ref.read(audioServiceProvider).playVoice(draggedLetter.soundAudio, force: true);

      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'letter_shadow_game',
          contentId: 'letters',
          kind: 'letter',
          attempts: 3,
          correct: 3,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters')),
              title: const Text('طابق الحروف', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _isFinished 
                  ? _buildResult() 
                  : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('اسحب الحرف وضعه على ظله', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _targetLetters.map((letter) {
            final isMatched = _matched[letter.id] ?? false;
            return DragTarget<Letter>(
              onAcceptWithDetails: (details) => _onDragAccepted(letter.id, details.data),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: isMatched ? Colors.green.shade100 : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isMatched ? Colors.green : Colors.white, width: 3),
                  ),
                  child: Center(
                    child: isMatched 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 60)
                      : Text(letter.character, style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((letter) {
            final isUsed = _matched[letter.id] == true;
            if (isUsed) return const SizedBox(width: 80, height: 80);

            return Draggable<Letter>(
              data: letter,
              onDragStarted: () => setState(() => _draggedLetterId = letter.id),
              onDragEnd: (_) => setState(() => _draggedLetterId = null),
              onDraggableCanceled: (_, __) => setState(() => _draggedLetterId = null),
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              ),
              childWhenDragging: _draggedLetterId == letter.id ? const SizedBox(width: 80, height: 80) : null, // شيل الشكل خالص وهو بيتسحب
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Center(child: Text(letter.character, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () { setState(() => _isLoading = true); _initGame(); }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/letters'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/professions_choice_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profession_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/floating.dart';
import '../../../core/animations/star_burst.dart';

class ProfessionsChoiceGame extends ConsumerStatefulWidget {
  const ProfessionsChoiceGame({super.key});
  @override
  ConsumerState<ProfessionsChoiceGame> createState() => _ProfessionsChoiceGameState();
}

class _ProfessionsChoiceGameState extends ConsumerState<ProfessionsChoiceGame> {
  static const List<ProfessionItem> professions = [
    ProfessionItem(id: 'carpenter', name: 'نَجَّار', emoji: '👨‍🔧', toolId: 'saw'),
    ProfessionItem(id: 'doctor', name: 'طَبِيب', emoji: '👨‍⚕️', toolId: 'stethoscope'),
    ProfessionItem(id: 'teacher', name: 'مُعَلِّم', emoji: '👨‍🏫', toolId: 'book'),
    ProfessionItem(id: 'chef', name: 'طَبَّاخ', emoji: '👨‍🍳', toolId: 'pan'),
    ProfessionItem(id: 'pilot', name: 'طَيَّار', emoji: '👨‍✈️', toolId: 'plane'),
    ProfessionItem(id: 'farmer', name: 'فَلَّاح', emoji: '👨‍🌾', toolId: 'tractor'),
    ProfessionItem(id: 'firefighter', name: 'رَجُل إِطْفَاء', emoji: '👨‍🚒', toolId: 'firetruck'),
    ProfessionItem(id: 'police', name: 'شُرْطِي', emoji: '👮', toolId: 'badge'),
    ProfessionItem(id: 'engineer', name: 'مُهَنْدِس', emoji: '👷', toolId: 'helmet'),
    ProfessionItem(id: 'artist', name: 'رَسَّام', emoji: '👨‍🎨', toolId: 'palette'),
    ProfessionItem(id: 'scientist', name: 'عَالِم', emoji: '👨‍🔬', toolId: 'microscope'),
    ProfessionItem(id: 'baker', name: 'خَبَّاز', emoji: '🥖', toolId: 'bread'),
  ];

  static const Map<String, ToolItem> allTools = {
    'saw': ToolItem(id: 'saw', name: 'مِنْشَار', emoji: '🪚'),
    'stethoscope': ToolItem(id: 'stethoscope', name: 'سَمَّاعَة', emoji: '🩺'),
    'book': ToolItem(id: 'book', name: 'كِتَاب', emoji: '📚'),
    'pan': ToolItem(id: 'pan', name: 'مِقْلَاة', emoji: '🍳'),
    'plane': ToolItem(id: 'plane', name: 'طَائِرَة', emoji: '✈️'),
    'tractor': ToolItem(id: 'tractor', name: 'جَرَّارَة', emoji: '🚜'),
    'firetruck': ToolItem(id: 'firetruck', name: 'عَرَبَة إِطْفَاء', emoji: '🚒'),
    'badge': ToolItem(id: 'badge', name: 'شَارَة', emoji: '🛡️'),
    'helmet': ToolItem(id: 'helmet', name: 'خُوذَة', emoji: '⛑️'),
    'palette': ToolItem(id: 'palette', name: 'لَوْحَة أَلْوَان', emoji: '🎨'),
    'microscope': ToolItem(id: 'microscope', name: 'مِجْهَر', emoji: '🔬'),
    'bread': ToolItem(id: 'bread', name: 'خُبْز', emoji: '🥖'),
  };

  int _currentIndex = 0;
  List<String> _options = [];
  String? _wrongId;
  String? _okId;
  bool _isFinished = false;
  int _wrongAttempts = 0;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _initRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/professions');
    });
  }

  void _initRound() {
    final profession = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice('professions/q_${profession.id}', force: true);
    final otherTools = allTools.keys.where((k) => k != profession.toolId).toList()..shuffle();
    setState(() {
      _options = [profession.toolId, ...otherTools.take(2)]..shuffle();
      _okId = null;
      _wrongId = null;
      _locked = false;
    });
  }

  void _onTapTool(String toolId) async {
    if (_locked) return;
    final profession = professions[_currentIndex];
    if (toolId == profession.toolId) {
      setState(() { _okId = toolId; _locked = true; });
      ref.read(audioServiceProvider).playSequence(['instructions/right', 'tools/$toolId']);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (_currentIndex < professions.length - 1) {
        setState(() { _currentIndex++; });
        _initRound();
      } else {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'professions_choice_game',
          contentId: 'professions',
          kind: 'profession',
          attempts: professions.length + _wrongAttempts,
          correct: professions.length,
          stars: _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 3 ? 2 : 1),
        );
      }
    } else {
      setState(() { _wrongId = toolId; _wrongAttempts++; });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() => _wrongId = null);
    }
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profession = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: Text('اختيار الأداة (${_currentIndex + 1}/${professions.length})', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(profession),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard(ProfessionItem profession) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Text('مَا هِيَ الأَدَاة الَّتِي يَسْتَخْدِمُهَا؟', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
        ),
        const SizedBox(height: 24),
        Floating(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))]),
            child: Column(
              children: [
                Text(profession.emoji, style: const TextStyle(fontSize: 120)),
                const SizedBox(height: 8),
                Text(profession.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
              ],
            ),
          ),
        ),
        const Spacer(),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _options.map((toolId) {
            final tool = allTools[toolId]!;
            final isOk = toolId == _okId;
            final isWrong = toolId == _wrongId;
            return GestureDetector(
              onTap: () => _onTapTool(toolId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 110, height: 130,
                decoration: BoxDecoration(
                  color: isOk ? Colors.green.shade100 : (isWrong ? Colors.orange.shade100 : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isOk ? Colors.green : (isWrong ? Colors.orange : Colors.grey.shade300), width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tool.emoji, style: const TextStyle(fontSize: 60)),
                    const SizedBox(height: 8),
                    Text(tool.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isOk ? Colors.green : (isWrong ? Colors.orange : Colors.black87))),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildResult() {
    final stars = _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 3 ? 2 : 1);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarBurst(stars: stars),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(stars, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () {
                setState(() { _currentIndex = 0; _isFinished = false; _wrongAttempts = 0; });
                _initRound();
              }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/professions_drag_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profession_item.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';

class ProfessionsDragGame extends ConsumerStatefulWidget {
  const ProfessionsDragGame({super.key});
  @override
  ConsumerState<ProfessionsDragGame> createState() => _ProfessionsDragGameState();
}

class _ProfessionsDragGameState extends ConsumerState<ProfessionsDragGame> {
  static const List<ProfessionItem> professions = [
    ProfessionItem(id: 'carpenter', name: 'نَجَّار', emoji: '👨‍🔧', toolId: 'saw'),
    ProfessionItem(id: 'doctor', name: 'طَبِيب', emoji: '👨‍⚕️', toolId: 'stethoscope'),
    ProfessionItem(id: 'teacher', name: 'مُعَلِّم', emoji: '👨‍🏫', toolId: 'book'),
    ProfessionItem(id: 'chef', name: 'طَبَّاخ', emoji: '👨‍🍳', toolId: 'pan'),
    ProfessionItem(id: 'pilot', name: 'طَيَّار', emoji: '👨‍✈️', toolId: 'plane'),
    ProfessionItem(id: 'farmer', name: 'فَلَّاح', emoji: '👨‍🌾', toolId: 'tractor'),
    ProfessionItem(id: 'firefighter', name: 'رَجُل إِطْفَاء', emoji: '👨‍🚒', toolId: 'firetruck'),
    ProfessionItem(id: 'police', name: 'شُرْطِي', emoji: '👮', toolId: 'badge'),
    ProfessionItem(id: 'engineer', name: 'مُهَنْدِس', emoji: '👷', toolId: 'helmet'),
    ProfessionItem(id: 'artist', name: 'رَسَّام', emoji: '👨‍🎨', toolId: 'palette'),
    ProfessionItem(id: 'scientist', name: 'عَالِم', emoji: '👨‍🔬', toolId: 'microscope'),
    ProfessionItem(id: 'baker', name: 'خَبَّاز', emoji: '🥖', toolId: 'bread'),
  ];

  static const Map<String, ToolItem> allTools = {
    'saw': ToolItem(id: 'saw', name: 'مِنْشَار', emoji: '🪚'),
    'stethoscope': ToolItem(id: 'stethoscope', name: 'سَمَّاعَة', emoji: '🩺'),
    'book': ToolItem(id: 'book', name: 'كِتَاب', emoji: '📚'),
    'pan': ToolItem(id: 'pan', name: 'مِقْلَاة', emoji: '🍳'),
    'plane': ToolItem(id: 'plane', name: 'طَائِرَة', emoji: '✈️'),
    'tractor': ToolItem(id: 'tractor', name: 'جَرَّارَة', emoji: '🚜'),
    'firetruck': ToolItem(id: 'firetruck', name: 'عَرَبَة إِطْفَاء', emoji: '🚒'),
    'badge': ToolItem(id: 'badge', name: 'شَارَة', emoji: '🛡️'),
    'helmet': ToolItem(id: 'helmet', name: 'خُوذَة', emoji: '⛑️'),
    'palette': ToolItem(id: 'palette', name: 'لَوْحَة أَلْوَان', emoji: '🎨'),
    'microscope': ToolItem(id: 'microscope', name: 'مِجْهَر', emoji: '🔬'),
    'bread': ToolItem(id: 'bread', name: 'خُبْز', emoji: '🥖'),
  };

  int _currentIndex = 0;
  List<String> _options = [];
  bool _isFinished = false;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _initRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/match');
    });
  }

  void _initRound() {
    final profession = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice('professions/q_${profession.id}', force: true);
    final others = allTools.keys.where((k) => k != profession.toolId).toList()..shuffle();
    setState(() {
      _options = [profession.toolId, ...others.take(2)]..shuffle();
      _locked = false;
    });
  }

  void _onDragAccepted(String toolId) async {
    if (_locked) return;
    final profession = professions[_currentIndex];
    if (toolId == profession.toolId) {
      setState(() => _locked = true);
      ref.read(audioServiceProvider).playSequence(['instructions/right', 'tools/$toolId']);
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (_currentIndex < professions.length - 1) {
        setState(() { _currentIndex++; });
        _initRound();
      } else {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'professions_drag_game',
          contentId: 'professions',
          kind: 'profession',
          attempts: professions.length,
          correct: professions.length,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: Text('توصيل المهن (${_currentIndex + 1}/${professions.length})', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(p),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard(ProfessionItem profession) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Text('اسْحَب الأَدَاة الصَّحِيحَة إِلَى المُهِمَّة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
        ),
        const SizedBox(height: 24),
        
        DragTarget<String>(
          onAcceptWithDetails: (details) => _onDragAccepted(details.data),
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 180, height: 220, // الارتفاع ده مهم عشان نمنع الشريط الأصفر
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange, width: 5),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(profession.emoji, style: const TextStyle(fontSize: 90)),
                  const SizedBox(height: 8),
                  Text(profession.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                ],
              ),
            );
          },
        ),
        const Spacer(),
        
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _options.map((toolId) {
            final tool = allTools[toolId]!;
            return Draggable<String>(
              data: toolId,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 100, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tool.emoji, style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 8),
                      Text(tool.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              childWhenDragging: const SizedBox(width: 100, height: 120),
              child: Container(
                width: 100, height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tool.emoji, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(tool.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber))),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: () {
                setState(() { _currentIndex = 0; _isFinished = false; });
                _initRound();
              }, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/professions_learn.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../core/animations/floating.dart';

class ProfessionsLearn extends ConsumerStatefulWidget {
  const ProfessionsLearn({super.key});

  @override
  ConsumerState<ProfessionsLearn> createState() => _ProfessionsLearnState();
}

class _ProfessionsLearnState extends ConsumerState<ProfessionsLearn> {
  static const List<Map<String, String>> professions = [
    {'name': 'نَجَّار', 'emoji': '👨‍🔧', 'tool': 'مِنْشَار', 'toolEmoji': '🪚', 'audio': 'professions/carpenter'},
    {'name': 'طَبِيب', 'emoji': '👨‍⚕️', 'tool': 'سَمَّاعَة', 'toolEmoji': '🩺', 'audio': 'professions/doctor'},
    {'name': 'مُعَلِّم', 'emoji': '👨‍🏫', 'tool': 'كِتَاب', 'toolEmoji': '📚', 'audio': 'professions/teacher'},
    {'name': 'طَبَّاخ', 'emoji': '👨‍🍳', 'tool': 'مِقْلَاة', 'toolEmoji': '🍳', 'audio': 'professions/chef'},
    {'name': 'طَيَّار', 'emoji': '👨‍✈️', 'tool': 'طَائِرَة', 'toolEmoji': '✈️', 'audio': 'professions/pilot'},
    {'name': 'فَلَّاح', 'emoji': '👨‍🌾', 'tool': 'جَرَّارَة', 'toolEmoji': '🚜', 'audio': 'professions/farmer'},
    {'name': 'رَجُل إِطْفَاء', 'emoji': '👨‍🚒', 'tool': 'عَرَبَة إِطْفَاء', 'toolEmoji': '🚒', 'audio': 'professions/firefighter'},
    {'name': 'شُرْطِي', 'emoji': '👮', 'tool': 'شَارَة', 'toolEmoji': '🛡️', 'audio': 'professions/police'},
    {'name': 'مُهَنْدِس', 'emoji': '👷', 'tool': 'خُوذَة', 'toolEmoji': '⛑️', 'audio': 'professions/engineer'},
    {'name': 'رَسَّام', 'emoji': '👨‍🎨', 'tool': 'لَوْحَة أَلْوَان', 'toolEmoji': '🎨', 'audio': 'professions/artist'},
    {'name': 'عَالِم', 'emoji': '👨‍🔬', 'tool': 'مِجْهَر', 'toolEmoji': '🔬', 'audio': 'professions/scientist'},
    {'name': 'خَبَّاز', 'emoji': '👨‍🍳', 'tool': 'خُبْز', 'toolEmoji': '🥖', 'audio': 'professions/baker'},
  ];

  int _currentIndex = 0;

  void _speak() {
    final p = professions[_currentIndex];
    ref.read(audioServiceProvider).playVoice(p['audio']!, force: true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = professions[_currentIndex];
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('تعلّم المهن', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BounceIn(
                    key: ValueKey(_currentIndex),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Floating(child: Text(p['emoji']!, style: const TextStyle(fontSize: 100))),
                          const SizedBox(height: 8),
                          Text(p['name']!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                          const SizedBox(height: 16),
                          const Text('يَسْتَخْدِمُ:', style: TextStyle(fontSize: 20, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p['toolEmoji']!, style: const TextStyle(fontSize: 60)),
                              const SizedBox(width: 16),
                              Text(p['tool']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          IconButton.filled(iconSize: 40, onPressed: _speak, icon: const Icon(Icons.volume_up)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                    iconSize: 48,
                    onPressed: () { setState(() { _currentIndex = (_currentIndex - 1 + professions.length) % professions.length; }); _speak(); },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('${_currentIndex + 1} / ${professions.length}', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                    iconSize: 48,
                    onPressed: () { setState(() { _currentIndex = (_currentIndex + 1) % professions.length; }); _speak(); },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/professions_menu.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/animations/bounce_in.dart';

class ProfessionsMenu extends StatelessWidget {
  const ProfessionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('المهن', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BounceIn(
                      child: KidsButton(
                        color: Colors.green.shade400,
                        onTap: () => context.push('/professions/learn'),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school, size: 60, color: Colors.white),
                            SizedBox(height: 8),
                            Text('تعلّم المهن', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BounceIn(
                      child: KidsButton(
                        color: Colors.blue.shade400,
                        onTap: () => context.push('/professions/choice'),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app, size: 60, color: Colors.white),
                            SizedBox(height: 8),
                            Text('اختيار الأداة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BounceIn(
                      child: KidsButton(
                        color: Colors.orange.shade400,
                        onTap: () => context.push('/professions/drag'),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.drag_indicator, size: 60, color: Colors.white),
                            SizedBox(height: 8),
                            Text('توصيل الأداة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/games/presentation/shape_shadow_game.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/star_burst.dart';
import '../../../data/models/shape_item.dart';
import '../../shapes/presentation/shapes_screen.dart';

class ShapeShadowGame extends ConsumerStatefulWidget {
  const ShapeShadowGame({super.key});

  @override
  ConsumerState<ShapeShadowGame> createState() => _ShapeShadowGameState();
}

class _ShapeShadowGameState extends ConsumerState<ShapeShadowGame> {
  List<ShapeItem> _targetShapes = [];
  List<ShapeItem> _options = [];
  Map<String, bool> _matched = {};
  bool _isFinished = false;
  String? _draggedShapeId;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // نختار 3 أشكال عشوائية
    final allShapes = ShapesScreen.shapes.toList()..shuffle();
    final selected = allShapes.take(3).toList();

    setState(() {
      _targetShapes = selected;
      _options = selected.toList()..shuffle();
      _matched = {for (var s in selected) s.id: false};
      _isFinished = false;
    });
  }

  void _onDragAccepted(String shadowId, ShapeItem draggedShape) {
    if (shadowId == draggedShape.id) {
      setState(() {
        _matched[shadowId] = true;
      });
      ref.read(audioServiceProvider).playVoice('shapes/${draggedShape.id}', force: true);

      // التحقق من الفوز
      if (_matched.values.every((v) => v == true)) {
        setState(() => _isFinished = true);
        ref.read(progressRepositoryProvider).recordResult(
          activityId: 'shape_shadow_game',
          contentId: 'shapes',
          kind: 'shape',
          attempts: 3,
          correct: 3,
          stars: 3,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حاول مرة أخرى!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 36, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/shapes')),
              title: const Text('طابق الأشكال', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            Expanded(
              child: _isFinished ? _buildResult() : _buildGameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('اسحب الشكل الملون وضعه على ظله', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        // الأشكال المفرغة (الأهداف)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _targetShapes.map((shape) {
            final isMatched = _matched[shape.id] ?? false;
            return DragTarget<ShapeItem>(
              onAcceptWithDetails: (details) => _onDragAccepted(shape.id, details.data),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: isMatched ? Colors.green.shade100 : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isMatched ? Colors.green : Colors.white, width: 3),
                  ),
                  child: Center(
                    child: isMatched 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 60)
                      : SizedBox(
                          width: 70, height: 70,
                          child: CustomPaint(painter: ShapePainter(shape.type, Colors.grey.shade400)), // ظل رمادي
                        ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
        
        // الأشكال الملونة (اللي بتتسحب)
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: _options.map((shape) {
            final isUsed = _matched[shape.id] == true;
            if (isUsed) return const SizedBox(width: 80, height: 80);

            return Draggable<ShapeItem>(
              data: shape,
              onDragStarted: () => setState(() => _draggedShapeId = shape.id),
              onDragEnd: (_) => setState(() => _draggedShapeId = null),
              onDraggableCanceled: (_, __) => setState(() => _draggedShapeId = null),
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: 80, height: 80,
                  child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
                ),
              ),
              childWhenDragging: _draggedShapeId == shape.id ? const SizedBox(width: 80, height: 80) : null,
              child: SizedBox(
                width: 80, height: 80,
                child: CustomPaint(painter: ShapePainter(shape.type, Colors.blue.shade400)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StarBurst(stars: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (_) => const Icon(Icons.star, size: 80, color: Colors.amber)),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filled(iconSize: 64, onPressed: _initGame, icon: const Icon(Icons.replay)),
              const SizedBox(width: 32),
              IconButton.filled(iconSize: 64, onPressed: () => context.go('/shapes'), icon: const Icon(Icons.check)),
            ],
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/home/home_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/animations/floating.dart';
import '../../core/widgets/kids_background.dart';
import '../../core/widgets/kids_button.dart';
import '../parent_zone/hold_to_open.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // معرفة إذا كانت الشاشة عرضية أم طولية
    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    // تصميم الزر
    Widget buildMenuButton(String title, String letter, String route, Color color) {
      return Floating(
        child: BounceIn(
          child: KidsButton(
            width: isLandscape ? 220 : 180,
            height: isLandscape ? 160 : 160,
            color: color,
            onTap: () => context.go(route),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(letter, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: KidsBackground(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // صورة البومة
                      Floating(
                        child: BounceIn(
                          child: Container(
                            width: isLandscape ? 120 : 140,
                            height: isLandscape ? 120 : 140,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/ui/mascot.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 16 : 24),
                      // العنوان
                      const Floating(
                        child: BounceIn(
                          child: Text(
                            'أول خطوة',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [Shadow(color: Color(0xFF00796B), offset: Offset(4, 4), blurRadius: 0)],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 32 : 48),
                      
                      // الأزرار (عرضية أو طولية)
                      if (isLandscape)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 32,
                          runSpacing: 24,
                          children: [
                            Floating(child: buildMenuButton('الحروف', 'أ', '/letters', const Color(0xFFFF7043))),
                            Floating(child: buildMenuButton('الأرقام', '١', '/numbers', const Color(0xFF29B6F6))),
                            Floating(child: buildMenuButton('الألوان', '🎨', '/colors', const Color(0xFF9C27B0))),
                            Floating(child: buildMenuButton('الأشكال', '🔺', '/shapes', const Color(0xFF4CAF50))),
                            Floating(child: buildMenuButton('التلوين', '🖍️', '/coloring', const Color(0xFFFF9800))),
                            Floating(child: buildMenuButton('المهن', '👷', '/professions', const Color(0xFF607D8B))),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Floating(child: buildMenuButton('الحروف', 'أ', '/letters', const Color(0xFFFF7043))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الأرقام', '١', '/numbers', const Color(0xFF29B6F6))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الألوان', '🎨', '/colors', const Color(0xFF9C27B0))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('الأشكال', '🔺', '/shapes', const Color(0xFF4CAF50))),
                            const SizedBox(height: 24),
                            Floating(child: buildMenuButton('التلوين', '🖍️', '/coloring', const Color(0xFFFF9800))),
                            Floating(child: buildMenuButton('المهن', '👷', '/professions', const Color(0xFF607D8B))),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // الحقوق في الأسفل
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Powered by Safyeldin Abdo © Ghinax',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ),
            // زر القفل
            PositionedDirectional(
              top: 10,
              end: 10,
              child: SafeArea(
                child: HoldToOpen(
                  onOpen: () => context.push('/parent-gate'),
                ),
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.emoji_events, color: Colors.amber),
                      onPressed: () => context.push('/rewards'),
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () => context.push('/about'),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
import '../../../core/animations/bounce_in.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/widgets/animated_image.dart'; // 👈 الصورة المتحركة

class LetterLessonScreen extends ConsumerStatefulWidget {
  const LetterLessonScreen({super.key, required this.letterId});
  final String letterId;
  @override
  ConsumerState<LetterLessonScreen> createState() => _LetterLessonScreenState();
}

class _LetterLessonScreenState extends ConsumerState<LetterLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  Future<void> _speak() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return;
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
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/letters')),
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) {
                  final letter = r.letterById(widget.letterId);
                  if (letter == null) return const Center(child: Text('الحرف غير موجود', style: TextStyle(color: Colors.white)));
                  return _LessonBody(repo: r, letter: letter, onReplay: _speak);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({required this.repo, required this.letter, required this.onReplay});
  final ContentRepository repo;
  final Letter letter;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final word = repo.wordById(letter.primaryWordId);
    final next = repo.nextOf(letter);
    final prev = repo.previousOf(letter);

    // استخدام SingleChildScrollView عشان نمنع مشكلة الأصفر والأسود
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة الحرف
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                children: [
                  BounceIn(
                    child: Text(letter.character, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Color(0xFF00796B), height: 1.0)),
                  ),
                  Text(letter.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final k in ['isolated', 'initial', 'medial', 'final'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(letter.forms[k] ?? '', style: const TextStyle(fontSize: 32, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // بطاقة الكلمة والصورة
            if (word != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedImage(
                      imagePath: 'assets/images/${word.image}.png',
                      emoji: word.emoji,
                      onTap: onReplay,
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        Text(word.textVowelled, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: onReplay,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                            child: const Icon(Icons.volume_up, size: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            
            // أزرار الأنشطة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KidsButton(
                  width: 70,
                  height: 70,
                  color: Colors.purple.shade400,
                  onTap: () => context.push('/letters/${letter.id}/recognize'),
                  child: const Icon(Icons.touch_app, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 12),
                KidsButton(
                  width: 70,
                  height: 70,
                  color: Colors.amber.shade600,
                  onTap: () => context.push('/letters/${letter.id}/match'),
                  child: const Icon(Icons.image, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 12),
                KidsButton(
                  width: 70,
                  height: 70,
                  color: Colors.orange.shade600,
                  onTap: () => context.push('/letters/${letter.id}/drag'),
                  child: const Icon(Icons.drag_indicator, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 12),
                KidsButton(
                  width: 70,
                  height: 70,
                  color: Colors.teal.shade400,
                  onTap: () => context.push('/letters/${letter.id}/trace'),
                  child: const Icon(Icons.draw, size: 32, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // أزرار التنقل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                  iconSize: 40,
                  onPressed: prev == null ? null : () => context.pushReplacement('/letters/${prev.id}'),
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                  iconSize: 40,
                  onPressed: next == null ? null : () => context.pushReplacement('/letters/${next.id}'),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';

class LettersScreen extends ConsumerWidget {
  const LettersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الحروف', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) => LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 900 ? 6 : (constraints.maxWidth > 600 ? 4 : 3);
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: r.letters.length,
                      itemBuilder: (context, i) {
                        final l = r.letters[i];
                        final earnedStars = stars[l.id] ?? 0;
                        
                        // شرط القفل: أول حرف مفتوح، والباقي بيتفتح لو الحرف اللي قبله متعلم (3 نجوم)
                        bool isUnlocked = i == 0;
                        if (i > 0) {
                          final prevLetter = r.letters[i - 1];
                          final prevStars = stars[prevLetter.id] ?? 0;
                          if (prevStars >= 1) { // ممكن نغير الرقم لـ 3 لو عايزه أصعب
                            isUnlocked = true;
                          }
                        }
                        
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: KidsButton(
                                color: isUnlocked ? Colors.white : Colors.grey.shade300,
                                onTap: isUnlocked ? () => context.push('/letters/${l.id}') : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('أكمل الحرف السابق أولاً!'), duration: Duration(seconds: 1)),
                                  );
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      l.character, 
                                      style: TextStyle(
                                        fontSize: 60, 
                                        fontWeight: FontWeight.bold, 
                                        color: isUnlocked ? const Color(0xFF00796B) : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (!isUnlocked)
                              const Positioned.fill(
                                child: Center(child: Icon(Icons.lock, size: 40, color: Colors.grey)),
                              ),
                            if (earnedStars > 0)
                              const PositionedDirectional(top: 4, end: 4, child: Icon(Icons.star, color: Colors.amber, size: 28)),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/numbers/domain/counting_state.dart`
```dart
class CountingState {
  CountingState(this.total);
  final int total;
  final Set<int> counted = {};

  int tap(int index) {
    if (counted.contains(index)) return 0;
    counted.add(index);
    return counted.length;
  }

  bool get complete => counted.length == total;
  void reset() => counted.clear();
}
```
## 📄 `lib/features/numbers/presentation/number_lesson_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';
import '../domain/counting_state.dart';

class NumberLessonScreen extends ConsumerStatefulWidget {
  const NumberLessonScreen({super.key, required this.numberId});
  final String numberId;
  @override
  ConsumerState<NumberLessonScreen> createState() => _NumberLessonScreenState();
}

class _NumberLessonScreenState extends ConsumerState<NumberLessonScreen> {
  CountingState? _counting;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final repo = await ref.read(contentRepositoryProvider.future);
    if (!mounted) return;
    final n = repo.numberById(widget.numberId);
    if (n == null) return;
    setState(() { _counting = CountingState(n.value); _done = false; });
    ref.read(audioServiceProvider).playVoice(n.audio, force: true);
  }

  Future<void> _onTapObject(int index) async {
    final repo = await ref.read(contentRepositoryProvider.future);
    final c = _counting;
    final n = repo.numberById(widget.numberId);
    if (c == null || n == null) return;
    
    final spoken = c.tap(index);
    if (spoken == 0) return;
    setState(() {});
    
    // تشغيل صوت الرقم اللي اتعد
    final item = repo.numberByValue(spoken);
    if (item != null) ref.read(audioServiceProvider).playVoice(item.audio, force: true);

    if (c.complete && !_done) {
      setState(() => _done = true);
      ref.read(progressRepositoryProvider).recordResult(
            activityId: 'count_${n.id}',
            contentId: n.id,
            kind: 'number',
            attempts: 1,
            correct: 1,
            stars: 3,
          );
    }
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(contentRepositoryProvider);
    final style = ref.watch(settingsProvider).numeralStyle;

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.apps, color: Colors.white), onPressed: () => context.go('/numbers')),
              title: const Text('درس الرقم', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) {
                  final n = r.numberById(widget.numberId);
                  final c = _counting;
                  if (n == null || c == null) return const Center(child: CircularProgressIndicator(color: Colors.white));
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // بطاقة الرقم
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                          ),
                          child: Column(
                            children: [
                              BounceIn(child: Text(formatNumber(n.value, style), style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Color(0xFF29B6F6), height: 1.0))),
                              Text(n.nameText, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        
                        // منطقة العد (لو الرقم أكبر من 20 هنكتفي بالرسالة عشان الشاشة متضربش)
                        if (n.value > 0 && n.value <= 20)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (var i = 0; i < n.value; i++)
                                    GestureDetector(
                                      onTap: () => _onTapObject(i),
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 200),
                                        opacity: c.counted.contains(i) ? 1.0 : 0.5,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: c.counted.contains(i) ? Colors.green.shade100 : Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: c.counted.contains(i) ? Colors.green : Colors.grey.shade400, width: 3),
                                          ),
                                          child: Center(
                                            child: c.counted.contains(i) 
                                              ? const Icon(Icons.check, color: Colors.green, size: 30)
                                              : const Icon(Icons.apple, color: Colors.redAccent, size: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        else if (n.value > 20)
                          const Text('رَقَم كَبِير!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))
                        else 
                          const Text('صِفْر (لَا شَيْء)', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                        
                        const Spacer(),
                        if (_done) const Icon(Icons.star, size: 80, color: Colors.amber),
                        const Spacer(),
                        // أزرار التحكم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            KidsButton(width: 80, height: 80, color: Colors.blue.shade400, onTap: _start, child: const Icon(Icons.replay, size: 40, color: Colors.white)),
                            const SizedBox(width: 16),
                            KidsButton(width: 80, height: 80, color: Colors.purple.shade400, onTap: () => context.push('/numbers/${n.id}/pick'), child: const Icon(Icons.touch_app, size: 40, color: Colors.white)),
                            const SizedBox(width: 16),
                            KidsButton(width: 80, height: 80, color: Colors.orange.shade400, onTap: () => context.push('/numbers/${n.id}/count_game'), child: const Icon(Icons.filter_9_plus, size: 40, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/numbers/presentation/numbers_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/progress_providers.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/widgets/kids_button.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/utils/arabic_numbers.dart';

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/numbers');
    });
    final repo = ref.watch(contentRepositoryProvider);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final style = ref.watch(settingsProvider).numeralStyle;

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الأرقام', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: repo.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('خطأ: $e', style: const TextStyle(color: Colors.white))),
                data: (r) => LayoutBuilder(
                  builder: (context, constraints) {
                    // شبكة ذكية: 5 أعمدة للموبايل، 8 للتابلت، 10 للكمبيوتر
                    int crossAxisCount = constraints.maxWidth > 1200 ? 10 : (constraints.maxWidth > 800 ? 8 : (constraints.maxWidth > 500 ? 5 : 4));
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: r.numbers.length,
                      itemBuilder: (context, i) {
                        final n = r.numbers[i];
                        final earnedStars = stars[n.id] ?? 0;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: KidsButton(
                                color: const Color(0xFF29B6F6),
                                onTap: () => context.push('/numbers/${n.id}'),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(formatNumber(n.value, style), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                            if (earnedStars > 0)
                              const PositionedDirectional(top: 4, end: 4, child: Icon(Icons.star, color: Colors.amber, size: 24)),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/parent_zone/hold_to_open.dart`
```dart
import 'package:flutter/material.dart';

class HoldToOpen extends StatefulWidget {
  const HoldToOpen({super.key, required this.onOpen, this.duration = const Duration(seconds: 3)});
  final VoidCallback onOpen;
  final Duration duration;
  @override
  State<HoldToOpen> createState() => _HoldToOpenState();
}

class _HoldToOpenState extends State<HoldToOpen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onOpen();
          _controller.reset();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                    strokeWidth: 4,
                  ),
                );
              },
            ),
            const Icon(Icons.lock_outline, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/parent_zone/parent_gate_challenge.dart`
```dart
import 'dart:math';

class ParentGateChallenge {
  ParentGateChallenge({required this.a, required this.b, required this.answer, required this.options});
  final int a, b, answer;
  final List<int> options;

  factory ParentGateChallenge.generate([Random? rng]) {
    final r = rng ?? Random();
    final a = r.nextInt(6) + 4;
    final b = r.nextInt(6) + 4;
    final answer = a * b;
    final options = <int>{answer, answer + 2, answer - 3, answer + 5}.toList()..shuffle(r);
    return ParentGateChallenge(a: a, b: b, answer: answer, options: options);
  }

  bool check(int v) => v == answer;
}
```
## 📄 `lib/features/parent_zone/parent_gate_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/settings/app_settings.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../core/widgets/kids_background.dart';
import '../../providers/parent_providers.dart';
import 'parent_gate_challenge.dart';

class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});
  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  late ParentGateChallenge _challenge = ParentGateChallenge.generate();

  void _pick(int v) {
    if (_challenge.check(v)) {
      ref.read(parentGateProvider.notifier).unlock();
      context.go('/parent');
    } else {
      setState(() => _challenge = ParentGateChallenge.generate());
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.watch(settingsProvider).numeralStyle;
    String f(int n) => formatNumber(n, style);

    return Scaffold(
      body: KidsBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text('منطقة وليّ الأمر', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('للكبار فقط: أجب على السؤال', style: TextStyle(fontSize: 20, color: Colors.white70)),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Text('${f(_challenge.a)} × ${f(_challenge.b)} = ؟', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final o in _challenge.options)
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FilledButton(
                                onPressed: () => _pick(o),
                                child: Text(f(o), style: const TextStyle(fontSize: 28)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('رجوع', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/parent_zone/parent_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/settings/app_settings.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../providers/parent_providers.dart';
import '../../providers/progress_providers.dart';

class ParentScreen extends ConsumerWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final learned = stars.values.where((s) => s > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة وليّ الأمر'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(parentGateProvider.notifier).lock();
            context.go('/');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('مستوى الصوت', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Slider(
            value: settings.voiceVolume,
            onChanged: (v) => ctrl.setVolume(v),
          ),
          const SizedBox(height: 24),
          const Text('شكل الأرقام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<NumeralStyle>(
            segments: const [
              ButtonSegment(value: NumeralStyle.arabicIndic, label: Text('١٢٣')),
              ButtonSegment(value: NumeralStyle.western, label: Text('123')),
            ],
            selected: {settings.numeralStyle},
            onSelectionChanged: (s) => ctrl.setNumerals(s.first),
          ),
          const SizedBox(height: 32),
          Text('تقدم الطفل: $learned عنصر تم تعلمه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('مسح كل التقدم', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('مسح كل التقدم؟'),
                  content: const Text('هل أنت متأكد؟ سيتم حذف كل النجوم والنتائج نهائياً.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('مسح', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(progressRepositoryProvider).resetAll();
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح التقدم')));
              }
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'أول خطوة - الإصدار 1.0.0',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Powered by Safyeldin Abdo © Ghinax',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const Text(
            'الخصوصية: لا يجمع التطبيق أي بيانات شخصية، ولا يتصل بالإنترنت إطلاقاً. يُحفظ التقدم على هذا الجهاز فقط.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```
## 📄 `lib/features/rewards/presentation/rewards_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/progress_providers.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = ref.watch(starsProvider).valueOrNull ?? const {};
    final totalStars = stars.values.fold<int>(0, (sum, s) => sum + s);

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('المكافآت', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: BounceIn(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
                        const SizedBox(height: 24),
                        Text('إجمالي النجوم: $totalStars', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                        const SizedBox(height: 16),
                        const Text('استمر في اللعب لتجمع المزيد!', style: TextStyle(fontSize: 20, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📄 `lib/features/shapes/presentation/shapes_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/kids_background.dart';
import '../../../core/animations/bounce_in.dart';
import '../../../data/models/shape_item.dart';
import '../../../providers/audio_providers.dart';

class ShapesScreen extends ConsumerWidget {
  const ShapesScreen({super.key});

  static const List<ShapeItem> shapes = [
    ShapeItem(id: 'circle', name: 'دَائِرَة', type: ShapeType.circle, emoji: '⭕'),
    ShapeItem(id: 'square', name: 'مُرَبَّع', type: ShapeType.square, emoji: '🟦'),
    ShapeItem(id: 'triangle', name: 'مُثَلَّث', type: ShapeType.triangle, emoji: '🔺'),
    ShapeItem(id: 'rectangle', name: 'مُسْتَطِيل', type: ShapeType.rectangle, emoji: '▬'),
    ShapeItem(id: 'diamond', name: 'مُعَيَّن', type: ShapeType.diamond, emoji: '🔷'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice('instructions/shapes');
    });

    return Scaffold(
      body: KidsBackground(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(iconSize: 40, icon: const Icon(Icons.home, color: Colors.white), onPressed: () => context.go('/')),
              title: const Text('الأشكال', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue.shade400),
                        onPressed: () => context.push('/shapes/game'),
                        icon: const Icon(Icons.videogame_asset, color: Colors.white),
                        label: const Text('لعبة الأشكال', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
                        onPressed: () => context.push('/shapes/shadow_game'),
                        icon: const Icon(Icons.extension, color: Colors.white),
                        label: const Text('طابق الظل', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: shapes.length,
                    itemBuilder: (context, i) {
                      final s = shapes[i];
                      return BounceIn(
                        child: GestureDetector(
                          onTap: () => ref.read(audioServiceProvider).playVoice('shapes/${s.id}', force: true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
                              border: Border.all(color: Colors.blue.shade200, width: 4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 80, height: 80, child: CustomPaint(painter: ShapePainter(s.type, Colors.blue.shade400))),
                                const SizedBox(height: 8),
                                Text(s.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter(this.type, this.color);
  final ShapeType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    switch (type) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
        break;
      case ShapeType.rectangle:
        canvas.drawRect(Rect.fromLTWH(0, h / 4, w, h / 2), paint);
        break;
      case ShapeType.triangle:
        final path = Path()..moveTo(w / 2, 0)..lineTo(w, h)..lineTo(0, h)..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.diamond:
        final path = Path()..moveTo(w / 2, 0)..lineTo(w, h / 2)..lineTo(w / 2, h)..lineTo(0, h / 2)..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```
## 📄 `lib/features/splash/splash_screen.dart`
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/bounce_in.dart';
import '../../core/widgets/kids_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال للشاشة الرئيسية بعد ثانيتين ونصف
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceIn(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ui/mascot.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 100, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const BounceIn(
                child: Text(
                  'أول خطوة',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [Shadow(color: Color(0xFF00796B), offset: Offset(4, 4), blurRadius: 0)],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 24),
              const Text('Powered by Safyeldin Abdo © Ghinax', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/settings/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  try {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  } catch (e) {
    debugPrint('AudioSession init failed: $e');
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const BaytApp(),
  ));
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
## 📄 `lib/providers/parent_providers.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentGate extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;
  void unlock() => state = DateTime.now().add(const Duration(minutes: 5));
  void lock() => state = null;
  bool get isUnlocked {
    final until = state;
    return until != null && DateTime.now().isBefore(until);
  }
}

final parentGateProvider = NotifierProvider<ParentGate, DateTime?>(ParentGate.new);
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
