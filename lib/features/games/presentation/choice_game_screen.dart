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
