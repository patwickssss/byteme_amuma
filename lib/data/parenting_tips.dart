/// Static, general, non-medical parenting tips. Rotates by day of year so
/// it feels fresh without any server or AI call.
class ParentingTips {
  ParentingTips._();

  static const List<String> _tips = [
    "A short daily routine — even just a song before naps — helps little ones feel secure.",
    "It's okay to ask for help. Taking a break recharges you for your child too.",
    'Reading together for just 10 minutes a day builds language skills early.',
    'Tummy time in small, frequent stretches is easier for babies than one long session.',
    'Celebrate small wins — every stage of growth is worth noticing.',
    'A consistent bedtime, even on weekends, makes mornings easier for everyone.',
    'Talking through your day with your child, even a toddler, supports language growth.',
    "Trust your instincts — you know your child better than any guide.",
    'Keeping a simple log of feedings or naps can reveal patterns you might miss.',
    'Water, rest, and a few deep breaths go a long way on hard parenting days.',
  ];

  static String forToday() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return _tips[dayOfYear % _tips.length];
  }
}
