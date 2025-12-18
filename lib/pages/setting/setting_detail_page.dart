import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingDetailPage extends StatelessWidget {
  final String title;
  final List<SettingGroup> items;
  const SettingDetailPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(spacing: 12, children: items),
        ),
      ),
    );
  }
}

// class SettingGroup extends StatelessWidget {
//   final String title;
//   final String description;
//   final IconData icon;
//   final List<SettingGroupItem> items;
//   const SettingGroup({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final surfaceColor = theme.colorScheme.surfaceContainer;
//     return Container(
//       decoration: BoxDecoration(
//         color: surfaceColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             blurRadius: 16,
//             offset: Offset(0, 8),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // header
//           Container(
//             decoration: BoxDecoration(
//               color: theme.colorScheme.secondaryContainer,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: ListTile(
//               title: Text(title),
//               subtitle: Text(description),
//               subtitleTextStyle: TextStyle(color: theme.hintColor),
//               leading: Icon(icon),
//               trailing: Icon(LucideIcons.chevronDown),
//             ),
//           ),
//           // body
//           Column(children: items),
//         ],
//       ),
//     );
//   }
// }

class SettingGroup extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<SettingGroupItem> items;
  // options
  final bool isExpansionInteractive;
  final bool initialExpanded;

  const SettingGroup({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
    this.isExpansionInteractive = true,
    this.initialExpanded = true,
  });

  @override
  State<SettingGroup> createState() => _SettingGroupState();
}

class _SettingGroupState extends State<SettingGroup> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainer;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 32,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.isExpansionInteractive) return;
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: Radius.circular(_isExpanded ? 0 : 16),
                ),
              ),
              child: ListTile(
                title: Text(widget.title),
                subtitle: Text(widget.description),
                subtitleTextStyle: TextStyle(color: theme.hintColor),
                leading: Icon(widget.icon),
                trailing: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(LucideIcons.chevronDown),
                ),
              ),
            ),
          ),

          // Body
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Material(
              color: theme.colorScheme.surfaceContainer,
              child: _isExpanded
                  ? Column(children: widget.items)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingGroupItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool roundBottom;

  const SettingGroupItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.roundBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      subtitleTextStyle: TextStyle(color: theme.hintColor),
      trailing: trailing,
      onTap: onTap,
      shape: roundBottom
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            )
          : null,
    );
  }
}
