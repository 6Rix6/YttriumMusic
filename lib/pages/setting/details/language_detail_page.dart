import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
import 'package:yttrium_music/common/widgets/custome_widgets.dart';
import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/common/enums/locale.dart';
import 'package:yttrium_music/pages/setting/setting_detail_page.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class LanguageDetailPage extends StatelessWidget {
  const LanguageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modal = ModalManager(context: context);
    final theme = Theme.of(context);
    final settingsController = Get.find<SettingsController>();
    return Obx(
      () => SettingDetailPage(
        title: t.setting.system.language.title,
        items: [
          SettingGroup(
            title: t.setting.system.language.locale.title,
            description: t.setting.system.language.locale.description,
            icon: CupertinoIcons.globe,
            items: [
              SettingGroupItem(
                title: t.setting.system.language.locale.language.title,
                icon: CupertinoIcons.textformat,
                subtitle: settingsController.language.name,
                onTap: () => modal.showPopup(
                  context,
                  dialog: CustomBlurryDialog(
                    titleWidget: Container(
                      width: double.infinity,
                      height: 60,
                      color: theme.colorScheme.secondaryContainer,
                      child: Center(
                        child: Text(
                          t.setting.system.language.locale.language.title,
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
                          ...Language.values.map(
                            (e) => Obx(
                              () => ListTileWithCheckMark(
                                title: e.name,
                                iconWidget: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e.name[0],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                active: settingsController.language == e,
                                onTap: () {
                                  settingsController.language = e;
                                  modal.closeDialog();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SettingGroupItem(
                title: t.setting.system.language.locale.country.title,
                icon: CupertinoIcons.location,
                subtitle: settingsController.country.name,
                roundBottom: true,
                onTap: () => modal.showPopup(
                  context,
                  dialog: CustomBlurryDialog(
                    titleWidget: Container(
                      width: double.infinity,
                      height: 60,
                      color: theme.colorScheme.secondaryContainer,
                      child: Center(
                        child: Text(
                          t.setting.system.language.locale.country.title,
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
                          ...Country.values.map(
                            (e) => Obx(
                              () => ListTileWithCheckMark(
                                title: e.name,
                                iconWidget: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e.name[0],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                active: settingsController.country == e,
                                onTap: () {
                                  settingsController.country = e;
                                  modal.closeDialog();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
