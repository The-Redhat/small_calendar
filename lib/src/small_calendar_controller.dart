import 'dart:async';

import 'package:small_calendar/src/callbacks.dart';

typedef Future<bool> IsHasCallback(DateTime date);

class SmallCalendarController {
  /// Future that returns true if specific date is today
  final IsHasCallback isTodayCallback;

  /// Future that returns true if specific date is selected
  final IsHasCallback isSelectedCallback;

  /// Future that returns true if there is a tick associated with specific date
  final IsHasCallback hasTick1Callback;

  /// Future that returns true if there is a tick associated with specific date
  final IsHasCallback hasTick2Callback;

  /// Future that returns true if there is a tick associated with specific date
  final IsHasCallback hasTick3Callback;

  Set<DateCallback> _goToListeners = new Set<DateCallback>();

  SmallCalendarController({
    this.isTodayCallback,
    this.isSelectedCallback,
    this.hasTick1Callback,
    this.hasTick2Callback,
    this.hasTick3Callback,
  });

  // for listeners -------------------------------------------------------------

  void addGoToListener(DateCallback listener) {
    _goToListeners.add(listener);
  }

  void removeGoToListener(DateCallback listener) {
    _goToListeners.remove(listener);
  }

  void _notifyGoToListener(DateTime dateToGoTo) {
    for (DateCallback listener in _goToListeners) {
      if (listener != null) {
        listener(dateToGoTo);
      }
    }
  }

  // is has --------------------------------------------------------------------

  Future<bool> isToday(DateTime date) async {
    if (isTodayCallback != null) {
      return isTodayCallback(date);
    }

    // default
    DateTime now = new DateTime.now();
    return (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  Future<bool> isSelected(DateTime date) async {
    if (isSelectedCallback != null) {
      return isSelectedCallback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick1(DateTime date) async {
    if (hasTick1Callback != null) {
      return hasTick1Callback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick2(DateTime date) async {
    if (hasTick2Callback != null) {
      return hasTick2Callback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick3(DateTime date) async {
    if (hasTick3Callback != null) {
      return hasTick3Callback(date);
    }

    // default
    return false;
  }

  // goTo ----------------------------------------------------------------------

  /// [SmallCalendar] displays month that shows [date].
  ///
  /// If month with specific [date] cannot be displayed, it shows the nearest month
  /// that can be displayed.
  void goTo(DateTime date) {
    _notifyGoToListener(date);
  }

  /// [SmallCalendar] displays month that shows today's date.
  ///
  /// If month with specific today's date cannot be displayed, it shows the nearest month
  /// that can be displayed.
  void goToToday() {
    goTo(new DateTime.now());
  }
}
