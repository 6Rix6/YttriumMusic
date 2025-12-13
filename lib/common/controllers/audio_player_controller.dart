import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final isPlaying = false.obs;
  final isBuffering = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  final processingState = ProcessingState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayerListeners();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // set streams
  void _setupAudioPlayerListeners() {
    isPlaying.bindStream(
      _audioPlayer.playerStateStream.map((state) => state.playing),
    );
    position.bindStream(_audioPlayer.positionStream);
    duration.bindStream(
      _audioPlayer.durationStream.map((d) => d ?? Duration.zero),
    );
    processingState.bindStream(
      _audioPlayer.playerStateStream.map((state) => state.processingState),
    );
    isBuffering.bindStream(
      _audioPlayer.playerStateStream.map(
        (state) =>
            state.processingState == ProcessingState.buffering ||
            state.processingState == ProcessingState.loading,
      ),
    );
  }

  // load audio from url
  Future<void> loadAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      Get.snackbar("Error", "Failed to load audio");
    }
  }

  // play
  void play() {
    _audioPlayer.play();
  }

  // pause
  void pause() {
    _audioPlayer.pause();
  }

  // stop
  void stop() {
    _audioPlayer.stop();
  }

  // seek
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}
