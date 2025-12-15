import 'package:flutter/material.dart';

class ListTileWithCheckMark extends StatelessWidget {
  final bool active;
  final void Function()? onTap;
  final String? title;
  final String subtitle;
  final IconData? icon;
  final Color? tileColor;
  final Widget? titleWidget;
  final Widget? leading;
  final double? iconSize;
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
    this.iconSize,
    this.dense = false,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // final tileAlpha = context.isDarkMode ? 5 : 20;
    final tileAlpha = 5;
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
