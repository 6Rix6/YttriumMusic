import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';

class ThemeController extends GetxController {
  final SettingsController settingsController;

  ThemeController({required this.settingsController});

  final currentLightColorScheme = Rxn<ColorScheme>();
  final currentDarkColorScheme = Rxn<ColorScheme>();

  bool get shouldUseDynamicColor =>
      settingsController.enableDynamicColor &&
      currentDarkColorScheme.value != null &&
      currentLightColorScheme.value != null;

  ThemeMode get themeMode => settingsController.themeMode;

  Future<void> setCurrentColorSchemeFromImageProvider(String imageUrl) async {
    currentLightColorScheme.value = await ColorScheme.fromImageProvider(
      provider: NetworkImage(imageUrl),
      brightness: Brightness.light,
    );
    currentDarkColorScheme.value = await ColorScheme.fromImageProvider(
      provider: NetworkImage(imageUrl),
      brightness: Brightness.dark,
    );
  }
}
