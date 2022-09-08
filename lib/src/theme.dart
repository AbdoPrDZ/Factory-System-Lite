import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modes/ui_theme.mode.dart';
import '../services/main.service.dart';

class UIColors {
  // basic
  static const Color primary1 = Color(0XFF42AAFB);
  static const Color primary2 = Color(0xFF0C5994);
  static const Color success = Color(0XFF00B14D);
  static const Color danger = Color(0XFFE84F4F);
  static const Color warning = Color(0XFFFFCD00);
  static const Color grey = Color(0XFFB2B2B2);
}

class LightTheme {
  static const Color pageBackground = Color(0XFFEFEFEF);
  static const Color primary = UIColors.primary1;
  static const Color success = UIColors.success;
  static const Color danger = UIColors.danger;
  static const Color text1 = Color(0XFF000000);
  static const Color text2 = Color(0XFF4D4D4D);
  static const Color text3 = Color(0XFF727272);
  static const Color text4 = Color(0XFF9B9B9B);
  static const Color text5 = pageBackground;
  static const Color text6 = Color(0XFF4387DF);
  static const Color iconBg = UIColors.primary1;
  static const Color iconFg = text5;
  static const Color feildBg = Color(0X16D8D8D8);
  static const Color field = Color.fromARGB(143, 117, 117, 117);
  static const Color fieldBg = Color.fromARGB(24, 121, 121, 121);
  static const Color fieldText = Color.fromARGB(255, 66, 66, 66);
  static const Color fieldFocus = Color(0xFF4387DF);
  static const Color cardBg = Color.fromARGB(255, 255, 255, 255);
  static const Color tableCellBg1 = Colors.transparent;
  static const Color tableCellFg1 = text2;
  static const Color tableCellBg2 = Color.fromARGB(134, 211, 211, 211);
  static const Color tableCellFg2 = text3;
}

class DarkTheme {
  static const Color pageBackground = Color(0xFF202020);
  static const Color primary = UIColors.primary2;
  static const Color success = UIColors.success;
  static const Color danger = UIColors.danger;
  static const Color text1 = Color(0XFFFFFFFF);
  static const Color text2 = Color(0XFFB2B2B2);
  static const Color text3 = Color(0XFF8D8D8D);
  static const Color text4 = Color(0XFF646464);
  static const Color text5 = pageBackground;
  static const Color text6 = Color(0xFF3567AA);
  static const Color feildBg = Color(0X16D8D8D8);
  static const Color iconBg = UIColors.primary1;
  static const Color iconFg = text5;
  static const Color field = Color(0x8FFFFFFF);
  static const Color fieldBg = Color(0x1DFFFFFF);
  static const Color fieldText = Color(0xFFEBEBEB);
  static const Color fieldFocus = Color(0xFF4387DF);
  static const Color cardBg = Color.fromARGB(255, 41, 41, 41);
  static const Color tableCellBg1 = Colors.transparent;
  static const Color tableCellFg1 = text2;
  static const Color tableCellBg2 = Color.fromARGB(133, 129, 129, 129);
  static const Color tableCellFg2 = Color.fromARGB(255, 207, 207, 207);
}

class UIThemeColors {
  static Color _getColor(String name) {
    Map<String, Map<String, Color>> colors = {
      UIThemeMode.light.mode: {
        'pageBackground': LightTheme.pageBackground,
        'text1': LightTheme.text1,
        'text2': LightTheme.text2,
        'text3': LightTheme.text3,
        'text4': LightTheme.text4,
        'text5': LightTheme.text5,
        'text6': LightTheme.text6,
        'primary': LightTheme.primary,
        'success': LightTheme.success,
        'danger': LightTheme.danger,
        'feildBg': LightTheme.feildBg,
        'iconFg': LightTheme.iconFg,
        'iconBg': LightTheme.iconBg,
        'field': LightTheme.field,
        'fieldBg': LightTheme.fieldBg,
        'fieldText': LightTheme.fieldText,
        'fieldFocus': LightTheme.fieldFocus,
        'cardBg': LightTheme.cardBg,
        'tableCellBg1': LightTheme.tableCellBg1,
        'tableCellFg1': LightTheme.tableCellFg1,
        'tableCellBg2': LightTheme.tableCellBg2,
        'tableCellFg2': LightTheme.tableCellFg2,
      },
      UIThemeMode.dark.mode: {
        'pageBackground': DarkTheme.pageBackground,
        'text1': DarkTheme.text1,
        'text2': DarkTheme.text2,
        'text3': DarkTheme.text3,
        'text4': DarkTheme.text4,
        'text5': DarkTheme.text5,
        'text6': DarkTheme.text6,
        'primary': DarkTheme.primary,
        'success': DarkTheme.success,
        'danger': DarkTheme.danger,
        'feildBg': DarkTheme.feildBg,
        'iconFg': DarkTheme.iconFg,
        'iconBg': DarkTheme.iconBg,
        'field': DarkTheme.field,
        'fieldBg': DarkTheme.fieldBg,
        'fieldText': DarkTheme.fieldText,
        'fieldFocus': DarkTheme.fieldFocus,
        'cardBg': DarkTheme.cardBg,
        'tableCellBg1': DarkTheme.tableCellBg1,
        'tableCellFg1': DarkTheme.tableCellFg1,
        'tableCellBg2': DarkTheme.tableCellBg2,
        'tableCellFg2': DarkTheme.tableCellFg2,
      }
    };
    String mode = Get.find<MainService>().themeMode.value.mode;
    mode = ['Dark', 'Light'].contains(mode) ? mode : 'Light';
    // print('$name: ${colors[mode]!.containsKey(name)}');
    return colors[mode]![name]!;
  }

  static Color get pageBackground => _getColor('pageBackground');
  static Color get primary => _getColor('primary');
  static Color get success => _getColor('success');
  static Color get danger => _getColor('danger');
  static Color get text1 => _getColor('text1');
  static Color get text2 => _getColor('text2');
  static Color get text3 => _getColor('text3');
  static Color get text4 => _getColor('text4');
  static Color get text5 => _getColor('text5');
  static Color get text6 => _getColor('text6');
  static Color get feildBg => _getColor('feildBg');
  static Color get iconFg => _getColor('iconFg');
  static Color get iconBg => _getColor('iconBg');
  static Color get field => _getColor("field");
  static Color get fieldBg => _getColor("fieldBg");
  static Color get fieldText => _getColor("fieldText");
  static Color get fieldFocus => _getColor("fieldFocus");
  static Color get cardBg => _getColor("cardBg");
  static Color get tableCellBg1 => _getColor("tableCellBg1");
  static Color get tableCellFg1 => _getColor("tableCellFg1");
  static Color get tableCellBg2 => _getColor("tableCellBg2");
  static Color get tableCellFg2 => _getColor("tableCellFg2");
}
