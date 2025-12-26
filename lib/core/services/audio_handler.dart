// audio_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.yttrium_music.audio',
      androidNotificationChannelName: 'YTMusic',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> loadUrl(
    String url, {
    String? title,
    String? artist,
    String? artworkUrl,
  }) async {
    try {
      final item = MediaItem(
        id: url,
        title: title ?? "Unknown Title",
        artist: artist ?? "Unknown Artist",
        duration: null,
        artUri: artworkUrl != null ? Uri.parse(artworkUrl) : null,
      );

      mediaItem.add(item);
      await _player.setAudioSource(_createAudioSource(url));

      if (_player.duration != null) {
        mediaItem.add(item.copyWith(duration: _player.duration));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load audio");
    }
  }

  AudioSource _createAudioSource(String urlOrPath) {
    if (urlOrPath.startsWith('http://') || urlOrPath.startsWith('https://')) {
      return AudioSource.uri(Uri.parse(urlOrPath));
    } else {
      return AudioSource.file(urlOrPath);
    }
  }
}
