import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_loadThemeMode(_prefs));

  final SharedPreferences _prefs;
  static const _themeKey = 'app_theme_mode';

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final savedMode = prefs.getString(_themeKey);
    if (savedMode == 'light') return ThemeMode.light;
    return ThemeMode.dark;
  }

  void toggleTheme(bool isDark) {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(_themeKey, newMode.name);
    emit(newMode);
  }
}
