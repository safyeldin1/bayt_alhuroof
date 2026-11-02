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
