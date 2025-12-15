import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
import 'package:yttrium_music/common/widgets/custome_widgets.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/pages/setting/setting_detail_page.dart';
import 'package:yttrium_music/common/utils/extensions.dart';

class AppearanceDetailPage extends StatelessWidget {
  const AppearanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modal = ModalManager(context: context);
    final theme = Theme.of(context);
    final settingsController = Get.find<SettingsController>();
    return Obx(
      () => SettingDetailPage(
        title: 'Appearance',
        items: [
          SettingGroup(
            title: 'Theme',
            description: 'Customize the look and feel.',
            icon: LucideIcons.paintbrushVertical,
            items: [
              SettingGroupItem(
                icon: LucideIcons.sun,
                title: 'Theme Mode',
                subtitle: settingsController.themeMode.name,
                onTap: () => modal.showPopup(
                  context,
                  dialog: CustomBlurryDialog(
                    titleWidget: Container(
                      width: double.infinity,
                      height: 60,
                      color: theme.colorScheme.secondaryContainer,
                      child: const Center(
                        child: Text(
                          "Select theme mode",
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
                        child: const Text('Cancel'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        spacing: 4,
                        children: [
                          Obx(
                            () => ListTileWithCheckMark(
                              title: 'System',
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
                              title: 'Light',
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
                              title: 'Dark',
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
                title: 'Dynamic Color',
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
