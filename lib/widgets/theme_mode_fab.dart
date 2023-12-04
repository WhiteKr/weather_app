import 'package:flutter/material.dart';
import 'package:weather_app/services/theme/custom_theme_mode.dart';

class ThemeModeFab extends StatefulWidget {
  const ThemeModeFab({super.key});

  @override
  State<ThemeModeFab> createState() => _ThemeModeFabState();
}

class _ThemeModeFabState extends State<ThemeModeFab> {
  void _onPressed() {
    CustomThemeMode.change();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CustomThemeMode.current,
      builder: (context, value, child) => FloatingActionButton(
        foregroundColor: value ? Colors.yellow : Colors.orange,
        backgroundColor: value ? Colors.black : Colors.white,
        onPressed: _onPressed,
        child: Icon(CustomThemeMode.current.value ? Icons.dark_mode : Icons.light_mode),
      ),
    );
  }
}
