import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/services/storage_service.dart';

/// Controller for managing application settings
/// To add a new setting:
/// 1. Define the setting key as a constant
/// 2. Create an Rx variable
/// 3. Load initial value in onInit()
/// 4. Implement getter/setter
class SettingsController extends GetxController {
  final StorageService storageService;

  SettingsController({required this.storageService});

  // Setting key constants
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyEnableDynamicColor = 'enable_dynamic_color';
  static const String _keyLanguage = 'language';
  static const String _keyAudioQuality = 'audio_quality';

  // Reactive variables
  final _themeMode = ThemeMode.system.obs;
  final _enableDynamicColor = false.obs;
  final _language = 'ja'.obs;
  final _audioQuality = 'high'.obs;

  // Getters
  ThemeMode get themeMode => _themeMode.value;
  bool get enableDynamicColor => _enableDynamicColor.value;
  String get language => _language.value;
  String get audioQuality => _audioQuality.value;

  // Setters
  set themeMode(ThemeMode value) {
    _themeMode.value = value;
    storageService.writeString(_keyThemeMode, value.name);
  }

  set enableDynamicColor(bool value) {
    _enableDynamicColor.value = value;
    storageService.writeBool(_keyEnableDynamicColor, value);
  }

  set language(String value) {
    _language.value = value;
    storageService.writeString(_keyLanguage, value);
  }

  set audioQuality(String value) {
    _audioQuality.value = value;
    storageService.writeString(_keyAudioQuality, value);
  }

  // Initialization
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final themeModeStr = storageService.readString(_keyThemeMode);
    if (themeModeStr != null) {
      _themeMode.value = ThemeMode.values.firstWhere(
        (mode) => mode.name == themeModeStr,
        orElse: () => ThemeMode.system,
      );
    }

    final enableDynamicColorStr = storageService.readBool(
      _keyEnableDynamicColor,
    );
    _enableDynamicColor.value = enableDynamicColorStr;

    final lang = storageService.readString(_keyLanguage);
    if (lang != null) {
      _language.value = lang;
    }

    final quality = storageService.readString(_keyAudioQuality);
    if (quality != null) {
      _audioQuality.value = quality;
    }
  }

  // Utility methods

  /// Reset all settings to default values
  void resetAllSettings() {
    themeMode = ThemeMode.system;
    language = 'ja';
    audioQuality = 'high';
  }
}
