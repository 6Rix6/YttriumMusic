import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innertube_dart/innertube_dart.dart';
// import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/common/widgets/navigation_button.dart';
import 'package:yttrium_music/common/widgets/yt_item_widget.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _search(String query) async {
    if (query.isNotEmpty) {
      final shouldClear =
          await context.push('/search/${Uri.encodeComponent(query)}') as bool?;
      if (shouldClear == true) {
        _searchController.clear();
      }
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Center(
          child: IconButton(
            icon: const Icon(CupertinoIcons.chevron_back),
            onPressed: () => context.pop(),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.globe), onPressed: () {}),
        ],
        centerTitle: true,
        titleSpacing: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: t.search.hint,
              isDense: true,
              border: InputBorder.none,
              suffixIcon: IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                icon: Icon(CupertinoIcons.xmark),
                onPressed: () {
                  _searchController.clear();
                  _focusNode.requestFocus();
                },
              ),
            ),
            onSubmitted: (_) => _search(_searchController.text),
          ),
        ),
      ),
      body: Center(child: Text("suggestions")),
    );
  }
}

class SearchResultPage extends StatefulWidget {
  final String query;
  final SearchFilter filter;
  const SearchResultPage({
    super.key,
    required this.query,
    this.filter = SearchFilter.all,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final YoutubeService _youtubeService = Get.find<YoutubeService>();
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayerController _playerController =
      Get.find<AudioPlayerController>();
  // yt.SearchPage? _searchResult;
  MusicCardShelfSection? _musicCardShelfSection;
  MusicShelfSection? _musicShelfSection;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _search();
  }

  Future<void> _search() async {
    final query = widget.query;
    if (query.isNotEmpty) {
      final result = await _youtubeService.youtube.search(query, widget.filter);
      result.when(
        success: (value) {
          setState(() {
            // _searchResult = value;
            if (value.tabs.firstOrNull case final tab?) {
              _musicCardShelfSection = tab.contents
                  .whereType<MusicCardShelfSection>()
                  .firstOrNull;
              _musicShelfSection = tab.contents
                  .whereType<MusicShelfSection>()
                  .firstOrNull;
            }
          });
        },
        error: (error) {
          Get.snackbar(t.general.error, error.toString());
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.chevron_back),
            onPressed: () => context.pop(false),
          ),
          centerTitle: true,
          titleSpacing: 0,
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onTap: () => context.pop(false),
              onTapAlwaysCalled: true,
              readOnly: true,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: t.search.hint,
                isDense: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: Icon(CupertinoIcons.xmark),
                  onPressed: () => context.pop(true),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.globe),
              onPressed: () => context.pop(false),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      // MusicCardShelf Card
                      if (_musicCardShelfSection != null)
                        MusicCardShelfWidget(section: _musicCardShelfSection!),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _musicShelfSection?.contents?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16).add(
                          EdgeInsets.only(
                            bottom: _playerController.playerHeight,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final item = _musicShelfSection?.contents?[index];
                          if (item is SongItem) {
                            return ResponsiveListItemWidget(item: item);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class MusicCardShelfWidget extends StatelessWidget {
  final MusicCardShelfSection section;

  const MusicCardShelfWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasContent = section.contents?.isNotEmpty ?? false;
    final hasContentTitle = section.contentTitle != null;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // card header
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
                bottom: hasContent ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              section.thumbnails?.getBest()?.url ?? "",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title ?? "",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              section.subtitle?.toString() ?? "",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (section.buttons != null && section.buttons!.isNotEmpty)
                    Row(
                      spacing: 12,
                      children: section.buttons!
                          .map(
                            (e) => Expanded(
                              child: NavigationButton(
                                endpoint: e.command!,
                                isDisabled: e.isDisabled ?? false,
                                text: e.text.toString(),
                                iconString: e.icon?.iconType,
                                primary: e.style == "STYLE_DARK_ON_WHITE",
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          // card content
          if (hasContent)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasContentTitle)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ).add(const EdgeInsets.only(top: 4)),
                      child: Text(
                        section.contentTitle!,
                        style: TextStyle(color: theme.hintColor),
                      ),
                    ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: section.contents?.length ?? 0,
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 4,
                      top: hasContentTitle ? 0 : 4,
                    ),
                    itemBuilder: (context, index) {
                      final item = section.contents?[index];
                      if (item is SongItem) {
                        return ResponsiveListItemWidget(item: item);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
