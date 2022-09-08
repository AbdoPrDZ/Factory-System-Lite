import 'mode.dart';

class UIThemeMode extends Mode {
  const UIThemeMode._(String mode) : super(mode);

  static const UIThemeMode dark = UIThemeMode._("Dark");
  static const UIThemeMode light = UIThemeMode._("Light");
}
