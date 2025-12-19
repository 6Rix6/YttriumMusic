import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'package:yttrium_music/route.dart';

import 'package:yttrium_music/common/services/storage_service.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/common/services/audio_handler.dart';
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/controllers/auth_controller.dart';
import 'package:yttrium_music/common/controllers/settings_controller.dart';
import 'package:yttrium_music/common/controllers/theme_controller.dart';
import 'package:yttrium_music/common/controllers/youtube_search_controller.dart';

import 'package:yttrium_music/common/widgets/player/player.dart';
import 'package:yttrium_music/common/widgets/player/wallpaper.dart';

import 'package:yttrium_music/i18n/translations.g.dart';
import 'package:yttrium_music/common/utils/extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init services and controllers
  final storageService = await Get.putAsync(() => StorageService().init());
  final authController = Get.put(
    AuthController(storageService: storageService),
  );
  final settingsController = Get.put(
    SettingsController(storageService: storageService),
  );
  final themeController = Get.put(
    ThemeController(settingsController: settingsController),
  );
  final audioHandler = await Get.putAsync(() => initAudioService());
  final audioPlayerController = Get.put(
    AudioPlayerController(audioHandler: audioHandler),
  );
  await Get.putAsync(
    () => YoutubeService(
      authController: authController,
      audioPlayerController: audioPlayerController,
      themeController: themeController,
      settingsController: settingsController,
    ).init(),
  );
  Get.put(YoutubeSearchController());

  // set locale
  LocaleSettings.setLocaleRaw(settingsController.language.code);

  // request permissions
  // TODO: request only when app first launch
  await Permission.notification.request();

  // webview debug setting
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const YttriumMusic());
}

class YttriumMusic extends StatelessWidget {
  const YttriumMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => Obx(() {
        final themeController = Get.find<ThemeController>();
        return GetMaterialApp.router(
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          routeInformationProvider: goRouter.routeInformationProvider,
          title: 'YouTube Music',
          theme: _buildTheme(
            Brightness.light,
            themeController.shouldUseDynamicColor
                ? themeController.currentLightColorScheme.value!
                : lightColorScheme,
          ),
          darkTheme: _buildTheme(
            Brightness.dark,
            themeController.shouldUseDynamicColor
                ? themeController.currentDarkColorScheme.value!
                : darkColorScheme,
          ),
          themeMode: themeController.themeMode,
        );
      }),
    );
  }
}

ThemeData _buildTheme(Brightness brightness, ColorScheme? colorScheme) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    sliderTheme: SliderThemeData(year2023: false),
  );
}

class MainPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainPage({super.key, required this.navigationShell});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 2.1,
      lowerBound: -0.1,
      value: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioPlayer = Get.find<AudioPlayerController>();
    final playerChild = Player(animation: _animationController);
    final authController = Get.find<AuthController>();
    return Material(
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Row(
                  spacing: 12,
                  children: [
                    const Icon(
                      CupertinoIcons.arrowtriangle_right_circle_fill,
                      size: 28,
                    ),
                    const Text(
                      'Music',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.search),
                    onPressed: () => context.go('/search'),
                  ),
                  Obx(() {
                    final icon = authController.isLoggedIn.value
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  authController.accountPhotoUrl.value,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Icon(CupertinoIcons.person);
                    return IconButton(
                      icon: icon,
                      onPressed: () => context.push('/setting'),
                    );
                  }),
                ],
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
              body: widget.navigationShell,
              bottomNavigationBar: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      (kBottomNavigationBarHeight *
                              _animationController.value *
                              2)
                          .withMinimum(0),
                    ),
                    child: NavigationBarTheme(
                      data: NavigationBarThemeData(
                        backgroundColor:
                            theme.navigationBarTheme.backgroundColor,
                        indicatorColor: Color.alphaBlend(
                          theme.colorScheme.primary.withAlpha(20),
                          theme.colorScheme.secondaryContainer,
                        ),
                      ),
                      child: NavigationBar(
                        height: 64,
                        selectedIndex: widget.navigationShell.currentIndex,
                        labelBehavior:
                            NavigationDestinationLabelBehavior.onlyShowSelected,
                        destinations: [
                          NavigationDestination(
                            icon: Icon(Icons.home),
                            label: t.navigation.home,
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.search),
                            label: t.navigation.search,
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.library_music),
                            label: t.navigation.library,
                          ),
                        ],
                        onDestinationSelected: (index) {
                          widget.navigationShell.goBranch(
                            index,
                            initialLocation:
                                index == widget.navigationShell.currentIndex,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (_animationController.value > 0.01) {
                  return Container(
                    color: Colors.black.withValues(
                      alpha: (_animationController.value * 1.2).clamp(0, 1),
                    ),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor
                          .withValues(
                            alpha: (_animationController.value * 3 - 2).clamp(
                              0,
                              .8,
                            ),
                          ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),

          // Player Wallpaper
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (_animationController.value > 0.01) {
                  return Opacity(
                    opacity: _animationController.value.clamp(0.0, 1.0),
                    child: const Wallpaper(
                      gradient: false,
                      particleOpacity: .3,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),

          // Player
          Obx(() {
            final hasTrack = audioPlayer.hasTrack;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: hasTrack ? 1 : 0,
              child: hasTrack ? playerChild : null,
            );
          }),
        ],
      ),
    );
  }
}
