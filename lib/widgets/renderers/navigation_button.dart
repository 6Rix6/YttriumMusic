import 'package:flutter/material.dart';
import 'package:innertube_dart/innertube_dart.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/core/services/youtube_service.dart';
import 'package:yttrium_music/widgets/renderers/youtube_icon.dart';

enum ButtonSize { small, medium, large }

class NavigationButton extends StatelessWidget {
  final NavigationEndpoint endpoint;
  final String text;
  final Widget? textWidget;
  final bool primary;
  final bool isIconButton;
  final bool isDisabled;
  final ButtonSize size;
  final String? iconString;
  final Widget? iconWidget;
  const NavigationButton({
    super.key,
    required this.endpoint,
    required this.text,
    this.textWidget,
    this.primary = false,
    this.isIconButton = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.iconString,
    this.iconWidget,
  }) : assert(
         !isIconButton || (iconString != null || iconWidget != null),
         'iconString or iconWidget must be provided when isIconButton is true',
       );

  void onPressed() {
    if (endpoint.watchEndpoint != null) {
      final youtubeService = Get.find<YoutubeService>();
      youtubeService.playSong(endpoint.watchEndpoint!.videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = isDisabled ? null : () => this.onPressed();
    if (isIconButton) {
      return IconButton(onPressed: onPressed, icon: _buildIcon()!);
    }
    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: _buildIcon(),
        label: textWidget ?? Text(text),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: _buildIcon(),
      label: textWidget ?? Text(text),
    );
  }

  Widget? _buildIcon() {
    if (iconWidget != null) return iconWidget;
    if (iconString != null) return YoutubeIcon(iconString!);
    return null;
  }
}
