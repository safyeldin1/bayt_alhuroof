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
