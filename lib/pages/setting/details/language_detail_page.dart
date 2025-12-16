import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
// import 'package:yttrium_music/common/widgets/custome_widgets.dart';
// import 'package:yttrium_music/common/widgets/modal_manager.dart';
import 'package:yttrium_music/pages/setting/setting_detail_page.dart';
// import 'package:yttrium_music/common/utils/extensions.dart';

class LanguageDetailPage extends StatelessWidget {
  const LanguageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final modal = ModalManager(context: context);
    // final theme = Theme.of(context);
    final settingsController = Get.find<SettingsController>();
    return Obx(
      () => SettingDetailPage(
        title: 'Language',
        items: [
          SettingGroup(
            title: 'Locale',
            description: 'Select your language and country',
            icon: CupertinoIcons.globe,
            items: [
              SettingGroupItem(
                title: 'Language',
                icon: CupertinoIcons.textformat,
                subtitle: settingsController.language,
                onTap: () {},
              ),
              SettingGroupItem(
                title: 'Country',
                icon: CupertinoIcons.location,
                subtitle: "placeholder",
                roundBottom: true,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
