import 'package:flutter/material.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/common/widgets/button_widgets.dart';
import 'package:yttrium_music/common/widgets/carousel_widget.dart';

class SectionWidget extends StatelessWidget {
  final yt.Section section;
  const SectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.contents == null || section.contents!.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 16,
                      children: [
                        if (section.header?.thumbnail != null)
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  section.header!.thumbnail!.url,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (section.header?.strapline != null)
                                Text(
                                  section.header!.strapline!,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              Text(
                                section.title ?? "",
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (section.header?.moreButton != null)
                    MoreButtonWidget(moreButton: section.header!.moreButton!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // content
          if (section.itemType == yt.SectionItemType.musicTwoRowItem)
            TwoRowItemCarouselWidget(section: section)
          else if (section.itemType ==
              yt.SectionItemType.musicResponsiveListItem)
            ResponsiveLisItemCarouselWidget(section: section),
        ],
      ),
    );
  }
}
