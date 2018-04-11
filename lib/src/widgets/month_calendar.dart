import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../data/all.dart';
import '../small_calendar_controller.dart';
import '../callbacks.dart';
import '../generator.dart';
import 'small_calendar_style.dart';
import 'weekday_indicator.dart';
import 'day_widget.dart';

class MonthCalendar extends StatefulWidget {
  final Month month;

  final int firstWeekday;

  final SmallCalendarController controller;

  final bool showWeekdayIndication;
  final List<int> weekdayIndicationDays;
  final Map<int, String> dayNames;
  final double weekdayIndicationHeight;

  final DateTimeCallback onDayPressed;

  MonthCalendar({
    @required this.month,
    @required this.firstWeekday,
    @required this.controller,
    @required this.showWeekdayIndication,
    @required this.weekdayIndicationDays,
    @required this.dayNames,
    @required this.weekdayIndicationHeight,
    @required this.onDayPressed,
  })
      : super(key: new ObjectKey(month));

  @override
  State createState() => new _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  bool _isActive;
  List<DayData> _days = <DayData>[];

  @override
  void initState() {
    super.initState();

    _isActive = true;

    _days = generateDays();
    widget.controller.addDayRefreshListener(onRefreshDays);

    refreshDaysData();
  }

  @override
  void dispose() {
    _isActive = false;
    widget.controller.removeDayRefreshListener(onRefreshDays);

    super.dispose();
  }

  @override
  void didUpdateWidget(MonthCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeDayRefreshListener(onRefreshDays);
      widget.controller.addDayRefreshListener(onRefreshDays);
    }

    if (oldWidget.firstWeekday != widget.firstWeekday) {
      _days = generateDays();
      refreshDaysData();
    }
  }

  void onRefreshDays() {
    refreshDaysData();
  }

  List<DayData> generateDays() {
    return generateExtendedDaysOfMonth(
      widget.month,
      widget.firstWeekday,
    )
        .map((day) => new DayData(day: day))
        .toList();
  }

  Future refreshDaysData() async {
    for (int i = 0; i < _days.length; i++) {
      updateIsHasOfDay(_days[i]).then((updatedDay) {
        if (!_isActive) return;
        setState(() {
          _days[i] = updatedDay;
        });
      });
    }
  }

  Future<DayData> updateIsHasOfDay(DayData dayData) async {
    DateTime dateTime = dayData.day.toDateTime();

    return dayData.copyWithIsHasChanged(
      isToday: await widget.controller.isToday(dateTime),
      isSelected: await widget.controller.isSelected(dateTime),
      hasTick1: await widget.controller.hasTick1(dateTime),
      hasTick2: await widget.controller.hasTick2(dateTime),
      hasTick3: await widget.controller.hasTick3(dateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];

    // weekday indication
    if (widget.showWeekdayIndication) {
      widgets.add(
        generateWeekdayIndication(context),
      );
    }

    // weeks
    widgets.addAll(
      generateWeeks(),
    );

    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  Widget generateWeekdayIndication(BuildContext context) {
    return new Container(
      height: widget.weekdayIndicationHeight,
      color: SmallCalendarStyle
          .of(context)
          .weekdayIndicationStyleData
          .backgroundColor,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: widget.weekdayIndicationDays
            .map(
              (day) => new Expanded(
                    child:
                        new WeekdayIndicator(text: "${widget.dayNames[day]}"),
                  ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> generateWeeks() {
    List<Widget> r = <Widget>[];

    for (int i = 0; i < _days.length; i += 7) {
      Iterable<DayData> daysOfWeek = _days.getRange(i, i + 7);
      r.add(
        generateWeek(daysOfWeek),
      );
    }

    return r;
  }

  Widget generateWeek(Iterable<DayData> daysOfWeek) {
    return new Expanded(
      child: new Row(
        children: daysOfWeek
            .map(
              (day) => new Expanded(
                    child: new DayWidget(
                      dayData: day,
                      onPressed: widget.onDayPressed,
                    ),
                  ),
            )
            .toList(),
      ),
    );
  }
}
