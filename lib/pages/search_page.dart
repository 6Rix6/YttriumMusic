import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innertube_dart/innertube_dart.dart';
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/common/widgets/yt_item_widget.dart';
import 'package:yttrium_music/i18n/translations.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _search() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final shouldClear =
          await context.push('/search/${Uri.encodeComponent(query)}') as bool?;
      if (shouldClear == true) {
        _searchController.clear();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: t.search.hint,
              isDense: true,
              prefixIcon: Icon(CupertinoIcons.search, size: 20),
              border: InputBorder.none,
              suffixIcon: null,
            ),
            onSubmitted: (_) => _search(),
          ),
        ),
      ),
      body: Center(child: Text("suggestions")),
    );
  }
}

class SearchResultPage extends StatefulWidget {
  final String query;
  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final YoutubeService _youtubeService = Get.find<YoutubeService>();
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayerController _playerController =
      Get.find<AudioPlayerController>();
  SearchResult? _searchResult;
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
      final result = await _youtubeService.youtube.search(
        query,
        SearchFilter.all,
      );
      result.when(
        success: (value) {
          setState(() {
            _searchResult = value;
            for (var song in value.items) {
              print(song);
            }
          });
        },
        error: (error) {
          Get.snackbar("Error", error.toString());
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).colorScheme.surfaceContainer,
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
                hintText: t.search.hint,
                isDense: true,
                prefixIcon: Icon(CupertinoIcons.search, size: 20),
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
                  () => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchResult?.items.length ?? 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16).add(
                      EdgeInsets.only(
                        bottom:
                            kBottomNavigationBarHeight +
                            _playerController.playerHeight,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final item = _searchResult?.items[index];
                      if (item is SongItem) {
                        return ResponsiveListItemWidget(item: item);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
