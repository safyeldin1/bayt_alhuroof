import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../providers/content_providers.dart';
import '../../../core/widgets/kids_background.dart';

class BalloonGameScreen extends ConsumerStatefulWidget {
  const BalloonGameScreen({super.key});

  @override
  ConsumerState<BalloonGameScreen> createState() => _BalloonGameScreenState();
}

class _BalloonGameScreenState extends ConsumerState<BalloonGameScreen> {
  String? _mode;
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == null) {
      return _buildModeSelection();
    }
    return _BalloonGameBoard(mode: _mode!, onBack: () => setState(() => _mode = null));
  }

  Widget _buildModeSelection() {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/'))),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModeButton('حروف', 'أ', Colors.orange, () => setState(() => _mode = 'letters')),
                    _buildModeButton('أرقام', '١', Colors.blue, () => setState(() => _mode = 'numbers')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String title, String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250, height: 250,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(40), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 20, offset: const Offset(0, 10))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 100, color: Colors.white, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _BalloonGameBoard extends ConsumerStatefulWidget {
  const _BalloonGameBoard({required this.mode, required this.onBack});
  final String mode;
  final VoidCallback onBack;

  @override
  ConsumerState<_BalloonGameBoard> createState() => _BalloonGameBoardState();
}

class _BalloonGameBoardState extends ConsumerState<_BalloonGameBoard> {
  int _lives = 3;
  int _score = 0;
  bool _gameOver = false;
  bool _isPaused = true;
  
  List<Map<String, dynamic>> _balloons = [];
  List<Map<String, dynamic>> _particles = []; // للنجوم
  String _targetChar = '';
  String _targetAudio = '';
  late Timer _gameLoop;
  
  final List<String> _lettersPool = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'];
  final List<String> _numbersPool = ['١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', '١٠'];
  
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.pink];

  @override
  void initState() {
    super.initState();
    _loadDataAndStart();
    
    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || _gameOver) return;
      
      // بنحدث الجليتر (النجوم) حتى لو اللعبة متوقفة
      setState(() {
        for (var p in _particles) {
          p['y'] -= 2.5; // بتطير لفوق بسرعة
          p['x'] += p['dx'];
          p['opacity'] -= 0.02;
        }
        _particles.removeWhere((p) => p['opacity'] <= 0);
      });

      // لو اللعبة متوقفة، البلالين مش بتتحرك
      if (_isPaused) return;
      
      setState(() {
        for (var b in _balloons) {
          b['y'] -= 1.5;
          b['x'] += b['dx'];
          if (b['x'] < 0 || b['x'] > 300) b['dx'] *= -1;
        }
        _balloons.removeWhere((b) => b['y'] < -100);
        if (Random().nextInt(100) < 1) _spawnBalloon();
      });
    });
  }

  Future<void> _loadDataAndStart() async {
    await ref.read(contentRepositoryProvider.future);
    if (!mounted) return;
    _startNewRound();
  }

  void _startNewRound() {
    final pool = widget.mode == 'letters' ? _lettersPool : _numbersPool;
    _targetChar = pool[Random().nextInt(pool.length)];
    
    final repo = ref.read(contentRepositoryProvider).valueOrNull;
    if (repo != null) {
      if (widget.mode == 'letters') {
        final letter = repo.letters.firstWhere((l) => l.character == _targetChar, orElse: () => repo.letters.first);
        _targetAudio = letter.nameAudio;
      } else {
        const arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
        final englishDigits = ['0','1','2','3','4','5','6','7','8','9'];
        String englishChar = _targetChar;
        for (int i = 0; i < arabicDigits.length; i++) {
          englishChar = englishChar.replaceAll(arabicDigits[i], englishDigits[i]);
        }
        final numIndex = int.tryParse(englishChar) ?? 1;
        final number = repo.numberByValue(numIndex) ?? repo.numbers.first;
        _targetAudio = number.audio;
      }
    }
    
    setState(() => _isPaused = true);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_targetAudio.isNotEmpty) {
        await ref.read(audioServiceProvider).playVoice(_targetAudio, force: true);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) setState(() => _isPaused = false);
      } else {
        setState(() => _isPaused = false);
      }
    });
  }

  void _spawnBalloon() {
    final pool = widget.mode == 'letters' ? _lettersPool : _numbersPool;
    final random = Random();
    final char = random.nextBool() ? _targetChar : pool[random.nextInt(pool.length)];
    
    _balloons.add({
      'char': char,
      'x': random.nextDouble() * 250 + 20,
      'y': 600.0,
      'dx': random.nextBool() ? 0.5 : -0.5,
      'color': _colors[random.nextInt(_colors.length)],
    });
  }

  // تفجير النجوم في نفس مكان البالونة
  void _createExplosion(double x, double y) {
    final random = Random();
    for (int i = 0; i < 15; i++) {
      _particles.add({
        'x': x + 40,
        'y': y + 40,
        'dx': random.nextDouble() * 8 - 4, // حركة عشوائية أوسع
        'opacity': 1.0,
      });
    }
  }

  void _onBalloonTap(Map<String, dynamic> balloon) async {
    if (_isPaused) return;

    if (balloon['char'] == _targetChar) {
      // 1. وقف اللعبة فوراً
      setState(() {
        _isPaused = true;
        _score += 10;
      });
      
      // 2. طلع النجوم (الجليتر) فوراً
      _createExplosion(balloon['x'], balloon['y']);
      
      // 3. شيل البالونة
      setState(() {
        _balloons.remove(balloon);
      });
      
      // 4. استنى ثانية عشان الجليتر يبان (اللعبة واقفة والجليتر بيتحرك في الخلفية)
      await Future.delayed(const Duration(milliseconds: 800));
      
      // 5. شغل الصوت
      await ref.read(audioServiceProvider).playVoice('instructions/right', force: true);
      
      // 6. استنى شوية وبعدين ابدأ الجولة الجديدة
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) _startNewRound();
      
    } else {
      setState(() {
        _lives--;
        if (_lives <= 0) _gameOver = true;
      });
      await ref.read(audioServiceProvider).playVoice('instructions/try_again', force: true);
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('هل تريد الخروج؟', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('هل أنت متأكد أنك تريد الخروج من اللعبة والعودة للشاشة السابقة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('لا، أكمل اللعب', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onBack();
              },
              child: const Text('نعم، خروج', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _gameLoop.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            
            ..._balloons.map((b) {
              return Positioned(
                left: b['x'],
                top: b['y'],
                child: GestureDetector(
                  onTap: () => _onBalloonTap(b),
                  child: Container(
                    width: 100, height: 120,
                    decoration: BoxDecoration(
                      color: b['color'],
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b['char'], style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold)),
                        Container(width: 2, height: 25, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            
            // النجوم (الجليتر)
            ..._particles.map((p) {
              return Positioned(
                left: p['x'],
                top: p['y'],
                child: Opacity(
                  opacity: p['opacity'],
                  child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 40), // شكل جليتر
                ),
              );
            }).toList(),
            
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: _confirmExit,
                        ),
                        Row(children: [const Icon(Icons.favorite, color: Colors.red), Text(' $_lives', style: const TextStyle(color: Colors.white, fontSize: 20))]),
                        GestureDetector(
                          onTap: () => ref.read(audioServiceProvider).playVoice(_targetAudio, force: true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                const Icon(Icons.volume_up, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(_targetChar, style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Row(children: [const Icon(Icons.star, color: Colors.amber), Text(' $_score', style: const TextStyle(color: Colors.white, fontSize: 20))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            if (_gameOver) _buildGameOver(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('انتهت اللعبة!', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Text('نقاطك: $_score', style: const TextStyle(fontSize: 30, color: Colors.white)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _gameOver = false;
                  _lives = 3;
                  _score = 0;
                  _balloons.clear();
                  _particles.clear();
                  _startNewRound();
                });
              },
              child: const Text('لعب مرة أخرى', style: TextStyle(fontSize: 24)),
            ),
            TextButton(
              onPressed: widget.onBack,
              child: const Text('رجوع', style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
