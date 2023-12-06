import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomThemeMode {
  static final CustomThemeMode instance = CustomThemeMode._internal();

  factory CustomThemeMode() => instance;

  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static ValueNotifier<bool> current = ValueNotifier(true);

  static void change() async {
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        current.value = false;
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        current.value = true;
        break;
      default:
    }

    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('themeMode', current.value);
  }

  static void _initializeTheme() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final bool? isLightTheme = pref.getBool('themeMode');

    if (isLightTheme != null) {
      themeMode.value = isLightTheme ? ThemeMode.light : ThemeMode.dark;
      current.value = isLightTheme;
    }
  }

  CustomThemeMode._internal() {
    _initializeTheme();
  }
}
