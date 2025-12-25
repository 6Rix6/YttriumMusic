import 'package:get/get.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/core/controllers/audio_player_controller.dart';
import 'package:yttrium_music/core/controllers/auth_controller.dart';
import 'package:yttrium_music/core/controllers/settings_controller.dart';
import 'package:yttrium_music/core/controllers/theme_controller.dart';

class YoutubeService extends GetxService {
  late final yt.YouTube youtube;
  final AuthController authController;
  final AudioPlayerController audioPlayerController;
  final ThemeController themeController;
  final SettingsController settingsController;

  YoutubeService({
    required this.authController,
    required this.audioPlayerController,
    required this.themeController,
    required this.settingsController,
  });

  Future<YoutubeService> init() async {
    youtube = yt.YouTube(
      cookie: authController.cookie.value,
      locale: yt.YouTubeLocale(
        gl: settingsController.country.code,
        hl: settingsController.language.code,
      ),
      onCookieUpdate: (cookie) {
        authController.setCookie(cookie);
      },
    );
    await youtube.initialize();
    return this;
  }

  Future<void> login(String cookie) async {
    final test = yt.YouTube(cookie: cookie);
    await test.initialize();
    final result = await test.accountInfo();
    result.when(
      success: (value) {
        if (value.accountName != null && value.accountHandle != null) {
          authController.login(
            cookie: cookie,
            accountName: value.accountName!,
            accountHandle: value.accountHandle!,
            accountPhotoUrl: value.accountPhoto?.thumbnails.first.url ?? "",
          );
          youtube.cookie = cookie;
        } else {
          throw Exception('Account info not found');
        }
      },
      error: (value) {
        throw value;
      },
    );
  }

  Future<void> logout() async {
    authController.logout();
    youtube.cookie = '';
  }

  Future<void> playSong(String id, {yt.SongItem? fallbackSong}) async {
    final player = await youtube.player(id, client: yt.YouTubeClient.android);
    final webPlayer = await youtube.player(
      id,
      client: yt.YouTubeClient.webRemix,
    );
    player.when(
      success: (playerResponse) async {
        if (playerResponse.playabilityStatus.status != 'OK') return;

        final audioFormats = playerResponse.streamingData?.adaptiveFormats
            .where((f) => f.isAudio && f.url != null)
            .toList();

        if (audioFormats == null || audioFormats.isEmpty) return;

        final bestFormat = audioFormats.reduce(
          (a, b) => (a.bitrate > b.bitrate) ? a : b,
        );
        final detail =
            webPlayer.value.videoDetails ?? playerResponse.videoDetails;

        final artworkUrl =
            webPlayer.value.videoDetails?.thumbnail.getBest()?.url ??
            playerResponse.videoDetails?.thumbnail.getBest()?.url ??
            fallbackSong?.thumbnails?.getBest()?.url;
        final title = detail?.title ?? fallbackSong?.title ?? "";
        final artist =
            detail?.author ??
            fallbackSong?.artists?.map((e) => e.name).join(', ') ??
            "";

        await audioPlayerController.loadAudio(
          bestFormat.url!,
          title: title,
          artist: artist,
          artworkUrl: artworkUrl,
        );
        audioPlayerController.play();

        if (artworkUrl != null) {
          themeController.setCurrentColorSchemeFromImageProvider(artworkUrl);
        }
      },
      error: (value) {
        throw value;
      },
    );
  }
}
