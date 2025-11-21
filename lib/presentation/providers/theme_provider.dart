import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_storage_service.dart';

/// Theme mode notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService _storageService;

  ThemeModeNotifier(this._storageService) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final savedMode = _storageService.getThemeMode();
    if (savedMode != null) {
      state = _parseThemeMode(savedMode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storageService.setThemeMode(mode.toString());
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final storageService = ref.watch(
    Provider<LocalStorageService>((ref) => LocalStorageService()),
  );
  return ThemeModeNotifier(storageService);
});
