import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _voice = AudioPlayer();
  double voiceVolume = 1.0;

  Future<void> playVoice(String ref, {bool force = false}) async {
    try {
      final assetPath = 'assets/audio/$ref.m4a';
      debugPrint('🔊 [محاولة تشغيل]: $assetPath');
      
      // لو إحنا على لينكس، بنتجاهل التشغيل الفعلي عشان التطبيق ميهنجش
      if (Platform.isLinux) {
        debugPrint('⚠️ [لينكس]: تم تجاهل التشغيل الفعلي (لتجنب التعليق)، الصوت سيعمل على الموبايل.');
        return;
      }

      await _voice.stop();
      await _voice.setAsset(assetPath);
      await _voice.setVolume(voiceVolume);
      _voice.play();
    } catch (e) {
      debugPrint('❌ خطأ في الصوت ($ref): $e');
    }
  }

  Future<void> playSequence(List<String> refs) async {
    for (final ref in refs) {
      await playVoice(ref, force: true);
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  Future<void> stop() async {
    try { await _voice.stop(); } catch (_) {}
  }

  Future<void> dispose() async {
    try { await _voice.dispose(); } catch (_) {}
  }
}
