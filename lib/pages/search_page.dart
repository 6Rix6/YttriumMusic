import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    final AudioPlayerController controller = Get.find<AudioPlayerController>();

    // final String testAudioUrl =
    //     "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
    // // 画面ロード時に音声をセット
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.loadAudio(testAudioUrl);
    // });

    return Scaffold(
      appBar: AppBar(title: const Text("GetX Audio Player")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ステータス表示
            Obx(() {
              if (controller.isBuffering.value) {
                return const CircularProgressIndicator();
              }
              return Text(
                controller.isPlaying.value ? "再生中" : "一時停止 / 停止",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),

            const SizedBox(height: 30),

            // スライダー（シークバー）
            Obx(() {
              final position = controller.position.value.inSeconds.toDouble();
              final duration = controller.duration.value.inSeconds.toDouble();

              // durationが0の場合はスライダーを動かせないようにする
              final maxDuration = duration > 0 ? duration : 1.0;
              final currentPosition = position > maxDuration
                  ? maxDuration
                  : position;

              return Column(
                children: [
                  Slider(
                    min: 0.0,
                    max: maxDuration,
                    value: currentPosition,
                    onChanged: (value) {
                      controller.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(controller.position.value)),
                      Text(_formatDuration(controller.duration.value)),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // コントロールボタン
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 再生・一時停止ボタン
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                      ),
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 時間を 00:00 形式にするヘルパーメソッド
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
