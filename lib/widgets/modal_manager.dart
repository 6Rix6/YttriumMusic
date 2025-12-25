import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:nampack/extensions/navigator_ext.dart';
import 'package:nampack/navigation/transition_type.dart';
import 'package:yttrium_music/core/utils/extensions.dart';
import 'package:yttrium_music/core/utils/context_extensions.dart';

class ModalManager {
  final BuildContext context;
  late final NavigatorState navigator;

  ModalManager({required this.context}) {
    navigator = Navigator.of(context, rootNavigator: true);
  }

  int _currentDialogNumber = 0;
  int _currentSheetNumber = 0;

  Future<T?> showPopup<T>(
    BuildContext context, {
    final Widget? dialog,
    final Widget Function(ThemeData theme)? dialogBuilder,
    final int durationInMs = 300,
    final bool Function()? tapToDismiss,
    final FutureOr<void> Function()? onDismissing,
    final double scale = 0.96,
    final bool blackBg = false,
    final void Function()? onDisposing,
  }) async {
    _currentDialogNumber++;
    final theme = Theme.of(context);

    Future<void> handleDismiss() async {
      if (tapToDismiss != null && tapToDismiss() == false) return;

      if (_currentDialogNumber > 0) {
        await closeDialog();

        if (onDismissing != null) {
          await onDismissing();
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    final res = await navigator.pushPage<T>(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await handleDismiss();
        },
        child: material.RepaintBoundary(
          child: BgBlur(
            blur: 5.0,
            enabled: _currentDialogNumber == 1,
            child: TapDetector(
              onTap: handleDismiss,
              child: Container(
                color: Colors.black.withValues(alpha: blackBg ? 1.0 : 0.45),
                child: Transform.scale(
                  scale: scale,
                  child: Theme(
                    data: theme,
                    child: dialogBuilder == null
                        ? dialog!
                        : dialogBuilder(theme),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      durationInMs: durationInMs,
      opaque: false,
      fullscreenDialog: true,
      transition: Transition.fade,
      maintainState: true,
    );

    if (onDisposing != null) {
      onDisposing.executeAfterDelay(durationMS: durationInMs * 2);
    }

    return res;
  }

  Future<void> closeDialog([int count = 1]) async {
    if (_currentDialogNumber == 0) return;
    int closeCount = count.withMaximum(_currentDialogNumber);
    while (closeCount > 0) {
      _currentDialogNumber--;
      navigator.pop();
      closeCount--;
    }
  }

  Future<void> closeAllDialogs() async {
    if (_currentDialogNumber == 0) return;
    closeDialog(_currentDialogNumber);
  }

  Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget Function(
      BuildContext context,
      double bottomPadding,
      double maxWidth,
      double maxHeight,
    )
    builder,
    BoxDecoration Function(BuildContext context)? decoration,
    double? heightPercentage,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool? showDragHandle,
    Color? backgroundColor,
  }) async {
    await Future.delayed(Duration.zero); // delay bcz sometimes doesnt show

    _currentSheetNumber++;
    return navigator
        .push(
          _CustomModalBottomSheetRoute<T>(
            backgroundBlur: _currentSheetNumber == 1 ? 3.0 : 0.0,
            isScrollControlled: isScrollControlled,
            showDragHandle: showDragHandle,
            isDismissible: isDismissible,
            backgroundColor: backgroundColor,
            builder: (context) {
              final bottomMargin = MediaQuery.viewInsetsOf(context).bottom;
              final bottomPadding = MediaQuery.paddingOf(context).bottom;
              return material.Padding(
                padding: EdgeInsets.only(bottom: bottomMargin),
                child: DecoratedBox(
                  decoration:
                      decoration?.call(context) ?? const BoxDecoration(),
                  child: SizedBox(
                    height: heightPercentage == null
                        ? null
                        : (context.height * heightPercentage),
                    width: context.width,
                    child: material.Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: LayoutWidthHeightProvider(
                        builder: (context, maxWidth, maxHeight) => builder(
                          context,
                          bottomPadding,
                          maxWidth,
                          maxHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
        .whenComplete(() => _currentSheetNumber--);
  }
}

class TapDetector extends StatelessWidget {
  final VoidCallback? onTap;
  final void Function(TapGestureRecognizer instance)? initializer;
  final Widget? child;
  final HitTestBehavior? behavior;

  const TapDetector({
    super.key,
    required this.onTap,
    this.initializer,
    this.child,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures =
        <Type, GestureRecognizerFactory>{};
    gestures[TapGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(debugOwner: this),
          initializer ??
              (TapGestureRecognizer instance) {
                instance
                  ..onTap = onTap
                  ..gestureSettings = MediaQuery.maybeGestureSettingsOf(
                    context,
                  );
              },
        );

    return RawGestureDetector(
      behavior: behavior,
      gestures: gestures,
      child: child,
    );
  }
}

class LayoutWidthHeightProvider extends StatelessWidget {
  final Widget Function(BuildContext context, double maxWidth, double maxHeight)
  builder;
  const LayoutWidthHeightProvider({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.withMaximum(context.width);
        final maxHeight = constraints.maxHeight.withMaximum(context.height);
        return builder(context, maxWidth, maxHeight);
      },
    );
  }
}

class _CustomModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  final double backgroundBlur;
  _CustomModalBottomSheetRoute({
    this.backgroundBlur = 0,
    required super.isScrollControlled,
    super.showDragHandle,
    super.isDismissible,
    super.backgroundColor,
    required super.builder,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final child = super.buildPage(context, animation, secondaryAnimation);
    if (backgroundBlur > 0) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) =>
            BgBlur(blur: backgroundBlur * animation.value, child: child),
      );
    }
    return child;
  }
}

class Blur extends StatelessWidget {
  final double blur;
  final bool enabled;
  final TileMode? tileMode;
  final Widget child;

  const Blur({
    super.key,
    required this.blur,
    this.enabled = true,
    bool fixArtifacts = false,
    required this.child,
  }) : tileMode = fixArtifacts ? TileMode.decal : Blur.kDefaultTileMode;

  static const kDefaultTileMode = TileMode.clamp;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      enabled: enabled && blur > 0,
      imageFilter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: tileMode,
      ),
      child: child,
    );
  }
}

class BgBlur extends StatelessWidget {
  final double blur;
  final bool enabled;
  final Widget child;

  const BgBlur({
    super.key,
    required this.blur,
    this.enabled = true,
    required this.child,
  });

  static final _groupKey = BackdropKey();

  @override
  Widget build(BuildContext context) {
    if (!enabled || blur == 0) return child;
    return BackdropFilter(
      backdropGroupKey: _groupKey,
      filter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: Blur.kDefaultTileMode,
      ),
      child: child,
    );
  }
}
