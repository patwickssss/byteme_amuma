/// Small helpers for Philippine peso amounts (no extra packages needed).
class Money {
  Money._();

  /// 12345.6 -> ₱12,346  (centavos are not needed for budget planning)
  static String format(num value) {
    final negative = value < 0;
    final digits = value.abs().round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${negative ? '-' : ''}₱$buffer';
  }

  /// Reads what the user typed ("25,000" or "₱25000.50"). Null if invalid.
  static double? parse(String text) {
    final cleaned = text.replaceAll(',', '').replaceAll('₱', '').trim();
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
}
