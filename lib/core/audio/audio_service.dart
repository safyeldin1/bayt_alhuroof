import 'dart:io' show Platform, Process;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _voice = AudioPlayer();
  double voiceVolume = 1.0;
  int _token = 0;

  Future<void> playVoice(String ref, {bool force = false}) async {
    try {
      final assetPath = 'assets/audio/$ref.m4a';
      debugPrint('🔊 [محاولة تشغيل]: $assetPath');
      
      // زيادة التوكن عشان نلغي أي تشغيل قديم
      final myToken = ++_token;
      
      if (Platform.isLinux) {
        try {
          await Process.run('mpv', ['--no-video', assetPath]);
          debugPrint('✅ [لينكس]: اشتغل ببرنامج mpv بنجاح');
        } catch (e) {
          debugPrint('❌ [لينكس]: فشل تشغيل mpv: $e');
        }
        return;
      }

      // للموبايل
      await _voice.stop();
      if (myToken != _token) return; // لو فيه طلب جديد، الغي القديم
      
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
    _token++; // إلغاء أي تشغيل جاري
    try { 
      if (Platform.isLinux) {
        await Process.run('pkill', ['mpv']); // إيقاف mpv على لينكس
      } else {
        await _voice.stop(); 
      }
    } catch (_) {}
  }

  Future<void> dispose() async {
    try { await _voice.dispose(); } catch (_) {}
  }
}
