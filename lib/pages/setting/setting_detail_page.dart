import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
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
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(spacing: 12, children: items),
        ),
      ),
    );
  }
}

class SettingGroup extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<SettingGroupItem> items;
  const SettingGroup({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainer;
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // header
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListTile(
              title: Text(title),
              subtitle: Text(description),
              subtitleTextStyle: TextStyle(color: theme.hintColor),
              leading: Icon(icon),
              trailing: Icon(LucideIcons.chevronDown),
            ),
          ),
          // body
          Column(children: items),
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

  const SettingGroupItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
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
    );
  }
}
