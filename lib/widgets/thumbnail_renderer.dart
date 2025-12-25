import 'package:flutter/material.dart';
import 'package:innertube_dart/innertube_dart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ThumbnailRenderer extends StatelessWidget {
  final Thumbnails thumbnails;
  final double width;
  final double height;
  const ThumbnailRenderer({
    super.key,
    required this.thumbnails,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final url = thumbnails.getBest()?.url;
    return Skeleton.replace(
      width: width,
      height: height,
      child: url != null
          ? Image.network(url, width: width, height: height, fit: BoxFit.cover)
          : Container(width: width, height: height, color: Colors.grey),
    );
  }
}
