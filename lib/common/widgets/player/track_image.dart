import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:yttrium_music/common/utils/player_ui_utils.dart';

class TrackImage extends StatelessWidget {
  const TrackImage({
    super.key,
    required this.image,
    required this.bottomOffset,
    required this.maxOffset,
    required this.screenSize,
    required this.cp,
    required this.p,
    this.width = 82.0,
    this.horizontalPadding = 16.0,
    this.bytes,
    this.large = false,
  });

  final Widget image;
  final bool large;

  final double width;
  final double horizontalPadding;

  final double bottomOffset;
  final double maxOffset;
  final Size screenSize;
  final double cp;
  final double p;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    final radius = rangeProgress(a: 14.0, b: 32.0, c: cp);
    final borderRadius = SmoothBorderRadius(
      cornerRadius: radius,
      cornerSmoothing: 1.0,
    );
    final size = rangeProgress(
      a: width,
      b: screenSize.width - horizontalPadding * 2,
      c: cp,
    );

    return Transform.translate(
      offset: Offset(0, bottomOffset + (-maxOffset / 2.15 * p.clamp(0, 2))),
      child: Padding(
        padding: EdgeInsets.all(
          12.0 * (1 - cp),
        ).add(EdgeInsets.only(left: horizontalPadding * cp)),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: size,
            width: size,
            child: Padding(
              padding: EdgeInsets.all(12.0 * (1 - cp)),
              child: PageTransitionSwitcher(
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) {
                      return FadeThroughTransition(
                        fillColor: Colors.transparent,
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                child: Container(
                  key: const Key("imgcontainer"),
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(borderRadius: borderRadius),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .25 * cp),
                        blurRadius: 24.0,
                        offset: const Offset(0.0, 4.0),
                      ),
                    ],
                  ),
                  child: ClipRRect(borderRadius: borderRadius, child: image),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
