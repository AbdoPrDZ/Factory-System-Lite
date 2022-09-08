import 'mode.dart';

class DisplayTypes extends Mode<String> {
  const DisplayTypes._(String mode) : super(mode);

  static const DisplayTypes day = DisplayTypes._('Day');
  static const DisplayTypes week = DisplayTypes._('Week');
  static const DisplayTypes month = DisplayTypes._('Month');
  static const DisplayTypes year = DisplayTypes._('Year');

  bool get isDay => mode == DisplayTypes.day.mode;
  bool get isWeek => mode == DisplayTypes.week.mode;
  bool get isMonth => mode == DisplayTypes.month.mode;
  bool get isYear => mode == DisplayTypes.year.mode;
}
