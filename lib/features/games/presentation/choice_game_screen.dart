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
            SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(iconSize: 30, icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go(widget.backRoute)),
                    title: s == null ? null : Text('سؤال ${s.index + 1} من ${s.questions.length}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
    
    // تقسيم الشاشة لنصين (يمين ويسار) عشان مفيش سكرول لتحت
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // النص الشمال: السؤال والصورة
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_setup?.instructionText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _setup!.instructionText!, 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (prompt != null) Expanded(child: Center(child: prompt(context, q))),
                const SizedBox(height: 16),
                if (q.promptAudio != null)
                  IconButton.filled(
                    iconSize: 40,
                    onPressed: _playPrompt,
                    icon: const Icon(Icons.volume_up),
                  ),
              ],
            ),
          ),
          
          // النص اليمين: الخيارات
          Expanded(
            flex: 1,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final o in q.options)
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: widget.idOf(o) == _okId
                              ? Colors.green
                              : (widget.idOf(o) == _wrongId ? Colors.orange.shade300 : Colors.white),
                          foregroundColor: widget.idOf(o) == _okId || widget.idOf(o) == _wrongId ? Colors.white : const Color(0xFF00796B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF00796B), width: 3)),
                        ),
                        onPressed: () => _onTap(o),
                        child: FittedBox(fit: BoxFit.scaleDown, child: widget.optionBuilder(context, ref, o)),
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
                      const Icon(Icons.star, size: 60, color: Colors.amber),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filled(iconSize: 50, onPressed: onReplay, icon: const Icon(Icons.replay)),
                const SizedBox(width: 32),
                IconButton.filled(iconSize: 50, onPressed: onBack, icon: const Icon(Icons.check)),
              ],
            ),
          ],
        ),
      );
}
