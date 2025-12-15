import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/controllers/auth_controller.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/pages/login_page.dart';
import 'package:yttrium_music/pages/setting/details/appearance_detail_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainer;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            _SettingPageSection(
              title: 'Account',
              child: _buildAccountCard(surfaceColor),
            ),

            _SettingPageSection(
              title: 'Interface',
              child: _buildMenuSection(surfaceColor, [
                _MenuItem(
                  CupertinoIcons.color_filter,
                  'Appearance',
                  onTap: () => Get.to(() => const AppearanceDetailPage()),
                ),
                _MenuItem(
                  CupertinoIcons.bell,
                  'Notifications',
                  trailingText: '1',
                ),
                _MenuItem(CupertinoIcons.square_list, 'Display Mode'),
              ]),
            ),

            _SettingPageSection(
              title: 'Playback',
              child: _buildMenuSection(surfaceColor, [
                _MenuItem(CupertinoIcons.speaker_2, 'Equalizer'),
                _MenuItem(CupertinoIcons.shuffle, 'Crossfade'),
                _MenuItem(CupertinoIcons.infinite, 'Gapless Playback'),
              ]),
            ),

            _SettingPageSection(
              title: 'System',
              child: _buildMenuSection(surfaceColor, [
                _MenuItem(CupertinoIcons.textformat, 'Language'),
                _MenuItem(CupertinoIcons.floppy_disk, 'Storage'),
                _MenuItem(CupertinoIcons.lock, 'Data & Privacy'),
                _MenuItem(CupertinoIcons.info, 'About'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(Color surfaceColor) {
    return Obx(() {
      final theme = Theme.of(Get.context!);
      final authController = Get.find<AuthController>();
      final youtubeService = Get.find<YoutubeService>();
      final isLoggedIn = authController.isLoggedIn.value;
      final leading = Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade800,
        ),
        clipBehavior: Clip.antiAlias,
        child: isLoggedIn
            ? Image.network(authController.accountPhotoUrl.value)
            : const Icon(Icons.person),
      );
      final trailing = OutlinedButton(
        onPressed: () async {
          if (isLoggedIn) {
            youtubeService.logout();
          } else {
            final result =
                await Get.to(() => const LoginPage()) as LoginResult?;
            try {
              if (result != null) {
                await youtubeService.login(result.innerTubeCookie);
                Get.snackbar(
                  "Success",
                  "Logged in successfully",
                  snackPosition: SnackPosition.TOP,
                );
              } else {
                throw Exception("Login failed");
              }
            } catch (e) {
              Get.snackbar(
                "Error",
                e.toString(),
                snackPosition: SnackPosition.TOP,
              );
            }
          }
        },
        child: Text(isLoggedIn ? 'Sign out' : 'Sign in'),
      );
      final title = isLoggedIn ? authController.accountName.value : 'Sign in';
      final subtitle = isLoggedIn
          ? authController.accountHandle.value
          : 'Sign in with your Google account';
      return Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: leading,
          title: Text(title, style: const TextStyle(fontSize: 16)),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: theme.hintColor),
          ),
          trailing: trailing,
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    });
  }

  Widget _buildMenuSection(Color color, List<_MenuItem> items) {
    final theme = Theme.of(Get.context!);
    return Column(
      spacing: 2,
      children: items.map((item) {
        final isFirstItem = items.indexOf(item) == 0;
        final isLastItem = items.indexOf(item) == items.length - 1;
        final radius = BorderRadius.vertical(
          top: Radius.circular(isFirstItem ? 16 : 4),
          bottom: Radius.circular(isLastItem ? 16 : 4),
        );
        return Material(
          color: color,
          borderRadius: radius,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade800,
              ),
              child: Icon(item.icon, size: 24),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: item.trailingText != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text(
                      item.trailingText!,
                      style: TextStyle(fontSize: 16, color: theme.hintColor),
                    ),
                  )
                : null,
            onTap: item.onTap,
            shape: RoundedRectangleBorder(borderRadius: radius),
          ),
        );
      }).toList(),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  _MenuItem(this.icon, this.title, {this.trailingText, this.onTap});
}

class _SettingPageSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingPageSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: theme.hintColor),
          ),
        ),
        child,
      ],
    );
  }
}
