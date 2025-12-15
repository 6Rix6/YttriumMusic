import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nampack/extensions/navigator_ext.dart';
import 'package:nampack/navigation/transition_type.dart';
import 'package:yttrium_music/common/utils/extensions.dart';

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

class CustomBlurryDialog extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Widget? titleWidget;
  final Widget? titleWidgetInPadding;
  final List<Widget>? trailingWidgets;
  final Widget? child;
  final List<Widget>? actions;
  final Widget? leftAction;
  final bool normalTitleStyle;
  final String? bodyText;
  final bool isWarning;
  final bool scrollable;
  final double horizontalInset;
  final double verticalInset;
  final EdgeInsetsGeometry contentPadding;
  final ThemeData? theme;

  const CustomBlurryDialog({
    super.key,
    this.child,
    this.trailingWidgets,
    this.title,
    this.titleWidget,
    this.titleWidgetInPadding,
    this.actions,
    this.icon,
    this.normalTitleStyle = false,
    this.bodyText,
    this.isWarning = false,
    this.horizontalInset = 50.0,
    this.verticalInset = 32.0,
    this.scrollable = true,
    this.contentPadding = const EdgeInsets.all(14.0),
    this.leftAction,
    this.theme,
  });

  double calculateDialogHorizontalMargin(BuildContext context, double minimum) {
    final screenWidth = context.width;
    final val = (screenWidth / 1000).clampDouble(0.0, 1.0);
    double percentage = 0.25 * val * val;
    percentage = percentage.clampDouble(0.0, 0.25);
    return (screenWidth * percentage).withMinimum(minimum);
  }

  @override
  Widget build(BuildContext context) {
    final ctxth = theme ?? context.theme;
    final vInsets = verticalInset;
    final double horizontalMargin = calculateDialogHorizontalMargin(
      context,
      horizontalInset,
    );
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: ctxth.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: vInsets,
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.width * 0.9),
            child: TapDetector(
              onTap: () {},
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title.
                    if (titleWidget != null) titleWidget!,
                    if (titleWidgetInPadding != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 28.0,
                          left: 28.0,
                          right: 24.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: titleWidgetInPadding,
                        ),
                      ),
                    if (titleWidget == null && titleWidgetInPadding == null)
                      normalTitleStyle
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 28.0,
                                left: 28.0,
                                right: 24.0,
                              ),
                              child: Row(
                                children: [
                                  if (icon != null || isWarning) ...[
                                    Icon(
                                      isWarning
                                          ? LucideIcons.fileExclamationPoint
                                          : icon,
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                  Expanded(
                                    child: Text(
                                      isWarning
                                          ? "(placeholder) warning text"
                                          : title ?? '',
                                      style: const TextStyle(
                                        fontFamily: "LexendDeca",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (trailingWidgets != null)
                                    ...trailingWidgets!,
                                ],
                              ),
                            )
                          : Container(
                              color: ctxth.cardTheme.color,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (icon != null) ...[
                                    Icon(icon),
                                    const SizedBox(width: 10.0),
                                  ],
                                  Expanded(
                                    child: Text(
                                      title ?? '',
                                      style: const TextStyle(
                                        fontFamily: "LexendDeca",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                    /// Body.
                    Padding(
                      padding: contentPadding,
                      child: SizedBox(
                        width: context.width,
                        child: bodyText != null
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  bodyText!,
                                  style: ctxth.textTheme.displayMedium,
                                ),
                              )
                            : child,
                      ),
                    ),

                    /// Actions.
                    if (actions != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: SizedBox(
                          width: context.width - horizontalInset,
                          child: Wrap(
                            runSpacing: 8.0,
                            alignment: leftAction == null
                                ? WrapAlignment.end
                                : WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (leftAction != null) ...[
                                const SizedBox(width: 6.0),
                                leftAction!,
                                const SizedBox(width: 6.0),
                              ],
                              ...actions!.addSeparators(
                                separator: const SizedBox(width: 6.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopupTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;
  const PopupTile({
    super.key,
    required this.icon,
    required this.title,
    this.description = "",
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        if (action != null) Padding(padding: EdgeInsets.all(3), child: action),
      ],
    );
  }
}
