import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/audio_providers.dart';
import '../../../core/widgets/kids_background.dart';

class PillarsGameScreen extends ConsumerStatefulWidget {
  const PillarsGameScreen({super.key});

  @override
  ConsumerState<PillarsGameScreen> createState() => _PillarsGameScreenState();
}

class _PillarsGameScreenState extends ConsumerState<PillarsGameScreen> {
  // لاحظ: هنا بنستخدم q_ عشان صوت السؤال
  final List<Map<String, String>> _allPillars = [
    {
      'name': 'الشهادتان',
      'emoji': '☝️',
      'desc': 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا الله وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ الله',
      'audio': 'pillars/q_shahada',
      'color': 'FF7043',
    },
    {
      'name': 'الصلاة',
      'emoji': '🕌',
      'desc': 'الرُّكْن الَّذِي نُصَلِّي فِيهِ خَمْس صَلَوَات فِي اليَوْم',
      'audio': 'pillars/q_salah',
      'color': '29B6F6',
    },
    {
      'name': 'الزكاة',
      'emoji': '💰',
      'desc': 'الرُّكْن الَّذِي نُعْطِي فِيهِ المَال لِلْفُقَرَاء وَالْمَسَاكِين',
      'audio': 'pillars/q_zakat',
      'color': '66BB6A',
    },
    {
      'name': 'الصوم',
      'emoji': '🌙',
      'desc': 'الرُّكْن الَّذِي نَصُوم فِيهِ شَهْر رَمَضَان',
      'audio': 'pillars/q_sawm',
      'color': 'AB47BC',
    },
    {
      'name': 'الحج',
      'emoji': '🕋',
      'desc': 'الرُّكْن الَّذِي نَزُور فِيهِ بَيْت الله الحَرَام فِي مَكَّة',
      'audio': 'pillars/q_hajj',
      'color': 'FFA726',
    },
  ];

  late Map<String, String> _target;
  List<Map<String, String>> _options = [];
  int _score = 0;
  int _currentQuestion = 1;
  final int _totalQuestions = 5;
  bool _gameOver = false;
  String? _selectedWrong;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _generateQuestion();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  void _generateQuestion() {
    if (_currentQuestion > _totalQuestions) {
      setState(() => _gameOver = true);
      return;
    }

    final random = Random();
    _target = _allPillars[random.nextInt(_allPillars.length)];
    
    final others = _allPillars.where((p) => p['name'] != _target['name']).toList()..shuffle();
    _options = [_target, others[0], others[1]]..shuffle();

    setState(() => _selectedWrong = null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playVoice(_target['audio']!, force: true);
    });
  }

  void _onAnswer(Map<String, String> answer) async {
    if (answer['name'] == _target['name']) {
      setState(() => _score += 10);
      await ref.read(audioServiceProvider).playVoice('instructions/right', force: true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() => _currentQuestion++);
        _generateQuestion();
      }
    } else {
      setState(() => _selectedWrong = answer['name']);
      await ref.read(audioServiceProvider).playVoice('instructions/try_again', force: true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _selectedWrong = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidsBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, elevation: 0,
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/pillars_learn')),
                title: Text('سؤال $_currentQuestion من $_totalQuestions', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              Expanded(
                child: _gameOver ? _buildResult() : _buildBoard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    final color = Color(int.parse('0xFF${_target['color']}'));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // السؤال: توصيف الركن
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('اخْتَر الرُّكْن الصَّحِيح:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(_target['desc']!, textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color, height: 1.5)),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: color),
                      iconSize: 40,
                      onPressed: () => ref.read(audioServiceProvider).playVoice(_target['audio']!, force: true),
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // الخيارات
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options.map((option) {
                final isWrong = _selectedWrong == option['name'];
                return GestureDetector(
                  onTap: () => _onAnswer(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 200, height: 100,
                    decoration: BoxDecoration(
                      color: isWrong ? Colors.orange.shade300 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isWrong ? Colors.orange : Colors.grey.shade300, width: 4),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(option['name']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
          const SizedBox(height: 16),
          Text('أحسنت! نتيجتك: $_score', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              setState(() {
                _gameOver = false;
                _score = 0;
                _currentQuestion = 1;
                _generateQuestion();
              });
            },
            child: const Text('العب مرة أخرى', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
