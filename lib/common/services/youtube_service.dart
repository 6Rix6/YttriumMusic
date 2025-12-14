import 'package:get/get.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/controllers/auth_controller.dart';

class YoutubeService extends GetxService {
  late final yt.YouTube youtube;
  final AuthController authController;
  final AudioPlayerController audioPlayerController;

  YoutubeService({
    required this.authController,
    required this.audioPlayerController,
  });

  Future<YoutubeService> init() async {
    youtube = yt.YouTube(
      cookie: authController.cookie.value,
      locale: yt.YouTubeLocale(gl: 'JP', hl: 'ja'),
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

  Future<void> playSong(yt.SongItem song) async {
    final player = await youtube.player(
      song.id,
      client: yt.YouTubeClient.android,
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
        await audioPlayerController.loadAudio(
          bestFormat.url!,
          title: song.title,
          artist: song.artists?.map((e) => e.name).join(', '),
          artworkUrl: song.thumbnails?.getBest()?.url,
        );
        audioPlayerController.play();
      },
      error: (value) {
        throw value;
      },
    );
  }
}
