import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class YoutubeIcon extends Icon {
  factory YoutubeIcon(
    String iconType, {
    Key? key,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    List<Shadow>? shadows,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    final iconData = _mapStringToIconData(iconType);

    return YoutubeIcon._internal(
      iconData,
      key: key,
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  const YoutubeIcon._internal(
    super.icon, {
    super.key,
    super.size,
    super.fill,
    super.weight,
    super.grade,
    super.opticalSize,
    super.color,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
  });

  static IconData _mapStringToIconData(String name) {
    switch (name) {
      case "PLAY_ARROW":
        return CupertinoIcons.play_fill;
      case "MUSIC_SHUFFLE":
        return LucideIcons.shuffle;
      case "PLAYLIST_ADD":
        return LucideIcons.listPlus;
      case "MIX":
        return LucideIcons.radio;
      default:
        return Icons.help_outline;
    }
  }
}
