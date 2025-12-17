import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
import 'package:yttrium_music/common/widgets/custome_widgets.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/pages/setting/setting_detail_page.dart';
import 'package:yttrium_music/common/utils/extensions.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class AppearanceDetailPage extends StatelessWidget {
  const AppearanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modal = ModalManager(context: context);
    final theme = Theme.of(context);
    final settingsController = Get.find<SettingsController>();
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
                  dialog: CustomBlurryDialog(
                    titleWidget: Container(
                      width: double.infinity,
                      height: 60,
                      color: theme.colorScheme.secondaryContainer,
                      child: Center(
                        child: Text(
                          t.setting.iface.appearance.theme.themeMode.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => modal.closeDialog(),
                        child: Text(t.general.cancel),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        spacing: 4,
                        children: [
                          Obx(
                            () => ListTileWithCheckMark(
                              title: t
                                  .setting
                                  .iface
                                  .appearance
                                  .theme
                                  .themeMode
                                  .system,
                              icon: LucideIcons.monitor,
                              active:
                                  settingsController.themeMode ==
                                  ThemeMode.system,
                              onTap: () {
                                settingsController.themeMode = ThemeMode.system;
                                modal.closeDialog();
                              },
                            ),
                          ),
                          Obx(
                            () => ListTileWithCheckMark(
                              title: t
                                  .setting
                                  .iface
                                  .appearance
                                  .theme
                                  .themeMode
                                  .light,
                              icon: LucideIcons.sun,
                              active:
                                  settingsController.themeMode ==
                                  ThemeMode.light,
                              onTap: () {
                                settingsController.themeMode = ThemeMode.light;
                                modal.closeDialog();
                              },
                            ),
                          ),
                          Obx(
                            () => ListTileWithCheckMark(
                              title: t
                                  .setting
                                  .iface
                                  .appearance
                                  .theme
                                  .themeMode
                                  .dark,
                              icon: LucideIcons.moon,
                              active:
                                  settingsController.themeMode ==
                                  ThemeMode.dark,
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
            ],
          ),
        ],
      ),
    );
  }
}
