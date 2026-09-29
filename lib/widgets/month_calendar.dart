import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';

/// Simple month-grid calendar (no external package), matching
/// Care_Records___Reminder_Add_Profile(2).png. Highlights today and any
/// date with a reminder, and reports taps for navigating months/days.
class MonthCalendar extends StatelessWidget {
  final DateTime month; // any date within the shown month
  final Set<DateTime> markedDates; // dates (y/m/d only) that have reminders
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const MonthCalendar({
    super.key,
    required this.month,
    required this.markedDates,
    required this.selectedDate,
    required this.onDaySelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7; // Sun=0 .. Sat=6
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.pink),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AgeUtils.monthNames[month.month - 1]} ${month.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onPrevMonth,
                    icon: const Icon(Icons.chevron_left, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: onNextMonth,
                    icon: const Icon(Icons.chevron_right, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              _WeekdayLabel('SUN'),
              _WeekdayLabel('MON'),
              _WeekdayLabel('TUE'),
              _WeekdayLabel('WED'),
              _WeekdayLabel('THU'),
              _WeekdayLabel('FRI'),
              _WeekdayLabel('SAT'),
            ],
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              final date = DateTime(month.year, month.month, day);
              final isToday = AgeUtils.isSameDay(date, today);
              final isSelected = AgeUtils.isSameDay(date, selectedDate);
              final hasReminder = markedDates.any((d) => AgeUtils.isSameDay(d, date));

              return GestureDetector(
                onTap: () => onDaySelected(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.maroon : Colors.transparent,
                    shape: BoxShape.circle,
                    border: !isSelected && isToday
                        ? Border.all(color: AppColors.pink)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (hasReminder && !isSelected)
                        Positioned(
                          bottom: 1,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.pink,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.pink,
          ),
        ),
      ),
    );
  }
}
