import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/services/storage_service.dart';
import 'package:yttrium_music/common/enums/locale.dart';

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
  static const String _keyCountry = 'country';
  static const String _keyAudioQuality = 'audio_quality';

  // Reactive variables
  final _themeMode = ThemeMode.system.obs;
  final _enableDynamicColor = false.obs;
  final _language = Language.en.obs;
  final _country = Country.us.obs;
  final _audioQuality = 'high'.obs;

  // Getters
  ThemeMode get themeMode => _themeMode.value;
  bool get enableDynamicColor => _enableDynamicColor.value;
  Language get language => _language.value;
  Country get country => _country.value;
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

  set language(Language value) {
    _language.value = value;
    storageService.writeString(_keyLanguage, value.code);
  }

  set country(Country value) {
    _country.value = value;
    storageService.writeString(_keyCountry, value.code);
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

    final langCode = storageService.readString(_keyLanguage);
    if (langCode != null) {
      _language.value = Language.values.firstWhere(
        (lang) => lang.code == langCode,
        orElse: () => Language.en,
      );
    }

    final countryCode = storageService.readString(_keyCountry);
    if (countryCode != null) {
      _country.value = Country.values.firstWhere(
        (country) => country.code == countryCode,
        orElse: () => Country.us,
      );
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
    language = Language.en;
    country = Country.us;
    audioQuality = 'high';
  }
}
