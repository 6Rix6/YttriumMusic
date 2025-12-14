// ignore_for_file: dead_code
// This is originally a part of [Tear Music](https://github.com/tearone/tearmusic)
// Credits goes for the original author @55nknown

import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/utils/duration_format.dart';
// import 'package:kikoeru/widgets/common/work_cover_image.dart';
// import 'package:provider/provider.dart';
// import 'package:kikoeru/core/providers/audio_player_provider.dart';
// import 'package:kikoeru/core/providers/will_pop_provider.dart';
import 'track_image.dart';
import 'track_info.dart';
// import 'queue/queue_view.dart';
import 'package:yttrium_music/common/utils/player_ui_utils.dart';

enum PlayerState { mini, expanded, queue }

class Player extends StatefulWidget {
  const Player({super.key, required this.animation});

  final AnimationController animation;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  double offset = 0.0;
  double prevOffset = 0.0;
  Size screenSize = Size.zero;
  double topInset = 0.0;
  double bottomInset = 0.0;
  double maxOffset = 0.0;
  final velocity = VelocityTracker.withKind(PointerDeviceKind.touch);
  static const Cubic bouncingCurve = Cubic(0.175, 0.885, 0.32, 1.125);

  static const headRoom = 50.0;
  static const actuationOffset = 100.0; // min distance to snap
  static const deadSpace = 100.0; // Distance from bottom to ignore swipes
  static const bottomOffsetClosed = kBottomNavigationBarHeight;

  /// Horizontal track switching
  double sOffset = 0.0;
  double sPrevOffset = 0.0;
  double stParallax = 1.0;
  double siParallax = 1.15;
  static const sActuationMulti = 1.5;
  double sMaxOffset = 0.0;
  late AnimationController sAnim;

  late AnimationController playPauseAnim;

