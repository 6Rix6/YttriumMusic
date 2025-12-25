import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/core/services/youtube_service.dart';
import 'package:yttrium_music/widgets/renderers/thumbnail_renderer.dart';

const double kImageHeight = 160;

class TowRowItemWidget extends StatelessWidget {
  final yt.YTItem item;
  const TowRowItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item is yt.SongItem) {
      return _SongItemWidget(item: item as yt.SongItem);
    } else if (item is yt.AlbumItem) {
      return _AlbumItemWidget(item: item as yt.AlbumItem);
    } else if (item is yt.PlaylistItem) {
      return _PlaylistItemWidget(item: item as yt.PlaylistItem);
    } else if (item is yt.ArtistItem) {
      return _ArtistItemWidget(item: item as yt.ArtistItem);
    }
    return const SizedBox.shrink();
  }
}

class _SongItemWidget extends StatelessWidget {
  final yt.SongItem item;
  const _SongItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final aspectRatio = item.isVideo ? 16 / 9 : 1;
    return GestureDetector(
      onTap: () =>
          Get.find<YoutubeService>().playSong(item.id, fallbackSong: item),
      child: SizedBox(
        width: aspectRatio * kImageHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Container(
              height: kImageHeight,
              width: aspectRatio * kImageHeight,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: ThumbnailRenderer(
                thumbnails: item.thumbnails!,
                width: aspectRatio * kImageHeight,
                height: kImageHeight,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  item.subtitle.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumItemWidget extends StatelessWidget {
  final yt.AlbumItem item;
  const _AlbumItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Get.to(() => AlbumPage(browseId: item.browseId)),
      onTap: () => context.push('/album'),
      child: SizedBox(
        width: kImageHeight,
        height: kImageHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Container(
              height: kImageHeight,
              width: kImageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item.thumbnails.getBest()?.url ?? ""),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),

                Text(
                  item.subtitle.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistItemWidget extends StatelessWidget {
  final yt.PlaylistItem item;
  const _PlaylistItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kImageHeight,
      height: kImageHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            height: kImageHeight,
            width: kImageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(item.thumbnails?.getBest()?.url ?? ""),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),

              Text(
                item.subtitle.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArtistItemWidget extends StatelessWidget {
  final yt.ArtistItem item;
  const _ArtistItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kImageHeight,
      height: kImageHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            height: kImageHeight,
            width: kImageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kImageHeight / 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(item.thumbnails?.getBest()?.url ?? ""),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),

                Text(
                  item.subtitle.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
