import 'package:flutter/material.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/widgets/renderers/yt_item_widget.dart';

class TwoRowItemCarouselWidget extends StatelessWidget {
  final yt.Section section;
  const TwoRowItemCarouselWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        scrollDirection: Axis.horizontal,
        itemCount: section.contents!.length,
        itemBuilder: (context, index) {
          final item = section.contents![index];
          return TowRowItemWidget(item: item);
        },
      ),
    );
  }
}

class ResponsiveLisItemCarouselWidget extends StatefulWidget {
  final yt.Section section;
  const ResponsiveLisItemCarouselWidget({super.key, required this.section});

  @override
  State<ResponsiveLisItemCarouselWidget> createState() =>
      _ResponsiveLisItemCarouselWidgetState();
}

class _ResponsiveLisItemCarouselWidgetState
    extends State<ResponsiveLisItemCarouselWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 312,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: ((widget.section.contents?.length ?? 0) / 4).ceil(),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 8,
              children: [
                for (int i = 0; i < 4; i++)
                  if ((index * 4 + i) < (widget.section.contents?.length ?? 0))
                    ResponsiveListItemWidget(
                      item:
                          widget.section.contents![index * 4 + i]
                              as yt.SongItem,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
