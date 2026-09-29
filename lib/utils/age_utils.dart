/// Computes a human "X months, Y weeks old" / "X years, Y months old"
/// string from a birth date, matching the Care Records design.
class AgeUtils {
  AgeUtils._();

  static String describe(DateTime birthDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    var totalDays = today.difference(DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
    )).inDays;
    if (totalDays < 0) totalDays = 0;

    final years = totalDays ~/ 365;
    final remAfterYears = totalDays % 365;
    final months = remAfterYears ~/ 30;
    final remAfterMonths = remAfterYears % 30;
    final weeks = remAfterMonths ~/ 7;
    final days = remAfterMonths % 7;

    if (years >= 1) {
      final m = months;
      return m > 0
          ? '$years ${years == 1 ? 'year' : 'years'}, $m ${m == 1 ? 'month' : 'months'} old'
          : '$years ${years == 1 ? 'year' : 'years'} old';
    }
    if (months >= 1) {
      return weeks > 0
          ? '$months ${months == 1 ? 'month' : 'months'}, $weeks ${weeks == 1 ? 'week' : 'weeks'} old'
          : '$months ${months == 1 ? 'month' : 'months'} old';
    }
    if (weeks >= 1) {
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} old';
    }
    return '$days ${days == 1 ? 'day' : 'days'} old';
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String formatDate(DateTime d) =>
      '${monthNames[d.month - 1]} ${d.day}, ${d.year}';
}
