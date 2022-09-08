class DateRange {
  final DateTime from;
  final DateTime to;

  DateRange({required this.from, required this.to});

  static int getMonthDaysCount(DateTime date) {
    DateTime firstDayThisMonth = DateTime(date.year, date.month, date.day);
    DateTime firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  factory DateRange.after(DateTime from, Duration delay) =>
      DateRange(from: from, to: from.add(delay));

  factory DateRange.befor(DateTime from, Duration delay) =>
      DateRange(from: from.subtract(delay), to: from);

  factory DateRange.thisDay() {
    DateTime currentDate = DateTime.now();
    return DateRange.after(
      DateTime(currentDate.year, currentDate.month, currentDate.day, 5),
      const Duration(hours: 17),
    );
  }

  factory DateRange.thisWeek() {
    DateTime currentDate = DateTime.now();
    return DateRange.after(
      DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day - currentDate.weekday,
      ),
      const Duration(days: 6),
    );
  }

  factory DateRange.thisMonth() {
    DateTime currentDate = DateTime.now();
    return DateRange(
      from: DateTime(currentDate.year, currentDate.month, 1),
      to: DateTime(
        currentDate.year,
        currentDate.month,
        getMonthDaysCount(currentDate),
      ),
    );
  }

  factory DateRange.thisYear() {
    DateTime currentDate = DateTime.now();
    return DateRange(
      from: DateTime(currentDate.year),
      to: DateTime(currentDate.year, 12),
    );
  }
}
