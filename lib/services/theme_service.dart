import 'package:flutter/material.dart';
import 'local_storage_service.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final settings = await LocalStorageService.getUserSettings();
      if (settings != null) {
        _isDarkMode = (settings['theme'] ?? 'light') == 'dark';
      }
      notifyListeners();
    } catch (e) {
      print('Error loading theme: $e');
      _isDarkMode = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      _isDarkMode = isDark;
      
      // Save to local storage
      final settings = await LocalStorageService.getUserSettings() ?? {};
      settings['theme'] = isDark ? 'dark' : 'light';
      await LocalStorageService.saveUserSettings(settings);
      
      notifyListeners();
    } catch (e) {
      print('Error toggling theme: $e');
    }
  }

  ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Colors.grey[850],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }

  ThemeData getCurrentTheme() {
    return _isDarkMode ? getDarkTheme() : getLightTheme();
  }
}