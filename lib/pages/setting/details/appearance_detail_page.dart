import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
import 'package:yttrium_music/common/widgets/custom_widgets.dart';
import 'package:yttrium_music/common/widgets/dialogs/dialog_with_list.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/pages/setting/setting_detail_page.dart';
import 'package:yttrium_music/common/utils/extensions.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class AppearanceDetailPage extends StatelessWidget {
  const AppearanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modal = ModalManager(context: context);
    final settingsController = Get.find<SettingsController>();
    // final theme = Theme.of(context);
    return Obx(
      () => SettingDetailPage(
        title: t.setting.iface.appearance.title,
        items: [
          SettingGroup(
            title: t.setting.iface.appearance.theme.title,
            description: t.setting.iface.appearance.theme.description,
            icon: LucideIcons.paintbrushVertical,
            items: [
              SettingGroupItem(
                icon: LucideIcons.sun,
                title: t.setting.iface.appearance.theme.themeMode.title,
                subtitle: settingsController.themeMode.toText(),
                onTap: () => modal.showPopup(
                  context,
                  dialog: DialogWithList(
                    title: t.setting.iface.appearance.theme.themeMode.title,
                    modalManager: modal,
                    items: [
                      Obx(
                        () => ListTileWithCheckMark(
                          title:
                              t.setting.iface.appearance.theme.themeMode.system,
                          icon: LucideIcons.monitor,
                          active:
                              settingsController.themeMode == ThemeMode.system,
                          onTap: () {
                            settingsController.themeMode = ThemeMode.system;
                            modal.closeDialog();
                          },
                        ),
                      ),
                      Obx(
                        () => ListTileWithCheckMark(
                          title:
                              t.setting.iface.appearance.theme.themeMode.light,
                          icon: LucideIcons.sun,
                          active:
                              settingsController.themeMode == ThemeMode.light,
                          onTap: () {
                            settingsController.themeMode = ThemeMode.light;
                            modal.closeDialog();
                          },
                        ),
                      ),
                      Obx(
                        () => ListTileWithCheckMark(
                          title:
                              t.setting.iface.appearance.theme.themeMode.dark,
                          icon: LucideIcons.moon,
                          active:
                              settingsController.themeMode == ThemeMode.dark,
                          onTap: () {
                            settingsController.themeMode = ThemeMode.dark;
                            modal.closeDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SettingGroupItem(
                icon: LucideIcons.palette,
                roundBottom: true,
                title: t.setting.iface.appearance.theme.dynamicColor.title,
                subtitle: settingsController.enableDynamicColor.toText(),
                trailing: Switch(
                  value: settingsController.enableDynamicColor,
                  onChanged: (value) {
                    settingsController.enableDynamicColor = value;
                  },
                ),
                onTap: () {
                  settingsController.enableDynamicColor =
                      !settingsController.enableDynamicColor;
                },
              ),
              // SettingGroupItem(
              //   icon: LucideIcons.paintBucket,
              //   title: "main color (light)",
              //   subtitle: "#FF0000",
              //   trailing: Container(
              //     width: 32,
              //     height: 32,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: theme.colorScheme.secondaryContainer,
              //     ),
              //     child: Center(
              //       child: Container(
              //         width: 24,
              //         height: 24,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: Colors.amberAccent,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SettingGroupItem(
              //   icon: LucideIcons.paintBucket,
              //   title: "main color (dark)",
              //   subtitle: "#FF0000",
              //   trailing: Container(
              //     width: 32,
              //     height: 32,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: theme.colorScheme.secondaryContainer,
              //     ),
              //     child: Center(
              //       child: Container(
              //         width: 24,
              //         height: 24,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: Colors.amberAccent,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
