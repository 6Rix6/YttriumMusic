import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:yttrium_music/main.dart';
import 'package:yttrium_music/pages/album_page.dart';
import 'package:yttrium_music/pages/home_page.dart';
import 'package:yttrium_music/pages/library_page.dart';
import 'package:yttrium_music/pages/search_page.dart';
import 'package:yttrium_music/pages/setting/details/appearance_detail_page.dart';
import 'package:yttrium_music/pages/setting/details/language_detail_page.dart';
import 'package:yttrium_music/pages/setting/setting_page.dart';
import 'package:yttrium_music/pages/signin_page.dart';

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final searchResultNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'searchResult',
);
final albumNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'album');

final goRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/setting',
      name: 'setting',
      pageBuilder: (context, state) {
        return MaterialPage(key: state.pageKey, child: const SettingPage());
      },
      routes: [
        GoRoute(
          path: 'appearance',
          name: 'appearance',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const AppearanceDetailPage(),
            );
          },
        ),
        GoRoute(
          path: 'language',
          name: 'language',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const LanguageDetailPage(),
            );
          },
        ),
        GoRoute(
          path: "signin",
          name: "signin",
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const SigninPage());
          },
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: Get.key,
      builder: (context, state, navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: [
        // home branch
        StatefulShellBranch(
          navigatorKey: homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(),
                );
              },
            ),
          ],
        ),

        // library branch
        StatefulShellBranch(
          navigatorKey: libraryNavigatorKey,
          routes: [
            GoRoute(
              path: '/library',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const LibraryPage(),
                );
              },
            ),
          ],
        ),

        // search branch
        StatefulShellBranch(
          navigatorKey: searchNavigatorKey,
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const SearchPage(),
                );
              },
              routes: [
                GoRoute(
                  path: ':query',
                  name: 'searchResult',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: SearchResultPage(
                        query: state.pathParameters['query']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // StatefulShellBranch(
        //   navigatorKey: searchResultNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: '/search/:query',
        //       pageBuilder: (context, state) {
        //         return MaterialPage(
        //           key: state.pageKey,
        //           child: SearchResultPage(
        //             query: state.pathParameters['query']!,
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // ),

        // album branch
        StatefulShellBranch(
          navigatorKey: albumNavigatorKey,
          routes: [
            GoRoute(
              path: '/album',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const AlbumPage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(body: Center(child: Text(state.error.toString()))),
  ),
);
