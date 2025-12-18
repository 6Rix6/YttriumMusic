import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:yttrium_music/common/utils/extensions.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';

class ListTileWithCheckMark extends StatelessWidget {
  final bool active;
  final void Function()? onTap;
  final String? title;
  final String subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final double? iconSize;
  final Color? tileColor;
  final Widget? titleWidget;
  final Widget? leading;
  final bool dense;
  final bool expanded;

  const ListTileWithCheckMark({
    super.key,
    this.active = false,
    this.onTap,
    this.title,
    this.subtitle = '',
    this.icon = Icons.circle_outlined,
    this.tileColor,
    this.titleWidget,
    this.leading,
    this.iconWidget,
    this.iconSize,
    this.dense = false,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final tileAlpha = isDark ? 20 : 10;
    final br = BorderRadius.circular(8.0);
    final titleWidgetFinal = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10.0 : 14.0,
        vertical: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget ?? Text(title ?? ''),
          if (subtitle != '') Text(subtitle, style: textTheme.displaySmall),
        ],
      ),
    );
    return Material(
      borderRadius: br,
      color:
          tileColor ??
          Color.alphaBlend(
            theme.colorScheme.onSurface.withAlpha(tileAlpha),
            theme.cardColor,
          ),
      child: InkWell(
        borderRadius: br,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (leading != null)
                leading!
              else if (iconWidget != null)
                iconWidget!
              else if (icon != null)
                Icon(icon, size: iconSize),
              expanded
                  ? Expanded(child: titleWidgetFinal)
                  : Flexible(child: titleWidgetFinal),
              active ? const Icon(Icons.check) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
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
