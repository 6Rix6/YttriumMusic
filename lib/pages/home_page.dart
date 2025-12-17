import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yttrium_music/common/controllers/audio_player_controller.dart';
import 'package:yttrium_music/common/services/youtube_service.dart';
import 'package:yttrium_music/common/consts/dummies.dart';
import 'package:yttrium_music/common/widgets/section_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  final List<yt.Section> _sections = [];
  // ignore: unused_field
  List<yt.ChipCloudChipRenderer> _chips = [];
  yt.Thumbnails? _background;
  yt.Continuations? _continuations;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  final youtubeController = Get.find<YoutubeService>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchHomeFeed();
  }

  Future<void> _fetchHomeFeed({yt.Continuations? continuation}) async {
    final result = await youtubeController.youtube.home(
      continuation: continuation,
    );
    result.when(
      success: (value) {
        setState(() {
          _sections.addAll(value.sections);
          if (value.header?.chips != null) {
            _chips = value.header!.chips!;
          }
          if (value.background != null && _background == null) {
            _background = value.background;
          }
          _continuations = value.continuations?.firstOrNull;
        });
      },
      error: (error) {},
    );
    setState(() {
      _isLoading = false;
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    _handleOpacity();
    _loadMore();
  }

  void _handleOpacity() {
    double offset = _scrollController.offset;
    double opacity = 0.0;

    if (offset < 100) {
      opacity = 0.0;
    } else if (offset > 300) {
      opacity = 1.0;
    } else {
      opacity = (offset - 100) / 200;
    }

    if (_appBarOpacity != opacity) {
      setState(() {
        _appBarOpacity = opacity;
      });
    }
  }

  void _loadMore() {
    double offset = _scrollController.offset;

    if (offset >= _scrollController.position.maxScrollExtent - 500) {
      if (_continuations != null && !_isLoading && !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        _fetchHomeFeed(continuation: _continuations);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerController = Get.find<AudioPlayerController>();
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height + 100),
            Obx(
              () => Skeletonizer(
                enabled: _isLoading,
                containersColor: Colors.grey.shade800,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: audioPlayerController.hasTrack
                        ? kBottomNavigationBarHeight + 100
                        : kBottomNavigationBarHeight + 16,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _isLoading ? 5 : _sections.length,
                  itemBuilder: (context, index) {
                    final section = _isLoading
                        ? dummySection
                        : _sections[index];
                    return SectionWidget(section: section);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderActionChip extends StatelessWidget {
  final yt.ChipCloudChipRenderer chip;
  const HeaderActionChip({super.key, required this.chip});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ActionChip(
        label: Text(chip.text.toString()),
        color: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: chip.isSelected ? 1 : 0.1),
        ),
        labelStyle: TextStyle(
          // color: chip.isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