  late ScrollController scrollController;
  bool queueScrollable = false;
  bool bounceUp = false;
  bool bounceDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final media = MediaQueryData.fromView(View.of(context));
      topInset = media.padding.top;
      bottomInset = media.padding.bottom;
      screenSize = media.size;
      maxOffset = screenSize.height;
      sMaxOffset = screenSize.width;
      setState(() {});
    });

    sAnim = AnimationController(
      vsync: this,
      lowerBound: -1,
      upperBound: 1,
      value: 0.0,
    );
    playPauseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    sAnim.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void verticalSnapping() {
    final distance = prevOffset - offset;
    final speed = velocity.getVelocity().pixelsPerSecond.dy;
    const threshold = 500.0;

    // speed threshold is an eyeballed value
    // used to actuate on fast flicks too

    if (prevOffset > maxOffset) {
      // Start from queue
      if (speed > threshold || distance > actuationOffset) {
        snapToExpanded();
      } else {
        snapToQueue();
      }
    } else if (prevOffset > maxOffset / 2) {
      // Start from top
      if (speed > threshold || distance > actuationOffset) {
        snapToMini();
      } else if (-speed > threshold || -distance > actuationOffset) {
        snapToQueue();
      } else {
        snapToExpanded();
      }
    } else {
      // Start from bottom
      if (-speed > threshold || -distance > actuationOffset) {
        snapToExpanded();
      } else {
        snapToMini();
      }
    }
  }

  void snapToExpanded({bool haptic = true}) {
    offset = maxOffset;
    if (prevOffset < maxOffset) bounceUp = true;
    if (prevOffset > maxOffset) bounceDown = true;
    snap(haptic: haptic);
  }

  void snapToMini({bool haptic = true}) {
    offset = 0;
    bounceDown = false;
    snap(haptic: haptic);
  }

  void snapToQueue({bool haptic = true}) {
    offset = maxOffset * 2;
    bounceUp = false;
    snap(haptic: haptic);
  }

  void snap({bool haptic = true}) {
    widget.animation
        .animateTo(
          offset / maxOffset,
          curve: bouncingCurve,
          duration: const Duration(milliseconds: 300),
        )
        .then((_) {
          bounceUp = false;
        });
    if (haptic && (prevOffset - offset).abs() > actuationOffset) {
      HapticFeedback.lightImpact();
    }
  }

  void snapToPrev() {
    sOffset = -sMaxOffset;
    sAnim
        .animateTo(
          -1.0,
          curve: bouncingCurve,
          duration: const Duration(milliseconds: 300),
        )
        .then((_) {
          sOffset = 0;
          sAnim.animateTo(0.0, duration: Duration.zero);
          // tracks.insert(0, tracks.removeLast());
        });
    if ((sPrevOffset - sOffset).abs() > actuationOffset) {
      HapticFeedback.lightImpact();
    }
  }

  void snapToCurrent() {
    sOffset = 0;
    sAnim.animateTo(
      0.0,
      curve: bouncingCurve,
      duration: const Duration(milliseconds: 300),
    );
    if ((sPrevOffset - sOffset).abs() > actuationOffset) {
      HapticFeedback.lightImpact();
    }
  }

  void snapToNext() {
    sOffset = sMaxOffset;
    sAnim
        .animateTo(
          1.0,
          curve: bouncingCurve,
          duration: const Duration(milliseconds: 300),
        )
        .then((_) {
          sOffset = 0;
          sAnim.animateTo(0.0, duration: Duration.zero);
          // tracks.add(tracks.removeAt(0));
        });
    if ((sPrevOffset - sOffset).abs() > actuationOffset) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Get.find<AudioPlayerController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Listener(
      onPointerDown: (event) {
        if (event.position.dy > screenSize.height - deadSpace) return;

        velocity.addPosition(event.timeStamp, event.position);

        prevOffset = offset;

        bounceUp = false;
        bounceDown = false;
      },
      onPointerMove: (event) {
        if (event.position.dy > screenSize.height - deadSpace) return;

        velocity.addPosition(event.timeStamp, event.position);

        if (offset <= maxOffset) return;
        if (scrollController.positions.isNotEmpty &&
            scrollController.positions.first.pixels > 0.0 &&
            offset >= maxOffset * 2) {
          return;
        }

        offset -= event.delta.dy;
        offset = offset.clamp(-headRoom, maxOffset * 2);

        widget.animation.animateTo(offset / maxOffset, duration: Duration.zero);

        setState(() => queueScrollable = offset >= maxOffset * 2);
      },
      onPointerUp: (event) {
        if (offset <= maxOffset) return;
        if (scrollController.positions.isNotEmpty &&
            scrollController.positions.first.pixels > 0.0 &&
            offset >= maxOffset * 2) {
          return;
        }

        setState(() => queueScrollable = true);
        verticalSnapping();
      },
      child: GestureDetector(
        /// Tap
        onTap: () {
          if (widget.animation.value < (actuationOffset / maxOffset)) {
            snapToExpanded();
          }
        },

        /// Vertical
        onVerticalDragUpdate: (details) {
          if (details.globalPosition.dy > screenSize.height - deadSpace) {
            return;
          }
          if (offset > maxOffset) return;

          offset -= details.primaryDelta ?? 0;
          offset = offset.clamp(-headRoom, maxOffset * 2 + headRoom / 2);

          widget.animation.animateTo(
            offset / maxOffset,
            duration: Duration.zero,
          );
        },
        onVerticalDragEnd: (_) => verticalSnapping(),

        /// Horizontal
        onHorizontalDragStart: (details) {
          return;
          if (offset > maxOffset) return;

          sPrevOffset = sOffset;
        },
        onHorizontalDragUpdate: (details) {
          return;
          if (offset > maxOffset) return;
          if (details.globalPosition.dy > screenSize.height - deadSpace) {
            return;
          }

          sOffset -= details.primaryDelta ?? 0.0;
          sOffset = sOffset.clamp(-sMaxOffset, sMaxOffset);

          sAnim.animateTo(sOffset / sMaxOffset, duration: Duration.zero);
        },
        onHorizontalDragEnd: (details) {
          return;
          if (offset > maxOffset) return;

          final distance = sPrevOffset - sOffset;
          final speed = velocity.getVelocity().pixelsPerSecond.dx;
          const threshold = 1000.0;

          // speed threshold is an eyeballed value
          // used to actuate on fast flicks too

          if (speed > threshold ||
              distance > actuationOffset * sActuationMulti) {
            snapToPrev();
          } else if (-speed > threshold ||
              -distance > actuationOffset * sActuationMulti) {
            snapToNext();
          } else {
            snapToCurrent();
          }
        },

        // Child
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            final Color onSecondary = Theme.of(
              context,
            ).colorScheme.onSecondaryContainer;

            final double progressValue = widget.animation.value;
            final double clampedProgressValue = progressValue.clamp(0, 1);
            final double inverseProgressValue = 1 - progressValue;
            final double inverseClampedProgressValue = 1 - clampedProgressValue;

            final double reverseProgressValue = inverseAboveOne(progressValue);
            final double reverseClampedProgressValue = reverseProgressValue
                .clamp(0, 1);

            final double queueProgressValue =
                progressValue.clamp(1.0, 3.0) - 1.0;
            final double queueClampedProgressValue = queueProgressValue.clamp(
              0.0,
              1.0,
            );

            final double bounceProgressValue = !bounceUp
                ? !bounceDown
                      ? reverseProgressValue
                      : 1 - (progressValue - 1)
                : progressValue;
            final double bounceClampedProgressValue = bounceProgressValue.clamp(
              0.0,
              1.0,
            );

            final BorderRadius borderRadius = BorderRadius.only(
              topLeft: Radius.circular(24.0 + 6.0 * progressValue),
              topRight: Radius.circular(24.0 + 6.0 * progressValue),
              bottomLeft: Radius.circular(
                24.0 * (1 - progressValue * 10 + 9).clamp(0, 1),
              ),
              bottomRight: Radius.circular(
                24.0 * (1 - progressValue * 10 + 9).clamp(0, 1),
              ),
            );
            final double bottomOffset =
                (-bottomOffsetClosed * inverseClampedProgressValue +
                    progressValue.clamp(-1, 0) * -200) -
                (bottomInset * inverseClampedProgressValue);
            final double opacity = (bounceClampedProgressValue * 5 - 4).clamp(
              0,
              1,
            );
            final double fastOpacity = (bounceClampedProgressValue * 10 - 9)
                .clamp(0, 1);
            double panelHeight = maxOffset / 1.6;
            if (progressValue > 1.0) {
              panelHeight = rangeProgress(
                a: panelHeight,
                b: maxOffset / 1.6 - 100.0 - topInset,
                c: queueClampedProgressValue,
              );
            }

            // final double queueOpacity = ((p.clamp(1.0, 3.0) - 1).clamp(0.0, 1.0) * 4 - 3).clamp(0, 1);
            final double queueOffset = queueProgressValue;

            return MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: Stack(
                children: [
                  /// Player Body
                  Container(
                    color: progressValue > 0 ? Colors.transparent : null,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: Offset(0, bottomOffset),
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  12 *
                                  (1 - clampedProgressValue * 10 + 9).clamp(
                                    0,
                                    1,
                                  ),
                              vertical: 12 * inverseClampedProgressValue,
                            ),
                            child: Container(
                              height: rangeProgress(
                                a: 82.0,
                                b: panelHeight,
                                c: progressValue.clamp(0, 3),
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                borderRadius: borderRadius,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: .15 * clampedProgressValue,
                                    ),
                                    blurRadius: 32.0,
                                  ),
                                ],
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withAlpha(50)
                                      : Colors.grey.withAlpha(50),
                                  width: 1,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).cardColor.withValues(
                                        alpha: rangeProgress(
                                          a: 1.0,
                                          b: .9,
                                          c: inverseClampedProgressValue,
                                        ),
                                      ),
                                      Theme.of(context).cardColor.withValues(
                                        alpha: rangeProgress(
                                          a: .0,
                                          b: .9,
                                          c: inverseClampedProgressValue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Top Row
                  if (reverseClampedProgressValue > 0.0)
                    Material(
                      type: MaterialType.transparency,
                      child: Opacity(
                        opacity: reverseClampedProgressValue,
                        child: Transform.translate(
                          offset: Offset(0, (1 - bounceProgressValue) * -100),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      snapToMini();
                                    },
                                    icon: Icon(
                                      CupertinoIcons.chevron_down,
                                      color: onSecondary,
                                    ),
                                    iconSize: 26.0,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(45.0),
                                      onTap: () {
                                        if (audioPlayer.hasTrack) {
                                          snapToMini();
                                          // TODO: jump this work info page
                                          // AlbumView.view(
                                          //   currentMusic.playing!.album!,
                                          //   context: context,
                                          // ).then(
                                          //   (_) => context
                                          //       .read<ThemeProvider>()
                                          //       .resetTheme(),
                                          // );
                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Playing from",
                                            style: TextStyle(
                                              color: onSecondary.withValues(
                                                alpha: .8,
                                              ),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            audioPlayer
                                                    .currentMediaItem
                                                    .value
                                                    ?.album ??
                                                "",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.0,
                                              color: onSecondary.withValues(
                                                alpha: .9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        useRootNavigator: true,
                                        builder: (context) =>
                                            Container(height: 300),
                                      );
                                    },
                                    icon: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: .2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.ellipsis,
                                        color: onSecondary,
                                      ),
                                    ),
                                    iconSize: 26.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  /// Controls
                  Material(
                    type: MaterialType.transparency,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        bottomOffset +
                            (-maxOffset / 7.0 * bounceProgressValue) +
                            ((-maxOffset + topInset + 80.0) *
                                (!bounceUp
                                    ? !bounceDown
                                          ? queueProgressValue
                                          : (1 - bounceProgressValue)
                                    : 0.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          12.0 * inverseClampedProgressValue,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              // shuffle, prev, next, repeat
                              if (fastOpacity > 0.0) ...[
                                Opacity(
                                  opacity: fastOpacity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          24.0 *
                                          (16 *
                                                  (!bounceDown
                                                      ? inverseClampedProgressValue
                                                      : 0.0) +
                                              1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          iconSize: 28.0,
                                          icon: Icon(CupertinoIcons.shuffle),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          iconSize: 28.0,
                                          icon: Icon(CupertinoIcons.repeat),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: fastOpacity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          84.0 *
                                          (2 *
                                                  (!bounceDown
                                                      ? inverseClampedProgressValue
                                                      : 0.0) +
                                              1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          iconSize: 40.0,
                                          icon: Icon(
                                            Icons.skip_previous_rounded,
                                          ),
                                          onPressed: () {
                                            snapToPrev();
                                            // audioPlayer.previous();
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 40.0,
                                          icon: Icon(Icons.skip_next_rounded),
                                          onPressed: () {
                                            snapToNext();
                                            // audioPlayer.next();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

                              Padding(
                                padding: EdgeInsets.all(12.0 * inverseClampedProgressValue).add(
                                  EdgeInsets.only(
                                    right: !bounceDown
                                        ? !bounceUp
                                              ? screenSize.width *
                                                        reverseClampedProgressValue /
                                                        2 -
                                                    80 *
                                                        reverseClampedProgressValue /
                                                        2 +
                                                    (queueProgressValue * 24.0)
                                              : screenSize.width *
                                                        clampedProgressValue /
                                                        2 -
                                                    80 *
                                                        clampedProgressValue /
                                                        2
                                        : screenSize.width *
                                                  bounceClampedProgressValue /
                                                  2 -
                                              80 *
                                                  bounceClampedProgressValue /
                                                  2 +
                                              (queueProgressValue * 24.0),
                                  ),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    floatingActionButtonTheme:
                                        FloatingActionButtonThemeData(
                                          sizeConstraints: BoxConstraints.tight(
                                            Size.square(
                                              rangeProgress(
                                                a: 60.0,
                                                b: 80.0,
                                                c: reverseProgressValue,
                                              ),
                                            ),
                                          ),
                                          iconSize: rangeProgress(
                                            a: 32.0,
                                            b: 46.0,
                                            c: reverseProgressValue,
                                          ),
                                        ),
                                  ),
                                  child: Obx(() {
                                    final processingState =
                                        audioPlayer.processingState.value;
                                    Widget playbackIndicator;

                                    if (processingState ==
                                        AudioProcessingState.loading) {
                                      playbackIndicator = SizedBox(
                                        key: const Key("loading"),
                                        height: rangeProgress(
                                          a: 60.0,
                                          b: 80.0,
                                          c: reverseProgressValue,
                                        ),
                                        width: rangeProgress(
                                          a: 60.0,
                                          b: 80.0,
                                          c: reverseProgressValue,
                                        ),
                                        child: Center(
                                          child:
                                              LoadingAnimationWidget.staggeredDotsWave(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                                size: 42.0,
                                              ),
                                        ),
                                      );
                                    } else if (processingState ==
                                        AudioProcessingState.error) {
                                      playbackIndicator = SizedBox(
                                        key: const Key("error"),
                                        height: rangeProgress(
                                          a: 60.0,
                                          b: 80.0,
                                          c: reverseProgressValue,
                                        ),
                                        width: rangeProgress(
                                          a: 60.0,
                                          b: 80.0,
                                          c: reverseProgressValue,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.warning,
                                            size: 42.0,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                        ),
                                      );
                                    } else {
                                      playbackIndicator = Obx(() {
                                        final playing =
                                            audioPlayer.isPlaying.value;
                                        final position =
                                            audioPlayer.position.value;
                                        final duration =
                                            audioPlayer.duration.value;

                                        if (playing) {
                                          playPauseAnim.forward();
                                        } else {
                                          playPauseAnim.reverse();
                                        }

                                        final progress =
                                            duration.inMilliseconds == 0
                                            ? 0.0
                                            : position.inMilliseconds /
                                                  duration.inMilliseconds;

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
                                          ),
                                          child: CustomPaint(
                                            painter: MiniplayerProgressPainter(
                                              progress *
                                                  (1 -
                                                      reverseClampedProgressValue),
                                              indicatorColor: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            child: FloatingActionButton(
                                              backgroundColor:
                                                  Colors.transparent,
                                              heroTag: null,
                                              onPressed:
                                                  audioPlayer.togglePlayPause,
                                              elevation: 0,
                                              child: AnimatedIcon(
                                                progress: playPauseAnim,
                                                icon: AnimatedIcons.play_pause,
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    }

                                    return PageTransitionSwitcher(
                                      transitionBuilder:
                                          (
                                            child,
                                            primaryAnimation,
                                            secondaryAnimation,
                                          ) {
                                            return FadeThroughTransition(
                                              animation: primaryAnimation,
                                              secondaryAnimation:
                                                  secondaryAnimation,
                                              fillColor: Colors.transparent,
                                              child: child,
                                            );
                                          },
                                      child: playbackIndicator,
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Track Info
                  Material(
                    type: MaterialType.transparency,
                    child: AnimatedBuilder(
                      animation: sAnim,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Opacity(
                              opacity: 1 - sAnim.value.abs(),
                              child: Transform.translate(
                                offset: Offset(
                                  -sAnim.value * sMaxOffset / stParallax +
                                      (12.0 * queueProgressValue),
                                  (-maxOffset + topInset + 102.0) *
                                      (!bounceUp
                                          ? !bounceDown
                                                ? queueProgressValue
                                                : (1 - bounceProgressValue)
                                          : 0.0),
                                ),
                                child: Obx(
                                  () => TrackInfo(
                                    artist:
                                        audioPlayer
                                            .currentMediaItem
                                            .value
                                            ?.artist ??
                                        "",
                                    title:
                                        audioPlayer
                                            .currentMediaItem
                                            .value
                                            ?.title ??
                                        "",
                                    p: bounceProgressValue,
                                    cp: bounceClampedProgressValue,
                                    bottomOffset: bottomOffset,
                                    maxOffset: maxOffset,
                                    screenSize: screenSize,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Track Image
                  AnimatedBuilder(
                    animation: sAnim,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          Opacity(
                            opacity: 1 - sAnim.value.abs(),
                            child: Transform.translate(
                              offset: Offset(
                                -sAnim.value * sMaxOffset / siParallax,
                                !bounceUp
                                    ? (-maxOffset + topInset + 108.0) *
                                          (!bounceDown
                                              ? queueProgressValue
                                              : (1 - bounceProgressValue))
                                    : 0.0,
                              ),
                              // artwork
                              child: Obx(
                                () => TrackImage(
                                  image: Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 400,
                                          width: 400,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                audioPlayer
                                                        .currentMediaItem
                                                        .value
                                                        ?.artUri
                                                        .toString() ??
                                                    "",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // WorkCoverImage(
                                        //   uri:
                                        //       snapshot.data?.artUri
                                        //           .toString() ??
                                        //       "",
                                        //   size: Size(400, 400),
                                        //   blurRadius: 10 * (y * 2),
                                        //   placeholderIconSize: 30 * y,
                                        // ),
                                        // if (progressValue == 1)
                                        //   Container(
                                        //     height: 400,
                                        //     width: 400,
                                        //     color: Colors.transparent,
                                        //     child: OverlayControls(),
                                        //   ),
                                      ],
                                    ),
                                  ),
                                  p: bounceProgressValue,
                                  cp: bounceClampedProgressValue,
                                  width: rangeProgress(
                                    a: 82.0,
                                    b: 92.0,
                                    c: queueProgressValue,
                                  ),
                                  screenSize: screenSize,
                                  bottomOffset: bottomOffset,
                                  maxOffset: maxOffset,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Slider
                  Offstage(
                    offstage: fastOpacity == 0.0,
                    child: Opacity(
                      opacity: fastOpacity,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          bottomOffset + (-maxOffset / 4.0 * progressValue),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Obx(() {
                            final position = audioPlayer.position.value;
                            final duration = audioPlayer.duration.value;

                            final dHours = position.inHours > 0;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: ExSeekBar(
                                      position: position,
                                      duration: duration,
                                      onChanged: (value) {
                                        audioPlayer.seek(value);
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          if (dHours) ...[
                                            AnimatedFlipCounter(
                                              value: position.inHours,
                                              curve: Curves.easeIn,
                                              textStyle: const TextStyle(
                                                letterSpacing: -.5,
                                              ),
                                            ),
                                            const Text(":"),
                                          ],

                                          AnimatedFlipCounter(
                                            value: position.inMinutes % 60,
                                            wholeDigits: dHours ? 2 : 1,
                                            curve: Curves.easeIn,
                                            textStyle: const TextStyle(
                                              letterSpacing: -.5,
                                            ),
                                          ),

                                          const Text(
                                            ":",
                                            style: TextStyle(letterSpacing: 1),
                                          ),

                                          AnimatedFlipCounter(
                                            value: position.inSeconds % 60,
                                            wholeDigits: 2,
                                            textStyle: const TextStyle(
                                              letterSpacing: -.5,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Text(duration.shortFormat()),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  // queue list
                  Transform.translate(
                    offset: Offset(0, (1 - queueOffset) * maxOffset),
                    child: IgnorePointer(
                      ignoring: !queueScrollable,
                      // child: QueueView(controller: scrollController),
                    ),
                  ),

                  /// Destination selector
                  if (opacity > 0.0)
                    Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, -100 * inverseProgressValue),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 24.0,
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.headphones,
                                        size: 18.0,
                                        color: onSecondary,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 14.0,
                                      ),
                                      child: Text('Headphones'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Lyrics button
                  if (opacity > 0.0)
                    Material(
                      type: MaterialType.transparency,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(-50, -100 * inverseProgressValue),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 24.0,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // final track = context
                                    //     .read<CurrentMusicProvider>()
                                    //     .playing!;
                                    // LyricsView.view(track, context: context);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.quote_bubble,
                                    size: 28.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Queue button
                  Offstage(
                    offstage: opacity == 0.0,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(0, -100 * inverseProgressValue),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 24.0,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    snapToQueue();
                                  },
                                  icon: Icon(
                                    CupertinoIcons.music_note_list,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MiniplayerProgressPainter extends CustomPainter {
  final double progress;
  final Color indicatorColor;
  final Color backgroundColor;
  static const strokeWidth = 4.0;
  MiniplayerProgressPainter(
    this.progress, {
    this.indicatorColor = Colors.white,
    this.backgroundColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16.0),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          strokeWidth,
          strokeWidth,
          size.width - strokeWidth * 2,
          size.height - strokeWidth * 2,
        ),
        const Radius.circular(12.0),
      ),
      Paint()..color = indicatorColor.withValues(alpha: .8),
    );
    canvas.saveLayer(
      Rect.fromLTWH(-10, -10, size.width + 20, size.height + 20),
      Paint(),
    );
    canvas.drawArc(
      Rect.fromLTWH(-10, -10, size.width + 20, size.height + 20),
      -1.570796,
      6.283185 * (1 - progress) * -1,
      true,
      Paint()..color = backgroundColor,
    );
    canvas.drawDRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-10, -10, size.width + 20, size.height + 20),
        const Radius.circular(0.0),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16.0),
      ),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MiniplayerProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class ExSeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const ExSeekBar({
    super.key,
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<ExSeekBar> createState() => _ExSeekBarState();
}

class _ExSeekBarState extends State<ExSeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final value = _dragValue ?? widget.position.inSeconds.toDouble();

    return Column(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inSeconds.toDouble(),
          value: value.clamp(0.0, widget.duration.inSeconds.toDouble()),
          onChanged: (newValue) {
            setState(() {
              _dragValue = newValue;
            });
            widget.onChanged?.call(Duration(seconds: newValue.toInt()));
          },
          onChangeEnd: (newValue) {
            setState(() {
              _dragValue = null;
            });
            widget.onChangeEnd?.call(Duration(seconds: newValue.toInt()));
          },
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}

class OverlayControls extends StatefulWidget {
  const OverlayControls({super.key});

  @override
  State<OverlayControls> createState() => _OverlayControlsState();
}

class _OverlayControlsState extends State<OverlayControls> {
  bool show = false;
  Timer? _hideTimer;

  void _toggleOverlay() {
    setState(() {
      show = !show;
    });

    if (show) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          color: Colors.black.withValues(alpha: .2),
          height: 400,
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // back 10 secs function
                    },
                    icon: Icon(Icons.replay_10_rounded),
                    iconSize: 50,
                  ),
                  IconButton(
                    onPressed: () {
                      // forward 10 secs function
                    },
                    icon: Icon(Icons.forward_10_rounded),
                    iconSize: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
