// audio_player_controller.dart
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:yttrium_music/common/services/audio_handler.dart'; // MyAudioHandlerの型キャスト用

class AudioPlayerController extends GetxController {
  late final AudioHandler audioHandler;

  AudioPlayerController({required this.audioHandler});

  final isPlaying = false.obs;
  final isBuffering = false.obs;
  final processingState = AudioProcessingState.idle.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final currentMediaItem = Rxn<MediaItem>();

  bool get hasTrack => currentMediaItem.value != null;
  double get playerHeight => hasTrack ? 36 : 0;

  @override
  void onInit() {
    super.onInit();
    _bindAudioHandlerStreams();
  }

  void _bindAudioHandlerStreams() {
    final playbackState$ = audioHandler.playbackState;
    final mediaItem$ = audioHandler.mediaItem;
    final position$ = AudioService.position;

    isPlaying.bindStream(playbackState$.map((s) => s.playing));
    isBuffering.bindStream(
      playbackState$.map(
        (s) =>
            s.processingState == AudioProcessingState.buffering ||
            s.processingState == AudioProcessingState.loading,
      ),
    );
    processingState.bindStream(playbackState$.map((s) => s.processingState));

    currentMediaItem.bindStream(mediaItem$);
    duration.bindStream(
      mediaItem$.map((item) => item?.duration ?? Duration.zero),
    );

    position.bindStream(position$);
  }

  Future<void> loadAudio(
    String url, {
    String? title,
    String? artist,
    String? artworkUrl,
  }) async {
    if (audioHandler is MyAudioHandler) {
      await (audioHandler as MyAudioHandler).loadUrl(
        url,
        title: title,
        artist: artist,
        artworkUrl: artworkUrl,
      );
    }
  }

  void play() => audioHandler.play();

  void pause() => audioHandler.pause();

  void stop() => audioHandler.stop();

  void togglePlayPause() {
    if (isPlaying.value) {
      pause();
    } else {
      play();
    }
  }

  void seek(Duration pos) => audioHandler.seek(pos);
}
