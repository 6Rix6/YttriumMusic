import 'package:flutter/material.dart';
import 'package:yttrium_music/common/widgets/custom_widgets.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class DialogWithList extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final ModalManager modalManager;
  const DialogWithList({
    super.key,
    required this.title,
    required this.items,
    required this.modalManager,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomBlurryDialog(
      titleWidget: Container(
        width: double.infinity,
        height: 60,
        color: theme.colorScheme.secondaryContainer,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => modalManager.closeDialog(),
          child: Text(t.general.cancel),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(spacing: 4, children: items),
      ),
    );
  }
}
