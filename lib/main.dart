import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:yttrium_music/common/services/storage_service.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/consts/color_schems.dart';
import 'package:yttrium_music/common/controllers/auth_controller.dart';
import 'package:yttrium_music/pages/home_page.dart';
import 'package:yttrium_music/pages/library_page.dart';
import 'package:yttrium_music/pages/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init services and controllers
  final storageService = await Get.putAsync(() => StorageService().init());
  final historyController = Get.put(
    AuthController(storageService: storageService),
  );
  final audioPlayerController = Get.put(AudioPlayerController());
  await Get.putAsync(
    () => YoutubeService(
      authController: historyController,
      audioPlayerController: audioPlayerController,
    ).init(),
  );

  // webview debug setting
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const YoutubeMusic());
}

class YoutubeMusic extends StatelessWidget {
  const YoutubeMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'YouTube Music',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[HomePage(), SearchPage(), LibraryPage()],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: theme.navigationBarTheme.backgroundColor,
          indicatorColor: Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(20),
            theme.colorScheme.secondaryContainer,
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          height: 64,
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}
