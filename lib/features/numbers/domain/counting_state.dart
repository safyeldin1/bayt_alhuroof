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
