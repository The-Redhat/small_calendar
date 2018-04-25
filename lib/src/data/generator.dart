import 'day_data.dart';

/// Generates a list of [DayData] to be displayed for specific calendar [month].
///
/// Resulting list also contains days that do not belong to [month], but do
/// belong to a week of which at least one day does belong to [month].
///
/// eg.
/// If first day of [month] is on Wednesday and [firstWeekday] is Monday,
/// the first two days of generated list will be the last two days of the month the is before the [month].
List<DayData> generateDayData(DateTime month, int firstWeekday) {
  List<DayData> r = <DayData>[];

  DateTime currentDay;
  // adds days before the start of the month
  currentDay = _lowerToFirstWeekday(
    new DateTime.utc(
      month.year,
      month.month,
    ),
    firstWeekday,
  );
  while (currentDay.month != month.month) {
    r.add(
      new DayData(
        day: currentDay,
        isExtended: true,
      ),
    );
    currentDay = currentDay.add(new Duration(days: 1));
  }

  // adds actual days of month
  while (currentDay.month == month.month) {
    r.add(
      new DayData(
        day: currentDay,
        isExtended: false,
      ),
    );
    currentDay = currentDay.add(new Duration(days: 1));
  }

  // adds days after the end of the month
  while (currentDay.weekday != firstWeekday) {
    r.add(
      new DayData(
        day: currentDay,
        isExtended: true,
      ),
    );
    currentDay = currentDay.add(new Duration(days: 1));
  }

  return r;
}

DateTime _lowerToFirstWeekday(DateTime day, int firstWeekday) {
  while (day.weekday != firstWeekday) {
    day = day.add(new Duration(days: -1));
  }

  return day;
}

/// Generates list of all weekdays (monday-sunday) starting with [firstWeekday].
List<int> generateWeekdays(int firstWeekday) {
  List<int> r = <int>[];

  int zeroBasedFirstWeekday = firstWeekday - 1;

  for (int i = 0; i < 7; i++) {
    r.add((((zeroBasedFirstWeekday + i) % 7)) + 1);
  }

  return r;
}
