enum NumeralStyle { arabicIndic, western }

String formatNumber(int n, NumeralStyle style) {
  if (style == NumeralStyle.western) return n.toString();
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return n.toString().split('').map((c) => digits[int.parse(c)]).join();
}
