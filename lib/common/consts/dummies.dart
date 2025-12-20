import 'package:innertube_dart/innertube_dart.dart';

const dummyArtist = Artist(name: "Dummy Artist");
const dummyRuns = Runs(runs: [Run(text: "Dummy Text")]);
const dummyThumbnails = Thumbnails(
  thumbnails: [Thumbnail(url: "", width: 600, height: 400)],
);
const dummySong = SongItem(
  id: "dummy_id",
  title: "Dummy Song",
  artists: [dummyArtist],
  subtitle: dummyRuns,
  thumbnails: dummyThumbnails,
  viewCount: "100 views",
);

const dummyVideo = SongItem(
  id: "dummy_id",
  title: "Dummy Song",
  artists: [dummyArtist],
  subtitle: dummyRuns,
  thumbnails: dummyThumbnails,
  viewCount: "100 views",
  isVideo: true,
);

const dummyAlbum = AlbumItem(
  browseId: "dummy_id",
  playlistId: "dummy_id",
  title: "Dummy Album",
  artists: [dummyArtist],
  subtitle: dummyRuns,
  thumbnails: dummyThumbnails,
);

final dummySection = Section(
  itemType: SectionItemType.musicTwoRowItem,
  type: SectionType.musicCarouselShelf,
  contents: List.filled(5, dummySong),
  title: "Dummy Section",
  header: SectionHeader(title: "Dummy Header"),
);
